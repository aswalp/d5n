import 'dart:developer';

import 'package:d5ninterview/auth/loginpage.dart';
import 'package:d5ninterview/const/const.dart';
import 'package:d5ninterview/extension/extension.dart';
import 'package:d5ninterview/home/categories.dart';
import 'package:d5ninterview/service/auth.dart';
import 'package:d5ninterview/service/user.dart';
import 'package:d5ninterview/widgets/textfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  @override
  void dispose() {
    // TODO: implement dispose
    emailcontroller.dispose();
    usernamecontroller.dispose();

    passwordcontroller.dispose();

    confpasswordcontroller.dispose();

    super.dispose();
  }

  final emailcontroller = TextEditingController();
  final usernamecontroller = TextEditingController();
  final passwordcontroller = TextEditingController();
  final confpasswordcontroller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants.bgcolor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
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
                "Create An Account",
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(45.0),
            child: Column(
              children: [
                UiTextField(
                  hint: "Full Name",
                  controller: usernamecontroller,
                ),
                const SizedBox(
                  height: 20,
                ),
                UiTextField(
                  hint: "Email",
                  controller: emailcontroller,
                ),
                const SizedBox(
                  height: 20,
                ),
                UiTextField(
                  hint: "Password",
                  controller: passwordcontroller,
                ),
                const SizedBox(
                  height: 20,
                ),
                UiTextField(
                  hint: "Confirm Password",
                  controller: confpasswordcontroller,
                ),
                const SizedBox(
                  height: 30,
                ),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Constants.btnColor,
                        shape: const RoundedRectangleBorder(),
                        fixedSize: Size(MediaQuery.sizeOf(context).width, 50)),
                    onPressed: () async {
                      try {
                        if (usernamecontroller.text.isEmpty ||
                            emailcontroller.text.isEmpty ||
                            passwordcontroller.text.isEmpty ||
                            confpasswordcontroller.text.isEmpty) {
                          context.showSnackbar("completed the feilds");
                        } else if (passwordcontroller.text !=
                                confpasswordcontroller.text ||
                            passwordcontroller.text.length > 6) {
                          context.showSnackbar(
                              "password do not match or minimum 6 letters needed ");
                        } else {
                          UserCredential userCredential = await AuthServices()
                              .createAccount(emailcontroller.text,
                                  passwordcontroller.text);
                          if (userCredential.user != null) {
                            await UserDataService()
                                .registerUser(
                              usernamecontroller.text,
                              emailcontroller.text,
                              userCredential.user!.uid,
                            )
                                .then((value) {
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const CategoriesPage(),
                                ),
                                (route) => false,
                              );
                            });
                          } else {
                            context.showSnackbar("showthing went wrong");
                            log("error 1");
                          }
                        }
                      } catch (e) {
                        context.showSnackbar("showthing went wrong");
                        log("error 2 $e.");
                      }
                    },
                    child: const Text(
                      "Continue",
                      style: TextStyle(color: Colors.white),
                    )),
                const SizedBox(
                  height: 30,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginPage(),
                        ));
                  },
                  child: RichText(
                    text: const TextSpan(
                      text: "Already have an Account?",
                      children: [
                        TextSpan(
                            text: 'Login',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.underline)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
