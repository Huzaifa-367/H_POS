import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_pos/GlobalComponents/button_global.dart';
import 'package:mobile_pos/Provider/delivery_address_provider.dart';
import 'package:mobile_pos/constant.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:mobile_pos/generated/l10n.dart' as lang;
import 'add_delivery_location.dart';

class DeliveryAddress extends StatefulWidget {
  const DeliveryAddress({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _DeliveryAddressState createState() => _DeliveryAddressState();
}

class _DeliveryAddressState extends State<DeliveryAddress> {
  bool selected = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          lang.S.of(context).deliveryAddress,
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
      body: Consumer(builder: (context, ref, __) {
        final providerData = ref.watch(deliveryAddressProvider);
        if (providerData.value!.isEmpty) {
          return Center(
              child: Text(
            lang.S.of(context).noDataAvailabe,
            style: const TextStyle(fontSize: 18),
          ));
        } else {
          return SingleChildScrollView(
            child: Column(
              children: [
                providerData.when(data: (deliveryAddress) {
                  return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: deliveryAddress.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Card(
                            elevation: 4.0,
                            shape: RoundedRectangleBorder(side: const BorderSide(color: Colors.white, width: 2.0), borderRadius: BorderRadius.circular(15.0)),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 20.0, top: 20.0, bottom: 10.0),
                                  child: Row(
                                    children: [
                                      const Image(
                                        image: AssetImage('images/officedeliver.png'),
                                      ),
                                      const SizedBox(
                                        width: 15.0,
                                      ),
                                      Text(
                                        '${deliveryAddress[index].firstName} / ${deliveryAddress[index].addressType}',
                                        style: GoogleFonts.poppins(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20.0,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(left: 20.0),
                                      child: SizedBox(
                                        width: 200.0,
                                        child: Text(
                                          deliveryAddress[index].addressLocation,
                                          maxLines: 2,
                                          style: GoogleFonts.poppins(
                                            color: kGreyTextColor,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 50.0,
                                    ),
                                    const Image(
                                      image: AssetImage('images/map.png'),
                                      height: 66.0,
                                      width: 66.0,
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 20.0, top: 10.0, bottom: 30.0),
                                  child: Text(
                                    deliveryAddress[index].phoneNumber,
                                    style: GoogleFonts.poppins(
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ],
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
          );
        }
      }),
      bottomNavigationBar: ButtonGlobalWithoutIcon(
        buttontext: lang.S.of(context).addDelivery,
        buttonDecoration: kButtonDecoration.copyWith(color: Constants.kMainColor),
        onPressed: () {
          const AddDelivery().launch(context);
        },
        buttonTextColor: Colors.white,
      ),
    );
  }
}
