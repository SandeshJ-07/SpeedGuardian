import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:speed_guardian/Pages/login.dart';
import 'package:speed_guardian/utils/components.dart';
import 'package:speed_guardian/utils/utils.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class RegisterPilot extends StatefulWidget {
  const RegisterPilot({super.key});

  @override
  RegisterPilotState createState() => RegisterPilotState();
}

class RegisterPilotState extends State<RegisterPilot> {
  final _formKey = GlobalKey<FormState>();
  final _code = TextEditingController();
  final _name = TextEditingController();
  final _email = TextEditingController();

  bool _loading = false;
  var _validate = {
    "code": false,
    "name": false,
    "email": false,
  };

  @override
  void dispose() {
    _code.dispose();
    _name.dispose();
    _email.dispose();
    super.dispose();
  }

  // Firebase Auth And Storage
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseDatabase databaseMain = FirebaseDatabase.instance;
  final FirebaseDatabase _database = FirebaseDatabase.instanceFor(
      app: Firebase.app(),
      databaseURL:
          dotenv.env["DATABASE_URL"]);

  Future<User?> signupWithEmailPass(
      String email, String password, String name) async {
    try {
      UserCredential credential = await auth.createUserWithEmailAndPassword(
          email: email, password: password);
      credential.user?.updateDisplayName(name);
      return credential.user;
    } catch (e) {

      return null;
    }
  }

  void _signup() async {
    FocusManager.instance.primaryFocus?.unfocus();
    String name = _name.text;
    String code = _code.text;
    String email = _email.text;

    String? guardianId;

    setState(() {
      _loading = true;
      _validate = {
        "name": false,
        "email": false,
        "code": false,
      };
    });

    if (name.isEmpty) _validate["name"] = true;
    if (email.isEmpty ||
        !RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
            .hasMatch(email)) _validate["email"] = true;
    if (code.isEmpty) _validate["code"] = true;

    if (_validate["name"]! || _validate["email"]! || _validate["code"]!) {
      setState(() {
        _loading = false;
      });
      return;
    }

    final codeRef = _database.ref().child("/code").child(code);
    final snapshot = await codeRef.get();
    if (snapshot.exists) {
      Map? data = snapshot.value as Map?;
      if (data == null) {
        setState(() {
          _loading = false;
        });
        _validate["code"] = true;
        return;
      } else {
        setState(() {
          guardianId = data["id"];
        });
        Map deviceInfo = await getDeviceInfo();
        try {
          if (guardianId == null) {
            setState(() {
              _loading = false;
            });
            return;
          }
          User? user = await signupWithEmailPass(email, code, name);
          if (user == null) {
            setState(() {
              _loading = false;
            });
            return;
          }
          user.sendEmailVerification();
          final pilotRef = _database.ref().child("/users");
          await pilotRef.child(user.uid).set({
            "id": user.uid,
            "name": name,
            "guardianCode": code,
            "email": email,
            "guardianId": guardianId,
            "deviceInfo": deviceInfo,
            "type": "pilot",
            "track": false,
          });
          List data = [];
          List notis = [];
          final guardianRef =
              _database.ref().child('/users').child(guardianId!);
          final snapshot = await guardianRef.get();
          if (snapshot.exists) {
            Map? gData = snapshot.value as Map;
            if (gData["pilots"] != null) data = gData["pilots"];
            if (gData["notifications"] != null) {
              notis = gData["notifications"];
            }
          }
          notis.add({
            "read": false,
            "text":
                "${deviceInfo["name"]} has been added to your devices under name: $name",
            "title": "New device added",
            "timestamp": DateTime.now().toString(),
          });
          data.add({
            "pilotId": user.uid,
            "name": name,
            "deviceName": deviceInfo["name"],
          });
          await guardianRef
              .update({"pilots": data, "code": null, "notifications": notis});
          await _database.ref().child("/code").child(code).remove();
          _email.clear();
          _name.clear();
          _code.clear();
          setState(() {
            _loading = false;
          });
          await Future.delayed(const Duration(seconds: 1));
          if(context.mounted) openSnackbar(context, "Registration Successful");
          if(context.mounted) navigateWithAnimation(context, const LoginPage());
        } catch (e) {
          setState(() {
            _loading = false;
          });
          if(context.mounted) openSnackbar(context, "Registration Failed: $e");
        }
      }
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: SingleChildScrollView(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
              inputTextField(
                  "Username", const Icon(Icons.person), _name, context,
                  error: _validate["name"] ?? false,
                  errorMessage: "Invalid name"),
              const SizedBox(height: 20),
              inputTextField(
                  "Pilot Email", const Icon(Icons.email), _email, context,
                  error: _validate["email"] ?? false,
                  errorMessage: "Invalid email"),
              const SizedBox(height: 20),
              inputTextField(
                  "Guardian Code", const Icon(Icons.code), _code, context,
                  error: _validate["code"] ?? false,
                  errorMessage: "Invalid code",
                  maxLen: 6),
              const SizedBox(height: 30),
              SizedBox(
                  width: getWidth(context, 1.3),
                  child: filledButton("Register device", _signup, context,
                      loading: _loading, disabled: _loading))
            ])));
  }
}
