import 'package:flutter/material.dart';

import 'package:speed_guardian/utils/components.dart';
import 'package:speed_guardian/utils/utils.dart';
import 'package:speed_guardian/Pages/tnc.dart';

const onboardingPages = [
  {
    "icon": 'assets/images/onboard1.png',
    "title": "Precise Navigation",
    "text":
        'Get assured that your family navigates the right way with our precise location tracking.'
  },
  {
    "icon": 'assets/images/onboard3.png',
    "title": "Live Updates",
    "text":
        "Receive live updates of your loved ones' whereabouts and activities in real-time.",
  },
  {
    "icon": 'assets/images/onboard2.png',
    "title": "SpeedGuard",
    "text":
        "Ensure their speed doesn't exceed safe limits with speed monitoring features.",
  },
];

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  OnboardingScreenState createState() => OnboardingScreenState();
}

class OnboardingScreenState extends State<OnboardingScreen> {
  int _screenIndex = 0;

  void navigateToTnC() {
    navigateWithAnimation(context, const TermsAndConditions());
  }

  // Moves to next Page
  void _nextPage() {
    if (_screenIndex == onboardingPages.length - 1) {
      navigateToTnC();
      return;
    }
    if (_screenIndex < onboardingPages.length - 1) {
      setState(() {
        _screenIndex++;
      });
    }
  }

  // Moves to previous page
  void _prevPage() {
    if (_screenIndex > 0) {
      setState(() {
        _screenIndex--;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragEnd: (details) {
        if (details.primaryVelocity! > 0) {
          _prevPage();
        } else if (details.primaryVelocity! < 0) {
          _nextPage();
        }
      },
      child: Scaffold(
          body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Expanded(child: SizedBox()),
          Center(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                Container(
                    margin: const EdgeInsets.only(top: 10.0, bottom: 20),
                    child: Text(onboardingPages[_screenIndex]["title"]!,
                        style: const TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: themeBlue,
                        ))),
                Image.asset(onboardingPages[_screenIndex]["icon"]!,
                    height: getHeight(context, 2.5)),
                SizedBox(
                  width: getWidth(context, 1.1),
                  child: Text(
                    onboardingPages[_screenIndex]["text"]!,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                ),
                Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: onboardingNavigation(_screenIndex))
              ])),
          const Expanded(child: SizedBox()),
          Container(
            margin: const EdgeInsets.fromLTRB(5, 0, 0, 10),
            child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
              if (_screenIndex > 0) textButton("Prev", _prevPage, context),
              const Expanded(child: SizedBox()),
              if (_screenIndex < onboardingPages.length - 1)
                textButton("Next", _nextPage, context),
              if (_screenIndex == onboardingPages.length - 1)
                textButton("Next", navigateToTnC, context)
            ]),
          ),
        ],
      )),
    );
  }
}

// Returns the navigation indicators on onboarding screen
List<Widget> onboardingNavigation(int screenIndex) {
  List<Widget> rowChildren = [];
  for (int i = 0; i < onboardingPages.length; i++) {
    rowChildren.add(navigationCircle(i, screenIndex));
  }
  return rowChildren;
}

// Returns individual navigation indicator
Widget navigationCircle(int currIndex, int activeIndex) {
  return Container(
    margin: const EdgeInsets.only(top: 50, right: 7),
    height: 7,
    width: 7,
    decoration: BoxDecoration(
        color: activeIndex == currIndex ? Colors.blueAccent : Colors.black12,
        shape: BoxShape.circle),
  );
}
