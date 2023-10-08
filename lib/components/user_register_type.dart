import 'package:flutter/material.dart';
import 'package:speed_guardian/utils/components.dart';
import 'package:speed_guardian/utils/utils.dart';
import '../utils/class.dart';
import 'Forms/register_guardian.dart';
import 'Forms/register_pilot.dart';

class UserRegisterType extends StatefulWidget {
  const UserRegisterType({super.key});

  @override
  UserRegisterTypeState createState() => UserRegisterTypeState();
}

class UserRegisterTypeState extends State<UserRegisterType> {
  UserType userType = UserType.guardian;

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      SizedBox(
        width: getWidth(context, 1.2),
        child: SegmentedButton<UserType>(
          selectedIcon: const Icon(Icons.person),
          style: ButtonStyle(
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(3.0),
                      side: const BorderSide(color: Colors.red))),
              backgroundColor: MaterialStateProperty.resolveWith<Color>(
                    (Set<MaterialState> states) {
                  if (states.contains(MaterialState.selected)) {
                    return themeColor(0.7);
                  }
                  return Colors.black12;
                },
              ),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              visualDensity: const VisualDensity(horizontal: -1, vertical: -1),
              side: MaterialStateProperty.resolveWith<BorderSide>(
                      (Set<MaterialState> states) {
                    return const BorderSide(color: Colors.black12);
                  })),
          segments: const <ButtonSegment<UserType>>[
            ButtonSegment<UserType>(
              value: UserType.guardian,
              label: Text("Guardian"),
            ),
            ButtonSegment<UserType>(
              value: UserType.pilot,
              label: Text("Pilot"),
            ),
          ],
          selected: <UserType>{userType},
          onSelectionChanged: (Set<UserType> newSelection) {
            setState(() {
              userType = newSelection.first;
            });
          },
        ),
      ),
      const SizedBox(height: 30),
      userType == UserType.guardian ? const RegisterGuardianForm() : const RegisterPilot()
    ]);
  }
}
