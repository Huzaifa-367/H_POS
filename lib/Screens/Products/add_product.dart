// ignore_for_file: unused_result, use_build_context_synchronously

import 'dart:io';

import 'package:firebase_core/firebase_core.dart' as firebase_core;
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:mobile_pos/GlobalComponents/Button_Widget.dart';
import 'package:mobile_pos/GlobalComponents/DropDown/custom_dropdown.dart';
import 'package:mobile_pos/GlobalComponents/add_category.dart';
import 'package:mobile_pos/GlobalComponents/core_widgets.dart';
import 'package:mobile_pos/GlobalComponents/text_widget.dart';
import 'package:mobile_pos/Provider/category_brans_units_provide.dart';
import 'package:mobile_pos/Screens/Products/Model/unit_model.dart';
import 'package:mobile_pos/Utils/validation_rules.dart';
import 'package:mobile_pos/model/product_model.dart';
import 'package:mobile_pos/repository/subscription_repo.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:mobile_pos/generated/l10n.dart' as lang;
import '../../GlobalComponents/Model/category_model.dart';
import '../../Provider/product_provider.dart';
import '../../constant.dart';
import '../../currency.dart';
import '../Home/Dashboard.dart';
import 'Model/brands_model.dart';

// ignore: must_be_immutable
class AddProduct extends StatefulWidget {
  AddProduct({super.key, this.catName, this.unitsName, this.brandName});

  String? catName;

  String? unitsName;
  String? brandName;

  @override
  // ignore: library_private_types_in_public_api
  _AddProductState createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  GetCategoryAndVariationModel data =
      GetCategoryAndVariationModel(variations: [], categoryName: '');
  String productCategory = 'Select Product Category';
  String brandName = 'Select Brand';
  String productUnit = 'Select Unit';
  late String productName,
      productStock,
      productSalePrice,
      productPurchasePrice,
      productCode;
  String productWholeSalePrice = '0';
  String productDealerPrice = '0';
  String productPicture =
      'https://firebasestorage.googleapis.com/v0/b/maanpos.appspot.com/o/Customer%20Picture%2FNo_Image_Available.jpeg?alt=media&token=3de0d45e-0e4a-4a7b-b115-9d6722d5031f';
  String productDiscount = 'Not Provided';
  String productManufacturer = 'Not Provided';
  String size = 'Not Provided';
  String color = 'Not Provided';
  String weight = 'Not Provided';
  String capacity = 'Not Provided';
  String type = 'Not Provided';
  List<String> catItems = [];
  bool showProgress = false;
  double progress = 0.0;
  final ImagePicker _picker = ImagePicker();
  XFile? pickedImage;
  List<String> codeList = [];
  List<String> productNameList = [];
  String promoCodeHint = 'Enter Product Code';
  TextEditingController productCodeController = TextEditingController();

  int loop = 0;
  File imageFile = File('No File');
  String imagePath = 'No Data';

  /// Popup values
  String unitsName = '';
  CategoryModel? selectedCategory;

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
        productPicture = url.toString();
      });
    } on firebase_core.FirebaseException catch (e) {
      EasyLoading.dismiss();
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.code.toString())));
    }
  }

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
    return '';
  }

  @override
  void initState() {
    widget.catName == null
        ? productCategory = 'Select Product Category'
        : productCategory = widget.catName ?? "";
    widget.unitsName == null
        ? productUnit = 'Select Units'
        : productUnit = widget.unitsName ?? "";
    widget.brandName == null
        ? brandName = 'Select Brands'
        : brandName = widget.brandName ?? "";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    loop++;
    return Scaffold(
      backgroundColor: AppColors.shadeColor2,
      appBar: AppBar(
        backgroundColor: AppColors.bgColor,
        iconTheme: const IconThemeData(color: Colors.black),
        title: Text(
          lang.S.of(context).addNewProduct,
          style: GoogleFonts.poppins(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Consumer(builder: (context, ref, __) {
        final categoryData = ref.watch(categoryProvider);
        final brandData = ref.watch(brandsProvider);
        final unitData = ref.watch(unitsProvider);
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(left: 10.0, right: 10.0),
            child: Column(
              spacing: 10,
              children: [
                FirebaseAnimatedList(
                  shrinkWrap: true,
                  query: FirebaseDatabase.instance
                      .ref()
                      .child(constUserId)
                      .child('Products'),
                  itemBuilder: (context, snapshot, animation, index) {
                    final json = snapshot.value as Map<dynamic, dynamic>;
                    final product = ProductModel.fromJson(json);
                    codeList.add(product.productCode.toLowerCase());
                    productNameList.add(product.productName.toLowerCase());
                    return Container();
                  },
                ).visible(loop <= 1),
                const SizedBox(
                  height: 10.0,
                ).visible(showProgress),
                Visibility(
                  visible: showProgress,
                  child: CircularProgressIndicator(
                    color: Constants.kMainColor,
                    strokeWidth: 5.0,
                  ),
                ),
                CustomTextFormField(
                  hintText: lang.S.of(context).productName,
                  validator: (p0) => ValidationRules().normal(p0),
                  onChanged: (p0) {
                    setState(() {
                      productName = p0;
                    });
                  },
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomDropdown.search(
                      hintText: productCategory,
                      onChanged: (item) async {
                        List<String> variations = [];

                        setState(() {
                          productCategory = item!.categoryName;
                          if (item.capacity) variations.add("Capacity");
                          if (item.color) variations.add("Color");
                          if (item.size) variations.add("Size");
                          if (item.type) variations.add("Type");
                          if (item.weight) variations.add("Weight");

                          data = GetCategoryAndVariationModel(
                            variations: variations,
                            categoryName: item.categoryName,
                          );
                        });
                      },
                      enabled: true,
                      headerBuilder: (context, selectedItem, enabled) {
                        return Text(selectedItem.categoryName);
                      },
                      listItemBuilder:
                          (context, item, isSelected, onItemSelect) {
                        return Text(item.categoryName);
                      },
                      items: categoryData.value,
                    ).withWidth(context.width() * 0.7),
                    ButtonWidget(
                      btnText: "ADD",
                      onPress: () => const AddCategory().launch(context),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomTextFormField(
                      hintText: lang.S.of(context).size,
                      labelText: "L,M,S",
                      validator: (p0) => ValidationRules().normal(p0),
                      onChanged: (p0) {
                        setState(() {
                          size = p0;
                        });
                      },
                    )
                        .withWidth(context.width() * 0.45)
                        .visible(data.variations.contains('Size')),
                    CustomTextFormField(
                      hintText: lang.S.of(context).color,
                      labelText: 'Green',
                      validator: (p0) => ValidationRules().normal(p0),
                      onChanged: (p0) {
                        setState(() {
                          color = p0;
                        });
                      },
                    )
                        .withWidth(context.width() * 0.45)
                        .visible(data.variations.contains('Color')),
                  ],
                ).visible(data.variations.contains('Size') ||
                    data.variations.contains('Color')),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomTextFormField(
                      hintText: lang.S.of(context).weight,
                      labelText: '10 g',
                      validator: (p0) => ValidationRules().normal(p0),
                      onChanged: (p0) {
                        setState(() {
                          weight = p0;
                        });
                      },
                    )
                        .withWidth(context.width() * 0.45)
                        .visible(data.variations.contains('Weight')),
                    CustomTextFormField(
                      hintText: lang.S.of(context).capacity,
                      labelText: '8 GB',
                      validator: (p0) => ValidationRules().normal(p0),
                      onChanged: (p0) {
                        setState(() {
                          capacity = p0;
                        });
                      },
                    )
                        .withWidth(context.width() * 0.45)
                        .visible(data.variations.contains('Capacity')),
                  ],
                ).visible(data.variations.contains('Capacity') ||
                    data.variations.contains('Weight')),
                CustomTextFormField(
                  hintText: lang.S.of(context).type,
                  labelText: 'Vip',
                  validator: (p0) => ValidationRules().normal(p0),
                  onChanged: (p0) {
                    setState(() {
                      type = p0;
                    });
                  },
                ).visible(data.variations.contains('Type')),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomDropdown.search(
                      hintText: brandName,
                      onChanged: (item) async {
                        setState(() {
                          brandName = item!.brandName;
                        });
                      },
                      enabled: true,
                      headerBuilder: (context, selectedItem, enabled) {
                        return Text(selectedItem.brandName);
                      },
                      listItemBuilder:
                          (context, item, isSelected, onItemSelect) {
                        return Text(item.brandName);
                      },
                      items: brandData.value,
                    ).withWidth(context.width() * 0.7),
                    ButtonWidget(
                      btnText: "ADD",
                      onPress: () => showDialog(
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
                                margin: EdgeInsets.all(15),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  spacing: 15,
                                  children: [
                                    TextWidget(
                                      title: lang.S.of(context).addBrand,
                                      txtSize: 16.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    CustomTextFormField(
                                      hintText: lang.S.of(context).brandName,
                                      validator: (p0) =>
                                          ValidationRules().normal(p0),
                                      onChanged: (p0) {
                                        setState(() {
                                          brandName = p0;
                                        });
                                      },
                                    ),
                                    ButtonWidget(
                                      btnText: lang.S.of(context).save,
                                      onPress: () async {
                                        bool isAlreadyAdded = false;
                                        brandData.value?.forEach((element) {
                                          if (element.brandName
                                                  .toLowerCase()
                                                  .removeAllWhiteSpace() ==
                                              brandName
                                                  .toLowerCase()
                                                  .removeAllWhiteSpace()) {
                                            isAlreadyAdded = true;
                                          }
                                        });
                                        setState(() {
                                          showProgress = true;
                                        });
                                        final DatabaseReference
                                            categoryInformationRef =
                                            FirebaseDatabase.instance
                                                .ref()
                                                .child(constUserId)
                                                .child('Brands');
                                        categoryInformationRef.keepSynced(true);
                                        BrandsModel brandModel =
                                            BrandsModel(brandName);
                                        isAlreadyAdded
                                            ? EasyLoading.showError(
                                                'Already Added')
                                            : categoryInformationRef
                                                .push()
                                                .set(brandModel.toJson());
                                        setState(() {
                                          showProgress = false;
                                          isAlreadyAdded
                                              ? null
                                              : ScaffoldMessenger.of(context)
                                                  .showSnackBar(const SnackBar(
                                                      content: Text(
                                                          "Data Saved Successfully")));
                                        });
                                        ref.refresh(brandsProvider);

                                        isAlreadyAdded
                                            ? null
                                            : Navigator.pop(context);
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }),
                    ),
                  ],
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
                          productCode = value;
                          promoCodeHint = value;
                        });
                      },
                      onFieldSubmitted: (value) {
                        if (codeList.contains(value)) {
                          EasyLoading.showError('This Product Already added!');
                          productCodeController.clear();
                        } else {
                          setState(() {
                            productCode = value;
                            promoCodeHint = value;
                          });
                        }
                      },
                    ).withWidth(context.width() * 0.65),
                    ButtonWidget(
                      btnText: "SCAN",
                      onPress: () async {
                        String value = await scanBarcodeNormal();
                        productCode = value;
                        promoCodeHint = value;
                        productCodeController.text = value;
                        setState(() {});
                        print("Product Code===>>> $productCode");
                      },
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomTextFormField(
                      hintText: lang.S.of(context).stock,
                      validator: (p0) => ValidationRules().normal(p0),
                      onChanged: (p0) {
                        setState(() {
                          productStock = p0;
                        });
                      },
                    ).withWidth(context.width() * 0.25),
                    CustomDropdown.search(
                      hintText: productUnit,
                      onChanged: (item) async {
                        setState(() {
                          productUnit = item!.unitName;
                        });
                      },
                      enabled: true,
                      headerBuilder: (context, selectedItem, enabled) {
                        return Text(selectedItem.unitName);
                      },
                      listItemBuilder:
                          (context, item, isSelected, onItemSelect) {
                        return Text(item.unitName);
                      },
                      items: unitData.value,
                    ).withWidth(context.width() * 0.45),
                    ButtonWidget(
                      btnText: "ADD",
                      onPress: () => showDialog(
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
                                margin: EdgeInsets.all(15),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  spacing: 15,
                                  children: [
                                    TextWidget(
                                      title: lang.S.of(context).addUnit,
                                      txtSize: 16.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    CustomTextFormField(
                                      hintText: lang.S.of(context).unitName,
                                      validator: (p0) =>
                                          ValidationRules().normal(p0),
                                      onChanged: (p0) {
                                        setState(() {
                                          unitsName = p0;
                                        });
                                      },
                                    ),
                                    ButtonWidget(
                                      btnText: lang.S.of(context).save,
                                      onPress: () async {
                                        bool isAlreadyAdded = false;
                                        unitData.value?.forEach((element) {
                                          if (element.unitName
                                                  .toLowerCase()
                                                  .removeAllWhiteSpace() ==
                                              unitsName
                                                  .toLowerCase()
                                                  .removeAllWhiteSpace()) {
                                            isAlreadyAdded = true;
                                          }
                                        });
                                        setState(() {
                                          showProgress = true;
                                        });
                                        final DatabaseReference
                                            unitInformationRef =
                                            FirebaseDatabase.instance
                                                .ref()
                                                .child(constUserId)
                                                .child('Units');
                                        unitInformationRef.keepSynced(true);
                                        UnitModel unitModel =
                                            UnitModel(unitsName);
                                        isAlreadyAdded
                                            ? EasyLoading.showError(
                                                'Already Added')
                                            : unitInformationRef
                                                .push()
                                                .set(unitModel.toJson());
                                        setState(() {
                                          showProgress = false;
                                          isAlreadyAdded
                                              ? null
                                              : ScaffoldMessenger.of(context)
                                                  .showSnackBar(const SnackBar(
                                                      content: Text(
                                                          "Data Saved Successfully")));
                                        });

                                        ref.refresh(unitsProvider);

                                        // ignore: use_build_context_synchronously
                                        isAlreadyAdded
                                            ? null
                                            : Navigator.pop(context);
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomTextFormField(
                      hintText: lang.S.of(context).purchasePrice,
                      validator: (p0) => ValidationRules().normal(p0),
                      onChanged: (p0) {
                        setState(() {
                          productPurchasePrice = p0;
                        });
                      },
                    ).withWidth(context.width() * 0.45),
                    CustomTextFormField(
                      hintText: lang.S.of(context).salePrice,
                      validator: (p0) => ValidationRules().normal(p0),
                      onChanged: (p0) {
                        setState(() {
                          productSalePrice = p0;
                        });
                      },
                    ).withWidth(context.width() * 0.45),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomTextFormField(
                      hintText: lang.S.of(context).wholeSalePrice,
                      validator: (p0) => ValidationRules().normal(p0),
                      onChanged: (p0) {
                        setState(() {
                          productWholeSalePrice = p0;
                        });
                      },
                    ).withWidth(context.width() * 0.45),
                    CustomTextFormField(
                      hintText: lang.S.of(context).dealerPrice,
                      validator: (p0) => ValidationRules().normal(p0),
                      onChanged: (p0) {
                        setState(() {
                          productDealerPrice = p0;
                        });
                      },
                    ).withWidth(context.width() * 0.45),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomTextFormField(
                      hintText: lang.S.of(context).discount,
                      validator: (p0) => ValidationRules().normal(p0),
                      onChanged: (p0) {
                        setState(() {
                          productDiscount = p0;
                        });
                      },
                    ).withWidth(context.width() * 0.45),
                    CustomTextFormField(
                      hintText: lang.S.of(context).manufacturer,
                      validator: (p0) => ValidationRules().normal(p0),
                      onChanged: (p0) {
                        setState(() {
                          productManufacturer = p0;
                        });
                      },
                    ).withWidth(context.width() * 0.45),
                  ],
                ),
                Column(
                  children: [
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        GestureDetector(
                                          onTap: () async {
                                            pickedImage =
                                                await _picker.pickImage(
                                                    imageQuality: 20,
                                                    source:
                                                        ImageSource.gallery);

                                            setState(() {
                                              imageFile =
                                                  File(pickedImage!.path);
                                              imagePath = pickedImage!.path;
                                            });

                                            Future.delayed(
                                                const Duration(
                                                    milliseconds: 100), () {
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
                                                lang.S.of(context).gallery,
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
                                            pickedImage =
                                                await _picker.pickImage(
                                                    imageQuality: 20,
                                                    source: ImageSource.camera);
                                            setState(() {
                                              imageFile =
                                                  File(pickedImage!.path);
                                              imagePath = pickedImage!.path;
                                            });
                                            Future.delayed(
                                                const Duration(
                                                    milliseconds: 100), () {
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
                              border: Border.all(
                                  color: Constants.kMainColor, width: 1),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(120)),
                              image: imagePath == 'No Data'
                                  ? DecorationImage(
                                      image: NetworkImage(productPicture),
                                      fit: BoxFit.cover,
                                    )
                                  : DecorationImage(
                                      image: FileImage(imageFile),
                                      fit: BoxFit.cover,
                                    ),
                            ),
                          ),
                          Container(
                            height: 120,
                            width: 120,
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: Constants.kMainColor, width: 1),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(120)),
                              image: DecorationImage(
                                image: FileImage(imageFile),
                                fit: BoxFit.cover,
                              ),
                            ),
                            // child: imageFile.path == 'No File' ? null : Image.file(imageFile),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              height: 35,
                              width: 35,
                              decoration: BoxDecoration(
                                border:
                                    Border.all(color: Colors.white, width: 2),
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(120)),
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
                    const SizedBox(height: 10),
                  ],
                ),
                ButtonWidget(
                  btnText: lang.S.of(context).saveNPublish,
                  onPress: () async {
                    if (!codeList.contains(productCode.toLowerCase()) &&
                        !productNameList.contains(productName.toLowerCase())) {
                      bool result =
                          await InternetConnectionChecker().hasConnection;
                      if (result) {
                        bool status = await PurchaseModel().isActiveBuyer();
                        if (status) {
                          try {
                            EasyLoading.show(
                                status: 'Loading...', dismissOnTap: false);

                            imagePath == 'No Data'
                                ? null
                                : await uploadFile(imagePath);
                            // ignore: no_leading_underscores_for_local_identifiers
                            final DatabaseReference _productInformationRef =
                                FirebaseDatabase.instance
                                    .ref()
                                    .child(constUserId)
                                    .child('Products');
                            _productInformationRef.keepSynced(true);
                            ProductModel productModel = ProductModel(
                              productName,
                              productCategory,
                              size,
                              color,
                              weight,
                              capacity,
                              type,
                              brandName,
                              productCode,
                              productStock,
                              productUnit,
                              productSalePrice,
                              productPurchasePrice,
                              productDiscount,
                              productWholeSalePrice,
                              productDealerPrice,
                              productManufacturer,
                              productPicture,
                            );
                            _productInformationRef
                                .push()
                                .set(productModel.toJson());
                            decreaseSubscriptionSale();
                            EasyLoading.showSuccess('Added Successfully',
                                duration: const Duration(milliseconds: 500));
                            _productInformationRef.onChildAdded.listen((event) {
                              ref.refresh(productProvider);
                            });
                            Future.delayed(const Duration(milliseconds: 100),
                                () {
                              const Dashboard()
                                  .launch(context, isNewTask: true);
                            });
                          } catch (e) {
                            EasyLoading.dismiss();
                            ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(e.toString())));
                          }
                        } else {
                          showLicensePage(context: context);
                        }
                      } else {
                        try {
                          EasyLoading.show(
                              status: 'Loading...', dismissOnTap: false);
                          imagePath == 'No Data'
                              ? null
                              : await uploadFile(imagePath);
                          // ignore: no_leading_underscores_for_local_identifiers
                          final DatabaseReference _productInformationRef =
                              FirebaseDatabase.instance
                                  .ref()
                                  .child(constUserId)
                                  .child('Products');
                          _productInformationRef.keepSynced(true);
                          ProductModel productModel = ProductModel(
                            productName,
                            productCategory,
                            size,
                            color,
                            weight,
                            capacity,
                            type,
                            brandName,
                            productCode,
                            productStock,
                            productUnit,
                            productSalePrice,
                            productPurchasePrice,
                            productDiscount,
                            productWholeSalePrice,
                            productDealerPrice,
                            productManufacturer,
                            productPicture,
                          );
                          _productInformationRef
                              .push()
                              .set(productModel.toJson());
                          decreaseSubscriptionSale();
                          EasyLoading.showSuccess('Added Successfully',
                              duration: const Duration(milliseconds: 500));
                          _productInformationRef.onChildAdded.listen((event) {
                            ref.refresh(productProvider);
                          });
                          Future.delayed(const Duration(milliseconds: 100), () {
                            const Dashboard().launch(context, isNewTask: true);
                          });
                        } catch (e) {
                          EasyLoading.dismiss();
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(e.toString())));
                        }
                      }
                    } else {
                      EasyLoading.showError(
                          'Product Code or Name are already added!');
                    }
                  },
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  void decreaseSubscriptionSale() async {
    final ref =
        FirebaseDatabase.instance.ref('$constUserId/Subscription/products');
    ref.keepSynced(true);
    var data = await ref.once();
    int beforeSale = int.parse(data.snapshot.value.toString());
    int afterSale = beforeSale - 1;
    beforeSale != -202
        ? FirebaseDatabase.instance
            .ref('$constUserId/Subscription')
            .update({'products': afterSale})
        : null;
  }
}
