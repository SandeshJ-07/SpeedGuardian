import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:speed_guardian/Pages/edit_profile.dart';
import 'package:speed_guardian/utils/components.dart';
import 'package:speed_guardian/utils/utils.dart';

import 'Dialogs/send_email_verification_dialog.dart';
import 'Dialogs/verify_phone_number.dart';

Widget getProfileCompletionStep(
    BuildContext context, User? currUser, int step, Map? userData){
  switch (step) {
    case 1:
      return filledButton("Verify Email", () {
        sendEmailVerificationDialog(context, currUser);
      }, context);
    case 2:
      return filledButton("Add contact", () {
        navigateWithAnimation(context, GuardianEditProfile(currUser, userData));
      }, context);
    case 3:
      return filledButton("Verify Contact", (){
        navigateWithAnimation(context, VerifyPhoneNumber(currUser!.phoneNumber));
      }, context);
    case 4:
      return filledButton("Add blood group", (){navigateWithAnimation(context, GuardianEditProfile(currUser, userData));}, context);
    case 5:
      return filledButton("Add address", (){navigateWithAnimation(context, GuardianEditProfile(currUser, userData));}, context);
    default:
      return Container();
  }
}
