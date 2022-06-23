import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:page_transition/page_transition.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../widgets/footer.dart';
import '../widgets/logo.dart';
import 'main_page.dart';

class SplashPage extends StatefulWidget {
  static String routeName = '/';
  const SplashPage({Key? key}) : super(key: key);

  @override
  State<SplashPage> createState() => _SplashPageState();
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
                const Logo(),
                SizedBox(height: 23.h),
                const Footer(),
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
