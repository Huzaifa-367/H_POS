import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:mobile_pos/Screens/Delivery/Model/delivery_model.dart';

import '../constant.dart';

class DeliveryRepo {
  Future<List<DeliveryModel>> getAllDelivery() async {
    List<DeliveryModel> deliveryList = [];

    await FirebaseDatabase.instance.ref(constUserId).child('Delivery Addresses').orderByKey().get().then((value) {
      for (var element in value.children) {
        deliveryList.add(DeliveryModel.fromJson(jsonDecode(jsonEncode(element.value))));
      }
    });
    return deliveryList;
  }
}
