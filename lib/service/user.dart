import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:d5ninterview/models/categorymodel.dart';
import 'package:d5ninterview/models/taskmodel.dart';
import 'package:d5ninterview/models/userdatamodel.dart';
import 'package:d5ninterview/service/auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserDataService {
  final CollectionReference<UserDataModel> userDataCollection =
      FirebaseFirestore.instance.collection("userDatas").withConverter(
            fromFirestore: UserDataModel.fromFirebase,
            toFirestore: (UserDataModel value, options) => value.toFirestore(),
          );
  Future<DocumentSnapshot<UserDataModel>> getuserData(String uid) {
    return userDataCollection.doc(uid).get();
  }

  Future<void> registerUser(
    String name,
    String email,
    String id,
  ) {
    return userDataCollection.doc(id).set(
          UserDataModel(
            userName: name,
            email: email,
          ),
        );
  }

  Future<DocumentSnapshot<UserDataModel>> getUser(String uid) {
    return userDataCollection.doc(uid).get();
  }

  Future<DocumentReference<CategoryModel>> addCategory(
    String id,
    String name,
  ) {
    return userDataCollection
        .doc(id)
        .collection("category")
        .withConverter(
          fromFirestore: CategoryModel.fromFirebase,
          toFirestore: (CategoryModel contact, options) =>
              contact.toFirestore(),
        )
        .add(CategoryModel(categoryname: name, tasknumber: 0));
  }

  Stream<QuerySnapshot<CategoryModel>> getCategories(String id) {
    return userDataCollection
        .doc(id)
        .collection("category")
        .withConverter(
          fromFirestore: CategoryModel.fromFirebase,
          toFirestore: (CategoryModel category, options) =>
              category.toFirestore(),
        )
        .snapshots();
  }

  Stream<DocumentSnapshot<CategoryModel>> getCategory(
      String id, String categoryId) {
    return userDataCollection
        .doc(id)
        .collection("category")
        .withConverter(
          fromFirestore: CategoryModel.fromFirebase,
          toFirestore: (CategoryModel category, options) =>
              category.toFirestore(),
        )
        .doc(categoryId)
        .snapshots();
  }

  Future<void> deleteCategory(String id, String categoryId) {
    return userDataCollection
        .doc(id)
        .collection("category")
        .doc(categoryId)
        .delete();
  }

  /// TASK

  Future<void> addTask(String uid, String categoryId, TaskModel data) async {
    await userDataCollection
        .doc(uid)
        .collection("category")
        .doc(categoryId)
        .collection("tasks")
        .withConverter(
          fromFirestore: TaskModel.fromFirebase,
          toFirestore: (TaskModel value, options) => value.toFirestore(),
        )
        .add(data);
    await userDataCollection
        .doc(uid)
        .collection('category')
        .doc(categoryId)
        .update({
      'tasknumber': FieldValue.increment(1),
    });
  }

  Stream<QuerySnapshot<TaskModel>> getTask(String uid, String categoryId) {
    return userDataCollection
        .doc(uid)
        .collection("category")
        .doc(categoryId)
        .collection("tasks")
        .withConverter(
          fromFirestore: TaskModel.fromFirebase,
          toFirestore: (TaskModel value, options) => value.toFirestore(),
        )
        .snapshots();
  }

  Future<void> completeTask(
      String userId, String categoryId, String taskId, bool iscomplected) {
    return userDataCollection
        .doc(userId)
        .collection('category')
        .doc(categoryId)
        .collection('tasks')
        .doc(taskId)
        .update({'isCompeleted': !iscomplected});
  }

  Future<void> deleteTask(
      String userId, String categoryId, String taskId) async {
    await userDataCollection
        .doc(userId)
        .collection('category')
        .doc(categoryId)
        .collection('tasks')
        .doc(taskId)
        .delete();
    await userDataCollection
        .doc(userId)
        .collection('category')
        .doc(categoryId)
        .update({
      'tasknumber': FieldValue.increment(-1),
    });
  }
}

final userDataServiceProvider = Provider<UserDataService>((ref) {
  return UserDataService();
});
final getCategorieyProvider =
    StreamProvider<QuerySnapshot<CategoryModel>?>((ref) {
  return ref.watch(authProvider).value == null
      ? const Stream.empty()
      : ref
          .read(userDataServiceProvider)
          .getCategories(ref.read(authProvider).value!.uid);
});

final getCategoryIdProvider = StateProvider<String?>((ref) {
  return null;
});
final getTaskProvider = StreamProvider<QuerySnapshot<TaskModel>>((ref) {
  var uid = ref.watch(authProvider).value?.uid;
  var categoryId = ref.watch(getCategoryIdProvider);
  return uid == null
      ? const Stream.empty()
      : ref.read(userDataServiceProvider).getTask(uid, categoryId!);
});

final getUserProvider = FutureProvider<DocumentSnapshot<UserDataModel>?>((ref) {
  var authState = ref.watch(authProvider);
  var userservice = ref.read(userDataServiceProvider);
  return authState.value == null
      ? null
      : userservice.getUser(authState.value!.uid);
});
