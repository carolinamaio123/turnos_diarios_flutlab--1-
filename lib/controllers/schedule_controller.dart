import 'package:flutter/material.dart';
import '../models/shift.dart';
import '../models/break_period.dart';
import '../utils/time_utils.dart'; // <-- IMPORT NECESSÁRIO

class ScheduleController {
  List<Shift> loadShifts() {
    final breakPeriod = BreakPeriod(
        start: TimeOfDay(hour: 12, minute: 30),
        end: TimeOfDay(hour: 13, minute: 0),
        label: 'Lunch');
    final shifts = [
      Shift(
        name: 'Neuza Silva',
        start: const TimeOfDay(hour: 3, minute: 45),
        end: const TimeOfDay(hour: 12, minute: 0),
        column: 0,
        color: Color(0x8a8e4848),
        breaks: [
          BreakPeriod(
            start: const TimeOfDay(hour: 8, minute: 0),
            end: const TimeOfDay(hour: 8, minute: 30),
            label: 'Coffee Break',
          ),
        ],
      ),
      Shift(
        name: 'John Doe',
        start: const TimeOfDay(hour: 9, minute: 0),
        end: const TimeOfDay(hour: 17, minute: 0),
        column: 1,
        color: Colors.blue,
        breaks: [
          breakPeriod,
        ],
      ),
      Shift(
        name: 'Jane Smith',
        start: const TimeOfDay(hour: 10, minute: 30),
        end: const TimeOfDay(hour: 18, minute: 0),
        column: 2,
        color: Colors.teal,
      ),
      // ... outros turnos
    ];

    // 🔒 Corrigir horários fora do intervalo
    for (var shift in shifts) {
      shift.start = TimeUtils.clamp(shift.start);
      shift.end = TimeUtils.clamp(shift.end);
      for (final b in shift.breaks) {
        b.start = TimeUtils.clamp(b.start);
        b.end = TimeUtils.clamp(b.end);
      }
    }

    return shifts; // ✅ Corrigido (sem chaves)
  }
}
