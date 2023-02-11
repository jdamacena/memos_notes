import 'package:flutter/material.dart';
import 'package:notes/models/note.dart';

class NoteListItem extends StatelessWidget {
  final void Function() onTap;
  final Note note;

  const NoteListItem({
    required Key key,
    required Note this.note,
    required void Function() this.onTap,
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
        borderRadius: BorderRadius.all(Radius.circular(8.0)),
      ),
      child: ListTile(
        title: Text(
          note.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: note.description.trim().length <= 0
            ? null
            : Text(
                note.description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
        onTap: onTap,
      ),
    );
  }
}
