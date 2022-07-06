import 'package:flutter/material.dart';

import 'form_input_divider.dart';

class ClauseSubHeader extends StatelessWidget {
  final String header;
  const ClauseSubHeader({Key? key, required this.header}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const FormInputDivider(),
        Text(
          header,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
        const FormInputDivider(),
      ],
    );
  }
}
