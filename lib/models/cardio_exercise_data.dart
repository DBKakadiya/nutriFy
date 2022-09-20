class CardioData {
  int? id;
  String? date;
  String? description;
  String? time;
  String? calorie;

  CardioData({
    required this.id,
    required this.date,
    required this.description,
    required this.time,
    required this.calorie,
  });

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'id': id,
      'date': date,
      'description': description,
      'time': time,
      'calorie': calorie
    };
    return map;
  }

  CardioData.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    date = map['date'];
    description = map['description'];
    time = map['time'];
    calorie = map['calorie'];
  }

  @override
  String toString() {
    return 'CardioData{id: $id, date: $date, description: $description, time: $time, calorie: $calorie}';
  }
}
