import 'package:flutter/material.dart';
import 'package:frontend/addcomment.dart';
import 'package:frontend/auth_provider.dart';
import 'package:frontend/createthread.dart';
import 'package:frontend/forumlist.dart';
import 'package:frontend/login_page.dart';
import 'package:provider/provider.dart';
import 'signup_page.dart';
import 'thread.dart';

void main() {
  runApp(ChangeNotifierProvider(
    create: (_) => AuthProvider(),
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

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
        '/ForumList': (context) =>   const ForumListScreen(),
        '/Thread': (context) => ThreadScreen(),
        '/CreateThread': (context) => CreateThreadScreen(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/AddComment') {
          final args = settings.arguments as Map<String, dynamic>;
          return MaterialPageRoute(
            builder: (context) => AddCommentScreen(threadId: args['threadId'] as int),
          );
        }
        return null;
      },
    );
  }
}
