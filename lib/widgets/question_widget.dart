import 'package:flutter/material.dart';

class QuestionWidget extends StatelessWidget {
  final String question;
  final int? selected;
  final Function(int) onSelect;

  const QuestionWidget({
    super.key,
    required this.question,
    required this.selected,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    final scale = [-3, -2, -1, 0, 1, 2, 3];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(question, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: scale.map((value) {
            return GestureDetector(
              onTap: () => onSelect(value),
              child: Container(
                margin: const EdgeInsets.all(6),
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  color: selected == value
                      ? (value < 0 ? Colors.red : (value > 0 ? Colors.green : Colors.black))
                      : Colors.transparent,
                  border: Border.all(
                    color: value < 0 ? Colors.red : (value > 0 ? Colors.green : Colors.black),
                  ),
                  shape: BoxShape.circle,
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
