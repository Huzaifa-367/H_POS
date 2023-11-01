import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'model/subscription_model.dart';
import 'model/subscription_plan_model.dart';
import 'package:flutter/material.dart';

class Subscription {
  static List<SubscriptionPlanModel> subscriptionPlan = [];
  static SubscriptionPlanModel customersActivePlan = SubscriptionPlanModel(
    subscriptionName: 'Free',
    saleNumber: 0,
    purchaseNumber: 0,
    products: 0,
    partiesNumber: 0,
    duration: 0,
    dueNumber: 0,
    offerPrice: 0,
    subscriptionPrice: 0,
  );
  static const String currency = 'USD';
  static SubscriptionModel freeSubscriptionModel = SubscriptionModel(
    saleNumber: 0,
    purchaseNumber: 0,
    products: 0,
    partiesNumber: 0,
    duration: 0,
    dueNumber: 0,
    subscriptionDate: DateTime.now().add(const Duration(days: 5)).toString(),
    subscriptionName: 'Free',
  );

  static void decreaseSubscriptionLimits(
      {required String itemType, required BuildContext context}) {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    final ref = FirebaseDatabase.instance.ref(userId).child('Subscription');
    ref.keepSynced(true);
    ref.child(itemType).get().then((value) {
      int beforeAction = int.parse(value.value.toString());
      if (beforeAction != -202) {
        int afterAction = beforeAction - 1;
        ref.update({itemType: afterAction});
      }
    });
  }
}
