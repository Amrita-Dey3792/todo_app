import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/Presentation/providers/TodoProvider.dart';
import 'package:todo_app/data/models/Todo.dart';


class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

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
    final provider = context.watch<TodoProvider>();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          provider.currentFilter == null
              ? "TO-DO (All)"
              : "TO-DO (${provider.currentFilter!.name.toUpperCase()})",
        ),
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,

        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.filter_list),

            onSelected: (value) {
              if (value == "all") {
                provider.setFilter(null);
              } else if (value == "high") {
                provider.setFilter(Priority.high);
              } else if (value == "medium") {
                provider.setFilter(Priority.medium);
              } else {
                provider.setFilter(Priority.low);
              }
            },

            itemBuilder: (_) => const [
              PopupMenuItem(value: "all", child: Text("All")),
              PopupMenuItem(value: "high", child: Text("High")),
              PopupMenuItem(value: "medium", child: Text("Medium")),
              PopupMenuItem(value: "low", child: Text("Low")),
            ],
          ),
        ],
      ),

      // ================= BODY =================
      body: provider.todos.isEmpty
          ? const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.check_circle_outline,
                    size: 60,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 10),
                  Text("No Todos Found"),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(10),
              itemCount: provider.todos.length,
              itemBuilder: (_, index) {
                final todo = provider.todos[index];

                return Dismissible(
                  key: ValueKey(todo.id),
                  direction: DismissDirection.endToStart,

                  background: Container(
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    color: Colors.red,
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),

                  onDismissed: (_) {
                    provider.deleteTodo(todo.id);
                  },

                  child: Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 6,
                          color: Colors.black.withOpacity(0.05),
                        ),
                      ],
                    ),

                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),

                      child: Row(
                        children: [
                          Checkbox(
                            value: todo.isCompleted,
                            onChanged: (_) => provider.toggleTodo(todo.id),
                          ),

                          const SizedBox(width: 8),

                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  todo.title,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    decoration: todo.isCompleted
                                        ? TextDecoration.lineThrough
                                        : null,
                                  ),
                                ),

                                const SizedBox(height: 4),

                                Text(
                                  todo.description,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(width: 8),

                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CircleAvatar(
                                radius: 5,
                                backgroundColor: getPriorityColor(
                                  todo.priority,
                                ),
                              ),

                              const SizedBox(width: 10),

                              IconButton(
                                icon: const Icon(
                                  Icons.edit,
                                  color: Colors.blue,
                                ),
                                onPressed: () {
                                  _showEditDialog(context, provider, todo);
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),

      // ================= ADD BUTTON =================
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
        onPressed: () => _showAddDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  // ================= ADD TODO =================
  void _showAddDialog(BuildContext context) {
    final titleCtrl = TextEditingController();
    final descCtrl = TextEditingController();
    Priority priority = Priority.medium;

    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (_) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text("Add Todo"),

              content: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      controller: titleCtrl,
                      decoration: const InputDecoration(
                        labelText: "Title",
                        prefixIcon: Icon(Icons.title),
                        border: OutlineInputBorder(),
                      ),
                      validator: (v) => v!.isEmpty ? "Enter title" : null,
                    ),

                    const SizedBox(height: 10),

                    TextFormField(
                      controller: descCtrl,
                      decoration: const InputDecoration(
                        labelText: "Description",
                        prefixIcon: Icon(Icons.description),
                        border: OutlineInputBorder(),
                      ),
                      validator: (v) => v!.isEmpty ? "Enter description" : null,
                    ),

                    const SizedBox(height: 10),

                    DropdownButtonFormField<Priority>(
                      value: priority,
                      decoration: const InputDecoration(
                        labelText: "Priority",
                        prefixIcon: Icon(Icons.flag),
                        border: OutlineInputBorder(),
                      ),
                      items: Priority.values.map((p) {
                        return DropdownMenuItem(
                          value: p,
                          child: Text(p.name.toUpperCase()),
                        );
                      }).toList(),
                      onChanged: (val) {
                        setState(() => priority = val!);
                      },
                    ),
                  ],
                ),
              ),

              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Cancel"),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (!formKey.currentState!.validate()) return;

                    context.read<TodoProvider>().addTodo(
                      titleCtrl.text,
                      descCtrl.text,
                      priority,
                    );

                    Navigator.pop(context);
                  },
                  child: const Text("Add"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  // ================= EDIT TODO =================
  void _showEditDialog(BuildContext context, TodoProvider provider, Todo todo) {
    final titleCtrl = TextEditingController(text: todo.title);
    final descCtrl = TextEditingController(text: todo.description);
    Priority priority = todo.priority;

    showDialog(
      context: context,
      builder: (_) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text("Edit Todo"),

              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: titleCtrl,
                    decoration: const InputDecoration(
                      labelText: "Title",
                      prefixIcon: Icon(Icons.title),
                      border: OutlineInputBorder(),
                    ),
                  ),

                  const SizedBox(height: 10),

                  TextField(
                    controller: descCtrl,
                    decoration: const InputDecoration(
                      labelText: "Description",
                      prefixIcon: Icon(Icons.description),
                      border: OutlineInputBorder(),
                    ),
                  ),

                  const SizedBox(height: 10),

                  DropdownButtonFormField<Priority>(
                    value: priority,
                    decoration: const InputDecoration(
                      labelText: "Priority",
                      prefixIcon: Icon(Icons.flag),
                      border: OutlineInputBorder(),
                    ),
                    items: Priority.values.map((p) {
                      return DropdownMenuItem(
                        value: p,
                        child: Text(p.name.toUpperCase()),
                      );
                    }).toList(),
                    onChanged: (val) {
                      setState(() => priority = val!);
                    },
                  ),
                ],
              ),

              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Cancel"),
                ),
                ElevatedButton(
                  onPressed: () {
                    provider.updateTodo(
                      todo.id,
                      titleCtrl.text,
                      descCtrl.text,
                      priority,
                    );

                    Navigator.pop(context);
                  },
                  child: const Text("Update"),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
