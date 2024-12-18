import 'package:d5ninterview/const/const.dart';
import 'package:flutter/material.dart';

class UiTextField extends StatelessWidget {
  UiTextField({super.key, required this.hint, this.controller});

  String hint;
  TextEditingController? controller;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.sizeOf(context).width * 0.75,
      child: TextField(
        controller: controller,
        style: TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.grey),
          filled: true,
          fillColor: Constants.innerColor,
          border: InputBorder.none,
        ),
      ),
    );
  }
}
