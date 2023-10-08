import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:speed_guardian/Pages/Guardian/index.dart';
import 'package:speed_guardian/utils/utils.dart';

import '../../Pages/Pilot/index.dart';
import '../../utils/components.dart';

class VerifyPhoneNumber extends StatefulWidget {
  final String? contact;
  bool? isPilot;
  VerifyPhoneNumber(this.contact, {bool isPilot = true,super.key});

  @override
  VerifyPhoneNumberState createState() => VerifyPhoneNumberState();
}

class VerifyPhoneNumberState extends State<VerifyPhoneNumber> {
  final auth = FirebaseAuth.instance;
  late final Future<User?> firebaseUser;
  var verificationId = '';

  final _contact = TextEditingController();
  final _otp = TextEditingController();

  bool _loading = false;
  bool codeSent = false;

  @override
  void initState() {
    super.initState();
    _contact.text = widget.contact ?? "";
  }

  void phoneAuthentication() async {
    setState(() {
      _loading = true;
    });
    var phoneNo = _contact.text;
    phoneNo = phoneNo.contains('+91') ? phoneNo : '+91$phoneNo';

    await auth.verifyPhoneNumber(
      phoneNumber: phoneNo,
      verificationCompleted: (credentials) async {
        setState(() {
          _loading = false;
        });
        User? user = auth.currentUser;
        user!.updatePhoneNumber(credentials);
        if(widget.isPilot == true){
         navigateWithAnimation(context, PilotIndex(screenIndex:2));
        }else {
          navigateWithAnimation(context, GuardianIndex(screenIndex: 2));
        }
        openSnackbar(context, "Verification Completed");
      },
      codeSent: (verificationId, resendToken) {
        setState(() {
          _loading = false;
        });
        openSnackbar(context, "OTP has been sent");
        setState(() {
          codeSent = true;
        });
        this.verificationId = verificationId;
      },
      codeAutoRetrievalTimeout: (verificationId) {
        setState(() {
          _loading = false;
        });
        this.verificationId = verificationId;
        openSnackbar(context, 'OTP Timeout');
      },
      verificationFailed: (e) {
        setState(() {
          _loading = false;
        });
        if (e.code == 'invalid-phone-number') {
          const snackBar = SnackBar(
            content: Text('Provided phone number is invalid!'),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        } else {
          const snackBar = SnackBar(
            content: Text('Something went wrong!'),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
      },
    );
  }

  verifyOTP() async {
    setState(() {
      _loading = true;
    });
    try {
      var otp = _otp.text;
      await auth.currentUser!.updatePhoneNumber(PhoneAuthProvider.credential(
          verificationId: verificationId, smsCode: otp));
      setState(() {
        _loading = false;
      });
      if(context.mounted) openSnackbar(context, "OTP verified successfully");
      if(context.mounted) navigateWithAnimation(context, GuardianIndex(), ltr: true);
    } catch (e) {
      if(context.mounted) openSnackbar(context, "OTP verification failed");
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Verify Contact",
                    style: Theme.of(context).textTheme.titleLarge,
                    textAlign: TextAlign.start),
                const SizedBox(height: 40),
                inputTextField(
                    "Contact", const Icon(Icons.phone), _contact, context,
                    enabled: !codeSent && !_loading),
                const SizedBox(height: 20),
                inputTextField("OTP", const Icon(Icons.code), _otp, context,
                    enabled: !_loading && codeSent, maxLen: 6),
                const SizedBox(height: 10),
                verificationId.isEmpty
                    ? filledButton("Send OTP", phoneAuthentication, context,
                        loading: _loading)
                    : filledButton("Verify", verifyOTP, context,
                        loading: _loading),
              ],
            )),
      ),
    );
  }
}
