import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:speed_guardian/Pages/Pilot/home.dart';
import 'package:speed_guardian/Pages/Pilot/profile.dart';
import 'package:speed_guardian/Pages/help.dart';
import 'package:speed_guardian/components/Pilot/app_bar.dart';
import 'package:speed_guardian/components/Pilot/sidebar.dart';
import 'package:speed_guardian/utils/class.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../../utils/utils.dart';

class PilotIndex extends StatefulWidget {
  int screenIndex = 0;

  PilotIndex({this.screenIndex = 0, super.key});

  @override
  PilotIndexState createState() => PilotIndexState();
}

class PilotIndexState extends State<PilotIndex> {
  User? currUser;
  Map? userData, guardianData;

  List<Object>? speedHistory;
  int speedLimit = 30;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  int screenIndex = 0;
  late bool showSidebar;
  StreamSubscription? _getPositionSubscription;

  final FirebaseDatabase _database = FirebaseDatabase.instanceFor(
      app: Firebase.app(),
      databaseURL:
          dotenv.env["DATABASE_URL"]);

  _handleLocationPermission() async {
    LocationPermission permission;

    await Geolocator.isLocationServiceEnabled();
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        if (context.mounted) {
          openSnackbar(context, 'Location permissions are denied');
        }
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      if (context.mounted) {
        openSnackbar(context,
            "Location permissions are permanently denied, we cannot request permissions.");
      }
      return false;
    }
    return true;
  }

  _getCurrentPosition() async {
    const LocationSettings locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 0,
    );
    final hasPermission = await _handleLocationPermission();
    if (!hasPermission) return null;
    _getPositionSubscription =
        Geolocator.getPositionStream(locationSettings: locationSettings)
            .listen((Position position) {
      final pilotRef = _database.ref().child("/users/${currUser?.uid}");

      pilotRef.update({
        "speed": {
          "speed": position.speed,
          "timestamp": position.timestamp.toString()
        },
        "location": {
          "latitude": position.latitude,
          "longitude": position.longitude,
          "timestamp": position.timestamp.toString()
        }
      });
      if (position.speed > speedLimit) {
        speedHistory = [
          ...?speedHistory,
          {"speed": position.speed, "timestamp": DateTime.now().toString()}
        ];
        pilotRef.set({"speedHistory": speedHistory});
      }
    });
  }

  @override
  void dispose() {
    _getPositionSubscription?.cancel();
    super.dispose();
  }

  _getPrefs([int screenInd = 0]) async {
    User? user = await getCurrentUser();
    final userRef = _database.ref().child("/users/${user!.uid}/");
    setState(() {
      currUser = user;
      screenIndex = screenInd;
    });
    userRef.onValue.listen((event) async {
      Map? data = event.snapshot.value as Map?;
      setState(() {
        userData = data;
        speedHistory = data?["speedHistory"] ?? [];
        speedLimit = data?["speedLimit"] ?? 30;
      });
      if (data?["track"] == true) {
        _getCurrentPosition();
      }
    });
    final guardianRef =
        _database.ref().child("/users/${userData?["guardianId"]}");
    final guardianSnapshot = await guardianRef.get();
    if (guardianSnapshot.exists) {
      Map? data = guardianSnapshot.value as Map?;
      setState(() {
        guardianData = data;
      });
    }
  }

  syncData() {
    _getPrefs(screenIndex);
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
       SidebarRoutes(
          'Home',
          const Icon(Icons.home_outlined),
          const Icon(Icons.home, color: Colors.white),
          PilotHome(currUser,userData),
          0),
      SidebarRoutes(
          'Profile',
          const Icon(Icons.person_2_outlined),
          const Icon(Icons.person_2, color: Colors.white),
          PilotProfile(currUser, userData, guardianData),
          1),
      const SidebarRoutes('Help', Icon(Icons.help_outline),
          Icon(Icons.help, color: Colors.white), Help(), 2)
    ];
    return Scaffold(
        key: scaffoldKey,
        appBar: appBar(screenIndex),
        drawer:
            Sidebar(screenIndex, handleDrawerScreenChanged, routes, syncData),
        body: SafeArea(
          top: true,
          child: currUser != null
              ? routes.elementAt(screenIndex).page
              : const Center(
                  child: Text("Loading...",
                      style: TextStyle(color: Colors.blueGrey))),
        ));
  }
}
