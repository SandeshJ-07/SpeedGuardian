import 'package:flutter/material.dart';

import 'package:speed_guardian/Pages/login.dart';
import 'package:speed_guardian/utils/components.dart';
import 'package:speed_guardian/utils/utils.dart';

import '../components/user_register_type.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  RegisterPageState createState() => RegisterPageState();
}

class RegisterPageState extends State<RegisterPage> {
  void navigateToLogin() {
    navigateWithAnimation(context, const LoginPage());
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
          Image.asset('assets/images/register.png',
              height: getHeight(context, 5)),
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Register",
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 28)),
                    const Text("Start navigating the right way!"),
                    const SizedBox(height: 30),
                    const SizedBox(child: UserRegisterType()),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text("Already have an account?"),
                        textButton("Login", navigateToLogin, context),
                      ],
                    )
                  ]))
        ]),
      ),
    ])));
  }
}
