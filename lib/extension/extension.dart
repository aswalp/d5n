import 'package:flutter/material.dart';

extension ContextExtensions on BuildContext {
  showSnackbar(String msg) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(
          msg,
          style: const TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void progressbar() {
    showDialog(
        context: this, builder: (_) => const CircularProgressIndicator());
  }
}
