class UserData {
  String? name;
  String? gender;
  int? age;
  String? dateOfBirth;
  String? country;
  String? height;
  String? weight;
  String? currentWeight;
  String? goalReason;
  String? activityLevel;
  String? goalWeight;
  String? weeklyGoal;
  String? startDate;
  String? caloriesGoal;
  String? carbohydrates;
  int? percentageCarbohydrates;
  String? protein;
  int? percentageProtein;
  String? fat;
  int? percentageFat;
  String? satFat;
  String? cholesterol;
  String? sodium;
  String? potassium;
  String? fiber;
  String? sugars;
  String? vitaminA;
  String? vitaminC;
  String? calcium;
  String? iron;

  UserData({
    required this.name,
    required this.gender,
    required this.age,
    required this.dateOfBirth,
    required this.country,
    required this.height,
    required this.weight,
    required this.currentWeight,
    required this.goalReason,
    required this.activityLevel,
    required this.goalWeight,
    required this.weeklyGoal,
    required this.startDate,
    required this.caloriesGoal,
    required this.carbohydrates,
    required this.percentageCarbohydrates,
    required this.protein,
    required this.percentageProtein,
    required this.fat,
    required this.percentageFat,
    required this.satFat,
    required this.cholesterol,
    required this.sodium,
    required this.potassium,
    required this.fiber,
    required this.sugars,
    required this.vitaminA,
    required this.vitaminC,
    required this.calcium,
    required this.iron
  });

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'name': name,
      'gender': gender,
      'age': age,
      'dateOfBirth': dateOfBirth,
      'country': country,
      'height': height,
      'weight': weight,
      'currentWeight': currentWeight,
      'goalReason': goalReason,
      'activityLevel': activityLevel,
      'goalWeight': goalWeight,
      'weeklyGoal': weeklyGoal,
      'startDate': startDate,
      'caloriesGoal': caloriesGoal,
      'carbohydrates': carbohydrates,
      'percentageCarbohydrates': percentageCarbohydrates,
      'protein': protein,
      'percentageProtein': percentageProtein,
      'fat': fat,
      'percentageFat': percentageFat,
      'satFat': satFat,
      'cholesterol': cholesterol,
      'sodium': sodium,
      'potassium': potassium,
      'fiber': fiber,
      'sugars': sugars,
      'vitaminA': vitaminA,
      'vitaminC': vitaminC,
      'calcium': calcium,
      'iron': iron,
    };
    return map;
  }

  UserData.fromMap(Map<String, dynamic> map) {
    name = map['name'];
    gender = map['gender'];
    age = map['age'];
    dateOfBirth = map['dateOfBirth'];
    country = map['country'];
    height = map['height'];
    weight = map['weight'];
    currentWeight = map['currentWeight'];
    goalReason = map['goalReason'];
    activityLevel = map['activityLevel'];
    goalWeight = map['goalWeight'];
    weeklyGoal = map['weeklyGoal'];
    startDate = map['startDate'];
    caloriesGoal = map['caloriesGoal'];
    carbohydrates = map['carbohydrates'];
    percentageCarbohydrates = map['percentageCarbohydrates'];
    protein = map['protein'];
    percentageProtein = map['percentageProtein'];
    fat = map['fat'];
    percentageFat = map['percentageFat'];
    satFat = map['satFat'];
    cholesterol = map['cholesterol'];
    sodium = map['sodium'];
    potassium = map['potassium'];
    fiber = map['fiber'];
    sugars = map['sugars'];
    vitaminA = map['vitaminA'];
    vitaminC = map['vitaminC'];
    calcium = map['calcium'];
    iron = map['iron'];
  }

  @override
  String toString() {
    return 'UserData{name: $name, gender: $gender, age: $age, dateOfBirth: $dateOfBirth, country: $country, height: $height, weight: $weight, currentWeight: $currentWeight, goalReason: $goalReason, activityLevel: $activityLevel, goalWeight: $goalWeight, weeklyGoal: $weeklyGoal, startDate: $startDate, caloriesGoal: $caloriesGoal, carbohydrates: $carbohydrates, percentageCarbohydrates: $percentageCarbohydrates, protein: $protein, percentageProtein: $percentageProtein, fat: $fat, percentageFat: $percentageFat, satFat: $satFat, cholesterol: $cholesterol, sodium: $sodium, potassium: $potassium, fiber: $fiber, sugars: $sugars, vitaminA: $vitaminA, vitaminC: $vitaminC, calcium: $calcium, iron: $iron}';
  }
}
