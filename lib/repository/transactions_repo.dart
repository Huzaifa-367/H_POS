import 'dart:convert';
import 'package:firebase_database/firebase_database.dart';
import 'package:mobile_pos/constant.dart';
import 'package:mobile_pos/model/transition_model.dart';

import '../model/due_transaction_model.dart';

class TransitionRepo {
  Future<List<TransitionModel>> getAllTransition() async {
    final ref = FirebaseDatabase.instance.ref(constUserId).child('Sales Transition');

    List<TransitionModel> transitionList = [];
    await ref.orderByKey().get().then((value) {
      for (var element in value.children) {
        transitionList.add(TransitionModel.fromJson(jsonDecode(jsonEncode(element.value))));
      }
    });
    ref.keepSynced(true);
    return transitionList;
  }
}

class PurchaseTransitionRepo {
  Future<List<dynamic>> getAllTransition() async {
    final ref = FirebaseDatabase.instance.ref(constUserId).child('Purchase Transition');

    List<dynamic> transitionList = [];
    await ref.orderByKey().get().then((value) {
      for (var element in value.children) {
        transitionList.add(PurchaseTransitionModel.fromJson(jsonDecode(jsonEncode(element.value))));
      }
    });
    ref.keepSynced(true);
    return transitionList;
  }
}

class DueTransitionRepo {
  Future<List<DueTransactionModel>> getAllTransition() async {
    final ref = FirebaseDatabase.instance.ref(constUserId).child('Due Transaction');

    List<DueTransactionModel> transitionList = [];
    await ref.orderByKey().get().then((value) {
      for (var element in value.children) {
        transitionList.add(DueTransactionModel.fromJson(jsonDecode(jsonEncode(element.value))));
      }
    });
    ref.keepSynced(true);
    return transitionList;
  }
}
