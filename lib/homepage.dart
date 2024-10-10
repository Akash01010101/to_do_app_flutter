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
      todoList.removeAt(index);
      saveprefs(); // Save changes after deletion
    });
  }

  void loadprefs() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? loadedList = prefs.getStringList('todo_list');

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

  void saveprefs() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> stringList = todoList.map((item) {
      return '${item[0]}|${item[1]}'; // Join text and status with a delimiter
    }).toList();
    await prefs.setStringList('todo_list', stringList);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 169, 84, 238),
      appBar: AppBar(
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
