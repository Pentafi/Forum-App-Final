import 'package:flutter/material.dart';
import 'package:frontend/model/forum_model.dart';
import 'package:frontend/model/topic_model.dart';
import 'package:frontend/provider/auth_provider.dart';
import 'package:frontend/provider/forum_provider.dart';
import 'package:frontend/provider/topicprovider.dart';
import 'package:frontend/screens/addcomment.dart';
import 'package:frontend/screens/forumlist.dart';
import 'package:frontend/screens/login_page.dart';
import 'package:frontend/screens/new_topic_screen.dart';
import 'package:frontend/screens/signup_page.dart';
import 'package:frontend/screens/thread.dart';
import 'package:frontend/screens/topic_screen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => TopicProvider()),
        ChangeNotifierProvider(create: (_) => ForumProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Putahe Forum App',
      theme: ThemeData(
        primarySwatch: Colors.brown,
      ),
      initialRoute: '/signup',
      routes: {
        '/signup': (context) => const SignupPage(),
        '/login': (context) => LoginScreen(),
        '/ForumList': (context) => ForumListScreen(),
        '/Thread': (context) => const ThreadScreen(),
        '/CreateThread': (context) => const NewTopicScreen(forumId: '',),
        '/TopicScreen': (context) {
          final arguments = ModalRoute.of(context)!.settings.arguments
              as Map<String, dynamic>;
          final topic = arguments['topic'] as TopicModel;
          final forum = arguments['forum'] as ForumModel;
          return TopicScreen(topic: topic, forum: forum);
        },
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/AddComment') {
          final args = settings.arguments as Map<String, dynamic>;
          return MaterialPageRoute(
            builder: (context) =>
                AddCommentScreen(threadId: args['threadId'] as int),
          );
        }
        return null;
      },
    );
  }
}
