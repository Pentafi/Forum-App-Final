import 'package:flutter/material.dart';
import 'package:frontend/model/topic_model.dart';

class TopicProvider with ChangeNotifier {
  final List<TopicModel> _topics = [];

  List<TopicModel> get allTopics {
    return [..._topics];
  }

  int get topicsCount {
    return _topics.length;
  }

void addTopic(TopicModel topic) {
  _topics.add(topic);
  notifyListeners();
  print('Added topic: $topic');
}

  TopicModel findById(String id) {
    return _topics.firstWhere(
      (topic) => topic.topicId == id, 
      orElse: () => TopicModel(
          topicTitle: 'Not found', 
          topicDescription: 'No description', 
          topicId: '0', forumId: null)
    );
  }
}
