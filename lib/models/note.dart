class Note {
  int id;
  String title;
  String description;
  String timestamp;
  bool archived;

  Note({
    required this.id,
    required this.title,
    required this.description,
    required this.timestamp,
    this.archived = false,
  });

  Map<String, dynamic> toMap({bool withId = false}) {
    Map<String, dynamic> map = {
      'title': title.trim(),
      'description': description.trim(),
      'timestamp': timestamp,
      'archived': archived ? 1 : 0,
    };

    if (withId) {
      map.addAll({'id': id});
    }

    return map;
  }

  static Note fromMap(Map<String, dynamic> map) {
    var timestamp = map['timestamp'];
    var archived = map['archived'] == 1;

    return Note(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      archived: archived,
      timestamp: timestamp ?? '',
    );
  }

  static Note empty() {
    return Note(
      id: 0,
      title: '',
      description: '',
      timestamp: '',
      archived: false,
    );
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
      archived: this.archived
    );
  }
}
