import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:speed_guardian/Pages/register.dart';
import 'package:speed_guardian/utils/utils.dart';
import 'package:speed_guardian/utils/components.dart';

class TermsAndConditions extends StatefulWidget {
  const TermsAndConditions({super.key});

  @override
  TermsAndConditionsState createState() => TermsAndConditionsState();
}

class TermsAndConditionsState extends State<TermsAndConditions> {
  bool _accepted = false;

  void toggleAccept() {
    setState(() {
      _accepted = !_accepted  ;
    });
  }

  void acceptTerms() async {
    if (_accepted) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setInt("initScreen", 1);
      if(context.mounted) navigateWithAnimation(context, const RegisterPage());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: Column(children: <Widget>[
      const Expanded(child: SizedBox()),
      Image.asset("assets/images/Logo.png", width: 300),
      const SizedBox(height: 30),
      const Text("Advanced safety measure for your family",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      const SizedBox(height: 80),
      const Text("Disclaimer", style: TextStyle(fontWeight: FontWeight.w700)),
      const SizedBox(height: 10),
      SizedBox(
          width: getWidth(context, 1.2),
          child: const Text(
              "SpeedGuardian is a mobile application designed to provide information and services to users. While we strive to ensure the accuracy and reliability of the information and services provided, we want to make it clear that SpeedGuardian is not 100% accurate, and the information presented should be used as a general reference only.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14))),
      const SizedBox(height: 50),
      SizedBox(
          width: getWidth(context, 1.2),
          child: InkWell(
            onTap: toggleAccept,
            child: Row(children: [
              Checkbox(
                value: _accepted,
                checkColor: themeBlue,
                fillColor: MaterialStateProperty.resolveWith((states) {
                  if (states.contains(MaterialState.selected)) {
                    return Colors.black12;
                  }
                  return Colors.black12;
                }),
                side: MaterialStateBorderSide.resolveWith(
                  (states) => const BorderSide(width: 0),
                ),
                onChanged: (bool? value) {
                  toggleAccept();
                },
              ),
              const Flexible(
                  child: Text(
                      "I have reviewed the disclaimer and agree to the terms and conditions."))
            ]),
          )),
      const Expanded(child: SizedBox()),
      filledButton("Get Started", acceptTerms, context, disabled: !_accepted),
    ])));
  }
}
