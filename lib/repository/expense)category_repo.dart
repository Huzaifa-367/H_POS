// ignore_for_file: file_names

import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';

import '../constant.dart';
import '../model/expense_category_model.dart';

class ExpenseCategoryRepo {
  final CurrentUserData currentUserData = CurrentUserData();
  Future<List<ExpenseCategoryModel>> getAllExpenseCategory() async {
    final ref = FirebaseDatabase.instance.ref(constUserId).child('Expense Category');
    ref.keepSynced(true);
    List<ExpenseCategoryModel> allExpenseCategoryList = [];

    ref.orderByKey().get().then((value) {
      for (var element in value.children) {
        var data = ExpenseCategoryModel.fromJson(jsonDecode(jsonEncode(element.value)));
        allExpenseCategoryList.add(data);
      }
    });
    return allExpenseCategoryList;
  }
}
//
// class IncomeCategoryRepo {
//   Future<List<IncomeCategoryModel>> getAllIncomeCategory() async {
//     List<IncomeCategoryModel> allIncomeCategoryList = [];
//
//     await FirebaseDatabase.instance.ref(constUserId).child('Income Category').orderByKey().get().then((value) {
//       for (var element in value.children) {
//         var data = IncomeCategoryModel.fromJson(jsonDecode(jsonEncode(element.value)));
//         allIncomeCategoryList.add(data);
//       }
//     });
//     return allIncomeCategoryList;
//   }
// }
