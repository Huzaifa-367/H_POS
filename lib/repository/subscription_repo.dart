import 'dart:convert';
import 'package:firebase_database/firebase_database.dart';
import 'package:mobile_pos/model/subscription_model.dart';
import 'package:http/http.dart' as http;
import '../constant.dart';

class SubscriptionRepo {
  static Future<SubscriptionModel> getSubscriptionData() async {
    DatabaseReference ref = FirebaseDatabase.instance.ref('$constUserId/Subscription');
    final model = await ref.get();
    var data = jsonDecode(jsonEncode(model.value));
    // Subscription.selectedItem = SubscriptionModel.fromJson(data).subscriptionName;
    return SubscriptionModel.fromJson(data);
  }
}

class PurchaseModel {
  Future<bool> isActiveBuyer() async {
    final response =
        await http.get(Uri.parse('https://api.envato.com/v3/market/author/sale?code=$purchaseCode'), headers: {'Authorization': 'Bearer orZoxiU81Ok7kxsE0FvfraaO0vDW5tiz'});
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }
}
