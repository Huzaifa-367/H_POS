// ignore_for_file: file_names

import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:mobile_pos/GlobalComponents/Model/category_model.dart';

import '../Screens/Products/Model/brands_model.dart';
import '../Screens/Products/Model/unit_model.dart';
import '../constant.dart';

class CategoryRepo {
  Future<List<CategoryModel>> getAllCategory() async {
    List<CategoryModel> categoryList = [];
    print("Category List Fetching/: $categoryList");
    await FirebaseDatabase.instance
        .ref(constUserId)
        .child('Categories')
        .orderByKey()
        .get()
        .then((value) {
      for (var element in value.children) {
        categoryList
            .add(CategoryModel.fromJson(jsonDecode(jsonEncode(element.value))));
      }
    });
    final categoryRef =
        FirebaseDatabase.instance.ref(constUserId).child('Categories');
    categoryRef.keepSynced(true);
    print("Category List Fetched/: $categoryList");
    return categoryList;
  }
}

class BrandsRepo {
  Future<List<BrandsModel>> getAllBrand() async {
    List<BrandsModel> brandsList = [];
    await FirebaseDatabase.instance
        .ref(constUserId)
        .child('Brands')
        .orderByKey()
        .get()
        .then((value) {
      for (var element in value.children) {
        brandsList
            .add(BrandsModel.fromJson(jsonDecode(jsonEncode(element.value))));
      }
    });
    final brandRef = FirebaseDatabase.instance.ref(constUserId).child('Brands');
    brandRef.keepSynced(true);
    return brandsList;
  }
}

class UnitsRepo {
  Future<List<UnitModel>> getAllUnits() async {
    List<UnitModel> unitsList = [];
    await FirebaseDatabase.instance
        .ref(constUserId)
        .child('Units')
        .orderByKey()
        .get()
        .then((value) {
      for (var element in value.children) {
        unitsList
            .add(UnitModel.fromJson(jsonDecode(jsonEncode(element.value))));
      }
    });
    final unitRef = FirebaseDatabase.instance.ref(constUserId).child('Units');
    unitRef.keepSynced(true);
    return unitsList;
  }
}
