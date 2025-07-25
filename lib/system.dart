import 'package:flutter/material.dart';
import 'package:storage_sisecam/screens/start_screen.dart';

class System extends StatefulWidget {
  const System({Key? key}) : super(key: key);

  @override
  State<System> createState() => _StorageState();
}

class _StorageState extends State<System> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromARGB(255, 221, 149, 149),
                Color.fromARGB(255, 213, 194, 194),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: const StartScreen(), // artık parametre göndermiyoruz
        ),
      ),
    );
  }
}
