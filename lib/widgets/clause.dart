import 'package:flutter/material.dart';

class Clause extends StatelessWidget {
  final String clause;
  const Clause({Key? key, required this.clause}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 10),
        Text(
          clause,
          textAlign: TextAlign.justify,
          style: const TextStyle(fontSize: 12),
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}
