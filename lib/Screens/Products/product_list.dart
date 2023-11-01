import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_pos/GlobalComponents/Product_Card.dart';
import 'package:mobile_pos/Provider/product_provider.dart';
import 'package:mobile_pos/Screens/Products/Bar_Code_Generate.dart';
import 'package:mobile_pos/Screens/Products/update_product.dart';
import 'package:nb_utils/nb_utils.dart';
import '../../GlobalComponents/button_global.dart';
import '../../constant.dart';
import '../../currency.dart';
import 'package:mobile_pos/generated/l10n.dart' as lang;

class ProductList extends StatefulWidget {
  const ProductList({Key? key}) : super(key: key);

  @override
  State<ProductList> createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, __) {
        final providerData = ref.watch(productProvider);
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            iconTheme: const IconThemeData(color: Colors.black),
            title: Text(
              lang.S.of(context).productList,
              style: GoogleFonts.poppins(
                color: Colors.black,
              ),
            ),
            centerTitle: true,
          ),
          body: SingleChildScrollView(
            child: providerData.when(data: (products) {
              return products.isNotEmpty
                  ? ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: products.length,
                      itemBuilder: (_, i) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: GestureDetector(
                            onTap: () {
                              UpdateProduct(productModel: products[i])
                                  .launch(context);
                            },
                            child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Constants().kBgColor),
                                child: ProductCard(
                                  productTitle: products[i].productName,
                                  productDescription: products[i].brandName,
                                  stock: products[i].productStock,
                                  productImage: products[i].productPicture,
                                  /////
                                  ///
                                  productPrice: products[i].productSalePrice,
                                  productCode: products[i].productCode,
                                  purchasePrice:
                                      products[i].productPurchasePrice,
                                  capacity: products[i].capacity,
                                  color: products[i].color,
                                  type: products[i].type,
                                  size: products[i].size,
                                  weight: products[i].weight,
                                )),
                          ),
                        );
                      })
                  : Center(
                      child: Text(
                        lang.S.of(context).addProduct,
                        maxLines: 2,
                        style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 20.0),
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
          ),
          bottomNavigationBar: ButtonGlobal(
            iconWidget: Icons.add,
            buttontext: lang.S.of(context).addNewProduct,
            iconColor: Colors.white,
            buttonDecoration:
                kButtonDecoration.copyWith(color: Constants.kMainColor),
            onPressed: () {
              Navigator.pushNamed(context, '/AddProducts');
            },
          ),
        );
      },
    );
  }
}
