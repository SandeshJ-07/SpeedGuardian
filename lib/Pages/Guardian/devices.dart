import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:speed_guardian/Pages/Guardian/user_device.dart';
import 'package:speed_guardian/components/Dialogs/add_pilot_help.dart';
import 'package:speed_guardian/components/Dialogs/pilot_code_generate.dart';
import 'package:speed_guardian/components/Guardian/pilot_code.dart';
import 'package:speed_guardian/utils/components.dart';
import 'package:speed_guardian/utils/utils.dart';

class GuardianDevices extends StatefulWidget {
  final User? user;
  final Map? userData;
  final String? code;

  const GuardianDevices(this.user, this.userData, this.code, {super.key});

  @override
  GuardianDevicesState createState() => GuardianDevicesState();
}

class GuardianDevicesState extends State<GuardianDevices> {
  User? currUser;
  Map? userDetails;
  List<Object?>? devices;
  String? code;

  navigateToPilot(BuildContext context, String pilotId) {
    navigateWithAnimation(context, UserDevice(pilotId), replace: false);
  }

  @override
  void initState() {
    setState(() {
      currUser = widget.user;
      userDetails = widget.userData;
      devices = widget.userData?["pilots"];
      code = widget.userData?["code"];
    });
    super.initState();
  }

  refreshDevicesPage() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Stack(
        children: [
          Column(children: [
            Row(
              children: [
                Text("Devices Connected",
                    style: Theme.of(context).textTheme.titleLarge),
              ],
            ),
            PilotCode(userDetails?["code"]),
            Expanded(
                child: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: devices == null || devices!.isEmpty
                  ? const Center(
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                          Icon(Icons.info_outline,
                              size: 60, color: Colors.black12),
                          SizedBox(height: 10),
                          Text("No Device Connected"),
                        ]))
                  : SingleChildScrollView(
                      child: Column(children: [
                      ...?devices?.map((device) {
                        var dev = device as Map;
                        return deviceCard(dev["name"], dev["deviceName"], () {
                          navigateToPilot(context, dev["pilotId"]);
                        });
                      })
                    ])),
            )),
          ]),
          if (currUser?.emailVerified == true &&
              currUser?.phoneNumber != null &&
              currUser!.phoneNumber!.isNotEmpty &&
              userDetails?["code"] == null)
            circularButton(const Icon(Icons.add, color: Colors.white, size: 30),
                () {
              showPilotCodeGenerateDialog(
                  context, userDetails, refreshDevicesPage);
            }, context, bottom: 25, right: 5),
          if (userDetails?["code"] != null)
            circularButton(
                const Icon(Icons.question_mark, color: Colors.white, size: 25),
                () {
              showAddPilotHelpDialog(context);
            }, context, bottom: 25, right: 5)
        ],
      ),
    );
  }
}
