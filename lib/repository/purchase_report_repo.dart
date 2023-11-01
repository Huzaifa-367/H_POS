import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';

import '../Screens/Purchase/Model/purchase_report.dart';
import '../constant.dart';

class PurchaseReportRepo {
  Future<List<PurchaseReport>> getAllPurchaseReport() async {
    List<PurchaseReport> reportList = [];
    await FirebaseDatabase.instance.ref(constUserId).child('Purchase Report').orderByKey().get().then((value) {
      for (var element in value.children) {
        reportList.add(PurchaseReport.fromJson(jsonDecode(jsonEncode(element.value))));
      }
    });
    return reportList;
  }
}
