import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/Presentation/providers/TodoProvider.dart';
import 'package:todo_app/Presentation/screens/SplashScreen.dart';
import 'package:todo_app/data/repositories/TodoRepository.dart';
import 'package:todo_app/data/services/TodoService.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => TodoProvider(
            TodoRepository(TodoService()),
          ),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(useMaterial3: true),
        home: const SplashScreen(),
      ),
    );
  }
}