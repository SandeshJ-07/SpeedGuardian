import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:speed_guardian/components/Forms/edit_profile_form.dart';

class GuardianEditProfile extends StatefulWidget {
  final User? user;
  final Map? userDetails;

  const GuardianEditProfile(this.user, this.userDetails, {super.key});

  @override
  GuardianEditProfileState createState() => GuardianEditProfileState();
}

class GuardianEditProfileState extends State<GuardianEditProfile> {
  User? currUser;
  Map? userData;
  String? bloodGroup;

  setBloodGroup(String bg) {
    bloodGroup = bg;
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      currUser = widget.user;
      userData = widget.userDetails;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text("Edit Profile",
                  style: Theme.of(context).textTheme.titleLarge,
                  textAlign: TextAlign.start),
              const SizedBox(height: 40),
              Padding(
                padding: const EdgeInsets.only(right: 40, left: 10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const CircleAvatar(
                      backgroundImage: AssetImage("assets/images/avatar.png"),
                      radius: 30,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      "${currUser?.displayName}",
                      style: const TextStyle(color: Colors.black),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(right: 40, left: 10),
                  child: GuardianEditProfileForm(currUser, userData),
                ),
              ),
            ])),
      ),
    );
  }
}
