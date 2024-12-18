import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:d5ninterview/models/taskmodel.dart';

class CategoryModel {
  String categoryname;

  int? tasknumber;
  List<TaskModel>? tasks;
  CategoryModel({required this.categoryname, this.tasknumber,this.tasks});

  factory CategoryModel.fromFirebase(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return CategoryModel(
      categoryname: data?["categoryname"],
      tasknumber: data?["tasknumber"],
      tasks:(data?["tasks"] as List<dynamic>?)
          ?.map((task) => TaskModel.fromMap(task as Map<String, dynamic>))
          .toList()
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      "categoryname": categoryname,
      "tasknumber": tasknumber,
      "task":tasks?.map((task) => task.toMap()).toList(),
    };
  }
}
