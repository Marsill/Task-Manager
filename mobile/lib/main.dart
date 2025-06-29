import 'package:flutter/material.dart';
import 'package:taskmanager/pages/ListOfTasks.dart';
import 'package:taskmanager/pages/Splash.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Task Manager',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
    home: SplashScreen(
      child: ListOfTaskPage(),
      ),
    );

  }
}
