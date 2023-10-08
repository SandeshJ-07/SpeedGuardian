import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:speed_guardian/Pages/Guardian/index.dart';
import 'package:speed_guardian/Pages/Pilot/index.dart';
import 'package:speed_guardian/Pages/login.dart';
import 'package:speed_guardian/Pages/onboarding.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'dart:async';

import '../utils/utils.dart';

int? initScreen;

class SplashScreen extends StatefulWidget {
  final int? showOnboard;

  const SplashScreen({Key? key, this.showOnboard}) : super(key: key);

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  bool _visible = false;
  Map? userData;
  User? currUser;

  final FirebaseDatabase _database = FirebaseDatabase.instanceFor(
      app: Firebase.app(),
      databaseURL:
          dotenv.env["DATABASE_URL"]);

  _getPrefs() async {
    if (FirebaseAuth.instance.currentUser != null) {
      User? user = await getCurrentUser();
      final userRef = _database.ref().child("/users/${user?.uid}/");
      setState(() {
        currUser = user;
      });

      final snapshot = await userRef.get();
      if (snapshot.exists) {
        Map? data = snapshot.value as Map?;
        userData = data;
        initScreen = widget.showOnboard;
        Timer(
            const Duration(milliseconds: 1),
            () => setState(() {
                  _visible = true;
                }));
        Timer(const Duration(seconds: 3), () async {
          await Navigator.of(context).pushReplacement(_createRoute(data));
        });
      }
    } else {
      Timer(
          const Duration(milliseconds: 1),
          () => setState(() {
                _visible = true;
              }));
      Timer(const Duration(seconds: 3), () async {
        await Navigator.of(context).pushReplacement(_createRoute(null));
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _getPrefs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: AnimatedOpacity(
            opacity: _visible ? 1 : 0,
            duration: const Duration(milliseconds: 1500),
            child: Center(
                child: Image.asset('assets/images/Logo.png', width: 300))));
  }
}

Route _createRoute(Map? userData) {
  return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>
          FirebaseAuth.instance.currentUser == null
              ? initScreen == 0 || initScreen == null
                  ? const OnboardingScreen()
                  : const LoginPage()
              : userData?["type"] == "pilot"
                  ? PilotIndex()
                  : GuardianIndex(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.decelerate;
        final tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        final offsetAnimation = animation.drive(tween);
        return SlideTransition(position: offsetAnimation, child: child);
      });
}
