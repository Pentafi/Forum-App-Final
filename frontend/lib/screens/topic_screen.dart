import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:frontend/model/forum_model.dart';
import 'package:frontend/model/topic_model.dart';
import 'package:frontend/provider/auth_provider.dart';
import 'package:frontend/provider/topicprovider.dart';
import 'package:frontend/screens/new_topic_screen.dart';
import 'package:frontend/widget/topic_widget.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class TopicScreen extends StatefulWidget {
  final TopicModel topic;
  final ForumModel forum;

  TopicScreen({required this.topic, required this.forum});

  @override
  _TopicScreenState createState() => _TopicScreenState();
}

class _TopicScreenState extends State<TopicScreen> {
  Future<void> _fetchTopics() async {
    final response = await http.get(
      Uri.parse('http://127.0.0.1:8000/api/forums/${widget.forum.forumId}/topics/'),
      headers: {
        "Content-Type": "application/json",
        'Authorization': 'Bearer ${AuthProvider.accessToken}',
      },
    );

    if (response.statusCode == 200) {
      final topics = jsonDecode(response.body);
      final topicProvider = context.read<TopicProvider>();

      topics.forEach((topic) {
        topicProvider.addTopic(
          TopicModel(
            topicId: topic['id'].toString(),
            topicTitle: topic['title'],
            forumId: widget.forum.forumId,
            topicDescription: '',
          ),
        );
      });
    } else {
      throw Exception('Failed to fetch topics');
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchTopics();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Threads'),
      ),
      backgroundColor: Colors.white,
      body: Consumer<TopicProvider>(
        builder: (context, topicProvider, child) {
          final allTopics = topicProvider.allTopics;
          return allTopics.isEmpty ? _buildEmptyState() : TopicWidget(allTopics: allTopics);
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const NewTopicScreen(forumId: '',),
            ),
          );
        },
        backgroundColor: Colors.brown,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Text(
        'No topics available.',
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    );
  }
}
