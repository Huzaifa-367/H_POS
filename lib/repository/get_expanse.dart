import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';

import '../constant.dart';
import '../model/expense_model.dart';

class ExpenseRepo {
  final CurrentUserData currentUserData = CurrentUserData();
  Future<List<ExpenseModel>> getAllExpense() async {
    final ref = FirebaseDatabase.instance.ref(constUserId).child('Expense');

    List<ExpenseModel> allExpense = [];

    await FirebaseDatabase.instance.ref(constUserId).child('Expense').orderByKey().get().then((value) {
      for (var element in value.children) {
        var data = ExpenseModel.fromJson(jsonDecode(jsonEncode(element.value)));
        allExpense.add(data);
      }
    });
    ref.keepSynced(true);
    return allExpense;
  }
}
