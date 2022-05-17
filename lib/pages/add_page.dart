import 'package:aqniyet/components/auth_required_state.dart';
import 'package:flutter/material.dart';

class AddPage extends StatefulWidget {
  static String routeName = '/add';
  const AddPage({Key? key}) : super(key: key);

  @override
  State<AddPage> createState() => _AddPageState();
}

class _AddPageState extends AuthRequiredState<AddPage> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
