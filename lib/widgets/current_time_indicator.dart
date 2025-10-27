import 'package:flutter/material.dart';
import '../../utils/time_utils.dart';

class CurrentTimeIndicator extends StatelessWidget {
  const CurrentTimeIndicator({super.key, required TimeOfDay time, required TimeOfDay now});

  @override
  Widget build(BuildContext context) {
    final now = TimeOfDay.now();
    final topOffset = TimeUtils.timeToOffset(now);

    return Positioned(
      top: topOffset,
      left: 0,
      right: 0,
      child: Row(
        children: [
          const SizedBox(
            width: 60,
            child: Text(
              'Agora',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.redAccent, fontSize: 10, fontWeight: FontWeight.w600),
            ),
          ),
          Expanded(child: Container(height: 1.2, color: Colors.redAccent)),
          const Padding(
            padding: EdgeInsets.only(left: 10),
            child: CircleAvatar(radius: 5, backgroundColor: Colors.redAccent),
          ),
        ],
      ),
    );
  }
}
