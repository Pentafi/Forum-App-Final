import 'package:frontend/model/topic_model.dart';

class ForumModel {
  final String forumId;
  final String forumTitle;
  final String description;
  final List<TopicModel> topics;
  final String id; 
  final String title; 

  ForumModel({
    required this.forumId,
    required this.forumTitle,
    required this.description,
    required this.topics,
    required this.id, 
    required this.title, 
  });

  factory ForumModel.fromJson(Map<String, dynamic> json) {
    return ForumModel(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      forumId: '',
      forumTitle: '',
      topics: [],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description,
      };
}
