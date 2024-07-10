import 'package:flutter/material.dart';

class GroceryitemWidget extends StatelessWidget {
  const GroceryitemWidget(
      {super.key,
      required this.name,
      required this.quantity,
      required this.categoryColor});

  final Color categoryColor;
  final String name;
  final String quantity;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          Icons.square,
          color: categoryColor,
        ),
        const SizedBox(
          width: 30,
        ),
        Text(
          name,
          style: const TextStyle(
            fontSize: 16,
          ),
        ),
        const Spacer(),
        Text(
          quantity,
        ),
      ],
    );
  }
}
