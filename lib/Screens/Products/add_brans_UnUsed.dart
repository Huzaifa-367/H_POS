// ignore_for_file: unused_result

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_pos/GlobalComponents/button_global.dart';
import 'package:mobile_pos/Provider/category_brans_units_provide.dart';
import 'package:mobile_pos/Screens/Products/Model/brands_model.dart';
import 'package:mobile_pos/constant.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:mobile_pos/generated/l10n.dart' as lang;

class AddBrands extends StatefulWidget {
  const AddBrands({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AddBrandsState createState() => _AddBrandsState();
}

class _AddBrandsState extends State<AddBrands> {
  bool showProgress = false;
  late String brandName;

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, __) {
      final allBrands = ref.watch(brandsProvider);
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
            lang.S.of(context).addBrand,
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
        body: SingleChildScrollView(
          child: Padding(
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
                      brandName = value;
                    });
                  },
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    hintText: 'Apple',
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    labelText: lang.S.of(context).brandName,
                  ),
                ),
                ButtonGlobalWithoutIcon(
                  buttontext: lang.S.of(context).save,
                  buttonDecoration:
                      kButtonDecoration.copyWith(color: Constants.kMainColor),
                  onPressed: () async {
                    bool isAlreadyAdded = false;
                    allBrands.value?.forEach((element) {
                      if (element.brandName
                              .toLowerCase()
                              .removeAllWhiteSpace() ==
                          brandName.toLowerCase().removeAllWhiteSpace()) {
                        isAlreadyAdded = true;
                      }
                    });
                    setState(() {
                      showProgress = true;
                    });
                    final DatabaseReference categoryInformationRef =
                        FirebaseDatabase.instance
                            .ref()
                            .child(constUserId)
                            .child('Brands');
                    categoryInformationRef.keepSynced(true);
                    BrandsModel brandModel = BrandsModel(brandName);
                    isAlreadyAdded
                        ? EasyLoading.showError('Already Added')
                        : categoryInformationRef
                            .push()
                            .set(brandModel.toJson());
                    setState(() {
                      showProgress = false;
                      isAlreadyAdded
                          ? null
                          : ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text("Data Saved Successfully")));
                    });
                    ref.refresh(brandsProvider);

                    // ignore: use_build_context_synchronously
                    isAlreadyAdded ? null : Navigator.pop(context);
                  },
                  buttonTextColor: Colors.white,
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
