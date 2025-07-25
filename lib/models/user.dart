import 'package:hive/hive.dart';

part 'user.g.dart'; // Hive için kod üretimi

@HiveType(typeId: 3)
class User extends HiveObject {
  @HiveField(0)
  late String username;

  @HiveField(1)
  late String password;

  @HiveField(2)
  late String role; // örnek: 'worker', 'manager', 'admin'

  @HiveField(3)
  late String department; // örnek: 'fabrikasyon', 'lojistik'

  User({
    required this.username,
    required this.password,
    required this.role,
    required this.department,
  });
}
