import 'package:hive/hive.dart';
import 'package:storage_sisecam/models/user.dart'; // Bu gerekli!

class AuthService {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  final Box<User> userBox = Hive.box<User>('users');

  // Giriş yapma
  bool login(String username, String password) {
    if (userBox.containsKey(username)) {
      final user = userBox.get(username);
      return user?.password == password;
    }
    return false;
  }

  // Kullanıcı kontrolü
  bool isUserExists(String username) {
    return userBox.containsKey(username);
  }

  // Kayıt
  void register(String username, String password, {
    required String role,
    required String department,
  }) {
    final newUser = User(
      username: username,
      password: password,
      role: role,
      department: department,
    );
    userBox.put(username, newUser);
  }

  // Rol alma
  String? getRole(String username) {
    return userBox.get(username)?.role;
  }

  // Departman alma
  String? getDepartment(String username) {
    return userBox.get(username)?.department;
  }

  // Kullanıcı nesnesini döndürme
  User? getUser(String username) {
    return userBox.get(username);
  }

  // Session Box erişimi
  static final Box sessionBox = Hive.box('session');
}
