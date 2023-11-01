class CurrencyModel {
  CurrencyModel({
    required this.name,
    required this.symbol,
  });

  String name, symbol;

  CurrencyModel.fromJson(Map<dynamic, dynamic> json)
      : name = json['name'],
        symbol = json['symbol'];

  Map<dynamic, dynamic> toJson() => <dynamic, dynamic>{
        'name': name,
        'symbol': symbol,
      };
}
