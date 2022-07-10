import 'package:flutter/material.dart';

import '../utils/constants.dart';

class AppTitle extends StatelessWidget {
  const AppTitle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Text(
      appName,
      style: TextStyle(
        fontSize: 30,
        fontWeight: FontWeight.bold,
        color: Colors.indigo,
      ),
      textAlign: TextAlign.center,
    );
  }
}
