class NotesData {
  String? date;
  String? foodNote;
  String? exerciseNote;

  NotesData({
    required this.date,
    required this.foodNote,
    required this.exerciseNote,
  });

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'date': date,
      'foodNote': foodNote,
      'exerciseNote': exerciseNote
    };
    return map;
  }

  NotesData.fromMap(Map<String, dynamic> map) {
    date = map['date'];
    foodNote = map['foodNote'];
    exerciseNote = map['exerciseNote'];
  }

  @override
  String toString() {
    return 'NotesData{date: $date, foodNote: $foodNote, exerciseNote: $exerciseNote}';
  }
}
