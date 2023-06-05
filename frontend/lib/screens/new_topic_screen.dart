import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:frontend/model/topic_model.dart';
import 'package:frontend/model/forum_model.dart';
import 'package:frontend/provider/auth_provider.dart';
import 'package:frontend/provider/topicprovider.dart';
import 'package:frontend/provider/forum_provider.dart';
import 'package:frontend/screens/topic_screen.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class NewTopicScreen extends StatefulWidget {
  final String
      forumId; 
  const NewTopicScreen({Key? key, required this.forumId}) : super(key: key);

  @override
  _NewTopicScreenState createState() => _NewTopicScreenState();
}

class _NewTopicScreenState extends State<NewTopicScreen> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  void _createTopic() async {
    final title = _titleController.text;
    final description = _descriptionController.text;
    final forumId = widget.forumId;
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final token = authProvider.user?.accessToken;

    try {
      if (title.isEmpty || description.isEmpty) {
        print('Title or description is empty.');
        return;
      }

      final response = await http.post(
        Uri.parse('http://127.0.0.1:8000/api/topics/create/'),
        headers: {
          "Content-Type": "application/json",
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          "title": title,
          "description": description,
          "forum": forumId,
        }),
      );

      if (response.statusCode == 201) {
        final responseData = jsonDecode(response.body);
        final topicProvider = context.read<TopicProvider>();
        final forumProvider = context.read<ForumProvider>();
        final newTopicId = responseData['id'].toString();

        final newTopic = TopicModel(
          topicTitle: title,
          topicDescription: description,
          topicId: newTopicId,
          forumId: widget.forumId, 
        );

        topicProvider.addTopic(newTopic);

        final newForum = ForumModel(
          forumTitle: 'New Forum',
          forumId: widget.forumId, 
          description:
              'New Forum Description',
          topics: [newTopic],
          title: '',
          id: '',
        );

        forumProvider.addForum(newForum);

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => TopicScreen(topic: newTopic, forum: newForum),
          ),
        );
      } else {
        throw Exception('Failed to create topic');
      }
    } catch (e) {
      print('Error creating topic: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create New Topic'),
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
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: 'Description'),
            ),
            ElevatedButton(
              onPressed: _createTopic,
              child: const Text('Create Topic'),
            ),
          ],
        ),
      ),
    );
  }
}
