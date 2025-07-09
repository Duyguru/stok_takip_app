class TrackedSize {
  final int? id;
  final String size;
  final bool inStock;

  TrackedSize({this.id, required this.size, this.inStock = false});

  factory TrackedSize.fromJson(Map<String, dynamic> json) {
    return TrackedSize(
      id: json['id'],
      size: json['size'],
      inStock: json['in_stock'] ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'size': size,
        'in_stock': inStock,
      };
}

class Product {
  final int? id;
  final String url;
  final List<TrackedSize> trackedSizes;

  Product({this.id, required this.url, required this.trackedSizes});

  factory Product.fromJson(Map<String, dynamic> json) {
    var sizesJson = json['tracked_sizes'] as List?;
    List<TrackedSize> sizes = sizesJson != null
        ? sizesJson.map((e) => TrackedSize.fromJson(e)).toList()
        : [];
    return Product(
      id: json['id'],
      url: json['url'],
      trackedSizes: sizes,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'url': url,
        'tracked_sizes': trackedSizes.map((e) => e.toJson()).toList(),
      };
} 