import 'package:flutter/material.dart';
import 'AddTask.dart';

class Task {
  String title;
  String content;
  bool isCompleted;

  Task({required this.title, required this.content, this.isCompleted = false});
}

class ListOfTaskPage extends StatefulWidget {
  const ListOfTaskPage({super.key});

  @override
  _ListOfTaskPageState createState() => _ListOfTaskPageState();
}

class _ListOfTaskPageState extends State<ListOfTaskPage> {
  List<Task> tasks = [];

  void _addTask() async {
    final newTask = await Navigator.push<Task>(
      context,
      MaterialPageRoute(builder: (context) => const AddEditTaskPage()),
    );

    if (newTask != null) {
      setState(() {
        tasks.add(newTask);
      });
    }
  }

  void _editTask(int index) async {
    final editedTask = await Navigator.push<Task>(
      context,
      MaterialPageRoute(
        builder: (context) => AddEditTaskPage(task: tasks[index], index: index),
      ),
    );

    if (editedTask != null) {
      setState(() {
        tasks[index] = editedTask;
      });
    }
  }

  void _deleteTask(int index) {
    setState(() {
      tasks.removeAt(index);
    });
  }

  void _toggleTaskCompletion(int index) {
    setState(() {
      tasks[index].isCompleted = !tasks[index].isCompleted;
    });
  }

  @override
  Widget build(BuildContext context) {
    final incompleteTasks = tasks.where((task) => !task.isCompleted).toList();
    final completedTasks = tasks.where((task) => task.isCompleted).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Tasks'),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: tasks.isEmpty
          ? const Center(child: Text('No tasks yet. Add a new one!'))
          : ListView(
              children: [
                if (incompleteTasks.isNotEmpty) ...[
                  const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                      'Incomplete Tasks',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  ...incompleteTasks.asMap().entries.map((entry) {
                    final index = tasks.indexOf(entry.value);
                    final task = entry.value;
                    return _buildTaskCard(task, index);
                  }).toList(),
                ],
                if (completedTasks.isNotEmpty) ...[
                  const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                      'Completed Tasks',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  ...completedTasks.asMap().entries.map((entry) {
                    final index = tasks.indexOf(entry.value);
                    final task = entry.value;
                    return _buildTaskCard(task, index, isCompleted: true);
                  }).toList(),
                ],
              ],
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addTask,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildTaskCard(Task task, int index, {bool isCompleted = false}) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 4,
      child: ListTile(
        title: Text(
          task.title.isNotEmpty ? task.title : 'Untitled Task',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            decoration: isCompleted ? TextDecoration.lineThrough : null,
          ),
        ),
        subtitle: Text(
          task.content.isNotEmpty ? task.content : 'No content provided',
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        onTap: () => _editTask(index),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () => _deleteTask(index),
            ),
            IconButton(
              icon: Icon(
                task.isCompleted ? Icons.check_circle : Icons.check_circle_outline,
                color: task.isCompleted ? Colors.green : null,
              ),
              onPressed: () => _toggleTaskCompletion(index),
            ),
          ],
        ),
      ),
    );
  }
}