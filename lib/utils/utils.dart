import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:speed_guardian/utils/class.dart';
import 'dart:io';
import 'dart:async';

Future<User?> getCurrentUser() async {
  var currUser = FirebaseAuth.instance.currentUser;
  return currUser;
}

signOutUser() async {
  FirebaseAuth auth = FirebaseAuth.instance;
  await auth.signOut();
}

getWidth(
  BuildContext context, [
  double lowerFactor = 1,
]) {
  return MediaQuery.of(context).size.width / lowerFactor;
}

getHeight(
  BuildContext context, [
  double lowerFactor = 1,
]) {
  return MediaQuery.of(context).size.height / lowerFactor;
}

Route _createAnimatedRoute(BuildContext context, Widget page,
    [bool ltr = false]) {
  return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = ltr ? const Offset(-1.0, 0.0) : const Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.decelerate;
        final tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        final offsetAnimation = animation.drive(tween);
        return SlideTransition(position: offsetAnimation, child: child);
      });
}

void navigateWithAnimation(BuildContext context, Widget page,
    {bool ltr = false, bool replace = true}) {
  if (replace) {
    Navigator.of(context)
        .pushReplacement(_createAnimatedRoute(context, page, ltr = ltr));
  } else {
    Navigator.of(context).push(_createAnimatedRoute(context, page, ltr = ltr));
  }
}

void openSnackbar(BuildContext context, String message) {
  var snackBar = SnackBar(
    elevation: 10,
    content: Text(message),
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

copyToClipboard(String text) async {
  await Clipboard.setData(ClipboardData(text: text));
}

void closeDrawer(GlobalKey<ScaffoldState> scaffoldKey) {
  scaffoldKey.currentState!.closeDrawer();
}

void openDrawer(GlobalKey<ScaffoldState> scaffoldKey) {
  scaffoldKey.currentState!.openDrawer();
}

Color getAlertMessageType(MessageType type) {
  if (type == MessageType.success) return Colors.green[50] as Color;
  if (type == MessageType.error) return Colors.red[50] as Color;
  if (type == MessageType.warning) return Colors.yellow[50] as Color;
  if (type == MessageType.info) return Colors.blue[50] as Color;
  return Colors.blue[100] as Color;
}

Future<Map<dynamic, dynamic>> getDeviceInfo() async {
  Map<dynamic, dynamic> deviceData = <String, dynamic>{};
  DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  if (Platform.isAndroid) {
    var device = await deviceInfoPlugin.androidInfo;
    deviceData = {
      "model": device.model,
      "name": "${device.brand} ${device.device}",
      "OS": "Android",
    };
  } else if (Platform.isIOS) {
    var device = await deviceInfoPlugin.iosInfo;
    deviceData = {
      "device": device.model,
      "name": device.name,
      "OS": "iOS",
    };
  }
  return deviceData;
}
