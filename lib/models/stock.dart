class Stock {
  num price;
  final String symbol;
  final DateTime time;
  final num? quantity;
  final num? totalValue;
  num? percentChange;

  Stock({
    required this.price,
    required this.symbol,
    required this.time,
    this.quantity,
    this.totalValue,
    this.percentChange,
  });

  factory Stock.fromJson(Map<String, dynamic> json) {
    return Stock(
      price: (json['price'] ?? 0.0),
      symbol: json['symbol'] ?? '',
      time: json['timestamp'] ?? 0.0,
    );
  }

  factory Stock.fromJson2(Map<String, dynamic> json) {
    final time =
        DateTime.fromMicrosecondsSinceEpoch(json['data'][0]['t'] * 1000);
    return Stock(
      price: json['data'][0]['p'],
      symbol: json['data'][0]['s'],
      time: time,
    );
  }

  factory Stock.fakeStock() {
    return Stock(
      price: 0,
      symbol: 'AAPL',
      time: DateTime.now(),
      quantity: 0,
      totalValue: 0,
      percentChange: 0,
    );
  }

  @override
  String toString() =>
      'StockModel(symbol: $symbol, price: $price, qty: $quantity, total value: $totalValue)';
}
