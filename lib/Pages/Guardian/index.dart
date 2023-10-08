import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:speed_guardian/Pages/Guardian/devices.dart';
import 'package:speed_guardian/Pages/Guardian/home.dart';
import 'package:speed_guardian/Pages/Guardian/profile.dart';
import 'package:speed_guardian/Pages/help.dart';
import 'package:speed_guardian/components/Guardian/app_bar.dart';
import 'package:speed_guardian/components/Guardian/sidebar.dart';
import 'package:speed_guardian/utils/class.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../../utils/utils.dart';

class GuardianIndex extends StatefulWidget {
  int screenIndex = 0;

  GuardianIndex({this.screenIndex = 0, super.key});

  @override
  GuardianIndexState createState() => GuardianIndexState();
}

class GuardianIndexState extends State<GuardianIndex> {
  User? currUser;
  Map? userData;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  int screenIndex = 0;
  late bool showSidebar;
  String? code;
  List<NotificationData>? notifications;

  final FirebaseDatabase _database = FirebaseDatabase.instanceFor(
      app: Firebase.app(),
      databaseURL:
          dotenv.env["DATABASE_URL"]);

  _getPrefs([int screenInd = 0]) async {
    User? user = await getCurrentUser();
    final userRef = _database.ref().child("/users/${user!.uid}/");
    setState(() {
      currUser = user;
      screenIndex = screenInd;
    });
    userRef.onValue.listen((event) {
      Map? data = event.snapshot.value as Map?;
      setState(() {
        userData = data;
        code = data?["code"];
      });
      if (userData?["email"] != user.email) {
        userRef.update({"email": user.email});
      }
    });
  }

  syncData() {
    int ind = screenIndex;
    _getPrefs(ind);
  }

  @override
  void initState() {
    super.initState();
    _getPrefs(widget.screenIndex);
  }

  void handleDrawerScreenChanged(int selectedScreen) {
    setState(() {
      screenIndex = selectedScreen;
    });
    closeDrawer(scaffoldKey);
  }

  @override
  Widget build(BuildContext context) {
    List<SidebarRoutes> routes = <SidebarRoutes>[
       SidebarRoutes('Home', const Icon(Icons.home_outlined),
          const Icon(Icons.home, color: Colors.white), GuardianHome(currUser,userData), 0),
      SidebarRoutes(
          'Devices',
          const Icon(Icons.phone_android_rounded),
          const Icon(Icons.phone_android_sharp, color: Colors.white),
          GuardianDevices(currUser, userData, code),
          1),
      SidebarRoutes(
          'Profile',
          const Icon(Icons.person_2_outlined),
          const Icon(Icons.person_2, color: Colors.white),
          GuardianProfile(currUser, userData),
          2),
      const SidebarRoutes('Help', Icon(Icons.help_outline),
          Icon(Icons.help, color: Colors.white), Help(), 3)
    ];
    return Scaffold(
      key: scaffoldKey,
      appBar: appBar(context, screenIndex),
      drawer: Sidebar(screenIndex, handleDrawerScreenChanged, routes, syncData),
      body: SafeArea(
        top: true,
        child: currUser != null
            ? GestureDetector(
                onHorizontalDragEnd: (details) {
                  if (details.primaryVelocity! > 0) {
                    openDrawer(scaffoldKey);
                  }
                },
                child: routes.elementAt(screenIndex).page,
              )
            : const Center(
                child: Text("Loading...",
                    style: TextStyle(color: Colors.blueGrey))),
      ),
    );
  }
}
