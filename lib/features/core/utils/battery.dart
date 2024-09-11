import 'package:flutter/material.dart';

IconData getBatteryIcon(int? batteryLevel) {
  if (batteryLevel == null) {
    return Icons.battery_unknown;
  }

  if (batteryLevel >= 95) {
    return Icons.battery_full;
  } else if (batteryLevel >= 80) {
    return Icons.battery_6_bar;
  } else if (batteryLevel >= 70) {
    return Icons.battery_5_bar;
  } else if (batteryLevel >= 55) {
    return Icons.battery_4_bar;
  } else if (batteryLevel >= 40) {
    return Icons.battery_3_bar;
  } else if (batteryLevel >= 25) {
    return Icons.battery_2_bar;
  } else if (batteryLevel >= 10) {
    return Icons.battery_1_bar;
  } else {
    return Icons.battery_0_bar;
  }
}
