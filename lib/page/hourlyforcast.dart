import 'package:flutter/material.dart';

class HourlyForeCast extends StatelessWidget {
  final IconData icon;
  final String lable;
  final String value;
  const HourlyForeCast({
    super.key,
    required this.icon,
    required this.lable,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      child: Container(
        width: 90,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Text(
              lable,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(
              height: 8.0,
            ),
            Icon(
              icon,
              size: 32,
            ),
            const SizedBox(
              height: 8.0,
            ),
            Text(
              value,
            ),
          ],
        ),
      ),
    );
  }
}
