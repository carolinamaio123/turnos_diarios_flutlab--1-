import 'dart:math';
import 'package:flutter/material.dart';

class TimeUtils {
  // Intervalo total do calendário
  static const int startHour = 1; // hora inicial (4:00)
  static const int endHour = 23; // hora final (23:00)
  static const double quarterHeight = 24; // altura de cada bloco de 15 min

  /// Converte um TimeOfDay em um deslocamento vertical (px)
  static double timeToOffset(TimeOfDay time) {
    final totalMinutes = (time.hour * 60 + time.minute) - (startHour * 60);
    final quarterCount = totalMinutes / 15;

    // Evita valores negativos (antes das 4h00)
    return max(0, quarterCount * quarterHeight);
  }

  /// Converte duração (start → end) em altura (px)
  static double durationToHeight(TimeOfDay start, TimeOfDay end) {
    final startMinutes = start.hour * 60 + start.minute;
    final endMinutes = end.hour * 60 + end.minute;
    final duration = max(0, endMinutes - startMinutes);

    // 15 minutos = quarterHeight px
    return (duration / 15) * quarterHeight;
  }

  /// Garante que um horário está dentro do intervalo 4:00 → 23:00
  static TimeOfDay clamp(TimeOfDay time) {
    if (time.hour < startHour) return TimeOfDay(hour: startHour, minute: 0);
    if (time.hour >= endHour) return TimeOfDay(hour: endHour, minute: 0);
    return time;
  }
}
