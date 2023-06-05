import 'package:flutter/material.dart';
import 'package:frontend/model/topic_model.dart';

class TopicWidget extends StatelessWidget {
  final List<TopicModel> allTopics;

  const TopicWidget({Key? key, required this.allTopics}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('Building TopicWidget with topics: $allTopics');
    return ListView.builder(
      itemCount: allTopics.length,
      itemBuilder: (context, index) {
        return Card(
          child: ListTile(
            title: Text(allTopics[index].topicTitle),
            subtitle: Text(allTopics[index].topicDescription),
            trailing: IconButton(
              icon: const Icon(Icons.arrow_forward),
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  '/AddComment',
                  arguments: {'threadId': allTopics[index].topicId},
                );
              },
            ),
          ),
        );
      },
    );
  }
}
