import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:speed_guardian/components/speed_history.dart';
import 'package:speed_guardian/components/user_location.dart';
import 'package:speed_guardian/utils/components.dart';
import 'package:lit_relative_date_time/lit_relative_date_time.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class UserDevice extends StatefulWidget {
  final String? pilotId;

  const UserDevice(this.pilotId, {super.key});

  @override
  UserDeviceState createState() => UserDeviceState();
}

class UserDeviceState extends State<UserDevice> {
  Map? pilotData;
  List? pilotDetails;

  final FirebaseDatabase _database = FirebaseDatabase.instanceFor(
      app: Firebase.app(), databaseURL: dotenv.env["DATABASE_URL"]);

  _getPrefs() async {
    final userRef = _database.ref().child("/users/${widget.pilotId}/");
    userRef.onValue.listen((event) {
      Map? data = event.snapshot.value as Map?;
      setState(() {
        pilotData = data;
        pilotDetails = [
          {
            "label": "Email",
            "text": data?["email"],
            "icon": const Icon(Icons.email)
          },
          {
            "label": "Contact",
            "text": data?["contact"],
            "icon": const Icon(Icons.phone)
          },
          {
            "label": "Guardian Code",
            "text": data?["guardianCode"],
            "icon": const Icon(Icons.code)
          },
          {
            "label": "Address",
            "text": data?["address"],
            "icon": const Icon(Icons.home)
          },
          {
            "label": "Blood Group",
            "text": data?["bloodGroup"],
            "icon": const Icon(Icons.bloodtype_rounded)
          },
          {
            "label": "Speed Limit",
            "text": data?["maxSpeed"] ?? 60,
            "icon": const Icon(Icons.speed)
          }
        ];
      });
    });
  }

  toggleTracking({bool track = true}) async {
    await _database
        .ref()
        .child('/users/${widget.pilotId}')
        .update({"track": track});
    setState(() {
      pilotData?["track"] = track;
    });
  }

  @override
  void initState() {
    super.initState();
    _getPrefs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(pilotData?["name"] ?? "",
                  style: Theme.of(context).textTheme.titleLarge,
                  textAlign: TextAlign.start),
              const SizedBox(height: 10),
              Row(
                children: [
                  const Text("Last logged in: "),
                  if (pilotData?["lastLoggedIn"] != null)
                    AnimatedRelativeDateTimeBuilder(
                      date: DateTime.parse(pilotData?["lastLoggedIn"]!),
                      builder: (relDateTime, formatted) {
                        return Text(
                          formatted,
                        );
                      },
                    ),
                  if (pilotData?["lastLoggedIn"] == null) const Text("--")
                ],
              ),
              Row(
                children: [
                  const Text("Last logged out: "),
                  if (pilotData?["lastLoggedOut"] != null)
                    AnimatedRelativeDateTimeBuilder(
                      date: DateTime.parse(pilotData?["lastLoggedOut"]!),
                      builder: (relDateTime, formatted) {
                        return Text(
                          formatted,
                        );
                      },
                    ),
                  if (pilotData?["lastLoggedIn"] == null) const Text("--")
                ],
              ),
              const SizedBox(height: 10),
              if (pilotData?["location"] != null)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Text("Speed: "),
                        Text("${pilotData?["speed"]["speed"]}"),
                      ],
                    ),
                    Row(
                      children: [
                        const Text("Speed last tracked: "),
                        AnimatedRelativeDateTimeBuilder(
                          date:
                              DateTime.parse(pilotData?["speed"]["timestamp"]!),
                          builder: (relDateTime, formatted) {
                            return Text(
                              formatted,
                            );
                          },
                        ),
                      ],
                    ),
                    UserLocation(
                      pilotData?["location"]["longitude"] as double,
                      pilotData?["location"]["latitude"] as double,
                      DateTime.parse(pilotData?["location"]["timestamp"]),
                    ),
                  ],
                ),
              Padding(
                  padding: const EdgeInsets.only(top: 30),
                  child: filledButton(
                      pilotData?["track"] ?? false
                          ? "Stop Tracking"
                          : "Start Tracking", () {
                    toggleTracking(track: !pilotData?["track"]);
                  }, context)),
              if (pilotDetails != null)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 30),
                    const Text("Pilot Details:",
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 16)),
                    const SizedBox(height: 20),
                    ...pilotDetails!.map(
                      (item) => Container(
                          margin: const EdgeInsets.only(bottom: 20),
                          child: displayData(item["label"],
                              "${item["text"] ?? "--"}", item["icon"])),
                    )
                  ],
                ),
              SpeedHistory(pilotData?["speedHistory"] ?? []),
            ]),
          ),
        ));
  }
}
