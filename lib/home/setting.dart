import 'dart:developer';
import 'dart:io';

import 'package:d5ninterview/auth/loginpage.dart';
import 'package:d5ninterview/const/const.dart';
import 'package:d5ninterview/service/auth.dart';
import 'package:d5ninterview/service/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

class Settings extends ConsumerStatefulWidget {
  const Settings({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SettingsState();
}

class _SettingsState extends ConsumerState<Settings> {
  final ImagePicker picker = ImagePicker();
  String? _image;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants.bgcolor,
      appBar: AppBar(
        backgroundColor: Constants.bgcolor,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.white,
            )),
        centerTitle: true,
        title: const Text(
          "Settings",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: ref.watch(getUserProvider).when(
          data: (data) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  ListTile(
                    leading: CircleAvatar(
                      backgroundImage:
                          _image != null ? FileImage(File(_image!)) : null,
                    ),
                    title: Text(
                      data!.data()!.userName,
                      style: const TextStyle(color: Colors.white),
                    ),
                    subtitle: Text(
                      data.data()!.email,
                      style: const TextStyle(color: Colors.white),
                    ),
                    trailing: IconButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text("Selected image"),
                              actions: [
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Constants.btnColor,
                                      shape: RoundedRectangleBorder()),
                                  onPressed: () {
                                    getimageGallery();
                                    Navigator.pop(context);
                                  },
                                  child: Text(
                                    "Gallery",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Constants.btnColor,
                                      shape: RoundedRectangleBorder()),
                                  onPressed: () {
                                    getimageCamera();
                                    Navigator.pop(context);
                                  },
                                  child: const Text(
                                    "Camera",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                        icon: const Icon(
                          Icons.border_color,
                          color: Colors.white,
                        )),
                  ),
                  Text(
                    "hi my name ${data.data()!.userName}",
                    style: const TextStyle(color: Colors.white),
                  ),
                  const ListTile(
                    leading: Icon(
                      Icons.notifications,
                      color: Colors.white,
                    ),
                    title: Text(
                      "Notifications",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  const ListTile(
                    leading: Icon(
                      Icons.settings,
                      color: Colors.white,
                    ),
                    title: Text(
                      "General",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  ListTile(
                    onTap: () {},
                    leading: const Icon(
                      Icons.person,
                      color: Colors.white,
                    ),
                    title: const Text(
                      "Account",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  ListTile(
                    onTap: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginPage(),
                        ),
                        (route) => false,
                      ).then(
                        (value) {
                          ref.watch(authServicesProvider).logout();
                        },
                      );
                    },
                    leading: Icon(
                      Icons.logout,
                      color: Colors.white,
                    ),
                    title: Text(
                      "logout",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            );
          },
          error: (error, stackTrace) => Center(child: Text(error.toString())),
          loading: () => const Center(child: CircularProgressIndicator())),
    );
  }

  getimageGallery() async {
    final XFile? image =
        await picker.pickImage(source: ImageSource.gallery, imageQuality: 60);

    if (image != null) {
      log("path:-${image.path}");
      setState(() {
        _image = image.path;
      });
    }
  }

  getimageCamera() async {
    final XFile? image =
        await picker.pickImage(source: ImageSource.camera, imageQuality: 60);

    if (image != null) {
      log("path:-${image.path}");
      setState(() {
        _image = image.path;
      });
    }
  }
}
