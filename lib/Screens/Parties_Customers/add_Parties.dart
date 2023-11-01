// ignore: import_of_legacy_library_into_null_safe
// ignore_for_file: unused_result

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
import 'package:mobile_pos/generated/l10n.dart' as lang;

class AddCustomer extends StatefulWidget {
  const AddCustomer({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _AddCustomerState createState() => _AddCustomerState();
}

class _AddCustomerState extends State<AddCustomer> {
  String radioItem = 'Retailer';
  String groupValue = '';

  // ignore: prefer_typing_uninitialized_variables
  var dialogContext;
  bool expanded = false;
  String customerName = 'Guest';
  String phoneNumber = '000';
  String customerAddress = 'Not Provided';
  String emailAddress = 'Not Provided';
  String dueAmount = '0';
  String profilePicture =
      'https://firebasestorage.googleapis.com/v0/b/salespro-82021.appspot.com/o/Customer%20Picture%2Fnoprofile%20pic.jpeg?alt=media&token=08c02444-083f-4986-8d56-43f4c7e1160d';
  final ImagePicker _picker = ImagePicker();
  bool showProgress = false;
  double progress = 0.0;
  bool isPhoneAlready = false;
  XFile? pickedImage;
  TextEditingController phoneText = TextEditingController();
  File imageFile = File('No File');
  String imagePath = 'No Data';

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
        profilePicture = url.toString();
      });
    } on firebase_core.FirebaseException catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.code.toString())));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          lang.S.of(context).addContact,
          style: GoogleFonts.poppins(
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 0.0,
      ),
      body: Consumer(builder: (context, ref, __) {
        final customerData = ref.watch(customerProvider);

        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: AppTextField(
                    controller: phoneText,
                    textFieldType: TextFieldType.PHONE,
                    onChanged: (value) {
                      setState(() {
                        phoneNumber = value;
                      });
                    },
                    decoration: InputDecoration(
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      labelText: lang.S.of(context).phone,
                      hintText: lang.S.of(context).enterYourPhoneNumber,
                      border: const OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Constants.kMainColor,
                        ), // Change the border color when focused
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Constants().kBgColor),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: AppTextField(
                    textFieldType: TextFieldType.NAME,
                    onChanged: (value) {
                      setState(() {
                        customerName = value;
                      });
                    },
                    decoration: InputDecoration(
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      labelText: lang.S.of(context).name,
                      hintText: lang.S.of(context).enterYourName,
                      border: const OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Constants
                                .kMainColor), // Change the border color when focused
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Constants().kBgColor),
                      ),
                    ),
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: RadioListTile(
                        contentPadding: EdgeInsets.zero,
                        groupValue: groupValue,
                        activeColor: Constants.kMainColor,
                        title: Text(
                          lang.S.of(context).retailer,
                          maxLines: 1,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        value: 'Retailer',
                        onChanged: (value) {
                          setState(() {
                            groupValue = value.toString();
                            radioItem = value.toString();
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
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        value: 'Dealer',
                        onChanged: (value) {
                          setState(() {
                            groupValue = value.toString();
                            radioItem = value.toString();
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
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        value: 'Wholesaler',
                        onChanged: (value) {
                          setState(() {
                            groupValue = value.toString();
                            radioItem = value.toString();
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
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        value: 'Supplier',
                        onChanged: (value) {
                          setState(() {
                            groupValue = value.toString();
                            radioItem = value.toString();
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
                  expansionCallback: (int index, bool isExpanded) {
                    setState(() {
                      expanded == false ? expanded = true : expanded = false;
                    });
                  },
                  animationDuration: const Duration(milliseconds: 500),
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
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Constants.kMainColor),
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
                                        width:
                                            MediaQuery.of(context).size.width -
                                                80,
                                        child: Center(
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              GestureDetector(
                                                onTap: () async {
                                                  pickedImage =
                                                      await _picker.pickImage(
                                                          imageQuality: 20,
                                                          source: ImageSource
                                                              .gallery);
                                                  setState(() {
                                                    imageFile =
                                                        File(pickedImage!.path);
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
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Icon(
                                                      Icons
                                                          .photo_library_rounded,
                                                      size: 60.0,
                                                      color:
                                                          Constants.kMainColor,
                                                    ),
                                                    Text(
                                                      'Gallery',
                                                      style:
                                                          GoogleFonts.poppins(
                                                        fontSize: 20.0,
                                                        color: Constants
                                                            .kMainColor,
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
                                                      await _picker.pickImage(
                                                          imageQuality: 20,
                                                          source: ImageSource
                                                              .camera);
                                                  setState(() {
                                                    imageFile =
                                                        File(pickedImage!.path);
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
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    const Icon(
                                                      Icons.camera,
                                                      size: 60.0,
                                                      color: kGreyTextColor,
                                                    ),
                                                    Text(
                                                      'Camera',
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
                                        color: Constants.kMainColor, width: 1),
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(120)),
                                    image: imagePath == 'No Data'
                                        ? DecorationImage(
                                            image: NetworkImage(profilePicture),
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
                          const SizedBox(height: 15),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: AppTextField(
                              textFieldType: TextFieldType.EMAIL,
                              onChanged: (value) {
                                setState(() {
                                  emailAddress = value;
                                });
                              },
                              decoration: InputDecoration(
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Constants
                                          .kMainColor), // Change the border color when focused
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Constants().kBgColor),
                                ),
                                border: const OutlineInputBorder(),
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.always,
                                labelText: lang.S.of(context).email,
                                hintText: 'example@gmail.com',
                                hintStyle: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: AppTextField(
                              textFieldType: TextFieldType.NAME,
                              maxLines: 2,
                              onChanged: (value) {
                                setState(() {
                                  customerAddress = value;
                                });
                              },
                              decoration: InputDecoration(
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Constants
                                          .kMainColor), // Change the border color when focused
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Constants().kBgColor),
                                ),
                                border: const OutlineInputBorder(),
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.always,
                                labelText: lang.S.of(context).address,
                                hintText: 'Rawalpindi, Pakistan',
                                hintStyle: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: AppTextField(
                              textFieldType: TextFieldType.PHONE,
                              onChanged: (value) {
                                setState(() {
                                  dueAmount = value;
                                });
                              },
                              maxLines: 2,
                              decoration: InputDecoration(
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Constants
                                          .kMainColor), // Change the border color when focused
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Constants().kBgColor),
                                ),
                                border: const OutlineInputBorder(),
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.always,
                                labelText: lang.S.of(context).previousDue,
                                hintText: lang.S.of(context).amount,
                                hintStyle: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
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
                    buttontext: lang.S.of(context).save,
                    buttonDecoration:
                        kButtonDecoration.copyWith(color: Constants.kMainColor),
                    onPressed: () async {
                      for (var element in customerData.value!) {
                        if (element.phoneNumber == phoneNumber) {
                          EasyLoading.showError('Phone number already exist');
                          isPhoneAlready = true;
                          phoneText.clear();
                        }
                      }
                      Future.delayed(const Duration(milliseconds: 500),
                          () async {
                        if (isPhoneAlready) {
                        } else {
                          try {
                            EasyLoading.show(
                                status: 'Loading...', dismissOnTap: false);
                            imagePath == 'No Data'
                                ? null
                                : await uploadFile(imagePath);
                            // ignore: no_leading_underscores_for_local_identifiers
                            final DatabaseReference _customerInformationRef =
                                FirebaseDatabase.instance
                                    // ignore: deprecated_member_use
                                    .reference()
                                    .child(constUserId)
                                    .child('Customers');
                            _customerInformationRef.keepSynced(true);
                            CustomerModel customerModel = CustomerModel(
                              customerName,
                              phoneNumber,
                              radioItem,
                              profilePicture,
                              emailAddress,
                              customerAddress,
                              dueAmount,
                            );
                            _customerInformationRef
                                .push()
                                .set(customerModel.toJson());

                            ///________Subscription_____________________________________________________
                            decreaseSubscriptionSale();

                            EasyLoading.showSuccess('Added Successfully!');
                            _customerInformationRef.onChildAdded
                                .listen((event) {
                              ref.refresh(customerProvider);
                            });
                            Future.delayed(const Duration(milliseconds: 100),
                                () {
                              Navigator.pop(context);
                            });
                          } catch (e) {
                            EasyLoading.dismiss();
                            ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(e.toString())));
                          }
                        }
                      });
                    },
                    buttonTextColor: Colors.white),
              ],
            ),
          ),
        );
      }),
    );
  }

  void decreaseSubscriptionSale() async {
    final userId = constUserId;
    final ref =
        FirebaseDatabase.instance.ref('$userId/Subscription/partiesNumber');
    ref.keepSynced(true);
    var data = await ref.once();
    int beforeSale = int.parse(data.snapshot.value.toString());
    int afterSale = beforeSale - 1;
    beforeSale != -202
        ? FirebaseDatabase.instance
            .ref('$userId/Subscription')
            .update({'partiesNumber': afterSale})
        : null;
  }
}
