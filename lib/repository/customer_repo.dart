import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:mobile_pos/Screens/Parties_Customers/Model/customer_model.dart';

import '../constant.dart';

class CustomerRepo {
  Future<List<CustomerModel>> getAllCustomers() async {
    List<CustomerModel> customerList = [];
    final ref = FirebaseDatabase.instance.ref(constUserId).child('Customers');

    await ref.orderByKey().get().then((value) {
      for (var element in value.children) {
        customerList.add(CustomerModel.fromJson(jsonDecode(jsonEncode(element.value))));
      }
    });
    ref.keepSynced(true);
    return customerList;
  }
}
