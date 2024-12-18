import 'package:cloud_firestore/cloud_firestore.dart';

class UserDataModel {
  String userName;
  String email;
  String? image;
  UserDataModel({
    required this.userName,
    required this.email,
    this.image,
  });

  factory UserDataModel.fromFirebase(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return UserDataModel(
        userName: data?["userName"],
        email: data?["email"],
        image: data?["image"]);
  }

  Map<String, dynamic> toFirestore() {
    return {"userName": userName, "email": email, "image": image};
  }
}
