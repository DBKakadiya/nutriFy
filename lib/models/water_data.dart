class WaterData {
  String? date;
  String? water;

  WaterData({
    required this.date,
    required this.water,
  });

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{'date': date, 'water': water};
    return map;
  }

  WaterData.fromMap(Map<String, dynamic> map) {
    date = map['date'];
    water = map['water'];
  }

  @override
  String toString() {
    return 'WaterData{date: $date, water: $water}';
  }
}
