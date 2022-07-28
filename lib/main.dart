import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart' as provider;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'components/shared_preferences_provider.dart';
import 'pages/account_page.dart';
import 'pages/add_page.dart';
import 'pages/advert_page.dart';
import 'pages/adverts_page.dart';
import 'pages/change_password.dart';
import 'pages/chat_page.dart';
import 'pages/city_page.dart';
import 'pages/edit_page.dart';
import 'pages/login_page.dart';
import 'pages/main_page.dart';
import 'pages/my_adverts_page.dart';
import 'pages/password_recovery_page.dart';
import 'pages/policy_page.dart';
import 'pages/privacy_page.dart';
import 'pages/remove_account_page.dart';
import 'pages/report_page.dart';
import 'pages/room_page.dart';
import 'pages/signup_page.dart';
import 'pages/splash_page.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'pages/support_page.dart';
import 'pages/verify_email_page.dart';
import 'pages/verify_page.dart';
import 'secrets.dart';
import 'services/app_service.dart';
import 'utils/constants.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: supabaseUrl,
    anonKey: supabaseAnonKey,
  );

  timeago.setLocaleMessages('ru', timeago.RuMessages());
  timeago.setLocaleMessages('en', timeago.EnMessages());

  await Firebase.initializeApp();
  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    navigatorKey.currentState!.pushNamed(RoomPage.routeName);
  });

  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    badge: false,
    provisional: false,
    sound: true,
  );

  if (settings.authorizationStatus == AuthorizationStatus.authorized) {
    if (kDebugMode) {
      print('User granted permission');
    }
    String? token = await messaging.getToken();
    if (token != null) {
      await supabase.rpc('update_fcm_key', params: {'key': token}).execute();
    }
  } else {
    if (kDebugMode) {
      print('User declined or has not accepted permission');
    }
  }

  runApp(provider.MultiProvider(
    providers: [
      provider.Provider<SharedPreferencesProvider>(
          create: (_) =>
              SharedPreferencesProvider(SharedPreferences.getInstance())),
      provider.ChangeNotifierProvider<AppService>(
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
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('ru', ''),
          Locale('en', ''),
        ],
        navigatorKey: navigatorKey,
        initialRoute: SplashPage.routeName,
        routes: <String, WidgetBuilder>{
          SplashPage.routeName: (_) => const SplashPage(),
          LoginPage.routeName: (_) => const LoginPage(),
          SignUpPage.routeName: (_) => const SignUpPage(),
          MainPage.routeName: (_) => const MainPage(),
          AddPage.routeName: (_) => const AddPage(),
          EditPage.routeName: (_) => const EditPage(),
          CityPage.routeName: (_) => const CityPage(),
          AdvertsPage.routeName: (_) => const AdvertsPage(),
          MyAdvertsPages.routeName: (_) => const MyAdvertsPages(),
          AdvertPage.routeName: (_) => const AdvertPage(),
          AccountPage.routeName: (_) => const AccountPage(),
          VerifyPage.routeName: (_) => const VerifyPage(),
          PrivacyPage.routeName: (_) => const PrivacyPage(),
          PasswordRecoveryPage.routeName: (_) => const PasswordRecoveryPage(),
          VerifyEmailPage.routeName: (_) => const VerifyEmailPage(),
          RemoveAccountPage.routeName: (_) => const RemoveAccountPage(),
          ChangePassword.routeName: (_) => const ChangePassword(),
          SupportPage.routeName: (_) => const SupportPage(),
          PolicyPage.routeName: (_) => const PolicyPage(),
          ReportPage.routeName: (_) => const ReportPage(),
          ChatPage.routeName: (_) => const ChatPage(),
          RoomPage.routeName: (_) => const RoomPage(),
        },
      );
    });
  }
}
