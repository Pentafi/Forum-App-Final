import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CreateThreadScreen extends StatefulWidget {
  CreateThreadScreen({Key? key}) : super(key: key);

  @override
  _CreateThreadScreenState createState() => _CreateThreadScreenState();
}

class _CreateThreadScreenState extends State<CreateThreadScreen> {
  final _titleController = TextEditingController();
  final _postController = TextEditingController();

  void _createThread() async {
    final title = _titleController.text;
    final post = _postController.text;
    final response = await http.post(
      Uri.parse('http://127.0.0.1:8000/api/topics/create/'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "title": title,
        "post": post,
      }),
    );

    if (response.statusCode == 201) {
      // if thread creation is successful, navigate back to forum list
      Navigator.pop(context);
    } else {
      throw Exception('Failed to create thread');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Thread'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Title'),
            ),
            TextField(
              controller: _postController,
              decoration: const InputDecoration(labelText: 'First post'),
            ),
            ElevatedButton(
              onPressed: _createThread,
              child: const Text('Create Thread'),
            ),
          ],
        ),
      ),
    );
  }
}
