import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:speed_guardian/Pages/login.dart';
import 'package:speed_guardian/utils/utils.dart';

Future<void> sendEmailVerificationDialog(
    BuildContext context, User? user) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        title: const Text("Verify Email"),
        content: const SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                        'You will receive an email to verify your email. You\'ll need to log in again to continue.'),
                    SizedBox(height: 10),
                    Text('Do you want to continue?'),
                  ]),
              SizedBox(height: 20)
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Close', style: TextStyle(color: Colors.black)),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromRGBO(53, 147, 175, 0.8)),
            child: const Text('Send', style: TextStyle(color: Colors.white)),
            onPressed: () {
              user?.sendEmailVerification();
              signOutUser();
              Navigator.of(context).pop();
              Navigator.of(context).pushReplacement(_createLoginRoute());
              const snackBar = SnackBar(
                content: Text('Check your mail to verify.'),
              );
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            },
          ),
        ],
      );
    },
  );
}

Route _createLoginRoute() {
  return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>
          const LoginPage(),
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
