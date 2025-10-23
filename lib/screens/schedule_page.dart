import 'package:flutter/material.dart';
import '../controllers/schedule_controller.dart';
import '../widgets/top_app_bar.dart';
import '../widgets/segmented_buttons.dart';
import '../widgets/time_column.dart';
import '../widgets/schedule_grid.dart';
import '../widgets/bottom_navigation.dart';
import '../widgets/category_legend.dart';

class SchedulePage extends StatelessWidget {
  const SchedulePage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = ScheduleController();
    final shifts = controller.loadShifts();

    return Scaffold(
      backgroundColor: const Color(0xFFF6F8F7),
      body: SafeArea(
        child: Column(
          children: [
            const TopAppBar(),
            const SegmentedButtons(),
            const CategoryLegend(),
            Expanded(
              child: Row(
                children: [
                  const TimeColumn(),
                  Expanded(child: ScheduleGrid(shifts: shifts)),
                ],
              ),
            ),
            const BottomNavigation(),
          ],
        ),
      ),
    );
  }
}
