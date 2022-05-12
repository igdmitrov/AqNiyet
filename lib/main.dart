import 'package:aqniyet/services/app_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'pages/login_page.dart';
import 'pages/main_page.dart';
import 'pages/splash_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://ekafrwzpvnxinsngbpiu.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImVrYWZyd3pwdm54aW5zbmdicGl1Iiwicm9sZSI6ImFub24iLCJpYXQiOjE2NTE1ODMwNjgsImV4cCI6MTk2NzE1OTA2OH0.y0hW774bZKHBFhYDaK_87cmNNNvb1O14tDb769ED5Jg',
  );

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider<AppService>(
        create: (_) => AppService(),
      ),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Sizer(builder: (context, orientation, deviceType) {
      return MaterialApp(
        title: 'AqNiyet',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.indigo,
        ),
        initialRoute: SplashPage.routeName,
        routes: <String, WidgetBuilder>{
          SplashPage.routeName: (_) => const SplashPage(),
          LoginPage.routeName: (_) => const LoginPage(),
          MainPage.routeName: (_) => const MainPage(),
        },
      );
    });
  }
}
