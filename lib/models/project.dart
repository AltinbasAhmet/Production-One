import 'package:hive/hive.dart';

part 'project.g.dart';

@HiveType(typeId: 2)
class Project extends HiveObject {
  @HiveField(0)
  String title;

  @HiveField(1)
  String manager;

  @HiveField(2)
  String contributors;

  @HiveField(3)
  DateTime startDate;

  @HiveField(4)
  DateTime endDate;

  @HiveField(5)
  double estimatedCost;

  @HiveField(6)
  String factory;

  Project({
    required this.title,
    required this.manager,
    required this.contributors,
    required this.startDate,
    required this.endDate,
    required this.estimatedCost,
    required this.factory,
  });
}
