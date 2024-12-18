import 'package:d5ninterview/auth/forgotpasswordpage.dart';
import 'package:d5ninterview/auth/registerpage.dart';
import 'package:d5ninterview/const/const.dart';
import 'package:d5ninterview/extension/extension.dart';
import 'package:d5ninterview/home/categories.dart';
import 'package:d5ninterview/service/auth.dart';
import 'package:d5ninterview/widgets/textfield.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  void dispose() {
    // TODO: implement dispose
    emailcontroller.dispose();
    passwordcontroller.dispose();

    super.dispose();
  }

  final emailcontroller = TextEditingController();
  final passwordcontroller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants.bgcolor,
      body: Padding(
        padding: const EdgeInsets.all(42.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: MediaQuery.sizeOf(context).width,
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
              height: 8,
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ForgotPassword(),
                    ));
              },
              child: const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Forgot the passsword?",
                    style: TextStyle(color: Colors.grey),
                  )),
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Constants.btnColor,
                    shape: const RoundedRectangleBorder(),
                    fixedSize: Size(MediaQuery.sizeOf(context).width, 50)),
                onPressed: () async {
                  try {
                    if (emailcontroller.text.isEmpty ||
                        passwordcontroller.text.isEmpty) {
                      context.showSnackbar("fill the feilds");
                    } else {
                      AuthServices()
                          .login(emailcontroller.text, passwordcontroller.text)
                          .then((value) {
                        if (value.user == null) {
                          context.showSnackbar("something went wrong ");
                        } else {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const CategoriesPage(),
                            ),
                            (route) => false,
                          );
                        }
                      });
                    }
                  } catch (e) {
                    context.showSnackbar("something went wrong ");
                  }
                },
                child: const Text(
                  "Continue",
                  style: TextStyle(color: Colors.white),
                )),
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
      ),
    );
  }
}
