import 'package:flutter/material.dart';
import 'package:storage_sisecam/screens/start_screen.dart';
import 'package:storage_sisecam/services/auth_service.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final AuthService _authService = AuthService();

  String? _selectedRole;
  String? _selectedDepartment;

  void _register() {
    final username = _usernameController.text.trim();
    final password = _passwordController.text.trim();

    if (_selectedRole == null || _selectedDepartment == null) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Eksik Bilgi'),
          content: const Text('Lütfen rol ve departman seçiniz.'),
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

    if (_authService.isUserExists(username)) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Kayıt Başarısız'),
          content: const Text('Bu kullanıcı adı zaten kayıtlı.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Tamam'),
            ),
          ],
        ),
      );
    } else {
      _authService.register(
        username,
        password,
        role: _selectedRole!,
        department: _selectedDepartment!,
      );

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Kayıt Başarılı'),
          content: const Text('Artık giriş yapabilirsiniz.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const StartScreen()),
                );
              },
              child: const Text('Girişe Git'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Kayıt Ol')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(
                labelText: 'Yeni Kullanıcı Adı',
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(
                labelText: 'Yeni Şifre',
              ),
              obscureText: true,
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(labelText: 'Rol'),
              value: _selectedRole,
              items: const [
                DropdownMenuItem(value: 'worker', child: Text('Çalışan')),
                DropdownMenuItem(value: 'manager', child: Text('Departman Müdürü')),
                DropdownMenuItem(value: 'firin_sefi', child: Text('Fırın Şefi')),
                DropdownMenuItem(value: 'fabrika_muduru', child: Text('Fabrika Müdürü')),
                DropdownMenuItem(value: 'admin', child: Text('Yönetici')),
              ],
              onChanged: (value) {
                setState(() {
                  _selectedRole = value;
                });
              },
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(labelText: 'Departman'),
              value: _selectedDepartment,
              items: const [
                DropdownMenuItem(value: 'fabrikasyon', child: Text('Fabrikasyon')),
                DropdownMenuItem(value: 'lojistik', child: Text('Lojistik')),
                DropdownMenuItem(value: 'planlama', child: Text('Planlama')),
              ],
              onChanged: (value) {
                setState(() {
                  _selectedDepartment = value;
                });
              },
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _register,
              child: const Text('Kayıt Ol'),
            ),
          ],
        ),
      ),
    );
  }
}
