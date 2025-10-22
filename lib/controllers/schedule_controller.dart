import 'package:flutter/material.dart';
import '../models/shift.dart';
import '../models/break_period.dart';
import '../models/category.dart';

class ScheduleController {
  List<Shift> loadShifts() {
    return [
      // 🔴 Chefia
      Shift(
        name: 'Ana Rocha',
        start: const TimeOfDay(hour: 8, minute: 0),
        end: const TimeOfDay(hour: 16, minute: 0),
        column: 0,
        category: CategoryId.chefia,
        breaks: const [
          BreakPeriod(
            start: TimeOfDay(hour: 12, minute: 30),
            end: TimeOfDay(hour: 13, minute: 0),
            label: 'Almoço',
          ),
        ],
      ),
      Shift(
        name: 'Carlos Mendes',
        start: const TimeOfDay(hour: 9, minute: 0),
        end: const TimeOfDay(hour: 17, minute: 0),
        column: 1,
        category: CategoryId.chefia,
        breaks: const [
          BreakPeriod(
            start: TimeOfDay(hour: 12, minute: 30),
            end: TimeOfDay(hour: 13, minute: 0),
            label: 'Almoço',
          ),
        ],
      ),

      // 🟠 Padeiro
      Shift(
        name: 'João Pereira',
        start: const TimeOfDay(hour: 5, minute: 30),
        end: const TimeOfDay(hour: 13, minute: 30),
        column: 2,
        category: CategoryId.padeiro,
        breaks: const [
          BreakPeriod(
            start: TimeOfDay(hour: 9, minute: 0),
            end: TimeOfDay(hour: 9, minute: 30),
            label: 'Almoço',
          ),
        ],
      ),
      Shift(
        name: 'Marta Santos',
        start: const TimeOfDay(hour: 6, minute: 0),
        end: const TimeOfDay(hour: 14, minute: 0),
        column: 3,
        category: CategoryId.padeiro,
        breaks: const [
          BreakPeriod(
            start: TimeOfDay(hour: 10, minute: 0),
            end: TimeOfDay(hour: 10, minute: 30),
            label: 'Almoço',
          ),
        ],
      ),

      // 🟢 Funcionário
      Shift(
        name: 'Neusa Silva',
        start: const TimeOfDay(hour: 8, minute: 0),
        end: const TimeOfDay(hour: 16, minute: 0),
        column: 4,
        category: CategoryId.funcionario,
        breaks: const [
          BreakPeriod(
            start: TimeOfDay(hour: 12, minute: 30),
            end: TimeOfDay(hour: 13, minute: 0),
            label: 'Almoço',
          ),
        ],
      ),
      Shift(
        name: 'José Almeida',
        start: const TimeOfDay(hour: 7, minute: 30),
        end: const TimeOfDay(hour: 15, minute: 30),
        column: 5,
        category: CategoryId.funcionario,
        breaks: const [
          BreakPeriod(
            start: TimeOfDay(hour: 11, minute: 30),
            end: TimeOfDay(hour: 12, minute: 0),
            label: 'Almoço',
          ),
        ],
      ),
    ];
  }
}
