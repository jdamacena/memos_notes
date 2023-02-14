import 'package:flutter/material.dart';

class ArchivedTile extends StatelessWidget {
  const ArchivedTile({
    Key? key,
    required this.onPressed,
  }) : super(key: key);

  final Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: onPressed,
      child: SizedBox(
        height: 60.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.archive,
              color: Colors.amber,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Text("Archived"),
            ),
          ],
        ),
      ),
    );
  }
}
