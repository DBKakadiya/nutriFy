class FoodData {
  int? id;
  String? type;
  String? date;
  String? brandName;
  String? description;
  int? servingSize;
  String? servingUnit;
  int? servingContainer;
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

  FoodData({
    required this.id,
    required this.type,
    required this.date,
    required this.brandName,
    required this.description,
    required this.servingSize,
    required this.servingUnit,
    required this.servingContainer,
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
  });

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'id': id,
      'type': type,
      'date': date,
      'brandName': brandName,
      'description': description,
      'servingSize': servingSize,
      'servingUnit': servingUnit,
      'servingContainer': servingContainer,
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
    };
    return map;
  }

  FoodData.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    type = map['type'];
    date = map['date'];
    brandName = map['brandName'];
    description = map['description'];
    servingSize = map['servingSize'];
    servingUnit = map['servingUnit'];
    servingContainer = map['servingContainer'];
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
  }

  @override
  String toString() {
    return 'FoodData{id: $id, type: $type, date: $date, brandName: $brandName, description: $description, servingSize: $servingSize, servingUnit: $servingUnit, servingContainer: $servingContainer, calorie: $calorie, fat: $fat, satFat: $satFat, sodium: $sodium, cholesterol: $cholesterol, carbohydrates: $carbohydrates, potassium: $potassium, protein: $protein, fiber: $fiber, sugar: $sugar, vitaminA: $vitaminA, vitaminC: $vitaminC, calcium: $calcium, iron: $iron, time: $time}';
  }
}
