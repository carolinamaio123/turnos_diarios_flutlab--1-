import 'package:flutter/material.dart';
import '../models/shift.dart';
import '../utils/time_utils.dart';
import 'shift_card.dart';

class ScheduleGrid extends StatelessWidget {
  final List<Shift> shifts;
  const ScheduleGrid({super.key, required this.shifts});

  @override
  Widget build(BuildContext context) {
    final totalQuarters = (TimeUtils.endHour - TimeUtils.startHour) * 4;
    final contentHeight = totalQuarters * TimeUtils.quarterHeight;

    return LayoutBuilder(builder: (context, constraints) {
      final columnCount = 6;
      final columnWidth = (constraints.maxWidth - 8) / columnCount;

      return SingleChildScrollView(
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
              for (final s in shifts) ...[
                Positioned(
                  left: s.column * columnWidth + 6,
                  top: TimeUtils.timeToOffset(s.start),
                  width: columnWidth - 12,
                  height: TimeUtils.durationToHeight(s.start, s.end),
                  child: Stack(
                    children: [
                      Positioned.fill(child: ShiftCard(shift: s)),
                      for (final b in s.breaks)
                        Positioned(
                          top: TimeUtils.timeToOffset(b.start) -
                              TimeUtils.timeToOffset(s.start),
                          left: 4,
                          right: 4,
                          height: TimeUtils.durationToHeight(b.start, b.end),
                          child: Container(
                            decoration: BoxDecoration(
                              color:
                                  Colors.grey.shade200.withValues(alpha: 0.9),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              b.label ?? 'Break',
                              style: TextStyle(
                                color: Colors.grey.shade800,
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
              Builder(builder: (context) {
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
                          child: const Text('Agora',
                              style: TextStyle(
                                  color: Colors.redAccent,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 10))),
                      Expanded(
                          child:
                              Container(height: 1.2, color: Colors.redAccent)),
                      Padding(
                        // Move o Container 5 pixels para a esquerda
                        padding: const EdgeInsets.only(left: 10),
                        child: Container(
                          width: 10,
                          height: 10,
                          // REMOVE A MARGEM: margin: const EdgeInsets.only(left: -5),
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.redAccent,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ],
          ),
        ),
      );
    });
  }
}
