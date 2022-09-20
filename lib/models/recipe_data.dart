class RecipeData {
  int? id;
  String? type;
  String? date;
  String? recipeName;
  int? servings;
  String? ingredients;
  String? calorie;
  String? time;

  RecipeData({
    required this.id,
    required this.type,
    required this.date,
    required this.recipeName,
    required this.servings,
    required this.ingredients,
    required this.calorie,
    required this.time,
  });

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'id': id,
      'type': type,
      'date': date,
      'recipeName': recipeName,
      'servings': servings,
      'ingredients': ingredients,
      'calorie': calorie,
      'time': time,
    };
    return map;
  }

  RecipeData.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    type = map['type'];
    date = map['date'];
    recipeName = map['recipeName'];
    servings = map['servings'];
    ingredients = map['ingredients'];
    calorie = map['calorie'];
    time = map['time'];
  }

  @override
  String toString() {
    return 'RecipeData{id: $id, type: $type, date: $date, recipeName: $recipeName, servings: $servings, ingredients: $ingredients, calorie: $calorie, time: $time}';
  }
}
