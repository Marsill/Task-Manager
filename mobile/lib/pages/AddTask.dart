import 'package:flutter/material.dart';
import 'ListOfTasks.dart';

class AddEditTaskPage extends StatefulWidget {
  final Task? task;
  final int? index;

  const AddEditTaskPage({super.key, this.task, this.index});

  @override
  _AddEditTaskPageState createState() => _AddEditTaskPageState();
}

class _AddEditTaskPageState extends State<AddEditTaskPage> {
  final _formKey = GlobalKey<FormState>();
  String? _title;
  String? _content;
  bool _isCompleted = false;

  @override
  void initState() {
    super.initState();
    _title = widget.task?.title;
    _content = widget.task?.content;
    _isCompleted = widget.task?.isCompleted ?? false;
  }

  void _saveTask() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final newTask = Task(
        title: _title!,
        content: _content!,
        isCompleted: _isCompleted,
      );
      Navigator.pop(context, newTask);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.task == null ? 'Add Task' : 'Edit Task'),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                initialValue: _title,
                decoration: const InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value!.isEmpty ? 'Title cannot be empty' : null,
                onSaved: (value) => _title = value,
              ),
              const SizedBox(height: 16),
              TextFormField(
                initialValue: _content,
                maxLines: 8,
                decoration: const InputDecoration(
                  labelText: 'Content',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value!.isEmpty ? 'Content cannot be empty' : null,
                onSaved: (value) => _content = value,
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: _saveTask,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                ),
                child: const Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}