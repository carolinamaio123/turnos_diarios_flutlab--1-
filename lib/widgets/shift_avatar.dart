import 'package:flutter/material.dart';
import '../../models/shift.dart';
import '../../utils/time_utils.dart';
import 'shift_popup.dart';
import '../shift_card.dart';

class ShiftAvatar extends StatelessWidget {
  final Shift shift;
  final double columnWidth;

  const ShiftAvatar({super.key, required this.shift, required this.columnWidth});

  @override
  Widget build(BuildContext context) {
    final shiftHeight = TimeUtils.durationToHeight(shift.start, shift.end);
    final shiftTop = TimeUtils.timeToOffset(shift.start);
    final avatarSize = (columnWidth - 12) * 0.5;

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
          top: shiftTop + 8.0,
          child: GestureDetector(
            onTap: () => showShiftPopup(context, shift),
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
      ],
    );
  }

  String _getInitials(String name) {
    final parts = name.trim().split(' ');
    if (parts.isEmpty) return '';
    if (parts.length == 1) return parts[0][0].toUpperCase();
    return '${parts.first[0].toUpperCase()}${parts.last[0].toUpperCase()}';
  }
}
