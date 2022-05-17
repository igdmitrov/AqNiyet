import 'package:flutter/material.dart';

class Greeting extends StatelessWidget {
  final DateTime dateTime;
  const Greeting({Key? key, required this.dateTime}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final hour = dateTime.hour;

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
