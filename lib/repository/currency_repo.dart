import 'dart:convert';
import 'package:firebase_database/firebase_database.dart';

import '../model/currency_model.dart';

class CurrencyRepo {
  Future<List<CurrencyModel>> getAllCurrency() async {
    List<CurrencyModel> currencyList = [];
    await FirebaseDatabase.instance.ref().child('Admin Panel').child('Currency').orderByKey().get().then((value) {
      for (var element in value.children) {
        currencyList.add(CurrencyModel.fromJson(jsonDecode(jsonEncode(element.value))));
      }
    });
    return currencyList;
  }
}
