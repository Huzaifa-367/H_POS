class UserRoleModel {
  late String email, userTitle, databaseId;
  late bool salePermission,
      partiesPermission,
      purchasePermission,
      productPermission,
      profileEditPermission,
      addExpensePermission,
      lossProfitPermission,
      dueListPermission,
      stockPermission,
      reportsPermission,
      salesListPermission,
      purchaseListPermission;

  String? userKey;

  UserRoleModel({
    required this.email,
    required this.userTitle,
    required this.databaseId,
    required this.salePermission,
    required this.partiesPermission,
    required this.purchasePermission,
    required this.productPermission,
    required this.profileEditPermission,
    required this.addExpensePermission,
    required this.lossProfitPermission,
    required this.dueListPermission,
    required this.stockPermission,
    required this.reportsPermission,
    required this.salesListPermission,
    required this.purchaseListPermission,
    this.userKey,
  });

  UserRoleModel.fromJson(Map<dynamic, dynamic> json)
      : email = json['email'],
        userTitle = json['userTitle'],
        databaseId = json['databaseId'],
        salePermission = json['salePermission'],
        partiesPermission = json['partiesPermission'],
        purchasePermission = json['purchasePermission'],
        productPermission = json['productPermission'],
        profileEditPermission = json['profileEditPermission'],
        addExpensePermission = json['addExpensePermission'],
        lossProfitPermission = json['lossProfitPermission'],
        dueListPermission = json['dueListPermission'],
        stockPermission = json['stockPermission'],
        reportsPermission = json['reportsPermission'],
        salesListPermission = json['salesListPermission'],
        purchaseListPermission = json['purchaseListPermission'];

  Map<dynamic, dynamic> toJson() => <String, dynamic>{
        'email': email,
        'userTitle': userTitle,
        'databaseId': databaseId,
        'salePermission': salePermission,
        'partiesPermission': partiesPermission,
        'purchasePermission': purchasePermission,
        'productPermission': productPermission,
        'profileEditPermission': profileEditPermission,
        'addExpensePermission': addExpensePermission,
        'lossProfitPermission': lossProfitPermission,
        'dueListPermission': dueListPermission,
        'stockPermission': stockPermission,
        'reportsPermission': reportsPermission,
        'salesListPermission': salesListPermission,
        'purchaseListPermission': purchaseListPermission,
      };
}
