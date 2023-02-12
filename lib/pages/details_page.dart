import 'package:flutter/material.dart';
import 'package:notes/di/service_locator.dart';
import 'package:notes/models/note.dart';
import 'package:notes/repository/notes_repository.dart';

enum MenuOptions { cancel, delete }

class DetailsPage extends StatefulWidget {
  DetailsPage({
    Key? key,
    required this.title,
    this.note,
  }) : super(key: key);

  final String title;
  final Note? note;

  @override
  _DetailPageState createState() => _DetailPageState(getIt.get<NotesRepository>());
}

class _DetailPageState extends State<DetailsPage> {
  Note note = Note.empty();
  late final Note originalNote;

  late MenuOptions _selection;

  NotesRepository notesRepository;

  _DetailPageState(this.notesRepository);

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
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> getAppBarActions(BuildContext context) {
    var outOfPopUpContext = context;

    var popupMenuButton = PopupMenuButton<MenuOptions>(
      onSelected: (MenuOptions result) async {
        switch (result) {
          case MenuOptions.delete:
            await onDeleteButtonPressed(outOfPopUpContext);
            break;
          case MenuOptions.cancel:
            Navigator.of(context).pop();
            break;
          default:
            break;
        }
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<MenuOptions>>[
        PopupMenuItem<MenuOptions>(
          value: MenuOptions.cancel,
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(
                  Icons.cancel,
                  color: Colors.grey,
                ),
              ),
              Text('Cancel'),
            ],
          ),
        ),
        PopupMenuItem<MenuOptions>(
          value: MenuOptions.delete,
          enabled: note.id > 0,
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(
                  Icons.delete,
                  color: Colors.grey,
                ),
              ),
              Text('Delete'),
            ],
          ),
        ),
      ],
    );

    var archiveButton = IconButton(
      icon: Icon(Icons.archive),
      onPressed: () async {
        bool success = await _archiveNote(note);

        if (success) {
          note.archived = !note.archived;

          _showToast(context, note.archived ? "Archived" : "Unarchived");
        }
      },
    );

    return List<Widget>.of([if (note.id > 0) archiveButton, popupMenuButton]);
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

  Future<int> _saveNote(Note note) {
    return notesRepository.saveNoteAsync(
      note,
      DateTime.now().millisecondsSinceEpoch.toString(),
    );
  }

  Future<bool> _archiveNote(Note note) {
    return notesRepository.updateNoteArchivedStatusAsync(
      note.id,
      !note.archived,
    );
  }

  Future<bool> _deleteNote(int id) => notesRepository.deleteNoteAsync(id);
}
