// ignore_for_file: unused_result

import 'dart:convert';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:mobile_pos/Provider/customer_provider.dart';
import 'package:mobile_pos/Provider/transactions_provider.dart';
import 'package:mobile_pos/Screens/Purchase%20List/purchase_edit_invoice_add_productes.dart';
import 'package:mobile_pos/model/product_model.dart';
import 'package:mobile_pos/model/transition_model.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../Provider/add_to_cart_purchase.dart';
import '../../Provider/product_provider.dart';
import '../../Provider/profile_provider.dart';
import '../../Provider/purchase_report_provider.dart';
import '../../constant.dart';
import 'package:mobile_pos/Screens/Parties_Customers/Model/customer_model.dart';
import 'package:mobile_pos/generated/l10n.dart' as lang;

class PurchaseListEditScreen extends StatefulWidget {
  const PurchaseListEditScreen({Key? key, required this.transitionModel})
      : super(key: key);

  final PurchaseTransitionModel transitionModel;

  @override
  State<PurchaseListEditScreen> createState() => _PurchaseListEditScreenState();
}

class _PurchaseListEditScreenState extends State<PurchaseListEditScreen> {
  @override
  void initState() {
    pastProducts = widget.transitionModel.productList!;
    transitionModel = widget.transitionModel;
    paidAmount = double.parse(widget.transitionModel.totalAmount.toString()) -
        double.parse(widget.transitionModel.dueAmount.toString()) +
        double.parse(widget.transitionModel.returnAmount.toString());
    dropdownValue = widget.transitionModel.paymentType;
    discountAmount = widget.transitionModel.discountAmount!;
    discountText.text = discountAmount.toString();
    paidText.text = paidAmount.toString();
    pastDue = widget.transitionModel.dueAmount!.toInt();
    returnAmount = widget.transitionModel.returnAmount!;
    invoice = widget.transitionModel.invoiceNumber.toInt();
    // TODO: implement initState
    super.initState();
  }

  int pastDue = 0;

  late PurchaseTransitionModel transitionModel = PurchaseTransitionModel(
    customerName: widget.transitionModel.customerName,
    customerPhone: widget.transitionModel.customerPhone,
    customerType: widget.transitionModel.customerType,
    invoiceNumber: invoice.toString(),
    purchaseDate: DateTime.now().toString(),
  );

  List<ProductModel> pastProducts = [];
  List<ProductModel> presentProducts = [];
  List<ProductModel> decreaseStockList2 = [];
  List<ProductModel> increaseStockList = [];

  TextEditingController discountText = TextEditingController();
  TextEditingController paidText = TextEditingController();

  int invoice = 0;
  double paidAmount = 0;
  double discountAmount = 0;
  double returnAmount = 0;
  double dueAmount = 0;
  double subTotal = 0;
  String? dropdownValue = 'Cash';

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

  bool doNotCheckProducts = false;

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, consumerRef, __) {
      final providerData = consumerRef.watch(cartNotifierPurchase);
      final personalData = consumerRef.watch(profileDetailsProvider);
      final productList = consumerRef.watch(productProvider);

      ///__________Add_previous_products_in_the_List___________________________________________

      if (!doNotCheckProducts) {
        List<ProductModel> cartList = [];
        for (var element in widget.transitionModel.productList!) {
          productList.value?.forEach((products) {
            if (element.productCode == products.productCode) {
              ProductModel cartItem = products;
              cartItem.productStock = element.productStock;
              cartList.add(cartItem);
            }
          });
          if (widget.transitionModel.productList?.length == cartList.length) {
            providerData.addToCartRiverPodForEdit(cartList);
            doNotCheckProducts = true;
          }
        }
      }
      return personalData.when(data: (data) {
        return Scaffold(
          appBar: AppBar(
            title: Text(
              lang.S.of(context).purchaseReport,
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
                          Column(
                            children: [
                              Column(
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: AppTextField(
                                          textFieldType: TextFieldType.NAME,
                                          readOnly: true,
                                          initialValue: widget
                                              .transitionModel.invoiceNumber,
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
                                          initialValue: DateFormat.yMMMd()
                                              .format(DateTime.parse(
                                            widget.transitionModel.purchaseDate,
                                          )),
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
                                              onPressed: () async {},
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
                                  AppTextField(
                                    textFieldType: TextFieldType.NAME,
                                    readOnly: true,
                                    initialValue:
                                        widget.transitionModel.customerName,
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
                                      labelText:
                                          lang.S.of(context).customerName,
                                      border: const OutlineInputBorder(),
                                    ),
                                  ),
                                  const SizedBox(height: 10),

                                  ///_______Added_ItemS__________________________________________________
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(10),
                                          topRight: Radius.circular(10)),
                                      border: Border.all(
                                          width: 1,
                                          color: const Color(0xffEAEFFA)),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          width: double.infinity,
                                          decoration: BoxDecoration(
                                            color: Constants().kBgColor,
                                            borderRadius:
                                                const BorderRadius.only(
                                                    topLeft:
                                                        Radius.circular(10),
                                                    topRight:
                                                        Radius.circular(10)),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(10),
                                            child: Text(
                                              lang.S.of(context).itemAdded,
                                              style:
                                                  const TextStyle(fontSize: 16),
                                            ),
                                          ),
                                        ),
                                        ListView.builder(
                                            shrinkWrap: true,
                                            physics:
                                                const NeverScrollableScrollPhysics(),
                                            itemCount: providerData
                                                .cartItemPurchaseList.length,
                                            itemBuilder: (context, index) {
                                              int i = 0;
                                              for (var element
                                                  in pastProducts) {
                                                if (element.productCode !=
                                                    providerData
                                                        .cartItemPurchaseList[
                                                            index]
                                                        .productCode) {
                                                  i++;
                                                }
                                                if (i == pastProducts.length) {
                                                  bool isInTheList = false;
                                                  for (var element
                                                      in increaseStockList) {
                                                    if (element.productCode ==
                                                        providerData
                                                            .cartItemPurchaseList[
                                                                index]
                                                            .productCode) {
                                                      element.productStock =
                                                          providerData
                                                              .cartItemPurchaseList[
                                                                  index]
                                                              .productStock;
                                                      isInTheList = true;
                                                      break;
                                                    }
                                                  }

                                                  isInTheList
                                                      ? null
                                                      : increaseStockList.add(
                                                          providerData
                                                                  .cartItemPurchaseList[
                                                              index]);
                                                }
                                              }
                                              return Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 10, right: 10),
                                                child: ListTile(
                                                  contentPadding:
                                                      const EdgeInsets.all(0),
                                                  title: Text(providerData
                                                      .cartItemPurchaseList[
                                                          index]
                                                      .productName
                                                      .toString()),
                                                  subtitle: Text(
                                                      '${providerData.cartItemPurchaseList[index].productStock} X ${providerData.cartItemPurchaseList[index].productPurchasePrice} = ${double.parse(providerData.cartItemPurchaseList[index].productStock) * providerData.cartItemPurchaseList[index].productPurchasePrice.toInt()}'),
                                                  trailing: Row(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      Text(
                                                          ' ${lang.S.of(context).quantity}: ${providerData.cartItemPurchaseList[index].productStock}'),
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
                                                    ],
                                                  ),
                                                ),
                                              );
                                            }),
                                      ],
                                    ).visible(providerData
                                        .cartItemPurchaseList.isNotEmpty),
                                  ),
                                  const SizedBox(height: 10),

                                  ///_______Add_Button__________________________________________________
                                  GestureDetector(
                                    onTap: () {
                                      EditPurchaseInvoiceSaleProducts(
                                        catName: null,
                                        customerModel: CustomerModel(
                                            widget.transitionModel.customerName,
                                            widget
                                                .transitionModel.customerPhone,
                                            widget.transitionModel.customerType,
                                            '',
                                            '',
                                            '',
                                            ''),
                                        transitionModel: widget.transitionModel,
                                      ).launch(context);
                                    },
                                    child: Container(
                                      height: 50,
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                          color: Constants.kMainColor
                                              .withOpacity(0.1),
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(10))),
                                      child: Center(
                                        child: Text(
                                          lang.S.of(context).addItems,
                                          style: TextStyle(
                                              color: Constants.kMainColor,
                                              fontSize: 20),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 10),

                                  ///_____Total______________________________
                                  Container(
                                    decoration: BoxDecoration(
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(10)),
                                        border: Border.all(
                                            color: Constants().kBgColor,
                                            width: 1)),
                                    child: Column(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                              color: Constants().kBgColor,
                                              borderRadius:
                                                  const BorderRadius.only(
                                                      topRight:
                                                          Radius.circular(10),
                                                      topLeft:
                                                          Radius.circular(10))),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                lang.S.of(context).subTotal,
                                                style: const TextStyle(
                                                    fontSize: 16),
                                              ),
                                              Text(
                                                providerData
                                                    .getTotalAmount()
                                                    .toString(),
                                                style: const TextStyle(
                                                    fontSize: 16),
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
                                                lang.S.of(context).discount,
                                                style: const TextStyle(
                                                    fontSize: 16),
                                              ),
                                              SizedBox(
                                                width: context.width() / 4,
                                                child: TextField(
                                                  controller: discountText,
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
                                                              double.parse(
                                                                  value);
                                                        });
                                                      } else {
                                                        discountText.clear();
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
                                                    hintText: '0',
                                                  ),
                                                  keyboardType:
                                                      TextInputType.number,
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
                                                lang.S.of(context).total,
                                                style: const TextStyle(
                                                    fontSize: 16),
                                              ),
                                              Text(
                                                calculateSubtotal(
                                                        total: providerData
                                                            .getTotalAmount())
                                                    .toString(),
                                                style: const TextStyle(
                                                    fontSize: 16),
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
                                                style: const TextStyle(
                                                    fontSize: 16),
                                              ),
                                              SizedBox(
                                                width: context.width() / 4,
                                                child: TextField(
                                                  controller: paidText,
                                                  keyboardType:
                                                      TextInputType.number,
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
                                          padding: const EdgeInsets.all(10.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                lang.S.of(context).returnAmount,
                                                style: const TextStyle(
                                                    fontSize: 16),
                                              ),
                                              Text(
                                                calculateReturnAmount(
                                                        total: subTotal)
                                                    .abs()
                                                    .toString(),
                                                style: const TextStyle(
                                                    fontSize: 16),
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
                                                style: const TextStyle(
                                                    fontSize: 16),
                                              ),
                                              Text(
                                                calculateDueAmount(
                                                        total: subTotal)
                                                    .toString(),
                                                style: const TextStyle(
                                                    fontSize: 16),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  // const SizedBox(height: 10),
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
                                          width: 1,
                                          color: Constants().kBgColor),
                                    ),
                                    padding: const EdgeInsets.all(10),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              lang.S.of(context).paymentTypes,
                                              style: const TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.black54),
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
                                          value: dropdownValue,
                                          icon: Icon(
                                            Icons.keyboard_arrow_down,
                                            color: Constants.kMainColor,
                                          ),
                                          items: paymentsTypeList
                                              .map((String items) {
                                            return DropdownMenuItem(
                                              value: items,
                                              child: Text(items),
                                            );
                                          }).toList(),
                                          onChanged: (newValue) {
                                            setState(() {
                                              dropdownValue =
                                                  newValue.toString();
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
                                  // const SizedBox(
                                  //   height: 30,
                                  // ),
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
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(10)),
                                              color: Colors.grey.shade200),
                                          child: const Center(
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Icon(
                                                  FeatherIcons.camera,
                                                  color: Colors.grey,
                                                ),
                                                SizedBox(width: 5),
                                                Text(
                                                  'Image',
                                                  style: TextStyle(
                                                      color: Colors.grey,
                                                      fontSize: 16),
                                                )
                                              ],
                                            ),
                                          )),
                                    ],
                                  ).visible(false),
                                ],
                              ),
                            ],
                          ),
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
                              if (providerData
                                  .cartItemPurchaseList.isNotEmpty) {
                                try {
                                  EasyLoading.show(
                                      status: 'Loading...',
                                      dismissOnTap: false);

                                  dueAmount <= 0
                                      ? transitionModel.isPaid = true
                                      : transitionModel.isPaid = false;
                                  dueAmount <= 0
                                      ? transitionModel.dueAmount = 0
                                      : transitionModel.dueAmount = dueAmount;
                                  returnAmount < 0
                                      ? transitionModel.returnAmount =
                                          returnAmount.abs()
                                      : transitionModel.returnAmount = 0;
                                  transitionModel.discountAmount =
                                      discountAmount;
                                  transitionModel.totalAmount = subTotal;
                                  transitionModel.productList =
                                      providerData.cartItemPurchaseList;
                                  transitionModel.paymentType = dropdownValue;
                                  transitionModel.invoiceNumber =
                                      invoice.toString();

                                  ///________________updateInvoice___________________________________________________________
                                  String? key;
                                  await FirebaseDatabase.instance
                                      .ref(constUserId)
                                      .child('Purchase Transition')
                                      .orderByKey()
                                      .get()
                                      .then((value) {
                                    for (var element in value.children) {
                                      final t =
                                          PurchaseTransitionModel.fromJson(
                                              jsonDecode(
                                                  jsonEncode(element.value)));
                                      if (transitionModel.invoiceNumber ==
                                          t.invoiceNumber) {
                                        key = element.key;
                                      }
                                    }
                                  });
                                  await FirebaseDatabase.instance
                                      .ref(constUserId)
                                      .child('Purchase Transition')
                                      .child(key!)
                                      .update(transitionModel.toJson());

                                  ///__________StockMange_________________________________________________

                                  presentProducts =
                                      transitionModel.productList!;

                                  for (var pastElement in pastProducts) {
                                    int i = 0;
                                    for (var futureElement in presentProducts) {
                                      if (pastElement.productCode ==
                                          futureElement.productCode) {
                                        if (pastElement.productStock.toInt() <
                                                futureElement.productStock
                                                    .toInt() &&
                                            pastElement.productStock !=
                                                futureElement.productStock) {
                                          ProductModel m = pastElement;
                                          m.productStock = (futureElement
                                                      .productStock
                                                      .toInt() -
                                                  pastElement.productStock
                                                      .toInt())
                                              .toString();
                                          // ignore: iterable_contains_unrelated_type
                                          increaseStockList.contains(
                                                  pastElement.productCode)
                                              ? null
                                              : increaseStockList.add(m);
                                        } else if (pastElement.productStock
                                                    .toInt() >
                                                futureElement.productStock
                                                    .toInt() &&
                                            pastElement.productStock.toInt() !=
                                                futureElement.productStock
                                                    .toInt()) {
                                          ProductModel n = pastElement;
                                          n.productStock = (pastElement
                                                      .productStock
                                                      .toInt() -
                                                  futureElement.productStock
                                                      .toInt())
                                              .toString();
                                          // ignore: iterable_contains_unrelated_type
                                          decreaseStockList2.contains(
                                                  pastElement.productCode)
                                              ? null
                                              : decreaseStockList2.add(n);
                                        }
                                        break;
                                      } else {
                                        i++;
                                        if (i == presentProducts.length) {
                                          ProductModel n = pastElement;
                                          decreaseStockList2.add(n);
                                        }
                                      }
                                    }
                                  }

                                  ///_____________StockUpdate_______________________________________________________

                                  for (var element in increaseStockList) {
                                    increaseStock(
                                        productCode: element.productCode,
                                        productModel: element);
                                  }

                                  for (var element in decreaseStockList2) {
                                    decreaseStock(
                                        productCode: element.productCode,
                                        productModel: element);
                                  }

                                  ///_________DueUpdate______________________________________________________
                                  if (pastDue < transitionModel.dueAmount!) {
                                    double due =
                                        pastDue - transitionModel.dueAmount!;
                                    getSpecificCustomersDueUpdate(
                                        phoneNumber: widget
                                            .transitionModel.customerPhone,
                                        isDuePaid: false,
                                        due: due.toInt());
                                  } else if (pastDue >
                                      transitionModel.dueAmount!) {
                                    double due =
                                        transitionModel.dueAmount! - pastDue;
                                    getSpecificCustomersDueUpdate(
                                        phoneNumber: widget
                                            .transitionModel.customerPhone,
                                        isDuePaid: true,
                                        due: due.toInt());
                                  }

                                  providerData.clearCart();
                                  consumerRef.refresh(customerProvider);
                                  consumerRef.refresh(productProvider);
                                  consumerRef.refresh(purchaseReportProvider);
                                  consumerRef
                                      .refresh(purchaseTransitionProvider);
                                  consumerRef.refresh(profileDetailsProvider);
                                  EasyLoading.dismiss();

                                  // ignore: use_build_context_synchronously
                                  Navigator.pop(context);
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

  void increaseStock(
      {required String productCode, required ProductModel productModel}) async {
    final ref = FirebaseDatabase.instance.ref('$constUserId/Products/');

    var data =
        await ref.orderByChild('productCode').equalTo(productCode).once();
    String productPath = data.snapshot.value.toString().substring(1, 21);

    var data1 = await ref.child('$productPath/productStock').once();
    int stock = int.parse(data1.snapshot.value.toString());
    int remainStock = stock + productModel.productStock.toInt();

    ref.child(productPath).update({
      'productSalePrice': productModel.productSalePrice,
      'productPurchasePrice': productModel.productPurchasePrice,
      'productWholeSalePrice': productModel.productWholeSalePrice,
      'productDealerPrice': productModel.productDealerPrice,
      'productStock': '$remainStock',
    });
  }

  void decreaseStock(
      {required String productCode, required ProductModel productModel}) async {
    final ref = FirebaseDatabase.instance.ref('$constUserId/Products/');

    var data =
        await ref.orderByChild('productCode').equalTo(productCode).once();
    String productPath = data.snapshot.value.toString().substring(1, 21);

    var data1 = await ref.child('$productPath/productStock').once();
    int stock = int.parse(data1.snapshot.value.toString());
    int remainStock = stock - productModel.productStock.toInt();

    ref.child(productPath).update({
      'productSalePrice': productModel.productSalePrice,
      'productPurchasePrice': productModel.productPurchasePrice,
      'productWholeSalePrice': productModel.productWholeSalePrice,
      'productDealerPrice': productModel.productDealerPrice,
      'productStock': '$remainStock',
    });
  }

  void getSpecificCustomersDueUpdate(
      {required String phoneNumber,
      required bool isDuePaid,
      required int due}) async {
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

    int totalDue;

    isDuePaid ? totalDue = previousDue + due : totalDue = previousDue - due;
    ref.child(key!).update({'due': '$totalDue'});
  }
}
