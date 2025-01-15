// ignore_for_file: unused_result

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_pos/GlobalComponents/button_global.dart';
import 'package:mobile_pos/Provider/category_brans_units_provide.dart';
import 'package:mobile_pos/Screens/Products/Model/unit_model.dart';
import 'package:mobile_pos/constant.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:mobile_pos/generated/l10n.dart' as lang;

class AddUnits extends StatefulWidget {
  const AddUnits({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AddUnitsState createState() => _AddUnitsState();
}

class _AddUnitsState extends State<AddUnits> {
  bool showProgress = false;
  late String unitsName;

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, __) {
      final allUnits = ref.watch(unitsProvider);
      return Scaffold(
        appBar: AppBar(
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Image(
                image: AssetImage('images/x.png'),
              )),
          title: Text(
            lang.S.of(context).addUnit,
            style: GoogleFonts.poppins(
              color: Colors.black,
              fontSize: 20.0,
            ),
          ),
          iconTheme: const IconThemeData(color: Colors.black),
          centerTitle: true,
          backgroundColor: Colors.white,
          elevation: 0.0,
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Visibility(
                visible: showProgress,
                child: CircularProgressIndicator(
                  color: Constants.kMainColor,
                  strokeWidth: 5.0,
                ),
              ),
              AppTextField(
                textFieldType: TextFieldType.NAME,
                onChanged: (value) {
                  setState(() {
                    unitsName = value;
                  });
                },
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  hintText: 'kg',
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  labelText: lang.S.of(context).unitName,
                ),
              ),
              ButtonGlobalWithoutIcon(
                buttontext: lang.S.of(context).save,
                buttonDecoration:
                    kButtonDecoration.copyWith(color: Constants.kMainColor),
                onPressed: () async {
                  bool isAlreadyAdded = false;
                  allUnits.value?.forEach((element) {
                    if (element.unitName.toLowerCase().removeAllWhiteSpace() ==
                        unitsName.toLowerCase().removeAllWhiteSpace()) {
                      isAlreadyAdded = true;
                    }
                  });
                  setState(() {
                    showProgress = true;
                  });
                  final DatabaseReference unitInformationRef = FirebaseDatabase
                      .instance
                      .ref()
                      .child(constUserId)
                      .child('Units');
                  unitInformationRef.keepSynced(true);
                  UnitModel unitModel = UnitModel(unitsName);
                  isAlreadyAdded
                      ? EasyLoading.showError('Already Added')
                      : unitInformationRef.push().set(unitModel.toJson());
                  setState(() {
                    showProgress = false;
                    isAlreadyAdded
                        ? null
                        : ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text("Data Saved Successfully")));
                  });

                  ref.refresh(unitsProvider);

                  // ignore: use_build_context_synchronously
                  isAlreadyAdded ? null : Navigator.pop(context);
                },
                buttonTextColor: Colors.white,
              ),
            ],
          ),
        ),
      );
    });
  }
}
