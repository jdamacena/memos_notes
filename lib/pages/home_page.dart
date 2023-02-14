import 'package:flutter/material.dart';
import 'package:notes/models/notes_filter_options.dart';
import 'package:notes/models/note.dart';
import 'package:notes/pages/details_page.dart';
import 'package:notes/di/service_locator.dart';
import 'package:notes/repository/notes_repository.dart';
import 'package:notes/widgets/archived_tile.dart';
import 'package:notes/widgets/note_list_item.dart';

enum MenuOptions { settings, archived, refresh }

class HomePage extends StatefulWidget {
  final NotesFilterOptions filter;
  final String title;

  HomePage({
    Key? key,
    required this.filter,
    required this.title,
  }) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState(getIt.get<NotesRepository>());
}

class _HomePageState extends State<HomePage> {
  late MenuOptions _selection;
  bool get _isInArchivedPage => widget.filter == NotesFilterOptions.archived;

  late Future<List<Note>> futureNotesFromDb;

  NotesRepository notesRepository;

  _HomePageState(this.notesRepository);

  void _showToast(BuildContext context, String text) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(
      SnackBar(
        content: Text(text),
      ),
    );
  }

  void _createNote(BuildContext context) {
    openDetailsPage('Create note');
  }

  void _editNote(BuildContext context, Note note) {
    openDetailsPage('Edit note', note: note);
  }

  Future<void> openDetailsPage(String title, {Note? note}) async {
    dynamic didDeleteNote = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          return DetailsPage(title: title, note: note);
        },
      ),
    );

    if (didDeleteNote is bool && didDeleteNote) {
      refreshPage();
    }
  }

  Future<List<Note>> getFutureNotesFromDb() {
    return notesRepository.getNotesFromDbAsync(widget.filter);
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
        title: Text(widget.title),
        actions: [
          PopupMenuButton<MenuOptions>(
            onSelected: (MenuOptions result) {
              switch(result) {
                case MenuOptions.archived:
                  openArchivedPage();
                  break;
                case MenuOptions.refresh:
                  refreshPage();
                  break;
                default:
              }

              setState(() {
                _selection = result;
              });
            },
            itemBuilder: (BuildContext context) {
              return <PopupMenuEntry<MenuOptions>>[
              PopupMenuItem<MenuOptions>(
                value: MenuOptions.refresh,
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(
                        Icons.refresh,
                        color: Colors.grey,
                      ),
                    ),
                    Text('Refresh'),
                  ],
                ),
              ),
              if (!_isInArchivedPage)
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
              if (!_isInArchivedPage)
                PopupMenuItem<MenuOptions>(
                  value: MenuOptions.settings,
                  enabled: false,
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
            ];
            },
          )
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async => refreshPage(),
        child: FutureBuilder<List<Note>>(
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
                  child: CircularProgressIndicator(),
                );
              case ConnectionState.active:
              case ConnectionState.none:
                // TODO: Handle this case.
                break;
            }

            return Center(child: Text("No notes yet..."));
          },
        ),
      ),
      floatingActionButton:
      _isInArchivedPage
          ? null
          : FloatingActionButton(
              onPressed: () => _createNote(context),
              tooltip: 'New note',
              child: Icon(Icons.add),
            ),
    );
  }

  void refreshPage() {
    futureNotesFromDb = getFutureNotesFromDb();

    setState(() {});
  }

  ListView buildListView(List<Note> list) {
    int count = list.length;

    if (widget.filter != NotesFilterOptions.archived) {
      count += 1;
    }

    return ListView.builder(
      padding: EdgeInsets.only(left: 4.0, right: 4.0, bottom: 8.0),
      itemCount: count,
      itemBuilder: (context, index) {
        if (index == list.length) {
          return ArchivedTile(onPressed: openArchivedPage);
        }

        var noteTmp = list[index];
        var onTap = () => _editNote(context, noteTmp);

        return NoteListItem(key: UniqueKey(), note: noteTmp, onTap: onTap);
      },
    );
  }

  void openArchivedPage() {
     Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          return HomePage(
            filter: NotesFilterOptions.archived,
            title: "Archived",
          );
        },
      ),
    );
  }
}
