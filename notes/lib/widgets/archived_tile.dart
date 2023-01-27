import 'package:flutter/material.dart';

class ArchivedTile extends StatelessWidget {
  const ArchivedTile({
    Key? key,
    required this.onPressed,
  }) : super(key: key);

  final Null Function() onPressed;

  @override
  Widget build(BuildContext context) {
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
            onPressed: onPressed,
          ),
        ],
      ),
    );
  }
}
