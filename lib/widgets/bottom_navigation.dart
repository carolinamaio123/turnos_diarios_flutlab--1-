
import 'package:flutter/material.dart';

class BottomNavigation extends StatelessWidget {
  const BottomNavigation({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(bottom: 8, top: 6),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: Colors.black12)),
      ),
      child: Row(
        children: [
          _item(Icons.home, 'Home', false),
          _item(Icons.calendar_month, 'Schedule', true),
          _item(Icons.mail, 'Requests', false),
          _item(Icons.notifications, 'Notifications', false),
          _item(Icons.person, 'Profile', false),
        ],
      ),
    );
  }

  Widget _item(IconData icon, String label, bool active) {
    return Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: active ? Colors.teal : Colors.grey.shade600),
          const SizedBox(height: 4),
          Text(label, style: TextStyle(fontSize: 11, color: active ? Colors.teal : Colors.grey.shade600)),
        ],
      ),
    );
  }
}
