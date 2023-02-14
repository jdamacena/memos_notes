import 'package:flutter/material.dart';
import 'package:notes/models/note.dart';

class NoteListItem extends StatelessWidget {
  final void Function() onTap;
  final Note note;

  const NoteListItem({
    required Key key,
    required this.note,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
        borderRadius: BorderRadius.all(Radius.circular(4.0)),
      ),
      child: ListTile(
        leading: Column(mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(note.archived ? Icons.archive_outlined : Icons.edit_note),
          ],
        ),
        title: Text(
          note.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: note.description.trim().length <= 0
            ? null
            : Text(
                note.description,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
        onTap: onTap,
      ),
    );
  }
}
