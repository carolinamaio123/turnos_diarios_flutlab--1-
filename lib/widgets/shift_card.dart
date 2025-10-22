
import 'package:flutter/material.dart';
import '../models/shift.dart';

class ShiftCard extends StatelessWidget {
  final Shift shift;
  const ShiftCard({super.key, required this.shift});

  String get initials {
    final parts = shift.name.trim().split(' ');
    if (parts.isEmpty) return '';
    // return first and last initial only when possible
    if (parts.length == 1) return parts[0][0].toUpperCase();
    return '${parts.first[0].toUpperCase()}${parts.last[0].toUpperCase()}';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: shift.color,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 3, offset: Offset(0, 1))],
      ),
      child: Center(
        child: Text(
          initials,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
