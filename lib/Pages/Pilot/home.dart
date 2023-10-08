import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:speed_guardian/components/user_live_location.dart';
import 'package:speed_guardian/utils/components.dart';

class PilotHome extends StatefulWidget {
  final User? currUser;
  final Map? userData;
  const PilotHome(this.currUser, this.userData,{super.key});

  @override
  PilotHomeState createState() => PilotHomeState();
}

class PilotHomeState extends State<PilotHome> {
  late User? currUser;
  late Map? userData;

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
                  minHeight: MediaQuery.of(context).size.height / 8,
                  maxHeight: MediaQuery.of(context).size.height / 8,
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
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                  color: themeColor(0.15),
                  margin: const EdgeInsets.only(top: 0, bottom: 20),
                  child: userData?["track"] == true
                      ? UserLiveLocation(pilotId: currUser?.uid)
                      : const UserLiveLocation()),
            ]),
      ),
    );
  }
}
