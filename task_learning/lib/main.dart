import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:task_learning/db_helper.dart';
import 'package:task_learning/grocery_model.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(MaterialApp(home: SqLiteApp()));
}

class SqLiteApp extends StatefulWidget {
  const SqLiteApp({super.key});

  @override
  State<SqLiteApp> createState() => _SqLiteAppState();
}

class _SqLiteAppState extends State<SqLiteApp> {
  int? selectedId;
  final textController = TextEditingController();
  final descriptionController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
            appBar: AppBar(
              title: const Text("Todo App"),
            ),
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: FutureBuilder<List<Grocery>>(
                  future: DatabaseHelper.instance.getGroceries(),
                  builder: (BuildContext context,
                      AsyncSnapshot<List<Grocery>> snapshot) {
                    if (!snapshot.hasData) {
                      return Center(child: Text("Loading...."));
                    }
                    return snapshot.data!.isEmpty
                        ? const Center(
                            child: Text("No Groceries"),
                          )
                        : ListView(
                            children: snapshot.data!.map((grocery) {
                            return Center(
                              child: Card(
                                color: selectedId == grocery.id
                                    ? Colors.white70
                                    : Colors.white,
                                child: ListTile(
                                  title: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Flexible(
                                        child: Container(
                                          child: Column(
                                            children: [
                                              Text(
                                                grocery.name,
                                                style: TextStyle(),
                                              ),
                                              Text(
                                                grocery.description,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      IconButton(
                                        icon: Icon(Icons.delete),
                                        onPressed: () {
                                          setState(() {
                                            DatabaseHelper.instance
                                                .remove(grocery.id!);
                                          });
                                        },
                                      ),
                                    ],
                                  ),
                                  onTap: () {
                                    setState(() {
                                      if (selectedId == null) {
                                        textController.text = grocery.name;
                                        selectedId = grocery.id;
                                      } else {
                                        textController.text = '';
                                        selectedId = null;
                                      }
                                    });
                                  },
                                ),
                              ),
                            );
                          }).toList());
                  },
                ),
              ),
            ),
            floatingActionButton: FloatingActionButton(
              child: Icon(Icons.save),
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        scrollable: true,
                        title: const Text('Add Task'),
                        content: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Form(
                            child: Column(
                              children: <Widget>[
                                TextFormField(
                                  controller: textController,
                                  decoration: const InputDecoration(
                                    labelText: 'Title',
                                    icon: Icon(Icons.account_box),
                                  ),
                                ),
                                TextFormField(
                                  controller: descriptionController,
                                  decoration: const InputDecoration(
                                    labelText: 'Description',
                                    icon: Icon(Icons.message),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: TextButton(
                                    style: TextButton.styleFrom(
                                      backgroundColor: Colors.blue,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        selectedId != null
                                            ? DatabaseHelper.instance.update(
                                                Grocery(
                                                    id: selectedId,
                                                    name: textController.text,
                                                    description:
                                                        descriptionController
                                                            .text),
                                              )
                                            : DatabaseHelper.instance.add(
                                                Grocery(
                                                    name: textController.text,
                                                    description:
                                                        descriptionController
                                                            .text),
                                              );
                                      });
                                    },
                                    child: Text('Add',
                                        style: TextStyle(color: Colors.white)),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      );
                    });
              },
            )));
  }
}
