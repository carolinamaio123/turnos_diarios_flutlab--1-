import 'package:flutter/material.dart';
import '../../models/shift.dart';
import '../../pages/person_details_page.dart';

void showShiftPopup(BuildContext context, Shift shift) {
  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: shift.color,
                radius: 24,
                child: Text(
                  shift.name.isNotEmpty ? shift.name[0].toUpperCase() : '',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  shift.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => PersonDetailsPage(shift: shift),
                ),
              );
            },
            icon: const Icon(Icons.info_outline),
            label: const Text('Ver informações completas'),
            style: ElevatedButton.styleFrom(
              backgroundColor: shift.color,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Fechar', style: TextStyle(color: Colors.grey)),
        ),
      ],
    ),
  );
}
