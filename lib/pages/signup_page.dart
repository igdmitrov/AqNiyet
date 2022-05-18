import 'package:aqniyet/pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:sizer/sizer.dart';

import '../utils/constants.dart';

class SignUpPage extends StatefulWidget {
  static String routeName = '/signup';
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _form = GlobalKey<FormState>();
  bool _isLoading = false;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  Future<void> _signUp() async {
    setState(() {
      _isLoading = true;
    });

    final isValid =
        _form.currentState == null ? false : _form.currentState!.validate();

    if (isValid) {
      final response = await supabase.auth
          .signUp(_emailController.text, _passwordController.text);
      final error = response.error;
      if (error != null) {
        context.showErrorSnackBar(message: error.message);
      } else {
        context.showSnackBar(message: 'User was created');
        Navigator.of(context)
            .pushNamed(LoginPage.routeName, arguments: _emailController.text);
      }
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 10.w),
        children: [
          Form(
            key: _form,
            child: Column(
              children: [
                Image.asset(
                  'assets/images/login.png',
                  height: 30.h,
                ),
                const Text(
                  'AqNiyet',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.indigo,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 18),
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(labelText: 'Email'),
                  validator: emailValidator(),
                ),
                const SizedBox(height: 18),
                TextFormField(
                  controller: _passwordController,
                  decoration: const InputDecoration(labelText: 'Password'),
                  obscureText: true,
                  validator: passwordValidator(),
                ),
                const SizedBox(height: 18),
                TextFormField(
                  controller: _confirmPasswordController,
                  decoration:
                      const InputDecoration(labelText: 'Confirm Password'),
                  obscureText: true,
                  validator: (val) =>
                      MatchValidator(errorText: 'Password do not match')
                          .validateMatch(_confirmPasswordController.text,
                              _passwordController.text),
                ),
                const SizedBox(height: 18),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: _isLoading ? null : _signUp,
                      child: Text(_isLoading ? 'Loading' : 'Sign Up'),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    TextButton(
                      onPressed: () =>
                          Navigator.of(context).pushNamed(LoginPage.routeName),
                      child: const Text('Sign In'),
                    ),
                  ],
                ),
                SizedBox(height: 20.h),
                const Text(
                  'DEVELOPED BY IGOR DMITROV',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
                Text(
                  DateTime.now().year.toString(),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
