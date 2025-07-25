import 'package:flutter/material.dart';
import 'package:storage_sisecam/screens/home_screen.dart';
import 'package:storage_sisecam/screens/register_screen.dart';
import 'package:storage_sisecam/services/auth_service.dart'; // AuthService import edildi

class StartScreen extends StatefulWidget {
  const StartScreen({Key? key}) : super(key: key);

  @override
  State<StartScreen> createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  


  void _login() {
    final username = _usernameController.text.trim();
    final password = _passwordController.text.trim();
    final AuthService _authService = AuthService(); // Singleton instance

    if (username.isEmpty || password.isEmpty) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Eksik Bilgi'),
      content: const Text('Kullanıcı adı ve şifre boş bırakılamaz.'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Tamam'),
        ),
      ],
    ),
  );
  return;
}


  if (_authService.login(username, password)) {
  final user = _authService.getUser(username);

  if (user != null) {
    final box = AuthService.sessionBox;

    box.put('username', user.username);
    box.put('role', user.role);
    box.put('department', user.department);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const HomeScreen()),
    );
  } else {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hata'),
        content: const Text('Kullanıcı bilgileri alınamadı.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Tamam'),
          ),
        ],
      ),
    );
  }
}
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Üretim Sistemi - Giriş')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(
                labelText: 'Kullanıcı Adı veya ID',
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(
                labelText: 'Şifre',
              ),
              obscureText: true,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _login,
              child: const Text('Giriş Yap'),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const RegisterScreen()),
                );
              },
              child: const Text('Hesabınız yok mu? Kayıt olun'),
            ),
          ],
        ),
      ),
    );
  }
}
