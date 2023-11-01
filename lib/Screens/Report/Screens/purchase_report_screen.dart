import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_pos/Provider/purchase_report_provider.dart';
import 'package:mobile_pos/Screens/Home/home_screen.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../../constant.dart';

class PurchaseReportScreen extends StatefulWidget {
  const PurchaseReportScreen({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _PurchaseReportScreenState createState() => _PurchaseReportScreenState();
}

class _PurchaseReportScreenState extends State<PurchaseReportScreen> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return await const HomeScreen().launch(context, isNewTask: true);
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Purchase Report',
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
        body: Consumer(builder: (context, ref, __) {
          final providerData = ref.watch(purchaseReportProvider);
          return SingleChildScrollView(
            child: Column(
              children: [
                Column(
                  children: [
                    const SizedBox(height: 10.0),
                    // Row(
                    //   children: [
                    //     Expanded(
                    //       child: Padding(
                    //         padding: const EdgeInsets.all(4.0),
                    //         child: AppTextField(
                    //           textFieldType: TextFieldType.NAME,
                    //           readOnly: true,
                    //           onTap: () async {
                    //             var date = await showDatePicker(
                    //                 context: context,
                    //                 initialDate: DateTime.now(),
                    //                 firstDate: DateTime(1900),
                    //                 lastDate: DateTime(2100));
                    //             dateController.text =
                    //                 date.toString().substring(0, 10);
                    //           },
                    //           controller: dateController,
                    //           decoration: InputDecoration(
                    //               border: OutlineInputBorder(),
                    //               floatingLabelBehavior:
                    //               FloatingLabelBehavior.always,
                    //               labelText: 'Start Date',
                    //               hintText: 'Pick Start Date'),
                    //         ),
                    //       ),
                    //     ),
                    //     Expanded(
                    //       child: Padding(
                    //         padding: const EdgeInsets.all(4.0),
                    //         child: AppTextField(
                    //           textFieldType: TextFieldType.OTHER,
                    //           readOnly: true,
                    //           onTap: () async {
                    //             var date = await showDatePicker(
                    //                 context: context,
                    //                 initialDate: DateTime.now(),
                    //                 firstDate: DateTime(1900),
                    //                 lastDate: DateTime(2100));
                    //             dateController.text =
                    //                 date.toString().substring(0, 10);
                    //           },
                    //           controller: dateController,
                    //           decoration: InputDecoration(
                    //               border: OutlineInputBorder(),
                    //               floatingLabelBehavior:
                    //               FloatingLabelBehavior.always,
                    //               labelText: 'End Date',
                    //               hintText: 'Pick End Date'),
                    //         ),
                    //       ),
                    //     ),
                    //   ],
                    // ),
                    // SizedBox(
                    //   height: 10.0,
                    // ),
                    DataTable(
                      headingRowColor: MaterialStateColor.resolveWith(
                          (states) => kDarkWhite),
                      columns: const <DataColumn>[
                        DataColumn(
                          label: Text(
                            'Customer Name',
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'QTY',
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'Price',
                          ),
                        ),
                      ],
                      rows: const [],
                    ),
                    providerData.when(data: (salesReport) {
                      return ListView.builder(
                          itemCount: salesReport.length,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 4,
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.only(left: 15.0),
                                      child: Text(
                                        salesReport[index].customerName,
                                        textAlign: TextAlign.start,
                                        style: GoogleFonts.poppins(
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Text(
                                      salesReport[index].purchaseQuantity,
                                      style: GoogleFonts.poppins(
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      salesReport[index].purchasePrice,
                                      style: GoogleFonts.poppins(
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          });
                    }, error: (e, stack) {
                      return Text(e.toString());
                    }, loading: () {
                       return Center(
                  child: CircularProgressIndicator(
                color: Constants.kMainColor,
              ));
                    }),
                  ],
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
