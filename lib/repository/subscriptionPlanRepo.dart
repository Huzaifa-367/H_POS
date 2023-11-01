// ignore_for_file: file_names

import 'dart:convert';
import 'package:firebase_database/firebase_database.dart';
import 'package:mobile_pos/model/subscription_plan_model.dart';

class SubscriptionPlanRepo {
  Future<List<SubscriptionPlanModel>> getAllSubscriptionPlans() async {
    List<SubscriptionPlanModel> planList = [];
    await FirebaseDatabase.instance.ref().child('Admin Panel').child('Subscription Plan').orderByKey().get().then((value) {
      for (var element in value.children) {
        planList.add(SubscriptionPlanModel.fromJson(jsonDecode(jsonEncode(element.value))));
      }
    });
    return planList;
  }
}
