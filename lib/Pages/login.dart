import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:speed_guardian/Pages/Guardian/index.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:speed_guardian/Pages/Pilot/index.dart';
import 'package:speed_guardian/Pages/forgot_password.dart';
import 'package:speed_guardian/Pages/register.dart';
import 'package:speed_guardian/utils/components.dart';
import 'package:speed_guardian/utils/utils.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();

  bool _loading = false;

  var _validate = {
    "email": false,
    "password": false,
  };

  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseDatabase _database = FirebaseDatabase.instanceFor(
      app: Firebase.app(),
      databaseURL:
          dotenv.env["DATABASE_URL"]);

  Future<User?> loginUser(String email, String password) async {
    UserCredential credential =
        await auth.signInWithEmailAndPassword(email: email, password: password);
    return credential.user;
  }

  void _login() async {
    FocusManager.instance.primaryFocus?.unfocus();
    setState(() {
      _loading = true;
      _validate = {
        "name": false,
        "email": false,
        "password": false,
        "contact": false,
      };
    });

    String email = _email.text;
    String password = _password.text;

    if (email.isEmpty ||
        !RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
            .hasMatch(email)) _validate["email"] = true;
    if (password.isEmpty || password.length < 6) {
      _validate["password"] = true;
    }

    if (_validate["email"]! || _validate["password"]!) {
      setState(() {
        _loading = false;
      });
      return;
    }

    try {
      User? user = await loginUser(email, password);
      if (user != null) {
        setState(() {
          _loading = false;
        });

        final userRef = _database.ref().child("/users/${user.uid}/");
        final snapshot = await userRef.get();
        if (snapshot.exists) {
          Map? data = snapshot.value as Map?;
          userRef.update({"lastLoggedIn": DateTime.now().toString()});
          await Future.delayed(const Duration(seconds: 1));
          if (data?["type"] == "pilot") {
            if(context.mounted) navigateWithAnimation(context, PilotIndex());
          } else {
            if(context.mounted) navigateWithAnimation(context, GuardianIndex());
          }
        }
      }
    } catch (e) {
      FirebaseAuthException error = e as FirebaseAuthException;
      setState(() {
        _loading = false;
      });
      if(context.mounted) openSnackbar(context, 'Login Failed: ${error.message}');
    }
  }

  void navigateToRegister() {
    navigateWithAnimation(context, const RegisterPage(), ltr: true);
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
            child: Stack(children: [
      Image.asset('assets/images/wave_reg.png',
          width: MediaQuery.of(context).size.width),
      Container(
        margin: EdgeInsets.only(top: getHeight(context, 7)),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Image.asset('assets/images/login.png', height: getHeight(context, 5)),
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    const Text("Login",
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 28)),
                    const Text("Log In to your account"),
                    const SizedBox(height: 30),
                    SizedBox(
                      width: 300,
                      child: Form(
                          key: _formKey,
                          child: Column(children: <Widget>[
                            inputTextField("Email", const Icon(Icons.email),
                                _email, context,
                                error: _validate["email"] ?? false,
                                enabled: !_loading,
                                errorMessage: "Invalid email"),
                            const SizedBox(height: 20),
                            inputTextField("Password", const Icon(Icons.lock),
                                _password, context,
                                enabled: !_loading,
                                error: _validate["password"] ?? false,
                                errorMessage: "Minimum characters: 6",
                                obsecureText: true),
                          ])),
                    ),
                    textButton("Forgot Password", () {
                      navigateWithAnimation(
                          context,
                          ForgotPasswordPage(
                            email: _email.text,
                          ),
                          ltr: true);
                    }, context, fontSize: 14),
                    SizedBox(
                        width: getWidth(context, 1.3),
                        child: filledButton("Login", _login, context,
                            loading: _loading)),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text("Don't have an account?"),
                        textButton("Register", navigateToRegister, context),
                      ],
                    )
                  ]))
        ]),
      ),
    ])));
  }
}
