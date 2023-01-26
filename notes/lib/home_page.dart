import 'package:flutter/material.dart';
import 'package:notes/details_page.dart';

import 'note.dart';

enum MenuOptions { settings, archived }

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late MenuOptions _selection;

  late Future<List<Note>> futureNotesFromDb;

  void _showToast(BuildContext context, String text) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(
      SnackBar(
        content: Text(text),
      ),
    );
  }

  Future<void> _createNote(BuildContext context) async {
    var pushResult = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => DetailsPage(title: 'Create note'),
      ),
    );

    _showToast(context, "popped " + pushResult);
  }

  void _editNote(BuildContext context, Note note) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => DetailsPage(title: 'Edit note', note: note),
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    futureNotesFromDb = getFutureNotesFromDb();
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
            icon: Icon(Icons.refresh),
            tooltip: 'Refresh',
            onPressed: () => setState(() {
              futureNotesFromDb = getFutureNotesFromDb();
            }),
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
      body: FutureBuilder<List<Note>>(
        future: futureNotesFromDb,
        builder: (BuildContext context, AsyncSnapshot<List<Note>> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              if (snapshot.hasError) {
                return Center(child: Text("Something went wrong..."));
              }

              if (!(snapshot.hasData && snapshot.data!.length > 0)) {
                return Center(child: Text("No notes yet..."));
              }

              List<Note> list = snapshot.data!;

              return buildListView(list);

            case ConnectionState.waiting:
              return Center(
                child: Text('Loading...'),
              );
            case ConnectionState.active:
            case ConnectionState.none:
              // TODO: Handle this case.
              break;
          }

          return Text("No notes yet...");
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async => await _createNote(context),
        tooltip: 'New note',
        child: Icon(Icons.add),
      ),
    );
  }

  ListView buildListView(List<Note> list) {
    return ListView.builder(
      padding: EdgeInsets.only(left: 4.0, right: 4.0, bottom: 8.0),
      itemCount: list.length + 1,
      itemBuilder: (context, index) {
        if (index == list.length) {
          // TODO create a separate widget for the Archived button
          return SizedBox(
            height: 60.0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.archive,
                  color: Colors.amber,
                ),
                TextButton(
                  child: Text("Archived"),
                  onPressed: () {},
                ),
              ],
            ),
          );
        }

        var noteTmp = list[index];

        return Container(
          padding: EdgeInsets.symmetric(vertical: 2.0),
          margin: EdgeInsets.only(
            top: 8.0,
          ),
          decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(blurRadius: 3.0, color: Colors.grey),
              ],
              borderRadius: BorderRadius.all(Radius.circular(8.0))),
          child: ListTile(
            title: Text(
              noteTmp.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            subtitle: noteTmp.description.trim().length <= 0
                ? null
                : Text(
                    noteTmp.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
            onTap: () => _editNote(context, noteTmp),
          ),
        );
      },
    );
  }

  Future<List<Note>> getFutureNotesFromDb() {
    // TODO get data from database
    throw Exception("Not Implemented");
  }
}
