import 'package:flutter/material.dart';
import 'package:notes/di/service_locator.dart';
import 'package:notes/models/notes_filter_options.dart';

import 'pages/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  setupServiceLocator();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Notes',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.blue,
            secondary: Colors.blueAccent,
          ),
      ),
      home: HomePage(
        filter: NotesFilterOptions.notArchived,
        title: 'Notes',
      ),
    );
  }
}
