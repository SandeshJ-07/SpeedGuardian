import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:speed_guardian/Pages/login.dart';
import 'package:speed_guardian/utils/utils.dart';
import 'package:speed_guardian/utils/class.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';


class Sidebar extends StatefulWidget {
  final int selectedScreen;
  final Function(int selectedScreen) handleScreenChanged;
  final List<SidebarRoutes> routes;
  final Function syncData;

  const Sidebar(
      this.selectedScreen, this.handleScreenChanged, this.routes, this.syncData,
      {super.key});

  @override
  SidebarState createState() => SidebarState();
}

class SidebarState extends State<Sidebar> {
  User? currUser;
  late Function syncData;

  void getPrefs() async {
    User? user = await getCurrentUser();
    setState(() {
      currUser = user;
      syncData = widget.syncData;
    });
  }

  @override
  void initState() {
    getPrefs();
    super.initState();
  }

  final FirebaseDatabase _database = FirebaseDatabase.instanceFor(
      app: Firebase.app(),
      databaseURL:
          dotenv.env["DATABASE_URL"]);

  void logout() async {
    await signOutUser();
    await _database
        .ref()
        .child("/users/${currUser!.uid}")
        .update({"lastLoggedOut": DateTime.now().toString()});
    await Future.delayed(const Duration(seconds: 1));
    if (context.mounted) navigateWithAnimation(context, const LoginPage());
  }

  @override
  Widget build(BuildContext context) {
    return NavigationDrawer(
      indicatorColor: const Color.fromRGBO(53, 147, 175, 0.7),
      indicatorShape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(5),
        ),
      ),
      onDestinationSelected: widget.handleScreenChanged,
      selectedIndex: widget.selectedScreen,
      children: <Widget>[
        Container(
          alignment: Alignment.centerLeft,
          child: const Padding(
            padding: EdgeInsets.only(left: 30, bottom: 0),
            child: CircleAvatar(
              backgroundImage: AssetImage("assets/images/avatar.png"),
              radius: 20,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(28, 10, 16, 10),
          child: Text(
            '${currUser?.displayName}',
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        const Padding(
          padding: EdgeInsets.all(8),
          child: Divider(
            thickness: 1,
            color: Colors.black12,
          ),
        ),
        ...widget.routes.map(
          (SidebarRoutes destination) {
            return NavigationDrawerDestination(
              label: Text(destination.label,
                  style: TextStyle(
                    color: widget.selectedScreen == destination.index
                        ? Colors.white
                        : Colors.black,
                  )),
              icon: destination.icon,
              selectedIcon: destination.selectedIcon,
            );
          },
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 3),
          child: Divider(
            thickness: 1,
            color: Colors.black12,
          ),
        ),
        TextButton(
            onPressed: () {
              syncData();
            },
            style: TextButton.styleFrom(
              foregroundColor: const Color.fromRGBO(53, 147, 175, 0.4), padding: EdgeInsets.zero,
              alignment: Alignment.centerLeft,
            ),
            child: const Row(
              children: [
                SizedBox(width: 30),
                Icon(
                  Icons.sync,
                  color: Colors.black,
                ),
                SizedBox(width: 10),
                Text("Sync", style: TextStyle(color: Colors.black)),
              ],
            )),
        TextButton(
            onPressed: logout,
            style: TextButton.styleFrom(
              foregroundColor: const Color.fromRGBO(53, 147, 175, 0.4), padding: EdgeInsets.zero,
              alignment: Alignment.centerLeft,
            ),
            child: const Row(
              children: [
                SizedBox(width: 30),
                Icon(
                  Icons.logout,
                  color: Colors.black,
                ),
                SizedBox(width: 10),
                Text("Logout", style: TextStyle(color: Colors.black)),
              ],
            )),
        const Padding(
          padding: EdgeInsets.only(left: 8.0, right: 8, top: 3, bottom: 8),
          child: Divider(
            thickness: 1,
            color: Colors.black12,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Text("SpeedGuardian",
              style: Theme.of(context).textTheme.titleSmall),
        ),
      ],
    );
  }
}
