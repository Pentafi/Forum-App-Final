import 'package:flutter/material.dart';
import 'package:frontend/model/forum_model.dart';
import 'package:frontend/provider/auth_provider.dart';
import 'package:frontend/provider/forum_provider.dart';
import 'package:frontend/screens/new_topic_screen.dart';
import 'package:frontend/screens/topic_screen.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ForumListScreen extends StatefulWidget {
  @override
  _ForumListScreenState createState() => _ForumListScreenState();
}

class _ForumListScreenState extends State<ForumListScreen> {
  Future<void> _fetchForums() async {
    final response = await http.get(
      Uri.parse('http://127.0.0.1:8000/api/forums/'), 
      headers: {
        "Content-Type": "application/json",
        'Authorization': 'Bearer ${AuthProvider.accessToken}',
      },
    );

    if (response.statusCode == 200) {
      final forums = jsonDecode(response.body);
      // ignore: use_build_context_synchronously
      final forumProvider = context.read<ForumProvider>();

      forums.forEach((forum) {
        forumProvider.addForum(
          ForumModel(
            forumId: forum['id'].toString(),
            forumTitle: forum['title'], description: '', id: '', title: '', topics: [],
          ),
        );
      });
    } else {
      throw Exception('Failed to fetch forums');
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchForums();
  }

  @override
  Widget build(BuildContext context) {
    final forumProvider = Provider.of<ForumProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Forums'),
      ),
      body: ListView.builder(
        itemCount: forumProvider.forumsCount,
        itemBuilder: (ctx, index) {
          final forum = forumProvider.allForums[index];
          return ListTile(
            title: Text(forum.forumTitle),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TopicScreen(forum: forum, topic: forum.topics[index],),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const NewTopicScreen(forumId: '',),
            ),
          );
        },
      ),
    );
  }
}
