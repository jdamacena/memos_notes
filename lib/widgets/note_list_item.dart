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
    const textPadding = const EdgeInsets.all(2.0);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 4.0,
          vertical: 8.0,
        ),
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
        child: Row(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(
                    note.archived ? Icons.archive_outlined : Icons.edit_note,
                    color: Theme.of(context).colorScheme.secondary,

                  ),
                ),
              ],
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: textPadding,
                    child: Text(
                      note.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 16.0,
                      ),
                    ),
                  ),
                  if (note.description.trim().length > 0)
                    Padding(
                      padding: textPadding,
                      child: Text(
                        note.description,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  Padding(
                    padding: textPadding,
                    child: Text(
                      note.formattedTimestamp,
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
