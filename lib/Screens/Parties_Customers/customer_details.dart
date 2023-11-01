// ignore_for_file: unused_result

import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_pos/Provider/customer_provider.dart';
import 'package:mobile_pos/Provider/print_purchase_provider.dart';
import 'package:mobile_pos/Provider/transactions_provider.dart';
import 'package:mobile_pos/Screens/Parties_Customers/edit_customer.dart';
import 'package:mobile_pos/Screens/Settings/Profile_Widget.dart';
import 'package:mobile_pos/constant.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../GlobalComponents/button_global.dart';
import '../../Provider/printer_provider.dart';
import '../../Provider/profile_provider.dart';
import '../../currency.dart';
import '../../model/print_transaction_model.dart';
import '../invoice_details/purchase_invoice_details.dart';
import '../invoice_details/sales_invoice_details_screen.dart';
import 'Model/customer_model.dart';
import 'package:mobile_pos/generated/l10n.dart' as lang;

// ignore: must_be_immutable
class CustomerDetails extends StatefulWidget {
  CustomerDetails({Key? key, required this.customerModel}) : super(key: key);
  CustomerModel customerModel;

  @override
  State<CustomerDetails> createState() => _CustomerDetailsState();
}

class _CustomerDetailsState extends State<CustomerDetails> {
  late String customerKey;
  String buttonsSelected = '';

  void getCustomerKey(String phoneNumber) async {
    final userId = constUserId;
    await FirebaseDatabase.instance
        .ref(userId)
        .child('Customers')
        .orderByKey()
        .get()
        .then((value) {
      for (var element in value.children) {
        var data = jsonDecode(jsonEncode(element.value));
        if (data['phoneNumber'].toString() == phoneNumber) {
          customerKey = element.key.toString();
        }
      }
    });
  }

  @override
  void initState() {
    getCustomerKey(widget.customerModel.phoneNumber);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, cRef, __) {
      final providerData = cRef.watch(transitionProvider);
      final providerDataPurchase = cRef.watch(purchaseTransitionProvider);
      final printerData = cRef.watch(printerProviderNotifier);
      final printerDataPurchase = cRef.watch(printerPurchaseProviderNotifier);
      final personalData = cRef.watch(profileDetailsProvider);
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text(
            lang.S.of(context).CustomerDetails,
            style: GoogleFonts.poppins(
              fontSize: 20,
              color: Colors.black,
            ),
          ),
          actions: [
            IconButton(
              onPressed: () {
                EditCustomer(customerModel: widget.customerModel)
                    .launch(context);
              },
              icon: Icon(
                FeatherIcons.edit2,
                color: Constants.kMainColor,
              ),
            ),
            IconButton(
              onPressed: () async {
                DatabaseReference ref = FirebaseDatabase.instance
                    .ref("$constUserId/Customers/$customerKey");
                await ref.remove();
                cRef.refresh(customerProvider);
                // ignore: use_build_context_synchronously
                Navigator.pop(context);
              },
              icon: Icon(
                FeatherIcons.trash2,
                color: Constants.kMainColor,
              ),
            ),
          ],
          centerTitle: true,
          iconTheme: const IconThemeData(color: Colors.black),
          elevation: 0.0,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              //const SizedBox(height: 40),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: BigUserCard(
                  //settingColor: kPremiumPlanColor,
                  // userMoreInfo: Text(
                  //   details.businessCategory ?? '',
                  //   style: GoogleFonts.poppins(
                  //     fontSize: 15.0,
                  //     fontWeight: FontWeight.normal,
                  //     color: kDarkWhite,
                  //   ),
                  // ),
                  //backgroundMotifColor: kPremiumPlanColor,
                  userName: widget.customerModel.customerName,
                  role: Text(
                    widget.customerModel.phoneNumber,
                    style: GoogleFonts.poppins(
                      fontSize: 15.0,
                      fontWeight: FontWeight.normal,
                      color: kDarkWhite,
                    ),
                  ),
                  cardRadius: 20,
                  backgroundColor: Constants.kMainColor,
                  userProfilePic:
                      NetworkImage(widget.customerModel.profilePicture),
                  cardActionWidget: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: GestureDetector(
                          onTap: () async {
                            final Uri url = Uri.parse(
                                'tel:${widget.customerModel.phoneNumber}');

                            if (await canLaunchUrl(url)) {
                              await launchUrl(url);
                            }

                            setState(() {
                              buttonsSelected = 'Call';
                            });
                          },
                          child: Container(
                            height: 50,
                            width: 80,
                            decoration: BoxDecoration(
                                color: buttonsSelected == 'Call'
                                    ? Constants.kMainColor
                                    : Constants.kMainColor.withOpacity(0.10),
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(10))),
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    FeatherIcons.phone,
                                    size: 15,
                                    color: buttonsSelected == 'Call'
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    'Call',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: buttonsSelected == 'Call'
                                          ? Colors.white
                                          : Colors.black,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: GestureDetector(
                          onTap: () async {
                            final Uri url = Uri.parse(
                                'sms:${widget.customerModel.phoneNumber}');

                            if (await canLaunchUrl(url)) {
                              await launchUrl(url);
                            }
                            setState(() {
                              buttonsSelected = 'Message';
                            });
                          },
                          child: Container(
                            height: 50,
                            width: 80,
                            decoration: BoxDecoration(
                              color: buttonsSelected == 'Message'
                                  ? Constants.kMainColor
                                  : Constants.kMainColor.withOpacity(0.10),
                              borderRadius: const BorderRadius.all(
                                Radius.circular(10),
                              ),
                            ),
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    FeatherIcons.messageSquare,
                                    size: 15,
                                    color: buttonsSelected == 'Message'
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                  Text(
                                    'Message',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: buttonsSelected == 'Message'
                                          ? Colors.white
                                          : Colors.black,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: GestureDetector(
                          onTap: () async {
                            setState(() {
                              buttonsSelected = 'Email';
                            });
                          },
                          child: Container(
                            height: 50,
                            width: 80,
                            decoration: BoxDecoration(
                                color: buttonsSelected == 'Email'
                                    ? Constants.kMainColor
                                    : Constants.kMainColor.withOpacity(0.10),
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(10))),
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    FeatherIcons.mail,
                                    size: 15,
                                    color: buttonsSelected == 'Email'
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                  Text(
                                    'Email',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: buttonsSelected == 'Email'
                                          ? Colors.white
                                          : Colors.black,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ).visible(!isSubUser),
                ),
              ),

              Text(
                lang.S.of(context).recentTransaction,
                style: const TextStyle(fontSize: 18),
              ),
              widget.customerModel.type != 'Supplier'
                  ? providerData.when(data: (transaction) {
                      return ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: transaction.length,
                        itemBuilder: (context, index) {
                          final reTransaction = transaction.reversed.toList();
                          return reTransaction[index].customerPhone ==
                                  widget.customerModel.phoneNumber
                              ? GestureDetector(
                                  onTap: () {
                                    SalesInvoiceDetails(
                                      personalInformationModel:
                                          personalData.value!,
                                      transitionModel: reTransaction[index],
                                    ).launch(context);
                                  },
                                  child: Column(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(20),
                                        width: context.width(),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  "${lang.S.of(context).totalProduct} : ${reTransaction[index].productList!.length.toString()}",
                                                  style: const TextStyle(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                Text(
                                                  '#${reTransaction[index].invoiceNumber}',
                                                  style: const TextStyle(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 10),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Container(
                                                  padding:
                                                      const EdgeInsets.all(8),
                                                  decoration: BoxDecoration(
                                                      color: reTransaction[
                                                                      index]
                                                                  .dueAmount! <=
                                                              0
                                                          ? const Color(
                                                                  0xff0dbf7d)
                                                              .withOpacity(0.1)
                                                          : const Color(
                                                                  0xFFED1A3B)
                                                              .withOpacity(0.1),
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
                                                              0xFFED1A3B),
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                                Text(
                                                  reTransaction[index]
                                                      .purchaseDate
                                                      .substring(0, 10),
                                                  style: const TextStyle(
                                                    color: Colors.grey,
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 10),
                                            Text(
                                              '${lang.S.of(context).total} : $currency ${reTransaction[index].totalAmount.toString()}',
                                              style: const TextStyle(
                                                color: Colors.grey,
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            personalData.when(data: (data) {
                                              return Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    '${lang.S.of(context).due}: $currency ${reTransaction[index].dueAmount.toString()}',
                                                    style: TextStyle(
                                                      color: reTransaction[
                                                                      index]
                                                                  .dueAmount! >
                                                              0
                                                          ? kPremiumPlanColor2
                                                          : null,
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  Row(
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
                                                                    context:
                                                                        context,
                                                                    builder:
                                                                        (_) {
                                                                      return Dialog(
                                                                        child:
                                                                            SizedBox(
                                                                          height:
                                                                              200,
                                                                          child:
                                                                              ListView.builder(
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
                                                                                subtitle: Text(lang.S.of(context).clickToConnect),
                                                                              );
                                                                            },
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
                                                          onPressed: () {},
                                                          icon: Icon(
                                                            FeatherIcons.share,
                                                            color: Constants
                                                                .kMainColor,
                                                          )),
                                                      IconButton(
                                                          onPressed: () {},
                                                          icon: Icon(
                                                            FeatherIcons
                                                                .moreVertical,
                                                            color: Constants
                                                                .kMainColor,
                                                          )),
                                                    ],
                                                  )
                                                ],
                                              );
                                            }, error: (e, stack) {
                                              return Text(e.toString());
                                            }, loading: () {
                                              return const Text('Loading');
                                            }),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        height: 0.5,
                                        width: context.width(),
                                        color: Constants().kBgColor,
                                      )
                                    ],
                                  ),
                                )
                              : Container();
                        },
                      );
                    }, error: (e, stack) {
                      return Text(e.toString());
                    }, loading: () {
                      return Center(
                          child: CircularProgressIndicator(
                        color: Constants.kMainColor,
                      ));
                    })
                  : providerDataPurchase.when(data: (transaction) {
                      final reTransaction = transaction.reversed.toList();
                      return ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: reTransaction.length,
                        itemBuilder: (context, index) {
                          return reTransaction[index].customerPhone ==
                                  widget.customerModel.phoneNumber
                              ? GestureDetector(
                                  onTap: () {
                                    PurchaseInvoiceDetails(
                                      transitionModel: reTransaction[index],
                                      personalInformationModel:
                                          personalData.value!,
                                    ).launch(context);
                                  },
                                  child: Column(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(20),
                                        width: context.width(),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  "${lang.S.of(context).totalProduct} : ${reTransaction[index].productList!.length.toString()}",
                                                  style: const TextStyle(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                Text(
                                                  '#${reTransaction[index].invoiceNumber}',
                                                  style: const TextStyle(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 10),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Container(
                                                  padding:
                                                      const EdgeInsets.all(8),
                                                  decoration: BoxDecoration(
                                                      color: reTransaction[
                                                                      index]
                                                                  .dueAmount! <=
                                                              0
                                                          ? const Color(
                                                                  0xff0dbf7d)
                                                              .withOpacity(0.1)
                                                          : const Color(
                                                                  0xFFED1A3B)
                                                              .withOpacity(0.1),
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
                                                              0xFFED1A3B),
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                                Text(
                                                  reTransaction[index]
                                                      .purchaseDate
                                                      .substring(0, 10),
                                                  style: const TextStyle(
                                                      color: Colors.grey),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 10),
                                            Text(
                                              '${lang.S.of(context).total} : $currency ${reTransaction[index].totalAmount.toString()}',
                                              style: const TextStyle(
                                                color: Colors.grey,
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  '${lang.S.of(context).due}: $currency ${reTransaction[index].dueAmount.toString()}',
                                                  style: const TextStyle(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                personalData.when(data: (data) {
                                                  return Row(
                                                    children: [
                                                      IconButton(
                                                          onPressed: () async {
                                                            await printerData
                                                                .getBluetooth();
                                                            PrintPurchaseTransactionModel
                                                                model =
                                                                PrintPurchaseTransactionModel(
                                                              personalInformationModel:
                                                                  data,
                                                              purchaseTransitionModel:
                                                                  reTransaction[
                                                                      index],
                                                            );
                                                            connected
                                                                ? printerDataPurchase
                                                                    .printTicket(
                                                                    printTransactionModel:
                                                                        model,
                                                                    productList: model
                                                                        .purchaseTransitionModel!
                                                                        .productList,
                                                                  )
                                                                // ignore: use_build_context_synchronously
                                                                : showDialog(
                                                                    context:
                                                                        context,
                                                                    builder:
                                                                        (_) {
                                                                      return Dialog(
                                                                        child:
                                                                            SizedBox(
                                                                          height:
                                                                              200,
                                                                          child:
                                                                              ListView.builder(
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
                                                                                      // ignore: use_build_context_synchronously
                                                                                      : toast(lang.S.of(context).tryAgain);
                                                                                },
                                                                                title: Text('${printerData.availableBluetoothDevices[index]}'),
                                                                                subtitle: Text(lang.S.of(context).connect),
                                                                              );
                                                                            },
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
                                                          onPressed: () {},
                                                          icon: Icon(
                                                            FeatherIcons.share,
                                                            color: Constants
                                                                .kMainColor,
                                                          )),
                                                      IconButton(
                                                          onPressed: () {},
                                                          icon: Icon(
                                                            FeatherIcons
                                                                .moreVertical,
                                                            color: Constants
                                                                .kMainColor,
                                                          )),
                                                    ],
                                                  );
                                                }, error: (e, stack) {
                                                  return Text(e.toString());
                                                }, loading: () {
                                                  return Text(lang.S
                                                      .of(context)
                                                      .loading);
                                                }),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        height: 0.5,
                                        width: context.width(),
                                        color: Constants().kBgColor,
                                      )
                                    ],
                                  ),
                                )
                              : Container();
                        },
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
        ),
        // bottomNavigationBar: ButtonGlobal(
        //   iconWidget: null,
        //   buttontext: lang.S.of(context).viewAll,
        //   iconColor: Colors.white,
        //   buttonDecoration: kButtonDecoration.copyWith(color: Constants.kMainColor),
        //   onPressed: () {},
        // ),
      );
    });
  }
}
