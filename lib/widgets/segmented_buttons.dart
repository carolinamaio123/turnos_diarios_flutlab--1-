import 'package:flutter/material.dart';

class SegmentedButtons extends StatelessWidget {
  const SegmentedButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10.0),
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: const [
            Expanded(child: _Segment(label: 'My Schedule', selected: true)),
            SizedBox(width: 6),
            Expanded(child: _Segment(label: 'All')),
            SizedBox(width: 6),
            Expanded(child: _Segment(label: 'Teams')),
          ],
        ),
      ),
    );
  }
}

class _Segment extends StatelessWidget {
  final String label;
  final bool selected;

  const _Segment({required this.label, this.selected = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: selected ? Colors.white : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
        boxShadow: selected
            ? [
                BoxShadow(
                    color: Colors.black.withValues(alpha: 0.06), blurRadius: 6)
              ]
            : null,
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: selected ? Colors.black : Colors.grey.shade600,
        ),
      ),
    );
  }
}
