import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_pos/Provider/add_to_cart.dart';
import 'package:mobile_pos/Screens/Parties_Customers/Model/customer_model.dart';
import 'package:mobile_pos/Screens/Parties_Customers/add_Parties.dart';
import 'package:mobile_pos/Screens/Sales/add_sales.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../Provider/customer_provider.dart';
import '../../constant.dart';
import '../../currency.dart';
import 'package:mobile_pos/generated/l10n.dart' as lang;

class SalesContact extends StatefulWidget {
  const SalesContact({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _SalesContactState createState() => _SalesContactState();
}

class _SalesContactState extends State<SalesContact> {
  Color color = Colors.black26;
  String searchCustomer = '';

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, __) {
      final providerData = ref.watch(customerProvider);
      final cart = ref.watch(cartNotifier);
      return Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text(
            lang.S.of(context).chooseCustomer,
            style: GoogleFonts.poppins(
              color: Colors.black,
            ),
          ),
          centerTitle: true,
          iconTheme: const IconThemeData(color: Colors.black),
          elevation: 0.0,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: providerData.when(data: (customer) {
              return customer.isNotEmpty
                  ? Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: AppTextField(
                            textFieldType: TextFieldType.NAME,
                            decoration: InputDecoration(
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color:
                                        Constants.kMainColor!), // Change the border color when focused
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color:
                                        Constants().kBgColor), // Change the border color when not focused
                              ),
                              border: const OutlineInputBorder(),
                              hintText: lang.S.of(context).search,
                              prefixIcon: Icon(
                                Icons.search,
                                color: kGreyTextColor.withOpacity(0.5),
                              ),
                            ),
                            onChanged: (value) {
                              setState(() {
                                searchCustomer = value;
                              });
                            },
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            CustomerModel guestModel = CustomerModel(
                              'Guest',
                              'Guest',
                              'Guest',
                              'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460__340.png',
                              'Guest',
                              'Guest',
                              '0',
                            );
                            AddSalesScreen(customerModel: guestModel)
                                .launch(context);
                            cart.clearCart();
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Constants().kBgColor,
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(8)),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Row(
                                  children: [
                                    SizedBox(
                                      height: 50.0,
                                      width: 50.0,
                                      child: CircleAvatar(
                                        foregroundColor: Colors.blue,
                                        backgroundColor: Colors.white,
                                        radius: 70.0,
                                        child: ClipOval(
                                          child: Image.network(
                                            'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460__340.png',
                                            fit: BoxFit.cover,
                                            width: 120.0,
                                            height: 120.0,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 10.0),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Walk-in Customer',
                                          style: GoogleFonts.poppins(
                                            color: Colors.black,
                                            fontSize: 15.0,
                                          ),
                                        ),
                                        Text(
                                          'Guest',
                                          style: GoogleFonts.poppins(
                                            color: Colors.grey,
                                            fontSize: 15.0,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const Spacer(),
                                    const SizedBox(width: 20),
                                    Icon(
                                      Icons.arrow_forward_ios,
                                      color: Constants.kMainColor,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          height: 1.5,
                          width: double.infinity,
                          color: Constants.kMainColor,
                        ),
                        ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: customer.length,
                            itemBuilder: (_, index) {
                              customer[index].type == 'Retailer'
                                  ? color = const Color(0xFF56da87)
                                  : Colors.white;
                              customer[index].type == 'Wholesaler'
                                  ? color = const Color(0xFF25a9e0)
                                  : Colors.white;
                              customer[index].type == 'Dealer'
                                  ? color = const Color(0xFFff5f00)
                                  : Colors.white;
                              customer[index].type == 'Supplier'
                                  ? color = const Color(0xFFA569BD)
                                  : Colors.white;
                              return customer[index]
                                          .customerName
                                          .contains(searchCustomer) &&
                                      !customer[index].type.contains('Supplier')
                                  ? GestureDetector(
                                      onTap: () {
                                        AddSalesScreen(
                                                customerModel: customer[index])
                                            .launch(context);
                                        cart.clearCart();
                                      },
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(top: 5.0),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: Constants().kBgColor,
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(8)),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Row(
                                              children: [
                                                SizedBox(
                                                  height: 50.0,
                                                  width: 50.0,
                                                  child: CircleAvatar(
                                                    foregroundColor:
                                                        Colors.blue,
                                                    backgroundColor:
                                                        Colors.white,
                                                    radius: 70.0,
                                                    child: ClipOval(
                                                      child: Image.network(
                                                        customer[index]
                                                            .profilePicture,
                                                        fit: BoxFit.cover,
                                                        width: 120.0,
                                                        height: 120.0,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(width: 10.0),
                                                Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      customer[index]
                                                          .customerName,
                                                      style:
                                                          GoogleFonts.poppins(
                                                        color: Colors.black,
                                                        fontSize: 15.0,
                                                      ),
                                                    ),
                                                    Text(
                                                      customer[index].type,
                                                      style:
                                                          GoogleFonts.poppins(
                                                        color: color,
                                                        fontSize: 15.0,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                const Spacer(),
                                                Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.end,
                                                  children: [
                                                    Text(
                                                      '$currency ${customer[index].dueAmount}',
                                                      style:
                                                          GoogleFonts.poppins(
                                                        color: Colors.black,
                                                        fontSize: 15.0,
                                                      ),
                                                    ),
                                                    Text(
                                                      lang.S.of(context).due,
                                                      style:
                                                          GoogleFonts.poppins(
                                                        color: const Color(
                                                            0xFFff5f00),
                                                        fontSize: 15.0,
                                                      ),
                                                    ),
                                                  ],
                                                ).visible(customer[index]
                                                            .dueAmount !=
                                                        '' &&
                                                    customer[index].dueAmount !=
                                                        '0'),
                                                const SizedBox(width: 20),
                                                Icon(
                                                  Icons.arrow_forward_ios,
                                                  color: Constants.kMainColor,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                                  : Container();
                            }),
                      ],
                    )
                  : GestureDetector(
                      onTap: () {
                        CustomerModel guestModel = CustomerModel(
                          'Guest',
                          'Guest',
                          'Guest',
                          'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460__340.png',
                          'Guest',
                          'Guest',
                          '0',
                        );
                        AddSalesScreen(customerModel: guestModel)
                            .launch(context);
                        cart.clearCart();
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            SizedBox(
                              height: 50.0,
                              width: 50.0,
                              child: CircleAvatar(
                                foregroundColor: Colors.blue,
                                backgroundColor: Colors.white,
                                radius: 70.0,
                                child: ClipOval(
                                  child: Image.network(
                                    'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460__340.png',
                                    fit: BoxFit.cover,
                                    width: 120.0,
                                    height: 120.0,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10.0),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Walk-in Customer',
                                  style: GoogleFonts.poppins(
                                    color: Colors.black,
                                    fontSize: 15.0,
                                  ),
                                ),
                                Text(
                                  'Guest',
                                  style: GoogleFonts.poppins(
                                    color: Colors.grey,
                                    fontSize: 15.0,
                                  ),
                                ),
                              ],
                            ),
                            const Spacer(),
                            const SizedBox(width: 20),
                            Icon(
                              Icons.arrow_forward_ios,
                              color: Constants.kMainColor,
                            ),
                          ],
                        ),
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
        ),
        floatingActionButton: FloatingActionButton(
            backgroundColor: Constants.kMainColor,
            child: const Icon(
              Icons.add,
              color: kDarkWhite,
            ),
            onPressed: () {
              const AddCustomer().launch(context);
            }),
      );
    });
  }
}
