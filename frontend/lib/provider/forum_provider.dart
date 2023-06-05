import 'package:flutter/material.dart';
import 'package:frontend/model/forum_model.dart';  

class ForumProvider with ChangeNotifier {
  final List<ForumModel> _forums = [];

  List<ForumModel> get allForums {
    return [..._forums];
  }

  int get forumsCount {
    return _forums.length;
  }

  void addForum(ForumModel forum) {
    _forums.add(forum);
    notifyListeners();
    print('Added forum: $forum');
  }

  ForumModel findById(String id) {
    return _forums.firstWhere(
      (forum) => forum.forumId == id, 
      orElse: () => ForumModel(
          forumTitle: 'Not found', 
          forumId: '0', description: '', id: '', title: '', topics: [])
    );
  }
}
