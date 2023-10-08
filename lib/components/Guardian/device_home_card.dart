import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:speed_guardian/Pages/Guardian/index.dart';
import 'package:speed_guardian/utils/components.dart';
import 'package:speed_guardian/utils/utils.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../../Pages/Guardian/user_device.dart';

class DeviceHomeCard extends StatefulWidget {
  const DeviceHomeCard({super.key});

  @override
  DeviceHomeCardState createState() => DeviceHomeCardState();
}

class DeviceHomeCardState extends State<DeviceHomeCard> {
  List? deviceList = [];
  Map? userData;

  final FirebaseDatabase _database = FirebaseDatabase.instanceFor(
      app: Firebase.app(),
      databaseURL:
      dotenv.env["DATABASE_URL"]);

  _getPrefs() async {
    User? user = await getCurrentUser();
    final userRef = _database.ref().child("/users/${user!.uid}/pilots");
    final snapshot = await userRef.get();
    if(snapshot.exists){
      setState(() {
        deviceList = snapshot.value as List;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _getPrefs();
  }
  navigateToPilot(BuildContext context, String pilotId) {
    navigateWithAnimation(context, UserDevice(pilotId), replace: false);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(15, 20, 15, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Device Connected",
              style: TextStyle(fontSize: 21, fontWeight: FontWeight.w500)),
          const SizedBox(
            height: 10,
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              border: Border.all(width: 0, color: Colors.transparent),
            ),
            child: SizedBox(
                height: deviceList!.isEmpty ? 200 : getHeight(context, 6),
                child: deviceList!.isEmpty
                    ? const Center(
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                            Icon(Icons.info_outline,
                                size: 40, color: Colors.black12),
                            SizedBox(height: 10),
                            Text("No Device Connected"),
                          ]))
                    : SizedBox(
                        width: getWidth(context),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              ...?deviceList?.map(
                                (device) {
                                  return deviceCardHome(deviceList?[0]["name"],
                                      device["deviceName"], () {
                                    navigateToPilot(
                                        context, deviceList?[0]["pilotId"]);
                                  }, context);
                                },
                              ),
                              addDeviceCardHome(() {
                                navigateWithAnimation(
                                    context, GuardianIndex(screenIndex: 1));
                              }, context),
                            ],
                          ),
                        ))),
          ),
        ],
      ),
    );
  }
}
