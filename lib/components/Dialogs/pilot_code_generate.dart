import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:speed_guardian/Pages/Guardian/index.dart';
import 'package:speed_guardian/utils/components.dart';
import 'package:speed_guardian/utils/utils.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';


Future<void> showPilotCodeGenerateDialog(
    BuildContext context, Map? userDetails, Function refreshDevicePage) async {
  String? genCode;
  bool loading = false;

// Firebase Storage
  final FirebaseDatabase database = FirebaseDatabase.instanceFor(
      app: Firebase.app(),
      databaseURL:
          dotenv.env["DATABASE_URL"]);

  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return StatefulBuilder(builder: (context, setState) {
        generateCode() async {
          setState(() {
            loading = true;
          });
          var uuid = const Uuid();
          var id = uuid.v1().substring(0, 6);
          final databaseRef = database.ref();
          if (userDetails?["code"] != null) {
            await databaseRef
                .child('/code')
                .child(userDetails?["code"])
                .remove();
          }
          await databaseRef
              .child("/users")
              .child(userDetails?["id"])
              .update({"code": id});
          await databaseRef
              .child("/code")
              .child(id)
              .update({"id": userDetails?["id"]});
          setState(() {
            loading = false;
            genCode = id;
          });
          if (context.mounted) navigateWithAnimation(context, GuardianIndex(screenIndex:0));
        }

        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
          title: const Text("Guardian Code"),
          titleTextStyle: const TextStyle(
              fontSize: 20, color: Colors.black, fontWeight: FontWeight.w600),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                loading
                    ? Image.asset("assets/images/loadingD.gif", height: 50)
                    : genCode == null
                        ? const Column(children: [
                            Text(
                                'By generating a Guardian code, you can connect to your family\'s devices and track their location and speed.\n'),
                            Text(
                                'You will need to provide your guardian code, while registering for the pilot\'s device.'),
                          ])
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                                Text('${genCode!}\n',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w500)),
                                const Text(
                                    'You need to provide your guardian code, while registering for your pilot\'s device.\n'),
                                RichText(
                                    text: const TextSpan(
                                        style: TextStyle(color: Colors.black),
                                        children: [
                                      TextSpan(
                                          text: 'Note:',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold)),
                                      TextSpan(
                                          text:
                                              ' Everytime new code is generated.')
                                    ])),
                              ]),
                const SizedBox(height: 20)
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child:
                  const Text('Cancel', style: TextStyle(color: Colors.black)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            if (genCode == null && loading == false)
              ElevatedButton(
                style:
                    ElevatedButton.styleFrom(backgroundColor: themeColor(0.8)),
                child: const Text('Generate',
                    style: TextStyle(color: Colors.white)),
                onPressed: () {
                  generateCode();
                },
              ),
            if (genCode != null && loading == false)
              TextButton(
                child: const Text('Copy', style: TextStyle(color: themeBlue)),
                onPressed: () async {
                  openSnackbar(context, "Code copied to clipboard!");
                  copyToClipboard(genCode!);
                  Navigator.of(context).pop();
                },
              ),
          ],
        );
      });
    },
  );
}
