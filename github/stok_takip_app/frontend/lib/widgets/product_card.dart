import 'package:flutter/material.dart';

class ProductCard extends StatelessWidget {
  final String name;
  final String category;
  final int quantity;
  final double price;

  const ProductCard({
    super.key,
    required this.name,
    required this.category,
    required this.quantity,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Product Icon
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: Color.fromARGB(26, 232, 180, 203),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.inventory_2_outlined,
              color: Color(0xFFE8B4CB),
              size: 24,
            ),
          ),
          
          const SizedBox(width: 16),
          
          // Product Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF495057),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  category,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF6C757D),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: quantity < 10 
                            ? Color.fromARGB(26, 255, 183, 77)
                            : Color.fromARGB(26, 129, 199, 132),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        'Stok: $quantity',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: quantity < 10 
                              ? const Color(0xFFFFB74D)
                              : const Color(0xFF81C784),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '₺${price.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFFE8B4CB),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          // Action Button
          IconButton(
            onPressed: () {
              // TODO: Navigate to product details
            },
            icon: const Icon(
              Icons.arrow_forward_ios,
              color: Color(0xFF6C757D),
              size: 16,
            ),
          ),
        ],
      ),
    );
  }
} 