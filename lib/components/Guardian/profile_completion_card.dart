import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:speed_guardian/components/get_profile_completion_step.dart';
import 'package:speed_guardian/utils/components.dart';

import 'package:step_progress_indicator/step_progress_indicator.dart';
import '../../utils/utils.dart';

class ProfileCompletionCard extends StatefulWidget {
  final User? user;
  final Map? userData;
  const ProfileCompletionCard(this.user, this.userData,{super.key});

  @override
  ProfileCompletionCardState createState() => ProfileCompletionCardState();
}

class ProfileCompletionCardState extends State<ProfileCompletionCard> {
  List completions = [];
  int completionPercent = 0;
  int toComplete = 0;
  bool isExpanded = false;
  bool dismissed = false;
  Map? userData;
  User? currUser;

  _getPrefs() async {
    setState(() {
      currUser = widget.user;
      userData = widget.userData;
    });

    List mp = [
      {
        "name": "Verify Email",
        "step": "",
        "complete": currUser!.emailVerified== true
      },
      {
        "name": "Add Contact",
        "step": "",
        "complete": currUser!.phoneNumber != null
      },
      {
        "name": "Verify Contact",
        "step": "",
        "complete": currUser!.phoneNumber != null
      },
      {
        "name": "Add blood group",
        "step": "",
        "complete": userData?["bloodGroup"] != null
      },
      {
        "name": "Add address",
        "step": "",
        "complete": userData?["address"] != null
      },
    ];

    int steps = 0;
    if (currUser!.emailVerified == true) {
      steps += 1;
    }
    if (currUser!.phoneNumber != null) {
      steps += 1;
    }
    if (currUser!.phoneNumber != null) {
      steps += 1;
    }
    if (userData?["bloodGroup"] != null) {
      steps += 1;
    }
    if (userData?["address"] != null) {
      steps += 1;
    }
    int toCompleted = 5;
    for (int i = 0; i < 5; i++) {
      if (mp[i]["complete"] == false) {
        toCompleted = i + 1;
        break;
      }
    }

    setState(() {
      completionPercent = steps * 20;
      completions = mp;
      toComplete = toCompleted;
    });
  }

  String getErrorMessage(User? currUser, Map? userData) {
    if (currUser?.emailVerified == true && currUser?.phoneNumber == null) {
      return "You must verify your contact to add device.";
    } else if (currUser?.emailVerified == false &&
        currUser?.phoneNumber == null) {
      return "You must verify your email and contact to add device.";
    } else if (currUser?.emailVerified == false) {
      return "You must verify your email to add device.";
    }

    return "";
  }

  @override
  void initState() {
    super.initState();
    _getPrefs();
  }

  @override
  Widget build(BuildContext context) {

    if (completionPercent == 100) {
      return Container();
    }

    return Container(
      margin: dismissed
          ? const EdgeInsets.all(0)
          : const EdgeInsets.only(top: 20, bottom: 0),
      padding: dismissed
          ? const EdgeInsets.all(0)
          : const EdgeInsets.fromLTRB(15, 10, 15, 20),
      color: themeColor(0.2),
      child: dismissed
          ? null
          : Theme(
              data: ThemeData().copyWith(dividerColor: Colors.transparent),
              child: ExpansionTile(
                title: isExpanded
                    ? Text(
                        "Setup your profile",
                        style: Theme.of(context).textTheme.titleMedium,
                      )
                    : Row(
                        children: [
                          InkWell(
                            child: const Icon(Icons.cancel_outlined,
                                size: 16, color: Colors.black),
                            onTap: () {
                              setState(() {
                                dismissed = true;
                              });
                            },
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Text("Setup your profile ($completionPercent%)"),
                        ],
                      ),
                onExpansionChanged: (bool value) {
                  setState(() {
                    isExpanded = !isExpanded;
                  });
                },
                children: [
                  Container(
                      color: const Color.fromRGBO(0, 0, 0, 0.1),
                      width: getWidth(context, 1.1),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 10),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            errorMessage(getErrorMessage(currUser, userData)),
                            const SizedBox(
                              height: 20,
                            ),
                            Row(
                              children: [
                                Text("$completionPercent% ",
                                    style: const TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.w400)),
                                const Expanded(
                                  child: SizedBox(),
                                ),
                                const Icon(Icons.check_circle,
                                    color: Color.fromRGBO(53, 147, 175, 1))
                              ],
                            ),
                            const SizedBox(height: 5),
                            StepProgressIndicator(
                              totalSteps: 5,
                              currentStep: toComplete,
                              selectedColor:
                                  const Color.fromRGBO(53, 147, 175, 0.8),
                            ),
                            const SizedBox(height: 20),
                            const Text("Steps to complete your profile:"),
                            const SizedBox(height: 10),
                            ...completions.map((step) {
                              return Row(children: [
                                if (step!["complete"] == true)
                                  const Icon(Icons.check, color: Colors.green),
                                if (step!["complete"] != true)
                                  const Icon(Icons.circle_outlined,
                                      color: Colors.red),
                                const SizedBox(width: 10),
                                Text('${step["name"]}'),
                              ]);
                            }),
                            Container(
                                margin: const EdgeInsets.only(top: 20),
                                child: getProfileCompletionStep(
                                    context, currUser, toComplete, userData))
                          ]))
                ],
              ),
            ),
    );
  }
}
