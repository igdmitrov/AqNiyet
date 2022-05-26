import 'package:flutter/material.dart';

class Greeting extends StatelessWidget {
  const Greeting({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final hour = DateTime.now().hour;

    if (hour > 4 && hour < 12) {
      return const Text('Good morning!');
    }
    if (hour < 17) {
      return const Text('Good afternoon!');
    }

    if (hour > 17 && hour < 23) {
      return const Text('Good evening!');
    }

    return const Text('Good night!');
  }
}
