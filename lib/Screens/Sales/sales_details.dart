// ignore_for_file: unused_result

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cart/flutter_cart.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_pos/GlobalComponents/button_global.dart';
import 'package:mobile_pos/Provider/product_provider.dart';
import 'package:mobile_pos/Screens/Payment/payment_options.dart';
import 'package:mobile_pos/Screens/Sales/Model/sales_report.dart';
import 'package:mobile_pos/Screens/Sales/add_discount.dart';
import 'package:mobile_pos/currency.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:mobile_pos/generated/l10n.dart' as lang;
import '../../Provider/add_to_cart.dart';
import '../../constant.dart';

// ignore: must_be_immutable
class SalesDetails extends StatefulWidget {
  SalesDetails({Key? key, @required this.customerName}) : super(key: key);
  // ignore: prefer_typing_uninitialized_variables
  var customerName;
  @override
  // ignore: library_private_types_in_public_api
  _SalesDetailsState createState() => _SalesDetailsState();
}

class _SalesDetailsState extends State<SalesDetails> {
  var salesCart = FlutterCart();
  String customer = '';
  @override
  void initState() {
    widget.customerName == null
        ? customer = 'Unknown'
        : customer = widget.customerName;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, __) {
      final providerData = ref.watch(cartNotifier);
      return Scaffold(
        appBar: AppBar(
          title: Text(
            lang.S.of(context).salesDetails,
            style: GoogleFonts.poppins(
              color: Colors.black,
              fontSize: 20.0,
            ),
          ),
          iconTheme: const IconThemeData(color: Colors.black),
          centerTitle: true,
          backgroundColor: Colors.white,
          elevation: 0.0,
          actions: [
            PopupMenuButton(
              itemBuilder: (BuildContext bc) => [
                const PopupMenuItem(
                    value: "/addDiscount", child: Text('Add Discount')),
                const PopupMenuItem(
                    value: "clear", child: Text('Cancel All Product')),
                const PopupMenuItem(
                    value: "/settings", child: Text('Vat Doesn\'t Apply')),
              ],
              onSelected: (value) {
                Navigator.pushNamed(context, '$value');
              },
            ),
          ],
        ),
        body: Column(
          children: [
            const SizedBox(
              height: 30.0,
            ),
            Expanded(
              child: ListView.builder(
                itemCount: providerData.cartItemList.length,
                itemBuilder: (context, index) => Padding(
                  padding: const EdgeInsets.only(
                      left: 25.0, right: 25.0, bottom: 10.0),
                  child: Stack(
                    children: [
                      Text(
                        providerData.cartItemList[index].productName.toString(),
                        style: GoogleFonts.poppins(
                          color: kGreyTextColor,
                          fontSize: 15.0,
                        ),
                      ),
                      Positioned(
                        right: 70,
                        child: SizedBox(
                          width: 65,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  providerData.quantityDecrease(index);
                                },
                                child: Container(
                                  height: 20,
                                  width: 20,
                                  decoration: BoxDecoration(
                                    color: Constants.kMainColor,
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(10)),
                                  ),
                                  child: const Center(
                                      child: Text(
                                    '-',
                                    style: TextStyle(
                                        fontSize: 14, color: Colors.white),
                                  )),
                                ),
                              ),
                              const SizedBox(width: 5),
                              Text(
                                '${providerData.cartItemList[index].quantity}',
                                style: GoogleFonts.poppins(
                                  color: kGreyTextColor,
                                  fontSize: 15.0,
                                ),
                              ),
                              const SizedBox(width: 5),
                              GestureDetector(
                                onTap: () {
                                  providerData.quantityIncrease(index);
                                },
                                child: Container(
                                  height: 20,
                                  width: 20,
                                  decoration: BoxDecoration(
                                    color: Constants.kMainColor,
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(10)),
                                  ),
                                  child: const Center(
                                      child: Text(
                                    '+',
                                    style: TextStyle(
                                        fontSize: 14, color: Colors.white),
                                  )),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        right: 0,
                        child: Text(
                          '$currency${providerData.cartItemList[index].subTotal.toString()}',
                          style: GoogleFonts.poppins(
                            color: kGreyTextColor,
                            fontSize: 15.0,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const Spacer(),
            const Divider(
              color: kGreyTextColor,
              thickness: 0.5,
            ),
            Padding(
              padding:
                  const EdgeInsets.only(left: 25.0, right: 25.0, bottom: 10.0),
              child: Row(
                children: [
                  Text(
                    lang.S.of(context).subTotal,
                    style: GoogleFonts.poppins(
                      color: kGreyTextColor,
                      fontSize: 15.0,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    providerData.getTotalAmount().toString(),
                    style: GoogleFonts.poppins(
                      color: kGreyTextColor,
                      fontSize: 15.0,
                    ),
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: () {
                const AddDiscount().launch(context);
              },
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 25.0, right: 25.0, bottom: 10.0),
                child: Row(
                  children: [
                    Text(
                      lang.S.of(context).discount,
                      style: GoogleFonts.poppins(
                        color: kGreyTextColor,
                        fontSize: 15.0,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      providerData.discountType == 'USD'
                          ? providerData.discount.toString()
                          : '${providerData.discount} %',
                      style: GoogleFonts.poppins(
                        color: kGreyTextColor,
                        fontSize: 15.0,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              height: 50,
              width: MediaQuery.of(context).size.width,
              color: kDarkWhite,
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 25.0, right: 25.0, bottom: 10.0),
                child: Row(
                  children: [
                    Text(
                      lang.S.of(context).total,
                      style: GoogleFonts.poppins(
                        color: Colors.black,
                        fontSize: 20.0,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      providerData.getTotalAmount().toString(),
                      style: GoogleFonts.poppins(
                        color: Colors.black,
                        fontSize: 20.0,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            ButtonGlobal(
              iconWidget: Icons.arrow_forward,
              buttontext: lang.S.of(context).continueButton,
              iconColor: Colors.white,
              buttonDecoration:
                  kButtonDecoration.copyWith(color: Constants.kMainColor),
              onPressed: () async {
                try {
                  EasyLoading.show(status: 'Loading...', dismissOnTap: false);
                  final DatabaseReference salesReportRef = FirebaseDatabase
                      .instance
                      .ref()
                      .child(constUserId)
                      .child('Sales Report');
                  SalesReport salesReport = SalesReport(
                      customer,
                      providerData.getTotalAmount().toString(),
                      providerData.cartItemList.length.toString());
                  await salesReportRef.push().set(salesReport.toJson());
                  EasyLoading.dismiss();

                  Future.delayed(const Duration(milliseconds: 500), () {
                    ref.refresh(productProvider);
                    const PaymentOptions().launch(context);
                  });
                } catch (e) {
                  EasyLoading.dismiss();
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text(e.toString())));
                }
              },
            ),
          ],
        ),
      );
    });
  }
}
