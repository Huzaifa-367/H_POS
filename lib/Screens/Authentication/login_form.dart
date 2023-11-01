import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_pos/GlobalComponents/button_global.dart';
import 'package:mobile_pos/Screens/Authentication/register_form.dart';
import 'package:mobile_pos/repository/login_repo.dart';
import 'package:nb_utils/nb_utils.dart';
import '../../constant.dart';
import 'forgot_password.dart';
import 'package:mobile_pos/generated/l10n.dart' as lang;

class LoginForm extends StatefulWidget {
  const LoginForm({
    Key? key,
    //required this.isEmailLogin,
  }) : super(key: key);

  //final bool isEmailLogin;

  @override
  // ignore: library_private_types_in_public_api
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  bool showPassword = true;
  late String email, password;
  GlobalKey<FormState> globalKey = GlobalKey<FormState>();

  bool validateAndSave() {
    final form = globalKey.currentState;
    if (form!.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  bool isEmailLogin = true;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Consumer(builder: (context, ref, child) {
          final loginProvider = ref.watch(logInProvider);
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
                              loginProvider.email = value!;
                            },
                          ),
                          const SizedBox(height: 20),
                          TextFormField(
                            keyboardType: TextInputType.text,
                            obscureText: showPassword,
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
                              labelText: lang.S.of(context).password,
                              hintText: lang.S.of(context).pleaseEnterAPassword,
                              suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    showPassword = !showPassword;
                                  });
                                },
                                icon: Icon(
                                  showPassword
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                  color: Constants.kMainColor,
                                ),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Password can\'t be empty';
                              } else if (value.length < 4) {
                                return 'Please enter a bigger password';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              loginProvider.password = value!;
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      const Spacer(),
                      TextButton(
                        onPressed: () {
                          const ForgotPassword().launch(context);
                          // Navigator.pushNamed(context, '/forgotPassword');
                        },
                        child: Text(
                          lang.S.of(context).forgotPassword,
                          style: GoogleFonts.poppins(
                            color: kGreyTextColor,
                            fontSize: 15.0,
                          ),
                        ),
                      ),
                    ],
                  ).visible(isEmailLogin),
                  ButtonGlobalWithoutIcon(
                      buttontext: lang.S.of(context).logIn,
                      buttonDecoration:
                          kButtonDecoration.copyWith(color: Constants.kMainColor),
                      onPressed: () {
                        if (validateAndSave()) {
                          loginProvider.signIn(context);
                        }
                      },
                      buttonTextColor: Colors.white),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      TextButton(
                        onPressed: () {
                          setState(() {
                            isEmailLogin = false;
                          });
                          //const LoginForm(isEmailLogin: false).launch(context);
                        },
                        child: Text(
                          lang.S.of(context).staffLogin,
                          style: GoogleFonts.poppins(
                            color: Constants.kMainColor,
                            fontSize: 15.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      // Text(
                      //   lang.S.of(context).noAcc,
                      //   style: GoogleFonts.poppins(
                      //       color: kGreyTextColor, fontSize: 15.0),
                      // ),
                      TextButton(
                        onPressed: () {
                          // Navigator.pushNamed(context, '/signup');
                          const RegisterScreen().launch(context);
                        },
                        child: Text(
                          lang.S.of(context).register,
                          style: GoogleFonts.poppins(
                            color: Constants.kMainColor,
                            fontSize: 15.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ).visible(isEmailLogin),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
