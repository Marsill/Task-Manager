import 'package:flutter/material.dart';

class Task {
  String title;
  String description;

  Task({required this.title, required this.description});
}

class TaskListPage extends StatefulWidget {
  @override
  _TaskListPageState createState() => _TaskListPageState();
}

class _TaskListPageState extends State<TaskListPage> {
  List<Task> tasks = [];
  void _addTask() async {
    final newTask = await Navigator.push<Task>(
      context,
      MaterialPageRoute(builder: (context) => AddEditTaskPage()),
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
        builder: (context) => AddEditTaskPage(task: tasks[index]),
      ),
    );

    if (editedTask != null) {
      setState(() {
        tasks[index] = editedTask;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Tasks'),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: tasks.isEmpty
          ? Center(child: Text('No tasks yet. Add a new task!'))
          : ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                var task = tasks[index];
                return Card(
                  margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 4,
                  child: ListTile(
                    title: Text(
                      task.title.isNotEmpty ? task.title : 'Untitled Task',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      task.description.isNotEmpty
                          ? task.description
                          : 'No description provided',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    onTap: () => _editTask(index),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addTask,
        child: Icon(Icons.add),
      ),
    );
  }
}

class AddEditTaskPage extends StatefulWidget {
  final Task? task;

  AddEditTaskPage({this.task});

  @override
  _AddEditTaskPageState createState() => _AddEditTaskPageState();
}

class _AddEditTaskPageState extends State<AddEditTaskPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descController;

  @override
  void initState() {
    super.initState();
    _titleController =
        TextEditingController(text: widget.task?.title ?? '');
    _descController =
        TextEditingController(text: widget.task?.description ?? '');
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    super.dispose();
  }

  void _saveTask() {
    if (_formKey.currentState!.validate()) {
      final newTask = Task(
        title: _titleController.text.trim(),
        description: _descController.text.trim(),
      );
      Navigator.pop(context, newTask);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.task == null ? 'Add Task' : 'Edit Task'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(labelText: 'Task Title'),
                validator: (value) =>
                    value == null || value.trim().isEmpty ? 'Enter a title' : null,
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _descController,
                decoration: InputDecoration(labelText: 'Description'),
                maxLines: 3,
              ),
              SizedBox(height: 32),
              ElevatedButton(
                onPressed: _saveTask,
                child: Text('Save Task'),
              )
            ],
          ),
        ),
      ),
    );
  }
}