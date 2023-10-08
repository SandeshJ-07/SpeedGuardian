import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class SidebarRoutes {
  const SidebarRoutes(
      this.label, this.icon, this.selectedIcon, this.page, this.index);

  final String label;
  final Widget icon;
  final Widget selectedIcon;
  final Widget page;
  final int index;
}

class UserDetails {
  const UserDetails(this.name, this.email, this.contact, this.id, this.code,
      this.address, this.bloodGroup);

  final String name;
  final String email;
  final String contact;
  final String id;
  final String? code;
  final String? address;
  final String? bloodGroup;
}

enum BloodGroup {
  aPOSITIVE,
  aNEGATIVE,
  bPOSITIVE,
  bNEGATIVE,
  abPOSITIVE,
  abNEGATIVE,
  oPOSITIVE,
  oNEGATIVE,
}

enum UserType { guardian, pilot }

class DropDownMenuItemClass<T> {
  late final T value;
  late Widget child;

  @override
  DropDownMenuItemClass(this.value, this.child);
}

enum MessageType {
  success,
  error,
  warning,
  info,
}

class DeviceCardInfo {
  late String? name;
  late String? deviceName;
  late String? pilotId;

  DeviceCardInfo(this.name, this.deviceName, this.pilotId);
}

class LocationInfo {
  late Position position;
  late DateTime timestamp;

  LocationInfo(this.position, this.timestamp);
}

class SpeedInfo {
  late int speed;
  late DateTime timestamp;

  SpeedInfo(this.speed, this.timestamp);
}

class NotificationData {
  late bool read;
  late String text;
  late DateTime timestamp;
  late String title;

  NotificationData(this.title, this.text, this.timestamp, this.read);
}
