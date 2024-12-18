import 'package:d5ninterview/const/const.dart';
import 'package:d5ninterview/extension/extension.dart';
import 'package:d5ninterview/models/taskmodel.dart';
import 'package:d5ninterview/service/auth.dart';
import 'package:d5ninterview/service/user.dart';
import 'package:d5ninterview/widgets/textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TaskPage extends ConsumerStatefulWidget {
  const TaskPage({
    super.key,
    this.head,
    required this.categoryId,
  });
  final String? head;
  final String categoryId;

  @override
  ConsumerState<TaskPage> createState() => _TaskPageState();
}

class _TaskPageState extends ConsumerState<TaskPage> {
  TextEditingController taskController = TextEditingController();

  @override
  void dispose() {
    taskController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants.bgcolor,
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.white,
            )),
        backgroundColor: Constants.bgcolor,
        title: Text(
          widget.head.toString(),
          style: const TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: ref.watch(getTaskProvider).when(
          data: (data) {
            if (data.docs.isEmpty) {
              return const Center(
                child: Text(
                  "No task found",
                  style: TextStyle(color: Colors.white),
                ),
              );
            }
            return Padding(
              padding: const EdgeInsets.all(20.0),
              child: ListView.separated(
                  itemBuilder: (context, index) {
                    return ListTile(
                      tileColor: Constants.innerColor,
                      leading: Checkbox(
                        shape: const CircleBorder(),
                        checkColor: Colors.white,
                        activeColor: Colors.green,
                        value: data.docs[index].data().isCompeleted,
                        onChanged: (value) {
                          ref.watch(userDataServiceProvider).completeTask(
                                ref.read(authProvider).value!.uid,
                                widget.categoryId,
                                data.docs[index].id,
                                data.docs[index].data().isCompeleted,
                              );
                        },
                      ),
                      title: Text(
                        data.docs[index].data().taskname,
                        style: TextStyle(color: Colors.white),
                      ),
                      trailing: IconButton(
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: ((context) => AlertDialog(
                                      title: Text(
                                        "Are you sure ?",
                                      ),
                                      content:
                                          const Text("This task will delete"),
                                      actions: [
                                        ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                                backgroundColor:
                                                    Constants.btnColor,
                                                shape:
                                                    RoundedRectangleBorder()),
                                            onPressed: (() {
                                              Navigator.of(context).pop();
                                            }),
                                            child: const Text(
                                              "Cancel",
                                              style: TextStyle(
                                                  color: Colors.white),
                                            )),
                                        ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                                backgroundColor:
                                                    Constants.btnColor,
                                                shape:
                                                    RoundedRectangleBorder()),
                                            onPressed: (() {
                                              ref
                                                  .watch(
                                                      userDataServiceProvider)
                                                  .deleteTask(
                                                      ref
                                                          .read(authProvider)
                                                          .value!
                                                          .uid,
                                                      widget.categoryId,
                                                      data.docs[index].id);
                                              Navigator.of(context).pop();
                                            }),
                                            child: const Text(
                                              "Delete",
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ))
                                      ],
                                    )));
                          },
                          icon: const Icon(
                            Icons.delete,
                            color: Colors.white,
                          )),
                    );
                  },
                  separatorBuilder: (context, index) => const SizedBox(
                        height: 10,
                      ),
                  itemCount: data.docs.length),
            );
          },
          error: (error, stackTrace) => Center(child: Text(error.toString())),
          loading: () => const Center(child: CircularProgressIndicator())),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        // foregroundColor:Colors.white,
        shape: const CircleBorder(),
        onPressed: () {
          showDialog(
            barrierDismissible: false,
            context: context,
            builder: (context) {
              return SimpleDialog(
                contentPadding: const EdgeInsets.all(16),
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: const Icon(
                            Icons.close,
                            color: Colors.black,
                          )),
                      UiTextField(
                          hint: "Type your task...",
                          controller: taskController),
                      const SizedBox(
                        height: 16,
                      ),
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Constants.btnColor,
                            shape: const RoundedRectangleBorder(),
                          ),
                          onPressed: () {
                            if (taskController.text.isNotEmpty) {
                              ref.read(userDataServiceProvider).addTask(
                                  ref.read(authProvider).value!.uid,
                                  ref.read(getCategoryIdProvider).toString(),
                                  TaskModel(
                                      taskname: taskController.text,
                                      isCompeleted: false));
                              taskController.clear();
                              Navigator.pop(context);
                            } else {
                              context.showSnackbar("Please fill the fields");
                            }
                          },
                          child: const Text(
                            "Add",
                            style: TextStyle(color: Colors.white),
                          ))
                      // ButtonWidget(
                      //     text: "Add",
                      //     onpressed: () {
                    ],
                  ),
                ],
              );
            },
          );
        },
        child: const Icon(
          Icons.add,
          size: 32,
        ),
      ),
    );
  }
}
