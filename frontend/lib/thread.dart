import 'package:flutter/material.dart';
import 'addcomment.dart';

class ThreadScreen extends StatelessWidget {
  const ThreadScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final threadId = ModalRoute.of(context)!.settings.arguments as int;
    const threadTitle = 'Thread Title';
    const postContent = 'Post Content';

    return Scaffold(
      appBar: AppBar(
        title: const Text(threadTitle),
      ),
      body: ListView.builder(
        itemCount: 5,
        itemBuilder: (context, index) {
          return const ListTile(
            title: Text(postContent),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddCommentScreen(threadId: threadId),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
