import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:storage_sisecam/models/idle_product.dart';
import 'package:storage_sisecam/screens/idle_product_screen.dart';
import 'package:intl/intl.dart';

class IdleProductListScreen extends StatefulWidget {
  const IdleProductListScreen({super.key});

  @override
  State<IdleProductListScreen> createState() => _IdleProductListScreenState();
}

class _IdleProductListScreenState extends State<IdleProductListScreen> {
  final Box<IdleProduct> productBox = Hive.box<IdleProduct>('idle_products');

  void _deleteProduct(int index) {
    productBox.deleteAt(index);
    setState(() {}); // Yeniden çiz
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Ürün silindi")),
    );
  }

  void _editProduct(int index, IdleProduct product) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => IdleProductAddScreen(existingProduct: product, index: index),
      ),
    ).then((_) => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    final products = productBox.values.toList();

    return Scaffold(
      appBar: AppBar(title: const Text("Kayıtlı Atıl Ürünler")),
      body: ListView.builder(
        itemCount: products.length,
        itemBuilder: (context, index) {
          final p = products[index];
          return ListTile(
            title: Text("${p.code} - ${p.name}"),
            subtitle: Text("SKT: ${DateFormat('dd.MM.yyyy').format(p.expirationDate)}"),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(icon: const Icon(Icons.edit), onPressed: () => _editProduct(index, p)),
                IconButton(icon: const Icon(Icons.delete), onPressed: () => _deleteProduct(index)),
              ],
            ),
          );
        },
      ),
    );
  }
}
