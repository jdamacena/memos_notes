class Note {
  int id;
  String title;
  String description;
  String timestamp;

  Note({
    required this.id,
    required this.title,
    required this.description,
    required this.timestamp,
  });

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

  Note copy() {
    return Note(
      id: this.id,
      description: this.description,
      timestamp: this.timestamp,
      title: this.title,
    );
  }
}
