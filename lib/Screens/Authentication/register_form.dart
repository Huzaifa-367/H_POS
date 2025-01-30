import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_pos/GlobalComponents/button_global.dart';
import 'package:mobile_pos/GlobalComponents/core_widgets.dart';
import 'package:mobile_pos/Screens/Authentication/phone.dart';
import 'package:mobile_pos/Utils/validation_rules.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../constant.dart';
import '../../repository/signup_repo.dart';
import 'login_form.dart';
import 'package:mobile_pos/generated/l10n.dart' as lang;

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool showPass1 = true;
  bool showPass2 = true;
  GlobalKey<FormState> globalKey = GlobalKey<FormState>();
  bool passwordShow = false;
  String? givenPassword;
  String? givenPassword2;

  bool validateAndSave() {
    final form = globalKey.currentState;
    if (form!.validate() && givenPassword == givenPassword2) {
      form.save();
      return true;
    }
    return false;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Consumer(builder: (context, ref, child) {
          final auth = ref.watch(signUpProvider);
          return Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('images/logoandname.png'),
                  const SizedBox(
                    height: 30.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Form(
                      key: globalKey,
                      child: Column(
                        children: [
                          const SizedBox(height: 20),
                          CustomTextFormField(
                            hintText: lang.S.of(context).enterYourEmailAddress,
                            validator: (p0) => ValidationRules().email(p0),
                            onChanged: (p0) {
                              setState(() {
                                auth.email = p0;
                              });
                            },
                          ),
                          const SizedBox(height: 20),
                          CustomTextFormField(
                            hintText: lang.S.of(context).password,
                            validator: (p0) => ValidationRules().normal(p0),
                            isPasswordTextField: showPass1,
                            suffixIconConstraints:
                                BoxConstraints(minWidth: 23, minHeight: 23),
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  showPass1 = !showPass1;
                                });
                              },
                              icon: Icon(
                                showPass1
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                color: Constants.kMainColor,
                              ),
                            ),
                            onChanged: (p0) {
                              setState(() {
                                givenPassword = p0;
                                auth.password = p0;
                              });
                            },
                          ),
                          const SizedBox(height: 20),
                          CustomTextFormField(
                            hintText: lang.S.of(context).password,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Password can\'t be empty';
                              } else if (value.length < 4) {
                                return 'Please enter a bigger password';
                              } else if (givenPassword != givenPassword2) {
                                return 'Password Not mach';
                              }
                              return null;
                            },
                            isPasswordTextField: showPass2,
                            suffixIconConstraints:
                                BoxConstraints(minWidth: 23, minHeight: 23),
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  showPass2 = !showPass2;
                                });
                              },
                              icon: Icon(
                                showPass2
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                color: Constants.kMainColor,
                              ),
                            ),
                            onChanged: (p0) {
                              setState(() {
                                givenPassword2 = p0;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  CustomStretchedTextButtonWidget(
                    buttonText: lang.S.of(context).register,
                    onTap: () {
                      if (validateAndSave()) {
                        auth.signUp(context);
                      }
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        lang.S.of(context).haveAcc,
                        style: GoogleFonts.poppins(
                            color: kGreyTextColor, fontSize: 15.0),
                      ),
                      TextButton(
                        onPressed: () {
                          const LoginForm(
                                  //isEmailLogin: true,
                                  )
                              .launch(context);
                          // Navigator.pushNamed(context, '/loginForm');
                        },
                        child: Text(
                          lang.S.of(context).logIn,
                          style: GoogleFonts.poppins(
                            color: Constants.kMainColor,
                            fontSize: 15.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  // TextButton(
                  //   onPressed: () {
                  //     const PhoneAuth().launch(context);
                  //   },
                  //   child: Text(lang.S.of(context).loginWithPhone),
                  // ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
