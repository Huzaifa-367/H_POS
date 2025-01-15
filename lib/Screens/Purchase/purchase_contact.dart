import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_pos/Screens/Parties_Customers/Model/customer_model.dart';
import 'package:mobile_pos/Screens/Purchase/purchase_details.dart';
import 'package:mobile_pos/constant.dart';
import 'package:nb_utils/nb_utils.dart';

class PurchaseContact extends StatefulWidget {
  const PurchaseContact({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _PurchaseContactState createState() => _PurchaseContactState();
}

class _PurchaseContactState extends State<PurchaseContact> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Choose a Customer',
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
          child: FirebaseAnimatedList(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            defaultChild: Padding(
              padding: const EdgeInsets.only(top: 30.0, bottom: 30.0),
              child: Loader(
                color: Colors.white.withOpacity(0.2),
                size: 60,
              ),
            ),
            query: FirebaseDatabase.instance
                // ignore: deprecated_member_use
                .ref()
                .child(constUserId)
                .child('Customers'),
            itemBuilder: (context, snapshot, animation, index) {
              final json = snapshot.value as Map<dynamic, dynamic>;
              final customer = CustomerModel.fromJson(json);
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: () {
                    PurchaseDetails(customerName: customer.customerName)
                        .launch(context);
                  },
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
                              customer.profilePicture,
                              fit: BoxFit.cover,
                              width: 120.0,
                              height: 120.0,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 10.0,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            customer.customerName,
                            style: GoogleFonts.poppins(
                              color: Colors.black,
                              fontSize: 15.0,
                            ),
                          ),
                          Text(
                            customer.phoneNumber,
                            style: GoogleFonts.poppins(
                              color: kGreyTextColor,
                              fontSize: 15.0,
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      const Icon(
                        Icons.arrow_forward_ios,
                        color: kGreyTextColor,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
