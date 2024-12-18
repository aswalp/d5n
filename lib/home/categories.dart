import 'package:d5ninterview/const/const.dart';
import 'package:d5ninterview/home/setting.dart';
import 'package:d5ninterview/home/taskpage.dart';
import 'package:d5ninterview/service/auth.dart';
import 'package:d5ninterview/service/user.dart';
import 'package:d5ninterview/widgets/textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CategoriesPage extends ConsumerStatefulWidget {
  const CategoriesPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CategoriesPageState();
}

class _CategoriesPageState extends ConsumerState<CategoriesPage> {
  final titlecontroller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants.bgcolor,
      appBar: AppBar(
        leading: Padding(
          padding: EdgeInsets.all(8.0),
          child: GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Settings(),
                    ));
              },
              child: CircleAvatar()),
        ),
        elevation: 0,
        backgroundColor: Constants.bgcolor,
        centerTitle: true,
        title: const Text(
          "Categories",
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.search,
                color: Colors.white,
              ))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Constants.innerColor,
                ),
                child: const Row(
                  children: [
                    CircleAvatar(),
                    SizedBox(
                      width: 8,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '"The memories is a sheild and life helper"',
                          style: TextStyle(fontSize: 13, color: Colors.white),
                        ),
                        Text(
                          'Thomas',
                          style: TextStyle(fontSize: 8, color: Colors.grey),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              ref.watch(getCategorieyProvider).when(
                    data: (data) {
                      if (data != null) {
                        return GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: data.docs.length + 1,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  mainAxisSpacing: 14,
                                  crossAxisSpacing: 14),
                          itemBuilder: (context, index) {
                            if (index == 0) {
                              return InkWell(
                                onTap: () {
                                  showDialog(
                                    barrierDismissible: false,
                                    context: context,
                                    builder: (context) {
                                      return SimpleDialog(
                                        contentPadding:
                                            const EdgeInsets.all(16),
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: [
                                              IconButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                icon: const Icon(
                                                  Icons.close,
                                                  color: Colors.black,
                                                ),
                                              ),
                                              UiTextField(
                                                hint: "Title",
                                                controller: titlecontroller,
                                              ),
                                              const SizedBox(
                                                height: 20,
                                              ),
                                              ElevatedButton(
                                                  style: ElevatedButton.styleFrom(
                                                      backgroundColor:
                                                          Constants.btnColor,
                                                      shape:
                                                          RoundedRectangleBorder()),
                                                  onPressed: () async {
                                                    if (titlecontroller
                                                        .text.isNotEmpty) {
                                                      ref
                                                          .watch(
                                                              userDataServiceProvider)
                                                          .addCategory(
                                                            ref
                                                                .watch(
                                                                    authServicesProvider)
                                                                .auth
                                                                .currentUser!
                                                                .uid,
                                                            titlecontroller
                                                                .text,
                                                          );
                                                      titlecontroller.clear();
                                                    }
                                                  },
                                                  child: const Text(
                                                    "Add",
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ))
                                            ],
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                                child: Container(
                                  height: 50,
                                  width: 50,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: Constants.innerColor,
                                  ),
                                  child: const Icon(
                                    size: 48,
                                    Icons.add_circle,
                                    color: Colors.white,
                                  ),
                                ),
                              );
                            }

                            final category = data.docs[index - 1];
                            return InkWell(
                              onTap: () {
                                ref.read(getCategoryIdProvider.notifier).state =
                                    category.id;
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => TaskPage(
                                        categoryId: category.id,
                                        head: category
                                            .data()
                                            .categoryname
                                            .toString(),
                                      ),
                                    ));
                              },
                              child: Container(
                                height: 50,
                                width: 50,
                                decoration: BoxDecoration(
                                  color: Constants.innerColor,
                                ),
                                child: Column(
                                  children: [
                                    const SizedBox(
                                      height: 30,
                                    ),
                                    Text(
                                      category.data().categoryname,
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    Text("${category.data().tasknumber} Task",
                                        style: TextStyle(color: Colors.white)),
                                    const Spacer(),
                                    Align(
                                      alignment: Alignment.bottomRight,
                                      child: IconButton(
                                          onPressed: () {
                                            showDialog(
                                              context: context,
                                              builder: (context) => AlertDialog(
                                                title: const Text(
                                                    "Are you sure ?"),
                                                content: const Text(
                                                    "This category will be deleted ."),
                                                actions: [
                                                  ElevatedButton(
                                                    style: ElevatedButton.styleFrom(
                                                        backgroundColor:
                                                            Constants.btnColor,
                                                        shape:
                                                            RoundedRectangleBorder()),
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                    },
                                                    child: Text(
                                                      "Cancel",
                                                      style: TextStyle(
                                                          color: Colors.white),
                                                    ),
                                                  ),
                                                  ElevatedButton(
                                                    style: ElevatedButton.styleFrom(
                                                        backgroundColor:
                                                            Constants.btnColor,
                                                        shape:
                                                            RoundedRectangleBorder()),
                                                    onPressed: () {
                                                      ref
                                                          .watch(
                                                              userDataServiceProvider)
                                                          .deleteCategory(
                                                              ref
                                                                  .read(
                                                                      authProvider)
                                                                  .value!
                                                                  .uid,
                                                              category.id);
                                                      Navigator.pop(context);
                                                    },
                                                    child: const Text(
                                                      "Delete",
                                                      style: TextStyle(
                                                          color: Colors.white),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
                                          icon: const Icon(
                                            Icons.delete,
                                            color: Colors.white,
                                          )),
                                    )
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      } else {
                        return const SizedBox();
                      }
                    },
                    error: (error, stackTrace) =>
                        Center(child: Text(error.toString())),
                    loading: () =>
                        const Center(child: CircularProgressIndicator()),
                  ),
            ],
          ),
        ),
      ),
    );
  }
}
