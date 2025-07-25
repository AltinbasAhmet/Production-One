import 'package:flutter/material.dart';
import 'package:storage_sisecam/screens/factory_detail_screen.dart';


class WarehouseScreen extends StatelessWidget {
  const WarehouseScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const List<String> factories = [
    'Fabrika A',
    'Fabrika B',
    'Fabrika C',
    'Fabrika D',
    'Fabrika E',
  ];
  
    return Scaffold(
      appBar: AppBar(
        title: const Text('Depolar'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: factories.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  backgroundColor: Colors.blueGrey.shade200,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => FactoryDetailScreen(factoryName: factories[index]),
                    ),
                  );
                },
                child: Text(
                  factories[index],
                  style: const TextStyle(fontSize: 18),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
