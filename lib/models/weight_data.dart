class WeightData {
  String? date;
  String? weight;
  String? image;

  WeightData({
    required this.date,
    required this.weight,
    required this.image,
  });

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{'date': date, 'weight': weight, 'image': image};
    return map;
  }

  WeightData.fromMap(Map<String, dynamic> map) {
    date = map['date'];
    weight = map['weight'];
    image = map['image'];
  }

  @override
  String toString() {
    return 'WeightData{date: $date, weight: $weight, image: $image}';
  }
}
