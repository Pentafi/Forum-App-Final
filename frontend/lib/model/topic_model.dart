class TopicModel {
  final String topicTitle;
  final String topicDescription;
  final String topicId;

  TopicModel({
    required this.topicTitle,
    required this.topicDescription,
    required this.topicId, required forumId,
  });

  @override
  String toString() {
    return 'TopicModel(topicTitle: $topicTitle, topicDescription: $topicDescription, topicId: $topicId)';
  }
}
