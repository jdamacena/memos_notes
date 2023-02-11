import 'package:flutter/material.dart';
import 'package:notes/di/service_locator.dart';
import 'package:notes/models/note.dart';
import 'package:notes/repository/DAO.dart';

enum MenuOptions { settings, archived }

class DetailsPage extends StatefulWidget {
  DetailsPage({
    Key? key,
    required this.title,
    this.note,
  }) : super(key: key);

  final String title;
  final Note? note;

  @override
  _DetailPageState createState() => _DetailPageState(getIt.get<DAO>());
}

class _DetailPageState extends State<DetailsPage> {
  Note note = Note(id: 0, title: '', description: '', timestamp: '');
  late final Note originalNote;

  late MenuOptions _selection;

  DAO dao;

  _DetailPageState(this.dao);

  void _showToast(BuildContext context, String text) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(
      SnackBar(
        content: Text(text),
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    note = widget.note ?? note;
    originalNote = note.copy();
  }
  @override
  Widget build(BuildContext context) {
    const spacer = SizedBox(height: 24);

    var titleController = TextEditingController(text: note.title);
    var descriptionController = TextEditingController(text: note.description);

    return WillPopScope(
      onWillPop: () async {
        if (note.toMap().toString() == originalNote.toMap().toString()) {
          return true;
        }
        _saveNote(note);

        executePopWitResult();

        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              Text(widget.title),
            ],
          ),
          actions: getAppBarActions(context)
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                spacer,
                TextFormField(
                  controller: titleController,
                  onChanged: (value) => note.title = value,
                  decoration: InputDecoration(
                    hintText: 'Title',
                    border: const OutlineInputBorder(),
                    labelText: "Title",
                  ),
                ),
                spacer,
                TextFormField(
                  controller: descriptionController,
                  onChanged: (value) => note.description = value,
                  minLines: 5,
                  maxLines: 10,
                  decoration: InputDecoration(
                    hintText: 'Type your note...',
                    border: const OutlineInputBorder(),
                    labelText: "Note",
                  ),
                ),
                spacer,
                ElevatedButton(
                  onPressed: () async {
                    int idSavedNote = await _saveNote(note);
                    note.id = idSavedNote;

                    _showToast(context, "Saved");
                  },
                  child: Text("Save"),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<IconButton> getAppBarActions(BuildContext context) {
    var deleteButton = IconButton(
      icon: Icon(Icons.delete),
      tooltip: 'Delete',
      onPressed: () async => await onDeleteButtonPressed(context),
    );

    var cancelButton = IconButton(
      icon: Icon(Icons.cancel),
      tooltip: 'Cancel',
      onPressed: () => Navigator.of(context).pop(),
    );

    var appBarActions = List<IconButton>.of([cancelButton]);

    if (note.id > 0) {
      appBarActions.add(deleteButton);
    }

    return appBarActions;
  }

  Future<void> onDeleteButtonPressed(BuildContext context) async {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete this note'),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text('This cannot be undone'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Delete'),
              onPressed: () async {
                // Close the dialog
                Navigator.of(context).pop();

                if (await _deleteNote(note.id)) {
                  _showToast(context, "Successfully Deleted");

                  // Close the screen
                  executePopWitResult();
                } else {
                  _showToast(context, "Something Went Wrong");
                }
              },
            ),
            ElevatedButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }

  void executePopWitResult({bool didDeleteNote = true}) {
    Navigator.of(context).pop(didDeleteNote);
  }

  Future<int> _saveNote(Note note) => dao.saveNoteAsync(note);

  Future<bool> _deleteNote(int id) => dao.deleteNoteAsync(id);
}
