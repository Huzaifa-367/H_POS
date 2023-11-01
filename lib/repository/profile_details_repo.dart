import 'dart:convert';
import 'package:firebase_database/firebase_database.dart';
import 'package:mobile_pos/constant.dart';
import 'package:mobile_pos/model/personal_information_model.dart';

class ProfileRepo {
  DatabaseReference ref = FirebaseDatabase.instance.ref();

  Future<PersonalInformationModel> getDetails() async {
    PersonalInformationModel personalInfo = PersonalInformationModel(
        companyName: 'Loading...',
        businessCategory: 'Loading...',
        countryName: 'Loading...',
        language: 'Loading...',
        phoneNumber: 'Loading...',
        remainingShopBalance: 0,
        shopOpeningBalance: 0,
        invoiceCounter: 1,
        pictureUrl:
            'https://cdn.pixabay.com/photo/2017/06/13/12/53/profile-2398782_960_720.png');
    final userRef = FirebaseDatabase.instance
        .ref(constUserId)
        .child('Personal Information');
    //print(userRef);
    final model = await userRef.get();
    userRef.keepSynced(true);
    var data = jsonDecode(jsonEncode(model.value));
    if (data == null) {
      //print(personalInfo);
      return personalInfo;
    } else {
      return PersonalInformationModel.fromJson(data);
    }
  }
}
