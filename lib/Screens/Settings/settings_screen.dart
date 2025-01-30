import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_pos/Screens/Profile%20Screen/profile_details.dart';
import 'package:mobile_pos/Screens/Settings/Color_Picker/color_picker.dart';
import 'package:mobile_pos/Screens/Settings/Profile_Widget.dart';
import 'package:mobile_pos/Screens/SplashScreen/splash_screen.dart';
import 'package:mobile_pos/Screens/User%20Roles/user_role_screen.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart' as pro;
import 'package:restart_app/restart_app.dart';
import '../../Provider/profile_provider.dart';
import '../../constant.dart';
import '../../currency.dart';
import '../../model/personal_information_model.dart';
import '../Currency/currency_screen.dart';
import '../Shimmers/home_screen_appbar_shimmer.dart';
import '../language/language.dart';
import '../subscription/package_screen.dart';
import 'package:mobile_pos/generated/l10n.dart' as lang;
import 'package:mobile_pos/constant.dart' as cons;

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SettingScreenState createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  String? dropdownValue = '\$ (PKR)';
  bool expanded = false;
  bool expandedHelp = false;
  bool expandedAbout = false;
  bool selected = false;

  Future<void> _signOut() async {
    await FirebaseAuth.instance.signOut();
    EasyLoading.showSuccess('Successfully Logged Out');
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    printerIsEnable();
    getCurrency();
  }

  getCurrency() async {
    final prefs = await SharedPreferences.getInstance();
    String? data = prefs.getString('currency');

    if (!data.isEmptyOrNull) {
      for (var element in items) {
        if (element.substring(0, 2).contains(data!)) {
          setState(() {
            dropdownValue = element;
          });
          break;
        }
      }
    } else {
      setState(() {
        dropdownValue = items[0];
      });
    }
  }

  void printerIsEnable() async {
    final prefs = await SharedPreferences.getInstance();

    isPrintEnable = prefs.getBool('isPrintEnable') ?? true;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Consumer(builder: (context, ref, _) {
        AsyncValue<PersonalInformationModel> userProfileDetails =
            ref.watch(profileDetailsProvider);
        // ColorProvider colorProvider = context.watch<ColorProvider>();

        return Scaffold(
          // backgroundColor: Constants().kBgColor,
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  userProfileDetails.when(data: (details) {
                    return BigUserCard(
                      userName: isSubUser
                          ? '${details.companyName ?? ''} [$subUserTitle]'
                          : details.companyName ?? '',
                      role: Text(
                        details.businessCategory ?? '',
                        style: GoogleFonts.poppins(
                          fontSize: 15.0,
                          fontWeight: FontWeight.normal,
                          color: kDarkWhite,
                        ),
                      ),
                      cardRadius: 20,
                      backgroundColor: Constants.kMainColor,
                      userProfilePic: NetworkImage(details.pictureUrl ?? ''),
                      cardActionWidget: SettingsItem(
                        onTap: () {
                          isSubUser
                              ? null
                              : const ProfileDetails().launch(context);
                        },
                        icon: Icons.person_outline_rounded,
                        iconStyle: IconStyle(
                          backgroundColor: Colors.purple,
                        ),
                        title: lang.S.of(context).profile,
                        subtitle: "Learn more about us",
                      ).visible(!isSubUser),
                    );
                  }, error: (e, stack) {
                    return Text(e.toString());
                  }, loading: () {
                    return const HomeScreenAppBarShimmer();
                  }),
                  SettingsGroup(
                    items: [
                      SettingsItem(
                        onTap: () {},
                        icon: Icons.print,
                        iconStyle: IconStyle(
                          iconsColor: Colors.white,
                          withBackground: true,
                          backgroundColor: Colors.red,
                        ),
                        title: lang.S.of(context).printing,
                        subtitle: "Do you want printing enabled?",
                        trailing: Switch.adaptive(
                          inactiveTrackColor: Constants().kBgColor,
                          inactiveThumbColor:
                              kPremiumPlanColor2.withOpacity(0.5),
                          activeColor: Constants.kMainColor,
                          trackOutlineColor:
                              WidgetStateProperty.resolveWith((states) {
                            if (states.contains(WidgetState.selected)) {
                              return Constants.kMainColor;
                            }
                            return kPremiumPlanColor2.withOpacity(0.8);
                          }),
                          value: isPrintEnable,
                          onChanged: (bool value) async {
                            final prefs = await SharedPreferences.getInstance();
                            await prefs.setBool('isPrintEnable', value);
                            setState(() {
                              isPrintEnable = value;
                            });
                          },
                        ),
                      ),
                      // SettingsItem(
                      //   onTap: () {},
                      //   icon: Icons.color_lens_rounded,
                      //   iconStyle: IconStyle(
                      //     iconsColor: Colors.white,
                      //     withBackground: true,
                      //     backgroundColor: Constants.kMainColor,
                      //   ),
                      //   title: lang.S.of(context).themecolor,
                      //   subtitle: "Select your theme?",
                      //   trailing: IconButton(
                      //       onPressed: () {
                      //         showDialog(
                      //             context: context,
                      //             builder: (BuildContext context) {
                      //               return Dialog(
                      //                 shape: RoundedRectangleBorder(
                      //                   borderRadius:
                      //                       BorderRadius.circular(12.0),
                      //                 ),
                      //                 // ignore: sized_box_for_whitespace
                      //                 child: const SizedBox(
                      //                   height: 450.0,
                      //                   child: DropDown(),
                      //                 ),
                      //               );
                      //             });
                      //       },
                      //       icon: Icon(
                      //         Icons.colorize,
                      //         color: Constants.kMainColor,
                      //       )),
                      // ),

                      //const DropDown(),

                      ///_________subscription_____________________________________________________

                      SettingsItem(
                        onTap: () {
                          const PackageScreen().launch(context);
                        },
                        icon: Icons.account_balance_wallet_outlined,
                        iconStyle: IconStyle(
                          backgroundColor: Colors.green,
                        ),
                        title: lang.S.of(context).subscription,
                        subtitle:
                            "Let us know how we can improve our applicaton",
                      ),

                      ///___________user_role___________________________________________________________

                      SettingsItem(
                        title: lang.S.of(context).userRole,
                        onTap: () {
                          const UserRoleScreen().launch(context);
                        },
                        icon: Icons.supervised_user_circle_sharp,
                        iconStyle: IconStyle(
                          backgroundColor: Colors.cyan,
                        ),
                        subtitle:
                            "Let us know how we can improve our applicaton",
                      ).visible(!isSubUser),

                      ///____________Currency________________________________________________
                      ///
                      SettingsItem(
                        title: '${lang.S.of(context).currency}: ' '$currency',
                        onTap: () async {
                          await const CurrencyScreen().launch(context);

                          setState(() {});

                          //  showCurrencyPicker(
                          //   context: context,
                          //   showFlag: true,
                          //   showCurrencyName: true,
                          //   showCurrencyCode: true,
                          //   onSelect: (Currency c) async {
                          //     final prefs = await SharedPreferences.getInstance();
                          //     await prefs.setString('currency', c.symbol);
                          //     await prefs.setString('currencyName', c.name);
                          //     setState(() {
                          //       currency = c.symbol;
                          //       currencyName = c.name;
                          //     });
                          //   },
                          // );
                        },
                        icon: Icons.currency_exchange,
                        iconStyle: IconStyle(
                          backgroundColor: Colors.amber,
                        ),
                        subtitle:
                            "Let us know how we can improve our applicaton",
                      ),

                      ///___________________language__________________________________________________________

                      SettingsItem(
                        title: lang.S.of(context).selectLang,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SelectLanguage(),
                          ),
                        ),
                        icon: Icons.language_rounded,
                        iconStyle: IconStyle(
                          backgroundColor: Colors.blue,
                        ),
                        subtitle:
                            "Let us know how we can improve our applicaton",
                      ),

                      ///__________log_Out_______________________________________________________________

                      SettingsItem(
                        title: lang.S.of(context).logOut,
                        onTap: () async {
                          EasyLoading.show(status: 'Log out');
                          await _signOut();
                          Future.delayed(const Duration(milliseconds: 1000),
                              () async {
                            ///________subUser_logout___________________________________________________
                            final prefs = await SharedPreferences.getInstance();
                            await prefs.setBool('isSubUser', false);
                            Future.delayed(const Duration(milliseconds: 1000),
                                () {
                              if ((Theme.of(context).platform ==
                                  TargetPlatform.android)) {
                                Restart.restartApp();
                              } else {
                                const SplashScreen()
                                    .launch(context, isNewTask: true);
                              }

                              // const SignInScreen().launch(context);
                            });
                            // Phoenix.rebirth(context);
                          });
                        },
                        icon: Icons.logout,
                        iconStyle: IconStyle(
                          backgroundColor: Colors.red,
                        ),
                        subtitle:
                            "Let us know how we can improve our applicaton",
                      ),
                    ],
                  ),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        '$appName V-$appVersion',
                        style: GoogleFonts.poppins(
                          color: kGreyTextColor,
                          fontSize: 16.0,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}

class NoticationSettings extends StatefulWidget {
  const NoticationSettings({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _NoticationSettingsState createState() => _NoticationSettingsState();
}

class _NoticationSettingsState extends State<NoticationSettings> {
  bool notify = false;
  String notificationText = 'Off';

  @override
  Widget build(BuildContext context) {
    // ignore: sized_box_for_whitespace

    return SizedBox(
      height: 350.0,
      width: MediaQuery.of(context).size.width - 80,
      child: Column(
        children: [
          Row(
            children: [
              const Spacer(),
              IconButton(
                color: kGreyTextColor,
                icon: const Icon(Icons.cancel_outlined),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
          Container(
            height: 100.0,
            width: 100.0,
            decoration: BoxDecoration(
              color: kDarkWhite,
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Center(
              child: Icon(
                Icons.notifications_none_outlined,
                size: 50.0,
                color: Constants.kMainColor,
              ),
            ),
          ),
          const SizedBox(
            height: 20.0,
          ),
          Center(
            child: Text(
              'Do Not Disturb',
              style: GoogleFonts.poppins(
                color: Colors.black,
                fontSize: 20.0,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Lorem ipsum dolor sit amet, consectetur elit. Interdum cons.',
                maxLines: 2,
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  color: kGreyTextColor,
                  fontSize: 16.0,
                ),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                notificationText,
                style: GoogleFonts.poppins(
                  color: Colors.black,
                  fontSize: 16.0,
                ),
              ),
              Switch(
                value: notify,
                onChanged: (val) {
                  setState(() {
                    notify = val;
                    val ? notificationText = 'On' : notificationText = 'Off';
                  });
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// class DropDown extends StatefulWidget {
//   const DropDown({super.key});

//   @override
//   State<DropDown> createState() => _DropDownState();
// }

// class _DropDownState extends State<DropDown> {
//   // Initialize selectedcolor here
//   @override
//   void initState() {
//     super.initState();
//   }

//   final _colorNotifier = ValueNotifier<Color>(Colors.green);

//   @override
//   Widget build(BuildContext context) {
//     final colorProvider = context.read<ColorProvider>();
//     return Column(
//       children: [
//         Center(
//           child: Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
//             child: ValueListenableBuilder<Color>(
//               valueListenable: _colorNotifier,
//               builder: (_, color, __) {
//                 return ColorPicker(
//                   initialPicker: Picker.hsv,
//                   color: Constants.kMainColor,
//                   onChanged: (value) async {
//                     color = value;
//                     newColor = value;
//                     colorProvider.setSelectedColor(value);
//                     //     // Save the selected color in SharedPreferences
//                   },
//                 );
//               },
//             ),
//           ),
//         ),
//         // DropdownButton<String>(
//         //   underline: Container(
//         //     height: 1.5,
//         //     color: Constants.kMainColor,
//         //   ),
//         //   iconEnabledColor: Constants.kMainColor,
//         //   value: selectedcolor,
//         //   onChanged: (value) async {
//         //     setState(() {
//         //       selectedcolor = value!; // Update the selectedcolor variable
//         //     });
//         //     colorProvider.setSelectedColor(value!);

//         //     // Save the selected color in SharedPreferences
//         //     SharedPreferences prefs = await SharedPreferences.getInstance();
//         //     prefs.setString('selectedColor', value);
//         //   },
//         //   items: ['Light Green', 'Sky Blue', 'Orange', 'Purple', 'Pink']
//         //       .map((color) {
//         //     return DropdownMenuItem<String>(
//         //       value: color,
//         //       child: Text(color),
//         //     );
//         //   }).toList(),
//         // ),

//         //
//       ],
//     );
//   }
// }
