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
      tasks.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Tasks'),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: tasks.isEmpty
          ? const Center(child: Text('No tasks yet. Add a new one!'))
          : ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                var task = tasks[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 4,
                  child: ListTile(
                    title: Text(
                      task.title.isNotEmpty ? task.title : 'Untitled Task',
                      style: const TextStyle(fontWeight: FontWeight.bold),
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
                          icon: const Icon(Icons.check_circle_outline),
                          onPressed: () => _toggleTaskCompletion(index),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addTask,
        child: const Icon(Icons.add),
      ),
    );
  }
}