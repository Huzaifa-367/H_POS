import 'package:firebase_database/firebase_database.dart';

import '../../../model/personal_information_model.dart';

class PersonalInformationDao {
  final DatabaseReference _personalInformationRef =
      // ignore: deprecated_member_use
      FirebaseDatabase.instance.reference().child('Personal Information');

  void saveInformation(PersonalInformationModel information) {
    _personalInformationRef.set(information.toJson());
  }

  Query getInformationQuery() {
    return _personalInformationRef;
  }
}
