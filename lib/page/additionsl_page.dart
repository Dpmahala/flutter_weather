import 'package:flutter/material.dart';

class Additional extends StatelessWidget {
  final IconData icon;
  final String lable;
  final String value;
  const Additional({
    super.key,
    required this.icon,
    required this.value,
    required this.lable,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Column(
          children: [
            Icon(
              icon,
              size: 32,
            ),
            const SizedBox(
              height: 8,
            ),
            Text(lable),
            const SizedBox(
              height: 8,
            ),
            Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
