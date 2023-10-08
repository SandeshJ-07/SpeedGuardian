import 'package:flutter/material.dart';
import 'package:speed_guardian/Pages/Guardian/notifications.dart';
import 'package:speed_guardian/utils/utils.dart';

PreferredSizeWidget appBar(BuildContext context, int screenIndex) {
  return AppBar(
    backgroundColor:
        screenIndex == 0 ? const Color.fromRGBO(47, 143, 175, 1) : Colors.white,
    actions: [
      if (screenIndex == 0)
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: IconButton(
            icon: const Icon(
              Icons.notifications,
              color: Colors.white,
            ),
            onPressed: () {
              navigateWithAnimation(context, const Notifications(), replace: false);
            },
          ),
        )
    ],
  );
}
