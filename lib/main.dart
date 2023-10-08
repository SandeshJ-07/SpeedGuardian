import 'package:flutter/material.dart';
import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'utils/firebase_options.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:speed_guardian/Pages/splashscreen.dart';

int? showOnboard;

Future main() async{
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  showOnboard = prefs.getInt("initScreen");
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await dotenv.load(fileName: "assets/.env");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Speed Guardian',
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      // Set the supported locales according to the localizations you have
      // implemented on your application.
      supportedLocales: const [
        Locale('en'), // English, no country code
      ],
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: const ColorScheme.light(),
        brightness: Brightness.light,
      ),
      debugShowCheckedModeBanner: false,
      home: SplashScreen(showOnboard: showOnboard),
    );
  }
}
