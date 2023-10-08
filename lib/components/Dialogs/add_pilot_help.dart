import 'package:flutter/material.dart';

Future<void> showAddPilotHelpDialog(
  BuildContext context,
) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Colors.white,
        titleTextStyle: const TextStyle(
            fontSize: 20, color: Colors.black, fontWeight: FontWeight.w600),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        title: const Text("Add Device"),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Column(children: [
                const Text(
                    'You can add your family\'s device by registering them as a pilot.\n\nWhile registration, you need to provide your email and guardian code to track your other device.\n'),
                RichText(
                    text: const TextSpan(
                        style: TextStyle(color: Colors.black),
                        children: [
                      TextSpan(
                          text: 'Note:',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      TextSpan(text: ' Everytime new code is generated.')
                    ])),
              ]),
              const SizedBox(height: 20)
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Close', style: TextStyle(color: Colors.black)),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
