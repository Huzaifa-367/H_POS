import 'dart:convert';
import 'package:firebase_database/firebase_database.dart';
import '../model/homepage_image_model.dart';

class HomePageImageRepo {
  Future<List<HomePageImageModel>> getAllHomePageImage() async {
    List<HomePageImageModel> imageList = [];
    await FirebaseDatabase.instance.ref().child('Admin Panel').child('Homepage Image').orderByKey().get().then((value) {
      for (var element in value.children) {
        imageList.add(HomePageImageModel.fromJson(jsonDecode(jsonEncode(element.value))));
      }
    });
    return imageList;
  }
}
