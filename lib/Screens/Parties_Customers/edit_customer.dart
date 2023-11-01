// ignore: import_of_legacy_library_into_null_safe
// ignore_for_file: unused_result

import 'dart:convert';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart' as firebase_core;
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile_pos/GlobalComponents/button_global.dart';
import 'package:mobile_pos/Screens/Parties_Customers/Model/customer_model.dart';
import 'package:mobile_pos/constant.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../Provider/customer_provider.dart';
import 'parties_list.dart';
import 'package:mobile_pos/generated/l10n.dart' as lang;

// ignore: must_be_immutable
class EditCustomer extends StatefulWidget {
  EditCustomer({Key? key, required this.customerModel}) : super(key: key);
  CustomerModel customerModel;

  @override
  // ignore: library_private_types_in_public_api
  _EditCustomerState createState() => _EditCustomerState();
}

class _EditCustomerState extends State<EditCustomer> {
  late CustomerModel updatedCustomerModel;
  String groupValue = '';

  // ignore: prefer_typing_uninitialized_variables
  var dialogContext;
  bool expanded = false;
  final ImagePicker _picker = ImagePicker();
  bool showProgress = false;
  double progress = 0.0;
  XFile? pickedImage;
  File imageFile = File('No File');
  String imagePath = 'No Data';
  late String customerKey;

  void getCustomerKey(String phoneNumber) async {
    final userId = constUserId;
    await FirebaseDatabase.instance
        .ref(userId)
        .child('Customers')
        .orderByKey()
        .get()
        .then((value) {
      for (var element in value.children) {
        var data = jsonDecode(jsonEncode(element.value));
        if (data['phoneNumber'].toString() == phoneNumber) {
          customerKey = element.key.toString();
        }
      }
    });
  }

  Future<void> uploadFile(String filePath) async {
    File file = File(filePath);
    try {
      EasyLoading.show(
        status: 'Uploading... ',
        dismissOnTap: false,
      );
      var snapshot = await FirebaseStorage.instance
          .ref('Customer Picture/${DateTime.now().millisecondsSinceEpoch}')
          .putFile(file);
      var url = await snapshot.ref.getDownloadURL();
      setState(() {
        updatedCustomerModel.profilePicture = url.toString();
      });
    } on firebase_core.FirebaseException catch (e) {
      EasyLoading.dismiss();
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.code.toString())));
    }
  }

  @override
  void initState() {
    getCustomerKey(widget.customerModel.phoneNumber);
    updatedCustomerModel = widget.customerModel;
    groupValue = widget.customerModel.type;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, cRef, __) {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text(
            lang.S.of(context).updateContact,
            style: GoogleFonts.poppins(
              color: Colors.black,
            ),
          ),
          centerTitle: true,
          iconTheme: const IconThemeData(color: Colors.black),
          elevation: 0.0,
        ),
        body: Consumer(builder: (context, ref, __) {
          // ignore: unused_local_variable
          final customerData = ref.watch(customerProvider);

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: AppTextField(
                      initialValue: widget.customerModel.phoneNumber,
                      readOnly: true,
                      textFieldType: TextFieldType.PHONE,
                      decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color:
                                  Constants.kMainColor!), // Change the border color when focused
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color:
                                  Constants().kBgColor), // Change the border color when not focused
                        ),
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        labelText: lang.S.of(context).phone,
                        border: const OutlineInputBorder(),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: AppTextField(
                      initialValue: widget.customerModel.customerName,
                      textFieldType: TextFieldType.NAME,
                      onChanged: (value) {
                        setState(() {
                          updatedCustomerModel.customerName = value;
                        });
                      },
                      decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color:
                                  Constants.kMainColor!), // Change the border color when focused
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color:
                                  Constants().kBgColor), // Change the border color when not focused
                        ),
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        labelText: lang.S.of(context).name,
                        hintText: 'John Doe',
                        border: const OutlineInputBorder(),
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: RadioListTile(
                          contentPadding: EdgeInsets.zero,
                          activeColor: Constants.kMainColor,
                          groupValue: groupValue,
                          title: Text(
                            lang.S.of(context).retailer,
                            maxLines: 1,
                            style: GoogleFonts.poppins(
                              fontSize: 12.0,
                            ),
                          ),
                          value: 'Retailer',
                          onChanged: (value) {
                            setState(() {
                              groupValue = value.toString();
                              updatedCustomerModel.type = value.toString();
                            });
                          },
                        ),
                      ),
                      Expanded(
                        child: RadioListTile(
                          contentPadding: EdgeInsets.zero,
                          groupValue: groupValue,
                          activeColor: Constants.kMainColor,
                          title: Text(
                            lang.S.of(context).dealer,
                            maxLines: 1,
                            style: GoogleFonts.poppins(
                              fontSize: 12.0,
                            ),
                          ),
                          value: 'Dealer',
                          onChanged: (value) {
                            setState(() {
                              groupValue = value.toString();
                              updatedCustomerModel.type = value.toString();
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: RadioListTile(
                          contentPadding: EdgeInsets.zero,
                          activeColor: Constants.kMainColor,
                          groupValue: groupValue,
                          title: Text(
                            lang.S.of(context).wholesaler,
                            maxLines: 1,
                            style: GoogleFonts.poppins(
                              fontSize: 12.0,
                            ),
                          ),
                          value: 'Wholesaler',
                          onChanged: (value) {
                            setState(() {
                              groupValue = value.toString();
                              updatedCustomerModel.type = value.toString();
                            });
                          },
                        ),
                      ),
                      Expanded(
                        child: RadioListTile(
                          contentPadding: EdgeInsets.zero,
                          activeColor: Constants.kMainColor,
                          groupValue: groupValue,
                          title: Text(
                            lang.S.of(context).supplier,
                            maxLines: 1,
                            style: GoogleFonts.poppins(
                              fontSize: 12.0,
                            ),
                          ),
                          value: 'Supplier',
                          onChanged: (value) {
                            setState(() {
                              groupValue = value.toString();
                              updatedCustomerModel.type = value.toString();
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  Visibility(
                    visible: showProgress,
                    child: CircularProgressIndicator(
                      color: Constants.kMainColor,
                      strokeWidth: 5.0,
                    ),
                  ),
                  ExpansionPanelList(
                    expandIconColor: Constants.kMainColor,
                    expansionCallback: (int index, bool isExpanded) {},
                    animationDuration: const Duration(seconds: 1),
                    elevation: 0,
                    dividerColor: Colors.white,
                    children: [
                      ExpansionPanel(
                        headerBuilder: (BuildContext context, bool isExpanded) {
                          return Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              TextButton(
                                child: Text(
                                  lang.S.of(context).moreInfo,
                                  style: GoogleFonts.poppins(
                                    fontSize: 20.0,
                                    color: Constants.kMainColor,
                                  ),
                                ),
                                onPressed: () {
                                  setState(() {
                                    expanded == false
                                        ? expanded = true
                                        : expanded = false;
                                  });
                                },
                              ),
                            ],
                          );
                        },
                        body: Column(
                          children: [
                            GestureDetector(
                              onTap: () {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return Dialog(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(12.0),
                                        ),
                                        // ignore: sized_box_for_whitespace
                                        child: Container(
                                          height: 200.0,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width -
                                              80,
                                          child: Center(
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                GestureDetector(
                                                  onTap: () async {
                                                    pickedImage =
                                                        await _picker.pickImage(imageQuality: 20,
                                                            source: ImageSource
                                                                .gallery);
                                                    setState(() {
                                                      imageFile = File(
                                                          pickedImage!.path);
                                                      imagePath =
                                                          pickedImage!.path;
                                                    });
                                                    Future.delayed(
                                                        const Duration(
                                                            milliseconds: 100),
                                                        () {
                                                      Navigator.pop(context);
                                                    });
                                                  },
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Icon(
                                                        Icons
                                                            .photo_library_rounded,
                                                        size: 60.0,
                                                        color: Constants.kMainColor,
                                                      ),
                                                      Text(
                                                        lang.S
                                                            .of(context)
                                                            .gallery,
                                                        style:
                                                            GoogleFonts.poppins(
                                                          fontSize: 20.0,
                                                          color: Constants.kMainColor,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                const SizedBox(
                                                  width: 40.0,
                                                ),
                                                GestureDetector(
                                                  onTap: () async {
                                                    pickedImage =
                                                        await _picker.pickImage(imageQuality: 20,
                                                            source: ImageSource
                                                                .camera);
                                                    setState(() {
                                                      imageFile = File(
                                                          pickedImage!.path);
                                                      imagePath =
                                                          pickedImage!.path;
                                                    });
                                                    Future.delayed(
                                                        const Duration(
                                                            milliseconds: 100),
                                                        () {
                                                      Navigator.pop(context);
                                                    });
                                                  },
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      const Icon(
                                                        Icons.camera,
                                                        size: 60.0,
                                                        color: kGreyTextColor,
                                                      ),
                                                      Text(
                                                        lang.S
                                                            .of(context)
                                                            .camera,
                                                        style:
                                                            GoogleFonts.poppins(
                                                          fontSize: 20.0,
                                                          color: kGreyTextColor,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    });
                              },
                              child: Stack(
                                children: [
                                  Container(
                                    height: 120,
                                    width: 120,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Constants.kMainColor!, width: 1),
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(120)),
                                      image: imagePath == 'No Data'
                                          ? DecorationImage(
                                              image: NetworkImage(
                                                  updatedCustomerModel
                                                      .profilePicture),
                                              fit: BoxFit.cover,
                                            )
                                          : DecorationImage(
                                              image: FileImage(imageFile),
                                              fit: BoxFit.cover,
                                            ),
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 0,
                                    right: 0,
                                    child: Container(
                                      height: 35,
                                      width: 35,
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                            color: Colors.white, width: 2),
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(120)),
                                        color: Constants.kMainColor,
                                      ),
                                      child: const Icon(
                                        Icons.camera_alt_outlined,
                                        size: 20,
                                        color: Colors.white,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            const SizedBox(height: 10),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: AppTextField(
                                initialValue: widget.customerModel.emailAddress,
                                textFieldType: TextFieldType.EMAIL,
                                onChanged: (value) {
                                  setState(() {
                                    updatedCustomerModel.emailAddress = value;
                                  });
                                },
                                decoration: InputDecoration(
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color:
                                            Constants.kMainColor!), // Change the border color when focused
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color:
                                            Constants().kBgColor), // Change the border color when not focused
                                  ),
                                  border: const OutlineInputBorder(),
                                  floatingLabelBehavior:
                                      FloatingLabelBehavior.always,
                                  labelText: lang.S.of(context).email,
                                  hintText: 'example@example.com',
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: AppTextField(
                                initialValue:
                                    widget.customerModel.customerAddress,
                                textFieldType: TextFieldType.NAME,
                                maxLines: 2,
                                onChanged: (value) {
                                  setState(() {
                                    updatedCustomerModel.customerAddress =
                                        value;
                                  });
                                },
                                decoration: InputDecoration(
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color:
                                              Constants.kMainColor!), // Change the border color when focused
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color:
                                              Constants().kBgColor), // Change the border color when not focused
                                    ),
                                    border: const OutlineInputBorder(),
                                    floatingLabelBehavior:
                                        FloatingLabelBehavior.always,
                                    labelText: lang.S.of(context).address,
                                    hintText:
                                        'Placentia, California(CA), 92870'),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: AppTextField(
                                //readOnly: true,
                                initialValue: widget.customerModel.dueAmount,
                                textFieldType: TextFieldType.NAME,
                                maxLines: 1,
                                decoration: InputDecoration(
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color:
                                            Constants.kMainColor!), // Change the border color when focused
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color:
                                            Constants().kBgColor), // Change the border color when not focused
                                  ),
                                  border: const OutlineInputBorder(),
                                  floatingLabelBehavior:
                                      FloatingLabelBehavior.always,
                                  labelText: lang.S.of(context).previousDue,
                                ),
                              ),
                            ),
                          ],
                        ),
                        isExpanded: expanded,
                      ),
                    ],
                  ),
                  ButtonGlobalWithoutIcon(
                      buttontext: lang.S.of(context).update,
                      buttonDecoration:
                          kButtonDecoration.copyWith(color: Constants.kMainColor),
                      onPressed: () async {
                        try {
                          EasyLoading.show(
                              status: 'Loading...', dismissOnTap: false);
                          imagePath == 'No Data'
                              ? null
                              : await uploadFile(imagePath);
                          DatabaseReference ref = FirebaseDatabase.instance
                              .ref("$constUserId/Customers/$customerKey");
                          await ref.update({
                            'customerName': updatedCustomerModel.customerName,
                            'type': updatedCustomerModel.type,
                            'profilePicture':
                                updatedCustomerModel.profilePicture,
                            'emailAddress': updatedCustomerModel.emailAddress,
                            'customerAddress':
                                updatedCustomerModel.customerAddress,
                          });
                          EasyLoading.showSuccess('Added Successfully',
                              duration: const Duration(milliseconds: 500));
                          //ref.refresh(productProvider);
                          Future.delayed(const Duration(milliseconds: 100), () {
                            cRef.refresh(customerProvider);
                            const CustomerList()
                                .launch(context, isNewTask: true);
                          });
                        } catch (e) {
                          EasyLoading.dismiss();
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(e.toString())));
                        }
                      },
                      buttonTextColor: Colors.white),
                ],
              ),
            ),
          );
        }),
      );
    });
  }
}
