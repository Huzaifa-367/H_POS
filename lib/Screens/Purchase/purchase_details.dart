import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cart/flutter_cart.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_pos/GlobalComponents/button_global.dart';
import 'package:mobile_pos/Screens/Payment/payment_options.dart';
import 'package:mobile_pos/Screens/Purchase/Model/purchase_report.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../constant.dart';
import '../../currency.dart';

// ignore: must_be_immutable
class PurchaseDetails extends StatefulWidget {
  PurchaseDetails({Key? key, @required this.customerName}) : super(key: key);
  // ignore: prefer_typing_uninitialized_variables
  var customerName;
  @override
  // ignore: library_private_types_in_public_api
  _PurchaseDetailsState createState() => _PurchaseDetailsState();
}

class _PurchaseDetailsState extends State<PurchaseDetails> {
  var cart = FlutterCart();
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
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Purchase Details',
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
                  value: "/purchaseCustomer", child: Text('Add Customer')),
              const PopupMenuItem(
                  value: "/addDiscount", child: Text('Add Discount')),
              const PopupMenuItem(
                  value: "/settings", child: Text('Cancel All Product')),
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
              itemCount: cart.cartLength,
              itemBuilder: (context, index) => Padding(
                padding: const EdgeInsets.only(
                    left: 25.0, right: 25.0, bottom: 10.0),
                child: Row(
                  children: [
                    Text(
                      cart.cartItemsList[index].productName.toString(),
                      style: GoogleFonts.poppins(
                        color: kGreyTextColor,
                        fontSize: 15.0,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      '$currency${cart.cartItemsList[index].variants.first.price.toString()}',
                      style: GoogleFonts.poppins(
                        color: kGreyTextColor,
                        fontSize: 15.0,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
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
                  'Subtotal',
                  style: GoogleFonts.poppins(
                    color: kGreyTextColor,
                    fontSize: 15.0,
                  ),
                ),
                const Spacer(),
                Text(
                  cart.total.toString(),
                  style: GoogleFonts.poppins(
                    color: kGreyTextColor,
                    fontSize: 15.0,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.only(left: 25.0, right: 25.0, bottom: 10.0),
            child: Row(
              children: [
                Text(
                  'Discount',
                  style: GoogleFonts.poppins(
                    color: kGreyTextColor,
                    fontSize: 15.0,
                  ),
                ),
                const Spacer(),
                Text(
                  '00',
                  style: GoogleFonts.poppins(
                    color: kGreyTextColor,
                    fontSize: 15.0,
                  ),
                ),
              ],
            ),
          ),
          const Divider(
            color: kGreyTextColor,
            thickness: 0.5,
          ),
          Container(
            height: 50,
            width: MediaQuery.of(context).size.width,
            color: kDarkWhite,
            child: Padding(
              padding:
                  const EdgeInsets.only(left: 25.0, right: 25.0, bottom: 10.0),
              child: Row(
                children: [
                  Text(
                    'Total',
                    style: GoogleFonts.poppins(
                      color: Colors.black,
                      fontSize: 15.0,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    cart.total.toString(),
                    style: GoogleFonts.poppins(
                      color: Colors.black,
                      fontSize: 15.0,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const Spacer(),
          ButtonGlobal(
            iconWidget: Icons.arrow_forward,
            buttontext: 'Continue',
            iconColor: Colors.white,
            buttonDecoration:
                kButtonDecoration.copyWith(color: Constants.kMainColor),
            onPressed: () async {
              try {
                EasyLoading.show(status: 'Loading...', dismissOnTap: false);
                // ignore: no_leading_underscores_for_local_identifiers
                final DatabaseReference _purchaseReportRef =
                    FirebaseDatabase.instance
                        // ignore: deprecated_member_use
                        .ref()
                        .child(constUserId)
                        .child('Purchase Report');
                PurchaseReport purchaseReport = PurchaseReport(customer,
                    cart.total.toString(), cart.cartLength.toString());
                await _purchaseReportRef.push().set(purchaseReport.toJson());
                EasyLoading.dismiss();
                // ignore: use_build_context_synchronously
                const PaymentOptions().launch(context);
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
  }
}
