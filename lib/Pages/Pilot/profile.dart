import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:speed_guardian/Pages/edit_profile.dart';
import 'package:speed_guardian/components/Dialogs/send_email_verification_dialog.dart';
import 'package:speed_guardian/components/Dialogs/verify_phone_number.dart';
import 'package:speed_guardian/utils/components.dart';

import '../../utils/utils.dart';

class PilotProfile extends StatefulWidget {
  final User? user;
  final Map? userData, guardianData;

  const PilotProfile(this.user, this.userData, this.guardianData, {super.key});

  @override
  PilotProfileState createState() => PilotProfileState();
}

class PilotProfileState extends State<PilotProfile> {
  User? currUser;
  Map? userData, guardianData;

  @override
  void initState() {
    setState(() {
      currUser = widget.user;
      userData = widget.userData;
      guardianData = widget.guardianData;
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
          Container(
              height: getHeight(context, 1.6),
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: SingleChildScrollView(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
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
                      const SizedBox(height: 30),
                      const Text("Guardian Details",
                          style: TextStyle(fontWeight: FontWeight.w500)),
                      const SizedBox(height: 30),
                      displayData("Guardian Name", guardianData?["name"],
                          const Icon(Icons.person)),
                      const SizedBox(height: 30),
                      displayData("Guardian Email", guardianData?["email"],
                          const Icon(Icons.email)),
                      const SizedBox(height: 30),
                      displayData("Guardian Contact", guardianData?["contact"],
                          const Icon(Icons.phone)),
                      const SizedBox(height: 30),
                      displayData("Guardian Address", guardianData?["address"],
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
                  context, VerifyPhoneNumber(currUser?.phoneNumber), replace: false);
            }, context),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.only(bottom: 10),
            child: Center(
                child: filledButton("Edit Profile", () {
              navigateWithAnimation(
                  context, GuardianEditProfile(currUser, userData), replace: false);
            }, context)),
          ),
        ]));
  }
}
