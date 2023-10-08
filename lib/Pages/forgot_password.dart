import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:speed_guardian/utils/components.dart';
import 'package:speed_guardian/utils/utils.dart';

import 'login.dart';

class ForgotPasswordPage extends StatefulWidget {
  String? email;

  ForgotPasswordPage({this.email, super.key});

  @override
  ForgotPasswordPageState createState() => ForgotPasswordPageState();
}

class ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  bool emailSent = false;
  bool _loading = false;

  var validate = {
    "email": false,
  };

  final FirebaseAuth auth = FirebaseAuth.instance;

  void resetPassword() async {
    setState(() {
      _loading = true;
    });
    try {
      await auth.sendPasswordResetEmail(email: _email.text);
      setState(() {
        emailSent = true;
      });
    } catch (e) {
      if(context.mounted) openSnackbar(context, "Email sent to reset password!");
    }
    setState(() {
      _loading = false;
    });
  }

  @override
  void dispose() {
    _email.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    if (widget.email != null) {
      _email.text = widget.email!;
    }
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
          Padding(
            padding: const EdgeInsets.only(left: 15),
            child: Image.asset('assets/images/forgot-password.png',
                height: getHeight(context, 4)),
          ),
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    const Text("Forgot Password",
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 28)),
                    const Text("Reset your account password"),
                    if (emailSent)
                      Padding(
                          padding: const EdgeInsets.only(top: 15),
                          child: showAlertMessage(
                              "Kindly check your email to reset your password.",
                              context)),
                    const SizedBox(height: 30),
                    SizedBox(
                      width: 300,
                      child: Form(
                          key: _formKey,
                          child: Column(children: <Widget>[
                            inputTextField("Email", const Icon(Icons.email),
                                _email, context,
                                error: validate["email"] ?? false,
                                enabled: !_loading,
                                errorMessage: "Invalid email"),
                          ])),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                        width: getWidth(context, 1.3),
                        child: filledButton(
                            "Reset Password", resetPassword, context,
                            loading: _loading)),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text("Got your password with you?"),
                        textButton("Login", () {
                          navigateWithAnimation(context, const LoginPage());
                        }, context),
                      ],
                    )
                  ]))
        ]),
      ),
    ])));
  }
}
