import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_pos/model/product_model.dart';

final cartNotifierPurchase = ChangeNotifierProvider((ref) => CartNotifier());

class CartNotifier extends ChangeNotifier {
  List<ProductModel> cartItemPurchaseList = [];
  double discount = 0;
  String discountType = 'USD';

  final List<ProductModel> productList = [];

  void addProductsInSales(ProductModel products) {
    productList.add(products);
    notifyListeners();
  }

  double getTotalAmount() {
    double totalAmountOfCart = 0;
    for (var element in cartItemPurchaseList) {
      totalAmountOfCart = totalAmountOfCart + (double.parse(element.productPurchasePrice.toString()) * double.parse(element.productStock.toString()));
    }
    return totalAmountOfCart;
  }

  addToCartRiverPod(ProductModel cartItem) {
    bool isNotInList = true;
    for (var element in cartItemPurchaseList) {
      if (element.productCode == cartItem.productCode) {
        element.productStock = (int.parse(element.productStock) + int.parse(cartItem.productStock)).toString();
        isNotInList = false;
        return;
      } else {
        isNotInList = true;
      }
    }
    if (isNotInList) {
      cartItemPurchaseList.add(cartItem);
    }
    notifyListeners();
  }

  addToCartRiverPodForEdit(List<ProductModel> cartItem) {
    cartItemPurchaseList = cartItem;
  }

  quantityDecrease(int index) {
    if (int.parse(cartItemPurchaseList[index].productStock) > 1) {
      int quantity = int.parse(cartItemPurchaseList[index].productStock);
      quantity--;
      cartItemPurchaseList[index].productStock = quantity.toString();
    }
    notifyListeners();
  }

  quantityIncrease(int index) {
    int quantity = int.parse(cartItemPurchaseList[index].productStock);
    quantity++;
    cartItemPurchaseList[index].productStock = quantity.toString();
    notifyListeners();
  }

  clearCart() {
    cartItemPurchaseList.clear();
    clearDiscount();
    notifyListeners();
  }

  deleteToCart(int index) {
    cartItemPurchaseList.removeAt(index);
    notifyListeners();
  }

  addDiscount(String type, double dis) {
    discount = dis;
    discountType = type;
    notifyListeners();
  }

  clearDiscount() {
    discount = 0;
    discountType = 'USD';
    notifyListeners();
  }
}
