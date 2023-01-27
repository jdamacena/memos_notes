
import 'package:flutter/material.dart';

enum MenuOptions { settings, archived }

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  late MenuOptions _selection;

  void _createNote() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Icon(Icons.note),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(widget.title),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            tooltip: 'Search',
            onPressed: () {},
          ),
          PopupMenuButton<MenuOptions>(
            onSelected: (MenuOptions result) {
              setState(() {
                _selection = result;
              });
            },
            itemBuilder: (BuildContext context) =>
            <PopupMenuEntry<MenuOptions>>[
              PopupMenuItem<MenuOptions>(
                value: MenuOptions.archived,
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(
                        Icons.archive,
                        color: Colors.grey,
                      ),
                    ),
                    Text('Archived'),
                  ],
                ),
              ),
              PopupMenuItem<MenuOptions>(
                value: MenuOptions.settings,
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(
                        Icons.settings,
                        color: Colors.grey,
                      ),
                    ),
                    Text('Settings'),
                  ],
                ),
              ),
            ],
          )
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _createNote,
        tooltip: 'New note',
        child: Icon(Icons.add),
      ),
    );
  }
}
