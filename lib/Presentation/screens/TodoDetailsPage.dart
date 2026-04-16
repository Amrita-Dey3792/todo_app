import 'package:flutter/material.dart';
import 'package:todo_app/data/models/Todo.dart';

class TodoDetailsPage extends StatelessWidget {
  final Todo todo;

  const TodoDetailsPage({super.key, required this.todo});

  Color getPriorityColor(Priority p) {
    switch (p) {
      case Priority.high:
        return Colors.red;
      case Priority.medium:
        return Colors.orange;
      case Priority.low:
        return Colors.green;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Todo Details"),
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // TITLE
            Text(
              todo.title,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 12),

            // PRIORITY CHIP
            Row(
              children: [
                Icon(Icons.flag, color: getPriorityColor(todo.priority)),
                const SizedBox(width: 6),
                Text(
                  todo.priority.name.toUpperCase(),
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: getPriorityColor(todo.priority),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            const Text(
              "Description",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 8),

            Text(
              todo.description.isEmpty ? "No description" : todo.description,
              style: const TextStyle(fontSize: 15),
            ),

            const SizedBox(height: 20),

            // STATUS
            Row(
              children: [
                Icon(
                  todo.isCompleted
                      ? Icons.check_circle
                      : Icons.radio_button_unchecked,
                  color: todo.isCompleted ? Colors.green : Colors.grey,
                ),
                const SizedBox(width: 8),
                Text(
                  todo.isCompleted ? "Completed" : "Not Completed",
                  style: const TextStyle(fontSize: 15),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
