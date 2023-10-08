import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:lit_relative_date_time/widget/animated_relative_date_time_builder.dart';
import 'package:speed_guardian/utils/utils.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../../utils/class.dart';

class Notifications extends StatefulWidget {
  const Notifications({super.key});

  @override
  NotificationState createState() => NotificationState();
}

class NotificationState extends State<Notifications> {
  Map? userData;
    List<NotificationData> notifications = [];

  final FirebaseDatabase _database = FirebaseDatabase.instanceFor(
      app: Firebase.app(),
      databaseURL:
      dotenv.env["DATABASE_URL"]);

  _getPrefs() async {
    User? user = await getCurrentUser();
    final userRef = _database.ref().child("/users/${user!.uid}/");
    final snapshot = await userRef.get();
    if (snapshot.exists) {
      var data = snapshot.value as Map;
      var notis = data["notifications"] as List;
      var notifics = notis
          .map((noti) =>
          NotificationData(noti["title"], noti["text"],
              DateTime.parse(noti['timestamp']), noti["read"]))
          .toList();
      notifics.sort((a, b) {
        return b.timestamp.compareTo(a.timestamp);
      });
      setState(() {
        userData = data;
        notifications = notifics;
      });
    }
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
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Notifications",
                      style: Theme
                          .of(context)
                          .textTheme
                          .titleLarge,
                      textAlign: TextAlign.start),
                  const SizedBox(
                    height: 20,
                  ),
                  ...notifications.map((notification) =>
                      Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 20, horizontal: 15),
                        margin: const EdgeInsets.only(bottom: 10),
                        decoration: BoxDecoration(
                          color: Colors.black12,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(notification.title,
                              style: const TextStyle(fontWeight: FontWeight
                                  .w500),),
                            const SizedBox(height: 5,),
                            Text(notification.text),
                            const SizedBox(height: 15,),
                            Row(
                              children: [
                                const Expanded(child: SizedBox()),
                                AnimatedRelativeDateTimeBuilder(
                                  date: notification.timestamp,
                                  builder: (relDateTime, formatted) {
                                    return Text(
                                      formatted,
                                    );
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ))
                ],
              ),
            ),
          ),
        ));
  }
}
