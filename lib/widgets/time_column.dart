import 'package:flutter/material.dart';
import '../utils/time_utils.dart';

class TimeColumn extends StatefulWidget {
  const TimeColumn({super.key});

  @override
  State<TimeColumn> createState() => _TimeColumnState();
}

class _TimeColumnState extends State<TimeColumn> with SingleTickerProviderStateMixin {
  late TimeOfDay _now;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _now = TimeOfDay.now();

    // Atualiza a hora a cada segundo para mover a linha suavemente
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() {
        _now = TimeOfDay.now();
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final totalQuarters = (TimeUtils.endHour - TimeUtils.startHour) * 4;
    final columnWidth = 50.0;

    return Stack(
      children: [
        Column(
          children: List.generate(totalQuarters, (i) {
            final hour = TimeUtils.startHour + (i ~/ 4);
            final minute = (i % 4) * 15;

            return Container(
              height: TimeUtils.quarterHeight,
              width: columnWidth,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: i % 8 < 4 ? Colors.grey.shade100 : Colors.white,
                border: Border(
                  bottom: BorderSide(color: Colors.grey.shade300, width: 0.5),
                ),
              ),
              child: Text(
                '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueGrey.shade700,
                ),
              ),
            );
          }),
        ),
        // Linha vermelha indicando a hora atual
        Positioned(
          top: _calculateOffset(_now),
          left: 0,
          right: 0,
          child: Container(
            height: 2,
            color: Colors.redAccent,
          ),
        ),
      ],
    );
  }

  double _calculateOffset(TimeOfDay now) {
    // Total de minutos desde a hora de início
    final totalMinutes = (now.hour - TimeUtils.startHour) * 60 + now.minute;
    // Converte para altura em pixels
    return totalMinutes / 15 * TimeUtils.quarterHeight;
  }
}
