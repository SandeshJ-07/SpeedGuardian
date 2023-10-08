import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:speed_guardian/components/user_live_location.dart';
import 'package:speed_guardian/components/Guardian/device_home_card.dart';
import 'package:speed_guardian/components/Guardian/profile_completion_card.dart';
import 'package:speed_guardian/utils/components.dart';

import '../../utils/utils.dart';

class GuardianHome extends StatefulWidget {
  final User? currUser;
  final Map? userData;

  const GuardianHome(this.currUser, this.userData, {super.key});

  @override
  GuardianHomeState createState() => GuardianHomeState();
}

class GuardianHomeState extends State<GuardianHome> {
  User? currUser;
  Map? userData;
  bool refresh = true;

  _getPrefs() async {
    setState(() {
      currUser = widget.currUser;
      userData = widget.userData;
    });
  }

  @override
  void initState() {
    super.initState();
    _getPrefs();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        color: Colors.white,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                constraints: BoxConstraints(
                  minHeight: MediaQuery.of(context).size.height / 4,
                  maxHeight: MediaQuery.of(context).size.height / 4,
                  minWidth: MediaQuery.of(context).size.width,
                ),
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(25),
                        bottomRight: Radius.circular(25)),
                    gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Color.fromRGBO(47, 143, 175, 1),
                          Color.fromRGBO(47, 143, 175, 0.9),
                          Color.fromRGBO(47, 143, 175, 1)
                        ])),
                child: Container(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("${currUser?.displayName}",
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.w500)),
                        const Text(
                            "Let us worry about your close ones' safety.",
                            style: TextStyle(color: Colors.white)),
                        const Expanded(child: SizedBox()),
                        SizedBox(
                          width: getWidth(context, 1.1),
                          child: Row(children: [
                            iconTextCard(
                                "Track their location",
                                const Icon(Icons.location_on,
                                    color: themeBlue, size: 50),
                                context),
                            const Expanded(child: SizedBox()),
                            iconTextCard(
                                "Track their speed",
                                const Icon(Icons.speed,
                                    color: themeBlue, size: 50),
                                context),
                          ]),
                        ),
                        const Expanded(child: SizedBox()),
                      ],
                    ),
                  ),
                ),
              ),
              if (userData != null) ProfileCompletionCard(currUser, userData),
              Container(
                  color: themeColor(0.15),
                  margin: const EdgeInsets.only(top: 0),
                  child: const DeviceHomeCard()),
              Container(
                  color: themeColor(0.15),
                  margin: const EdgeInsets.only(top: 0, bottom: 0),
                  child: const UserLiveLocation()),
            ]),
      ),
    );
  }
}
