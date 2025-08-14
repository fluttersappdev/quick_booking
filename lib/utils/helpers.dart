import 'package:flutter/material.dart';

import 'app_constants.dart' show AppConstants;

class Helpers {
  static Color getStatusColor(String status) {
    if (status.contains('On Time')) return Colors.green;
    if (status.contains('Delayed')) return Colors.orange;
    if (status.contains('Arrived')) return Colors.blue;
    return Colors.grey;
  }

  static String formatTime(String time) {
    // In a real app, this would parse and format the time properly
    return time;
  }

  static void showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.cardBorderRadius),
        ),
      ),
    );
  }

  static Future<void> simulateNetworkCall({int milliseconds = 800}) async {
    await Future.delayed(Duration(milliseconds: milliseconds));
  }
}