import 'package:flutter/material.dart';
import 'package:storage_sisecam/screens/warehouse_screen.dart';
import 'package:storage_sisecam/screens/project_system_screen.dart';
import 'package:storage_sisecam/screens/idle_product_screen.dart';
import 'package:storage_sisecam/screens/idle_products_request_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  void _navigateTo(BuildContext context, String screen) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$screen sayfasına yönlendiriliyorsunuz…')),
    );
  }

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
        title: const Text("Üretim Yönetim Paneli"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 20,
          mainAxisSpacing: 20,
          children: [
            _buildHomeCard(
              context,
              title: "Hammadde/Ürün",
              icon: Icons.local_shipping_rounded,
              onTap: () => _navigateTo(context, "Talep Aç"),
            ),
            _buildHomeCard(
              context,
              title: "Depo Bilgileri",
              icon: Icons.warehouse, // desteklenmezse Icons.store kullanın
              onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const WarehouseScreen()),
              ),
            ),
            _buildHomeCard(
              context,
              title: "Optima",
              icon: Icons.broadcast_on_personal_outlined, // desteklenmezse Icons.store kullanın
              onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const WarehouseScreen()),
              ),
            ),_buildHomeCard(
              context,
              title: "Rapor Sistemi",
              icon: Icons.folder_copy, // desteklenmezse Icons.store kullanın
              onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => ProjectSystemScreen(factoryOptions: ['Fabrika A', 'Fabrika B']),),
              ),
            ),_buildHomeCard(
              context,
              title: "Üretim Bütçesi",
              icon: Icons.account_balance_wallet_rounded, // desteklenmezse Icons.store kullanın
              onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const WarehouseScreen()),
              ),
            ),
            _buildHomeCard(
              context,
              title: "Proje Sistemi",
              icon: Icons.addchart_outlined, // desteklenmezse Icons.store kullanın
              onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => ProjectSystemScreen(factoryOptions:factories),),
              ),
            ), _buildHomeCard(
              context,
              title: "Atıl Ürün Sistemi",
              icon: Icons.add_business_rounded, // desteklenmezse Icons.store kullanın
              onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => IdleProductAddScreen(),),
              ),
            ),
            _buildHomeCard(
              context,
              title: "Atıl Ürün Talep",
              icon: Icons.add_shopping_cart_rounded, // desteklenmezse Icons.store kullanın
              onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => IdleProductRequestScreen(),),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHomeCard(BuildContext context, {
    required String title,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Colors.grey[200],
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade400,
              blurRadius: 6,
              offset: const Offset(2, 4),
            )
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 48, color: Colors.blueGrey),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
