import 'package:flutter/material.dart';
import 'break_period.dart';

class Shift {
  final String name;
  late TimeOfDay start;
  late TimeOfDay end;
  final int column;
  final Color color;
  final List<BreakPeriod> breaks;

  Shift({
    required this.name,
    required this.start,
    required this.end,
    required this.column,
    required this.color,
    this.breaks = const [],
  });

  Duration get netDuration {
    final total = Duration(
      minutes: (end.hour * 60 + end.minute) - (start.hour * 60 + start.minute),
    );
    final breaksTotal =
        breaks.fold<Duration>(Duration.zero, (sum, b) => sum + b.duration);
    return total - breaksTotal;
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'start': {'h': start.hour, 'm': start.minute},
        'end': {'h': end.hour, 'm': end.minute},
        'column': column,
        'color': color.toARGB32(),
        'breaks': breaks.map((b) => b.toJson()).toList(),
      };
}
