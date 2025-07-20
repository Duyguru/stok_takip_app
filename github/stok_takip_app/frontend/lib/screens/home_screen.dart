import 'package:flutter/material.dart';
import '../widgets/product_card.dart';
import '../widgets/stats_card.dart';
import '../models/product.dart';
import '../services/api_service.dart';
import 'add_product_screen.dart';
import 'notification_settings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<Product>> _productsFuture;

  @override
  void initState() {
    super.initState();
    _productsFuture = ApiService.fetchProducts();
  }

  Future<void> _refresh() async {
    setState(() {
      _productsFuture = ApiService.fetchProducts();
    });
  }

  void goToAddProduct() async {
    final result = await Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const AddProductScreen()),
    );
    if (result == true) {
      _refresh();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Stok Takip'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Logo kaldırıldı
          // const SizedBox(height: 24),
          // Center(
          //   child: Image.asset(
          //     'assets/images/app_logo.png',
          //     width: 160,
          //     height: 160,
          //   ),
          // ),
          // const SizedBox(height: 24),
          // Welcome Section
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFE8B4CB), Color(0xFFF4C2C2)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Hoş Geldiniz! 👋',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Stok takibinizi kolayca yönetin',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Quick Stats
          const Text(
            'Genel Bakış',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Color(0xFF495057),
            ),
          ),
          const SizedBox(height: 16),
          
          Row(
            children: [
              Expanded(
                child: FutureBuilder<List<Product>>(
                  future: _productsFuture,
                  builder: (context, snapshot) {
                    final int productCount = snapshot.hasData ? snapshot.data!.length : 0;
                    return StatsCard(
                      title: 'Toplam Ürün',
                      value: productCount.toString(),
                      icon: Icons.inventory_2_outlined,
                      color: const Color(0xFFE8B4CB),
                    );
                  },
                ),
              ),
              // Düşük Stok kartı kaldırıldı
            ],
          ),
          
          const SizedBox(height: 24),
          
          // Quick Actions
          const Text(
            'Hızlı İşlemler',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Color(0xFF495057),
            ),
          ),
          const SizedBox(height: 16),
          
          Row(
            children: [
              Expanded(
                child: _buildQuickActionCard(
                  title: 'Ürün Ekle',
                  icon: Icons.add_circle_outline,
                  color: const Color(0xFFE8B4CB),
                  onTap: goToAddProduct,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildQuickActionCard(
                  title: 'Bildirim Ayarları',
                  icon: Icons.notifications_active_outlined,
                  color: const Color(0xFF81C784),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const NotificationSettingsScreen(),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 24),
          
          // Recent Products
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Son Ürünler',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF495057),
                ),
              ),
              TextButton(
                onPressed: () {
                  // TODO: Navigate to all products
                },
                child: const Text(
                  'Tümünü Gör',
                  style: TextStyle(
                    color: Color(0xFFE8B4CB),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Sample Products
          Expanded(
            child: FutureBuilder<List<Product>>(
              future: _productsFuture,
              builder: (context, snapshot) {
                final int productCount = snapshot.hasData ? snapshot.data!.length : 0;
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Hata: \\${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('Henüz ürün eklemediniz.'));
                }
                final products = snapshot.data!;
                return RefreshIndicator(
                  onRefresh: _refresh,
                  child: ListView.builder(
                    itemCount: products.length,
                    itemBuilder: (context, index) => ProductCard(
                      product: products[index],
                      onDelete: () async {
                        await ApiService.deleteProduct(products[index].id!);
                        _refresh();
                      },
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: goToAddProduct,
        backgroundColor: const Color(0xFFE8B4CB),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildQuickActionCard({
    required String title,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Color.fromARGB(26, 232, 180, 203),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: 32,
              color: color,
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Color(0xFF495057),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
} 