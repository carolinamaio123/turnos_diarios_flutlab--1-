import 'package:flutter/material.dart';
import '../utils/time_utils.dart';

class TimeColumn extends StatelessWidget {
  const TimeColumn({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 60,
      color: Colors.grey.shade100,
      child: ListView.builder(
        itemCount: (TimeUtils.endHour - TimeUtils.startHour) * 4,
        itemBuilder: (context, index) {
          final totalMinutes = index * 15;
          final hour = totalMinutes ~/ 60;
          final minute = totalMinutes % 60;
          final isHour = minute == 0;
          final isHalf = minute == 30;

          return Container(
            height: TimeUtils.quarterHeight,
            alignment: Alignment.topCenter,
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: isHalf ? Colors.grey.shade600 : Colors.grey.shade300,
                  width: isHalf ? 1.2 : 0.6,
                ),
              ),
            ),
            child: isHour
                ? Padding(
                    padding: const EdgeInsets.only(top: 2.0),
                    child: Text('${hour.toString().padLeft(2, '0')}h',
                        style: TextStyle(fontSize: 11, color: Colors.grey.shade700)),
                  )
                : null,
          );
        },
      ),
    );
  }
}
