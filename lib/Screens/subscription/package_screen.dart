import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_pos/Screens/subscription/purchase_premium_plan_screen.dart';
import 'package:mobile_pos/constant.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../model/subscription_model.dart';
import '../../subscription.dart';
import 'package:mobile_pos/generated/l10n.dart' as lang;

class PackageScreen extends StatefulWidget {
  const PackageScreen({Key? key}) : super(key: key);

  @override
  State<PackageScreen> createState() => _PackageScreenState();
}

class _PackageScreenState extends State<PackageScreen> {
  SubscriptionModel subscriptionModel = SubscriptionModel(
    subscriptionName: '',
    subscriptionDate: DateTime.now().toString(),
    saleNumber: 0,
    purchaseNumber: 0,
    partiesNumber: 0,
    dueNumber: 0,
    duration: 0,
    products: 0,
  );
  Duration? remainTime;
  List<String>? initialPackageService;
  List<int>? mainPackageService;
  List<String> nameList = [
    'Sales',
    'Purchase',
    'Due collection',
    'Parties',
    'Products'
  ];
  List<String> imageList = [
    'images/sales_2.png',
    'images/purchase_2.png',
    'images/due_collection_2.png',
    'images/parties_2.png',
    'images/product1.png',
  ];

  void checkSubscriptionData() async {
    EasyLoading.show(status: 'Loading');
    DatabaseReference ref =
        FirebaseDatabase.instance.ref('$constUserId/Subscription');
    final model = await ref.get();
    var data = jsonDecode(jsonEncode(model.value));
    final finalModel = SubscriptionModel.fromJson(data);
    for (var element in Subscription.subscriptionPlan) {
      if (finalModel.subscriptionName == element.subscriptionName) {
        Subscription.customersActivePlan.saleNumber = element.saleNumber;
        Subscription.customersActivePlan.duration = element.duration;
        Subscription.customersActivePlan.products = element.products;
        Subscription.customersActivePlan.partiesNumber = element.partiesNumber;
        Subscription.customersActivePlan.dueNumber = element.dueNumber;
        Subscription.customersActivePlan.purchaseNumber =
            element.purchaseNumber;
        Subscription.customersActivePlan.subscriptionName =
            element.subscriptionName;
        Subscription.customersActivePlan.offerPrice = element.offerPrice;
        Subscription.customersActivePlan.subscriptionPrice =
            element.subscriptionPrice;

        mainPackageService = [
          Subscription.customersActivePlan.saleNumber,
          Subscription.customersActivePlan.purchaseNumber,
          Subscription.customersActivePlan.dueNumber,
          Subscription.customersActivePlan.partiesNumber,
          Subscription.customersActivePlan.products,
        ];
      }
    }

    setState(() {
      subscriptionModel = finalModel;
      initialPackageService = [
        finalModel.saleNumber.toString(),
        finalModel.purchaseNumber.toString(),
        finalModel.dueNumber.toString(),
        finalModel.partiesNumber.toString(),
        finalModel.products.toString(),
      ];
    });
    EasyLoading.dismiss();
  }

  @override
  void initState() {
    checkSubscriptionData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          lang.S.of(context).yourPack,
          style: GoogleFonts.poppins(
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 0.0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 80,
                width: double.infinity,
                decoration: BoxDecoration(
                    color: kPremiumPlanColor.withOpacity(0.2),
                    borderRadius: const BorderRadius.all(Radius.circular(10))),
                child: Row(
                  children: [
                    const SizedBox(width: 10),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          lang.S.of(context).freePlan,
                          style: const TextStyle(fontSize: 18),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Text(
                              lang.S.of(context).youRUsing,
                              style: const TextStyle(fontSize: 14),
                            ),
                            Text(
                              'Free Package',
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: TextStyle(
                                fontSize: 14,
                                color: Constants.kMainColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const Spacer(),
                    Container(
                      height: 63,
                      width: 63,
                      decoration: BoxDecoration(
                        color: Constants.kMainColor,
                        borderRadius: const BorderRadius.all(
                          Radius.circular(50),
                        ),
                      ),
                      child: Center(
                          child: Text(
                        '${(DateTime.parse(subscriptionModel.subscriptionDate).difference(DateTime.now()).inDays.abs() - subscriptionModel.duration).abs()} \nDays Left',
                        textAlign: TextAlign.center,
                        style:
                            const TextStyle(fontSize: 12, color: Colors.white),
                      )),
                    ),
                    const SizedBox(width: 20),
                  ],
                ),
              ).visible(
                  Subscription.customersActivePlan.subscriptionName == 'Free'),
              Container(
                height: 80,
                width: double.infinity,
                decoration: BoxDecoration(
                    color: kPremiumPlanColor.withOpacity(0.2),
                    borderRadius: const BorderRadius.all(Radius.circular(10))),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(width: 20),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          lang.S.of(context).premiumPlan,
                          style: const TextStyle(fontSize: 18),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Text(
                              lang.S.of(context).youRUsing,
                              style: const TextStyle(fontSize: 14),
                            ),
                            Text(
                              '${Subscription.customersActivePlan.subscriptionName} Package',
                              style: TextStyle(
                                  fontSize: 14,
                                  color: Constants.kMainColor,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const Spacer(),
                    Container(
                      height: 63,
                      width: 63,
                      decoration: BoxDecoration(
                        color: Constants.kMainColor,
                        borderRadius: const BorderRadius.all(
                          Radius.circular(50),
                        ),
                      ),
                      child: Center(
                          child: Text(
                        '${(DateTime.parse(subscriptionModel.subscriptionDate).difference(DateTime.now()).inDays.abs() - subscriptionModel.duration).abs()} \nDays Left',
                        textAlign: TextAlign.center,
                        style:
                            const TextStyle(fontSize: 12, color: Colors.white),
                      )),
                    ).visible(subscriptionModel.duration != -202),
                    const SizedBox(width: 20),
                  ],
                ),
              ).visible(
                  Subscription.customersActivePlan.subscriptionName != 'Free'),
              const SizedBox(height: 20),
              Text(
                lang.S.of(context).packFeatures,
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              ListView.builder(
                  itemCount: nameList.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (_, i) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: GestureDetector(
                        onTap: () {},
                        child: Card(
                          elevation: 1,
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: ListTile(
                              leading: SizedBox(
                                height: 40,
                                width: 40,
                                child: Image(
                                  image: AssetImage(imageList[i]),
                                ),
                              ),
                              title: Text(
                                nameList[i],
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                              trailing: mainPackageService?[i] != -202
                                  ? Text(
                                      '(${initialPackageService?[i] ?? ''}/${mainPackageService?[i].toString()})',
                                      style:
                                          const TextStyle(color: Colors.grey),
                                    )
                                  : Text(
                                      lang.S.of(context).unlimited,
                                      style:
                                          const TextStyle(color: Colors.grey),
                                    ),
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
              const SizedBox(height: 20),
              // const Text(
              //   'For Unlimited Usages',
              //   style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              // ).visible(initialSelectedPackage != 'Lifetime'),
              // const SizedBox(height: 20).visible(initialSelectedPackage != 'Lifetime'),
              GestureDetector(
                onTap: () {
                  const PurchasePremiumPlanScreen(
                    isCameBack: true,
                  ).launch(context);
                },
                child: Container(
                  height: 60,
                  decoration: BoxDecoration(
                    color: Constants.kMainColor,
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                  ),
                  child: Center(
                    child: Text(
                      lang.S.of(context).updateNow,
                      style: const TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                ),
              ).visible(Subscription.customersActivePlan.duration != -202 &&
                  !isSubUser),
            ],
          ),
        ),
      ),
    );
  }
}
