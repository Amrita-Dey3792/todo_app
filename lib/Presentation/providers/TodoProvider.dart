import 'package:flutter/material.dart';
import 'package:todo_app/data/models/Todo.dart';
import 'package:todo_app/data/repositories/TodoRepository.dart';
import 'package:uuid/uuid.dart';

class TodoProvider extends ChangeNotifier {
  final TodoRepository repository;

  List<Todo> _todos = [];
  Priority? _filter;

  Priority? get currentFilter => _filter;

  TodoProvider(this.repository) {
    loadTodos();
  }

  List<Todo> get todos {
    if (_filter == null) {
      return List.from(_todos);
    }

    return _todos.where((t) => t.priority == _filter).toList();
  }


  Future<void> loadTodos() async {
    _todos = await repository.getTodos();
    notifyListeners();
  }

  Future<void> addTodo(
    String title,
    String desc,
    Priority priority,
  ) async {
    final todo = Todo(
      id: const Uuid().v4(),
      title: title,
      description: desc,
      priority: priority,
      createdAt: DateTime.now(),
    );

    _todos.add(todo);

    await repository.saveTodos(_todos);
    notifyListeners();
  }

  Future<void> toggleTodo(String id) async {
    _todos = _todos.map((t) {
      if (t.id == id) {
        return t.copyWith(isCompleted: !t.isCompleted);
      }
      return t;
    }).toList();

    await repository.saveTodos(_todos);
    notifyListeners();
  }


  Future<void> deleteTodo(String id) async {
    _todos.removeWhere((t) => t.id == id);

    await repository.saveTodos(_todos);
    notifyListeners();
  }

  Future<void> updateTodo(
    String id,
    String title,
    String desc,
    Priority priority,
  ) async {
    final index = _todos.indexWhere((t) => t.id == id);

    if (index != -1) {
      _todos[index] = _todos[index].copyWith(
        title: title,
        description: desc,
        priority: priority,
      );

      await repository.saveTodos(_todos);
      notifyListeners();
    }
  }


  void setFilter(Priority? priority) {
    if (_filter == priority) return;

    _filter = priority;
    notifyListeners();
  }

  void clearFilter() {
    _filter = null;
    notifyListeners();
  }
}