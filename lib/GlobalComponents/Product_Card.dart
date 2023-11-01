// ignore_for_file: unused_result
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_pos/Screens/Products/Bar_Code_Generate.dart';
import 'package:mobile_pos/constant.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../Provider/add_to_cart.dart';
import '../../currency.dart';

// ignore: must_be_immutable
class ProductCard extends StatefulWidget {
  ProductCard({
    Key? key,
    required this.productTitle,
    required this.productDescription,
    required this.productPrice,
    required this.purchasePrice,
    required this.productImage,
    required this.productCode,
    required this.size,
    required this.color,
    required this.type,
    required this.weight,
    required this.capacity,
    required this.stock,
  }) : super(key: key);

  // final Product product;
  String productImage,
      productTitle,
      productDescription,
      productPrice,
      purchasePrice,
      productCode,
      size,
      color,
      weight,
      capacity,
      stock,
      type;

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  int quantity = 0;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Consumer(builder: (context, ref, __) {
      final providerData = ref.watch(cartNotifier);
      for (var element in providerData.cartItemList) {
        if (element.productName == widget.productTitle) {
          quantity = element.quantity;
        }
      }
      return Padding(
        padding: const EdgeInsets.all(5.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          //mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              //height: size.height * 0.04,
              width: size.width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.productTitle,
                    style: GoogleFonts.jost(
                      fontSize: 12.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => BarCodeGenerateScreen(
                      productName: widget.productTitle,
                      productCode: widget.productCode,
                      productSalePrice: widget.productPrice,
                    ).launch(context),
                    child: Container(
                      height: 25.0,
                      width: 35.0,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4.0),
                        border: Border.all(color: Constants.kMainColor),
                      ),
                      child: const Image(
                        image: AssetImage('images/barcode.png'),
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            //--------------------Descripton---------------
            SizedBox(
              //color: Colors.amber,
              height: widget.size != "Not Provided"
                  ? size.height * 0.11
                  : size.height * 0.075,
              width: size.width,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Container(
                      height: size.height * 0.06,
                      width: size.width * 0.13,
                      decoration: BoxDecoration(
                        border: Border.all(color: Constants.kMainColor),
                        image: DecorationImage(
                            image: NetworkImage(widget.productImage),
                            fit: BoxFit.cover),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                  ),
                  SizedBox(
                    //height: 0.2,
                    width: size.width * 0.2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        widget.productDescription != "Not Provided"
                            ? Text.rich(
                                TextSpan(
                                  text: "Brand: ",
                                  style: GoogleFonts.jost(
                                    fontSize: 10.0,
                                    fontWeight: FontWeight.bold,
                                    color: Constants.kMainColor,
                                  ),
                                  children: [
                                    TextSpan(
                                      text: widget.productDescription,
                                      style: GoogleFonts.jost(
                                        fontSize: 10.0,
                                        fontWeight: FontWeight.bold,
                                        color: kGreyTextColor,
                                      ),
                                    )
                                  ],
                                ),
                              )
                            : const SizedBox.shrink(),
                        widget.color != "Not Provided"
                            ? Text.rich(
                                TextSpan(
                                  text: "color: ",
                                  style: GoogleFonts.jost(
                                    fontSize: 10.0,
                                    fontWeight: FontWeight.bold,
                                    color: Constants.kMainColor,
                                  ),
                                  children: [
                                    TextSpan(
                                      text: widget.color,
                                      style: GoogleFonts.jost(
                                        fontSize: 10.0,
                                        fontWeight: FontWeight.bold,
                                        color: kGreyTextColor,
                                      ),
                                    )
                                  ],
                                ),
                              )
                            : const SizedBox.shrink(),
                        widget.size != "Not Provided"
                            ? Text.rich(
                                TextSpan(
                                  text: "Size: ",
                                  style: GoogleFonts.jost(
                                    fontSize: 10.0,
                                    fontWeight: FontWeight.bold,
                                    color: Constants.kMainColor,
                                  ),
                                  children: [
                                    TextSpan(
                                      text: widget.size,
                                      style: GoogleFonts.jost(
                                        fontSize: 10.0,
                                        fontWeight: FontWeight.bold,
                                        color: kGreyTextColor,
                                      ),
                                    )
                                  ],
                                ),
                              )
                            : const SizedBox.shrink(),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5.0),
                    child: Container(
                      width: 1.5,
                      height: double.infinity,
                      color: Constants.kMainColor,
                    ),
                  ),
                  SizedBox(
                    //height: 0.2,
                    width: size.width * 0.2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        widget.type != "Not Provided"
                            ? Text.rich(
                                TextSpan(
                                  text: "Type: ",
                                  style: GoogleFonts.jost(
                                    fontSize: 10.0,
                                    fontWeight: FontWeight.bold,
                                    color: Constants.kMainColor,
                                  ),
                                  children: [
                                    TextSpan(
                                      text: widget.type,
                                      style: GoogleFonts.jost(
                                        fontSize: 10.0,
                                        fontWeight: FontWeight.bold,
                                        color: kGreyTextColor,
                                      ),
                                    )
                                  ],
                                ),
                              )
                            : const SizedBox.shrink(),
                        widget.stock != "Not Provided"
                            ? Text.rich(
                                TextSpan(
                                  text: "Stock: ",
                                  style: GoogleFonts.jost(
                                    fontSize: 10.0,
                                    fontWeight: FontWeight.bold,
                                    color: Constants.kMainColor,
                                  ),
                                  children: [
                                    TextSpan(
                                      text: widget.stock,
                                      style: GoogleFonts.jost(
                                        fontSize: 10.0,
                                        fontWeight: FontWeight.bold,
                                        color: kGreyTextColor,
                                      ),
                                    )
                                  ],
                                ),
                              )
                            : const SizedBox.shrink(),
                        widget.capacity != "Not Provided"
                            ? Text.rich(
                                TextSpan(
                                  text: "Capacity: ",
                                  style: GoogleFonts.jost(
                                    fontSize: 10.0,
                                    fontWeight: FontWeight.bold,
                                    color: Constants.kMainColor,
                                  ),
                                  children: [
                                    TextSpan(
                                      text: widget.capacity,
                                      style: GoogleFonts.jost(
                                        fontSize: 10.0,
                                        fontWeight: FontWeight.bold,
                                        color: kGreyTextColor,
                                      ),
                                    )
                                  ],
                                ),
                              )
                            : const SizedBox.shrink(),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5.0),
                    child: Container(
                      width: 1.5,
                      height: double.infinity,
                      color: Constants.kMainColor,
                    ),
                  ),
                  SizedBox(
                    //height: 0.2,
                    width: size.width * 0.2,
                    child: Column(
                      children: [
                        Column(
                          children: [
                            Text.rich(
                              TextSpan(
                                text: "Sale: $currency: ",
                                style: GoogleFonts.jost(
                                  fontSize: 10.0,
                                  fontWeight: FontWeight.bold,
                                  color: Constants.kMainColor,
                                ),
                                children: [
                                  TextSpan(
                                    text: widget.productPrice,
                                    style: GoogleFonts.jost(
                                      fontSize: 10.0,
                                      fontWeight: FontWeight.bold,
                                      color: kPremiumPlanColor2,
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Container(
                              height: 1.5,
                              width: double.infinity,
                              color: Constants.kMainColor,
                            ),
                            Text.rich(
                              TextSpan(
                                text: "Buy: $currency: ",
                                style: GoogleFonts.jost(
                                  fontSize: 10.0,
                                  fontWeight: FontWeight.bold,
                                  color: Constants.kMainColor,
                                ),
                                children: [
                                  TextSpan(
                                    text: widget.purchasePrice,
                                    style: GoogleFonts.jost(
                                      fontSize: 10.0,
                                      fontWeight: FontWeight.bold,
                                      color: kGreyTextColor,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      );
    });
  }
}
