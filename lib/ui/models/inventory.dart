class Inventory {
  final String sku;
  final String productName;
  final num quantity;

  const Inventory({
    required this.sku,
    required this.productName,
    required this.quantity,
  });

  factory Inventory.fromJson(Map<String, dynamic> json) {
    return Inventory(
      sku: json['sku'] as String,
      productName: json['product_name'] as String,
      quantity: json['quantity'] as num,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'sku': sku,
      'productName': productName,
      'quantity': quantity,
    };
  }

  Inventory copyWith({
    String? sku,
    String? productName,
    num? quantity,
  }) {
    return Inventory(
      sku: sku ?? this.sku,
      productName: productName ?? this.productName,
      quantity: quantity ?? this.quantity,
    );
  }

  @override
  String toString() {
    return 'Inventory(sku: $sku, productName: $productName, quantity: $quantity)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Inventory &&
        other.sku == sku &&
        other.productName == productName &&
        other.quantity == quantity;
  }

  @override
  int get hashCode => sku.hashCode ^ productName.hashCode ^ quantity.hashCode;

  static List<Inventory> sampleInventoryData() {
    // Generate 20 random Inventory items for demo purposes
    final random = DateTime.now().millisecondsSinceEpoch;
    final items = <Inventory>[];
    final productNames = [
      'Beef Brisket',
      'Chicken Breast',
      'Pork Tenderloin',
      'Ground Beef',
      'Salmon Fillet',
      'Lamb Chops',
      'Turkey Thigh',
      'Bacon Strips',
      'Sausage Links',
      'Ribeye Steak',
      'Chicken Wings',
      'Pork Ribs',
      'Tuna Steak',
      'Veal Cutlet',
      'Duck Breast',
      'Ham Slices',
      'Beef Liver',
      'Chicken Liver',
      'Pork Belly',
      'Mutton Curry Cut',
    ];

    for (int i = 1; i <= 20; i++) {
      final sku = 'P${i.toString().padLeft(3, '0')}';
      final productName = productNames[(i - 1) % productNames.length];
      final quantity = (random + i * 11) % 100 + 1; // Random between 1-100

      items.add(Inventory(
        sku: sku,
        productName: productName,
        quantity: quantity,
      ));
    }

    return items;
  }
}
