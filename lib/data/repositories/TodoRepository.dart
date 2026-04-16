
import 'package:todo_app/data/models/Todo.dart';
import 'package:todo_app/data/services/TodoService.dart';

class TodoRepository {
  final TodoService service;

  TodoRepository(this.service);

  Future<List<Todo>> getTodos() => service.loadTodos();

  Future<void> saveTodos(List<Todo> todos) =>
      service.saveTodos(todos);
}