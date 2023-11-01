import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_pos/GlobalComponents/tab_buttons.dart';
import 'package:mobile_pos/Screens/Home/home_screen.dart';
import 'package:mobile_pos/constant.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:mobile_pos/generated/l10n.dart' as lang;
import '../../currency.dart';

class SalesScreen extends StatefulWidget {
  const SalesScreen({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _SalesScreenState createState() => _SalesScreenState();
}

class _SalesScreenState extends State<SalesScreen> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return await const HomeScreen().launch(context);
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            lang.S.of(context).saleList,
            style: GoogleFonts.poppins(
              color: Colors.black,
              fontSize: 20.0,
            ),
          ),
          iconTheme: const IconThemeData(color: Colors.black),
          centerTitle: true,
          backgroundColor: Colors.white,
          elevation: 0.0,
        ),
        body: Column(
          children: [
            const SizedBox(
              height: 10.0,
            ),
            Hero(
              tag: 'TabButton',
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TabButton(
                    background: Constants.kMainColor,
                    text: Colors.white,
                    title: 'Sales',
                    press: () {
                      Navigator.pushNamed(context, '/SalesList');
                    },
                  ),
                  const SizedBox(
                    width: 20.0,
                  ),
                  TabButton(
                    background: kDarkWhite,
                    text: Constants.kMainColor,
                    title: 'Paid',
                    press: () {
                      Navigator.pushNamed(context, '/Paid');
                    },
                  ),
                  const SizedBox(
                    width: 20.0,
                  ),
                  TabButton(
                    background: kDarkWhite,
                    text: Constants.kMainColor,
                    title: 'Due',
                    press: () {
                      Navigator.pushNamed(context, '/Due');
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 10.0,
            ),
            DataTable(
              headingRowColor:
                  MaterialStateColor.resolveWith((states) => kDarkWhite),
              columns: const <DataColumn>[
                DataColumn(
                  label: SizedBox(
                    width: 100.0,
                    child: Text(
                      'Date',
                    ),
                  ),
                ),
                DataColumn(
                  label: SizedBox(
                    width: 60.0,
                    child: Text(
                      'Payment',
                    ),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Balance',
                  ),
                ),
              ],
              rows: <DataRow>[
                DataRow(
                  cells: <DataCell>[
                    DataCell(
                      Column(
                        children: [
                          Text(
                            'Ibne Riead',
                            textAlign: TextAlign.start,
                            style: GoogleFonts.poppins(
                              color: Colors.black,
                              fontSize: 15.0,
                            ),
                          ),
                          Text(
                            'July 10, 2021',
                            textAlign: TextAlign.start,
                            style: GoogleFonts.poppins(
                              color: kGreyTextColor,
                              fontSize: 10.0,
                            ),
                          )
                        ],
                      ),
                    ),
                    const DataCell(
                      Text('Cash'),
                    ),
                    DataCell(
                      Text('$currency 3975'),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
