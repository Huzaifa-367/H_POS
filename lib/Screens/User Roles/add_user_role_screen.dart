import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_pos/GlobalComponents/button_global.dart';
import 'package:mobile_pos/constant.dart';
import 'package:mobile_pos/model/user_role_model.dart';
import 'package:nb_utils/nb_utils.dart';
import '../Authentication/phone.dart';

class AddUserRole extends StatefulWidget {
  const AddUserRole({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _AddUserRoleState createState() => _AddUserRoleState();
}

class _AddUserRoleState extends State<AddUserRole> {
  GlobalKey<FormState> globalKey = GlobalKey<FormState>();
  bool validateAndSave() {
    final form = globalKey.currentState;
    if (form!.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  bool allPermissions = false;
  bool salePermission = false;
  bool partiesPermission = false;
  bool purchasePermission = false;
  bool productPermission = false;
  bool profileEditPermission = false;
  bool addExpensePermission = false;
  bool lossProfitPermission = false;
  bool dueListPermission = false;
  bool stockPermission = false;
  bool reportsPermission = false;
  bool salesListPermission = false;
  bool purchaseListPermission = false;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController titleController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, __) {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text(
            'Add User Role',
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
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(width: 0.5, color: Constants.kMainColor!),
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                    ),
                    child: Column(
                      children: [
                        ///_______all_&_sale____________________________________________
                        Row(
                          children: [
                            ///_______all__________________________
                            SizedBox(
                              width: context.width() / 2 - 20,
                              child: CheckboxListTile(
                                activeColor: Constants.kMainColor,
                                value: allPermissions,
                                onChanged: (value) {
                                  if (value == true) {
                                    setState(() {
                                      allPermissions = value!;
                                      salePermission = true;
                                      partiesPermission = true;
                                      purchasePermission = true;
                                      productPermission = true;
                                      profileEditPermission = true;
                                      addExpensePermission = true;
                                      lossProfitPermission = true;
                                      dueListPermission = true;
                                      stockPermission = true;
                                      reportsPermission = true;
                                      salesListPermission = true;
                                      purchaseListPermission = true;
                                    });
                                  } else {
                                    setState(() {
                                      allPermissions = value!;
                                      salePermission = false;
                                      partiesPermission = false;
                                      purchasePermission = false;
                                      productPermission = false;
                                      profileEditPermission = false;
                                      addExpensePermission = false;
                                      lossProfitPermission = false;
                                      dueListPermission = false;
                                      stockPermission = false;
                                      reportsPermission = false;
                                      salesListPermission = false;
                                      purchaseListPermission = false;
                                    });
                                  }
                                },
                                title: const Text('All'),
                              ),
                            ),
                          ],
                        ),

                        ///_______Edit Profile_&_sale____________________________________________
                        Row(
                          children: [
                            ///_______Edit_Profile_________________________
                            Expanded(
                              child: CheckboxListTile(
                                activeColor: Constants.kMainColor,
                                value: profileEditPermission,
                                onChanged: (value) {
                                  setState(() {
                                    profileEditPermission = value!;
                                  });
                                },
                                title: const Text('Profile Edit'),
                              ),
                            ),

                            ///______sales____________________________
                            Expanded(
                              child: CheckboxListTile(
                                activeColor: Constants.kMainColor,
                                value: salePermission,
                                onChanged: (value) {
                                  setState(() {
                                    salePermission = value!;
                                  });
                                },
                                title: const Text('Sales'),
                              ),
                            ),
                          ],
                        ),

                        ///_____parties_&_Purchase_________________________________________
                        Row(
                          children: [
                            Expanded(
                              child: CheckboxListTile(
                                activeColor: Constants.kMainColor,
                                value: partiesPermission,
                                onChanged: (value) {
                                  setState(() {
                                    partiesPermission = value!;
                                  });
                                },
                                title: const Text('Parties'),
                              ),
                            ),
                            Expanded(
                              child: CheckboxListTile(
                                activeColor: Constants.kMainColor,
                                value: purchasePermission,
                                onChanged: (value) {
                                  setState(() {
                                    purchasePermission = value!;
                                  });
                                },
                                title: const Text('Purchase'),
                              ),
                            ),
                          ],
                        ),

                        ///_____Product_&_DueList_________________________________________
                        Row(
                          children: [
                            Expanded(
                              child: CheckboxListTile(
                                activeColor: Constants.kMainColor,
                                value: productPermission,
                                onChanged: (value) {
                                  setState(() {
                                    productPermission = value!;
                                  });
                                },
                                title: const Text('Products'),
                              ),
                            ),
                            Expanded(
                              child: CheckboxListTile(
                                activeColor: Constants.kMainColor,
                                value: dueListPermission,
                                onChanged: (value) {
                                  setState(() {
                                    dueListPermission = value!;
                                  });
                                },
                                title: const Text('Due List'),
                              ),
                            ),
                          ],
                        ),

                        ///_____Stock_&_Reports_________________________________________
                        Row(
                          children: [
                            Expanded(
                              child: CheckboxListTile(
                                activeColor: Constants.kMainColor,
                                value: stockPermission,
                                onChanged: (value) {
                                  setState(() {
                                    stockPermission = value!;
                                  });
                                },
                                title: const Text('Stock'),
                              ),
                            ),
                            Expanded(
                              child: CheckboxListTile(
                                activeColor: Constants.kMainColor,
                                value: reportsPermission,
                                onChanged: (value) {
                                  setState(() {
                                    reportsPermission = value!;
                                  });
                                },
                                title: const Text('Reports'),
                              ),
                            ),
                          ],
                        ),

                        ///_____SalesList_&_Purchase List_________________________________________
                        Row(
                          children: [
                            Expanded(
                              child: CheckboxListTile(
                                activeColor: Constants.kMainColor,
                                value: salesListPermission,
                                onChanged: (value) {
                                  setState(() {
                                    salesListPermission = value!;
                                  });
                                },
                                title: const Text('Sales List'),
                              ),
                            ),
                            Expanded(
                              child: CheckboxListTile(
                                activeColor: Constants.kMainColor,
                                value: purchaseListPermission,
                                onChanged: (value) {
                                  setState(() {
                                    purchaseListPermission = value!;
                                  });
                                },
                                title: const Text('Purchase List'),
                              ),
                            ),
                          ],
                        ),

                        ///_____LossProfit_&_Expense_________________________________________
                        Row(
                          children: [
                            Expanded(
                              child: CheckboxListTile(
                                activeColor: Constants.kMainColor,
                                value: lossProfitPermission,
                                onChanged: (value) {
                                  setState(() {
                                    lossProfitPermission = value!;
                                  });
                                },
                                title: const Text('Loss Profit'),
                              ),
                            ),
                            Expanded(
                              child: CheckboxListTile(
                                activeColor: Constants.kMainColor,
                                value: addExpensePermission,
                                onChanged: (value) {
                                  setState(() {
                                    addExpensePermission = value!;
                                  });
                                },
                                title: const Text('Expense'),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                ///___________Text_fields_____________________________________________
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Form(
                    key: globalKey,
                    child: Column(
                      children: [
                        ///__________email_________________________________________________________
                        AppTextField(
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Email can\'n be empty';
                            } else if (!value.contains('@')) {
                              return 'Please enter a valid email';
                            }
                            return null;
                          },
                          showCursor: true,
                          controller: emailController,
                          // cursorColor: kTitleColor,
                          decoration: kInputDecoration.copyWith(
                            labelText: 'Email',
                            // labelStyle: kTextStyle.copyWith(color: kTitleColor),
                            hintText: 'Enter your email address',
                            // hintStyle: kTextStyle.copyWith(color: kLitGreyColor),
                            contentPadding: const EdgeInsets.all(10.0),
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
                            errorBorder: const OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.red)),
                          ),
                          textFieldType: TextFieldType.EMAIL,
                        ),
                        const SizedBox(height: 20.0),

                        ///______password___________________________________________________________
                        AppTextField(
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Password can\'t be empty';
                            } else if (value.length < 4) {
                              return 'Please enter a bigger password';
                            }
                            return null;
                          },
                          suffixIconColor: Constants.kMainColor,
                          controller: passwordController,
                          showCursor: true,
                          // cursorColor: kTitleColor,
                          decoration: kInputDecoration.copyWith(
                            labelText: 'Password',
                            floatingLabelAlignment:
                                FloatingLabelAlignment.start,
                            // labelStyle: kTextStyle.copyWith(color: kTitleColor),
                            hintText: 'Enter your password',
                            // hintStyle: kTextStyle.copyWith(color: kLitGreyColor),
                            contentPadding: const EdgeInsets.all(10.0),
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
                            errorBorder: const OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.red)),
                          ),
                          textFieldType: TextFieldType.PASSWORD,
                        ),

                        ///________retype_email____________________________________________________
                        const SizedBox(height: 20.0),
                        AppTextField(
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Password can\'t be empty';
                            } else if (value != passwordController.text) {
                              return 'Password and confirm password does not match';
                            } else if (value.length < 4) {
                              return 'Please enter a bigger password';
                            }
                            return null;
                          },
                          suffixIconColor: Constants.kMainColor,
                          controller: confirmPasswordController,
                          showCursor: true,
                          // cursorColor: kTitleColor,
                          decoration: kInputDecoration.copyWith(
                            labelText: 'Password',
                            floatingLabelAlignment:
                                FloatingLabelAlignment.start,
                            // labelStyle: kTextStyle.copyWith(color: kTitleColor),
                            hintText: 'Enter your password',
                            // hintStyle: kTextStyle.copyWith(color: kLitGreyColor),
                            contentPadding: const EdgeInsets.all(10.0),
                            errorBorder: const OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.red)),
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
                          ),
                          textFieldType: TextFieldType.PASSWORD,
                        ),

                        ///__________Title_________________________________________________________
                        const SizedBox(height: 20.0),
                        AppTextField(
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'User title can\'n be empty';
                            }
                            return null;
                          },
                          showCursor: true,
                          controller: titleController,
                          decoration: kInputDecoration.copyWith(
                            labelText: 'User Title',
                            hintText: 'Enter User Title',
                            contentPadding: const EdgeInsets.all(10.0),
                            errorBorder: const OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.red)),
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
                          ),
                          textFieldType: TextFieldType.EMAIL,
                        ),
                        const SizedBox(height: 20.0),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(10.0),
          child: ButtonGlobalWithoutIcon(
              buttontext: 'Create',
              buttonDecoration: kButtonDecoration.copyWith(color: Constants.kMainColor),
              // onPressed: () async {
              //   // for (var element in customerData.value!) {
              //   //   if (element.phoneNumber == phoneNumber) {
              //   //     EasyLoading.showError('Phone number already exist');
              //   //     isPhoneAlready = true;
              //   //     phoneText.clear();
              //   //   }
              //   // }
              //   Future.delayed(const Duration(milliseconds: 500), () async {
              //     if (isPhoneAlready) {
              //     } else {
              //       try {
              //         EasyLoading.show(status: 'Loading...', dismissOnTap: false);
              //         imagePath == 'No Data' ? null : await uploadFile(imagePath);
              //         // ignore: no_leading_underscores_for_local_identifiers
              //         final DatabaseReference _customerInformationRef = FirebaseDatabase.instance
              //             // ignore: deprecated_member_use
              //             .reference()
              //             .child(FirebaseAuth.instance.currentUser!.uid)
              //             .child('Customers');
              //         CustomerModel customerModel = CustomerModel(
              //           customerName,
              //           phoneNumber,
              //           radioItem,
              //           profilePicture,
              //           emailAddress,
              //           customerAddress,
              //           dueAmount,
              //         );
              //         await _customerInformationRef.push().set(customerModel.toJson());
              //
              //         ///________Subscription_____________________________________________________
              //         decreaseSubscriptionSale();
              //
              //         EasyLoading.showSuccess('Added Successfully!');
              //         ref.refresh(customerProvider);
              //         Future.delayed(const Duration(milliseconds: 100), () {
              //           Navigator.pop(context);
              //         });
              //       } catch (e) {
              //         EasyLoading.dismiss();
              //         ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
              //       }
              //     }
              //   });
              // },
              onPressed: (() {
                if (salePermission ||
                    partiesPermission ||
                    purchasePermission ||
                    productPermission ||
                    profileEditPermission ||
                    addExpensePermission ||
                    lossProfitPermission ||
                    dueListPermission ||
                    stockPermission ||
                    reportsPermission ||
                    salesListPermission ||
                    purchaseListPermission) {
                  if (validateAndSave()) {
                    UserRoleModel userRoleData = UserRoleModel(
                      email: emailController.text,
                      userTitle: titleController.text,
                      databaseId: FirebaseAuth.instance.currentUser!.uid,
                      salePermission: salePermission,
                      partiesPermission: partiesPermission,
                      purchasePermission: purchasePermission,
                      productPermission: productPermission,
                      profileEditPermission: profileEditPermission,
                      addExpensePermission: addExpensePermission,
                      lossProfitPermission: lossProfitPermission,
                      dueListPermission: dueListPermission,
                      stockPermission: stockPermission,
                      reportsPermission: reportsPermission,
                      salesListPermission: salesListPermission,
                      purchaseListPermission: purchaseListPermission,
                    );
                    // print(FirebaseAuth.instance.currentUser!.uid);
                    signUp(
                      context: context,
                      email: emailController.text,
                      password: passwordController.text,
                      ref: ref,
                      userRoleModel: userRoleData,
                    );
                  }
                } else {
                  EasyLoading.showError('You Have To Give Permission');
                }
              }),
              buttonTextColor: Colors.white),
        ),
      );
    });
  }
}

void signUp(
    {required BuildContext context,
    required String email,
    required String password,
    required WidgetRef ref,
    required UserRoleModel userRoleModel}) async {
  EasyLoading.show(status: 'Registering....');
  try {
    UserCredential userCredential = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);
    // ignore: unnecessary_null_comparison
    if (userCredential != null) {
      await FirebaseDatabase.instance
          .ref()
          .child(userRoleModel.databaseId)
          .child('User Role')
          .push()
          .set(userRoleModel.toJson());
      await FirebaseDatabase.instance
          .ref()
          .child('Admin Panel')
          .child('User Role')
          .push()
          .set(userRoleModel.toJson());

      EasyLoading.dismiss();
      await FirebaseAuth.instance.signOut();
      // ignore: use_build_context_synchronously
      await showSussesScreenAndLogOut(context: context);
    }
  } on FirebaseAuthException catch (e) {
    EasyLoading.showError('Failed with Error');
    if (e.code == 'weak-password') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('The password provided is too weak.'),
          duration: Duration(seconds: 3),
        ),
      );
    } else if (e.code == 'email-already-in-use') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('The account already exists for that email.'),
          duration: Duration(seconds: 3),
        ),
      );
    }
  } catch (e) {
    EasyLoading.showError('Failed with Error');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(e.toString()),
        duration: const Duration(seconds: 3),
      ),
    );
  }
}

Future showSussesScreenAndLogOut({required BuildContext context}) {
  return showDialog(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) {
      return WillPopScope(
        onWillPop: () async {
          return false;
        },
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Center(
            child: Container(
              width: double.infinity,
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
                    const Text(
                      'Added Successful',
                      style: TextStyle(fontSize: 22),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'You have to RE-LOGIN on your account.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 20),
                    ButtonGlobalWithoutIcon(
                        buttontext: 'Ok',
                        buttonDecoration:
                            kButtonDecoration.copyWith(color: Colors.green),
                        onPressed: (() {
                          const PhoneAuth().launch(context, isNewTask: true);
                          // const SplashScreen().launch(context, isNewTask: true);
                        }),
                        buttonTextColor: Colors.white),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    },
  );
}
