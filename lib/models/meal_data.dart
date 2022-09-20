class MealData {
  int? id;
  String? type;
  String? date;
  String? image;
  String? name;
  String? calorie;
  String? fat;
  String? satFat;
  String? sodium;
  String? cholesterol;
  String? carbohydrates;
  String? potassium;
  String? protein;
  String? fiber;
  String? sugar;
  String? vitaminA;
  String? vitaminC;
  String? calcium;
  String? iron;
  String? time;
  String? direction;

  MealData({
    required this.id,
    required this.type,
    required this.date,
    required this.image,
    required this.name,
    required this.calorie,
    required this.fat,
    required this.satFat,
    required this.sodium,
    required this.cholesterol,
    required this.carbohydrates,
    required this.potassium,
    required this.protein,
    required this.fiber,
    required this.sugar,
    required this.vitaminA,
    required this.vitaminC,
    required this.calcium,
    required this.iron,
    required this.time,
    required this.direction,
  });

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'id': id,
      'type': type,
      'date': date,
      'image': image,
      'name': name,
      'calorie': calorie,
      'fat': fat,
      'satFat': satFat,
      'sodium': sodium,
      'cholesterol': cholesterol,
      'carbohydrates': carbohydrates,
      'potassium': potassium,
      'protein': protein,
      'fiber': fiber,
      'sugar': sugar,
      'vitaminA': vitaminA,
      'vitaminC': vitaminC,
      'calcium': calcium,
      'iron': iron,
      'time': time,
      'direction': direction,
    };
    return map;
  }

  MealData.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    type = map['type'];
    date = map['date'];
    image = map['image'];
    name = map['name'];
    calorie = map['calorie'];
    fat = map['fat'];
    satFat = map['satFat'];
    sodium = map['sodium'];
    cholesterol = map['cholesterol'];
    carbohydrates = map['carbohydrates'];
    potassium = map['potassium'];
    protein = map['protein'];
    fiber = map['fiber'];
    sugar = map['sugar'];
    vitaminA = map['vitaminA'];
    vitaminC = map['vitaminC'];
    calcium = map['calcium'];
    iron = map['iron'];
    time = map['time'];
    direction = map['direction'];
  }

  @override
  String toString() {
    return 'MealData{id: $id, type: $type, date: $date, image: $image, name: $name, calorie: $calorie, fat: $fat, satFat: $satFat, sodium: $sodium, cholesterol: $cholesterol, carbohydrates: $carbohydrates, potassium: $potassium, protein: $protein, fiber: $fiber, sugar: $sugar, vitaminA: $vitaminA, vitaminC: $vitaminC, calcium: $calcium, iron: $iron, time: $time, direction: $direction}';
  }
}
