import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
    readData();
  }

  var titleController = TextEditingController();
  var taskController = TextEditingController();
  var taskBox = Hive.box("taskBox");
  List<Map<String, dynamic>> ourTasks = [];

  // Create data in Hive database

  createData(Map<String, dynamic> data) async {
    await taskBox.add(data);
    readData();
  }

  // read Data from Hive database
  readData() async {
    var data = taskBox.keys.map((key) {
      final item = taskBox.get(key);
      return {"key": key, "title": item["title"], "task": item["task"]};
    }).toList();

    setState(() {
      ourTasks = data.reversed.toList();
    });
  }

  showFormModel(context, int? key) async {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => Padding(
        padding: EdgeInsets.fromLTRB(
            12, 12, 12, MediaQuery.of(context).viewInsets.bottom),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(hintText: "Enter Title"),
            ),
            SizedBox(
              height: 10,
            ),
            TextField(
              controller: taskController,
              decoration: InputDecoration(hintText: "Enter Task"),
            ),
            SizedBox(
              height: 10,
            ),
            ElevatedButton(
                onPressed: () {
                  var data = {
                    "title": titleController.text,
                    "task": taskController.text
                  };
                  createData(data);
                  Navigator.pop(context);
                },
                child: Text("Add Task")),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showFormModel(context, null);
          },
          child: Icon(Icons.add),
        ),
        appBar: AppBar(
          title: Text("My ToDo List"),
        ),
        body: ListView.builder(
            itemCount: ourTasks.length,
            itemBuilder: (BuildContext context, int index) {
              var currentTask = ourTasks[index];
              return Card(
                color: Color.fromARGB(255, 185, 241, 218),
                child: ListTile(
                  title: Text(currentTask["title"]),
                  subtitle: Text(currentTask["task"]),
                ),
              );
            }));
  }
}
