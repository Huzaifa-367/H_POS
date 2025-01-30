// ignore_for_file: unused_result

import 'dart:convert';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart' as firebase_core;
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile_pos/GlobalComponents/Button_Widget.dart';
import 'package:mobile_pos/GlobalComponents/button_global.dart';
import 'package:mobile_pos/GlobalComponents/core_widgets.dart';
import 'package:mobile_pos/Provider/product_provider.dart';
import 'package:mobile_pos/Utils/validation_rules.dart';
import 'package:mobile_pos/model/product_model.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../GlobalComponents/Model/category_model.dart';
import '../../constant.dart';
import '../../currency.dart';
import '../Home/home_screen.dart';
import 'package:mobile_pos/generated/l10n.dart' as lang;

// ignore: must_be_immutable
class UpdateProduct extends StatefulWidget {
  UpdateProduct({super.key, this.productModel});

  ProductModel? productModel;

  @override
  // ignore: library_private_types_in_public_api
  _UpdateProductState createState() => _UpdateProductState();
}

class _UpdateProductState extends State<UpdateProduct> {
  late String productKey;
  late ProductModel updatedProductModel;
  GetCategoryAndVariationModel data =
      GetCategoryAndVariationModel(variations: [], categoryName: '');
  bool showProgress = false;
  final ImagePicker _picker = ImagePicker();
  XFile? pickedImage;
  File imageFile = File('No File');
  String imagePath = 'No Data';
  // late String productCode;
  List<String> codeList = [];

  TextEditingController productCodeController = TextEditingController();

  Future<String> scanBarcodeNormal() async {
    String barcodeScanRes;
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.BARCODE);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }
    if (!mounted) {
      return '';
    }
    if (codeList.contains(barcodeScanRes)) {
      EasyLoading.showError('This Product Already added!');
    } else {
      if (barcodeScanRes != '-1') {
        return barcodeScanRes;
        // setState(() {
        //   productCode = barcodeScanRes;
        //   promoCodeHint = barcodeScanRes;
        // });
      }
    }
    return widget.productModel!.productCode;
  }

  Future<void> uploadFile(String filePath) async {
    File file = File(filePath);
    try {
      EasyLoading.show(
        status: 'Uploading... ',
        dismissOnTap: false,
      );
      var snapshot = await FirebaseStorage.instance
          .ref('Product Picture/${DateTime.now().millisecondsSinceEpoch}')
          .putFile(file);
      var url = await snapshot.ref.getDownloadURL();
      setState(() {
        updatedProductModel.productPicture = url.toString();
      });
    } on firebase_core.FirebaseException catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.code.toString())));
    }
  }

  void getProductKey(String code) {
    // ignore: unused_local_variable
    List<ProductModel> productList = [];
    final ref = FirebaseDatabase.instance.ref(constUserId).child('Products');
    ref.keepSynced(true);
    ref.orderByKey().get().then((value) {
      for (var element in value.children) {
        var data = jsonDecode(jsonEncode(element.value));
        if (data['productCode'].toString() == code) {
          productKey = element.key.toString();
        }
      }
    });
  }

  void deleteProduct({required WidgetRef wRef}) {
    DatabaseReference ref =
        FirebaseDatabase.instance.ref("$constUserId/Products/$productKey");
    ref.keepSynced(true);

    ref.remove();
    wRef.refresh(productProvider);
  }

  @override
  void initState() {
    productCodeController.text = widget.productModel!.productCode;
    getProductKey(widget.productModel!.productCode);
    updatedProductModel = widget.productModel!;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, __) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.black),
          title: Text(
            lang.S.of(context).updateProduct,
            style: GoogleFonts.poppins(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: [
            IconButton(
              onPressed: () {
                showDialog(
                  barrierDismissible: false,
                  context: context,
                  builder: (BuildContext context1) {
                    return Padding(
                      padding: const EdgeInsets.all(30.0),
                      child: Center(
                        child: Container(
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(Radius.circular(30)),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const SizedBox(height: 20),
                                Text(
                                  lang.S.of(context).youWantTodeletetheProduct,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 22,
                                  ),
                                ),
                                const SizedBox(height: 20),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Expanded(
                                      child: ButtonGlobalWithoutIcon(
                                        buttontext: lang.S.of(context).cancel,
                                        buttonDecoration: kButtonDecoration
                                            .copyWith(color: Colors.green),
                                        onPressed: (() {
                                          Navigator.pop(context1);
                                        }),
                                        buttonTextColor: Colors.white,
                                      ),
                                    ),
                                    Expanded(
                                      child: ButtonGlobalWithoutIcon(
                                        buttontext: lang.S.of(context).delete,
                                        buttonDecoration: kButtonDecoration
                                            .copyWith(color: Colors.red),
                                        onPressed: (() {
                                          deleteProduct(wRef: ref);
                                          Future.delayed(
                                              const Duration(milliseconds: 500),
                                              () {
                                            ref.refresh(productProvider);
                                            Navigator.pop(context1);
                                            Navigator.pop(context);
                                          });
                                        }),
                                        buttonTextColor: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
              icon: const Icon(
                Icons.delete,
                color: Colors.red,
              ),
            )
          ],
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(left: 10.0, right: 10.0),
            child: Column(
              children: [
                const SizedBox(height: 10.0),
                Visibility(
                  visible: showProgress,
                  child: CircularProgressIndicator(
                    color: Constants.kMainColor,
                    strokeWidth: 5.0,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: AppTextField(
                    initialValue: widget.productModel!.productName,
                    textFieldType: TextFieldType.NAME,
                    onChanged: (value) {
                      setState(() {
                        updatedProductModel.productName = value;
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
                      labelText: lang.S.of(context).productName,
                      hintText: 'Smart Watch',
                      border: const OutlineInputBorder(),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Container(
                    height: 60.0,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5.0),
                      border: Border.all(color: Constants().kBgColor),
                    ),
                    child: Row(
                      children: [
                        const SizedBox(
                          width: 10.0,
                        ),
                        Text(widget.productModel!.productCategory),
                        const Spacer(),
                        Icon(
                          Icons.keyboard_arrow_down,
                          color: Constants.kMainColor,
                        ),
                        const SizedBox(
                          width: 10.0,
                        ),
                      ],
                    ),
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: AppTextField(
                          initialValue: widget.productModel!.size,
                          textFieldType: TextFieldType.NAME,
                          onChanged: (value) {
                            setState(() {
                              updatedProductModel.size = value;
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
                            labelText: 'Size',
                            hintText: 'M',
                            border: const OutlineInputBorder(),
                          ),
                        ),
                      ),
                    ).visible(widget.productModel!.size != 'Not Provided'),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: AppTextField(
                          initialValue: widget.productModel!.color,
                          textFieldType: TextFieldType.NAME,
                          onChanged: (value) {
                            setState(() {
                              updatedProductModel.color = value;
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
                            labelText: lang.S.of(context).color,
                            hintText: 'Green',
                            border: const OutlineInputBorder(),
                          ),
                        ),
                      ),
                    ).visible(widget.productModel!.color != 'Not Provided'),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: AppTextField(
                          initialValue: widget.productModel!.weight,
                          textFieldType: TextFieldType.NAME,
                          onChanged: (value) {
                            setState(() {
                              updatedProductModel.weight = value;
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
                            labelText: lang.S.of(context).weight,
                            hintText: '10 inc',
                            border: const OutlineInputBorder(),
                          ),
                        ),
                      ),
                    ).visible(widget.productModel!.weight != 'Not Provided'),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: AppTextField(
                          initialValue: widget.productModel!.capacity,
                          textFieldType: TextFieldType.NAME,
                          onChanged: (value) {
                            setState(() {
                              updatedProductModel.capacity = value;
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
                            labelText: lang.S.of(context).capacity,
                            hintText: '244 liter',
                            border: const OutlineInputBorder(),
                          ),
                        ),
                      ),
                    ).visible(widget.productModel!.capacity != 'Not Provided'),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: AppTextField(
                    initialValue: widget.productModel!.type,
                    textFieldType: TextFieldType.NAME,
                    onChanged: (value) {
                      setState(() {
                        updatedProductModel.type = value;
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
                      labelText: lang.S.of(context).type,
                      hintText: 'Usb C',
                      border: const OutlineInputBorder(),
                    ),
                  ),
                ).visible(widget.productModel!.type != 'Not Provided'),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Container(
                    height: 60.0,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5.0),
                      border: Border.all(color: Constants().kBgColor),
                    ),
                    child: Row(
                      children: [
                        const SizedBox(
                          width: 10.0,
                        ),
                        Text(widget.productModel!.brandName),
                        const Spacer(),
                        Icon(
                          Icons.keyboard_arrow_down,
                          color: Constants.kMainColor,
                        ),
                        const SizedBox(
                          width: 10.0,
                        ),
                      ],
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomTextFormField(
                      hintText: lang.S.of(context).productCode,
                      controller: productCodeController,
                      validator: (p0) => ValidationRules().normal(p0),
                      onChanged: (value) {
                        setState(() {
                          updatedProductModel.productCode = value;
                        });
                      },
                      onFieldSubmitted: (value) {
                        if (codeList.contains(value)) {
                          EasyLoading.showError('This Product Already added!');
                          productCodeController.clear();
                        } else {
                          setState(() {
                            updatedProductModel.productCode = value;
                          });
                        }
                      },
                    ).withWidth(context.width() * 0.65),
                    ButtonWidget(
                      btnText: "SCAN",
                      onPress: () async {
                        String value = await scanBarcodeNormal();
                        updatedProductModel.productCode = value;
                        productCodeController.text = value;
                        setState(() {});
                        // print("Product Code===>>> $productCode");
                      },
                    ),
                  ],
                ),
                // Row(
                //   children: [
                //     Expanded(
                //       flex: 3,
                //       child: Padding(
                //         padding: const EdgeInsets.all(10.0),
                //         child: AppTextField(
                //           readOnly: true,
                //           textFieldType: TextFieldType.NAME,
                //           decoration: InputDecoration(
                //             focusedBorder: OutlineInputBorder(
                //               borderSide: BorderSide(
                //                   color: Constants
                //                       .kMainColor), // Change the border color when focused
                //             ),
                //             enabledBorder: OutlineInputBorder(
                //               borderSide: BorderSide(
                //                   color: Constants()
                //                       .kBgColor), // Change the border color when not focused
                //             ),
                //             floatingLabelBehavior: FloatingLabelBehavior.always,
                //             labelText: lang.S.of(context).productCode,
                //             hintText: widget.productModel!.productCode,
                //             border: const OutlineInputBorder(),
                //           ),
                //         ),
                //       ),
                //     ),
                //     Expanded(
                //       flex: 1,
                //       child: Padding(
                //         padding: const EdgeInsets.all(10.0),
                //         child: Container(
                //           height: 60.0,
                //           width: 100.0,
                //           padding: const EdgeInsets.all(5.0),
                //           decoration: BoxDecoration(
                //             borderRadius: BorderRadius.circular(8.0),
                //             border: Border.all(color: Constants.kMainColor),
                //           ),
                //           child: const Image(
                //             image: AssetImage('images/barcode.png'),
                //           ),
                //         ),
                //       ),
                //     ),
                //   ],
                // ),

                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: AppTextField(
                          initialValue: widget.productModel!.productStock,
                          onChanged: (value) {
                            setState(() {
                              updatedProductModel.productStock = value;
                            });
                          },
                          textFieldType: TextFieldType.PHONE,
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
                            labelText: lang.S.of(context).stock,
                            hintText: '20',
                            border: const OutlineInputBorder(),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Container(
                          height: 60.0,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5.0),
                            border: Border.all(color: Constants().kBgColor),
                          ),
                          child: Row(
                            children: [
                              const SizedBox(
                                width: 10.0,
                              ),
                              Text(widget.productModel!.productUnit),
                              const Spacer(),
                              Icon(
                                Icons.keyboard_arrow_down,
                                color: Constants.kMainColor,
                              ),
                              const SizedBox(
                                width: 10.0,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: AppTextField(
                          initialValue:
                              widget.productModel!.productPurchasePrice,
                          textFieldType: TextFieldType.PHONE,
                          onChanged: (value) {
                            setState(() {
                              updatedProductModel.productPurchasePrice = value;
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
                            labelText: lang.S.of(context).purchasePrice,
                            hintText: '$currency 300.90',
                            border: const OutlineInputBorder(),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: AppTextField(
                          initialValue: widget.productModel!.productSalePrice,
                          textFieldType: TextFieldType.PHONE,
                          onChanged: (value) {
                            setState(() {
                              updatedProductModel.productSalePrice = value;
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
                            labelText: lang.S.of(context).salePrice,
                            hintText: '$currency 234.09',
                            border: const OutlineInputBorder(),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: AppTextField(
                          initialValue:
                              widget.productModel!.productWholeSalePrice,
                          textFieldType: TextFieldType.PHONE,
                          onChanged: (value) {
                            setState(() {
                              updatedProductModel.productWholeSalePrice = value;
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
                            labelText: lang.S.of(context).wholeSalePrice,
                            hintText: '$currency 155',
                            border: const OutlineInputBorder(),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: AppTextField(
                          initialValue: widget.productModel!.productDealerPrice,
                          textFieldType: TextFieldType.PHONE,
                          onChanged: (value) {
                            setState(() {
                              updatedProductModel.productDealerPrice = value;
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
                            labelText: lang.S.of(context).dealerPrice,
                            hintText: '$currency 130',
                            border: const OutlineInputBorder(),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                        child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: AppTextField(
                        textFieldType: TextFieldType.PHONE,
                        initialValue: widget.productModel!.productDiscount,
                        onChanged: (value) {
                          setState(() {
                            updatedProductModel.productDiscount = value;
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
                          labelText: lang.S.of(context).discount,
                          hintText: '$currency 34.90',
                          border: const OutlineInputBorder(),
                        ),
                      ),
                    )),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: AppTextField(
                          initialValue:
                              widget.productModel!.productManufacturer,
                          textFieldType: TextFieldType.NAME,
                          onChanged: (value) {
                            setState(() {
                              updatedProductModel.productManufacturer = value;
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
                            labelText: lang.S.of(context).manufacturer,
                            hintText: 'Apple',
                            border: const OutlineInputBorder(),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                GestureDetector(
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return Dialog(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            // ignore: sized_box_for_whitespace
                            child: Container(
                              height: 200.0,
                              width: MediaQuery.of(context).size.width - 80,
                              child: Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    GestureDetector(
                                      onTap: () async {
                                        pickedImage = await _picker.pickImage(
                                            imageQuality: 20,
                                            source: ImageSource.gallery);
                                        setState(() {
                                          imageFile = File(pickedImage!.path);
                                          imagePath = pickedImage!.path;
                                        });
                                        Future.delayed(
                                            const Duration(milliseconds: 100),
                                            () {
                                          Navigator.pop(context);
                                        });
                                      },
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.photo_library_rounded,
                                            size: 60.0,
                                            color: Constants.kMainColor,
                                          ),
                                          Text(
                                            'Gallery',
                                            style: GoogleFonts.poppins(
                                              fontSize: 20.0,
                                              color: Constants.kMainColor,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 40.0,
                                    ),
                                    GestureDetector(
                                      onTap: () async {
                                        pickedImage = await _picker.pickImage(
                                            imageQuality: 20,
                                            source: ImageSource.camera);
                                        setState(() {
                                          imageFile = File(pickedImage!.path);
                                          imagePath = pickedImage!.path;
                                        });
                                        Future.delayed(
                                            const Duration(milliseconds: 100),
                                            () {
                                          Navigator.pop(context);
                                        });
                                      },
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          const Icon(
                                            Icons.camera,
                                            size: 60.0,
                                            color: kGreyTextColor,
                                          ),
                                          Text(
                                            lang.S.of(context).camera,
                                            style: GoogleFonts.poppins(
                                              fontSize: 20.0,
                                              color: kGreyTextColor,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        });
                  },
                  child: Stack(
                    children: [
                      Container(
                        height: 120,
                        width: 120,
                        decoration: BoxDecoration(
                          border:
                              Border.all(color: Constants.kMainColor, width: 1),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(120)),
                          image: imagePath == 'No Data'
                              ? DecorationImage(
                                  image: NetworkImage(
                                      widget.productModel!.productPicture),
                                  fit: BoxFit.cover,
                                )
                              : DecorationImage(
                                  image: FileImage(imageFile),
                                  fit: BoxFit.cover,
                                ),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          height: 35,
                          width: 35,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.white, width: 2),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(120)),
                            color: Constants.kMainColor,
                          ),
                          child: const Icon(
                            Icons.camera_alt_outlined,
                            size: 20,
                            color: Colors.white,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                ButtonGlobalWithoutIcon(
                  buttontext: lang.S.of(context).saveNPublish,
                  buttonDecoration:
                      kButtonDecoration.copyWith(color: Constants.kMainColor),
                  onPressed: () async {
                    try {
                      imagePath == 'No Data'
                          ? null
                          : await uploadFile(imagePath);
                      EasyLoading.show(
                          status: 'Loading...', dismissOnTap: false);
                      DatabaseReference ref = FirebaseDatabase.instance
                          .ref("$constUserId/Products/$productKey");
                      ref.keepSynced(true);
                      ref.update({
                        'productName': updatedProductModel.productName,
                        'productCategory': updatedProductModel.productCategory,
                        'size': updatedProductModel.size,
                        'color': updatedProductModel.color,
                        'weight': updatedProductModel.weight,
                        'capacity': updatedProductModel.capacity,
                        'type': updatedProductModel.type,
                        'brandName': updatedProductModel.brandName,
                        'productCode': updatedProductModel.productCode,
                        'productStock': updatedProductModel.productStock,
                        'productUnit': updatedProductModel.productUnit,
                        'productSalePrice':
                            updatedProductModel.productSalePrice,
                        'productPurchasePrice':
                            updatedProductModel.productPurchasePrice,
                        'productDiscount': updatedProductModel.productDiscount,
                        'productWholeSalePrice':
                            updatedProductModel.productWholeSalePrice,
                        'productDealerPrice':
                            updatedProductModel.productDealerPrice,
                        'productManufacturer':
                            updatedProductModel.productManufacturer,
                        'productPicture': updatedProductModel.productPicture,
                      });
                      EasyLoading.showSuccess('Added Successfully',
                          duration: const Duration(milliseconds: 500));

                      //ref.refresh(productProvider);
                      Future.delayed(const Duration(milliseconds: 100), () {
                        const HomeScreen().launch(context, isNewTask: true);
                      });
                    } catch (e) {
                      EasyLoading.dismiss();
                      ScaffoldMessenger.of(context)
                          .showSnackBar(SnackBar(content: Text(e.toString())));
                    }
                  },
                  buttonTextColor: Colors.white,
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
