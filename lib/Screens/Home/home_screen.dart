import 'dart:convert';
import 'dart:ffi';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_pos/Provider/Report_Click_Provider.dart';
import 'package:mobile_pos/Screens/Home/components/grid_items.dart';
import 'package:mobile_pos/Screens/Loss_Profit/loss_profit_screen.dart';
import 'package:mobile_pos/Screens/Profile%20Screen/profile_details.dart';
import 'package:mobile_pos/Screens/Report/Screens/due_report_screen.dart';
import 'package:mobile_pos/Screens/Report/Screens/purchase_report.dart';
import 'package:mobile_pos/Screens/Report/Screens/sales_report_screen.dart';
import 'package:mobile_pos/Screens/Report/reports.dart';
import 'package:mobile_pos/Screens/Settings/Profile_Widget.dart';
import 'package:mobile_pos/Screens/stock_list/stock_list.dart';
import 'package:mobile_pos/Screens/subscription/purchase_premium_plan_screen.dart';
import 'package:mobile_pos/constant.dart';
import 'package:mobile_pos/model/subscription_model.dart';
import 'package:mobile_pos/model/subscription_plan_model.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart' as pro;
// import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../../Provider/homepage_image_provider.dart';
import '../../Provider/profile_provider.dart';
import '../../model/paypal_info_model.dart';
import '../../subscription.dart';
import '../Shimmers/home_screen_appbar_shimmer.dart';
import '../subscription/package_screen.dart';
import 'package:mobile_pos/generated/l10n.dart' as lang;

import '../../Provider/user_role_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

GlobalKey listKey = GlobalKey();
GlobalKey buttonKey = GlobalKey();

class _HomeScreenState extends State<HomeScreen> {
  List<Color> color = [
    const Color(0xffEDFAFF),
    const Color(0xffFFF6ED),
    const Color(0xffEAFFEA),
    const Color(0xffEAFFEA),
    const Color(0xffEDFAFF),
    const Color(0xffFFF6ED),
    const Color(0xffFFF6ED),
    const Color(0xffEAFFEA),
    const Color(0xffEDFAFF),
    const Color(0xffEAFFEA),
    const Color(0xffFFF6ED),
  ];

  String customerPackage = '';
  List<Map<String, dynamic>> sliderList = [
    {
      "icon": 'images/banner1.png',
    },
    {
      "icon": 'images/banner2.png',
    }
  ];
  PageController pageController = PageController(initialPage: 0);

  void subscriptionRemainder() async {
    final prefs = await SharedPreferences.getInstance();

    DatabaseReference ref =
        FirebaseDatabase.instance.ref('$constUserId/Subscription');

    final model = await ref.get();
    var data = jsonDecode(jsonEncode(model.value));
    final dataModel = SubscriptionModel.fromJson(data);
    setState(() {
      customerPackage = dataModel.subscriptionName;
    });

    final remainTime =
        DateTime.parse(dataModel.subscriptionDate).difference(DateTime.now());

    if (dataModel.subscriptionName != 'Lifetime') {
      if (remainTime.inHours
          .abs()
          .isBetween((dataModel.duration * 24) - 24, dataModel.duration * 24)) {
        await prefs.setBool('isFiveDayRemainderShown', false);
        setState(() {
          isExpiringInOneDays = true;
          isExpiringInFiveDays = false;
        });
      } else if (remainTime.inHours.abs().isBetween(
          (dataModel.duration * 24) - 120, dataModel.duration * 24)) {
        setState(() {
          isExpiringInFiveDays = true;
          isExpiringInOneDays = false;
        });
      }

      final bool? isFiveDayRemainderShown =
          prefs.getBool('isFiveDayRemainderShown');

      if (isExpiringInFiveDays && isFiveDayRemainderShown == false) {
        // ignore: use_build_context_synchronously
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return Dialog(
              child: SizedBox(
                height: 200,
                width: 200,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      lang.S.of(context).yourPackageExpiredInDays,
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 20),
                    TextButton(
                      onPressed: () async {
                        await prefs.setBool('isFiveDayRemainderShown', true);
                        // ignore: use_build_context_synchronously
                        Navigator.pop(context);
                      },
                      child: Text(
                        lang.S.of(context).cancel,
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }
      if (isExpiringInOneDays) {
        // ignore: use_build_context_synchronously
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return Dialog(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: SizedBox(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        lang.S.of(context).yourPackageExpiredToday,
                        style: const TextStyle(fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),
                      Column(
                        children: [
                          TextButton(
                            onPressed: () {
                              const PackageScreen().launch(context);
                            },
                            child: Text(lang.S.of(context).purchase),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text(
                              lang.S.of(context).cancel,
                              style: const TextStyle(color: Colors.red),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      }
    }
  }

  Future<void> getPaypalInfo() async {
    DatabaseReference paypalRef =
        FirebaseDatabase.instance.ref('Admin Panel/Paypal Info');
    final paypalData = await paypalRef.get();
    PaypalInfoModel paypalInfoModel =
        PaypalInfoModel.fromJson(jsonDecode(jsonEncode(paypalData.value)));

    paypalClientId = paypalInfoModel.paypalClientId;
    paypalClientSecret = paypalInfoModel.paypalClientSecret;
  }

  Future<void> getAllSubscriptionPlan() async {
    final ref = FirebaseDatabase.instance
        .ref()
        .child('Admin Panel')
        .child('Subscription Plan');
    ref.keepSynced(true);

    ref.orderByKey().get().then((value) {
      for (var element in value.children) {
        Subscription.subscriptionPlan.add(SubscriptionPlanModel.fromJson(
            jsonDecode(jsonEncode(element.value))));
      }
    });
    for (var element in Subscription.subscriptionPlan) {
      if (element.subscriptionName == 'Free') {
        Subscription.freeSubscriptionModel.products = element.products;
        Subscription.freeSubscriptionModel.duration = element.duration;
        Subscription.freeSubscriptionModel.dueNumber = element.dueNumber;
        Subscription.freeSubscriptionModel.partiesNumber =
            element.partiesNumber;
        Subscription.freeSubscriptionModel.purchaseNumber =
            element.purchaseNumber;
        Subscription.freeSubscriptionModel.saleNumber = element.purchaseNumber;
        Subscription.freeSubscriptionModel.subscriptionDate =
            DateTime.now().toString();
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    subscriptionRemainder();
    getPaypalInfo();
    getAllSubscriptionPlan();
  }

  final CurrentUserData currentUserData = CurrentUserData();
  @override
  Widget build(BuildContext context) {
    // print('UserId: $constUserId');
    // print('UserId: ${FirebaseAuth.instance.currentUser!.uid}');
    freeIcons = getFreeIcons(context: context);
    ScrollController ctr = ScrollController();

    return SafeArea(
      child: Consumer(
        builder: (_, ref, __) {
          final userProfileDetails = ref.watch(profileDetailsProvider);
          final homePageImageProvider = ref.watch(homepageImageProvider);
          final userRoleData = ref.watch(allUserRoleProvider);
          //final isReportVisibleProvide = ref.watch(isReportVisibleProvider);

          return userRoleData.when(
            data: (data) {
              if (loggedinUserEmail == 'phone') {
                currentUserData.putUserData(
                    userId: FirebaseAuth.instance.currentUser!.uid,
                    isSubUser: false,
                    title: '',
                    email: '');
              } else {
                currentUserData.putUserData(
                    userId: FirebaseAuth.instance.currentUser!.uid,
                    isSubUser: false,
                    title: '',
                    email: '');
                for (var element in data) {
                  if (element.email == loggedinUserEmail) {
                    currentUserData.putUserData(
                        userId: element.databaseId,
                        isSubUser: true,
                        title: element.userTitle,
                        email: element.email);
                    subUserTitle = element.userTitle;
                  }
                }
              }
              return Scaffold(
                resizeToAvoidBottomInset: true,
                body: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: userProfileDetails.when(
                          data: (details) {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      isSubUser
                                          ? null
                                          : const ProfileDetails()
                                              .launch(context);
                                    },
                                    child: Container(
                                      height: 50,
                                      width: 50,
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                            image: NetworkImage(
                                                details.pictureUrl ?? ''),
                                            fit: BoxFit.cover),
                                        borderRadius: BorderRadius.circular(50),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 15.0,
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        isSubUser
                                            ? '${details.companyName ?? ''} [$subUserTitle]'
                                            : details.companyName ?? '',
                                        style: GoogleFonts.poppins(
                                          fontSize: 20.0,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black,
                                        ),
                                      ),
                                      Text(
                                        '$customerPackage Plan',
                                        style: GoogleFonts.poppins(
                                          color: Colors.black,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const Spacer(),
                                  // Container(
                                  //   height: 40.0,
                                  //   width: 86.0,
                                  //   decoration: BoxDecoration(
                                  //     borderRadius: BorderRadius.circular(10.0),
                                  //     color: Color(0xFFD9DDE3).withOpacity(0.5),
                                  //   ),
                                  //   child: Center(
                                  //     child: Text(
                                  //       '$currency 450',
                                  //       style: GoogleFonts.poppins(
                                  //         fontSize: 20.0,
                                  //         color: Colors.black,
                                  //       ),
                                  //     ),
                                  //   ),
                                  // ),
                                  // SizedBox(
                                  //   width: 10.0,
                                  // ),
                                  Container(
                                    height: 40.0,
                                    width: 40.0,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10.0),
                                      color: Constants().kBgColor,
                                    ),
                                    child: Center(
                                      child: GestureDetector(
                                        onTap: () {
                                          EasyLoading.showInfo('Coming Soon');
                                        },
                                        child: Icon(
                                          Icons.notifications_active,
                                          color: Constants.kMainColor,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                          error: (e, stack) {
                            return Text(e.toString());
                          },
                          loading: () {
                            return const HomeScreenAppBarShimmer();
                          },
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(10.0),
                        child: GridView.count(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          childAspectRatio: 1,
                          crossAxisSpacing: 5,
                          mainAxisSpacing: 10,
                          crossAxisCount: 3,
                          children: List.generate(
                            freeIcons.length,
                            (index) => HomeGridCards(
                              gridItems: freeIcons[index],
                              color: color[index],
                            ),
                          ),
                        ),
                      ),
                      //const SizedBox(height: 0),

                      context.watch<VisibilityProvider>().isReportVisible ==
                              true
                          ? SizedBox(
                              key: listKey,
                              width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.height * 0.55,
                              child: Reports(
                                isFromHome: true,
                              ),
                            )
                          : const SizedBox.shrink(),

                      // Container(
                      //     height: 1,
                      //     width: double.infinity,
                      //     color: Constants().kBgColor),
                      // const SizedBox(height: 10),

                      /// --------------------   Advertise Banners      ----------------

                      // SizedBox(
                      //   child: homePageImageProvider.when(
                      //     data: (images) {
                      //       if (images.isNotEmpty) {
                      //         return SizedBox(
                      //           width: double.infinity,
                      //           child: Column(
                      //             crossAxisAlignment: CrossAxisAlignment.center,
                      //             children: [
                      //               Text(
                      //                 lang.S.of(context).whatNew,
                      //                 textAlign: TextAlign.start,
                      //                 style: GoogleFonts.poppins(
                      //                   color: Colors.black,
                      //                   fontWeight: FontWeight.bold,
                      //                   fontSize: 20.0,
                      //                 ),
                      //               ),
                      //               Row(
                      //                 mainAxisAlignment:
                      //                     MainAxisAlignment.spaceAround,
                      //                 children: [
                      //                   Stack(
                      //                     children: [
                      //                       Container(
                      //                         padding:
                      //                             const EdgeInsets.symmetric(
                      //                           vertical: 10,
                      //                           horizontal: 5,
                      //                         ),
                      //                         height: 180,
                      //                         width: MediaQuery.of(context)
                      //                             .size
                      //                             .width,
                      //                         child: PageView.builder(
                      //                           pageSnapping: true,
                      //                           itemCount: images.length,
                      //                           controller: pageController,
                      //                           itemBuilder: (_, index) {
                      //                             if (images[index]
                      //                                 .imageUrl
                      //                                 .contains(
                      //                                     'https://firebasestorage.googleapis.com')) {
                      //                               return GestureDetector(
                      //                                 onTap: () {
                      //                                   const PackageScreen()
                      //                                       .launch(context);
                      //                                 },
                      //                                 child: ClipRRect(
                      //                                   borderRadius:
                      //                                       BorderRadius
                      //                                           .circular(10),
                      //                                   child: Image(
                      //                                     image: NetworkImage(
                      //                                       images[index]
                      //                                           .imageUrl,
                      //                                     ),
                      //                                     fit: BoxFit.fill,
                      //                                   ),
                      //                                 ),
                      //                               );
                      //                             }
                      //                             return null;
                      //                             //  else {
                      //                             //   YoutubePlayerController
                      //                             //       videoController =
                      //                             //       YoutubePlayerController(
                      //                             //     flags:
                      //                             //         const YoutubePlayerFlags(
                      //                             //       autoPlay: false,
                      //                             //       mute: false,
                      //                             //     ),
                      //                             //     initialVideoId:
                      //                             //         images[index]
                      //                             //             .imageUrl,
                      //                             //   );
                      //                             //   return ClipRRect(
                      //                             //     borderRadius:
                      //                             //         BorderRadius.circular(
                      //                             //             10),
                      //                             //     child: YoutubePlayer(
                      //                             //       controller:
                      //                             //           videoController,
                      //                             //       showVideoProgressIndicator:
                      //                             //           true,
                      //                             //       onReady: () {},
                      //                             //     ),
                      //                             //   );
                      //                             // }
                      //                           },
                      //                         ),
                      //                       ),
                      //                       Positioned(
                      //                         top: 75,
                      //                         left: 10,
                      //                         child: GestureDetector(
                      //                           child: Container(
                      //                             decoration: BoxDecoration(
                      //                               color: kDarkWhite
                      //                                   .withOpacity(0.8),
                      //                               borderRadius:
                      //                                   BorderRadius.circular(
                      //                                       50),
                      //                             ),
                      //                             height: 40,
                      //                             width: 40,
                      //                             child: Icon(
                      //                               Icons.keyboard_arrow_left,
                      //                               color: Constants.kMainColor,
                      //                             ),
                      //                           ),
                      //                           onTap: () {
                      //                             pageController.previousPage(
                      //                                 duration: const Duration(
                      //                                     milliseconds: 300),
                      //                                 curve: Curves.linear);
                      //                           },
                      //                         ),
                      //                       ),
                      //                       Positioned(
                      //                         top: 75,
                      //                         right: 10,
                      //                         child: GestureDetector(
                      //                           child: Container(
                      //                             decoration: BoxDecoration(
                      //                               color: kDarkWhite
                      //                                   .withOpacity(0.8),
                      //                               borderRadius:
                      //                                   BorderRadius.circular(
                      //                                       50),
                      //                             ),
                      //                             width: 40,
                      //                             height: 40,
                      //                             child: Icon(
                      //                               Icons.keyboard_arrow_right,
                      //                               color: Constants.kMainColor,
                      //                             ),
                      //                           ),
                      //                           onTap: () {
                      //                             pageController.nextPage(
                      //                                 duration: const Duration(
                      //                                     milliseconds: 300),
                      //                                 curve: Curves.linear);
                      //                           },
                      //                         ),
                      //                       ),
                      //                     ],
                      //                   ),
                      //                 ],
                      //               ),
                      //               const SizedBox(height: 30),
                      //             ],
                      //           ),
                      //         );
                      //       } else {
                      //         return GestureDetector(
                      //           onTap: () {
                      //             const PurchasePremiumPlanScreen(
                      //               isCameBack: true,
                      //             ).launch(context);
                      //           },
                      //           child: Container(
                      //             padding: const EdgeInsets.all(10),
                      //             height: 180,
                      //             width: MediaQuery.of(context).size.width,
                      //             decoration: const BoxDecoration(
                      //                 image: DecorationImage(
                      //                     image: AssetImage(
                      //                         'images/banner2.png'))),
                      //           ),
                      //         );
                      //       }
                      //     },
                      //     error: (e, stack) {
                      //       return Container(
                      //         padding: const EdgeInsets.all(10),
                      //         height: 180,
                      //         width: 320,
                      //         decoration: const BoxDecoration(
                      //             image: DecorationImage(
                      //                 image: AssetImage('images/banner2.png'))),
                      //       );
                      //     },
                      //     loading: () {
                      //       return Center(
                      //           child: CircularProgressIndicator(
                      //         color: Constants.kMainColor,
                      //       ));
                      //     },
                      //   ),
                      // ),

                      // Padding(
                      //   padding: const EdgeInsets.all(8.0),
                      //   child: Row(
                      //     children: [
                      //       SizedBox(
                      //         width: 10.0,
                      //       ),
                      //       Text(
                      //         'Business',
                      //         style: GoogleFonts.poppins(
                      //           color: Colors.black,
                      //           fontWeight: FontWeight.bold,
                      //           fontSize: 20.0,
                      //         ),
                      //       ),
                      //     ],
                      //   ),
                      // ),
                      // Container(
                      //   padding: const EdgeInsets.all(10.0),
                      //   child: GridView.count(
                      //     physics: const NeverScrollableScrollPhysics(),
                      //     shrinkWrap: true,
                      //     childAspectRatio: 1,
                      //     crossAxisCount: 4,
                      //     children: List.generate(
                      //       businessIcons.length,
                      //       (index) => HomeGridCards(
                      //         color: Constants.kMainColor,
                      //         gridItems: businessIcons[index],
                      //       ),
                      //     ),
                      //   ),
                      // ),

                      // Padding(
                      //   padding: const EdgeInsets.all(8.0),
                      //   child: Row(
                      //     children: [
                      //       SizedBox(
                      //         width: 10.0,
                      //       ),
                      //       Text(
                      //         'Enterprise',
                      //         style: GoogleFonts.poppins(
                      //           color: Colors.black,
                      //           fontWeight: FontWeight.bold,
                      //           fontSize: 20.0,
                      //         ),
                      //       ),
                      //     ],
                      //   ),
                      // ),
                      // Container(
                      //   padding: const EdgeInsets.all(10.0),
                      //   child: GridView.count(
                      //     physics: const NeverScrollableScrollPhysics(),
                      //     shrinkWrap: true,
                      //     childAspectRatio: 1,
                      //     crossAxisCount: 4,
                      //     children: List.generate(
                      //       enterpriseIcons.length,
                      //       (index) => HomeGridCards(
                      //         color: Constants.kMainColor,
                      //         gridItems: enterpriseIcons[index],
                      //       ),
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),
                ),
              );
            },
            error: (e, stack) {
              return Text(e.toString());
            },
            loading: () {
              return Center(
                  child: CircularProgressIndicator(
                color: Constants.kMainColor,
              ));
            },
          );
        },
      ),
    );
  }
}

class HomeGridCards extends StatefulWidget {
  const HomeGridCards({
    super.key,
    required this.gridItems,
    required this.color,
  });
  final GridItems gridItems;
  final Color color;

  @override
  State<HomeGridCards> createState() => _HomeGridCardsState();
}

class _HomeGridCardsState extends State<HomeGridCards> {
  Future<bool> subscriptionChecker({
    required String item,
  }) async {
    final DatabaseReference subscriptionRef = FirebaseDatabase.instance
        .ref()
        .child(constUserId)
        .child('Subscription');
    DatabaseReference ref =
        FirebaseDatabase.instance.ref('$constUserId/Subscription');
    ref.keepSynced(true);
    subscriptionRef.keepSynced(true);

    bool boolValue = true;

    await ref.get().then((value) async {
      final dataModel =
          SubscriptionModel.fromJson(jsonDecode(jsonEncode(value.value)));
      final remainTime =
          DateTime.parse(dataModel.subscriptionDate).difference(DateTime.now());
      for (var element in Subscription.subscriptionPlan) {
        if (dataModel.subscriptionName == element.subscriptionName) {
          if (remainTime.inHours.abs() > element.duration * 24) {
            Subscription.freeSubscriptionModel.subscriptionDate =
                DateTime.now().toString();
            subscriptionRef.set(Subscription.freeSubscriptionModel.toJson());
            final prefs = await SharedPreferences.getInstance();
            await prefs.setBool('isFiveDayRemainderShown', true);
          } else if (item == 'Sales' &&
              dataModel.saleNumber <= 0 &&
              dataModel.saleNumber != -202) {
            boolValue = false;
          } else if (item == 'Parties' &&
              dataModel.partiesNumber <= 0 &&
              dataModel.partiesNumber != -202) {
            boolValue = false;
          } else if (item == 'Purchase' &&
              dataModel.purchaseNumber <= 0 &&
              dataModel.purchaseNumber != -202) {
            boolValue = false;
          } else if (item == 'Products' &&
              dataModel.products <= 0 &&
              dataModel.products != -202) {
            boolValue = false;
          } else if (item == 'Due List' &&
              dataModel.dueNumber <= 0 &&
              dataModel.dueNumber != -202) {
            boolValue = false;
          }
        }
      }
    });
    return boolValue;
  }

  bool checkPermission({required String item}) {
    if (item == 'Sales' && finalUserRoleModel.salePermission) {
      return true;
    } else if (item == 'Parties' && finalUserRoleModel.partiesPermission) {
      return true;
    } else if (item == 'Purchase' && finalUserRoleModel.purchasePermission) {
      return true;
    } else if (item == 'Products' && finalUserRoleModel.productPermission) {
      return true;
    } else if (item == 'Due List' && finalUserRoleModel.dueListPermission) {
      return true;
    } else if (item == 'Stock' && finalUserRoleModel.stockPermission) {
      return true;
    } else if (item == 'Reports' && finalUserRoleModel.reportsPermission) {
      return true;
    } else if (item == 'Sales List' && finalUserRoleModel.salesListPermission) {
      return true;
    } else if (item == 'Purchase List' &&
        finalUserRoleModel.purchaseListPermission) {
      return true;
    } else if (item == 'Loss/Profit' &&
        finalUserRoleModel.lossProfitPermission) {
      return true;
    } else if (item == 'Expense' && finalUserRoleModel.addExpensePermission) {
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    // ignore: avoid_unnecessary_containers
    return Consumer(builder: (context, ref, __) {
      return Stack(
        alignment: Alignment.bottomCenter,
        children: [
          SizedBox(
            width: 120,
            child: Card(
              elevation: 2,
              color: widget.color,
              child: Column(
                children: [
                  TextButton(
                    onPressed: () async {
                      /////
                      ///
                      ///

                      //---------- Route Navigation ------------------

                      isSubUser
                          ? checkPermission(item: widget.gridItems.title)
                              ? await subscriptionChecker(
                                      item: widget.gridItems.title)
                                  ? Navigator.of(context)
                                      .pushNamed('/${widget.gridItems.route}')
                                  : EasyLoading.showError(
                                      'Update your plan first,\nyour limit is over.')
                              : EasyLoading.showError(
                                  'Sorry, you have no permission to access this service')
                          : await subscriptionChecker(
                                  item: widget.gridItems.title)
                              ? widget.gridItems.title !=
                                      lang.S.of(context).reports
                                  ? Navigator.of(context)
                                      .pushNamed('/${widget.gridItems.route}')
                                  : context
                                      .read<VisibilityProvider>()
                                      .toggleVisibility()
                              : EasyLoading.showError(
                                  'Update your plan first,\nyour limit is over.');

/////
                      //-----------------------   Auto Scroll To Report List      -------------------------------
                      //

                      // widget.gridItems.title == lang.S.of(context).reports
                      //     ? Future.delayed(
                      //         const Duration(milliseconds: 100),
                      //         () async {
                      //           await Scrollable.ensureVisible(
                      //             listKey.currentContext!,
                      //             duration:
                      //                 const Duration(milliseconds: 800),
                      //           );
                      //         },
                      //       )
                      //     : null;
                    },
                    child: Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(
                            widget.gridItems.icon.toString(),
                          ),
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              widget.gridItems.title.toString(),
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
              maxLines: 2,
            ),
          ),
        ],
      );
    });
  }
}
