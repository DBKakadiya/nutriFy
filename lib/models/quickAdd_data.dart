class QuickAddData {
  int? id;
  String? type;
  String? date;
  String? calorie;
  String? carbohydrates;
  String? fat;
  String? protein;
  String? time;

  QuickAddData({
    required this.id,
    required this.type,
    required this.date,
    required this.calorie,
    required this.carbohydrates,
    required this.fat,
    required this.protein,
    required this.time,
  });

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'id': id,
      'type': type,
      'date': date,
      'calorie': calorie,
      'carbohydrates': carbohydrates,
      'fat': fat,
      'protein': protein,
      'time': time,
    };
    return map;
  }

  QuickAddData.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    type = map['type'];
    date = map['date'];
    calorie = map['calorie'];
    carbohydrates = map['carbohydrates'];
    fat = map['fat'];
    protein = map['protein'];
    time = map['time'];
  }

  @override
  String toString() {
    return 'QuickAddData{id: $id, type: $type, date: $date, calorie: $calorie, carbohydrates: $carbohydrates, fat: $fat, protein: $protein, time: $time}';
  }
}
