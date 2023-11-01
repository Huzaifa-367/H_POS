import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_pos/GlobalComponents/button_global.dart';
import 'package:mobile_pos/Screens/Authentication/login_form.dart';
import 'package:mobile_pos/Screens/Profile%20Screen/edit_profile.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../Provider/profile_provider.dart';
import '../../constant.dart';
import '../../model/personal_information_model.dart';
import 'package:mobile_pos/generated/l10n.dart' as lang;

class ProfileDetails extends StatefulWidget {
  const ProfileDetails({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _ProfileDetailsState createState() => _ProfileDetailsState();
}

class _ProfileDetailsState extends State<ProfileDetails> {
  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, __) {
      AsyncValue<PersonalInformationModel> userProfileDetails =
          ref.watch(profileDetailsProvider);

      return userProfileDetails.when(data: (details) {
        return Scaffold(
          appBar: AppBar(
            title: Text(
              lang.S.of(context).profile,
              style: GoogleFonts.poppins(
                color: Colors.black,
                fontSize: 20.0,
              ),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 15.0),
                child: GestureDetector(
                  onTap: () {
                    EditProfile(
                      profile: details,
                    ).launch(context);
                  },
                  child: Row(
                    children: [
                      Icon(
                        Icons.edit,
                        color: Constants.kMainColor,
                      ),
                      const SizedBox(
                        width: 5.0,
                      ),
                      Text(
                        lang.S.of(context).edit,
                        style: GoogleFonts.poppins(
                          color: Constants.kMainColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
            iconTheme: const IconThemeData(color: Colors.black),
            centerTitle: true,
            backgroundColor: Colors.white,
            elevation: 0.0,
          ),
          body: Padding(
            padding: const EdgeInsets.all(10.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Center(
                    child: Container(
                      height: 100.0,
                      width: 100.0,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                            image: NetworkImage(details.pictureUrl ?? ''),
                            fit: BoxFit.cover),
                        borderRadius: BorderRadius.circular(50),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: AppTextField(
                      readOnly: true,
                      cursorColor: Constants.kMainColor,
                      controller: TextEditingController(
                        text: details.companyName,
                      ),
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
                          labelText: lang.S.of(context).name,
                          border: const OutlineInputBorder().copyWith(
                              borderSide:
                                  const BorderSide(color: kGreyTextColor)),
                          hoverColor: kGreyTextColor,
                          fillColor: kGreyTextColor),
                      textFieldType: TextFieldType.NAME,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: AppTextField(
                      readOnly: true,
                      cursorColor: Constants.kMainColor,
                      controller: TextEditingController(
                        text: details.phoneNumber,
                      ),
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
                          labelText: lang.S.of(context).phone,
                          border: const OutlineInputBorder().copyWith(
                              borderSide:
                                  const BorderSide(color: kGreyTextColor)),
                          hoverColor: kGreyTextColor,
                          fillColor: kGreyTextColor),
                      textFieldType: TextFieldType.NAME,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: AppTextField(
                      readOnly: true,
                      cursorColor: Constants.kMainColor,
                      controller: TextEditingController(
                        text: details.businessCategory,
                      ),
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
                        labelText: lang.S.of(context).businessCat,
                        border: const OutlineInputBorder().copyWith(
                            borderSide:
                                const BorderSide(color: kGreyTextColor)),
                        hoverColor: kGreyTextColor,
                        fillColor: kGreyTextColor,
                      ),
                      textFieldType: TextFieldType.NAME,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: AppTextField(
                            readOnly: true,
                            cursorColor: Constants.kMainColor,
                            controller: TextEditingController(
                              text: details.countryName,
                            ),
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
                                labelText: lang.S.of(context).address,
                                border: const OutlineInputBorder().copyWith(
                                    borderSide: const BorderSide(
                                        color: kGreyTextColor)),
                                hoverColor: kGreyTextColor,
                                fillColor: kGreyTextColor),
                            textFieldType: TextFieldType.NAME,
                          ),
                        ),
                        const SizedBox(
                          width: 10.0,
                        ),
                        Expanded(
                          child: AppTextField(
                            readOnly: true,
                            cursorColor: Constants.kMainColor,
                            controller: TextEditingController(
                              text: details.language,
                            ),
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
                                labelText: lang.S.of(context).language,
                                border: const OutlineInputBorder().copyWith(
                                    borderSide: const BorderSide(
                                        color: kGreyTextColor)),
                                hoverColor: kGreyTextColor,
                                fillColor: kGreyTextColor),
                            textFieldType: TextFieldType.NAME,
                          ),
                        ),
                      ],
                    ),
                  ),
                  ButtonGlobal(
                    iconWidget: Icons.arrow_forward,
                    buttontext: lang.S.of(context).changePassword,
                    iconColor: Colors.white,
                    buttonDecoration:
                        kButtonDecoration.copyWith(color: Constants.kMainColor),
                    onPressed: () async {
                      try {
                        EasyLoading.show(
                            status: 'Sending Email', dismissOnTap: false);
                        await FirebaseAuth.instance.sendPasswordResetEmail(
                          email: FirebaseAuth.instance.currentUser!.email
                              .toString(),
                        );
                        EasyLoading.showSuccess('Email Sent! Check your Inbox');
                        // ignore: use_build_context_synchronously
                        const LoginForm(
                                //isEmailLogin: true,
                                )
                            .launch(context);
                        FirebaseAuth.instance.signOut();
                      } catch (e) {
                        EasyLoading.showError(e.toString());
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      }, error: (e, stack) {
        return Text(e.toString());
      }, loading: () {
        return const CircularProgressIndicator();
      });
    });
  }
}
