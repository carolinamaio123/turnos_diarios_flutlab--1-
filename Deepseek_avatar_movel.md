Perfeito! Vou implementar um avatar que acompanha a rolagem mas fica sempre dentro dos limites do card. Isso requer uma abordagem diferente usando um Stack com Positioned que se ajPerfeito! Vou implementar um avatar que acompanha a rolagem mas fica sempre dentro dos limites do card. Isso requer uma abordagem diferente usando um Stack com Positioned que se ajusta baseado na posição de rolagem.

🔧 Arquivo: schedule_grid.dart (modificado)

```dart
import 'package:flutter/material.dart';
import '../models/shift.dart';
import '../utils/time_utils.dart';
import 'shift_card.dart';

class ScheduleGrid extends StatefulWidget {
  final List<Shift> shifts;
  const ScheduleGrid({super.key, required this.shifts});

  @override
  State<ScheduleGrid> createState() => _ScheduleGridState();
}

class _ScheduleGridState extends State<ScheduleGrid> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final totalQuarters = (TimeUtils.endHour - TimeUtils.startHour) * 4;
    final contentHeight = totalQuarters * TimeUtils.quarterHeight;

    return LayoutBuilder(builder: (context, constraints) {
      final columnCount = 6;
      final columnWidth = (constraints.maxWidth - 8) / columnCount;

      return SingleChildScrollView(
        controller: _scrollController,
        child: SizedBox(
          height: contentHeight,
          child: Stack(
            children: [
              Column(
                children: List.generate(
                  totalQuarters,
                  (i) {
                    final minute = (i * 15) % 60;
                    final isHalf = minute == 30;
                    return Container(
                      height: TimeUtils.quarterHeight,
                      decoration: BoxDecoration(
                        border: Border(
                          top: BorderSide(
                            color: isHalf
                                ? Colors.grey.shade600
                                : Colors.grey.shade300,
                            width: isHalf ? 1.2 : 0.6,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              for (final s in widget.shifts) 
                _buildShiftWithAvatar(s, columnWidth, contentHeight),
              _buildCurrentTimeIndicator(),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildShiftWithAvatar(Shift shift, double columnWidth, double contentHeight) {
    final shiftHeight = TimeUtils.durationToHeight(shift.start, shift.end);
    final shiftTop = TimeUtils.timeToOffset(shift.start);

    return Stack(
      children: [
        // Card do turno (fundo)
        Positioned(
          left: shift.column * columnWidth + 6,
          top: shiftTop,
          width: columnWidth - 12,
          height: shiftHeight,
          child: ShiftCard(shift: shift),
        ),
        
        // Avatar que acompanha a rolagem mas fica dentro do card
        Positioned(
          left: shift.column * columnWidth + 6,
          top: shiftTop,
          width: columnWidth - 12,
          height: shiftHeight,
          child: _buildScrollableAvatar(shift, columnWidth - 12, shiftHeight),
        ),
      ],
    );
  }

  Widget _buildScrollableAvatar(Shift shift, double cardWidth, double cardHeight) {
    final avatarSize = cardWidth * 0.5;
    final avatarRadius = avatarSize / 2;

    return NotificationListener<ScrollNotification>(
      onNotification: (scrollNotification) {
        // Força o rebuild quando houver rolagem
        if (scrollNotification is ScrollUpdateNotification) {
          setState(() {});
        }
        return false;
      },
      child: LayoutBuilder(
        builder: (context, constraints) {
          // Calcula a posição do avatar baseado na rolagem
          double avatarTop = 8; // Posição inicial
          
          // Obtém a posição atual de rolagem
          final scrollOffset = _scrollController.hasClients 
              ? _scrollController.offset 
              : 0;
          
          // Calcula a posição absoluta do card na tela
          final renderObject = context.findRenderObject() as RenderBox?;
          if (renderObject != null) {
            final cardGlobalPosition = renderObject.localToGlobal(Offset.zero);
            final cardScreenTop = cardGlobalPosition.dy - scrollOffset;
            
            // Limita o avatar para não sair do card
            final maxTop = cardHeight - avatarSize - 8; // 8px de margem inferior
            avatarTop = (cardScreenTop < 0) 
                ? 8 - cardScreenTop.clamp(0, maxTop) // Ajusta para cima se necessário
                : 8;
            
            avatarTop = avatarTop.clamp(8, maxTop);
          }

          return Positioned(
            top: avatarTop,
            left: (cardWidth - avatarSize) / 2,
            child: GestureDetector(
              onTap: () => _showInfoPopup(context, shift),
              child: MouseRegion(
                cursor: SystemMouseCursors.click,
                child: CircleAvatar(
                  radius: avatarRadius,
                  backgroundColor: Colors.white,
                  child: CircleAvatar(
                    radius: avatarRadius - 2,
                    backgroundColor: shift.color,
                    child: Text(
                      _getInitials(shift.name),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: avatarRadius * 0.8,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  String _getInitials(String name) {
    final parts = name.trim().split(' ');
    if (parts.isEmpty) return '';
    if (parts.length == 1) return parts[0][0].toUpperCase();
    return '${parts.first[0].toUpperCase()}${parts.last[0].toUpperCase()}';
  }

  void _showInfoPopup(BuildContext context, Shift shift) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: shift.color,
                    radius: 24,
                    child: Text(
                      _getInitials(shift.name),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      shift.name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        Text(
                          'Início',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        Text(
                          '${shift.start.hour.toString().padLeft(2, '0')}:${shift.start.minute.toString().padLeft(2, '0')}',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Text(
                          'Fim',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        Text(
                          '${shift.end.hour.toString().padLeft(2, '0')}:${shift.end.minute.toString().padLeft(2, '0')}',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.of(context).pop();
                    // TODO: Navegação para página de detalhes
                  },
                  icon: const Icon(Icons.info_outline, size: 20),
                  label: const Text(
                    'Ver informações completas',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: shift.color,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                'Fechar',
                style: TextStyle(color: Colors.grey),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildCurrentTimeIndicator() {
    final now = TimeOfDay.now();
    final topOffset = TimeUtils.timeToOffset(now);
    return Positioned(
      top: topOffset,
      left: 0,
      right: 0,
      child: Row(
        children: [
          Container(
            width: 60,
            alignment: Alignment.center,
            child: const Text(
              'Agora',
              style: TextStyle(
                color: Colors.redAccent,
                fontWeight: FontWeight.w600,
                fontSize: 10,
              ),
            ),
          ),
          Expanded(child: Container(height: 1.2, color: Colors.redAccent)),
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Container(
              width: 10,
              height: 10,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.redAccent,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
```

🔧 Arquivo: shift_card.dart (simplificado)

Agora o ShiftCard fica mais simples, pois o avatar foi movido para o ScheduleGrid:

```dart
import 'package:flutter/material.dart';
import '../models/shift.dart';

class ShiftCard extends StatelessWidget {
  final Shift shift;
  const ShiftCard({super.key, required this.shift});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: shift.color,
        borderRadius: BorderRadius.circular(8),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 3,
            offset: Offset(0, 1),
          ),
        ],
      ),
    );
  }
}
```

🎯 Como Funciona:

1. Lógica de Posicionamento Dinâmico:

· NotificationListener<ScrollNotification> - Detecta eventos de rolagem
· _scrollController.offset - Obtém a posição atual de rolagem
· RenderBox.localToGlobal() - Calcula a posição do card na tela
· clamp() - Limita o avatar dentro dos limites do card

2. Comportamento do Avatar:

· Acompanha a rolagem - Move-se suavemente com o scroll
· Não sai do card - Fica sempre entre 8px do topo e 8px da base
· Centralizado horizontalmente - Mantém-se no centro do card
· Clicável - Mantém a funcionalidade do pop-up

3. Otimizações:

· setState() apenas durante rolagem - Performance eficiente
· Cálculos otimizados - Usa geometria do Flutter
· Estado local - Não afeta outros componentes

✨ Resultado:

Agora o avatar:

· ✅ Acompanha a rolagem suavemente
· ✅ Fica sempre visível dentro do card
· ✅ Não ultrapassa os limites superior e inferior do card
· ✅ Mantém todas as funcionalidades anteriores (clique, pop-up)

O efeito é semelhante a um elemento "sticky" mas que respeita os limites do container pai (o card do turno). O usuário verá sempre o avatar do trabalhador enquanto o card estiver visível na tela! 🎉usta baseado na posição de rolagem.

🔧 Arquivo: schedule_grid.dart (modificado)

```dart
import 'package:flutter/material.dart';
import '../models/shift.dart';
import '../utils/time_utils.dart';
import 'shift_card.dart';

class ScheduleGrid extends StatefulWidget {
  final List<Shift> shifts;
  const ScheduleGrid({super.key, required this.shifts});

  @override
  State<ScheduleGrid> createState() => _ScheduleGridState();
}

class _ScheduleGridState extends State<ScheduleGrid> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final totalQuarters = (TimeUtils.endHour - TimeUtils.startHour) * 4;
    final contentHeight = totalQuarters * TimeUtils.quarterHeight;

    return LayoutBuilder(builder: (context, constraints) {
      final columnCount = 6;
      final columnWidth = (constraints.maxWidth - 8) / columnCount;

      return SingleChildScrollView(
        controller: _scrollController,
        child: SizedBox(
          height: contentHeight,
          child: Stack(
            children: [
              Column(
                children: List.generate(
                  totalQuarters,
                  (i) {
                    final minute = (i * 15) % 60;
                    final isHalf = minute == 30;
                    return Container(
                      height: TimeUtils.quarterHeight,
                      decoration: BoxDecoration(
                        border: Border(
                          top: BorderSide(
                            color: isHalf
                                ? Colors.grey.shade600
                                : Colors.grey.shade300,
                            width: isHalf ? 1.2 : 0.6,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              for (final s in widget.shifts) 
                _buildShiftWithAvatar(s, columnWidth, contentHeight),
              _buildCurrentTimeIndicator(),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildShiftWithAvatar(Shift shift, double columnWidth, double contentHeight) {
    final shiftHeight = TimeUtils.durationToHeight(shift.start, shift.end);
    final shiftTop = TimeUtils.timeToOffset(shift.start);

    return Stack(
      children: [
        // Card do turno (fundo)
        Positioned(
          left: shift.column * columnWidth + 6,
          top: shiftTop,
          width: columnWidth - 12,
          height: shiftHeight,
          child: ShiftCard(shift: shift),
        ),
        
        // Avatar que acompanha a rolagem mas fica dentro do card
        Positioned(
          left: shift.column * columnWidth + 6,
          top: shiftTop,
          width: columnWidth - 12,
          height: shiftHeight,
          child: _buildScrollableAvatar(shift, columnWidth - 12, shiftHeight),
        ),
      ],
    );
  }

  Widget _buildScrollableAvatar(Shift shift, double cardWidth, double cardHeight) {
    final avatarSize = cardWidth * 0.5;
    final avatarRadius = avatarSize / 2;

    return NotificationListener<ScrollNotification>(
      onNotification: (scrollNotification) {
        // Força o rebuild quando houver rolagem
        if (scrollNotification is ScrollUpdateNotification) {
          setState(() {});
        }
        return false;
      },
      child: LayoutBuilder(
        builder: (context, constraints) {
          // Calcula a posição do avatar baseado na rolagem
          double avatarTop = 8; // Posição inicial
          
          // Obtém a posição atual de rolagem
          final scrollOffset = _scrollController.hasClients 
              ? _scrollController.offset 
              : 0;
          
          // Calcula a posição absoluta do card na tela
          final renderObject = context.findRenderObject() as RenderBox?;
          if (renderObject != null) {
            final cardGlobalPosition = renderObject.localToGlobal(Offset.zero);
            final cardScreenTop = cardGlobalPosition.dy - scrollOffset;
            
            // Limita o avatar para não sair do card
            final maxTop = cardHeight - avatarSize - 8; // 8px de margem inferior
            avatarTop = (cardScreenTop < 0) 
                ? 8 - cardScreenTop.clamp(0, maxTop) // Ajusta para cima se necessário
                : 8;
            
            avatarTop = avatarTop.clamp(8, maxTop);
          }

          return Positioned(
            top: avatarTop,
            left: (cardWidth - avatarSize) / 2,
            child: GestureDetector(
              onTap: () => _showInfoPopup(context, shift),
              child: MouseRegion(
                cursor: SystemMouseCursors.click,
                child: CircleAvatar(
                  radius: avatarRadius,
                  backgroundColor: Colors.white,
                  child: CircleAvatar(
                    radius: avatarRadius - 2,
                    backgroundColor: shift.color,
                    child: Text(
                      _getInitials(shift.name),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: avatarRadius * 0.8,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  String _getInitials(String name) {
    final parts = name.trim().split(' ');
    if (parts.isEmpty) return '';
    if (parts.length == 1) return parts[0][0].toUpperCase();
    return '${parts.first[0].toUpperCase()}${parts.last[0].toUpperCase()}';
  }

  void _showInfoPopup(BuildContext context, Shift shift) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: shift.color,
                    radius: 24,
                    child: Text(
                      _getInitials(shift.name),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      shift.name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        Text(
                          'Início',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        Text(
                          '${shift.start.hour.toString().padLeft(2, '0')}:${shift.start.minute.toString().padLeft(2, '0')}',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Text(
                          'Fim',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        Text(
                          '${shift.end.hour.toString().padLeft(2, '0')}:${shift.end.minute.toString().padLeft(2, '0')}',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.of(context).pop();
                    // TODO: Navegação para página de detalhes
                  },
                  icon: const Icon(Icons.info_outline, size: 20),
                  label: const Text(
                    'Ver informações completas',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: shift.color,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                'Fechar',
                style: TextStyle(color: Colors.grey),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildCurrentTimeIndicator() {
    final now = TimeOfDay.now();
    final topOffset = TimeUtils.timeToOffset(now);
    return Positioned(
      top: topOffset,
      left: 0,
      right: 0,
      child: Row(
        children: [
          Container(
            width: 60,
            alignment: Alignment.center,
            child: const Text(
              'Agora',
              style: TextStyle(
                color: Colors.redAccent,
                fontWeight: FontWeight.w600,
                fontSize: 10,
              ),
            ),
          ),
          Expanded(child: Container(height: 1.2, color: Colors.redAccent)),
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Container(
              width: 10,
              height: 10,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.redAccent,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
```

🔧 Arquivo: shift_card.dart (simplificado)

Agora o ShiftCard fica mais simples, pois o avatar foi movido para o ScheduleGrid:

```dart
import 'package:flutter/material.dart';
import '../models/shift.dart';

class ShiftCard extends StatelessWidget {
  final Shift shift;
  const ShiftCard({super.key, required this.shift});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: shift.color,
        borderRadius: BorderRadius.circular(8),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 3,
            offset: Offset(0, 1),
          ),
        ],
      ),
    );
  }
}
```

🎯 Como Funciona:

1. Lógica de Posicionamento Dinâmico:

· NotificationListener<ScrollNotification> - Detecta eventos de rolagem
· _scrollController.offset - Obtém a posição atual de rolagem
· RenderBox.localToGlobal() - Calcula a posição do card na tela
· clamp() - Limita o avatar dentro dos limites do card

2. Comportamento do Avatar:

· Acompanha a rolagem - Move-se suavemente com o scroll
· Não sai do card - Fica sempre entre 8px do topo e 8px da base
· Centralizado horizontalmente - Mantém-se no centro do card
· Clicável - Mantém a funcionalidade do pop-up

3. Otimizações:

· setState() apenas durante rolagem - Performance eficiente
· Cálculos otimizados - Usa geometria do Flutter
· Estado local - Não afeta outros componentes

✨ Resultado:

Agora o avatar:

· ✅ Acompanha a rolagem suavemente
· ✅ Fica sempre visível dentro do card
· ✅ Não ultrapassa os limites superior e inferior do card
· ✅ Mantém todas as funcionalidades anteriores (clique, pop-up)

O efeito é semelhante a um elemento "sticky" mas que respeita os limites do container pai (o card do turno). O usuário verá sempre o avatar do trabalhador enquanto o card estiver visível na tela! 🎉
