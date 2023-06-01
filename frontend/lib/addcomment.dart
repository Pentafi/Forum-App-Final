import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AddCommentScreen extends StatefulWidget {
  final int threadId;

  AddCommentScreen({required this.threadId});

  @override
  _AddCommentScreenState createState() => _AddCommentScreenState();
}

class _AddCommentScreenState extends State<AddCommentScreen> {
  final _commentController = TextEditingController();

  void _addComment() async {
    final comment = _commentController.text;
    final response = await http.post(
      Uri.parse('http://127.0.0.1:8000/api/posts/create/'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "message": comment,
        "topic": widget.threadId,
      }),
    );

    if (response.statusCode == 201) {
      // ignore: use_build_context_synchronously
      Navigator.pop(context);
    } else {
      throw Exception('Failed to post comment');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Comment'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _commentController,
              decoration: const InputDecoration(labelText: 'Comment'),
            ),
            ElevatedButton(
              onPressed: _addComment,
              child: const Text('Add Comment'),
            ),
          ],
        ),
      ),
    );
  }
}
