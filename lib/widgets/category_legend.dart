import 'package:flutter/material.dart';
import '../models/category.dart';

class CategoryLegend extends StatelessWidget {
  const CategoryLegend({super.key});

  @override
  Widget build(BuildContext context) {
    // largura do ecrã
    final width = MediaQuery.of(context).size.width;
    // em ecrãs menores que 600px → empilha em colunas
    final isSmallScreen = width < 600;

    final items = categories.values.map((cat) {
      return _LegendItem(
        color: cat.color,
        label: '${cat.letter} = ${cat.label}',
      );
    }).toList();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
      child: isSmallScreen
          // Layout vertical (para telemóveis)
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: items
                  .map((item) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 3.0),
                        child: item,
                      ))
                  .toList(),
            )
          // Layout horizontal (para tablets/desktops)
          : Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: items,
            ),
    );
  }
}

class _LegendItem extends StatelessWidget {
  final Color color;
  final String label;

  const _LegendItem({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade800,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
