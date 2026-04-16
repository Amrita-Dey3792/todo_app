import 'dart:convert';

enum Priority {  low, medium, high }

class Todo {
  final String id;
  final String title;
  final String description;
  final bool isCompleted;
  final Priority priority;
  final DateTime createdAt;

  const Todo({
    required this.id,
    required this.title,
    required this.description,
    required this.priority,
    required this.createdAt,
    this.isCompleted = false,
  });

  Todo copyWith({
    String? id,
    String? title,
    String? description,
    bool? isCompleted,
    Priority? priority,
    DateTime? createdAt,
  }) {
    return Todo(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      isCompleted: isCompleted ?? this.isCompleted,
      priority: priority ?? this.priority,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'isCompleted': isCompleted,
      'priority': priority.index,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory Todo.fromMap(Map<String, dynamic> map) {
    return Todo(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      isCompleted: map['isCompleted'] ?? false,

      priority: Priority
          .values[(map['priority'] ?? 1).clamp(0, Priority.values.length - 1)],


      createdAt: DateTime.tryParse(map['createdAt'] ?? '') ?? DateTime.now(),
    );
  }

  String toJson() => json.encode(toMap());

  factory Todo.fromJson(String source) => Todo.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Todo(title: $title, priority: $priority, completed: $isCompleted)';
  }
}
