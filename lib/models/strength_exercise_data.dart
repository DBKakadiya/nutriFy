class StrengthData {
  int? id;
  String? date;
  String? description;
  String? hashOfSet;
  String? repetitionSet;
  String? weightPerRepetition;
  String? time;
  String? calorie;

  StrengthData({
    required this.id,
    required this.date,
    required this.description,
    required this.hashOfSet,
    required this.repetitionSet,
    required this.weightPerRepetition,
    required this.time,
    required this.calorie,
  });

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'id': id,
      'date': date,
      'description': description,
      'hashOfSet': hashOfSet,
      'repetitionSet': repetitionSet,
      'weightPerRepetition': weightPerRepetition,
      'time': time,
      'calorie': calorie,
    };
    return map;
  }

  StrengthData.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    date = map['date'];
    description = map['description'];
    hashOfSet = map['hashOfSet'];
    repetitionSet = map['repetitionSet'];
    weightPerRepetition = map['weightPerRepetition'];
    time = map['time'];
    calorie = map['calorie'];
  }

  @override
  String toString() {
    return 'StrengthData{id: $id, date: $date, description: $description, hashOfSet: $hashOfSet, repetitionSet: $repetitionSet, weightPerRepetition: $weightPerRepetition, time: $time, calorie: $calorie}';
  }
}
