class PurchaseReport {
  late String customerName, purchasePrice, purchaseQuantity;

  PurchaseReport(this.customerName, this.purchasePrice, this.purchaseQuantity);

  PurchaseReport.fromJson(Map<dynamic, dynamic> json)
      : customerName = json['customerName'] as String,
        purchasePrice = json['purchasePrice'] as String,
        purchaseQuantity = json['purchaseQuantity'] as String;

  Map<dynamic, dynamic> toJson() => <dynamic, dynamic>{
        'customerName': customerName,
        'purchasePrice': purchasePrice,
        'purchaseQuantity': purchaseQuantity,
      };
}
