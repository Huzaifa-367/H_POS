// ignore_for_file: use_build_context_synchronously
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:mobile_pos/Screens/Authentication/login_form.dart';
import 'package:mobile_pos/Screens/SplashScreen/on_board.dart';
import 'package:mobile_pos/constant.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:mobile_pos/generated/l10n.dart' as lang;
import '../../GlobalComponents/license_verifier.dart';
import '../../currency.dart';
import '../../repository/subscription_repo.dart';
import '../Home/home.dart';
import '../language/language_provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  String newUpdateVersion = '1.1';

  bool isUpdateAvailable = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  void showSnack(String text) {
    if (_scaffoldKey.currentContext != null) {
      ScaffoldMessenger.of(_scaffoldKey.currentContext!)
          .showSnackBar(SnackBar(content: Text(text)));
    }
  }

  void getPermission() async {
    // ignore: unused_local_variable
    Map<Permission, PermissionStatus> statuses = await [
      Permission.bluetoothScan,
      Permission.bluetoothConnect,
    ].request();
  }

  final CurrentUserData currentUserData = CurrentUserData();

  // Future<void> getSubUserData() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   isSubUser = prefs.getBool('isSubUser') ?? false;
  //   isSubUser ? currentUserData.getUserData() : null;
  // }

  @override
  void initState() {
    super.initState();
    init();
    getPermission();
    getCurrency();
    currentUserData.getUserData();
  }

  getCurrency() async {
    final prefs = await SharedPreferences.getInstance();
    currency = prefs.getString('currency') ?? '\$';
    currencyName = prefs.getString('currencyName') ?? 'United States Dollar';
  }

  var currentUser = FirebaseAuth.instance.currentUser;

  // bool isis = FirebaseAuth.instance.currentUser

  void setLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    String selectedLanguage = prefs.getString('lang') ?? 'English';
    selectedLanguage == 'English'
        ? context.read<LanguageChangeProvider>().changeLocale("en")
        : selectedLanguage == 'Hindi'
            ? context.read<LanguageChangeProvider>().changeLocale("hi")
            : selectedLanguage == 'Urdu'
                ? context.read<LanguageChangeProvider>().changeLocale("ur")
                : context.read<LanguageChangeProvider>().changeLocale("en");
  }

  void init() async {
    setLanguage();
    //final prefs = await SharedPreferences.getInstance();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    isPrintEnable = prefs.getBool('isPrintEnable') ?? true;
    //////////
    ///
    ///
    String? colorValue = prefs.getString('selectedColor');

    if (colorValue != null) {
      String hexColor = colorValue.replaceAll('Color(', '').replaceAll(')', '');
      print("Color Value: $colorValue");

      ///Color(0xff32c331)
      print("HexValue: $hexColor");
      setState(() {
        Constants.kMainColor = Color(int.parse(hexColor));
      });

      //setState(() {});
      context
          .read<ColorProvider>()
          .setSelectedColor(Color(int.parse(hexColor)));
    }

    final String? skipVersion = prefs.getString('skipVersion');
    bool result = await InternetConnectionChecker().hasConnection;
    if (result) {
      bool isValid = await PurchaseModel().isActiveBuyer();
      if (isValid) {
        await Future.delayed(const Duration(seconds: 2), () {
          if (isUpdateAvailable &&
              (skipVersion == null || skipVersion != newUpdateVersion)) {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: Center(
                    child: Container(
                      height: MediaQuery.of(context).size.height / 2,
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(30)),
                      ),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 20, bottom: 10),
                                  child: Text(
                                    lang.S.of(context).anewUpdateAvailable,
                                    style: const TextStyle(
                                      fontSize: 20,
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 30,
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: GestureDetector(
                                    onTap: () async {
                                      await prefs.remove('skipVersion');
                                    },
                                    child: Container(
                                      height: 50,
                                      decoration: BoxDecoration(
                                        color: Constants.kMainColor,
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(20)),
                                      ),
                                      child: Center(
                                          child: Text(
                                        lang.S.of(context).updateNow,
                                        style: const TextStyle(
                                            color: Colors.white),
                                      )),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: GestureDetector(
                                    onTap: () async {
                                      await prefs.setBool(
                                          'isSkipUpdate', false);
                                      await prefs.setString(
                                          'skipVersion', newUpdateVersion);

                                      if (currentUser != null) {
                                        const Home().launch(context);
                                      } else {
                                        const LoginForm().launch(context);
                                      }
                                    },
                                    child: Container(
                                      height: 50,
                                      decoration: BoxDecoration(
                                        color: Constants.kMainColor,
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(20)),
                                      ),
                                      child: Center(
                                          child: Text(
                                        lang.S.of(context).skipTheUpdate,
                                        style: const TextStyle(
                                            color: Colors.white),
                                      )),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: GestureDetector(
                                    onTap: () {
                                      if (currentUser != null) {
                                        const Home().launch(context);
                                      } else {
                                        const LoginForm().launch(context);
                                      }
                                    },
                                    child: Container(
                                      height: 50,
                                      decoration: BoxDecoration(
                                        color: Constants.kMainColor,
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(20)),
                                      ),
                                      child: Center(
                                          child: Text(
                                        lang.S.of(context).rememberMeLater,
                                        style: const TextStyle(
                                            color: Colors.white),
                                      )),
                                    ),
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
              },
            );
            // const RedeemConfirmationScreen().launch(context);
          } else {
            if (currentUser != null) {
              const Home().launch(context);
            } else {
              const LoginForm().launch(context);
            }
          }
        });
      } else {
        showLicense(context: context);
      }
    } else {
      await Future.delayed(const Duration(seconds: 2), () {
        if (isUpdateAvailable &&
            (skipVersion == null || skipVersion != newUpdateVersion)) {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return Padding(
                padding: const EdgeInsets.all(30.0),
                child: Center(
                  child: Container(
                    height: MediaQuery.of(context).size.height / 2,
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                    ),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 20, bottom: 10),
                                child: Text(
                                  lang.S.of(context).anewUpdateAvailable,
                                  style: const TextStyle(
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 30,
                              ),
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: GestureDetector(
                                  onTap: () async {
                                    await prefs.remove('skipVersion');
                                  },
                                  child: Container(
                                    height: 50,
                                    decoration: BoxDecoration(
                                      color: Constants.kMainColor,
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(20)),
                                    ),
                                    child: Center(
                                        child: Text(
                                      lang.S.of(context).updateNow,
                                      style:
                                          const TextStyle(color: Colors.white),
                                    )),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: GestureDetector(
                                  onTap: () async {
                                    await prefs.setBool('isSkipUpdate', false);
                                    await prefs.setString(
                                        'skipVersion', newUpdateVersion);

                                    if (currentUser != null) {
                                      const Home().launch(context);
                                    } else {
                                      const LoginForm().launch(context);
                                    }
                                  },
                                  child: Container(
                                    height: 50,
                                    decoration: BoxDecoration(
                                      color: Constants.kMainColor,
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(20)),
                                    ),
                                    child: Center(
                                        child: Text(
                                      lang.S.of(context).skipTheUpdate,
                                      style:
                                          const TextStyle(color: Colors.white),
                                    )),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: GestureDetector(
                                  onTap: () {
                                    if (currentUser != null) {
                                      const Home().launch(context);
                                    } else {
                                      const LoginForm().launch(context);
                                    }
                                  },
                                  child: Container(
                                    height: 50,
                                    decoration: BoxDecoration(
                                      color: Constants.kMainColor,
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(20)),
                                    ),
                                    child: Center(
                                        child: Text(
                                      lang.S.of(context).rememberMeLater,
                                      style:
                                          const TextStyle(color: Colors.white),
                                    )),
                                  ),
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
            },
          );
          // const RedeemConfirmationScreen().launch(context);
        } else {
          if (currentUser != null) {
            const Home().launch(context);
          } else {
            const LoginForm().launch(context);
          }
        }
      });
    }

    defaultBlurRadius = 10.0;
    defaultSpreadRadius = 0.5;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Constants.kMainColor,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: context.height() / 4,
            ),
            const Image(
              image: AssetImage('images/SplashLogo.png'),
            ),
            const Spacer(),
            Column(
              children: [
                Center(
                  child: Text(
                    lang.S.of(context).developedBy,
                    style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontWeight: FontWeight.normal,
                        fontSize: 20.0),
                  ),
                ),
                Center(
                  child: Text(
                    'V $appVersion',
                    style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontWeight: FontWeight.normal,
                        fontSize: 15.0),
                  ),
                ),
                const SizedBox(height: 10),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
