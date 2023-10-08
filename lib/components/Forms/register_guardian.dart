import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:speed_guardian/Pages/login.dart';
import 'package:speed_guardian/utils/components.dart';
import 'package:speed_guardian/utils/utils.dart';

class RegisterGuardianForm extends StatefulWidget {
  const RegisterGuardianForm({super.key});

  @override
  RegisterGuardianFormState createState() => RegisterGuardianFormState();
}

class RegisterGuardianFormState extends State<RegisterGuardianForm> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();

  bool _loading = false;
  var _validate = {
    "name": false,
    "email": false,
    "password": false,
  };

  // Firebase Auth And Storage
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseDatabase _database = FirebaseDatabase.instanceFor(
      app: Firebase.app(),
      databaseURL:
          dotenv.env["DATABASE_URL"]);

  Future<User?> signupWithEmailPass(
      String email, String password, String name) async {
    UserCredential credential = await auth.createUserWithEmailAndPassword(
        email: email, password: password);
    credential.user?.updateDisplayName(name);
    return credential.user;
  }

  void _signup() async {
    FocusManager.instance.primaryFocus?.unfocus();
    setState(() {
      _loading = true;
      _validate = {
        "name": false,
        "email": false,
        "password": false,
      };
    });
    String name = _name.text;
    String email = _email.text;
    String password = _password.text;

    if (name.isEmpty) _validate["name"] = true;
    if (email.isEmpty ||
        !RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
            .hasMatch(email)) _validate["email"] = true;
    if (password.isEmpty || password.length < 7) {
      _validate["password"] = true;
    }

    if (_validate["name"]! || _validate["email"]! || _validate["password"]!) {
      setState(() {
        _loading = false;
      });
      return;
    }

    try {
      User? user = await signupWithEmailPass(email, password, name);
      if (user != null) {
        user.sendEmailVerification();
        final ref = _database.ref().child("/users");
        await ref.child(user.uid).set({
          "id": user.uid,
          "email": email,
          "name": name,
          "type": "guardian",
        });
        _email.clear();
        _name.clear();
        _password.clear();
        setState(() {
          _loading = false;
        });
        await Future.delayed(const Duration(seconds: 1));
        if (context.mounted) openSnackbar(context, "Registration Successful");
        if (context.mounted) navigateWithAnimation(context, const LoginPage());
      }
    } catch (e) {
      FirebaseAuthException error = e as FirebaseAuthException;
      setState(() {
        _loading = false;
      });
      if (context.mounted) {
        openSnackbar(context, "Registration Failed: ${error.code}");
      }
      if (kDebugMode) {
        print("Error Signing up with Firebase");
      }
    }
  }

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              inputTextField("Name", const Icon(Icons.person), _name, context,
                  error: _validate["name"] ?? false,
                  errorMessage: "Invalid name"),
              const SizedBox(height: 20),
              inputTextField("Email", const Icon(Icons.email), _email, context,
                  error: _validate["email"] ?? false,
                  errorMessage: "Invalid email"),
              const SizedBox(height: 20),
              inputTextField(
                  "Password", const Icon(Icons.lock), _password, context,
                  error: _validate["password"] ?? false,
                  errorMessage: "Minimum length: 7",
                  obsecureText: true),
              const SizedBox(height: 30),
              SizedBox(
                  width: getWidth(context, 1.3),
                  child: filledButton("Register as Guardian", _signup, context,
                      loading: _loading)),
            ]));
  }
}
