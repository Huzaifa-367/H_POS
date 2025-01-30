import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
// import 'package:flutter_paypal/flutter_paypal.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_pos/model/subscription_plan_model.dart';
import 'package:mobile_pos/payment_methods.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../Provider/subacription_plan_provider.dart';
import '../../constant.dart';
import '../../currency.dart';
import '../../model/subscription_model.dart';
import '../../subscription.dart';
import '../Home/Dashboard.dart';
import 'package:mobile_pos/generated/l10n.dart' as lang;

import 'package:url_launcher/url_launcher.dart';

class PurchasePremiumPlanScreen extends StatefulWidget {
  const PurchasePremiumPlanScreen({super.key, required this.isCameBack});

  final bool isCameBack;

  @override
  State<PurchasePremiumPlanScreen> createState() =>
      _PurchasePremiumPlanScreenState();
}

class _PurchasePremiumPlanScreenState extends State<PurchasePremiumPlanScreen> {
  String selectedPayButton = 'Paypal';
  int selectedPackageValue = 0;
  SubscriptionPlanModel selectedPlan = SubscriptionPlanModel(
    subscriptionName: '',
    saleNumber: 0,
    purchaseNumber: 0,
    partiesNumber: 0,
    dueNumber: 0,
    duration: 0,
    products: 0,
    subscriptionPrice: 0,
    offerPrice: 0,
  );

  List<String> imageList = [
    'images/sp1.png',
    'images/sp2.png',
    'images/sp3.png',
    'images/sp4.png',
    'images/sp5.png',
    'images/sp6.png',
  ];

  List<String> titleListData = [
    'Free Lifetime Update',
    'Android & iOS App Support',
    'Premium Customer Support',
    'Custom Invoice Branding',
    'Unlimited Usage',
    'Free Data Backup',
  ];

  List<String> planDetailsImages = [
    'images/plan_details_1.png',
    'images/plan_details_2.png',
    'images/plan_details_3.png',
    'images/plan_details_4.png',
    'images/plan_details_5.png',
    'images/plan_details_6.png',
  ];
  List<String> planDetailsText = [
    'Free Lifetime Update',
    'Android & iOS App Support',
    'Premium Customer Support',
    'Custom Invoice Branding',
    'Unlimited Usage',
    'Free Data Backup',
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

// Define a function to create the WhatsApp message
  String getWhatsAppMessage(SubscriptionPlanModel plan) {
    // Construct the message with plan details

    final message =
        "Hi there! I'm interested in your *'${plan.subscriptionName}'* subscription plan.\n It looks perfect for my needs. Here are the details I'd like to know more about: \n"
        "📦 *Included Products:* ${plan.products == -202 ? "Unlimited" : plan.products}\n"
        "⏳ *Duration:* ${plan.duration} days\n"
        "💲 *Price:* ${plan.offerPrice} PKR\n"
        "📊 *Sales Count:* ${plan.saleNumber == -202 ? "Unlimited" : plan.saleNumber}\n"
        "📥 *Purchase Count:* ${plan.purchaseNumber == -202 ? "Unlimited" : plan.purchaseNumber}\n"
        "🤝 *Parties Count:* ${plan.partiesNumber == -202 ? "Unlimited" : plan.partiesNumber}\n"
        "💰 *Due Count:* ${plan.dueNumber == -202 ? "Unlimited" : plan.dueNumber}\n"
        "Could you please provide me with more information about this plan? I'd greatly appreciate it!\n"
        "Thank you! 😊";

    return Uri.encodeComponent(message);
  }

// Use this function to open WhatsApp
  void openWhatsApp(SubscriptionPlanModel plan) async {
    final whatsappMessage = getWhatsAppMessage(plan);

    final url = "https://wa.me/<+923203608044>?text=$whatsappMessage";

    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch WhatsApp';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, __) {
      final subscriptionPlanData = ref.watch(subscriptionPlanProvider);
      return Scaffold(
        body: SingleChildScrollView(
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        lang.S.of(context).purchasePremium,
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      GestureDetector(
                        onTap: () {
                          widget.isCameBack
                              ? Navigator.pop(context)
                              : const Dashboard().launch(context);
                        },
                        child: const Icon(Icons.cancel_outlined),
                      )
                    ],
                  ),
                  const SizedBox(height: 20),
                  ListView.builder(
                      itemCount: imageList.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (_, i) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: GestureDetector(
                            onTap: () {
                              // showDialog(
                              //   context: context,
                              //   builder: (BuildContext context) {
                              //     return Dialog(
                              //       child: Column(
                              //         mainAxisSize: MainAxisSize.min,
                              //         mainAxisAlignment:
                              //             MainAxisAlignment.center,
                              //         crossAxisAlignment:
                              //             CrossAxisAlignment.center,
                              //         children: [
                              //           const SizedBox(height: 20),
                              //           Row(
                              //             mainAxisSize: MainAxisSize.max,
                              //             mainAxisAlignment:
                              //                 MainAxisAlignment.end,
                              //             children: [
                              //               GestureDetector(
                              //                 child: const Icon(Icons.cancel),
                              //                 onTap: () {
                              //                   Navigator.pop(context);
                              //                 },
                              //               ),
                              //               const SizedBox(width: 20),
                              //             ],
                              //           ),
                              //           const SizedBox(height: 20),
                              //           Image(
                              //             height: 200,
                              //             width: 200,
                              //             image:
                              //                 AssetImage(planDetailsImages[i]),
                              //           ),
                              //           const SizedBox(height: 20),
                              //           Text(
                              //             planDetailsText[i],
                              //             style: const TextStyle(
                              //                 fontSize: 20,
                              //                 fontWeight: FontWeight.bold),
                              //           ),
                              //           const SizedBox(height: 15),
                              //           const Padding(
                              //             padding: EdgeInsets.all(8.0),
                              //             child: Text(
                              //                 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Natoque aliquet et, cur eget. Tellus sapien odio aliq.',
                              //                 textAlign: TextAlign.center,
                              //                 style: TextStyle(fontSize: 16)),
                              //           ),
                              //           const SizedBox(height: 20),
                              //         ],
                              //       ),
                              //     );
                              //   },
                              // );
                            },
                            child: Material(
                              elevation: 1,
                              borderRadius: BorderRadius.circular(10),
                              child: Container(
                                padding: const EdgeInsets.all(5.0),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Constants().kBgColor,
                                ),
                                child: ListTile(
                                  leading: SizedBox(
                                    height: 40,
                                    width: 40,
                                    child: Image(
                                      image: AssetImage(imageList[i]),
                                    ),
                                  ),
                                  title: Text(
                                    titleListData[i],
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16),
                                  ),
                                  // trailing:
                                  //     const Icon(FeatherIcons.alertCircle),
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                  const SizedBox(height: 10),
                  Text(
                    lang.S.of(context).buyPremium,
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 20,
                  ),

                  ///______________________________________________________________________
                  subscriptionPlanData.when(data: (data) {
                    return SizedBox(
                      height: (context.width() / 2.5) + 18,
                      child: ListView.builder(
                        physics: const ClampingScrollPhysics(),
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemCount: data.length,
                        itemBuilder: (BuildContext context, int index) {
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedPlan = data[index];
                              });
                            },
                            child: data[index].offerPrice >= 1
                                ? Padding(
                                    padding: const EdgeInsets.only(right: 10),
                                    child: SizedBox(
                                      height: (context.width() / 2.5) + 18,
                                      child: Stack(
                                        alignment: Alignment.bottomCenter,
                                        children: [
                                          Container(
                                            height: (context.width() / 2.5),
                                            width: (context.width() / 3) - 20,
                                            decoration: BoxDecoration(
                                              color: data[index]
                                                          .subscriptionName ==
                                                      selectedPlan
                                                          .subscriptionName
                                                  ? kPremiumPlanColor2
                                                      .withOpacity(0.1)
                                                  : Colors.white,
                                              borderRadius:
                                                  const BorderRadius.all(
                                                Radius.circular(10),
                                              ),
                                              border: Border.all(
                                                width: 1,
                                                color: data[index]
                                                            .subscriptionName ==
                                                        selectedPlan
                                                            .subscriptionName
                                                    ? kPremiumPlanColor2
                                                    : kPremiumPlanColor,
                                              ),
                                            ),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                const SizedBox(height: 25),
                                                const Text(
                                                  'Mobile App ',
                                                  //+\nDesktop',
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                const SizedBox(height: 15),
                                                Text(
                                                  data[index].subscriptionName,
                                                  style: const TextStyle(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                                const SizedBox(height: 5),
                                                Text(
                                                  '$currency${data[index].offerPrice}',
                                                  style: const TextStyle(
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color:
                                                          kPremiumPlanColor2),
                                                ),
                                                Text(
                                                  '$currency${data[index].subscriptionPrice}',
                                                  style: const TextStyle(
                                                      decoration: TextDecoration
                                                          .lineThrough,
                                                      fontSize: 14,
                                                      color: Colors.grey),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Positioned(
                                            top: 18,
                                            left: 0,
                                            child: Container(
                                              height: 25,
                                              width: 70,
                                              decoration: const BoxDecoration(
                                                color: kPremiumPlanColor2,
                                                borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(10),
                                                  bottomRight:
                                                      Radius.circular(10),
                                                ),
                                              ),
                                              child: Center(
                                                child: Text(
                                                  'Save ${(100 - ((data[index].offerPrice * 100) / data[index].subscriptionPrice)).toInt().toString()}%',
                                                  style: const TextStyle(
                                                      color: Colors.white),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                : Padding(
                                    padding: const EdgeInsets.only(
                                        bottom: 20, top: 20, right: 10),
                                    child: Container(
                                      height: (context.width() / 3) - 20,
                                      width: (context.width() / 3) - 20,
                                      decoration: BoxDecoration(
                                        color: data[index].subscriptionName ==
                                                selectedPlan.subscriptionName
                                            ? kPremiumPlanColor2
                                                .withOpacity(0.1)
                                            : Colors.white,
                                        borderRadius: const BorderRadius.all(
                                          Radius.circular(10),
                                        ),
                                        border: Border.all(
                                            width: 1,
                                            color:
                                                data[index].subscriptionName ==
                                                        selectedPlan
                                                            .subscriptionName
                                                    ? kPremiumPlanColor2
                                                    : kPremiumPlanColor),
                                      ),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            data[index].subscriptionName,
                                            style: const TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const SizedBox(height: 20),
                                          Text(
                                            '$currency${data[index].subscriptionPrice.toString()}',
                                            style: const TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                                color: kPremiumPlanColor),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                          );
                        },
                      ),
                    );
                  }, error: (Object error, StackTrace? stackTrace) {
                    return Text(error.toString());
                  }, loading: () {
                    return Center(
                        child: CircularProgressIndicator(
                      color: Constants.kMainColor,
                    ));
                  }),
                  const SizedBox(height: 20),
                  GestureDetector(
                    onTap: () {
                      openWhatsApp(selectedPlan);

                      // UsePaypal(
                      //     sandboxMode: sandbox,
                      //     clientId: paypalClientId,
                      //     secretKey: paypalClientSecret,
                      //     returnURL: "https://samplesite.com/return",
                      //     cancelURL: "https://samplesite.com/cancel",
                      //     transactions: [
                      //       {
                      //         "amount": {
                      //           // "total": Subscription.subscriptionAmounts[Subscription.selectedItem]!['Amount'].toString(),
                      //           "total": selectedPlan.subscriptionPrice.toString(),
                      //           "currency": Subscription.currency.toString(),
                      //           "details": {
                      //             // "subtotal": Subscription.subscriptionAmounts[Subscription.selectedItem]!['Amount'].toString(),
                      //             "subtotal": selectedPlan.subscriptionPrice.toString(),
                      //             "shipping": '0',
                      //             "shipping_discount": 0
                      //           }
                      //         },
                      //         "description": "The payment transaction description.",
                      //         "item_list": {
                      //           "items": [
                      //             {
                      //               "name": "${selectedPlan.subscriptionName} Package",
                      //               "quantity": 1,
                      //               // "price": Subscription.subscriptionAmounts[Subscription.selectedItem]!['Amount'].toString(),
                      //               "price": selectedPlan.subscriptionPrice.toString(),
                      //               "currency": Subscription.currency.toString(),
                      //             }
                      //           ],
                      //         }
                      //       }
                      //     ],
                      //     note: "Payment From MaanPos app",
                      //     onSuccess: (Map params) async {
                      //
                      //     },
                      //     onError: (error) {
                      //       EasyLoading.showError('Error');
                      //     },
                      //     onCancel: (params) {
                      //       EasyLoading.showError('Cancel');
                      //     }).launch(context);

                      // PaymentPage(
                      //         selectedPlan: selectedPlan,
                      //         onError: () {
                      //           EasyLoading.showError("Payment error");
                      //         },
                      //         totalAmount:
                      //             selectedPlan.subscriptionPrice.toString())
                      //     .launch(context);
                    },
                    child: Container(
                      height: 60,
                      decoration: BoxDecoration(
                        color: Constants.kMainColor,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10)),
                      ),
                      child: Center(
                        child: Text(
                          lang.S.of(context).buyPremium,
                          style: const TextStyle(
                              fontSize: 18, color: Colors.white),
                        ),
                      ),
                    ),
                  ).visible(Subscription.customersActivePlan.subscriptionName !=
                      selectedPlan.subscriptionName),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
