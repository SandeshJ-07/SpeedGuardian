import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:speed_guardian/Pages/Guardian/index.dart';
import 'package:speed_guardian/components/Dialogs/verify_phone_number.dart';
import 'package:speed_guardian/utils/class.dart';
import 'package:speed_guardian/utils/utils.dart';

import '../../Pages/Pilot/index.dart';
import '../../utils/components.dart';

class GuardianEditProfileForm extends StatefulWidget {
  final User? user;
  final Map? userDetails;

  const GuardianEditProfileForm(this.user, this.userDetails, {super.key});

  @override
  GuardianEditProfileFormState createState() => GuardianEditProfileFormState();
}

class GuardianEditProfileFormState extends State<GuardianEditProfileForm> {
  final _formKey = GlobalKey<FormState>();

  final _name = TextEditingController();
  final _email = TextEditingController();
  final _address = TextEditingController();
  String? bloodGroup;
  bool _loading = false;

  List<DropDownMenuItemClass<BloodGroup>> bgs = [
    DropDownMenuItemClass(BloodGroup.aPOSITIVE, const Text("A_POSITIVE")),
    DropDownMenuItemClass(BloodGroup.aNEGATIVE, const Text("A_NEGATIVE")),
    DropDownMenuItemClass(BloodGroup.bPOSITIVE, const Text("B_POSITIVE")),
    DropDownMenuItemClass(BloodGroup.bNEGATIVE, const Text("B_NEGATIVE")),
    DropDownMenuItemClass(BloodGroup.abPOSITIVE, const Text("AB_POSITIVE")),
    DropDownMenuItemClass(BloodGroup.abNEGATIVE, const Text("AB_NEGATIVE")),
    DropDownMenuItemClass(BloodGroup.oPOSITIVE, const Text("O_POSITIVE")),
    DropDownMenuItemClass(BloodGroup.oNEGATIVE, const Text("O_NEGATIVE")),
  ];

  BloodGroup getBloodGroup(String bg) {
    switch (bg) {
      case "aPOSITIVE":
        return BloodGroup.aPOSITIVE;
      case "aNEGATIVE":
        return BloodGroup.aNEGATIVE;
      case "bPOSITIVE":
        return BloodGroup.bPOSITIVE;
      case "bNEGATIVE":
        return BloodGroup.bNEGATIVE;
      case "oPOSITIVE":
        return BloodGroup.oPOSITIVE;
      case "oNEGATIVE":
        return BloodGroup.oNEGATIVE;
      case "abPOSITIVE":
        return BloodGroup.abPOSITIVE;
      case "abNEGATIVE":
        return BloodGroup.abNEGATIVE;
      default:
        return BloodGroup.aPOSITIVE;
    }
  }

  void onDropDownChange(BloodGroup bg) {
    setState(() {
      bloodGroup = bg.toString().replaceAll("BloodGroup.", "");
    });
  }

  final FirebaseDatabase _database = FirebaseDatabase.instanceFor(
      app: Firebase.app(),
      databaseURL:
          dotenv.env["DATABASE_URL"]);

  var _validate = {
    "name": false,
    "address": false,
    "email": false,
    "bloodGroup": false,
  };

  @override
  void initState() {
    super.initState();
    _name.text = widget.user!.displayName!;
    _email.text = widget.user!.email!;
    _address.text = widget.userDetails!["address"] ?? "";
    bloodGroup = widget.userDetails!["bloodGroup"];
  }

  @override
  Widget build(BuildContext context) {
    void updateProfile() async {
      setState(() {
        _loading = true;
        _validate = {
          "name": false,
          "address": false,
          "email": false,
          "bloodGroup": false,
        };
      });

      String name = _name.text;
      String email = _email.text;
      String address = _address.text;

      if (name.isEmpty) _validate["name"] = true;
      if (email.isEmpty ||
          !RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
              .hasMatch(email)) _validate["email"] = true;

      if (address.isEmpty) _validate["address"] = true;
      if (bloodGroup == null) _validate["bloodGroup"] = true;

      if (_validate["name"]! ||
          _validate["email"]! ||
          _validate["address"]! ||
          _validate["bloodGroup"]!) {
        setState(() {
          _loading = false;
        });
        return;
      }

      final userRef = _database.ref().child("/users").child(widget.user!.uid);

      if (email != widget.user!.email) {
        try {
          widget.user!.verifyBeforeUpdateEmail(email);
          openSnackbar(context,
              "Verify your email address by clicking the link in the mail sent!");
        } catch (e) {
          openSnackbar(context,
              "This operation is sensitive and requires recent authentication. Log in again before retrying this request.");
        }
      }

      try {
        Map<String, Object?> details = {};
        if (name != widget.user!.displayName) {
          details["name"] = name;
          widget.user!.updateDisplayName(name);
        }

        details["address"] = address;
        details["bloodGroup"] = bloodGroup!;
        userRef.update(details);
        setState(() {
          _loading = false;
        });
        if (details["type"] == "pilot") {
          navigateWithAnimation(context, PilotIndex(screenIndex: 0));
        } else {
          navigateWithAnimation(context, GuardianIndex(screenIndex: 0));
        }
        if (context.mounted) {
          openSnackbar(context, "Profile Updated! Effects may take time.");
        }
      } catch (e) {
        if (context.mounted) {
          openSnackbar(context, "Profile Update Failed. Try again later.");
        }
      }
    }

    return Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SingleChildScrollView(
                  child: Column(
                    children: [
                      inputTextField(
                          "Name", const Icon(Icons.person_2), _name, context,
                          error: _validate["name"] ?? false,
                          errorMessage: "Enter name"),
                      const SizedBox(height: 20),
                      inputTextField(
                          "Email", const Icon(Icons.email), _email, context,
                          error: _validate["email"] ?? false,
                          errorMessage: "Invalid email"),
                      const SizedBox(height: 20),
                      inputTextField(
                          "Address", const Icon(Icons.home), _address, context,
                          error: _validate["address"] ?? false,
                          errorMessage: "Enter address"),
                      const SizedBox(height: 20),
                      dropDownField<BloodGroup>(
                          "Blood Group",
                          const Icon(Icons.bloodtype_rounded),
                          bloodGroup != null
                              ? getBloodGroup(bloodGroup ?? '')
                              : null,
                          bgs,
                          onDropDownChange,
                          context,
                          error: _validate["bloodGroup"]!,
                          errorMessage: "Invalid Blood Group"),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 60,
                ),
                Container(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: Column(
                    children: [
                      outlinedButton("Update Contact", () {
                        navigateWithAnimation(
                            context,
                            VerifyPhoneNumber(widget.user!.phoneNumber,
                                isPilot:
                                    widget.userDetails?["type"] == "pilot"),
                            replace: false);
                      }, context),
                      const SizedBox(
                        height: 15,
                      ),
                      filledButton("Update", updateProfile, context,
                          loading: _loading, fullWidth: true),
                    ],
                  ),
                ),
              ]),
        ));
  }
}
