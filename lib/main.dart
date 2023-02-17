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
    var lightTheme = ThemeData(
      colorScheme: ColorScheme.fromSeed(
        brightness: Brightness.light,
        seedColor: Colors.blue,
        secondary: Colors.lightBlueAccent,
        shadow: Colors.grey,
      ),
    );

    var darkTheme = ThemeData(
      colorScheme: ColorScheme.fromSeed(
        brightness: Brightness.dark,
        seedColor: Colors.blue,
        secondary: Colors.lightBlueAccent,
        shadow: Colors.black54,
      ),
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Notes',
      theme: lightTheme,
      darkTheme: darkTheme,
      home: HomePage(
        filter: NotesFilterOptions.notArchived,
        title: 'Notes',
      ),
    );
  }
}
