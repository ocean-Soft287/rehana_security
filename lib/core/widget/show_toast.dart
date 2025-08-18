import 'package:flutter/material.dart';

void showToast(BuildContext context, String message) {
  final scaffold = ScaffoldMessenger.of(context);
  scaffold.showSnackBar(
    SnackBar(
      content: Text(message),
      behavior: SnackBarBehavior.floating,
      duration: const Duration(seconds: 2),
      margin: EdgeInsets.only(
        bottom: MediaQuery.of(context).size.height - 100,
        left: 20,
        right: 20,
      ),
    ),
  );
}
