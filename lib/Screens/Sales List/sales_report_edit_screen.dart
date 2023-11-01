// ignore_for_file: unused_result

import 'dart:convert';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:mobile_pos/Provider/add_to_cart.dart';
import 'package:mobile_pos/Provider/profile_provider.dart';
import 'package:mobile_pos/Screens/Sales%20List/sales_Edit_invoice_add_products.dart';
import 'package:mobile_pos/model/transition_model.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../Provider/customer_provider.dart';
import '../../Provider/product_provider.dart';
import '../../Provider/seles_report_provider.dart';
import '../../Provider/transactions_provider.dart';
import '../../constant.dart';
import '../../model/add_to_cart_model.dart';
import 'package:mobile_pos/Screens/Parties_Customers/Model/customer_model.dart';
import 'package:mobile_pos/generated/l10n.dart' as lang;

// ignore: must_be_immutable
class SalesReportEditScreen extends StatefulWidget {
  SalesReportEditScreen({Key? key, required this.transitionModel})
      : super(key: key);
  TransitionModel transitionModel;

  @override
  State<SalesReportEditScreen> createState() => _SalesReportEditScreenState();
}

class _SalesReportEditScreenState extends State<SalesReportEditScreen> {
  @override
  void initState() {
    pastProducts = widget.transitionModel.productList!;
    // TODO: implement initState
    super.initState();
    transitionModel = widget.transitionModel;
    paidAmount = double.parse(widget.transitionModel.totalAmount.toString()) -
        double.parse(widget.transitionModel.dueAmount.toString()) +
        double.parse(widget.transitionModel.returnAmount.toString());
    discountAmount = widget.transitionModel.discountAmount!;
    dropdownValue = widget.transitionModel.paymentType;
    discountText.text = discountAmount.toString();
    paidText.text = paidAmount.toString();
    pastDue = widget.transitionModel.dueAmount!.toInt();
    returnAmount = widget.transitionModel.returnAmount!;
    invoice = widget.transitionModel.invoiceNumber.toInt();
  }

  int pastDue = 0;

  TextEditingController discountText = TextEditingController();
  TextEditingController paidText = TextEditingController();

  int invoice = 0;
  double paidAmount = 0;
  double discountAmount = 0;
  double returnAmount = 0;
  double dueAmount = 0;
  double subTotal = 0;

  bool isGuestCustomer = false;

  List<AddToCartModel> pastProducts = [];
  List<AddToCartModel> presentProducts = [];
  List<AddToCartModel> increaseStockList = [];
  List<AddToCartModel> decreaseStockList = [];

  String? dropdownValue = 'Cash';
  String? selectedPaymentType;

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
    customerName: widget.transitionModel.customerName,
    customerPhone: '',
    customerType: '',
    invoiceNumber: invoice.toString(),
    purchaseDate: DateTime.now().toString(),
  );
  DateTime selectedDate = DateTime.now();
  bool doNotCheckProducts = false;

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, consumerRef, __) {
      final providerData = consumerRef.watch(cartNotifier);
      final personalData = consumerRef.watch(profileDetailsProvider);
      final productList = consumerRef.watch(productProvider);

      if (!doNotCheckProducts) {
        List<AddToCartModel> list = [];
        productList.value?.forEach((products) {
          String sentProductPrice = '';

          widget.transitionModel.productList?.forEach((element) {
            if (element.productId == products.productCode) {
              if (widget.transitionModel.customerType.contains('Retailer')) {
                sentProductPrice = products.productSalePrice;
              } else if (widget.transitionModel.customerType
                  .contains('Dealer')) {
                sentProductPrice = products.productDealerPrice;
              } else if (widget.transitionModel.customerType
                  .contains('Wholesaler')) {
                sentProductPrice = products.productWholeSalePrice;
              } else if (widget.transitionModel.customerType
                  .contains('Supplier')) {
                sentProductPrice = products.productPurchasePrice;
              } else if (widget.transitionModel.customerType
                  .contains('Guest')) {
                sentProductPrice = products.productSalePrice;
                isGuestCustomer = true;
              }

              AddToCartModel cartItem = AddToCartModel(
                productName: products.productName,
                subTotal: sentProductPrice,
                quantity: element.quantity,
                productId: products.productCode,
                productBrandName: products.brandName,
                stock: int.parse(
                  products.productStock,
                ),
                //stock: int.parse(products[i].productStock),
                uuid: products.productCode,
                productPicture: products.productPicture,
                capacity: products.capacity,
                color: products.color,
                type: products.type,
                size: products.size,
                weight: products.weight,
              );
              list.add(cartItem);

              // providerData.addProductsInSales(products);
            }
          });

          if (widget.transitionModel.productList?.length == list.length) {
            providerData.addToCartRiverPodForEdit(list);
            doNotCheckProducts = true;
          }
        });
      }
      return personalData.when(data: (data) {
        // invoice = data.invoiceCounter!.toInt();
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            title: Text(
              lang.S.of(context).editSalesInvoice,
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
                                  initialValue:
                                      widget.transitionModel.invoiceNumber,
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
                                  initialValue:
                                      DateFormat.yMMMd().format(DateTime.parse(
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
                          const SizedBox(height: 30),
                          AppTextField(
                            textFieldType: TextFieldType.NAME,
                            readOnly: true,
                            initialValue: widget.transitionModel.customerName,
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
                                                                "${providerData.cartItemList[index].productPicture}??"
                                                                " "),
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
                                                    ),
                                                  ),
                                                ),
                                                Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    SizedBox(
                                                      width: 80,
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
                                                              width: 5),
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
                                                              width: 5),
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
                                                        int i = 0;
                                                        for (var element
                                                            in pastProducts) {
                                                          if (element
                                                                  .productId !=
                                                              providerData
                                                                  .cartItemList[
                                                                      index]
                                                                  .productId) {
                                                            i++;
                                                          }
                                                          if (i ==
                                                              pastProducts
                                                                  .length) {
                                                            decreaseStockList.removeWhere((element) =>
                                                                element
                                                                    .productId ==
                                                                providerData
                                                                    .cartItemList[
                                                                        index]
                                                                    .productId);
                                                          }
                                                        }

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
                              EditSaleInvoiceSaleProducts(
                                catName: null,
                                customerModel: CustomerModel(
                                    widget.transitionModel.customerName,
                                    widget.transitionModel.customerPhone,
                                    widget.transitionModel.customerType,
                                    '',
                                    '',
                                    'customerAddress',
                                    ''),
                                transitionModel: widget.transitionModel,
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
                                            .toString(),
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
                                        lang.S.of(context).discount,
                                        style: const TextStyle(fontSize: 16),
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
                                                      double.parse(value);
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
                                        lang.S.of(context).total,
                                        style: const TextStyle(fontSize: 16),
                                      ),
                                      Text(
                                        calculateSubtotal(
                                                total: providerData
                                                    .getTotalAmount())
                                            .toString(),
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
                                        lang.S.of(context).previousPayAmount,
                                        style: const TextStyle(fontSize: 16),
                                      ),
                                      Text(
                                        (double.parse(widget
                                                    .transitionModel.totalAmount
                                                    .toString()) -
                                                double.parse(widget
                                                    .transitionModel.dueAmount
                                                    .toString()) +
                                                double.parse(widget
                                                    .transitionModel
                                                    .returnAmount
                                                    .toString()))
                                            .toString(),
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
                                  padding: const EdgeInsets.all(10.0),
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
                                            .toString(),
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
                                        lang.S.of(context).dueAmount,
                                        style: const TextStyle(fontSize: 16),
                                      ),
                                      Text(
                                        calculateDueAmount(total: subTotal)
                                            .toString(),
                                        style: const TextStyle(fontSize: 16),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // const SizedBox(height: 20),
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
                                  underline: Container(
                                    height: 1.5,
                                    color: Constants.kMainColor,
                                  ),
                                  value: dropdownValue,
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
                              if (providerData.cartItemList.isNotEmpty) {
                                if (isGuestCustomer && dueAmount > 0) {
                                  EasyLoading.showError(
                                      'Due is not for Guest Customer');
                                } else {
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
                                        providerData.cartItemList;
                                    transitionModel.paymentType = dropdownValue;
                                    transitionModel.invoiceNumber =
                                        invoice.toString();

                                    ///________________updateInvoice___________________________________________________________
                                    String? key;
                                    await FirebaseDatabase.instance
                                        .ref(constUserId)
                                        .child('Sales Transition')
                                        .orderByKey()
                                        .get()
                                        .then((value) {
                                      for (var element in value.children) {
                                        final t = TransitionModel.fromJson(
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
                                        .child('Sales Transition')
                                        .child(key!)
                                        .update(transitionModel.toJson());

                                    ///__________StockMange_________________________________________________

                                    presentProducts =
                                        transitionModel.productList!;

                                    for (var pastElement in pastProducts) {
                                      int i = 0;
                                      for (var futureElement
                                          in presentProducts) {
                                        if (pastElement.productId ==
                                            futureElement.productId) {
                                          if (pastElement.quantity <
                                                  futureElement.quantity &&
                                              pastElement.quantity !=
                                                  futureElement.quantity) {
                                            decreaseStockList.contains(
                                                    pastElement.productId)
                                                ? null
                                                : decreaseStockList.add(
                                                    AddToCartModel(
                                                      productName: pastElement
                                                          .productName,
                                                      productId:
                                                          pastElement.productId,
                                                      quantity: futureElement
                                                              .quantity
                                                              .toInt() -
                                                          pastElement.quantity
                                                              .toInt(),
                                                    ),
                                                  );
                                          } else if (pastElement.quantity >
                                                  futureElement.quantity &&
                                              pastElement.quantity !=
                                                  futureElement.quantity) {
                                            increaseStockList.contains(
                                                    pastElement.productId)
                                                ? null
                                                : increaseStockList.add(
                                                    AddToCartModel(
                                                      productName: pastElement
                                                          .productName,
                                                      productId:
                                                          pastElement.productId,
                                                      quantity:
                                                          pastElement.quantity -
                                                              futureElement
                                                                  .quantity,
                                                    ),
                                                  );
                                          }
                                          break;
                                        } else {
                                          i++;
                                          if (i == presentProducts.length) {
                                            increaseStockList.add(
                                              AddToCartModel(
                                                productName:
                                                    pastElement.productName,
                                                productId:
                                                    pastElement.productId,
                                                quantity: pastElement.quantity,
                                              ),
                                            );
                                          }
                                        }
                                      }
                                    }

                                    ///_____________StockUpdate_______________________________________________________

                                    for (var element in decreaseStockList) {
                                      decreaseStock(
                                          element.productId, element.quantity);
                                    }

                                    for (var element in increaseStockList) {
                                      increaseStock(
                                          element.productId, element.quantity);
                                    }
                                    // double due = transitionModel.dueAmount! - widget.transitionModel.dueAmount!;
                                    // print(due.toInt());

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
                                    // getSpecificCustomersDueUpdate(phoneNumber: widget.transitionModel.customerPhone, isDuePaid: true, due: 20);

                                    providerData.clearCart();
                                    consumerRef.refresh(customerProvider);
                                    consumerRef.refresh(productProvider);
                                    consumerRef.refresh(salesReportProvider);
                                    consumerRef.refresh(transitionProvider);
                                    consumerRef.refresh(profileDetailsProvider);

                                    EasyLoading.dismiss();

                                    // ignore: use_build_context_synchronously
                                    Navigator.pop(context);
                                  } catch (e) {
                                    EasyLoading.dismiss();
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text(e.toString())));
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

  void decreaseStock(String productCode, int quantity) async {
    final ref = FirebaseDatabase.instance.ref('$constUserId/Products/');

    var data =
        await ref.orderByChild('productCode').equalTo(productCode).once();
    String productPath = data.snapshot.value.toString().substring(1, 21);

    var data1 = await ref.child('$productPath/productStock').once();
    int stock = int.parse(data1.snapshot.value.toString());
    int remainStock = stock - quantity;

    ref.child(productPath).update({'productStock': '$remainStock'});
  }

  void increaseStock(String productCode, int quantity) async {
    final ref = FirebaseDatabase.instance.ref('$constUserId/Products/');

    var data =
        await ref.orderByChild('productCode').equalTo(productCode).once();
    String productPath = data.snapshot.value.toString().substring(1, 21);

    var data1 = await ref.child('$productPath/productStock').once();
    int stock = int.parse(data1.snapshot.value.toString());
    int remainStock = stock + quantity;

    ref.child(productPath).update({'productStock': '$remainStock'});
  }

  void decreaseSubscriptionSale() async {
    final ref =
        FirebaseDatabase.instance.ref('$constUserId/Subscription/saleNumber');
    var data = await ref.once();
    int beforeSale = int.parse(data.snapshot.value.toString());
    int afterSale = beforeSale - 1;
    FirebaseDatabase.instance
        .ref('$constUserId/Subscription')
        .update({'saleNumber': afterSale});
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
