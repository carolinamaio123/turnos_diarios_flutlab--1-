// ...existing code...
import 'package:flutter/material.dart';
import '../models/shift.dart';
import '../utils/time_utils.dart';
import 'shift_card.dart';
import 'person_details_page.dart';

class ScheduleGrid extends StatefulWidget {
  final List<Shift> shifts;
  const ScheduleGrid({super.key, required this.shifts});

  @override
  State<ScheduleGrid> createState() => _ScheduleGridState();
}

class _ScheduleGridState extends State<ScheduleGrid> {
  @override
  Widget build(BuildContext context) {
    final totalQuarters = (TimeUtils.endHour - TimeUtils.startHour) * 4;
    final contentHeight = totalQuarters * TimeUtils.quarterHeight;

    // usa LayoutBuilder para respeitar a largura passada pelo parent (SizedBox)
    return LayoutBuilder(
      builder: (context, constraints) {
        final availableWidth = constraints.maxWidth.isFinite && constraints.maxWidth > 0
            ? constraints.maxWidth
            : MediaQuery.of(context).size.width;
        final columnCount = 6;
        final columnWidth = (availableWidth - 8) / columnCount;

        return SizedBox(
          height: contentHeight,
          child: Stack(
            children: [
              // linhas do grid
              Column(
                children: List.generate(
                  totalQuarters,
                  (i) => Container(
                    height: TimeUtils.quarterHeight,
                    decoration: BoxDecoration(
                      border: Border(
                        top: BorderSide(
                          color: ((i * 15) % 60) == 30
                              ? Colors.grey.shade600
                              : Colors.grey.shade300,
                          width: ((i * 15) % 60) == 30 ? 1.2 : 0.6,
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              // turnos (posicionados pelo tempo)
              for (final shift in widget.shifts) _buildShiftWithAvatar(shift, columnWidth),

              // indicador de tempo atual
              _buildCurrentTimeIndicator(),
            ],
          ),
        );
      },
    );
  }

  Widget _buildShiftWithAvatar(Shift shift, double columnWidth) {
    final shiftHeight = TimeUtils.durationToHeight(shift.start, shift.end);
    final shiftTop = TimeUtils.timeToOffset(shift.start);
    final avatarSize = (columnWidth - 12) * 0.5;
    final avatarTop = 8.0;

    return Stack(
      children: [
        Positioned(
          left: shift.column * columnWidth + 6,
          top: shiftTop,
          width: columnWidth - 12,
          height: shiftHeight,
          child: ShiftCard(shift: shift),
        ),

        Positioned(
          left: shift.column * columnWidth + 6 + ((columnWidth - 12 - avatarSize) / 2),
          top: shiftTop + avatarTop,
          child: GestureDetector(
            onTap: () => _showInfoPopup(context, shift),
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              child: CircleAvatar(
                radius: avatarSize / 2,
                backgroundColor: Colors.white,
                child: CircleAvatar(
                  radius: (avatarSize / 2) - 2,
                  backgroundColor: shift.color,
                  child: Text(
                    _getInitials(shift.name),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: (avatarSize / 2) * 0.8,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
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
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
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
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PersonDetailsPage(shift: shift),
                      ),
                    );
                  },
                  icon: const Icon(Icons.info_outline, size: 20),
                  label: const Text('Ver informações completas'),
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
              child: const Text('Fechar', style: TextStyle(color: Colors.grey)),
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
// ...existing code...
