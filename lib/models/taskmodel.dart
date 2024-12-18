import 'package:cloud_firestore/cloud_firestore.dart';

class TaskModel {
  String taskname;
  bool isCompeleted;
  TaskModel({required this.taskname, required this.isCompeleted});
  factory TaskModel.fromMap(Map<String, dynamic> map) {
    return TaskModel(
      taskname: map["taskname"] ?? "",
      isCompeleted: map["isCompeleted"] ?? false,
    );
  }
  Map<String, dynamic> toMap() {
    return {
      "taskname": taskname,
      "isCompeleted": isCompeleted,
    };
  }

  factory TaskModel.fromFirebase(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return TaskModel(
      taskname: data?["taskname"],
      isCompeleted: data?["isCompeleted"],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      "taskname": taskname,
      "isCompeleted": isCompeleted,
    };
  }
}
