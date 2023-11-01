import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_pos/GlobalComponents/button_global.dart';
import 'package:mobile_pos/Provider/customer_provider.dart';
import 'package:mobile_pos/Screens/Parties_Customers/add_Parties.dart';
import 'package:mobile_pos/Screens/Parties_Customers/customer_details.dart';
import 'package:mobile_pos/constant.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:mobile_pos/generated/l10n.dart' as lang;
import '../../currency.dart';

class CustomerList extends StatefulWidget {
  const CustomerList({Key? key}) : super(key: key);

  @override
  State<CustomerList> createState() => _CustomerListState();
}

class _CustomerListState extends State<CustomerList> {
  late Color color;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          lang.S.of(context).partyList,
          style: GoogleFonts.poppins(
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 0.0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Consumer(builder: (context, ref, __) {
          final providerData = ref.watch(customerProvider);

          return providerData.when(data: (customer) {
            return customer.isNotEmpty
                ? ListView.builder(
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

                      return GestureDetector(
                        onTap: () {
                          CustomerDetails(
                            customerModel: customer[index],
                          ).launch(context);
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5.0),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Constants().kBgColor,
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(8)),
                            ),
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
                                          customer[index].profilePicture,
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        customer[index].customerName,
                                        style: GoogleFonts.poppins(
                                          color: Colors.black,
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        customer[index].type,
                                        style: GoogleFonts.poppins(
                                          color: color,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const Spacer(),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        '$currency: ${customer[index].dueAmount}',
                                        style: GoogleFonts.poppins(
                                          color: Colors.black,
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        lang.S.of(context).due,
                                        style: GoogleFonts.poppins(
                                          color: kPremiumPlanColor2,
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ).visible(customer[index].dueAmount != '' &&
                                      customer[index].dueAmount != '0'),
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
                      );
                    })
                : Center(
                    child: Text(
                      lang.S.of(context).addCustomer,
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
          });
        }),
      ),
      bottomNavigationBar: ButtonGlobal(
        iconWidget: Icons.add,
        buttontext: lang.S.of(context).addCustomer,
        
        iconColor: Colors.white,
        buttonDecoration:
            kButtonDecoration.copyWith(color: Constants.kMainColor),
        onPressed: () {
          const AddCustomer().launch(context);
        },
      ),
    );
  }
}
