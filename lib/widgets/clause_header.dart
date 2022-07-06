import 'package:flutter/material.dart';

import 'form_input_divider.dart';

class ClauseHeader extends StatelessWidget {
  final String header;
  const ClauseHeader({Key? key, required this.header}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const FormInputDivider(),
        Text(
          header,
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const FormInputDivider(),
      ],
    );
  }
}
