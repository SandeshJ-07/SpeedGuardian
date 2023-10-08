import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:speed_guardian/Pages/Guardian/index.dart';
import 'package:speed_guardian/utils/utils.dart';

import '../../Pages/Pilot/index.dart';
import '../../utils/components.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ConfirmPhoneNumber extends StatefulWidget {
  final String? contact;
  final String? userType;

  const ConfirmPhoneNumber(this.contact, this.userType, {super.key});

  @override
  ConfirmPhoneNumberState createState() => ConfirmPhoneNumberState();
}

class ConfirmPhoneNumberState extends State<ConfirmPhoneNumber> {
  final auth = FirebaseAuth.instance;
  late final Future<User?> firebaseUser;
  var verificationId = '';
  String? userType;
  final _contact = TextEditingController();
  final _otp = TextEditingController();

  bool _loading = false;
  bool codeSent = false;

  final FirebaseDatabase _database = FirebaseDatabase.instanceFor(
      app: Firebase.app(),
      databaseURL:
          dotenv.env["DATABASE_URL"]);

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

        final userRef = _database.ref().child("users/${user.uid}");
        userRef.update({"contact": phoneNo});
        if (userType == "pilot") {
          if (context.mounted) {
            navigateWithAnimation(context, PilotIndex(screenIndex: 0));
          } else {
            if (context.mounted) {
              navigateWithAnimation(context, GuardianIndex(screenIndex: 0));
            }
          }
        }
        if (context.mounted) openSnackbar(context, "Verification Completed");
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
      var phoneNo = _contact.text;
      phoneNo = phoneNo.contains('+91') ? phoneNo : '+91$phoneNo';
      User? user = auth.currentUser;
      final userRef = _database.ref().child("users/${user?.uid}");
      userRef.update({"contact": phoneNo});

      if (context.mounted) openSnackbar(context, "OTP verified successfully");
      if (context.mounted) {
        navigateWithAnimation(context, GuardianIndex(), ltr: true);
      }
    } catch (e) {
      if (context.mounted) openSnackbar(context, "OTP verification failed");
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _contact.text = widget.contact!;
    userType = widget.userType;
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
