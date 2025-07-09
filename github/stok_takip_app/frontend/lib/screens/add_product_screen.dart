import 'package:flutter/material.dart';
import '../models/product.dart';
import '../services/api_service.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({Key? key}) : super(key: key);

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _formKey = GlobalKey<FormState>();
  final _urlController = TextEditingController();
  final List<TextEditingController> _sizeControllers = [TextEditingController()];
  bool _isLoading = false;

  void _addSizeField() {
    setState(() {
      _sizeControllers.add(TextEditingController());
    });
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    try {
      final product = Product(
        url: _urlController.text,
        trackedSizes: _sizeControllers
            .where((c) => c.text.trim().isNotEmpty)
            .map((c) => TrackedSize(size: c.text.trim()))
            .toList(),
      );
      await ApiService.addProduct(product);
      Navigator.of(context).pop(true);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ürün eklenemedi: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Ürün Ekle')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _urlController,
                decoration: InputDecoration(labelText: 'Ürün URL'),
                validator: (v) => v == null || v.isEmpty ? 'URL gerekli' : null,
              ),
              SizedBox(height: 16),
              Text('Takip Edilecek Bedenler'),
              ..._sizeControllers.asMap().entries.map((entry) {
                int idx = entry.key;
                return Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: entry.value,
                        decoration: InputDecoration(labelText: 'Beden'),
                        validator: (v) => v == null || v.isEmpty ? 'Beden gerekli' : null,
                      ),
                    ),
                    if (idx == _sizeControllers.length - 1)
                      IconButton(
                        icon: Icon(Icons.add),
                        onPressed: _addSizeField,
                      ),
                  ],
                );
              }),
              SizedBox(height: 24),
              _isLoading
                  ? Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                      onPressed: _submit,
                      child: Text('Ekle'),
                    ),
            ],
          ),
        ),
      ),
    );
  }
} 