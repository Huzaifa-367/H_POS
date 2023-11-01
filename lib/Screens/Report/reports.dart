// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_pos/Screens/Home/home_screen.dart';
import 'package:mobile_pos/Screens/Loss_Profit/loss_profit_screen.dart';
import 'package:mobile_pos/Screens/Purchase/purchase_list.dart';
import 'package:mobile_pos/Screens/Report/Screens/due_report_screen.dart';
import 'package:mobile_pos/Screens/Report/Screens/purchase_report.dart';
import 'package:mobile_pos/Screens/Report/Screens/sales_report_screen.dart';
import 'package:mobile_pos/Screens/Settings/Profile_Widget.dart';
import 'package:mobile_pos/Screens/stock_list/stock_list.dart';
import 'package:mobile_pos/constant.dart';
import 'package:mobile_pos/invoice_constant.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:mobile_pos/generated/l10n.dart' as lang;

class Reports extends StatefulWidget {
  Reports({Key? key, required this.isFromHome}) : super(key: key);
  var isFromHome;

  @override
  // ignore: library_private_types_in_public_api
  _ReportsState createState() => _ReportsState();
}

class _ReportsState extends State<Reports> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.isFromHome != true
          ? AppBar(
              automaticallyImplyLeading: false,
              title: Text(
                lang.S.of(context).reports,
                style: GoogleFonts.poppins(
                  color: Colors.black,
                  fontSize: 20.0,
                ),
              ),
              iconTheme: const IconThemeData(color: Colors.black),
              centerTitle: true,
              backgroundColor: Colors.white,
              elevation: 0.0,
            )
          : null,
      body: SingleChildScrollView(
        physics: widget.isFromHome
            ? const NeverScrollableScrollPhysics()
            : const AlwaysScrollableScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.only(
            left: 8.0,
            right: 0.8,
          ),
          child: Column(
            children: [
              widget.isFromHome
                  ? Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: DottedBorderWidget(
                        radius: 10,
                        color: Constants.kMainColor,
                        strokeWidth: 2,
                        dotsWidth: 70,
                        child: SizedBox(
                          height: 2,
                          width: MediaQuery.of(context).size.width * 0.25,
                        ),
                      ),
                    )
                  : const SizedBox.shrink(),
              SettingsGroup(
                items: [
                  SettingsItem(
                    onTap: () {
                      const PurchaseReportScreen().launch(context);
                    },
                    icon: Icons.call_received_sharp,
                    iconStyle: IconStyle(
                      backgroundColor: Colors.blue,
                    ),
                    title: lang.S.of(context).purchaseReport,
                    subtitle: "Learn more about us",
                  ),
                  SettingsItem(
                    onTap: () {
                      const SalesReportScreen().launch(context);
                    },
                    icon: Icons.incomplete_circle_rounded,
                    iconStyle: IconStyle(
                      backgroundColor: Colors.green,
                    ),
                    title: lang.S.of(context).salesReport,
                    subtitle: "Learn more about us",
                  ),
                  SettingsItem(
                    onTap: () {
                      const DueReportScreen().launch(context);
                    },
                    icon: Icons.call_received_rounded,
                    iconStyle: IconStyle(
                      backgroundColor: Colors.redAccent,
                    ),
                    title: lang.S.of(context).dueReport,
                    subtitle: "Learn more about us",
                  ),
                  SettingsItem(
                    onTap: () {
                      const StockList().launch(context);
                    },
                    icon: Icons.production_quantity_limits_rounded,
                    iconStyle: IconStyle(
                      backgroundColor: Constants.kMainColor.withBlue(500),
                    ),
                    title: lang.S.of(context).stockList,
                    subtitle: "Learn more about us",
                  ),
                  SettingsItem(
                    onTap: () {
                      const LossProfitScreen().launch(context);
                    },
                    icon: Icons.attach_money_rounded,
                    iconStyle: IconStyle(
                      backgroundColor: Constants.kMainColor.withBlue(90),
                    ),
                    title: lang.S.of(context).lossOrProfit,
                    subtitle: "Learn more about us",
                  ),

                  // ////////
                  // ///
                  // ///
                  // const Spacer()
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
