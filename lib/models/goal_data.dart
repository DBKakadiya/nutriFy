class Goals{
  String? goal;

  Goals({required this.goal});

  Map<String, dynamic> toMap(){
    var map = <String, dynamic>{
      'goal': goal};
    return map;
  }

  Goals.fromMap(Map<String, dynamic> map) {
    goal = map['goal'];
  }

  @override
  String toString() {
    return 'Goals{goal: $goal}';
  }
}