import 'package:flutter/material.dart';

/**
 * Created by Mahesh Gubbi on 24-11-2023.
 * Bengaluru.
 */

class Constants {

  static const APIKEY = "ADD_YOUR_API_KEY";
  static const BaseURL = "https://generativelanguage.googleapis.com/v1beta2/models/text-bison-001:generateText?key=YOUR_API_KEY";

  static showCustomToast(BuildContext context, String message) {
    final snackBar = SnackBar(
      content: Text(message),
      duration: const Duration(seconds: 1),
      action: SnackBarAction(
        label: 'Close',
        onPressed: () {},
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
