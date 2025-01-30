// ignore_for_file: unused_result

import 'dart:convert';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_pos/Provider/customer_provider.dart';
import 'package:mobile_pos/Provider/due_transaction_provider.dart';
import 'package:mobile_pos/Screens/Parties_Customers/Model/customer_model.dart';
import 'package:mobile_pos/Screens/Report/Screens/due_report_screen.dart';
import 'package:mobile_pos/model/print_transaction_model.dart';
import 'package:nb_utils/nb_utils.dart';
import '../../Provider/printer_due_provider.dart';
import '../../Provider/profile_provider.dart';
import '../../Provider/transactions_provider.dart';
import '../../constant.dart';
import '../../currency.dart';
import '../../model/due_transaction_model.dart';
import '../../subscription.dart';
import 'package:mobile_pos/generated/l10n.dart' as lang;

class DueCollectionScreen extends StatefulWidget {
  const DueCollectionScreen({super.key, required this.customerModel});

  @override
  State<DueCollectionScreen> createState() => _DueCollectionScreenState();
  final CustomerModel customerModel;
}

class _DueCollectionScreenState extends State<DueCollectionScreen> {
  int invoice = 0;
  double paidAmount = 0;
  double discountAmount = 0;
  double returnAmount = 0;
  double remainDueAmount = 0;
  double subTotal = 0;
  double dueAmount = 0;

  double calculateSubtotal({required double total}) {
    subTotal = total - discountAmount;
    return total - discountAmount;
  }

  // double calculateReturnAmount({required double total}) {
  //   returnAmount = total - paidAmount;
  //   return paidAmount <= 0 || paidAmount <= subTotal ? 0 : total - paidAmount;
  // }

  double calculateDueAmount({required double total}) {
    if (total < 0) {
      remainDueAmount = 0;
    } else {
      remainDueAmount = dueAmount - total;
    }
    return dueAmount - total;
  }

  TextEditingController controller = TextEditingController();
  TextEditingController paidText = TextEditingController();
  TextEditingController dateController =
      TextEditingController(text: DateTime.now().toString());
  late DueTransactionModel dueTransactionModel = DueTransactionModel(
    customerName: widget.customerModel.customerName,
    customerPhone: widget.customerModel.phoneNumber,
    customerType: widget.customerModel.type,
    invoiceNumber: invoice.toString(),
    purchaseDate: DateTime.now().toString(),
  );
  String? dropdownValue = 'Select an invoice';
  String? dropdownPaymentValue = 'Cash';
  String? selectedInvoice;

  // List of items in our dropdown menu
  List<String> items = ['Select an invoice'];
  int count = 0;

  @override
  Widget build(BuildContext context) {
    count++;
    return Consumer(builder: (context, consumerRef, __) {
      final customerProviderRef = widget.customerModel.type == 'Supplier'
          ? consumerRef.watch(purchaseTransitionProvider)
          : consumerRef.watch(transitionProvider);
      final printerData = consumerRef.watch(printerDueProviderNotifier);
      final personalData = consumerRef.watch(profileDetailsProvider);
      return personalData.when(data: (data) {
        invoice = data.invoiceCounter!.toInt();
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            title: Text(
              lang.S.of(context).collectDue,
              style: GoogleFonts.poppins(
                color: Colors.black,
              ),
            ),
            centerTitle: true,
            iconTheme: const IconThemeData(color: Colors.black),
            elevation: 0.0,
          ),
          body: SingleChildScrollView(
            physics: const NeverScrollableScrollPhysics(),
            child: Column(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.78,
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                        children: [
                          const SizedBox(height: 20),
                          Row(
                            children: [
                              customerProviderRef.when(data: (customer) {
                                for (var element in customer) {
                                  if (element.customerPhone ==
                                          widget.customerModel.phoneNumber &&
                                      element.dueAmount != 0 &&
                                      count < 2) {
                                    items.add(element.invoiceNumber);
                                  }
                                  if (selectedInvoice ==
                                      element.invoiceNumber) {
                                    dueAmount = element.dueAmount!.toDouble();
                                  }
                                }
                                return Container(
                                  height: 60,
                                  width: 180,
                                  decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(05),
                                    ),
                                    border: Border.all(
                                        width: 1, color: Constants().kBgColor),
                                  ),
                                  child: Center(
                                    child: DropdownButton(
                                      underline: Container(
                                        height: 1.5,
                                        color: Constants.kMainColor,
                                      ),
                                      value: dropdownValue,
                                      icon: Icon(
                                        Icons.keyboard_arrow_down,
                                        color: Constants.kMainColor,
                                      ),
                                      items: items.map((String items) {
                                        return DropdownMenuItem(
                                          value: items,
                                          child: Text(items),
                                        );
                                      }).toList(),
                                      onChanged: (newValue) {
                                        setState(() {
                                          paidAmount = 0;
                                          paidText.clear();
                                          dropdownValue = newValue.toString();
                                          controller.text = newValue.toString();
                                          selectedInvoice = newValue.toString();
                                        });
                                      },
                                    ),
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
                              const SizedBox(width: 20),
                              Expanded(
                                child: AppTextField(
                                  textFieldType: TextFieldType.NAME,
                                  readOnly: true,
                                  controller: dateController,
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
                                    labelText: lang.S.of(context).date,
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
                                        if (picked != null) {
                                          setState(() {
                                            dateController.text =
                                                picked.toString();
                                            dueTransactionModel.purchaseDate =
                                                picked.toString();
                                          });
                                        }
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
                          const SizedBox(height: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    lang.S.of(context).dueAmount,
                                  ),
                                  Text(
                                    widget.customerModel.dueAmount == ''
                                        ? '$currency 0'
                                        : '$currency${widget.customerModel.dueAmount}',
                                    style: const TextStyle(
                                        color: Color(0xFFFF8C34)),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              AppTextField(
                                textFieldType: TextFieldType.NAME,
                                readOnly: true,
                                initialValue: widget.customerModel.customerName,
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
                                  labelText: lang.S.of(context).customerName,
                                  border: const OutlineInputBorder(),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),

                          ///_____Total______________________________
                          Container(
                            decoration: BoxDecoration(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(10)),
                                border: Border.all(
                                    color: Constants().kBgColor, width: 1)),
                            child: Column(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                      color: Constants().kBgColor,
                                      borderRadius: const BorderRadius.only(
                                          topRight: Radius.circular(10),
                                          topLeft: Radius.circular(10))),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        lang.S.of(context).totalAmount,
                                        style: const TextStyle(fontSize: 16),
                                      ),
                                      Text(
                                        dueAmount.toString(),
                                        style: const TextStyle(fontSize: 16),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        lang.S.of(context).paidAmount,
                                        style: const TextStyle(fontSize: 16),
                                      ),
                                      SizedBox(
                                        width: context.width() / 4,
                                        child: TextField(
                                          controller: paidText,
                                          onChanged: (value) {
                                            if (value == '') {
                                              setState(() {
                                                paidAmount = 0;
                                              });
                                            } else {
                                              if (value.toDouble() <=
                                                  dueAmount) {
                                                setState(() {
                                                  paidAmount =
                                                      double.parse(value);
                                                });
                                              } else {
                                                paidText.clear();
                                                setState(() {
                                                  paidAmount = 0;
                                                });
                                                EasyLoading.showError(
                                                    'You can\'t pay more then due');
                                              }
                                            }
                                          },
                                          textAlign: TextAlign.right,
                                          decoration: InputDecoration(
                                            focusedBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Constants
                                                      .kMainColor), // Change the border color when focused
                                            ),
                                            enabledBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Constants()
                                                      .kBgColor), // Change the border color when not focused
                                            ),
                                            hintText: '0',
                                          ),
                                          keyboardType: TextInputType.number,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        lang.S.of(context).dueAmount,
                                        style: const TextStyle(fontSize: 16),
                                      ),
                                      Text(
                                        calculateDueAmount(total: paidAmount)
                                            .toString(),
                                        style: const TextStyle(fontSize: 16),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 10),
                          Container(
                            height: 1,
                            width: double.infinity,
                            color: Constants().kBgColor,
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    lang.S.of(context).paymentTypes,
                                    style: const TextStyle(
                                        fontSize: 16, color: Colors.black54),
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  const Icon(
                                    Icons.wallet,
                                    color: Colors.green,
                                  )
                                ],
                              ),
                              DropdownButton(
                                underline: Container(
                                  height: 1.5,
                                  color: Constants.kMainColor,
                                ),
                                value: dropdownPaymentValue,
                                icon: Icon(
                                  Icons.keyboard_arrow_down,
                                  color: Constants.kMainColor,
                                ),
                                items: paymentsTypeList.map((String items) {
                                  return DropdownMenuItem(
                                    value: items,
                                    child: Text(items),
                                  );
                                }).toList(),
                                onChanged: (newValue) {
                                  setState(() {
                                    dropdownPaymentValue = newValue.toString();
                                  });
                                },
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Container(
                            height: 1,
                            width: double.infinity,
                            color: Constants().kBgColor,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: AppTextField(
                                  textFieldType: TextFieldType.NAME,
                                  onChanged: (value) {
                                    setState(() {});
                                  },
                                  decoration: InputDecoration(
                                    floatingLabelBehavior:
                                        FloatingLabelBehavior.always,
                                    labelText: lang.S.of(context).description,
                                    hintText: lang.S.of(context).addNote,
                                    border: const OutlineInputBorder(),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 20),
                              Container(
                                  height: 60,
                                  width: 100,
                                  decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(10)),
                                      color: Colors.grey.shade200),
                                  child: Center(
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Icon(
                                          FeatherIcons.camera,
                                          color: Colors.grey,
                                        ),
                                        const SizedBox(width: 5),
                                        Text(
                                          lang.S.of(context).image,
                                          style: const TextStyle(
                                              color: Colors.grey, fontSize: 16),
                                        )
                                      ],
                                    ),
                                  )),
                            ],
                          ).visible(false),
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                  color: Constants().kBgColor,
                  height: MediaQuery.of(context).size.height * 0.1,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: Row(
                      children: [
                        Expanded(
                            child: GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Container(
                            height: 60,
                            decoration: BoxDecoration(
                              color: Constants().kBgColor,
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(10)),
                            ),
                            child: Center(
                              child: Text(
                                lang.S.of(context).cancel,
                                style: const TextStyle(fontSize: 18),
                              ),
                            ),
                          ),
                        )),
                        const SizedBox(width: 10),
                        Expanded(
                          child: GestureDetector(
                            onTap: () async {
                              if (paidAmount >= 0) {
                                try {
                                  EasyLoading.show(
                                      status: 'Loading...',
                                      dismissOnTap: false);

                                  DatabaseReference ref = FirebaseDatabase
                                      .instance
                                      .ref("$constUserId/Due Transaction");
                                  final DatabaseReference
                                      personalInformationRef = FirebaseDatabase
                                          .instance
                                          .ref()
                                          .child(constUserId)
                                          .child('Personal Information');
                                  ref.keepSynced(true);
                                  personalInformationRef.keepSynced(true);

                                  dueTransactionModel.totalDue = dueAmount;
                                  remainDueAmount <= 0
                                      ? dueTransactionModel.isPaid = true
                                      : dueTransactionModel.isPaid = false;
                                  remainDueAmount <= 0
                                      ? dueTransactionModel.dueAmountAfterPay =
                                          0
                                      : dueTransactionModel.dueAmountAfterPay =
                                          remainDueAmount;
                                  dueTransactionModel.payDueAmount = paidAmount;
                                  dueTransactionModel.paymentType =
                                      dropdownPaymentValue;
                                  dueTransactionModel.invoiceNumber =
                                      invoice.toString();
                                  isSubUser
                                      ? dueTransactionModel.sellerName =
                                          subUserTitle
                                      : null;
                                  ref.push().set(dueTransactionModel.toJson());

                                  ///_____UpdateInvoice__________________________________________________
                                  updateInvoice(
                                    type: widget.customerModel.type,
                                    invoice: selectedInvoice.toString(),
                                    remainDueAmount: remainDueAmount.toInt(),
                                  );

                                  personalInformationRef
                                      .update({'invoiceCounter': invoice + 1});

                                  ///_________DueUpdate______________________________________________________
                                  getSpecificCustomers(
                                    phoneNumber:
                                        widget.customerModel.phoneNumber,
                                    due: paidAmount.toInt(),
                                  );

                                  ///________Subscription_____________________________________________________
                                  Subscription.decreaseSubscriptionLimits(
                                      itemType: 'dueNumber', context: context);

                                  ///________Print_______________________________________________________
                                  if (isPrintEnable &&
                                      (Theme.of(context).platform ==
                                          TargetPlatform.android)) {
                                    await printerData.getBluetooth();
                                    PrintDueTransactionModel model =
                                        PrintDueTransactionModel(
                                            dueTransactionModel:
                                                dueTransactionModel,
                                            personalInformationModel: data);
                                    if (connected) {
                                      await printerData.printTicket(
                                          printDueTransactionModel: model);
                                      consumerRef.refresh(customerProvider);
                                      consumerRef
                                          .refresh(dueTransactionProvider);
                                      consumerRef
                                          .refresh(purchaseTransitionProvider);
                                      consumerRef.refresh(transitionProvider);
                                      consumerRef
                                          .refresh(profileDetailsProvider);

                                      EasyLoading.dismiss();
                                      Future.delayed(
                                          const Duration(milliseconds: 500),
                                          () {
                                        const DueReportScreen().launch(context);
                                      });
                                    } else {
                                      // ignore: use_build_context_synchronously
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                        content: Text(lang.S
                                            .of(context)
                                            .pleaseConnectThePrinterFirst),
                                      ));
                                      // ignore: use_build_context_synchronously
                                      showDialog(
                                          context: context,
                                          builder: (_) {
                                            return WillPopScope(
                                              onWillPop: () async => false,
                                              child: Dialog(
                                                child: SizedBox(
                                                  child: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      ListView.builder(
                                                        shrinkWrap: true,
                                                        itemCount: printerData
                                                                .availableBluetoothDevices
                                                                .isNotEmpty
                                                            ? printerData
                                                                .availableBluetoothDevices
                                                                .length
                                                            : 0,
                                                        itemBuilder:
                                                            (context, index) {
                                                          return ListTile(
                                                            onTap: () async {
                                                              String select =
                                                                  printerData
                                                                          .availableBluetoothDevices[
                                                                      index];
                                                              List list = select
                                                                  .split("#");
                                                              // String name = list[0];
                                                              String mac =
                                                                  list[1];
                                                              bool isConnect =
                                                                  await printerData
                                                                      .setConnect(
                                                                          mac);
                                                              if (isConnect) {
                                                                await printerData
                                                                    .printTicket(
                                                                        printDueTransactionModel:
                                                                            model);
                                                                consumerRef.refresh(
                                                                    customerProvider);
                                                                consumerRef.refresh(
                                                                    dueTransactionProvider);
                                                                consumerRef.refresh(
                                                                    purchaseTransitionProvider);
                                                                consumerRef.refresh(
                                                                    transitionProvider);
                                                                consumerRef.refresh(
                                                                    profileDetailsProvider);
                                                                EasyLoading
                                                                    .showSuccess(
                                                                        'Added Successfully');
                                                                Future.delayed(
                                                                    const Duration(
                                                                        milliseconds:
                                                                            500),
                                                                    () {
                                                                  const DueReportScreen()
                                                                      .launch(
                                                                          context);
                                                                });
                                                              }
                                                            },
                                                            title: Text(
                                                                '${printerData.availableBluetoothDevices[index]}'),
                                                            subtitle: Text(lang
                                                                .S
                                                                .of(context)
                                                                .clickToConnect),
                                                          );
                                                        },
                                                      ),
                                                      const SizedBox(
                                                          height: 10),
                                                      Text(lang.S
                                                          .of(context)
                                                          .connectPrinter),
                                                      const SizedBox(
                                                          height: 10),
                                                      Container(
                                                        height: 1,
                                                        width: double.infinity,
                                                        color: Colors.grey,
                                                      ),
                                                      const SizedBox(
                                                          height: 15),
                                                      GestureDetector(
                                                        onTap: () {
                                                          consumerRef.refresh(
                                                              customerProvider);
                                                          consumerRef.refresh(
                                                              dueTransactionProvider);
                                                          consumerRef.refresh(
                                                              purchaseTransitionProvider);
                                                          consumerRef.refresh(
                                                              transitionProvider);
                                                          consumerRef.refresh(
                                                              profileDetailsProvider);
                                                          const DueReportScreen()
                                                              .launch(context);
                                                        },
                                                        child: Center(
                                                          child: Text(
                                                            lang.S
                                                                .of(context)
                                                                .cancel,
                                                            style: TextStyle(
                                                                color: Constants
                                                                    .kMainColor),
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
                                      EasyLoading.showSuccess(
                                          'Added Successfully');
                                    }
                                  } else {
                                    consumerRef.refresh(customerProvider);
                                    consumerRef.refresh(dueTransactionProvider);
                                    consumerRef
                                        .refresh(purchaseTransitionProvider);
                                    consumerRef.refresh(transitionProvider);
                                    consumerRef.refresh(profileDetailsProvider);

                                    EasyLoading.showSuccess(
                                        'Added Successfully');
                                    Future.delayed(
                                        const Duration(milliseconds: 500), () {
                                      const DueReportScreen().launch(context);
                                    });
                                  }
                                } catch (e) {
                                  EasyLoading.dismiss();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text(e.toString())));
                                }
                              } else {
                                EasyLoading.showError('Add product first');
                              }
                            },
                            child: Container(
                              height: 60,
                              decoration: BoxDecoration(
                                color: Constants.kMainColor,
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(10)),
                              ),
                              child: Center(
                                child: Text(
                                  lang.S.of(context).save,
                                  style: const TextStyle(
                                      fontSize: 18, color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      }, error: (e, stack) {
        return Center(
          child: Text(e.toString()),
        );
      }, loading: () {
        return Center(
            child: CircularProgressIndicator(
          color: Constants.kMainColor,
        ));
      });
    });
  }

  void updateInvoice(
      {required String type,
      required String invoice,
      required int remainDueAmount}) {
    final ref = type == 'Supplier'
        ? FirebaseDatabase.instance.ref('$constUserId/Purchase Transition/')
        : FirebaseDatabase.instance.ref('$constUserId/Sales Transition/');
    String? key;
    ref.keepSynced(true);

    type == 'Supplier'
        ? ref.orderByKey().get().then((value) {
            for (var element in value.children) {
              var data = jsonDecode(jsonEncode(element.value));
              if (data['invoiceNumber'] == invoice) {
                key = element.key;
                ref.child(key!).update({
                  'dueAmount': '$remainDueAmount',
                });
              }
            }
          })
        : ref.orderByKey().get().then((value) {
            for (var element in value.children) {
              var data = jsonDecode(jsonEncode(element.value));
              if (data['invoiceNumber'] == invoice) {
                key = element.key;
                ref.child(key!).update({
                  'dueAmount': '$remainDueAmount',
                });
              }
            }
          });
  }

  void getSpecificCustomers(
      {required String phoneNumber, required int due}) async {
    final ref = FirebaseDatabase.instance.ref('$constUserId/Customers/');
    String? key;

    await FirebaseDatabase.instance
        .ref(constUserId)
        .child('Customers')
        .orderByKey()
        .get()
        .then((value) {
      for (var element in value.children) {
        var data = jsonDecode(jsonEncode(element.value));
        if (data['phoneNumber'] == phoneNumber) {
          key = element.key;
        }
      }
    });
    var data1 = await ref.child('$key/due').once();
    int previousDue = data1.snapshot.value.toString().toInt();

    int totalDue = previousDue - due;
    ref.child(key!).update({'due': '$totalDue'});
  }

  void decreaseSubscriptionSale() async {
    final ref =
        FirebaseDatabase.instance.ref('$constUserId/Subscription/dueNumber');
    var data = await ref.once();
    int beforeSale = int.parse(data.snapshot.value.toString());
    int afterSale = beforeSale - 1;
    beforeSale != -202
        ? FirebaseDatabase.instance
            .ref('$constUserId/Subscription')
            .update({'dueNumber': afterSale})
        : null;
  }
}
