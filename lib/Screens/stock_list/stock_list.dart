import 'dart:convert';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nb_utils/nb_utils.dart';
import '../../Provider/product_provider.dart';
import '../../constant.dart';
import '../../currency.dart';
import '../../model/product_model.dart';
import 'package:mobile_pos/generated/l10n.dart' as lang;

class StockList extends StatefulWidget {
  const StockList({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _StockListState createState() => _StockListState();
}

class _StockListState extends State<StockList> {
  int totalStock = 0;
  double totalSalePrice = 0;
  double totalParPrice = 0;

  @override
  void initState() {
    getAllTotal();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          lang.S.of(context).stockList,
          style: GoogleFonts.poppins(
              color: Colors.black, fontSize: 22.0, fontWeight: FontWeight.w500),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0.0,
      ),
      body: Consumer(builder: (context, ref, __) {
        final providerData = ref.watch(productProvider);

        return SingleChildScrollView(
          child: Column(
            children: [
              Column(
                children: [
                  // const SizedBox(height: 10.0),
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      // borderRadius: BorderRadius.circular(10),
                      color: Constants().kBgColor,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 4,
                          child: Text(
                            lang.S.of(context).product,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Text(
                            lang.S.of(context).quantity,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Text(
                            lang.S.of(context).purchase,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Text(
                            lang.S.of(context).sale,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // DataTable(
                  //   horizontalMargin: 40.0,
                  //   columnSpacing: 50.0,
                  //   headingRowColor: MaterialStateColor.resolveWith(
                  //       (states) => Constants.kMainColor.withOpacity(0.2)),
                  //   columns: const <DataColumn>[
                  //     DataColumn(
                  //       label: Text(
                  //         'Product',
                  //         overflow: TextOverflow.ellipsis,
                  //         maxLines: 2,
                  //       ),
                  //     ),
                  //     DataColumn(
                  //       label: Text(
                  //         'QTY',
                  //       ),
                  //     ),
                  //     DataColumn(
                  //       label: Text(
                  //         'Purchase',
                  //         overflow: TextOverflow.ellipsis,
                  //         maxLines: 2,
                  //       ),
                  //     ),
                  //     DataColumn(
                  //       label: Text(
                  //         'Sale',
                  //         overflow: TextOverflow.ellipsis,
                  //         maxLines: 2,
                  //       ),
                  //     ),
                  //   ],
                  //   rows: const [],
                  // ).visible(false),
                  providerData.when(data: (product) {
                    return ListView.builder(
                        itemCount: product.length,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 4,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        product[index].productName,
                                        textAlign: TextAlign.start,
                                        style: GoogleFonts.poppins(
                                          color: product[index]
                                                      .productStock
                                                      .toInt() <=
                                                  5
                                              ? Colors.red
                                              : Colors.black,
                                          fontSize: 10.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        product[index].brandName,
                                        textAlign: TextAlign.start,
                                        style: GoogleFonts.poppins(
                                          color: product[index]
                                                      .productStock
                                                      .toInt() <=
                                                  5
                                              ? Colors.red
                                              : kGreyTextColor,
                                          fontSize: 10.0,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Center(
                                    child: Text(
                                      product[index].productStock,
                                      style: GoogleFonts.poppins(
                                        color: product[index]
                                                    .productStock
                                                    .toInt() <=
                                                5
                                            ? Colors.red
                                            : Colors.black,
                                        fontSize: 12.0,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                    flex: 2,
                                    child: Center(
                                      child: Text(
                                        '$currency: ${product[index].productPurchasePrice}',
                                        style: GoogleFonts.poppins(
                                          color: Constants.kMainColor,
                                          fontSize: 10.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    )),
                                Expanded(
                                  flex: 2,
                                  child: Center(
                                    child: Text(
                                      '$currency: ${product[index].productSalePrice}',
                                      style: GoogleFonts.poppins(
                                        color: kPremiumPlanColor2,
                                        fontSize: 10.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
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
            ],
          ),
        );
      }),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(20),
        color: Constants.kMainColor.withOpacity(0.2),
        child: Row(
          children: [
            Expanded(
              flex: 4,
              child: Text(
                lang.S.of(context).total,
                textAlign: TextAlign.start,
                style: GoogleFonts.poppins(
                  color: Colors.black,
                  fontSize: 12.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Text(
                totalStock.toString(),
                style: GoogleFonts.poppins(
                  color: Colors.black,
                  fontSize: 12.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Text(
                '$currency: ${totalParPrice.toInt().toString()}',
                style: GoogleFonts.poppins(
                  color: Constants.kMainColor,
                  fontSize: 10.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Text(
                '$currency: ${totalSalePrice.toInt().toString()}',
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.poppins(
                  color: kPremiumPlanColor2,
                  fontSize: 10.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void getAllTotal() async {
    // ignore: unused_local_variable
    List<ProductModel> productList = [];
    await FirebaseDatabase.instance
        .ref(constUserId)
        .child('Products')
        .orderByKey()
        .get()
        .then((value) {
      for (var element in value.children) {
        var data = jsonDecode(jsonEncode(element.value));
        totalStock = totalStock + int.parse(data['productStock']);
        totalSalePrice = totalSalePrice +
            (int.parse(data['productSalePrice']) *
                int.parse(data['productStock']));
        totalParPrice = totalParPrice +
            (int.parse(data['productPurchasePrice']) *
                int.parse(data['productStock']));
        // productList.add(ProductModel.fromJson(jsonDecode(jsonEncode(element.value))));
      }
    });
    setState(() {});
  }
}
