import 'package:flutter/material.dart';

class RemoveImageButton extends StatelessWidget {
  final Function() onPressed;
  const RemoveImageButton({Key? key, required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      label: const Text('Remove'),
      icon: const Icon(Icons.delete_forever_rounded),
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        primary: Colors.red,
      ),
    );
  }
}
