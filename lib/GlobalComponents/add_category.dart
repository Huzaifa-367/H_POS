// ignore_for_file: unused_result

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_pos/GlobalComponents/Model/category_model.dart';
import 'package:mobile_pos/GlobalComponents/button_global.dart';
import 'package:mobile_pos/Provider/category_brans_units_provide.dart';
import 'package:mobile_pos/constant.dart';
import 'package:nb_utils/nb_utils.dart';

class AddCategory extends StatefulWidget {
  const AddCategory({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AddCategoryState createState() => _AddCategoryState();
}

class _AddCategoryState extends State<AddCategory> {
  bool showProgress = false;
  late String categoryName;
  bool sizeCheckbox = false;
  bool colorCheckbox = false;
  bool weightCheckbox = false;
  bool capacityCheckbox = false;
  bool typeCheckbox = false;

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, __) {
      final allCategory = ref.watch(categoryProvider);
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
            'Add Category',
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
            padding: const EdgeInsets.all(15.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
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
                      categoryName = value;
                    });
                  },
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Fashion',
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    labelText: 'Category name',
                  ),
                ),
                const SizedBox(height: 20),
                const Text('Select variations : '),
                Row(
                  children: [
                    Expanded(
                      child: CheckboxListTile(
                        title: const Text("Size"),
                        value: sizeCheckbox,
                        checkboxShape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(50))),
                        onChanged: (newValue) {
                          setState(() {
                            sizeCheckbox = newValue!;
                          });
                        },
                        controlAffinity: ListTileControlAffinity
                            .leading, //  <-- leading Checkbox
                      ),
                    ),
                    Expanded(
                      child: CheckboxListTile(
                        title: const Text("Color"),
                        value: colorCheckbox,
                        checkboxShape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(50))),
                        onChanged: (newValue) {
                          setState(() {
                            colorCheckbox = newValue!;
                          });
                        },
                        controlAffinity: ListTileControlAffinity
                            .leading, //  <-- leading Checkbox
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: CheckboxListTile(
                        title: const Text("Weight"),
                        checkboxShape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(50))),
                        value: weightCheckbox,
                        onChanged: (newValue) {
                          setState(() {
                            weightCheckbox = newValue!;
                          });
                        },
                        controlAffinity: ListTileControlAffinity
                            .leading, //  <-- leading Checkbox
                      ),
                    ),
                    Expanded(
                      child: CheckboxListTile(
                        title: const Text("Capacity"),
                        checkboxShape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(50))),
                        value: capacityCheckbox,
                        onChanged: (newValue) {
                          setState(() {
                            capacityCheckbox = newValue!;
                          });
                        },
                        controlAffinity: ListTileControlAffinity
                            .leading, //  <-- leading Checkbox
                      ),
                    ),
                  ],
                ),
                CheckboxListTile(
                  title: const Text("Type"),
                  checkboxShape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(50))),
                  value: typeCheckbox,
                  onChanged: (newValue) {
                    setState(() {
                      typeCheckbox = newValue!;
                    });
                  },
                  controlAffinity:
                      ListTileControlAffinity.leading, //  <-- leading Checkbox
                ),
                ButtonGlobalWithoutIcon(
                  buttontext: 'Save',
                  buttonDecoration:
                      kButtonDecoration.copyWith(color: Constants.kMainColor),
                  onPressed: () async {
                    bool isAlreadyAdded = false;
                    allCategory.value?.forEach((element) {
                      if (element.categoryName
                          .toLowerCase()
                          .removeAllWhiteSpace()
                          .contains(
                            categoryName.toLowerCase().removeAllWhiteSpace(),
                          )) {
                        isAlreadyAdded = true;
                      }
                    });
                    setState(() {
                      showProgress = true;
                    });
                    // ignore: no_leading_underscores_for_local_identifiers
                    final DatabaseReference _categoryInformationRef =
                        FirebaseDatabase.instance
                            .ref()
                            .child(constUserId)
                            .child('Categories');
                    _categoryInformationRef.keepSynced(true);

                    CategoryModel categoryModel = CategoryModel(
                      categoryName: categoryName,
                      size: sizeCheckbox,
                      color: colorCheckbox,
                      capacity: capacityCheckbox,
                      type: typeCheckbox,
                      weight: weightCheckbox,
                    );
                    isAlreadyAdded
                        ? EasyLoading.showError('Already Added')
                        : _categoryInformationRef
                            .push()
                            .set(categoryModel.toJson());
                    setState(() {
                      showProgress = false;
                      isAlreadyAdded
                          ? null
                          : ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text("Data Saved Successfully")));
                    });
                    ref.refresh(categoryProvider);

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
