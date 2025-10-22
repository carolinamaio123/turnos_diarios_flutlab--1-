
import 'package:flutter/material.dart';

class TopAppBar extends StatelessWidget {
  const TopAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.black12)),
      ),
      child: Row(
        children: [
          IconButton(icon: const Icon(Icons.menu), onPressed: () {}),
          const Expanded(
            child: Center(
              child: Text(
                'Turnos Diários',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          IconButton(icon: const Icon(Icons.calendar_today), onPressed: () {}),
        ],
      ),
    );
  }
}
