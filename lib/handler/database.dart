import 'dart:async';

import 'package:floor/floor.dart';

import '../models/step_data.dart';
import 'StepsInfo.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

String stepCountTable = 'steps_count_table';
String stepCountId = 'id';
String stepDate = 'stepDate';
String steps = 'steps';
String targetSteps = 'targetSteps';
String stepCountTime = 'time';
String stepCountDateTime = 'dateTime';
String stepCountDuration = 'duration';
String stepCountDistance = 'distance';
String stepCountCalorie = 'calorie';

@Database(version: 1, entities: [StepsData])
abstract class FlutterDatabase extends FloorDatabase {
  StepsInfo get stepsInfo;
}

class $FloorFlutterDatabase {
  static _DatabaseBuilder databaseBuilder(String name) =>
      _DatabaseBuilder(name);

  static _DatabaseBuilder inMemoryDatabaseBuilder() => _DatabaseBuilder(null);
}

class _DatabaseBuilder {
  _DatabaseBuilder(this.name);

  final String? name;

  final List<Migration> _migrations = [];

  Callback? _callback;

  _DatabaseBuilder addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  _DatabaseBuilder addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  Future<FlutterDatabase> build() async {
    final path = name != null
        ? await sqfliteDatabaseFactory.getDatabasePath(name!)
        : ':memory:';
    final database = _Database();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}

class _Database extends FlutterDatabase {
  _Database([StreamController<String>? listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  StepsInfo? _stepsInfoInstance;

  Future<sqflite.Database> open(String path, List<Migration> migrations,
      [Callback? callback]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 1,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
        await callback?.onConfigure?.call(database);
      },
      onOpen: (database) async {
        await callback?.onOpen?.call(database);
      },
      onUpgrade: (database, startVersion, endVersion) async {
        await MigrationAdapter.runMigrations(
            database, startVersion, endVersion, migrations);

        await callback?.onUpgrade?.call(database, startVersion, endVersion);
      },
      onCreate: (database, version) async {
        await database.execute(
            'CREATE TABLE IF NOT EXISTS $stepCountTable ($stepCountId INTEGER PRIMARY KEY AUTOINCREMENT, $stepDate TEXT, $steps INTEGER, $targetSteps INTEGER, $stepCountTime TEXT, $stepCountDateTime TEXT, $stepCountDuration TEXT, $stepCountDistance REAL, $stepCountCalorie INTEGER)');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  StepsInfo get stepsInfo =>
      _stepsInfoInstance ??= _StepsInfo(database, changeListener);
}

class _StepsInfo extends StepsInfo {
  _StepsInfo(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database),
        _stepsDataInsertionAdapter = InsertionAdapter(
            database,
            stepCountTable,
            (StepsData item) => <String, Object?>{
                  stepCountId: item.id,
                  stepDate: item.stepDate,
                  steps: item.steps,
                  targetSteps: item.targetSteps,
                  stepCountTime: item.time,
                  stepCountDateTime: item.dateTime,
                  stepCountDuration: item.duration,
                  stepCountDistance: item.distance,
                  stepCountCalorie: item.calorie
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<StepsData> _stepsDataInsertionAdapter;

  @override
  Future<List<StepsData>> getAllStepsData() async {
    return _queryAdapter.queryList('SELECT * FROM $stepCountTable',
        mapper: (Map<String, Object?> row) => StepsData(
            id: row[stepCountId] as int?,
            stepDate: row[stepDate] as String?,
            steps: row[steps] as int?,
            targetSteps: row[targetSteps] as int?,
            time: row[stepCountTime] as String?,
            dateTime: row[stepCountDateTime] as String?,
            duration: row[stepCountDuration] as String?,
            distance: row[stepCountDistance] as double?,
            calorie: row[stepCountCalorie] as int?));
  }

  @override
  Future<List<StepsData>> getStepsForCurrentWeekSun() async {
    return _queryAdapter.queryList(
        'SELECT * FROM $stepCountTable WHERE (DATE(stepDate) >= DATE("now","weekday 0","-7 days"))',
        mapper: (Map<String, Object?> row) => StepsData(
            id: row[stepCountId] as int?,
            stepDate: row[stepDate] as String?,
            steps: row[steps] as int?,
            targetSteps: row[targetSteps] as int?,
            time: row[stepCountTime] as String?,
            dateTime: row[stepCountDateTime] as String?,
            duration: row[stepCountDuration] as String?,
            distance: row[stepCountDistance] as double?,
            calorie: row[stepCountCalorie] as int?));
  }

  @override
  Future<List<StepsData>> getStepsForCurrentWeekSat() async {
    return _queryAdapter.queryList(
        'SELECT * FROM $stepCountTable WHERE (DATE(stepDate) >= DATE("now","weekday 6","-7 days"))',
        mapper: (Map<String, Object?> row) => StepsData(
            id: row[stepCountId] as int?,
            stepDate: row[stepDate] as String?,
            steps: row[steps] as int?,
            targetSteps: row[targetSteps] as int?,
            time: row[stepCountTime] as String?,
            dateTime: row[stepCountDateTime] as String?,
            duration: row[stepCountDuration] as String?,
            distance: row[stepCountDistance] as double?,
            calorie: row[stepCountCalorie] as int?));
  }

  @override
  Future<List<StepsData>> getStepsForCurrentWeekMon() async {
    return _queryAdapter.queryList(
        'SELECT * FROM $stepCountTable WHERE (DATE(stepDate) >= DATE("now","weekday 1","-7 days"))',
        mapper: (Map<String, Object?> row) => StepsData(
            id: row[stepCountId] as int?,
            stepDate: row[stepDate] as String?,
            steps: row[steps] as int?,
            targetSteps: row[targetSteps] as int?,
            time: row[stepCountTime] as String?,
            dateTime: row[stepCountDateTime] as String?,
            duration: row[stepCountDuration] as String?,
            distance: row[stepCountDistance] as double?,
            calorie: row[stepCountCalorie] as int?));
  }

  @override
  Future<StepsData?> getTotalStepsForLast7Days() async {
    return _queryAdapter.query(
        'SELECT IFNULL(SUM(steps),0) as steps FROM $stepCountTable WHERE DATE(stepDate) >= (SELECT DATE("now","-7 days"))',
        mapper: (Map<String, Object?> row) => StepsData(
            id: row[stepCountId] as int?,
            stepDate: row[stepDate] as String?,
            steps: row[steps] as int?,
            targetSteps: row[targetSteps] as int?,
            time: row[stepCountTime] as String?,
            dateTime: row[stepCountDateTime] as String?,
            duration: row[stepCountDuration] as String?,
            distance: row[stepCountDistance] as double?,
            calorie: row[stepCountCalorie] as int?));
  }

  @override
  Future<List<StepsData>> getStepsForCurrentMonth() async {
    return _queryAdapter.queryList(
        'SELECT * FROM $stepCountTable WHERE (DATE(stepDate) >= DATE("now","start of month"))',
        mapper: (Map<String, Object?> row) => StepsData(
            id: row[stepCountId] as int?,
            stepDate: row[stepDate] as String?,
            steps: row[steps] as int?,
            targetSteps: row[targetSteps] as int?,
            time: row[stepCountTime] as String?,
            dateTime: row[stepCountDateTime] as String?,
            duration: row[stepCountDuration] as String?,
            distance: row[stepCountDistance] as double?,
            calorie: row[stepCountCalorie] as int?));
  }

  @override
  Future<StepsData?> getTotalStepsForCurrentMonth() async {
    return _queryAdapter.query(
        'SELECT IFNULL(SUM(steps),0) as steps FROM $stepCountTable WHERE (DATE(stepDate) >= DATE("now","start of month"))',
        mapper: (Map<String, Object?> row) => StepsData(
            id: row[stepCountId] as int?,
            stepDate: row[stepDate] as String?,
            steps: row[steps] as int?,
            targetSteps: row[targetSteps] as int?,
            time: row[stepCountTime] as String?,
            dateTime: row[stepCountDateTime] as String?,
            duration: row[stepCountDuration] as String?,
            distance: row[stepCountDistance] as double?,
            calorie: row[stepCountCalorie] as int?));
  }

  @override
  Future<StepsData?> getTotalStepsForCurrentWeek() async {
    return _queryAdapter.query(
        'SELECT IFNULL(SUM(steps),0) as steps FROM $stepCountTable WHERE (DATE(stepDate) >= DATE("now","weekday 1","-7 days"))',
        mapper: (Map<String, Object?> row) => StepsData(
            id: row[stepCountId] as int?,
            stepDate: row[stepDate] as String?,
            steps: row[steps] as int?,
            targetSteps: row[targetSteps] as int?,
            time: row[stepCountTime] as String?,
            dateTime: row[stepCountDateTime] as String?,
            duration: row[stepCountDuration] as String?,
            distance: row[stepCountDistance] as double?,
            calorie: row[stepCountCalorie] as int?));
  }

  @override
  Future<List<StepsData>> getLast7DaysStepsData() async {
    return _queryAdapter.queryList(
        'SELECT * FROM $stepCountTable WHERE (DATE(stepDate) >= DATE("now","-7 days"))',
        mapper: (Map<String, Object?> row) => StepsData(
            id: row[stepCountId] as int?,
            stepDate: row[stepDate] as String?,
            steps: row[steps] as int?,
            targetSteps: row[targetSteps] as int?,
            time: row[stepCountTime] as String?,
            dateTime: row[stepCountDateTime] as String?,
            duration: row[stepCountDuration] as String?,
            distance: row[stepCountDistance] as double?,
            calorie: row[stepCountCalorie] as int?));
  }

  @override
  Future<void> insertAllStepsData(StepsData stepsData) async {
    await _stepsDataInsertionAdapter.insert(
        stepsData, OnConflictStrategy.abort);
  }
}
