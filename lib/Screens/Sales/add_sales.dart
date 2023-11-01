// ignore_for_file: unused_result, use_build_context_synchronously

import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_pos/Provider/add_to_cart.dart';
import 'package:mobile_pos/Provider/customer_provider.dart';
import 'package:mobile_pos/Provider/profile_provider.dart';
import 'package:mobile_pos/Provider/transactions_provider.dart';
import 'package:mobile_pos/Screens/Report/Screens/sales_report_screen.dart';
import 'package:mobile_pos/Screens/Sales/sales_screen.dart';
import 'package:mobile_pos/model/transition_model.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../Provider/printer_provider.dart';
import '../../Provider/product_provider.dart';
import '../../Provider/seles_report_provider.dart';
import '../../constant.dart';
import '../../currency.dart';
import '../../model/personal_information_model.dart';
import '../../model/print_transaction_model.dart';
import '../../subscription.dart';
import '../Parties_Customers/Model/customer_model.dart';
import '../Home/home.dart';
import 'package:mobile_pos/generated/l10n.dart' as lang;

// ignore: must_be_immutable
class AddSalesScreen extends StatefulWidget {
  AddSalesScreen({Key? key, required this.customerModel}) : super(key: key);

  CustomerModel customerModel;

  @override
  State<AddSalesScreen> createState() => _AddSalesScreenState();
}

class _AddSalesScreenState extends State<AddSalesScreen> {
  TextEditingController paidText = TextEditingController();
  int invoice = 0;
  double paidAmount = 0;
  double discountAmount = 0;
  double returnAmount = 0;
  double dueAmount = 0;
  double subTotal = 0;

  String? dropdownValue = 'Cash';
  String? selectedPaymentType;

  bool isClicked = false;

  double calculateSubtotal({required double total}) {
    subTotal = total - discountAmount;
    return total - discountAmount;
  }

  double calculateReturnAmount({required double total}) {
    returnAmount = total - paidAmount;
    return paidAmount <= 0 || paidAmount <= subTotal ? 0 : total - paidAmount;
  }

  double calculateDueAmount({required double total}) {
    if (total < 0) {
      dueAmount = 0;
    } else {
      dueAmount = subTotal - paidAmount;
    }
    return returnAmount <= 0 ? 0 : subTotal - paidAmount;
  }

  late TransitionModel transitionModel = TransitionModel(
    customerName: widget.customerModel.customerName,
    customerPhone: widget.customerModel.phoneNumber,
    customerType: widget.customerModel.type,
    invoiceNumber: invoice.toString(),
    purchaseDate: DateTime.now().toString(),
  );
  DateTime selectedDate = DateTime.now();

  late PersonalInformationModel personalInformationModel;

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, consumerRef, __) {
      final providerData = consumerRef.watch(cartNotifier);
      final printerData = consumerRef.watch(printerProviderNotifier);
      final personalData = consumerRef.watch(profileDetailsProvider);
      return personalData.when(data: (data) {
        invoice = data.invoiceCounter!.toInt();
        personalInformationModel = data;
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            title: Text(
              lang.S.of(context).addSales,
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
                          Row(
                            children: [
                              Expanded(
                                child: AppTextField(
                                  textFieldType: TextFieldType.NAME,
                                  readOnly: true,
                                  initialValue: data.invoiceCounter.toString(),
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
                                    labelText: lang.S.of(context).inv,
                                    border: const OutlineInputBorder(),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 20),
                              Expanded(
                                child: AppTextField(
                                  textFieldType: TextFieldType.NAME,
                                  readOnly: true,
                                  initialValue: transitionModel.purchaseDate,
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
                                          initialDate: selectedDate,
                                          firstDate: DateTime(2015, 8),
                                          lastDate: DateTime(2101),
                                          context: context,
                                        );
                                        if (picked != null &&
                                            picked != selectedDate) {
                                          setState(() {
                                            selectedDate = picked;
                                            transitionModel.purchaseDate =
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
                          const SizedBox(height: 20),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(lang.S.of(context).dueAmount),
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
                          const SizedBox(height: 20),

                          ///_______Added_ItemS__________________________________________________
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                  width: 1, color: Constants().kBgColor),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      color: Constants().kBgColor,
                                      borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(10),
                                          topRight: Radius.circular(10)),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(10),
                                      child: SizedBox(
                                        width: context.width() / 1.35,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              lang.S.of(context).itemAdded,
                                              style:
                                                  const TextStyle(fontSize: 16),
                                            ),
                                            Text(
                                              lang.S.of(context).quantity,
                                              style:
                                                  const TextStyle(fontSize: 16),
                                            ),
                                          ],
                                        ),
                                      ),
                                    )),
                                ListView.builder(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemCount: providerData.cartItemList.length,
                                    itemBuilder: (context, index) {
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 5, horizontal: 3),
                                        child: Container(
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              color: Constants().kBgColor),
                                          child: ListTile(
                                            leading: Padding(
                                              padding:
                                                  const EdgeInsets.all(4.0),
                                              child: FittedBox(
                                                child: Column(
                                                  children: [
                                                    Container(
                                                      height: 50,
                                                      width: 50,
                                                      decoration: BoxDecoration(
                                                        image: DecorationImage(
                                                            image: NetworkImage(
                                                                "${providerData.cartItemList[index].productPicture}"),
                                                            fit: BoxFit.cover),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(90.0),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            contentPadding:
                                                const EdgeInsets.all(0),
                                            title: Text(
                                              "${providerData.cartItemList[index].productName}",
                                              style: const TextStyle(
                                                fontSize: 11,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            subtitle: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  '${providerData.cartItemList[index].quantity} X ${providerData.cartItemList[index].subTotal} = ${(double.parse(providerData.cartItemList[index].subTotal) * providerData.cartItemList[index].quantity).toStringAsFixed(0)}',
                                                  style: const TextStyle(
                                                      fontSize: 10),
                                                ),
                                                Text(
                                                  "${providerData.cartItemList[index].capacity == "Not Provided" ? "" : "Capacity: ${providerData.cartItemList[index].capacity!}: "} ${providerData.cartItemList[index].weight == "Not Provided" ? "" : "Weight: ${providerData.cartItemList[index].weight!}:"} ${providerData.cartItemList[index].size == "Not Provided" ? "" : "size: ${providerData.cartItemList[index].size!}"}",
                                                  style: const TextStyle(
                                                      fontSize: 10),
                                                ),
                                              ],
                                            ),
                                            trailing: Column(
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          bottom: 5.0,
                                                          right: 5),
                                                  child: Text(
                                                    "${providerData.cartItemList[index].color == "Not Provided" ? "" : "Color: ${providerData.cartItemList[index].color!} |"} ${providerData.cartItemList[index].type == "Not Provided" ? "" : "Type: ${providerData.cartItemList[index].type!}"}",
                                                    style: const TextStyle(
                                                      fontSize: 8,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      // color: kPremiumPlanColor2,
                                                    ),
                                                  ),
                                                ),
                                                Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    SizedBox(
                                                      width: 65,
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          GestureDetector(
                                                            onTap: () {
                                                              providerData
                                                                  .quantityDecrease(
                                                                      index);
                                                            },
                                                            child: Container(
                                                              height: 20,
                                                              width: 20,
                                                              decoration:
                                                                  BoxDecoration(
                                                                color: Constants
                                                                    .kMainColor,
                                                                borderRadius:
                                                                    const BorderRadius
                                                                        .all(
                                                                        Radius.circular(
                                                                            10)),
                                                              ),
                                                              child:
                                                                  const Center(
                                                                child: Text(
                                                                  '-',
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          14,
                                                                      color: Colors
                                                                          .white),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                              width: 2),
                                                          Text(
                                                            '${providerData.cartItemList[index].quantity}',
                                                            style: GoogleFonts
                                                                .poppins(
                                                              color:
                                                                  kGreyTextColor,
                                                              fontSize: 15.0,
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                              width: 2),
                                                          GestureDetector(
                                                            onTap: () {
                                                              providerData
                                                                  .quantityIncrease(
                                                                      index);
                                                            },
                                                            child: Container(
                                                              height: 20,
                                                              width: 20,
                                                              decoration:
                                                                  BoxDecoration(
                                                                color: Constants
                                                                    .kMainColor,
                                                                borderRadius:
                                                                    const BorderRadius
                                                                        .all(
                                                                        Radius.circular(
                                                                            10)),
                                                              ),
                                                              child:
                                                                  const Center(
                                                                      child:
                                                                          Text(
                                                                '+',
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        14,
                                                                    color: Colors
                                                                        .white),
                                                              )),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    const SizedBox(width: 10),
                                                    GestureDetector(
                                                      onTap: () {
                                                        providerData
                                                            .deleteToCart(
                                                                index);
                                                      },
                                                      child: Container(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(4),
                                                        color: Colors.red
                                                            .withOpacity(0.1),
                                                        child: const Icon(
                                                          Icons.delete,
                                                          size: 20,
                                                          color: Colors.red,
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(width: 10),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    }),
                              ],
                            ).visible(providerData.cartItemList.isNotEmpty),
                          ),
                          const SizedBox(height: 20),

                          ///_______Add_Button__________________________________________________
                          GestureDetector(
                            onTap: () {
                              SaleProducts(
                                catName: null,
                                customerModel: widget.customerModel,
                              ).launch(context);
                            },
                            child: Container(
                              height: 50,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                  color: Constants.kMainColor.withOpacity(0.1),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(10))),
                              child: Center(
                                  child: Text(
                                lang.S.of(context).addItems,
                                style: TextStyle(
                                    color: Constants.kMainColor, fontSize: 20),
                              )),
                            ),
                          ),
                          const SizedBox(height: 20),

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
                                        lang.S.of(context).subTotal,
                                        style: const TextStyle(fontSize: 16),
                                      ),
                                      Text(
                                        providerData
                                            .getTotalAmount()
                                            .toStringAsFixed(2),
                                        style: const TextStyle(fontSize: 16),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        lang.S.of(context).discount,
                                        style: const TextStyle(fontSize: 16),
                                      ),
                                      SizedBox(
                                        width: context.width() / 4,
                                        child: TextField(
                                          controller: paidText,
                                          onChanged: (value) {
                                            if (value == '') {
                                              setState(() {
                                                discountAmount = 0;
                                              });
                                            } else {
                                              if (value.toInt() <=
                                                  providerData
                                                      .getTotalAmount()) {
                                                setState(() {
                                                  discountAmount =
                                                      double.parse(value);
                                                });
                                              } else {
                                                paidText.clear();
                                                setState(() {
                                                  discountAmount = 0;
                                                });
                                                EasyLoading.showError(
                                                    'Enter a valid Discount');
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
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10.0,
                                    vertical: 5,
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        lang.S.of(context).total,
                                        style: const TextStyle(fontSize: 16),
                                      ),
                                      Text(
                                        calculateSubtotal(
                                                total: providerData
                                                    .getTotalAmount())
                                            .toStringAsFixed(2),
                                        style: const TextStyle(fontSize: 16),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10.0,
                                    //vertical: 5,
                                  ),
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
                                          keyboardType: TextInputType.number,
                                          onChanged: (value) {
                                            if (value == '') {
                                              setState(() {
                                                paidAmount = 0;
                                              });
                                            } else {
                                              setState(() {
                                                paidAmount =
                                                    double.parse(value);
                                              });
                                            }
                                          },
                                          textAlign: TextAlign.right,
                                          decoration: InputDecoration(
                                              focusedBorder:
                                                  UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Constants
                                                        .kMainColor), // Change the border color when focused
                                              ),
                                              enabledBorder:
                                                  UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Constants()
                                                        .kBgColor), // Change the border color when not focused
                                              ),
                                              hintText: '0'),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10.0,
                                    vertical: 5,
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        lang.S.of(context).returnAmount,
                                        style: const TextStyle(fontSize: 16),
                                      ),
                                      Text(
                                        calculateReturnAmount(total: subTotal)
                                            .abs()
                                            .toStringAsFixed(2),
                                        style: const TextStyle(fontSize: 16),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10.0,
                                    vertical: 5,
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        lang.S.of(context).dueAmount,
                                        style: const TextStyle(fontSize: 16),
                                      ),
                                      Text(
                                        calculateDueAmount(total: subTotal)
                                            .toStringAsFixed(2),
                                        style: const TextStyle(fontSize: 16),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          //const SizedBox(height: 20),
                          // Container(
                          //   height: 1,
                          //   width: double.infinity,
                          //   color: Constants().kBgColor,
                          // ),
                          const SizedBox(height: 10),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                  width: 1, color: Constants().kBgColor),
                            ),
                            padding: const EdgeInsets.all(10),
                            child: Row(
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
                                  value: dropdownValue,
                                  //dropdownColor: Constants().kBgColor,
                                  underline: Container(
                                    // You can customize the underline with a colored container
                                    height: 1.5,
                                    color: Constants
                                        .kMainColor, // Change this to the color you want
                                  ),
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
                                      dropdownValue = newValue.toString();
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 10),
                          // Container(
                          //   height: 1,
                          //   width: double.infinity,
                          //   color: Constants().kBgColor,
                          // ),
                          // const SizedBox(height: 30),
                          Row(
                            children: [
                              Expanded(
                                child: AppTextField(
                                  textFieldType: TextFieldType.NAME,
                                  onChanged: (value) {
                                    setState(() {});
                                  },
                                  decoration: const InputDecoration(
                                    floatingLabelBehavior:
                                        FloatingLabelBehavior.always,
                                    labelText: 'Description',
                                    hintText: 'Add Note',
                                    border: OutlineInputBorder(),
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
                                      Icon(
                                        FeatherIcons.camera,
                                        color: Constants().kBgColor,
                                      ),
                                      const SizedBox(width: 5),
                                      const Text(
                                        'Image',
                                        style: TextStyle(
                                            color: Colors.grey, fontSize: 16),
                                      )
                                    ],
                                  ),
                                ),
                              ),
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
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: Row(
                    children: [
                      Expanded(
                          child: GestureDetector(
                        onTap: () async {
                          const Home().launch(context);
                          // if (providerData.cartItemList.isNotEmpty) {
                          //   if (widget.customerModel.type == 'Guest' && dueAmount > 0) {
                          //     EasyLoading.showError('Due is not available for guest');
                          //   } else {
                          //     try {
                          //       EasyLoading.show(status: 'Loading...', dismissOnTap: false);
                          //
                          //       DatabaseReference ref = FirebaseDatabase.instance.ref("$constUserId/Sales Transition");
                          //
                          //       dueAmount <= 0 ? transitionModel.isPaid = true : transitionModel.isPaid = false;
                          //       dueAmount <= 0 ? transitionModel.dueAmount = 0 : transitionModel.dueAmount = dueAmount;
                          //       returnAmount < 0 ? transitionModel.returnAmount = returnAmount.abs() : transitionModel.returnAmount = 0;
                          //       transitionModel.discountAmount = discountAmount;
                          //       transitionModel.totalAmount = subTotal;
                          //       transitionModel.productList = providerData.cartItemList;
                          //       transitionModel.paymentType = dropdownValue;
                          //       isSubUser ? transitionModel.sellerName = subUserTitle : null;
                          //       transitionModel.invoiceNumber = invoice.toString();
                          //
                          //       int totalQuantity = 0;
                          //       double lossProfit = 0;
                          //       double totalPurchasePrice = 0;
                          //       double totalSalePrice = 0;
                          //       for (var element in transitionModel.productList!) {
                          //         totalPurchasePrice = totalPurchasePrice + (double.parse(element.productPurchasePrice) * element.quantity);
                          //         totalSalePrice = totalSalePrice + (double.parse(element.subTotal) * element.quantity);
                          //
                          //         totalQuantity = totalQuantity + element.quantity;
                          //       }
                          //       lossProfit = ((totalSalePrice - totalPurchasePrice.toDouble()) - double.parse(transitionModel.discountAmount.toString()));
                          //
                          //       transitionModel.totalQuantity = totalQuantity;
                          //       transitionModel.lossProfit = lossProfit;
                          //
                          //       await ref.push().set(transitionModel.toJson());
                          //
                          //       ///__________StockMange_________________________________________________-
                          //
                          //       for (var element in providerData.cartItemList) {
                          //         decreaseStock(element.productId, element.quantity);
                          //       }
                          //
                          //       ///_______invoice_Update_____________________________________________
                          //       final DatabaseReference personalInformationRef =
                          //           // ignore: deprecated_member_use
                          //           FirebaseDatabase.instance.ref().child(constUserId).child('Personal Information');
                          //
                          //       await personalInformationRef.update({'invoiceCounter': invoice + 1});
                          //
                          //       ///________Subscription_____________________________________________________
                          //       decreaseSubscriptionSale();
                          //
                          //       ///_________DueUpdate______________________________________________________
                          //       getSpecificCustomers(phoneNumber: widget.customerModel.phoneNumber, due: transitionModel.dueAmount!.toInt());
                          //       await printerData.getBluetooth();
                          //       PrintTransactionModel model = PrintTransactionModel(transitionModel: transitionModel, personalInformationModel: data);
                          //
                          //       ///_________printer________________________________________
                          //       if (isPrintEnable) {
                          //         if (connected) {
                          //           await printerData.printTicket(printTransactionModel: model, productList: providerData.cartItemList);
                          //           providerData.clearCart();
                          //           consumerRef.refresh(customerProvider);
                          //           consumerRef.refresh(productProvider);
                          //           consumerRef.refresh(salesReportProvider);
                          //           consumerRef.refresh(transitionProvider);
                          //           consumerRef.refresh(profileDetailsProvider);
                          //
                          //           EasyLoading.showSuccess('Added Successfully');
                          //           Future.delayed(const Duration(milliseconds: 500), () {
                          //             const Home().launch(context);
                          //           });
                          //         } else {
                          //           EasyLoading.showSuccess('Added Successfully');
                          //           // ignore: use_build_context_synchronously
                          //           ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          //             content: Text("Please Connect The Printer First"),
                          //           ));
                          //           // EasyLoading.showInfo('Please Connect The Printer First');
                          //           showDialog(
                          //               context: context,
                          //               builder: (_) {
                          //                 return WillPopScope(
                          //                   onWillPop: () async => false,
                          //                   child: Dialog(
                          //                     child: SizedBox(
                          //                       child: Column(
                          //                         mainAxisSize: MainAxisSize.min,
                          //                         children: [
                          //                           ListView.builder(
                          //                             shrinkWrap: true,
                          //                             itemCount: printerData.availableBluetoothDevices.isNotEmpty ? printerData.availableBluetoothDevices.length : 0,
                          //                             itemBuilder: (context, index) {
                          //                               return ListTile(
                          //                                 onTap: () async {
                          //                                   String select = printerData.availableBluetoothDevices[index];
                          //                                   List list = select.split("#");
                          //                                   // String name = list[0];
                          //                                   String mac = list[1];
                          //                                   bool isConnect = await printerData.setConnect(mac);
                          //                                   if (isConnect) {
                          //                                     await printerData.printTicket(printTransactionModel: model, productList: transitionModel.productList);
                          //                                     providerData.clearCart();
                          //                                     consumerRef.refresh(customerProvider);
                          //                                     consumerRef.refresh(productProvider);
                          //                                     consumerRef.refresh(salesReportProvider);
                          //                                     consumerRef.refresh(transitionProvider);
                          //                                     consumerRef.refresh(profileDetailsProvider);
                          //                                     EasyLoading.showSuccess('Added Successfully');
                          //                                     Future.delayed(const Duration(milliseconds: 500), () {
                          //                                       const Home().launch(context);
                          //                                     });
                          //                                   }
                          //                                 },
                          //                                 title: Text('${printerData.availableBluetoothDevices[index]}'),
                          //                                 subtitle: const Text("Click to connect"),
                          //                               );
                          //                             },
                          //                           ),
                          //                           const SizedBox(height: 10),
                          //                           Container(
                          //                             height: 1,
                          //                             width: double.infinity,
                          //                             color: Colors.grey,
                          //                           ),
                          //                           const SizedBox(height: 15),
                          //                           GestureDetector(
                          //                             onTap: () {
                          //                               consumerRef.refresh(customerProvider);
                          //                               consumerRef.refresh(productProvider);
                          //                               consumerRef.refresh(salesReportProvider);
                          //                               consumerRef.refresh(transitionProvider);
                          //                               consumerRef.refresh(profileDetailsProvider);
                          //                               const Home().launch(context);
                          //                             },
                          //                             child: const Center(
                          //                               child: Text(
                          //                                 'Cancel',
                          //                                 style: TextStyle(color: Constants.kMainColor),
                          //                               ),
                          //                             ),
                          //                           ),
                          //                           const SizedBox(height: 15),
                          //                         ],
                          //                       ),
                          //                     ),
                          //                   ),
                          //                 );
                          //               });
                          //         }
                          //       } else {
                          //         providerData.clearCart();
                          //         consumerRef.refresh(customerProvider);
                          //         consumerRef.refresh(productProvider);
                          //         consumerRef.refresh(salesReportProvider);
                          //         consumerRef.refresh(transitionProvider);
                          //         consumerRef.refresh(profileDetailsProvider);
                          //         EasyLoading.showSuccess('Added Successfully');
                          //         Future.delayed(const Duration(milliseconds: 500), () {
                          //           const SalesReportScreen().launch(context);
                          //         });
                          //       }
                          //       EasyLoading.showSuccess('Added Successfully');
                          //       // const Home().launch(context, isNewTask: true);
                          //     } catch (e) {
                          //       EasyLoading.dismiss();
                          //       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
                          //     }
                          //   }
                          // } else {
                          //   EasyLoading.showError('Add Product first');
                          // }
                        },
                        child: Container(
                          height: 60,
                          decoration: BoxDecoration(
                            color: Constants().kBgColor,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10)),
                          ),
                          child: const Center(
                            child: Text(
                              'Cancel',
                              style: TextStyle(fontSize: 18),
                            ),
                          ),
                        ),
                      )),
                      const SizedBox(width: 10),
                      Expanded(
                        child: GestureDetector(
                          onTap: () async {
                            if (providerData.cartItemList.isNotEmpty) {
                              if (widget.customerModel.type == 'Guest' &&
                                  dueAmount > 0) {
                                EasyLoading.showError(
                                    'Due is not available for guest');
                              } else {
                                if (!isClicked) {
                                  try {
                                    setState(() {
                                      isClicked = true;
                                    });
                                    EasyLoading.show(
                                        status: 'Loading...',
                                        dismissOnTap: false);

                                    DatabaseReference ref = FirebaseDatabase
                                        .instance
                                        .ref("$constUserId/Sales Transition");

                                    dueAmount <= 0
                                        ? transitionModel.isPaid = true
                                        : transitionModel.isPaid = false;
                                    dueAmount <= 0
                                        ? transitionModel.dueAmount = 0
                                        : transitionModel.dueAmount =
                                            double.parse(
                                                dueAmount.toStringAsFixed(2));
                                    returnAmount < 0
                                        ? transitionModel.returnAmount =
                                            returnAmount.abs()
                                        : transitionModel.returnAmount = 0;
                                    transitionModel.discountAmount =
                                        double.parse(
                                            discountAmount.toStringAsFixed(2));
                                    transitionModel.totalAmount = double.parse(
                                        subTotal.toStringAsFixed(2));
                                    transitionModel.productList =
                                        providerData.cartItemList;
                                    transitionModel.paymentType = dropdownValue;
                                    isSubUser
                                        ? transitionModel.sellerName =
                                            subUserTitle
                                        : null;
                                    transitionModel.invoiceNumber =
                                        invoice.toString();

                                    ///__________total LossProfit & quantity________________________________________________________________

                                    int totalQuantity = 0;
                                    double lossProfit = 0;
                                    double totalPurchasePrice = 0;
                                    double totalSalePrice = 0;
                                    for (var element
                                        in transitionModel.productList!) {
                                      totalPurchasePrice = totalPurchasePrice +
                                          (double.parse(element
                                                  .productPurchasePrice) *
                                              element.quantity);
                                      totalSalePrice = totalSalePrice +
                                          (double.parse(element.subTotal) *
                                              element.quantity);

                                      totalQuantity =
                                          totalQuantity + element.quantity;
                                    }
                                    lossProfit = ((totalSalePrice -
                                            totalPurchasePrice.toDouble()) -
                                        double.parse(transitionModel
                                            .discountAmount
                                            .toString()));

                                    transitionModel.totalQuantity =
                                        totalQuantity;
                                    transitionModel.lossProfit = double.parse(
                                        lossProfit.toStringAsFixed(2));
                                    ref.keepSynced(true);
                                    ref.push().set(transitionModel.toJson());

                                    ///__________StockMange_________________________________________________-

                                    for (var element
                                        in providerData.cartItemList) {
                                      decreaseStock(
                                          element.productId, element.quantity);
                                    }

                                    ///_______invoice_Update_____________________________________________
                                    final DatabaseReference
                                        personalInformationRef =
                                        FirebaseDatabase.instance
                                            .ref()
                                            .child(constUserId)
                                            .child('Personal Information');
                                    personalInformationModel.invoiceCounter =
                                        invoice + 1;
                                    personalInformationRef.keepSynced(true);

                                    personalInformationRef
                                        .set(personalInformationModel.toJson());
                                    // await personalInformationRef.update({'invoiceCounter': invoice + 1});

                                    ///________Subscription_____________________________________________________
                                    Subscription.decreaseSubscriptionLimits(
                                        itemType: 'saleNumber',
                                        context: context);

                                    ///_________DueUpdate______________________________________________________
                                    getSpecificCustomers(
                                        phoneNumber:
                                            widget.customerModel.phoneNumber,
                                        due:
                                            transitionModel.dueAmount!.toInt());

                                    ///________Print_______________________________________________________

                                    PrintTransactionModel model =
                                        PrintTransactionModel(
                                            transitionModel: transitionModel,
                                            personalInformationModel: data);
                                    if (isPrintEnable &&
                                        (Theme.of(context).platform ==
                                            TargetPlatform.android)) {
                                      await printerData.getBluetooth();
                                      if (connected) {
                                        await printerData.printTicket(
                                            printTransactionModel: model,
                                            productList:
                                                providerData.cartItemList);
                                        providerData.clearCart();
                                        consumerRef.refresh(customerProvider);
                                        consumerRef.refresh(productProvider);
                                        consumerRef
                                            .refresh(salesReportProvider);
                                        consumerRef.refresh(transitionProvider);
                                        consumerRef
                                            .refresh(profileDetailsProvider);

                                        EasyLoading.showSuccess(
                                            'Added Successfully');
                                        Future.delayed(
                                            const Duration(milliseconds: 500),
                                            () {
                                          const SalesReportScreen()
                                              .launch(context);
                                        });
                                      } else {
                                        EasyLoading.showSuccess(
                                            'Added Successfully');

                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(const SnackBar(
                                                content: Text(
                                                    'Please Connect The Printer First')));

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
                                                                List list =
                                                                    select.split(
                                                                        "#");
                                                                // String name = list[0];
                                                                String mac =
                                                                    list[1];
                                                                bool isConnect =
                                                                    await printerData
                                                                        .setConnect(
                                                                            mac);
                                                                if (isConnect) {
                                                                  await printerData.printTicket(
                                                                      printTransactionModel:
                                                                          model,
                                                                      productList:
                                                                          transitionModel
                                                                              .productList);
                                                                  providerData
                                                                      .clearCart();
                                                                  consumerRef
                                                                      .refresh(
                                                                          customerProvider);
                                                                  consumerRef
                                                                      .refresh(
                                                                          productProvider);
                                                                  consumerRef
                                                                      .refresh(
                                                                          salesReportProvider);
                                                                  consumerRef
                                                                      .refresh(
                                                                          transitionProvider);
                                                                  consumerRef
                                                                      .refresh(
                                                                          profileDetailsProvider);
                                                                  EasyLoading
                                                                      .showSuccess(
                                                                          'Added Successfully');
                                                                  Future.delayed(
                                                                      const Duration(
                                                                          milliseconds:
                                                                              500),
                                                                      () {
                                                                    const SalesReportScreen()
                                                                        .launch(
                                                                            context);
                                                                  });
                                                                }
                                                              },
                                                              title: Text(
                                                                  '${printerData.availableBluetoothDevices[index]}'),
                                                              subtitle: const Text(
                                                                  "Click to connect"),
                                                            );
                                                          },
                                                        ),
                                                        const SizedBox(
                                                            height: 10),
                                                        const Text(
                                                            'Please connect printer'),
                                                        const SizedBox(
                                                            height: 10),
                                                        Container(
                                                          height: 1,
                                                          width:
                                                              double.infinity,
                                                          color: Constants()
                                                              .kBgColor,
                                                        ),
                                                        const SizedBox(
                                                            height: 15),
                                                        GestureDetector(
                                                          onTap: () {
                                                            consumerRef.refresh(
                                                                customerProvider);
                                                            consumerRef.refresh(
                                                                productProvider);
                                                            consumerRef.refresh(
                                                                salesReportProvider);
                                                            consumerRef.refresh(
                                                                transitionProvider);
                                                            consumerRef.refresh(
                                                                profileDetailsProvider);
                                                            const SalesReportScreen()
                                                                .launch(
                                                                    context);
                                                          },
                                                          child: Center(
                                                            child: Text(
                                                              'Cancel',
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
                                      }
                                    } else {
                                      providerData.clearCart();
                                      consumerRef.refresh(customerProvider);
                                      consumerRef.refresh(productProvider);
                                      consumerRef.refresh(salesReportProvider);
                                      consumerRef.refresh(transitionProvider);
                                      consumerRef
                                          .refresh(profileDetailsProvider);
                                      EasyLoading.showSuccess(
                                          'Added Successfully');
                                      Future.delayed(
                                          const Duration(milliseconds: 500),
                                          () {
                                        const SalesReportScreen()
                                            .launch(context);
                                      });
                                    }
                                  } catch (e) {
                                    EasyLoading.dismiss();
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text(e.toString())));
                                  }
                                }
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
                            child: const Center(
                              child: Text(
                                'Save',
                                style: TextStyle(
                                    fontSize: 18, color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
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

  void decreaseStock(String productCode, int quantity) async {
    final ref = FirebaseDatabase.instance.ref('$constUserId/Products/');
    ref.keepSynced(true);
    ref.orderByKey().get().then((value) {
      for (var element in value.children) {
        var data = jsonDecode(jsonEncode(element.value));
        if (data['productCode'] == productCode) {
          String? key = element.key;
          int previousStock =
              element.child('productStock').value.toString().toInt();
          int remainStock = previousStock - quantity;
          ref.child(key!).update({'productStock': '$remainStock'});
        }
      }
    });

    // var data = await ref.orderByChild('productCode').equalTo(productCode).once();
    // String productPath = data.snapshot.value.toString().substring(1, 21);
    //
    // var data1 = await ref.child('$productPath/productStock').once();
    // int stock = int.parse(data1.snapshot.value.toString());
    // int remainStock = stock - quantity;
    //
    // ref.child(productPath).update({'productStock': '$remainStock'});
  }

  // void decreaseSubscriptionSale() async {
  //   final ref = FirebaseDatabase.instance.ref('$constUserId/Subscription/saleNumber');
  //   var data = await ref.once();
  //   int beforeSale = int.parse(data.snapshot.value.toString());
  //   int afterSale = beforeSale - 1;
  //   beforeSale != -202 ? FirebaseDatabase.instance.ref('$constUserId/Subscription').update({'saleNumber': afterSale}) : null;
  //
  //   final ref = FirebaseDatabase.instance.ref(constUserId).child('Subscription');
  //   ref.keepSynced(true);
  //   ref.child(itemType).get().then((value){
  //     print(value.value);
  //     int beforeAction = int.parse(value.value.toString());
  //     int afterAction = beforeAction - 1;
  //     ref.update({itemType: afterAction});
  //   });
  // }

  void getSpecificCustomers(
      {required String phoneNumber, required int due}) async {
    final ref = FirebaseDatabase.instance.ref('$constUserId/Customers/');
    ref.keepSynced(true);
    String? key;

    ref.orderByKey().get().then((value) {
      for (var element in value.children) {
        var data = jsonDecode(jsonEncode(element.value));
        if (data['phoneNumber'] == phoneNumber) {
          key = element.key;
          int previousDue = element.child('due').value.toString().toInt();
          int totalDue = previousDue + due;
          ref.child(key!).update({'due': '$totalDue'});
        }
      }
    });
    // var data1 = await ref.child('$key/due').once();
    // int previousDue = data1.snapshot.value.toString().toInt();
    //
    // int totalDue = previousDue + due;
    // ref.child(key!).update({'due': '$totalDue'});
  }
}
