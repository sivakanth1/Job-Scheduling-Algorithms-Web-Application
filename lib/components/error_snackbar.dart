import 'package:flutter/material.dart';

SnackBar snackBar(String errorMessage) {
  return SnackBar(
    backgroundColor: Colors.lightBlueAccent,
    content: Text(
      errorMessage,
      style: const TextStyle(fontSize: 20.0, color: Colors.white),
    ),
    duration: const Duration(milliseconds: 1500),
    width: 280.0, // Width of the SnackBar.
    padding: const EdgeInsets.all(15.0),
    behavior: SnackBarBehavior.floating,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10.0),
    ),
  );
}
