import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:page_transition/page_transition.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import 'main_page.dart';

class SplashPage extends StatefulWidget {
  static String routeName = '/';
  const SplashPage({Key? key}) : super(key: key);

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedSplashScreen(
        duration: 1500,
        splashIconSize: double.infinity,
        splash: ListView(
          padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 20.w),
          children: [
            Column(
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
                SizedBox(height: 23.h),
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
          ],
        ),
        nextScreen: const MainPage(),
        splashTransition: SplashTransition.fadeTransition,
        pageTransitionType: PageTransitionType.fade,
      ),
    );
  }
}
