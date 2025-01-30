import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:mobile_pos/Provider/add_to_cart.dart';
import 'package:mobile_pos/Provider/printer_provider.dart';
import 'package:mobile_pos/Provider/transactions_provider.dart';
import 'package:mobile_pos/Screens/Sales%20List/sales_report_edit_screen.dart';
import 'package:mobile_pos/model/print_transaction_model.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../Provider/profile_provider.dart';
import '../../../constant.dart';
import '../../GlobalComponents/generate_pdf.dart';
import '../../currency.dart';
import '../Home/Dashboard.dart';
import '../invoice_details/sales_invoice_details_screen.dart';
import 'package:mobile_pos/generated/l10n.dart' as lang;

class SalesListScreen extends StatefulWidget {
  const SalesListScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SalesListScreenState createState() => _SalesListScreenState();
}

class _SalesListScreenState extends State<SalesListScreen> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return await const Dashboard().launch(context, isNewTask: true);
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
        body: Consumer(builder: (context, ref, __) {
          final providerData = ref.watch(transitionProvider);
          final profile = ref.watch(profileDetailsProvider);
          final printerData = ref.watch(printerProviderNotifier);
          final personalData = ref.watch(profileDetailsProvider);
          final cart = ref.watch(cartNotifier);
          return SingleChildScrollView(
            child: providerData.when(data: (transaction) {
              final reTransaction = transaction.reversed.toList();
              return reTransaction.isNotEmpty
                  ? ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: reTransaction.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            SalesInvoiceDetails(
                              transitionModel: reTransaction[index],
                              personalInformationModel: profile.value!,
                            ).launch(context);
                          },
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Constants().kBgColor,
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(8)),
                                  ),
                                  padding: const EdgeInsets.all(10),
                                  width: context.width(),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            reTransaction[index].customerName,
                                            style:
                                                const TextStyle(fontSize: 16),
                                          ),
                                          Text(
                                              '#${reTransaction[index].invoiceNumber}'),
                                        ],
                                      ),
                                      const SizedBox(height: 10),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.all(8),
                                            decoration: BoxDecoration(
                                                color: reTransaction[index]
                                                            .dueAmount! <=
                                                        0
                                                    ? const Color(0xff0dbf7d)
                                                        .withOpacity(0.1)
                                                    : const Color(0xFFED1A3B)
                                                        .withOpacity(0.1),
                                                borderRadius:
                                                    const BorderRadius.all(
                                                        Radius.circular(10))),
                                            child: Text(
                                              reTransaction[index].dueAmount! <=
                                                      0
                                                  ? lang.S.of(context).paid
                                                  : lang.S.of(context).unPaid,
                                              style: TextStyle(
                                                  color: reTransaction[index]
                                                              .dueAmount! <=
                                                          0
                                                      ? const Color(0xff0dbf7d)
                                                      : const Color(
                                                          0xFFED1A3B)),
                                            ),
                                          ),
                                          Text(
                                            DateFormat.yMMMd().format(
                                                DateTime.parse(
                                                    reTransaction[index]
                                                        .purchaseDate)),
                                            style: const TextStyle(
                                                color: Colors.grey),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 10),
                                      Text(
                                        ' ${lang.S.of(context).total} : $currency ${reTransaction[index].totalAmount.toString()}',
                                        style:
                                            const TextStyle(color: Colors.grey),
                                      ),
                                      const SizedBox(height: 10),
                                      Text(
                                        '${lang.S.of(context).paid} : $currency ${reTransaction[index].totalAmount!.toDouble() - reTransaction[index].dueAmount!.toDouble()}',
                                        style:
                                            const TextStyle(color: Colors.grey),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            '${lang.S.of(context).due}: $currency ${reTransaction[index].dueAmount.toString()}',
                                            style:
                                                const TextStyle(fontSize: 16),
                                          ).visible(reTransaction[index]
                                                  .dueAmount!
                                                  .toInt() !=
                                              0),
                                          personalData.when(data: (data) {
                                            return Row(
                                              children: [
                                                IconButton(
                                                    onPressed: () async {
                                                      await printerData
                                                          .getBluetooth();
                                                      PrintTransactionModel
                                                          model =
                                                          PrintTransactionModel(
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
                                                              context: context,
                                                              builder: (_) {
                                                                return WillPopScope(
                                                                  onWillPop:
                                                                      () async =>
                                                                          false,
                                                                  child: Dialog(
                                                                    child:
                                                                        SizedBox(
                                                                      child:
                                                                          Column(
                                                                        mainAxisSize:
                                                                            MainAxisSize.min,
                                                                        children: [
                                                                          ListView
                                                                              .builder(
                                                                            shrinkWrap:
                                                                                true,
                                                                            itemCount: printerData.availableBluetoothDevices.isNotEmpty
                                                                                ? printerData.availableBluetoothDevices.length
                                                                                : 0,
                                                                            itemBuilder:
                                                                                (context, index) {
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
                                                                                subtitle: const Text("Click to connect"),
                                                                              );
                                                                            },
                                                                          ),
                                                                          const SizedBox(
                                                                              height: 10),
                                                                          const Text(
                                                                              'Connect Your printer'),
                                                                          const SizedBox(
                                                                              height: 10),
                                                                          Container(
                                                                              height: 1,
                                                                              width: double.infinity,
                                                                              color: Constants().kBgColor),
                                                                          const SizedBox(
                                                                              height: 15),
                                                                          GestureDetector(
                                                                            onTap:
                                                                                () {
                                                                              Navigator.pop(context);
                                                                            },
                                                                            child:
                                                                                Center(
                                                                              child: Text(
                                                                                'Cancel',
                                                                                style: TextStyle(color: Constants.kMainColor),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          const SizedBox(
                                                                              height: 15),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ),
                                                                );
                                                              });
                                                    },
                                                    icon: Icon(
                                                      FeatherIcons.printer,
                                                      color:
                                                          Constants.kMainColor,
                                                    )),
                                                IconButton(
                                                    onPressed: () => GeneratePdf()
                                                        .generateSaleDocument(
                                                            reTransaction[
                                                                index],
                                                            data,
                                                            context),
                                                    icon: Icon(
                                                      Icons.picture_as_pdf,
                                                      color:
                                                          Constants.kMainColor,
                                                    )),
                                                IconButton(
                                                    onPressed: () {
                                                      cart.clearCart();
                                                      SalesReportEditScreen(
                                                        transitionModel:
                                                            reTransaction[
                                                                index],
                                                      ).launch(context);
                                                    },
                                                    icon: Icon(
                                                      FeatherIcons.edit,
                                                      color:
                                                          Constants.kMainColor,
                                                    )),
                                              ],
                                            );
                                          }, error: (e, stack) {
                                            return Text(e.toString());
                                          }, loading: () {
                                            return const Text('Loading');
                                          }),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              // Container(
                              //   height: 0.5,
                              //   width: context.width(),
                              //   color: Colors.grey,
                              // )
                            ],
                          ),
                        );
                      },
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
          );
        }),
      ),
    );
  }
}
