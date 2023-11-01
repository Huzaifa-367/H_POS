// ignore_for_file: unused_result

import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_cart/flutter_cart.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_pos/GlobalComponents/Product_Card.dart';
import 'package:mobile_pos/Provider/product_provider.dart';
import 'package:mobile_pos/Screens/Parties_Customers/Model/customer_model.dart';
import 'package:mobile_pos/constant.dart';
import 'package:mobile_pos/model/product_model.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../Provider/add_to_cart.dart';
import '../../Provider/add_to_cart_purchase.dart';
import '../../currency.dart';
import '../../model/transition_model.dart';
import 'package:mobile_pos/generated/l10n.dart' as lang;

// ignore: must_be_immutable
class EditPurchaseInvoiceSaleProducts extends StatefulWidget {
  EditPurchaseInvoiceSaleProducts(
      {Key? key,
      @required this.catName,
      this.customerModel,
      required this.transitionModel})
      : super(key: key);

  // ignore: prefer_typing_uninitialized_variables
  var catName;
  CustomerModel? customerModel;
  PurchaseTransitionModel transitionModel;

  @override
  State<EditPurchaseInvoiceSaleProducts> createState() =>
      _EditPurchaseInvoiceSaleProductsState();
}

class _EditPurchaseInvoiceSaleProductsState
    extends State<EditPurchaseInvoiceSaleProducts> {
  String dropdownValue = '';
  String productCode = '0000';

  var salesCart = FlutterCart();
  String total = 'Cart Is Empty';
  int items = 0;
  String productPrice = '0';
  String sentProductPrice = '';

  @override
  void initState() {
    widget.catName == null
        ? dropdownValue = 'Fashion'
        : dropdownValue = widget.catName;
    super.initState();
  }

  Future<void> scanBarcodeNormal() async {
    String barcodeScanRes;
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.BARCODE);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }
    if (!mounted) return;

    setState(() {
      productCode = barcodeScanRes;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, __) {
      final providerData = ref.watch(cartNotifierPurchase);
      final productList = ref.watch(productProvider);

      return Scaffold(
        appBar: AppBar(
          title: Text(
            lang.S.of(context).salesDetails,
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
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(
                  height: 20.0,
                ),
                Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: AppTextField(
                          textFieldType: TextFieldType.NAME,
                          onChanged: (value) {
                            setState(() {
                              productCode = value;
                            });
                          },
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
                            labelText: lang.S.of(context).productCode,
                            hintText:
                                productCode == '0000' || productCode == '-1'
                                    ? 'Scan product QR code'
                                    : productCode,
                            border: const OutlineInputBorder(),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: GestureDetector(
                          onTap: () => scanBarcodeNormal(),
                          child: Container(
                            height: 60.0,
                            width: 100.0,
                            padding: const EdgeInsets.all(5.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8.0),
                              border: Border.all(color: Constants.kMainColor),
                            ),
                            child: const Image(
                              image: AssetImage('images/barcode.png'),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                productList.when(data: (products) {
                  return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: products.length,
                      itemBuilder: (_, i) {
                        if (widget.customerModel!.type.contains('Retailer')) {
                          productPrice = products[i].productSalePrice;
                        } else if (widget.customerModel!.type
                            .contains('Dealer')) {
                          productPrice = products[i].productDealerPrice;
                        } else if (widget.customerModel!.type
                            .contains('Wholesaler')) {
                          productPrice = products[i].productWholeSalePrice;
                        } else if (widget.customerModel!.type
                            .contains('Supplier')) {
                          productPrice = products[i].productPurchasePrice;
                        }
                        return GestureDetector(
                          onTap: () {
                            showDialog(
                                context: context,
                                builder: (_) {
                                  ProductModel tempProductModel = products[i];
                                  return AlertDialog(
                                      content: SizedBox(
                                    child: SingleChildScrollView(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                lang.S.of(context).addItems,
                                                style: const TextStyle(
                                                    fontSize: 16),
                                              ),
                                              IconButton(
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                  icon:
                                                      const Icon(Icons.cancel))
                                            ],
                                          ),
                                          Container(
                                            height: 1,
                                            width: double.infinity,
                                            color: Constants().kBgColor,
                                          ),
                                          const SizedBox(height: 10),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Column(
                                                mainAxisSize: MainAxisSize.min,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    products[i].productName,
                                                    style: const TextStyle(
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  Text(
                                                    products[i].brandName,
                                                    style: const TextStyle(
                                                      fontSize: 10,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.grey,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Column(
                                                mainAxisSize: MainAxisSize.min,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.end,
                                                children: [
                                                  Text(
                                                    lang.S.of(context).stock,
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color:
                                                          Constants.kMainColor,
                                                    ),
                                                  ),
                                                  Text(
                                                    products[i].productStock,
                                                    style: const TextStyle(
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.grey,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 20),
                                          Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Expanded(
                                                child: AppTextField(
                                                  textFieldType:
                                                      TextFieldType.PHONE,
                                                  onChanged: (value) {
                                                    tempProductModel
                                                        .productStock = value;
                                                  },
                                                  decoration: InputDecoration(
                                                    focusedBorder:
                                                        OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color: Constants
                                                              .kMainColor), // Change the border color when focused
                                                    ),
                                                    enabledBorder:
                                                        OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color: Constants()
                                                              .kBgColor), // Change the border color when not focused
                                                    ),
                                                    floatingLabelBehavior:
                                                        FloatingLabelBehavior
                                                            .always,
                                                    labelText: lang.S
                                                        .of(context)
                                                        .quantity,
                                                    hintText: '02',
                                                    border:
                                                        const OutlineInputBorder(),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 20),
                                          Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Expanded(
                                                child: AppTextField(
                                                  initialValue: products[i]
                                                      .productPurchasePrice,
                                                  keyboardType:
                                                      TextInputType.number,
                                                  textFieldType:
                                                      TextFieldType.NAME,
                                                  onChanged: (value) {
                                                    tempProductModel
                                                            .productPurchasePrice =
                                                        value;
                                                  },
                                                  decoration: InputDecoration(
                                                    focusedBorder:
                                                        OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color: Constants
                                                              .kMainColor), // Change the border color when focused
                                                    ),
                                                    enabledBorder:
                                                        OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color: Constants()
                                                              .kBgColor), // Change the border color when not focused
                                                    ),
                                                    floatingLabelBehavior:
                                                        FloatingLabelBehavior
                                                            .always,
                                                    labelText: lang.S
                                                        .of(context)
                                                        .purchasePrice,
                                                    border:
                                                        const OutlineInputBorder(),
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(width: 10),
                                              Expanded(
                                                child: AppTextField(
                                                  initialValue: products[i]
                                                      .productSalePrice,
                                                  keyboardType:
                                                      TextInputType.number,
                                                  textFieldType:
                                                      TextFieldType.NAME,
                                                  onChanged: (value) {
                                                    tempProductModel
                                                            .productSalePrice =
                                                        value;
                                                  },
                                                  decoration: InputDecoration(
                                                    focusedBorder:
                                                        OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color: Constants
                                                              .kMainColor), // Change the border color when focused
                                                    ),
                                                    enabledBorder:
                                                        OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color: Constants()
                                                              .kBgColor), // Change the border color when not focused
                                                    ),
                                                    floatingLabelBehavior:
                                                        FloatingLabelBehavior
                                                            .always,
                                                    labelText: lang.S
                                                        .of(context)
                                                        .salePrice,
                                                    border:
                                                        const OutlineInputBorder(),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 20),
                                          Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Expanded(
                                                child: AppTextField(
                                                  initialValue: products[i]
                                                      .productWholeSalePrice,
                                                  keyboardType:
                                                      TextInputType.number,
                                                  textFieldType:
                                                      TextFieldType.NAME,
                                                  onChanged: (value) {
                                                    tempProductModel
                                                            .productWholeSalePrice =
                                                        value;
                                                  },
                                                  decoration: InputDecoration(
                                                    focusedBorder:
                                                        OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color: Constants
                                                              .kMainColor), // Change the border color when focused
                                                    ),
                                                    enabledBorder:
                                                        OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color: Constants()
                                                              .kBgColor), // Change the border color when not focused
                                                    ),
                                                    floatingLabelBehavior:
                                                        FloatingLabelBehavior
                                                            .always,
                                                    labelText: lang.S
                                                        .of(context)
                                                        .wholeSalePrice,
                                                    border:
                                                        const OutlineInputBorder(),
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(width: 10),
                                              Expanded(
                                                child: AppTextField(
                                                  initialValue: products[i]
                                                      .productDealerPrice,
                                                  keyboardType:
                                                      TextInputType.number,
                                                  textFieldType:
                                                      TextFieldType.NAME,
                                                  onChanged: (value) {
                                                    tempProductModel
                                                            .productDealerPrice =
                                                        value;
                                                  },
                                                  decoration: InputDecoration(
                                                    focusedBorder:
                                                        OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color: Constants
                                                              .kMainColor), // Change the border color when focused
                                                    ),
                                                    enabledBorder:
                                                        OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color: Constants()
                                                              .kBgColor), // Change the border color when not focused
                                                    ),
                                                    floatingLabelBehavior:
                                                        FloatingLabelBehavior
                                                            .always,
                                                    labelText: lang.S
                                                        .of(context)
                                                        .dealerPrice,
                                                    border:
                                                        const OutlineInputBorder(),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 20),
                                          GestureDetector(
                                            onTap: () {
                                              providerData.addToCartRiverPod(
                                                  tempProductModel);
                                              providerData.addProductsInSales(
                                                  products[i]);
                                              ref.refresh(productProvider);
                                              int count = 0;
                                              Navigator.popUntil(context,
                                                  (route) {
                                                return count++ == 2;
                                              });
                                            },
                                            child: Container(
                                              height: 60,
                                              width: context.width(),
                                              decoration: BoxDecoration(
                                                  color: Constants.kMainColor,
                                                  borderRadius:
                                                      const BorderRadius.all(
                                                          Radius.circular(15))),
                                              child: Center(
                                                child: Text(
                                                  lang.S.of(context).save,
                                                  style: const TextStyle(
                                                      fontSize: 18,
                                                      color: Colors.white),
                                                ),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ));
                                });
                            // if (products[i].productStock.toInt() <= 0) {
                            //   EasyLoading.showError('Out of stock');
                            // } else {
                            //   if (widget.customerModel!.type.contains('Retailer')) {
                            //     sentProductPrice = products[i].productSalePrice;
                            //   } else if (widget.customerModel!.type.contains('Dealer')) {
                            //     sentProductPrice = products[i].productDealerPrice;
                            //   } else if (widget.customerModel!.type.contains('Wholesaler')) {
                            //     sentProductPrice = products[i].productWholeSalePrice;
                            //   } else if (widget.customerModel!.type.contains('Supplier')) {
                            //     sentProductPrice = products[i].productPurchasePrice;
                            //   }
                            //
                            //   AddToCartModel cartItem = AddToCartModel(
                            //     productName: products[i].productName,
                            //     subTotal: sentProductPrice,
                            //     productId: products[i].productCode,
                            //     productBrandName: products[i].brandName,
                            //     stock: int.parse(products[i].productStock),
                            //   );
                            //   providerData.addToCartRiverPod(cartItem);
                            //
                            //   EasyLoading.showSuccess('Added To Cart');
                            //   Navigator.pop(context);
                            // }
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Constants().kBgColor),
                              child: ProductCard(
                                productTitle: products[i].productName,
                                productDescription: products[i].brandName,
                                stock: products[i].productStock,
                                ////
                                ///
                                productPrice: productPrice,
                                purchasePrice: products[i].productPurchasePrice,
                                productCode: products[i].productCode,
                                productImage: products[i].productPicture,
                                capacity: products[i].capacity,
                                color: products[i].color,
                                type: products[i].type,
                                size: products[i].size,
                                weight: products[i].weight,
                              ).visible(
                                  (products[i].productCode == productCode ||
                                          productCode == '0000' ||
                                          productCode == '-1') &&
                                      productPrice != '0'),
                            ),
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
          ),
        ),
      );
    });
  }
}
