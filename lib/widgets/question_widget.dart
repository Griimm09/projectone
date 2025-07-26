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
        Text(
          question,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: scale.map((value) {
            return ChoiceChip(
              label: Text(value.toString()),
              selected: selected == value,
              onSelected: (bool selected) {
                if (selected) onSelect(value);
              },
              selectedColor: value < 0
                  ? Colors.red[300]
                  : (value > 0 ? Colors.green[300] : Colors.grey),
              labelStyle: TextStyle(
                color: selected == value ? Colors.white : Colors.black,
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 8),
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Sangat Tidak Setuju'),
            Text('Netral'),
            Text('Sangat Setuju'),
          ],
        ),
      ],
    );
  }
}
