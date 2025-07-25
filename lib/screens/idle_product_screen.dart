import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:storage_sisecam/models/idle_product.dart';
import 'package:storage_sisecam/services/auth_service.dart';
import 'package:intl/intl.dart';
import 'package:storage_sisecam/screens/idle_product_list_screen.dart';

class IdleProductAddScreen extends StatefulWidget {
  final IdleProduct? existingProduct;
  final int? index;

  const IdleProductAddScreen({super.key, this.existingProduct, this.index});

  @override
  State<IdleProductAddScreen> createState() => _IdleProductAddScreenState();
}


class _IdleProductAddScreenState extends State<IdleProductAddScreen> {
  final TextEditingController codeController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController stockController = TextEditingController();
  final List<String> factoryList = ["Fabrika A", "Fabrika B", "Fabrika C", "Genel"];

  String? selectedFactory;
  String? userRole;
  bool isAuthorized = false;
  DateTime? expirationDate;
  Uint8List? selectedImage;
  Uint8List? selectedPDF;

  @override
void initState() {
  super.initState();
  final role = AuthService.sessionBox.get('role');
  userRole = role;
  isAuthorized = (role == 'firin_sefi' || role == 'fabrika_muduru');

  // Eğer düzenleme için ürün varsa inputlara aktar
  if (widget.existingProduct != null) {
    final product = widget.existingProduct!;
    codeController.text = product.code;
    nameController.text = product.name ;
    descriptionController.text = product.description;
    selectedFactory = product.factory;
    expirationDate = product.expirationDate;
    selectedImage = product.imageBytes;
    selectedPDF = product.pdfBytes;
    stockController.text = product.stockQuantity.toString();
  }
  

  setState(() {});
}

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      final bytes = await image.readAsBytes();
      setState(() => selectedImage = bytes);
    }
  }

  Future<void> pickPDF() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions: ['pdf']);
    if (result != null && result.files.single.bytes != null) {
      setState(() => selectedPDF = result.files.single.bytes);
    }
  }

  void saveProduct() async {
  if (!isAuthorized) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Bu işlemi yapmaya yetkiniz yok.")),
    );
    return;
  }

  if (codeController.text.isEmpty || selectedFactory == null || expirationDate == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Lütfen zorunlu alanları doldurun.")),
    );
    return;
  }

  final product = IdleProduct(
  code: codeController.text,
  name: nameController.text,
  description: descriptionController.text,
  factory: selectedFactory!,
  addedDate: DateTime.now(),
  expirationDate: expirationDate!,
  imageBytes: selectedImage,
  pdfBytes: selectedPDF,
  stockQuantity: int.tryParse(stockController.text) ?? 0, // 👈 stok
);


  final box = Hive.box<IdleProduct>('idle_products');

  if (widget.index != null) {
    await box.putAt(widget.index!, product);
  } else {
    await box.add(product);
  }

  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(content: Text("Ürün başarıyla kaydedildi.")),
  );

  Navigator.pop(context);
}


  @override
  Widget build(BuildContext context) {
    if (userRole == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    return Scaffold(
      appBar: AppBar(title: const Text("Atıl Ürün Ekle")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(labelText: "Fabrika Seçiniz"),
              value: selectedFactory,
              items: factoryList.map((f) => DropdownMenuItem(value: f, child: Text(f))).toList(),
              onChanged: isAuthorized ? (value) => setState(() => selectedFactory = value) : null,
            ),
            TextField(
              controller: codeController,
              enabled: isAuthorized,
              decoration: const InputDecoration(labelText: "Ürün Kodu*"),
            ),
            TextField(
              controller: nameController,
              enabled: isAuthorized,
              decoration: const InputDecoration(labelText: "Ürün Adı"),
            ),
            TextField(
              controller: descriptionController,
              enabled: isAuthorized,
              decoration: const InputDecoration(labelText: "Açıklama"),
            ),
            TextField(
  controller: stockController,
  enabled: isAuthorized,
  keyboardType: TextInputType.number,
  decoration: const InputDecoration(labelText: "Stok Miktarı"),
),

            const SizedBox(height: 12),
            ListTile(
              title: Text(
                expirationDate != null
                    ? "Son Kullanma Tarihi: ${DateFormat('dd.MM.yyyy').format(expirationDate!)}"
                    : "Son Kullanma Tarihi Seçin",
              ),
              trailing: const Icon(Icons.calendar_today),
              onTap: isAuthorized
                  ? () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2100),
                      );
                      if (picked != null) {
                        setState(() => expirationDate = picked);
                      }
                    }
                  : null,
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton.icon(
                  onPressed: isAuthorized ? pickImage : null,
                  icon: const Icon(Icons.image),
                  label: const Text("Fotoğraf Yükle"),
                ),
                ElevatedButton.icon(
                  onPressed: isAuthorized ? pickPDF : null,
                  icon: const Icon(Icons.picture_as_pdf),
                  label: const Text("PDF Yükle"),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Tooltip(
              message: isAuthorized ? '' : 'Bu işlemi yapmaya yetkiniz yok.',
              child: ElevatedButton(
                onPressed: isAuthorized ? saveProduct : null,
                child: const Text("Kaydet"),
              ),
              
            ),
            const SizedBox(height: 30), // Butonlar arası boşluk
            ElevatedButton.icon(
              onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const IdleProductListScreen()),
        );
      },
      icon: const Icon(Icons.list),
      label: const Text("Eklenen Ürünleri Görüntüle"),
    ),
          ],

        ),
      ),
    );
  }
}
