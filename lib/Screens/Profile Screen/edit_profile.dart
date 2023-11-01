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
import 'package:nb_utils/nb_utils.dart';

import '../../Provider/profile_provider.dart';
import '../../Provider/shop_category_provider.dart';
import '../../constant.dart';
import '../../model/personal_information_model.dart';
import 'package:mobile_pos/generated/l10n.dart' as lang;

import '../../model/shop_category_model.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({Key? key, required this.profile}) : super(key: key);

  final PersonalInformationModel profile;

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  String dropdownLangValue = 'English';
  String initialCountry = 'Bangladesh';
  String dropdownValue = '';
  String companyName = 'nodata', phoneNumber = 'nodata';
  double progress = 0.0;
  int invoiceNumber = 0;
  bool showProgress = false;
  String profilePicture = 'nodata';
  int openingBalance = 0;
  int remainingShopBalance = 0;

  // ignore: prefer_typing_uninitialized_variables
  var dialogContext;
  final ImagePicker _picker = ImagePicker();
  XFile? pickedImage;
  File imageFile = File('No File');
  String imagePath = 'No Data';

  int loopCount = 0;

  Future<void> uploadFile(String filePath) async {
    File file = File(filePath);
    try {
      EasyLoading.show(
        status: 'Uploading... ',
        dismissOnTap: false,
      );
      final ref = FirebaseStorage.instance
          .ref('Profile Picture/${DateTime.now().millisecondsSinceEpoch}');

      var snapshot = await ref.putFile(file);
      var url = await snapshot.ref.getDownloadURL();
      print("Profile picture Uploading:  $url");
      setState(() {
        profilePicture = url.toString();
        print("Profile picture Uploading:  $profilePicture");
      });
    } on firebase_core.FirebaseException catch (e) {
      EasyLoading.dismiss();
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.code.toString())));
    }
  }

  DropdownButton<String> getCategory(
      {required String category, required List<ShopCategoryModel> list}) {
    List<String> categories = [];
    bool inNotInList = true;
    for (var element in list) {
      categories.add(element.categoryName ?? '');
      if (element.categoryName == dropdownValue) {
        inNotInList = false;
      }
    }

    List<DropdownMenuItem<String>> dropDownItems = [];
    if (inNotInList) {
      dropDownItems = [
        DropdownMenuItem(
          value: category,
          child: Text(category),
        ),
      ];
    }
    for (String category in categories) {
      var item = DropdownMenuItem(
        value: category,
        child: Text(category),
      );
      dropDownItems.add(item);
    }
    return DropdownButton(
      iconEnabledColor: Constants.kMainColor,
      items: dropDownItems,
      value: category,
      onChanged: (value) {
        setState(() {
          dropdownValue = value!;
        });
      },
    );
  }

  DropdownButton<String> getLanguage(String lang) {
    List<DropdownMenuItem<String>> dropDownLangItems = [];
    for (String lang in language) {
      var item = DropdownMenuItem(
        value: lang,
        child: Text(lang),
      );
      dropDownLangItems.add(item);
    }
    return DropdownButton(
      iconEnabledColor: Constants.kMainColor,
      items: dropDownLangItems,
      value: lang,
      onChanged: (value) {
        setState(() {
          dropdownLangValue = value!;
        });
      },
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    dropdownValue = widget.profile.businessCategory ?? '';
    dropdownLangValue = widget.profile.language ?? '';
    profilePicture = widget.profile.pictureUrl ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black),
        title: Text(
          lang.S.of(context).updateProfile,
          style: GoogleFonts.poppins(
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0.0,
      ),
      body: SingleChildScrollView(
        child: Consumer(builder: (context, ref, child) {
          AsyncValue<PersonalInformationModel> userProfileDetails =
              ref.watch(profileDetailsProvider);
          AsyncValue<List<ShopCategoryModel>> categoryList =
              ref.watch(shopCategoryProvider);

          return categoryList.when(data: (categoryList) {
            return Center(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                      "Update your profile to connect your customer with better impression",
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        color: kGreyTextColor,
                        fontSize: 15.0,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return Dialog(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              // ignore: sized_box_for_whitespace
                              child: Container(
                                height: 200.0,
                                width: MediaQuery.of(context).size.width - 80,
                                child: Center(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      GestureDetector(
                                        onTap: () async {
                                          pickedImage = await _picker.pickImage(
                                              imageQuality: 20,
                                              source: ImageSource.gallery);

                                          setState(() {
                                            imageFile = File(pickedImage!.path);
                                            imagePath = pickedImage!.path;
                                          });

                                          Future.delayed(
                                              const Duration(milliseconds: 100),
                                              () {
                                            Navigator.pop(context);
                                          });
                                        },
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.photo_library_rounded,
                                              size: 60.0,
                                              color: Constants.kMainColor,
                                            ),
                                            Text(
                                              'Gallery',
                                              style: GoogleFonts.poppins(
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
                                          pickedImage = await _picker.pickImage(
                                            imageQuality: 20,
                                            source: ImageSource.camera,
                                          );
                                          setState(() {
                                            imageFile = File(pickedImage!.path);
                                            imagePath = pickedImage!.path;
                                          });
                                          Future.delayed(
                                              const Duration(milliseconds: 100),
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
                                              style: GoogleFonts.poppins(
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
                            borderRadius:
                                const BorderRadius.all(Radius.circular(120)),
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
                              border: Border.all(color: Colors.white, width: 2),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(120)),
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
                  const SizedBox(height: 20.0),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: SizedBox(
                      height: 60.0,
                      child: FormField(
                        builder: (FormFieldState<dynamic> field) {
                          return InputDecorator(
                            decoration: InputDecoration(
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Constants
                                          .kMainColor), // Change the border color when focused
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Constants()
                                          .kBgColor), // Change the border color when not focused
                                ),
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.always,
                                labelText: lang.S.of(context).businessCat,
                                labelStyle: GoogleFonts.poppins(
                                  color: Colors.black,
                                  fontSize: 20.0,
                                ),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5.0))),
                            child: DropdownButtonHideUnderline(
                                child: getCategory(
                                    category: dropdownValue,
                                    list: categoryList)),
                          );
                        },
                      ),
                    ),
                  ),
                  userProfileDetails.when(data: (details) {
                    invoiceNumber = details.invoiceCounter!;
                    openingBalance = details.shopOpeningBalance;
                    remainingShopBalance = details.remainingShopBalance;

                    return Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: AppTextField(
                            initialValue: details.companyName,
                            onChanged: (value) {
                              setState(() {
                                companyName = value;
                              });
                            }, // Optional
                            textFieldType: TextFieldType.NAME,
                            decoration: InputDecoration(
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Constants
                                        .kMainColor), // Change the border color when focused
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Constants()
                                        .kBgColor), // Change the border color when not focused
                              ),
                              labelText: lang.S.of(context).businessName,
                              border: const OutlineInputBorder(),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: SizedBox(
                            height: 60.0,
                            child: AppTextField(
                              readOnly: true,
                              textFieldType: TextFieldType.PHONE,
                              initialValue: details.phoneNumber,
                              onChanged: (value) {
                                setState(() {
                                  phoneNumber = value;
                                });
                              },
                              decoration: InputDecoration(
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Constants
                                          .kMainColor), // Change the border color when focused
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Constants()
                                          .kBgColor), // Change the border color when not focused
                                ),
                                labelText: lang.S.of(context).phone,
                                border: const OutlineInputBorder(),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: AppTextField(
                            initialValue: details.countryName,
                            onChanged: (value) {
                              setState(() {
                                initialCountry = value;
                              });
                            }, // Optional
                            textFieldType: TextFieldType.NAME,
                            decoration: InputDecoration(
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Constants
                                        .kMainColor), // Change the border color when focused
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Constants()
                                        .kBgColor), // Change the border color when not focused
                              ),
                              labelText: lang.S.of(context).address,
                              border: const OutlineInputBorder(),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: SizedBox(
                            height: 60.0,
                            child: FormField(
                              builder: (FormFieldState<dynamic> field) {
                                return InputDecorator(
                                  decoration: InputDecoration(
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Constants
                                                .kMainColor), // Change the border color when focused
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Constants()
                                                .kBgColor), // Change the border color when not focused
                                      ),
                                      floatingLabelBehavior:
                                          FloatingLabelBehavior.always,
                                      labelText: lang.S.of(context).language,
                                      labelStyle: GoogleFonts.poppins(
                                        color: Colors.black,
                                        fontSize: 20.0,
                                      ),
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(5.0))),
                                  child: DropdownButtonHideUnderline(
                                      child: getLanguage(dropdownLangValue)),
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    );
                  }, error: (e, stack) {
                    return Text(e.toString());
                  }, loading: () {
                    return const CircularProgressIndicator();
                  }),
                  const SizedBox(
                    height: 40.0,
                  ),
                  ButtonGlobal(
                    iconWidget: Icons.arrow_forward,
                    buttontext: lang.S.of(context).continueButton,
                    iconColor: Colors.white,
                    buttonDecoration:
                        kButtonDecoration.copyWith(color: Constants.kMainColor),
                    onPressed: () async {
                      if (profilePicture == 'nodata') {
                        setState(() {
                          profilePicture =
                              userProfileDetails.value!.pictureUrl.toString();
                        });
                      }
                      if (companyName == 'nodata') {
                        setState(() {
                          companyName =
                              userProfileDetails.value!.companyName.toString();
                        });
                      }
                      if (phoneNumber == 'nodata') {
                        setState(() {
                          phoneNumber =
                              userProfileDetails.value!.phoneNumber.toString();
                        });
                      }
                      try {
                        EasyLoading.show(
                            status: 'Loading...', dismissOnTap: false);
                        imagePath == 'No Data'
                            ? null
                            : await uploadFile(imagePath);
                        // ignore: no_leading_underscores_for_local_identifiers
                        final DatabaseReference _personalInformationRef =
                            FirebaseDatabase.instance
                                .ref()
                                .child(constUserId)
                                .child('Personal Information');
                        _personalInformationRef.keepSynced(true);

                        PersonalInformationModel personalInformation =
                            PersonalInformationModel(
                          businessCategory: dropdownValue,
                          companyName: companyName,
                          phoneNumber: phoneNumber,
                          countryName: initialCountry,
                          invoiceCounter: invoiceNumber,
                          language: dropdownLangValue,
                          pictureUrl: profilePicture,
                          remainingShopBalance: remainingShopBalance,
                          shopOpeningBalance: openingBalance,
                        );
                        _personalInformationRef
                            .set(personalInformation.toJson());
                        ref.refresh(profileDetailsProvider);
                        print(
                            "personal Information/// :  $profileDetailsProvider");
                        EasyLoading.showSuccess('Updated Successfully',
                            duration: const Duration(milliseconds: 1000));
                        // ignore: use_build_context_synchronously
                        Navigator.pushNamed(context, '/home');
                      } catch (e) {
                        EasyLoading.dismiss();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(e.toString()),
                          ),
                        );
                      }
                      // Navigator.pushNamed(context, '/otp');
                    },
                  ),
                ],
              ),
            );
          }, error: (e, stack) {
            return Center(
              child: Text(e.toString()),
            );
          }, loading: () {
            return Center(
                child: CircularProgressIndicator(
              color: Constants.kMainColor,
            ));
          });
        }),
      ),
    );
  }
}
