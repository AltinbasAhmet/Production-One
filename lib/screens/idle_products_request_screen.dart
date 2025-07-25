import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:storage_sisecam/models/idle_product.dart';
import 'package:storage_sisecam/models/idle_product_request_log.dart';
import 'package:storage_sisecam/services/auth_service.dart';

class IdleProductRequestScreen extends StatefulWidget {
  const IdleProductRequestScreen({super.key});

  @override
  State<IdleProductRequestScreen> createState() => _IdleProductRequestScreenState();
}

class _IdleProductRequestScreenState extends State<IdleProductRequestScreen> {
  final Box<IdleProduct> productBox = Hive.box<IdleProduct>('idle_products');
  final Box<IdleProductRequestLog> logBox = Hive.box<IdleProductRequestLog>('idle_product_requests');
  String searchQuery = '';
  String? selectedFactory;
  String? userRole;
  String? username;
  bool isAuthorized = false;

  List<String> factories = ['Tümü', 'Fabrika A', 'Fabrika B', 'Fabrika C', 'Genel'];

  @override
  void initState() {
    super.initState();
    final session = AuthService.sessionBox;
    userRole = session.get('role');
    username = session.get('username');
    isAuthorized = (userRole == 'firin_sefi' || userRole == 'fabrika_muduru');
  }

  @override
  Widget build(BuildContext context) {
    final allProducts = productBox.values.toList();
    final filteredProducts = allProducts.where((product) {
      final matchesSearch = product.code.toLowerCase().contains(searchQuery.toLowerCase()) ||
          product.name.toLowerCase().contains(searchQuery.toLowerCase());
      final matchesFactory = selectedFactory == null || selectedFactory == 'Tümü' || product.factory == selectedFactory;
      return matchesSearch && matchesFactory;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Atıl Ürün Talep Ekranı'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: _showRequestHistoryDialog,
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            const DrawerHeader(child: Text('Fabrika Filtresi')),
            for (final factory in factories)
              ListTile(
                title: Text(factory),
                selected: selectedFactory == factory,
                onTap: () {
                  setState(() => selectedFactory = factory);
                  Navigator.pop(context);
                },
              ),
          ],
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              onChanged: (value) => setState(() => searchQuery = value),
              decoration: const InputDecoration(
                hintText: 'Ürün kodu veya ismine göre ara',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: filteredProducts.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.7,
              ),
              itemBuilder: (context, index) {
                final product = filteredProducts[index];
                return GestureDetector(
                  onTap: () => _showProductDetails(context, product),
                  child: Card(
                    elevation: 4,
                    child: Column(
                      children: [
                        if (product.imageBytes != null)
                          Image.memory(
                            product.imageBytes!,
                            height: 140,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Text(product.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                              Text("Kod: ${product.code}"),
                              Text("Stok: ${product.stockQuantity ?? 0}"),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showProductDetails(BuildContext context, IdleProduct product) {
    final quantityController = TextEditingController();
    String? selectedTargetFactory;

    showDialog(
      context: context,
      builder: (context) => Dialog(
        insetPadding: const EdgeInsets.all(16),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (product.imageBytes != null)
                      Image.memory(product.imageBytes!, height: 200, fit: BoxFit.cover),
                    const SizedBox(height: 10),
                    Text(product.name, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    Text("Kod: ${product.code}"),
                    Text("Açıklama: ${product.description}"),
                    Text("Fabrika: ${product.factory}"),
                    Text("Stok: ${product.stockQuantity ?? 0}"),
                    Text("SKT: ${DateFormat('dd.MM.yyyy').format(product.expirationDate)}"),
                    const SizedBox(height: 12),
                    if (isAuthorized) ...[
                      DropdownButtonFormField<String>(
                        value: selectedTargetFactory,
                        hint: const Text("Talep Eden Fabrika"),
                        items: factories.where((f) => f != 'Tümü').map((f) {
                          return DropdownMenuItem(value: f, child: Text(f));
                        }).toList(),
                        onChanged: (value) => selectedTargetFactory = value,
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: quantityController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: "Talep Edilen Miktar",
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton.icon(
                        icon: const Icon(Icons.shopping_cart),
                        label: const Text("Talep Et"),
                        onPressed: () {
                          final quantity = int.tryParse(quantityController.text) ?? 0;
                          if (selectedTargetFactory == null || quantity <= 0) {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text("Geçerli miktar ve fabrika seçin.")));
                            return;
                          }
                          Navigator.of(context).pop();
                          _requestProduct(product, quantity, selectedTargetFactory!);
                        },
                      ),
                    ]
                  ],
                ),
              ),
            ),
            Positioned(
              right: 5,
              top: 5,
              child: IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.of(context).pop(),
              ),
            )
          ],
        ),
      ),
    );
  }

  void _requestProduct(IdleProduct product, int quantity, String requestedFactory) async {
  final index = productBox.values.toList().indexOf(product);
  if ((product.stockQuantity ?? 0) < quantity) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Yeterli stok bulunmamaktadır.")),
    );
    return;
  }

  final updatedProduct = IdleProduct(
    code: product.code,
    name: product.name,
    description: product.description,
    factory: product.factory,
    addedDate: product.addedDate,
    expirationDate: product.expirationDate,
    imageBytes: product.imageBytes,
    pdfBytes: product.pdfBytes,
    stockQuantity: (product.stockQuantity ?? 0) - quantity,
  );

  await productBox.putAt(index, updatedProduct);

  // 🔧 Log kaydı için gerekli alanlar
  final newLog = IdleProductRequestLog(
    productCode: product.code,
    productName: product.name,
    quantity: quantity,
    requestedFactory: requestedFactory,
    requestedBy: AuthService.sessionBox.get('username') ?? "Bilinmiyor", // ← burada username geliyor
    requestDate: DateTime.now(),
  );

  await logBox.add(newLog);

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text("$quantity adet ürün talep edildi ($requestedFactory)")),
  );

  setState(() {});
}

  void _showRequestHistoryDialog() {
    final logs = logBox.values.toList().reversed.toList();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Talep Geçmişi"),
        content: SizedBox(
          width: double.maxFinite,
          child: logs.isEmpty
              ? const Text("Kayıt bulunamadı.")
              : ListView.builder(
                  shrinkWrap: true,
                  itemCount: logs.length,
                  itemBuilder: (context, index) {
                    final log = logs[index];
                    return ListTile(
                      leading: const Icon(Icons.assignment_turned_in_outlined),
                      title: Text("${log.productName} (${log.productCode})"),
                      subtitle: Text("Talep Eden: ${log.requestedBy}\nFabrika: ${log.requestedFactory} • Adet: ${log.quantity}"),
                      trailing: Text(DateFormat('dd.MM.yyyy HH:mm').format(log.requestDate)),
                    );
                  },
                ),
        ),
        actions: [
          TextButton(
            child: const Text("Kapat"),
            onPressed: () => Navigator.pop(context),
          )
        ],
      ),
    );
  }
}
