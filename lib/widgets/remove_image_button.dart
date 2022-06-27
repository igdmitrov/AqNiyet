import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class RemoveImageButton extends StatelessWidget {
  final Function() onPressed;
  final bool isLoading;
  const RemoveImageButton(
      {Key? key, required this.onPressed, required this.isLoading})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final appLocalization = AppLocalizations.of(context) as AppLocalizations;

    return OutlinedButton.icon(
      label: Text(appLocalization.question_remove_account),
      icon: const Icon(Icons.delete_forever_rounded),
      onPressed: isLoading ? null : onPressed,
      style: OutlinedButton.styleFrom(
        primary: Colors.red,
      ),
    );
  }
}
