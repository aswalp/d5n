import 'package:d5ninterview/auth/registerpage.dart';
import 'package:d5ninterview/const/const.dart';
import 'package:d5ninterview/widgets/textfield.dart';
import 'package:flutter/material.dart';

class ForgotPassword extends StatelessWidget {
  const ForgotPassword({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants.bgcolor,
      body: Column(
        children: [
          const SizedBox(
            height: 100,
          ),
          Row(
            children: [
              IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                  )),
              const SizedBox(
                width: 30,
              ),
              const Text(
                "Forgot Password",
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ],
          ),
          const SizedBox(
            height: 30,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 45.0),
            child: Column(
              children: [
                UiTextField(hint: "Email"),
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  "Enter the email address you need to create your account and we wiil email you a link to reset your password",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const RegisterPage(),
                        ));
                  },
                  child: RichText(
                    text: const TextSpan(
                      text: "Dont't have an account?",
                      children: [
                        TextSpan(
                            text: 'Register',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.underline)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
