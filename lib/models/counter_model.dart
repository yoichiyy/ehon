import 'package:hive/hive.dart';

part 'counter_model.g.dart';

// To generate new files, run:
// ` flutter pub run build_runner build --delete-conflicting-outputs`
@HiveType(typeId: 0)
class CounterModel extends HiveObject {
  CounterModel({required this.id, required this.count});

  @HiveField(0)
  String id;

  @HiveField(1)
  int count;

  @override
  String toString() => "$id - ${count.toString()}";
}
