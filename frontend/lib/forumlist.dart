import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ForumListScreen extends StatefulWidget {
  const ForumListScreen({Key? key});

  @override
  _ForumListScreenState createState() => _ForumListScreenState();
}

class _ForumListScreenState extends State<ForumListScreen> {
  List threads = []; // Update the variable name to "threads"

  Future fetchThreads() async { // Update the function name to "fetchThreads"
    final response = await http.get(Uri.parse('http://127.0.0.1:8000/api/topics/')); // Update the API endpoint to fetch topics instead of forums
    
    if (response.statusCode == 200) {
      setState(() {
        threads = json.decode(response.body);
      });
    } else {
      throw Exception('Failed to load threads');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchThreads(); // Update the function call to "fetchThreads"
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Threads'), // Update the app bar title to "Threads"
      ),
      body: ListView.builder(
        itemCount: threads.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(threads[index]['title']), // Update the key to "title"
            onTap: () {
              Navigator.pushNamed(context, '/Thread', arguments: threads[index]['id']); // Pass the thread ID as an argument
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/CreateThread');
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
