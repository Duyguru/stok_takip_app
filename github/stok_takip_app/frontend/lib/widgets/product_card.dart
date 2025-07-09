import 'package:flutter/material.dart';
import '../models/product.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final void Function()? onDelete;
  const ProductCard({Key? key, required this.product, this.onDelete}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              product.url,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Takip Edilen Bedenler:'),
                IconButton(
                  icon: Icon(Icons.delete, color: Colors.red),
                  onPressed: onDelete,
                  tooltip: 'Sil',
                ),
              ],
            ),
            ...product.trackedSizes.map((size) => Row(
                  children: [
                    Text(size.size),
                    SizedBox(width: 8),
                    Icon(
                      size.inStock ? Icons.check_circle : Icons.cancel,
                      color: size.inStock ? Colors.green : Colors.red,
                      size: 18,
                    ),
                    SizedBox(width: 4),
                    Text(size.inStock ? 'Stokta' : 'Yok'),
                  ],
                )),
          ],
        ),
      ),
    );
  }
} 