import 'package:flutter/material.dart';

class SemesterResult extends StatelessWidget {
  final String semester;
  final String result;

  const SemesterResult({
    super.key,
    required this.semester,
    required this.result,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          semester,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.black87,
          ),
        ),
        Text(
          result,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }
}
