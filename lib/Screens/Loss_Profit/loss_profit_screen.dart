import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:mobile_pos/Provider/all_expanse_provider.dart';
import 'package:mobile_pos/Provider/printer_provider.dart';
import 'package:mobile_pos/Provider/transactions_provider.dart';
import 'package:mobile_pos/Screens/Loss_Profit/single_loss_profit_screen.dart';
import 'package:mobile_pos/model/expense_model.dart';
import 'package:mobile_pos/model/print_transaction_model.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../Provider/profile_provider.dart';
import '../../../constant.dart';
import '../../currency.dart';
import 'package:mobile_pos/generated/l10n.dart' as lang;

class LossProfitScreen extends StatefulWidget {
  const LossProfitScreen({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _LossProfitScreenState createState() => _LossProfitScreenState();
}

class _LossProfitScreenState extends State<LossProfitScreen> {
  TextEditingController fromDateTextEditingController =
      TextEditingController(text: DateFormat.yMMMd().format(DateTime(2021)));
  TextEditingController toDateTextEditingController =
      TextEditingController(text: DateFormat.yMMMd().format(DateTime.now()));
  DateTime fromDate = DateTime(2021);
  DateTime toDate = DateTime.now();

  double totalLoss = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          lang.S.of(context).lp,
          style: GoogleFonts.poppins(
            color: Colors.black,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
        centerTitle: true,
        elevation: 0.0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Consumer(builder: (context, ref, __) {
              final providerData = ref.watch(transitionProvider);
              final printerData = ref.watch(printerProviderNotifier);
              final personalData = ref.watch(profileDetailsProvider);
              final expenseData = ref.watch(expenseProvider);
              expenseData.when(data: (mainData) {
                if (mainData.isNotEmpty) {
                  final List<ExpenseModel> data = mainData.reversed.toList();
                  totalExpense = 0;
                  for (var element in data) {
                    if ((fromDate.isBefore(
                                DateTime.parse(element.expenseDate)) ||
                            DateTime.parse(element.expenseDate)
                                .isAtSameMomentAs(fromDate)) &&
                        (toDate.isAfter(DateTime.parse(element.expenseDate)) ||
                            DateTime.parse(element.expenseDate)
                                .isAtSameMomentAs(toDate))) {
                      totalExpense += element.amount.toDouble();
                    }
                  }
                }
              }, error: (Object error, StackTrace? stackTrace) {
                return Text(error.toString());
              }, loading: () {
                return Center(
                    child: CircularProgressIndicator(
                  color: Constants.kMainColor,
                ));
              });

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
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.always,
                                labelText: lang.S.of(context).fromDate,
                                border: const OutlineInputBorder(),
                                suffixIcon: IconButton(
                                  onPressed: () async {
                                    final DateTime? picked =
                                        await showDatePicker(
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
                                      totalLoss = 0;
                                      totalProfit = 0;
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
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.always,
                                labelText: lang.S.of(context).toDate,
                                border: const OutlineInputBorder(),
                                suffixIcon: IconButton(
                                  onPressed: () async {
                                    final DateTime? picked =
                                        await showDatePicker(
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
                                      totalLoss = 0;
                                      totalProfit = 0;
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
                      totalProfit = 0;
                      for (var element in reTransaction) {
                        if ((fromDate.isBefore(
                                    DateTime.parse(element.purchaseDate)) ||
                                DateTime.parse(element.purchaseDate)
                                    .isAtSameMomentAs(fromDate)) &&
                            (toDate.isAfter(
                                    DateTime.parse(element.purchaseDate)) ||
                                DateTime.parse(element.purchaseDate)
                                    .isAtSameMomentAs(toDate))) {
                          element.lossProfit!.isNegative
                              ? totalLoss =
                                  totalLoss + element.lossProfit!.abs()
                              : totalProfit = totalProfit + element.lossProfit!;
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
                                        color: Constants.kMainColor
                                            .withOpacity(0.1),
                                        border: Border.all(
                                            width: 1,
                                            color: Constants.kMainColor),
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
                                              "${totalProfit - totalExpense}",
                                              style: const TextStyle(
                                                color: Colors.green,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            //const SizedBox(height: 10),
                                            Column(
                                              children: [
                                                Text.rich(
                                                  TextSpan(
                                                      text: lang.S
                                                          .of(context)
                                                          .profit,
                                                      style: const TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                      children: [
                                                        const TextSpan(
                                                          text: " - ",
                                                          style: TextStyle(
                                                            color:
                                                                kPremiumPlanColor2,
                                                            fontSize: 12,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                        TextSpan(
                                                          text: lang.S
                                                              .of(context)
                                                              .expenses,
                                                          style:
                                                              const TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 12,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                      ]),
                                                ),
                                                Text.rich(
                                                  TextSpan(
                                                      text: "$totalProfit",
                                                      style: const TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                      children: [
                                                        const TextSpan(
                                                          text: " - ",
                                                          style: TextStyle(
                                                            color:
                                                                kPremiumPlanColor2,
                                                            fontSize: 12,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                        TextSpan(
                                                          text: "$totalExpense",
                                                          style:
                                                              const TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 12,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                      ]),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        Container(
                                          width: 1,
                                          height: 60,
                                          color: Constants.kMainColor,
                                        ),
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Text(
                                              totalLoss.toString(),
                                              style: const TextStyle(
                                                color: Colors.orange,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            const SizedBox(height: 10),
                                            Text(
                                              lang.S.of(context).loss,
                                              style: const TextStyle(
                                                color: Colors.black,
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
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
                                    return (fromDate.isBefore(DateTime.parse(
                                                    reTransaction[index]
                                                        .purchaseDate)) ||
                                                DateTime.parse(
                                                        reTransaction[index]
                                                            .purchaseDate)
                                                    .isAtSameMomentAs(
                                                        fromDate)) &&
                                            (toDate.isAfter(DateTime.parse(
                                                    reTransaction[index]
                                                        .purchaseDate)) ||
                                                DateTime.parse(
                                                        reTransaction[index].purchaseDate)
                                                    .isAtSameMomentAs(toDate))
                                        ? GestureDetector(
                                            onTap: () {
                                              SingleLossProfitScreen(
                                                transactionModel:
                                                    reTransaction[index],
                                              ).launch(context);
                                            },
                                            child: Column(
                                              children: [
                                                Container(
                                                  padding:
                                                      const EdgeInsets.all(20),
                                                  width: context.width(),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Text(
                                                            reTransaction[index]
                                                                    .customerName
                                                                    .isNotEmpty
                                                                ? reTransaction[
                                                                        index]
                                                                    .customerName
                                                                : reTransaction[
                                                                        index]
                                                                    .customerPhone,
                                                            style:
                                                                const TextStyle(
                                                              fontSize: 14,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                            ),
                                                          ),
                                                          Text(
                                                            '#${reTransaction[index].invoiceNumber}',
                                                            style:
                                                                const TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontSize: 12,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      const SizedBox(
                                                          height: 10),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Container(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(8),
                                                            decoration: BoxDecoration(
                                                                color: reTransaction[index]
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
                                                                        Radius.circular(
                                                                            10))),
                                                            child: Text(
                                                              reTransaction[index]
                                                                          .dueAmount! <=
                                                                      0
                                                                  ? lang.S
                                                                      .of(
                                                                          context)
                                                                      .paid
                                                                  : lang.S
                                                                      .of(context)
                                                                      .unPaid,
                                                              style: TextStyle(
                                                                color: reTransaction[index]
                                                                            .dueAmount! <=
                                                                        0
                                                                    ? const Color(
                                                                        0xff0dbf7d)
                                                                    : const Color(
                                                                        0xFFED1A3B),
                                                                fontSize: 12,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                            ),
                                                          ),
                                                          Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .end,
                                                            children: [
                                                              Text(
                                                                DateFormat
                                                                        .yMMMd()
                                                                    .format(DateTime.parse(
                                                                        reTransaction[index]
                                                                            .purchaseDate)),
                                                                style:
                                                                    const TextStyle(
                                                                  color: Colors
                                                                      .grey,
                                                                  fontSize: 12,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                ),
                                                              ),
                                                              const SizedBox(
                                                                  height: 5),
                                                              Text(
                                                                DateFormat.jm().format(
                                                                    DateTime.parse(
                                                                        reTransaction[index]
                                                                            .purchaseDate)),
                                                                style:
                                                                    const TextStyle(
                                                                  color: Colors
                                                                      .grey,
                                                                  fontSize: 12,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                      const SizedBox(height: 5),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Text(
                                                                  '${lang.S.of(context).total} : $currency ${reTransaction[index].totalAmount.toString()}',
                                                                  style:
                                                                      const TextStyle(
                                                                    color: Colors
                                                                        .grey,
                                                                    fontSize:
                                                                        12,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                  ),
                                                                ),
                                                                const SizedBox(
                                                                    height: 5),
                                                                Text(
                                                                  '${lang.S.of(context).profit} : $currency ${reTransaction[index].lossProfit}',
                                                                  style:
                                                                      TextStyle(
                                                                    color: Constants
                                                                        .kMainColor,
                                                                    fontSize:
                                                                        12,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                  ),
                                                                ).visible(!reTransaction[
                                                                        index]
                                                                    .lossProfit!
                                                                    .isNegative),
                                                                Text(
                                                                  '${lang.S.of(context).loss}: $currency ${reTransaction[index].lossProfit!.abs()}',
                                                                  style:
                                                                      const TextStyle(
                                                                    color: Colors
                                                                        .redAccent,
                                                                    fontSize:
                                                                        12,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                  ),
                                                                ).visible(reTransaction[
                                                                        index]
                                                                    .lossProfit!
                                                                    .isNegative),
                                                              ]),
                                                          personalData.when(
                                                              data: (data) {
                                                            return Row(
                                                              children: [
                                                                IconButton(
                                                                    onPressed:
                                                                        () async {
                                                                      totalProfit =
                                                                          0;
                                                                      totalLoss =
                                                                          0;
                                                                      await printerData
                                                                          .getBluetooth();
                                                                      PrintTransactionModel
                                                                          model =
                                                                          PrintTransactionModel(
                                                                              transitionModel: reTransaction[index],
                                                                              personalInformationModel: data);
                                                                      connected
                                                                          ? printerData
                                                                              .printTicket(
                                                                              printTransactionModel: model,
                                                                              productList: model.transitionModel!.productList,
                                                                            )
                                                                          // ignore: use_build_context_synchronously
                                                                          : showDialog(
                                                                              context: context,
                                                                              builder: (_) {
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
                                                                                          Padding(
                                                                                            padding: const EdgeInsets.only(top: 20, bottom: 10),
                                                                                            child: Text(
                                                                                              lang.S.of(context).pleaseConnectYourBlutohPrinter,
                                                                                              style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                                                                                            ),
                                                                                          ),
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
                                                                    },
                                                                    icon: Icon(
                                                                      FeatherIcons
                                                                          .printer,
                                                                      color: Constants
                                                                          .kMainColor,
                                                                    )),
                                                                IconButton(
                                                                    onPressed: () =>
                                                                        toast(
                                                                            'Coming Soon'),
                                                                    icon: Icon(
                                                                      FeatherIcons
                                                                          .share,
                                                                      color: Constants
                                                                          .kMainColor,
                                                                    )).visible(true),
                                                              ],
                                                            );
                                                          }, error: (e, stack) {
                                                            return Text(
                                                                e.toString());
                                                          }, loading: () {
                                                            return const Text(
                                                                'Loading');
                                                          }),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Container(
                                                  height: 0.5,
                                                  width: context.width(),
                                                  color: Colors.grey,
                                                )
                                              ],
                                            ),
                                          )
                                        : Container();
                                  },
                                ),
                              ],
                            )
                          : const Padding(
                              padding: EdgeInsets.only(top: 60),
                              child: Text("Please make a sale first"),
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
          ],
        ),
      ),
    );
  }
}
