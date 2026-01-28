class DashboardResponse {
  final String date;
  final bool isToday;
  final List<ProductCount> products;

  const DashboardResponse({
    required this.date,
    required this.isToday,
    required this.products,
  });

  factory DashboardResponse.fromJson(Map<String, dynamic> json) {
    return DashboardResponse(
      date: json['date'] as String,
      isToday: json['is_today'] as bool,
      products: (json['products'] as List<dynamic>)
          .map((item) => ProductCount.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date,
      'is_today': isToday,
      'products': products.map((product) => product.toJson()).toList(),
    };
  }
}

class ProductCount {
  final String sku;
  final String productName;
  final int startOfDayCount;
  final int? currentCount;
  final int? endOfDayCount;
  final int scannedIn;
  final int scannedOut;

  const ProductCount({
    required this.sku,
    required this.productName,
    required this.startOfDayCount,
    this.currentCount,
    this.endOfDayCount,
    this.scannedIn = 0,
    this.scannedOut = 0,
  });

  factory ProductCount.fromJson(Map<String, dynamic> json) {
    return ProductCount(
      sku: json['sku'] as String,
      productName: json['product_name'] as String,
      startOfDayCount: json['start_of_day_count'] as int,
      currentCount: json['current_count'] as int?,
      endOfDayCount: json['end_of_day_count'] as int?,
      scannedIn: json['scanned_in'] as int? ?? 0,
      scannedOut: json['scanned_out'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'sku': sku,
      'product_name': productName,
      'start_of_day_count': startOfDayCount,
      'current_count': currentCount,
      'end_of_day_count': endOfDayCount,
      'scanned_in': scannedIn,
      'scanned_out': scannedOut,
    };
  }

  ProductCount copyWith({
    String? sku,
    String? productName,
    int? startOfDayCount,
    int? currentCount,
    int? endOfDayCount,
    int? scannedIn,
    int? scannedOut,
  }) {
    return ProductCount(
      sku: sku ?? this.sku,
      productName: productName ?? this.productName,
      startOfDayCount: startOfDayCount ?? this.startOfDayCount,
      currentCount: currentCount ?? this.currentCount,
      endOfDayCount: endOfDayCount ?? this.endOfDayCount,
      scannedIn: scannedIn ?? this.scannedIn,
      scannedOut: scannedOut ?? this.scannedOut,
    );
  }

  @override
  String toString() {
    return 'ProductCount(sku: $sku, productName: $productName, startOfDayCount: $startOfDayCount, currentCount: $currentCount, endOfDayCount: $endOfDayCount, scannedIn: $scannedIn, scannedOut: $scannedOut)';
  }
}

// Legacy SkuCount class for backward compatibility
class SkuCount {
  final String sku;
  final int startingCount;
  final int endCount;
  final int? currentCount;
  final int scannedIn;
  final int scannedOut;

  const SkuCount({
    required this.sku,
    required this.startingCount,
    required this.endCount,
    this.currentCount,
    this.scannedIn = 0,
    this.scannedOut = 0,
  });

  factory SkuCount.fromJson(Map<String, dynamic> json) {
    return SkuCount(
      sku: json['sku'] as String,
      startingCount: json['startingCount'] as int,
      endCount: json['endCount'] as int,
      currentCount: json['currentCount'] as int?,
      scannedIn: json['scanned_in'] as int? ?? 0,
      scannedOut: json['scanned_out'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'sku': sku,
      'startingCount': startingCount,
      'endCount': endCount,
      'currentCount': currentCount,
      'scanned_in': scannedIn,
      'scanned_out': scannedOut,
    };
  }

  SkuCount copyWith({
    String? sku,
    int? startingCount,
    int? endCount,
    int? currentCount,
    int? scannedIn,
    int? scannedOut,
  }) {
    return SkuCount(
      sku: sku ?? this.sku,
      startingCount: startingCount ?? this.startingCount,
      endCount: endCount ?? this.endCount,
      currentCount: currentCount ?? this.currentCount,
      scannedIn: scannedIn ?? this.scannedIn,
      scannedOut: scannedOut ?? this.scannedOut,
    );
  }

  @override
  String toString() {
    return 'Dashboard(sku: $sku, startingCount: $startingCount, endCount: $endCount, currentCount: $currentCount, scannedIn: $scannedIn, scannedOut: $scannedOut)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is SkuCount &&
        other.sku == sku &&
        other.startingCount == startingCount &&
        other.endCount == endCount &&
        other.currentCount == currentCount &&
        other.scannedIn == scannedIn &&
        other.scannedOut == scannedOut;
  }

  @override
  int get hashCode =>
      sku.hashCode ^
      startingCount.hashCode ^
      endCount.hashCode ^
      currentCount.hashCode ^
      scannedIn.hashCode ^
      scannedOut.hashCode;

  static List<SkuCount> sampleSkuCountData() {
    // Generate 20 random SkuCount items for demo purposes
    final random = DateTime.now().millisecondsSinceEpoch;
    final items = <SkuCount>[];

    for (int i = 1; i <= 20; i++) {
      final sku = 'P${i.toString().padLeft(3, '0')}';
      final startingCount = (random + i * 7) % 50 + 10;
      final endCount = startingCount + ((random + i * 13) % 30);
      final currentCount = (random + i * 17) % 2 == 0
          ? null
          : (startingCount +
              ((random + i * 23) % (endCount - startingCount + 1)));
      final scannedIn = (random + i * 29) % 15;
      final scannedOut = (random + i * 31) % 10;

      items.add(SkuCount(
        sku: sku,
        startingCount: startingCount,
        endCount: endCount,
        currentCount: currentCount,
        scannedIn: scannedIn,
        scannedOut: scannedOut,
      ));
    }

    return items;
  }
}
