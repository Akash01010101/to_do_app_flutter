import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:to_do_app/Todo.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _controller = TextEditingController();
  List todoList = [];
  int p = 0;
  @override
  void initState() {
    super.initState();
    loadprefs(); // Load preferences when the widget is initialized
  }

  void sav() {
    if (_controller.text.isNotEmpty) {
      setState(() {
        todoList.add([_controller.text, false]);
        _controller.clear();
        saveprefs(); // Save the updated list after adding a new item
      });
    }
  }

  void change(int index) {
    setState(() {
      todoList[index][1] = !todoList[index][1]; // Toggle completion status
      saveprefs(); // Save changes after toggling
    });
  }

  void del(int index) {
    setState(() {
      if (todoList[index][1] == true) {
        p = p + 10;
        _showDialog(context, "10 points will be awarded");
      } else {
        if (p >= 10) {
          p = p - 10;
          _showDialog(context, "10 points will be deducted");
        } else {
          _showDialog(context, "You're broke");
        }
      }
      todoList.removeAt(index);
      saveprefs(); // Save changes after deletion
    });
  }

  void loadprefs() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? loadedList = prefs.getStringList('todo_list');
    int? pts = prefs.getInt('ps');
    if (pts != null) {
      p = pts ?? 0;
    }
    if (loadedList != null) {
      setState(() {
        todoList = loadedList.map((item) {
          List<String> parts = item.split('|'); // Split to get text and status
          return [
            parts[0], // Todo text
            parts[1] == 'true' // Todo completed status
          ];
        }).toList();
      });
    }
  }

  void _showDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Alert'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
          ],
        );
      },
    );
  }

  void saveprefs() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> stringList = todoList.map((item) {
      return '${item[0]}|${item[1]}'; // Join text and status with a delimiter
    }).toList();
    await prefs.setStringList('todo_list', stringList);
    await prefs.setInt('ps', p);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 169, 84, 238),
      appBar: AppBar(
        leading: Center(
          child: Text(
            "Pts: $p",
            style: const TextStyle(fontSize: 20),
          ),
        ),
        title: const Center(child: Text("Todo App")),
        backgroundColor: const Color.fromARGB(255, 250, 75, 212),
      ),
      body: ListView.builder(
          itemCount: todoList.length,
          itemBuilder: (BuildContext context, index) {
            return Todo(
                tname: todoList[index][0],
                comp: todoList[index][1],
                onChanged: (value) => change(index),
                del: (context) => del(index));
          }),
      bottomNavigationBar: ElevatedButton(
        child: const Text("Rules"),
        onPressed: () => {
          _showDialog(context,
              "10 Points will be creadited if a completed task is deleted \n10 points will be deducted if an incomplete task is deleted")
        },
      ),
      floatingActionButton: Row(children: [
        Expanded(
            child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: TextField(
            controller: _controller,
            decoration: InputDecoration(
                hintText: "Add Todo",
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: const BorderSide(
                        color: Color.fromARGB(255, 80, 1, 67))),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: const BorderSide(
                        color: Color.fromARGB(255, 80, 1, 67)))),
          ),
        )),
        FloatingActionButton(
          onPressed: sav,
          child: const Icon(Icons.add),
        ),
      ]),
    );
  }
}
