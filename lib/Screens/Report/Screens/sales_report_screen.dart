import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:mobile_pos/Provider/printer_provider.dart';
import 'package:mobile_pos/Provider/transactions_provider.dart';
import 'package:mobile_pos/model/print_transaction_model.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:path_provider/path_provider.dart';

import '../../../GlobalComponents/generate_pdf.dart';
import '../../../Provider/profile_provider.dart';
import '../../../constant.dart';
import '../../../currency.dart';
import '../../Home/Dashboard.dart';
import '../../invoice_details/sales_invoice_details_screen.dart';
import 'package:mobile_pos/generated/l10n.dart' as lang;

class SalesReportScreen extends StatefulWidget {
  const SalesReportScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SalesReportScreenState createState() => _SalesReportScreenState();
}

class _SalesReportScreenState extends State<SalesReportScreen> {
  TextEditingController fromDateTextEditingController = TextEditingController(
      text: DateFormat.yMMMd()
          .format(DateTime(DateTime.now().year, DateTime.now().month, 1)));
  TextEditingController toDateTextEditingController =
      TextEditingController(text: DateFormat.yMMMd().format(DateTime.now()));
  DateTime fromDate = DateTime(DateTime.now().year, DateTime.now().month, 1);
  DateTime toDate = DateTime.now();
  double totalSale = 0;
  List<String> timeLimit = [
    'ToDay',
    'This Week',
    'This Month',
    'This Year',
    'All Time',
    'Custom'
  ];
  String? dropdownValue = 'This Month';

  void changeDate({required DateTime from}) {
    setState(() {
      fromDate = from;
      fromDateTextEditingController =
          TextEditingController(text: DateFormat.yMMMd().format(from));

      toDate = DateTime.now();
      toDateTextEditingController = TextEditingController(
          text: DateFormat.yMMMd().format(DateTime(
              DateTime.now().year, DateTime.now().month, DateTime.now().day)));
    });
  }

  Future<String> getPDFPath({required String data}) async {
    Directory appDocDir = await getApplicationDocumentsDirectory();
    String appDocPath = appDocDir.path;
    return '$appDocPath/your_pdf_file.pdf'; // Replace with the actual file name
  }

  @override
  Widget build(BuildContext context) {
    totalSale = 0;
    return WillPopScope(
      onWillPop: () async {
        return await const Dashboard().launch(context, isNewTask: true);
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            lang.S.of(context).salesReport,
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
          final providerData = ref.watch(transitionProvider);
          final printerData = ref.watch(printerProviderNotifier);
          final personalData = ref.watch(profileDetailsProvider);
          return SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                      right: 20.0, left: 20.0, top: 20, bottom: 10),
                  child: Row(
                    children: [
                      Expanded(
                        child: AppTextField(
                          textFieldType: TextFieldType.NAME,
                          readOnly: true,
                          controller: fromDateTextEditingController,
                          decoration: InputDecoration(
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Constants
                                      .kMainColor), // Change the border color when focused
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Constants()
                                      .kBgColor), // Change the border color when not focused
                            ),
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            labelText: lang.S.of(context).fromDate,
                            border: const OutlineInputBorder(),
                            suffixIcon: IconButton(
                              onPressed: () async {
                                final DateTime? picked = await showDatePicker(
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(2015, 8),
                                  lastDate: DateTime(2101),
                                  context: context,
                                );
                                setState(() {
                                  fromDateTextEditingController.text =
                                      DateFormat.yMMMd()
                                          .format(picked ?? DateTime.now());
                                  fromDate = picked!;
                                  totalSale = 0;
                                  dropdownValue = 'Custom';
                                });
                              },
                              icon: Icon(
                                FeatherIcons.calendar,
                                color: Constants.kMainColor,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: AppTextField(
                          textFieldType: TextFieldType.NAME,
                          readOnly: true,
                          controller: toDateTextEditingController,
                          decoration: InputDecoration(
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Constants
                                      .kMainColor), // Change the border color when focused
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Constants()
                                      .kBgColor), // Change the border color when not focused
                            ),
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            labelText: lang.S.of(context).toDate,
                            border: const OutlineInputBorder(),
                            suffixIcon: IconButton(
                              onPressed: () async {
                                final DateTime? picked = await showDatePicker(
                                  initialDate: toDate,
                                  firstDate: DateTime(2015, 8),
                                  lastDate: DateTime(2101),
                                  context: context,
                                );

                                setState(() {
                                  toDateTextEditingController.text =
                                      DateFormat.yMMMd()
                                          .format(picked ?? DateTime.now());
                                  picked!.isToday
                                      ? toDate = DateTime.now()
                                      : toDate = picked;
                                  totalSale = 0;
                                  dropdownValue = 'Custom';
                                });
                              },
                              icon: Icon(
                                FeatherIcons.calendar,
                                color: Constants.kMainColor,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                providerData.when(data: (transaction) {
                  final reTransaction = transaction.reversed.toList();

                  for (var element in reTransaction) {
                    if ((fromDate.isBefore(
                                DateTime.parse(element.purchaseDate)) ||
                            DateTime.parse(element.purchaseDate)
                                .isAtSameMomentAs(fromDate)) &&
                        (toDate.isAfter(DateTime.parse(element.purchaseDate)) ||
                            DateTime.parse(element.purchaseDate)
                                .isAtSameMomentAs(toDate))) {
                      totalSale = totalSale + element.totalAmount!;
                    }
                  }

                  return reTransaction.isNotEmpty
                      ? Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Container(
                                height: 100,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                    color:
                                        Constants.kMainColor.withOpacity(0.1),
                                    border: Border.all(
                                        width: 1, color: Constants.kMainColor),
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(15))),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          totalSale.toStringAsFixed(2),
                                          style: const TextStyle(
                                            color: Colors.green,
                                            fontSize: 20,
                                          ),
                                        ),
                                        const SizedBox(height: 10),
                                        const Text(
                                          'Total Sales',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Container(
                                      width: 1,
                                      height: 60,
                                      color: Constants.kMainColor,
                                    ),
                                    Container(
                                      height: 40,
                                      width: 150,
                                      padding: const EdgeInsets.all(5),
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              color: Constants.kMainColor,
                                              width: 1),
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(8))),
                                      child: DropdownButtonHideUnderline(
                                        child: DropdownButton(
                                          underline: null,
                                          // underline: const Divider(color: Colors.black),
                                          value: dropdownValue,
                                          icon: const Icon(
                                              Icons.keyboard_arrow_down),
                                          items: timeLimit.map((String items) {
                                            return DropdownMenuItem(
                                              value: items,
                                              child: Text(items),
                                            );
                                          }).toList(),
                                          onChanged: (newValue) {
                                            setState(() {
                                              dropdownValue =
                                                  newValue.toString();

                                              switch (newValue) {
                                                case 'ToDay':
                                                  changeDate(
                                                      from: DateTime(
                                                          DateTime.now().year,
                                                          DateTime.now().month,
                                                          DateTime.now().day));
                                                  break;
                                                case 'This Week':
                                                  changeDate(
                                                      from: DateTime(
                                                          DateTime.now().year,
                                                          DateTime.now().month,
                                                          DateTime.now()
                                                              .weekday));
                                                  break;
                                                case 'This Month':
                                                  changeDate(
                                                      from: DateTime(
                                                          DateTime.now().year,
                                                          DateTime.now().month,
                                                          1));
                                                  break;
                                                case 'This Year':
                                                  changeDate(
                                                      from: DateTime(
                                                          DateTime.now().year,
                                                          1,
                                                          1));
                                                  break;
                                                case 'All Time':
                                                  changeDate(
                                                      from:
                                                          DateTime(2020, 1, 1));
                                                  break;
                                              }
                                            });
                                          },
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: reTransaction.length,
                              itemBuilder: (context, index) {
                                return Visibility(
                                  visible: (fromDate.isBefore(DateTime.parse(
                                              reTransaction[index]
                                                  .purchaseDate)) ||
                                          DateTime.parse(reTransaction[index].purchaseDate)
                                              .isAtSameMomentAs(fromDate)) &&
                                      (toDate.isAfter(DateTime.parse(
                                              reTransaction[index]
                                                  .purchaseDate)) ||
                                          DateTime.parse(reTransaction[index]
                                                  .purchaseDate)
                                              .isAtSameMomentAs(toDate)),
                                  child: GestureDetector(
                                    onTap: () {
                                      SalesInvoiceDetails(
                                        transitionModel: reTransaction[index],
                                        personalInformationModel:
                                            personalData.value!,
                                      ).launch(context);
                                    },
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Container(
                                            padding: const EdgeInsets.all(10),
                                            decoration: BoxDecoration(
                                              color: Constants().kBgColor,
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(8)),
                                            ),
                                            width: context.width(),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  reTransaction[index]
                                                      .customerName,
                                                  style: const TextStyle(
                                                      fontSize: 16),
                                                ),
                                                const SizedBox(height: 5),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Container(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 8),
                                                      decoration: BoxDecoration(
                                                        color: reTransaction[
                                                                        index]
                                                                    .dueAmount! <=
                                                                0
                                                            ? const Color(
                                                                    0xff0dbf7d)
                                                                .withOpacity(
                                                                    0.1)
                                                            : const Color(
                                                                    0xFFED1A3B)
                                                                .withOpacity(
                                                                    0.1),
                                                        borderRadius:
                                                            const BorderRadius
                                                                .all(
                                                          Radius.circular(5),
                                                        ),
                                                      ),
                                                      child: Text(
                                                        reTransaction[index]
                                                                    .dueAmount! <=
                                                                0
                                                            ? lang.S
                                                                .of(context)
                                                                .paid
                                                            : lang.S
                                                                .of(context)
                                                                .unPaid,
                                                        style: TextStyle(
                                                            color: reTransaction[
                                                                            index]
                                                                        .dueAmount! <=
                                                                    0
                                                                ? const Color(
                                                                    0xff0dbf7d)
                                                                : const Color(
                                                                    0xFFED1A3B)),
                                                      ),
                                                    ),
                                                    Text(
                                                        '#${reTransaction[index].invoiceNumber}'),
                                                  ],
                                                ),
                                                const SizedBox(height: 5),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      '  ${lang.S.of(context).total} : $currency ${reTransaction[index].totalAmount.toString()}',
                                                      style: const TextStyle(
                                                          color: Colors.grey),
                                                    ),
                                                    Text(
                                                      DateFormat.yMMMd().format(
                                                          DateTime.parse(
                                                              reTransaction[
                                                                      index]
                                                                  .purchaseDate)),
                                                      style: const TextStyle(
                                                          color: Colors.grey),
                                                    ),
                                                  ],
                                                ),
                                                //const SizedBox(height: 5),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      '${lang.S.of(context).paid} : $currency ${reTransaction[index].totalAmount!.toDouble() - reTransaction[index].dueAmount!.toDouble()}',
                                                      style: const TextStyle(
                                                          color: Colors.grey),
                                                    ),
                                                    personalData.when(
                                                        data: (data) {
                                                      return Row(
                                                        children: [
                                                          IconButton(
                                                              onPressed:
                                                                  () async {
                                                                if ((Theme.of(
                                                                            context)
                                                                        .platform ==
                                                                    TargetPlatform
                                                                        .android)) {
                                                                  await printerData
                                                                      .getBluetooth();
                                                                  PrintTransactionModel model = PrintTransactionModel(
                                                                      transitionModel:
                                                                          reTransaction[
                                                                              index],
                                                                      personalInformationModel:
                                                                          data);
                                                                  connected
                                                                      ? printerData
                                                                          .printTicket(
                                                                          printTransactionModel:
                                                                              model,
                                                                          productList: model
                                                                              .transitionModel!
                                                                              .productList,
                                                                        )
                                                                      // ignore: use_build_context_synchronously
                                                                      : showDialog(
                                                                          context:
                                                                              context,
                                                                          builder:
                                                                              (_) {
                                                                            return WillPopScope(
                                                                              onWillPop: () async => false,
                                                                              child: Dialog(
                                                                                child: SizedBox(
                                                                                  child: Column(
                                                                                    mainAxisSize: MainAxisSize.min,
                                                                                    children: [
                                                                                      ListView.builder(
                                                                                        shrinkWrap: true,
                                                                                        itemCount: printerData.availableBluetoothDevices.isNotEmpty ? printerData.availableBluetoothDevices.length : 0,
                                                                                        itemBuilder: (context, index) {
                                                                                          return ListTile(
                                                                                            onTap: () async {
                                                                                              String select = printerData.availableBluetoothDevices[index];
                                                                                              List list = select.split("#");
                                                                                              // String name = list[0];
                                                                                              String mac = list[1];
                                                                                              bool isConnect = await printerData.setConnect(mac);
                                                                                              // ignore: use_build_context_synchronously
                                                                                              isConnect
                                                                                                  // ignore: use_build_context_synchronously
                                                                                                  ? finish(context)
                                                                                                  : toast('Try Again');
                                                                                            },
                                                                                            title: Text('${printerData.availableBluetoothDevices[index]}'),
                                                                                            subtitle: Text(lang.S.of(context).clickToConnect),
                                                                                          );
                                                                                        },
                                                                                      ),
                                                                                      const SizedBox(height: 10),
                                                                                      Text(lang.S.of(context).connectPrinter),
                                                                                      const SizedBox(height: 10),
                                                                                      Container(height: 1, width: double.infinity, color: Constants().kBgColor),
                                                                                      const SizedBox(height: 15),
                                                                                      GestureDetector(
                                                                                        onTap: () {
                                                                                          Navigator.pop(context);
                                                                                        },
                                                                                        child: Center(
                                                                                          child: Text(
                                                                                            lang.S.of(context).cancel,
                                                                                            style: TextStyle(color: Constants.kMainColor),
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                      const SizedBox(height: 15),
                                                                                    ],
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            );
                                                                          });
                                                                }
                                                              },
                                                              icon: Icon(
                                                                FeatherIcons
                                                                    .printer,
                                                                color: Constants
                                                                    .kMainColor,
                                                              )),
                                                          IconButton(
                                                              onPressed: () => GeneratePdf()
                                                                  .generateSaleDocument(
                                                                      reTransaction[
                                                                          index],
                                                                      data,
                                                                      context),
                                                              icon: Icon(
                                                                Icons
                                                                    .picture_as_pdf,
                                                                color: Constants
                                                                    .kMainColor,
                                                              )),
                                                        ],
                                                      );
                                                    }, error: (e, stack) {
                                                      return Text(e.toString());
                                                    }, loading: () {
                                                      return const Text(
                                                          'Loading');
                                                    }),
                                                  ],
                                                ),
                                                Text(
                                                  '${lang.S.of(context).due}: $currency ${reTransaction[index].dueAmount.toString()}',
                                                  style: const TextStyle(
                                                      fontSize: 16),
                                                ).visible(reTransaction[index]
                                                        .dueAmount!
                                                        .toInt() !=
                                                    0),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Container(
                                          height: 0.5,
                                          width: context.width(),
                                          color: Constants().kBgColor,
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        )
                      : Center(
                          child: Text(
                            lang.S.of(context).addSale,
                            maxLines: 2,
                            style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 20.0),
                          ),
                        );
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
          );
        }),
      ),
    );
  }
}
