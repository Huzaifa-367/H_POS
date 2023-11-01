// ignore_for_file: file_names

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:mobile_pos/Screens/Authentication/phone.dart';
import 'package:mobile_pos/Screens/Authentication/profile_setup.dart';
import 'package:mobile_pos/Screens/Authentication/success_screen.dart';
import 'package:mobile_pos/constant.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:pinput/pinput.dart';
import 'package:mobile_pos/generated/l10n.dart' as lang;

class OTPVerify extends StatefulWidget {
  const OTPVerify({Key? key}) : super(key: key);

  @override
  State<OTPVerify> createState() => _OTPVerifyState();
}

class _OTPVerifyState extends State<OTPVerify> {
  FirebaseAuth auth = FirebaseAuth.instance;

  String code = '';
  final CurrentUserData currentUserData = CurrentUserData();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios_rounded,
            color: Colors.black,
          ),
        ),
        elevation: 0,
      ),
      body: Container(
        margin: const EdgeInsets.only(left: 25, right: 25),
        alignment: Alignment.center,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('images/logoandname.png'),
              const SizedBox(height: 25),
              Text(
                lang.S.of(context).phoneVerification,
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Text(
                lang.S.of(context).registerTitle,
                style: const TextStyle(
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              Pinput(
                  length: 6,
                  showCursor: true,
                  onCompleted: (pin) {
                    code = pin;
                  }),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 45,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Constants.kMainColor, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                    onPressed: () async {
                      EasyLoading.show(status: 'Loading');
                      try {
                        PhoneAuthCredential credential = PhoneAuthProvider.credential(verificationId: PhoneAuth.verify, smsCode: code);
                        await auth.signInWithCredential(credential).then((value) {
                          if (value.additionalUserInfo!.isNewUser) {
                            EasyLoading.dismiss();

                            const ProfileSetup(
                              loginWithPhone: true,
                            ).launch(context);
                          } else {
                            EasyLoading.dismiss();
                            SuccessScreen(
                              email: 'phone',
                            ).launch(context);
                          }
                        });
                      } catch (e) {
                        EasyLoading.showError('Wrong OTP');
                      }
                    },
                    child: const Text("Verify Phone Number")),
              ),
              Row(
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        'phone',
                        (route) => false,
                      );
                    },
                    child: Text(
                      lang.S.of(context).editPhone,
                      style: const TextStyle(color: Colors.black),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
