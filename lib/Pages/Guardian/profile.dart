import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:speed_guardian/Pages/edit_profile.dart';
import 'package:speed_guardian/components/Dialogs/send_email_verification_dialog.dart';
import 'package:speed_guardian/components/Dialogs/verify_phone_number.dart';
import 'package:speed_guardian/utils/components.dart';

import '../../utils/utils.dart';

class GuardianProfile extends StatefulWidget {
  final User? user;
  final Map? userData;

  const GuardianProfile(this.user, this.userData, {super.key});

  @override
  GuardianProfileState createState() => GuardianProfileState();
}

class GuardianProfileState extends State<GuardianProfile> {
  User? currUser;
  Map? userData;

  @override
  void initState() {
    setState(() {
      currUser = widget.user;
      userData = widget.userData;
    });
    setState(() {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text("Profile",
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: TextAlign.start),
          const SizedBox(height: 40),
          const Center(
              child: CircleAvatar(
            backgroundImage: AssetImage("assets/images/avatar.png"),
            radius: 70,
          )),
          const SizedBox(height: 20),
          Center(
              child: Text("${currUser?.displayName}",
                  style: const TextStyle(
                      fontWeight: FontWeight.w500, fontSize: 24))),
          const SizedBox(height: 40),
          Container(
              height: getHeight(context, 3),
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: SingleChildScrollView(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            displayData("Email", widget.user!.email,
                                const Icon(Icons.mail)),
                            const Expanded(child: SizedBox()),
                            if (currUser!.emailVerified == true)
                              const Center(
                                  child: Icon(Icons.verified,
                                      color: Colors.blueAccent))
                          ]),
                      const SizedBox(height: 30),
                      displayData("Blood Group", userData?["bloodGroup"],
                          const Icon(Icons.bloodtype_rounded)),
                      const SizedBox(height: 30),
                      displayData("Contact", currUser?.phoneNumber,
                          const Icon(Icons.phone)),
                      const SizedBox(height: 30),
                      displayData("Address", userData?["address"],
                          const Icon(Icons.home)),
                    ]),
              )),
          const Expanded(child: SizedBox()),
          if (currUser?.emailVerified == false)
            outlinedButton("Verify Email", () {
              sendEmailVerificationDialog(context, currUser);
            }, context),
          if (currUser?.emailVerified == true && currUser?.phoneNumber == null)
            outlinedButton("Verify Contact", () {
              navigateWithAnimation(
                  context, VerifyPhoneNumber(currUser?.phoneNumber));
            }, context),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.only(bottom: 20),
            child: Center(
                child: filledButton("Edit Profile", () {
              navigateWithAnimation(
                  context, GuardianEditProfile(currUser, userData), replace: false);
            }, context)),
          ),
        ]));
  }
}
