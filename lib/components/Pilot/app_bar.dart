import 'package:flutter/material.dart';

PreferredSizeWidget appBar(int screenIndex) {
  return AppBar(
    backgroundColor:
    screenIndex == 0 ? const Color.fromRGBO(47, 143, 175, 1) : Colors.white,
  );
}
