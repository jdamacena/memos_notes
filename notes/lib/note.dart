class Note {
  int id;
  String title;
  String description;
  String timestamp;

  // TODO add timestamp;

  Note({
    required this.id,
    required this.title,
    required this.description,
    required this.timestamp,
  });

  // Convert a Note into a Map. The keys must correspond to the names of the
  // columns in the database.
  Map<String, dynamic> toMap({bool withId = false}) {
    Map<String, dynamic> map = {
      'title': title.trim(),
      'description': description.trim(),
      'timestamp': timestamp
    };

    if (withId) {
      map.addAll({'id': id});
    }

    return map;
  }

  @override
  String toString() {
    return this.toMap(withId: true).toString();
  }
}
