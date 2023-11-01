import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_pos/Provider/category,brans,units_provide.dart';
import 'package:mobile_pos/Screens/Products/Model/brands_model.dart';
import 'package:mobile_pos/Screens/Products/add_brans_UnUsed.dart';
import 'package:mobile_pos/constant.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../GlobalComponents/button_global.dart';
import 'package:mobile_pos/generated/l10n.dart' as lang;

// ignore: must_be_immutable
class BrandsList extends StatefulWidget {
  const BrandsList({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _BrandsListState createState() => _BrandsListState();
}

class _BrandsListState extends State<BrandsList> {
  bool showProgress = false;
  late String brandName;
  String search = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          lang.S.of(context).brands,
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
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Consumer(builder: (context, ref, __) {
            final brandData = ref.watch(brandsProvider);
            final allBrands = ref.watch(brandsProvider);
            return Column(
              children: [
                Text(
                  lang.S.of(context).addBrand,
                  style: GoogleFonts.poppins(
                    color: Colors.black,
                    fontSize: 16.0,
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: AppTextField(
                        textFieldType: TextFieldType.NAME,
                        onChanged: (value) {
                          setState(() {
                            brandName = value;
                          });
                        },
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          hintText: 'Realme',
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          labelText: lang.S.of(context).brandName,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: ButtonGlobalWithoutIcon(
                        buttontext: lang.S.of(context).save,
                        buttonDecoration:
                            kButtonDecoration.copyWith(color: Constants.kMainColor),
                        onPressed: () async {
                          bool isAlreadyAdded = false;
                          allBrands.value?.forEach((element) {
                            if (element.brandName
                                    .toLowerCase()
                                    .removeAllWhiteSpace() ==
                                brandName.toLowerCase().removeAllWhiteSpace()) {
                              isAlreadyAdded = true;
                            }
                          });
                          setState(() {
                            showProgress = true;
                          });
                          final DatabaseReference categoryInformationRef =
                              FirebaseDatabase.instance
                                  .ref()
                                  .child(constUserId)
                                  .child('Brands');
                          categoryInformationRef.keepSynced(true);
                          BrandsModel brandModel = BrandsModel(brandName);
                          isAlreadyAdded
                              ? EasyLoading.showError('Already Added')
                              : categoryInformationRef
                                  .push()
                                  .set(brandModel.toJson());
                          setState(() {
                            showProgress = false;
                            isAlreadyAdded
                                ? null
                                : ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content:
                                            Text("Data Saved Successfully")));
                          });
                          ref.refresh(brandsProvider);

                          // ignore: use_build_context_synchronously
                          //isAlreadyAdded ? null : Navigator.pop(context);
                        },
                        buttonTextColor: Colors.white,
                      ),
                    ),
                  ],
                ),

                // Row(
                //   children: [
                //     Expanded(
                //       flex: 3,
                //       child: AppTextField(
                //         textFieldType: TextFieldType.NAME,
                //         decoration: InputDecoration(
                //           border: const OutlineInputBorder(),
                //           hintText: lang.S.of(context).search,
                //           prefixIcon: Icon(
                //             Icons.search,
                //             color: kGreyTextColor.withOpacity(0.5),
                //           ),
                //         ),
                //         onChanged: (value) {
                //           setState(() {
                //             search = value;
                //           });
                //         },
                //       ),
                //     ),
                //     const SizedBox(
                //       width: 10.0,
                //     ),
                //     Expanded(
                //       flex: 1,
                //       child: GestureDetector(
                //         onTap: () {
                //           const AddBrands().launch(context);
                //         },
                //         child: Container(
                //           padding:
                //               const EdgeInsets.only(left: 20.0, right: 20.0),
                //           height: 60.0,
                //           decoration: BoxDecoration(
                //             borderRadius: BorderRadius.circular(5.0),
                //             border: Border.all(color: kGreyTextColor),
                //           ),
                //           child: const Icon(
                //             Icons.add,
                //             color: kGreyTextColor,
                //           ),
                //         ),
                //       ),
                //     ),
                //     const SizedBox(
                //       width: 20.0,
                //     ),
                //   ],
                // ),

                Divider(
                  thickness: 1.5,
                  color: Constants().kBgColor,
                ),
                const SizedBox(
                  height: 10,
                ),
                brandData.when(data: (data) {
                  return GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 20,
                        mainAxisSpacing: 10,
                        childAspectRatio: (1 / 0.35),
                      ),
                      shrinkWrap: true,
                      itemCount: data.length,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, i) {
                        return data[i].brandName.contains(search)
                            ? Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 5.0),
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.pop(context, data[i].brandName);
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.only(left: 10.0),
                                    decoration: BoxDecoration(
                                      color: Constants().kBgColor,
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(8)),
                                    ),
                                    alignment: Alignment.center,
                                    child: Text(
                                      data[i].brandName,
                                      style: GoogleFonts.poppins(
                                        fontSize: 18.0,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            : Container();
                      });
                }, error: (_, __) {
                  return Container();
                }, loading: () {
                  return const CircularProgressIndicator();
                }),
              ],
            );
          }),
        ),
      ),
    );
  }
}
