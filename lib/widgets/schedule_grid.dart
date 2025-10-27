import 'dart:async';
import 'package:flutter/material.dart';
import '../../models/shift.dart';
import '../../utils/time_utils.dart';
import 'shift_avatar.dart';
import 'current_time_indicator.dart';

// --- Classes auxiliares para grid dinâmica ---
class GridLineStyle {
  final double width;
  final Color color;
  const GridLineStyle({required this.width, required this.color});
}

class GridLineRule {
  final bool Function(int minutes) condition;
  final GridLineStyle style;
  const GridLineRule({required this.condition, required this.style});
}

// --- Widget principal ---
class ScheduleGrid extends StatefulWidget {
  final List<Shift> shifts;
  const ScheduleGrid({super.key, required this.shifts});

  @override
  State<ScheduleGrid> createState() => _ScheduleGridState();
}

class _ScheduleGridState extends State<ScheduleGrid> {
  late Timer _timer;
  late TimeOfDay _now;

  @override
  void initState() {
    super.initState();
    _now = TimeOfDay.now();

    // Atualiza a linha da hora atual a cada minuto
    _timer = Timer.periodic(const Duration(minutes: 1), (_) {
      setState(() {
        _now = TimeOfDay.now();
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final totalQuarters = (TimeUtils.endHour - TimeUtils.startHour) * 4;
    final contentHeight = totalQuarters * TimeUtils.quarterHeight;

    return LayoutBuilder(
      builder: (context, constraints) {
        final availableWidth = constraints.maxWidth.isFinite && constraints.maxWidth > 0
            ? constraints.maxWidth
            : MediaQuery.of(context).size.width;
        const columnCount = 6;
        final columnWidth = (availableWidth - 8) / columnCount;

        return SizedBox(
          height: contentHeight,
          child: Stack(
            children: [
              _buildGridLines(totalQuarters),
              for (final shift in widget.shifts)
                ShiftAvatar(shift: shift, columnWidth: columnWidth),
              CurrentTimeIndicator(now: _now),
            ],
          ),
        );
      },
    );
  }

  // --- Grid dinâmica ---
  Widget _buildGridLines(int totalQuarters) {
    const quarterLine = GridLineStyle(width: 0.5, color: Colors.grey.shade400);
    const halfHourLine = GridLineStyle(width: 1.0, color: Colors.grey.shade600);
    const hourLine = GridLineStyle(width: 2.0, color: Colors.grey.shade800);

    final currentMinutes = _now.hour * 60 + _now.minute;

    return Column(
      children: List.generate(totalQuarters, (i) {
        final minutes = i * 15;

        // Estilo base
        GridLineStyle style;
        if (minutes % 60 == 0) {
          style = hourLine;
        } else if (minutes % 30 == 0) {
          style = halfHourLine;
        } else {
          style = quarterLine;
        }

        // Regras dinâmicas (hora atual, feriados, eventos especiais)
        final rules = [
          GridLineRule(
            condition: (m) => m == (currentMinutes - currentMinutes % 15),
            style: GridLineStyle(width: style.width, color: Colors.redAccent),
          ),
          // Adiciona mais regras aqui se precisares
        ];

        for (final rule in rules) {
          if (rule.condition(minutes)) {
            style = rule.style;
            break;
          }
        }

        return Container(
          height: TimeUtils.quarterHeight,
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(color: style.color, width: style.width),
            ),
          ),
        );
      }),
    );
  }
}
