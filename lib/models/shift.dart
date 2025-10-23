import 'package:flutter/material.dart';
import 'break_period.dart';
import 'category.dart';

class Shift {
  final String name;
  final TimeOfDay start;
  final TimeOfDay end;
  final int column;
  final CategoryId category;
  final List<BreakPeriod> breaks;

  const Shift({
    required this.name,
    required this.start,
    required this.end,
    required this.column,
    required this.category,
    this.breaks = const [],
  });

  // GETTER para a cor baseada na categoria
  Color get color => categories[category]!.color;

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
        'category': category.name,
        'breaks': breaks.map((b) => b.toJson()).toList(),
      };
}
