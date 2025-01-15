import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_pos/GlobalComponents/button_global.dart';
import 'package:mobile_pos/Screens/Authentication/phone.dart';
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
                          TextFormField(
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              suffixIconColor: Constants.kMainColor,
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
                              border: const OutlineInputBorder(),
                              labelText: lang.S.of(context).emailText,
                              hintText:
                                  lang.S.of(context).enterYourEmailAddress,
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Email can\'n be empty';
                              } else if (!value.contains('@')) {
                                return 'Please enter a valid email';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              auth.email = value!;
                            },
                          ),
                          const SizedBox(height: 20),
                          TextFormField(
                            keyboardType: TextInputType.text,
                            obscureText: showPass1,
                            decoration: InputDecoration(
                              suffixIconColor: Constants.kMainColor,
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
                              border: const OutlineInputBorder(),
                              labelText: lang.S.of(context).password,
                              hintText: lang.S.of(context).pleaseEnterAPassword,
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
                            ),
                            onChanged: (value) {
                              givenPassword = value;
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Password can\'t be empty';
                              } else if (value.length < 4) {
                                return 'Please enter a bigger password';
                              } else if (value.length < 4) {
                                return 'Please enter a bigger password';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              auth.password = value!;
                            },
                          ),
                          const SizedBox(height: 20),
                          TextFormField(
                            keyboardType: TextInputType.emailAddress,
                            obscureText: showPass2,
                            decoration: InputDecoration(
                              suffixIconColor: Constants.kMainColor,
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
                              border: const OutlineInputBorder(),
                              labelText: lang.S.of(context).confirmPass,
                              hintText: lang.S
                                  .of(context)
                                  .pleaseEnterAConfirmPassword,
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
                            ),
                            onChanged: (value) {
                              givenPassword2 = value;
                            },
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
                          ),
                        ],
                      ),
                    ),
                  ),
                  ButtonGlobalWithoutIcon(
                    buttontext: lang.S.of(context).register,
                    buttonDecoration:
                        kButtonDecoration.copyWith(color: Constants.kMainColor),
                    onPressed: () {
                      if (validateAndSave()) {
                        auth.signUp(context);
                      }
                    },
                    buttonTextColor: Colors.white,
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
