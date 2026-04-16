import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_app/data/models/Todo.dart';

class TodoService {
  static const String key = 'todos';

  Future<List<Todo>> loadTodos() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? data = prefs.getStringList(key);

    if (data == null) return [];

    return data.map((e) => Todo.fromJson(e)).toList();
  }

  Future<void> saveTodos(List<Todo> todos) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> data = todos.map((e) => e.toJson()).toList();

    await prefs.setStringList(key, data);
  }
}
