import 'package:flutter/material.dart';

class BreakPeriod {
  late TimeOfDay start;
  late TimeOfDay end;
  final String? label;

  BreakPeriod({
    required this.start,
    required this.end,
    this.label,
  });

  Duration get duration {
    final startMinutes = start.hour * 60 + start.minute;
    final endMinutes = end.hour * 60 + end.minute;
    return Duration(minutes: endMinutes - startMinutes);
  }

  Map<String, dynamic> toJson() => {
        'start': {'h': start.hour, 'm': start.minute},
        'end': {'h': end.hour, 'm': end.minute},
        'label': label,
      };
}
