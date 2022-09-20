import 'package:floor/floor.dart';

@Entity(tableName: 'steps_count_table')
class StepsData {
  @PrimaryKey(autoGenerate: true)
  @ColumnInfo(name: "id")
  int? id;

  @ColumnInfo(name: "stepDate")
  String? stepDate;

  @ColumnInfo(name: "steps")
  int? steps;

  @ColumnInfo(name: "targetSteps")
  int? targetSteps;

  @ColumnInfo(name: "time")
  String? time;

  @ColumnInfo(name: "dateTime")
  String? dateTime;

  @ColumnInfo(name: "duration")
  String? duration;

  @ColumnInfo(name: "distance")
  double? distance;

  @ColumnInfo(name: "cal")
  int? calorie;

  StepsData(
      {this.id,
        required this.stepDate,
        required this.steps,
        required this.targetSteps,
        required this.time,
        required this.dateTime,
        required this.duration,
        required this.distance,
        required this.calorie});

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'id': id,
      'stepDate': stepDate,
      'steps': steps,
      'targetSteps': targetSteps,
      'time': time,
      'dateTime': dateTime,
      'duration': duration,
      'distance': distance,
      'calorie': calorie,
    };
    return map;
  }

  StepsData.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    stepDate = map['stepDate'];
    steps = map['steps'];
    targetSteps = map['targetSteps'];
    time = map['time'];
    dateTime = map['dateTime'];
    duration = map['duration'];
    distance = map['distance'];
    calorie = map['calorie'];
  }

  @override
  String toString() {
    return 'StepsData{id: $id, stepDate: $stepDate, steps: $steps, targetSteps: $targetSteps, time: $time, dateTime: $dateTime, duration: $duration, distance: $distance, calorie: $calorie}';
  }
}