import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product.dart';

class ApiService {
  static const String BASE_URL = 'http://10.0.2.2:8000';
  static const int userId = 1;

  static Future<List<Product>> fetchProducts() async {
    final response = await http.get(Uri.parse('$BASE_URL/users/$userId/products/'));
    if (response.statusCode == 200) {
      List data = json.decode(response.body);
      return data.map((e) => Product.fromJson(e)).toList();
    } else {
      throw Exception('Ürünler alınamadı');
    }
  }

  static Future<Product> addProduct(Product product) async {
    final response = await http.post(
      Uri.parse('$BASE_URL/users/$userId/products/'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(product.toJson()),
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      return Product.fromJson(json.decode(response.body));
    } else {
      throw Exception('Ürün eklenemedi');
    }
  }

  static Future<void> deleteProduct(int productId) async {
    final response = await http.delete(Uri.parse('$BASE_URL/products/$productId'));
    if (response.statusCode != 200) {
      throw Exception('Ürün silinemedi');
    }
  }

  static Future<void> sendFcmToken(String fcmToken) async {
    final response = await http.post(
      Uri.parse('$BASE_URL/users/$userId/fcm_token'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'fcm_token': fcmToken}),
    );
    if (response.statusCode != 200 && response.statusCode != 201) {
      // Sessizce geç, hata fırlatma
    }
  }
} 