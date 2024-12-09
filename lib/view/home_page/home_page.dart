// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todoo/controller/provider.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _textFieldController = TextEditingController();
  String newTask = '';
  //creating initState() for adding listener to controller
  @override
  void initState() {
    super.initState();
    _textFieldController.addListener(() {
      newTask = _textFieldController.text;
    });
  }

  //disposing the controller
  @override
  void dispose() {
    _textFieldController.dispose();
    super.dispose();
  }

  void _submit() {
    //we aren't interested in updating our ui so listen will be false
    Provider.of<TodoProvider>(context, listen: false).addTask(newTask);
    //cancelling the dialog
    Navigator.pop(context);
    _textFieldController.clear();
  }

  @override
  Widget build(BuildContext context) {
    Future<void> showAddTextDialog() async {
      return showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text("Add a new Task"),
              content: TextField(
                autofocus: true,
                controller: _textFieldController,
                decoration: const InputDecoration(hintText: "Add New Task"),
                onSubmitted: (_) => _submit(),
              ),
              actions: [
                ElevatedButton(
                  onPressed: _submit,
                  style: ElevatedButton.styleFrom(
                      minimumSize: const Size(120, 40)),
                  child: const Text("Submit"),
                )
              ],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              actionsAlignment: MainAxisAlignment.center,
            );
          });
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        centerTitle: true,
        title: const Text(
          "ToDo App",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        leading: IconButton(onPressed: () {}, icon: Icon(Icons.menu)),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(Icons.person),
          )
        ],
      ),
      body: const TodoAction(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.amber,
        onPressed: (() {
          showAddTextDialog();
        }),
        tooltip: "Add a todo",
        child: const Icon(Icons.add),
      ),
    );
  }
}

class TodoAction extends StatelessWidget {
  const TodoAction({super.key});
  @override
  Widget build(BuildContext context) {
    //store the value in a variable
    final task = Provider.of<TodoProvider>(context);
    return ListView.builder(
      itemCount: task.allTasks.length,
      itemBuilder: ((context, index) => ListTile(
            leading: Checkbox(
              // toggle the task as index item
              value: task.allTasks[index].completed,
              onChanged: ((_) => task.toggleTask(task.allTasks[index])),
            ),
            //show all the task title
            title: Text(task.allTasks[index].todoTitle),
            trailing: IconButton(
                onPressed: () {
                  //delete task as index item
                  task.deleteTask(task.allTasks[index]);
                },
                icon: const Icon(Icons.delete)),
          )),
    );
  }
}
