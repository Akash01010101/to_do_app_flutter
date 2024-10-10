import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class Todo extends StatelessWidget {
  const Todo(
      {super.key,
      required this.tname,
      required this.comp,
      required this.onChanged,
      required this.del});
  final String tname;
  final bool comp;
  final Function(bool?)? onChanged;
  final Function(BuildContext)? del;
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(
          top: 20,
          left: 20,
          right: 20,
          bottom: 0,
        ),
        child: Slidable(
          endActionPane: ActionPane(motion: const StretchMotion(), children: [
            SlidableAction(
              onPressed: del,
              icon: Icons.delete,
            )
          ]),
          child: Container(
            decoration: BoxDecoration(
                color: const Color.fromARGB(255, 228, 85, 247),
                borderRadius: BorderRadius.circular(22)),
            padding: const EdgeInsets.all(24),
            child: Row(
              children: [
                Checkbox(
                  value: comp,
                  onChanged: onChanged,
                  checkColor: const Color.fromARGB(255, 0, 0, 0),
                  activeColor: const Color.fromARGB(255, 171, 0, 250),
                ),
                Text(
                  tname,
                  style: TextStyle(
                      decoration: comp
                          ? TextDecoration.lineThrough
                          : TextDecoration.none,
                      color: const Color.fromARGB(255, 0, 0, 0),
                      fontSize: 22),
                ),
              ],
            ),
          ),
        ));
  }
}
