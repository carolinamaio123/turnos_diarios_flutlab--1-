import 'package:flutter/material.dart';
import '../controllers/schedule_controller.dart';
import '../widgets/top_app_bar.dart';
import '../widgets/segmented_buttons.dart';
import '../widgets/time_column.dart';
import '../widgets/schedule_grid.dart';
import '../widgets/bottom_navigation.dart';
import '../widgets/category_legend.dart';
import '../utils/time_utils.dart';

class SchedulePage extends StatelessWidget {
  const SchedulePage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = ScheduleController();
    final shifts = controller.loadShifts();

    // altura total do conteúdo do horário (usada pelo SingleChildScrollView)
    final totalQuarters = (TimeUtils.endHour - TimeUtils.startHour) * 4;
    final contentHeight = totalQuarters * TimeUtils.quarterHeight;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFFF6F8F7),
      body: SafeArea(
        child: Column(
          children: [
            const TopAppBar(),
            const SegmentedButtons(),
            const CategoryLegend(),
            Expanded(
              child: SingleChildScrollView(
                // único scroll vertical para ambas as colunas
                child: SizedBox(
                  height: contentHeight,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // coluna das horas (sem scroll próprio)
                      SizedBox(
                        width: 20,
                        child: const TimeColumn(),
                      ),

                      // grid dos turnos: agora permite scroll horizontal APENAS aqui
                      Expanded(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          // defina a largura total do grid conforme necessário
                         // 1.8 é um multiplicador (um valor double) usado para definir a largura do grid: `width = screenWidth * 1.8` significa que o SizedBox terá 1.8 vezes a largura da tela. É um valor arbitrário para deixar o conteúdo horizontalmente rolável — ajuste conforme a quantidade/lar e das colunas ou calcule dinamicamente (ex.: `width = columnCount * columnWidth`).
                          child: SizedBox(
                            width: screenWidth * 1.8,
                            height: contentHeight,
                            child: ScheduleGrid(shifts: shifts),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const BottomNavigation(),
          ],
        ),
      ),
    );
  }
}
