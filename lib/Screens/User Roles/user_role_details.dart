// ignore_for_file: unused_result

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_pos/GlobalComponents/button_global.dart';
import 'package:mobile_pos/constant.dart';
import 'package:mobile_pos/model/user_role_model.dart';
import 'package:mobile_pos/repository/get_user_role_repo.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../Provider/user_role_provider.dart';
import '../Authentication/phone.dart';

class UserRoleDetails extends StatefulWidget {
  const UserRoleDetails({Key? key, required this.userRoleModel}) : super(key: key);

  final UserRoleModel userRoleModel;

  @override
  // ignore: library_private_types_in_public_api
  _UserRoleDetailsState createState() => _UserRoleDetailsState();
}

class _UserRoleDetailsState extends State<UserRoleDetails> {
  GlobalKey<FormState> globalKey = GlobalKey<FormState>();

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
  TextEditingController titleController = TextEditingController();
  bool isMailSent = false;

  @override
  void initState() {
    getAllUserData();
    // TODO: implement initState
    super.initState();
    salePermission = widget.userRoleModel.salePermission;
    partiesPermission = widget.userRoleModel.partiesPermission;
    purchasePermission = widget.userRoleModel.purchasePermission;
    productPermission = widget.userRoleModel.productPermission;
    profileEditPermission = widget.userRoleModel.profileEditPermission;
    addExpensePermission = widget.userRoleModel.addExpensePermission;
    lossProfitPermission = widget.userRoleModel.lossProfitPermission;
    dueListPermission = widget.userRoleModel.dueListPermission;
    stockPermission = widget.userRoleModel.stockPermission;
    reportsPermission = widget.userRoleModel.reportsPermission;
    salesListPermission = widget.userRoleModel.salePermission;
    purchaseListPermission = widget.userRoleModel.purchaseListPermission;
    emailController.text = widget.userRoleModel.email;
    titleController.text = widget.userRoleModel.userTitle;
  }

  UserRoleRepo repo = UserRoleRepo();
  List<UserRoleModel> adminRoleList = [];
  List<UserRoleModel> userRoleList = [];

  String adminRoleKey = '';
  String userRoleKey = '';

  void getAllUserData() async {
    adminRoleList = await repo.getAllUserRoleFromAdmin();
    userRoleList = await repo.getAllUserRole();
    for (var element in adminRoleList) {
      if (element.email == widget.userRoleModel.email) {
        adminRoleKey = element.userKey ?? '';
        break;
      }
    }
    for (var element in userRoleList) {
      if (element.email == widget.userRoleModel.email) {
        userRoleKey = element.userKey ?? '';
        break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, __) {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text(
            'User Role Details',
            style: GoogleFonts.poppins(
              color: Colors.black,
            ),
          ),
          actions: [
            IconButton(
                onPressed: () async {
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (BuildContext context) {
                      String pass = '';
                      return Padding(
                        padding: const EdgeInsets.all(30.0),
                        child: Center(
                          child: Container(
                            width: double.infinity,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.all(Radius.circular(30)),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  AppTextField(
                                    textFieldType: TextFieldType.EMAIL,
                                    onChanged: (value) {
                                      pass = value;
                                    },
                                    decoration: const InputDecoration(labelText: 'Enter Password', border: OutlineInputBorder()),
                                  ),
                                  const SizedBox(height: 20),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: ButtonGlobalWithoutIcon(
                                          buttontext: 'Cancel',
                                          buttonDecoration: kButtonDecoration.copyWith(color: Colors.green),
                                          onPressed: (() {
                                            Navigator.pop(context);
                                          }),
                                          buttonTextColor: Colors.white,
                                        ),
                                      ),
                                      Expanded(
                                        child: ButtonGlobalWithoutIcon(
                                            buttontext: 'Delete',
                                            buttonDecoration: kButtonDecoration.copyWith(color: Colors.red),
                                            onPressed: (() async {
                                              if (pass != '' && pass.isNotEmpty) {
                                                await deleteUserRole(
                                                    email: widget.userRoleModel.email, password: pass, adminKey: adminRoleKey, userKey: userRoleKey, context: context);
                                              } else {
                                                EasyLoading.showError('Please Enter Password');
                                              }
                                            }),
                                            buttonTextColor: Colors.white),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
                icon: const Icon(
                  Icons.delete,
                  color: Colors.red,
                ))
          ],
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
                      border: Border.all(width: 0.5, color: kGreyTextColor),
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
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        ///__________email_________________________________________________________
                        AppTextField(
                          readOnly: true,
                          initialValue: widget.userRoleModel.email,
                          // cursorColor: kTitleColor,
                          decoration: kInputDecoration.copyWith(
                            labelText: 'Email',
                            // labelStyle: kTextStyle.copyWith(color: kTitleColor),
                            hintText: 'Enter your email address',
                            // hintStyle: kTextStyle.copyWith(color: kLitGreyColor),
                            contentPadding: const EdgeInsets.all(10.0),
                            enabledBorder: const OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(4.0),
                              ),
                              borderSide: BorderSide(color: kBorderColorTextField, width: 1),
                            ),
                            errorBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.red)),
                            focusedBorder: const OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(4.0)),
                              borderSide: BorderSide(color: kBorderColorTextField, width: 2),
                            ),
                          ),
                          textFieldType: TextFieldType.EMAIL,
                        ),
                        const SizedBox(height: 20.0),

                        ///__________Title_________________________________________________________
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
                            errorBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.red)),
                            enabledBorder: const OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(4.0),
                              ),
                              borderSide: BorderSide(color: kBorderColorTextField, width: 1),
                            ),
                            focusedBorder: const OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(4.0)),
                              borderSide: BorderSide(color: kBorderColorTextField, width: 2),
                            ),
                          ),
                          textFieldType: TextFieldType.EMAIL,
                        ),
                        const SizedBox(height: 20.0),

                        TextButton(
                          onPressed: () async {
                            try {
                              EasyLoading.show(status: 'Loading....');
                              await FirebaseAuth.instance.sendPasswordResetEmail(
                                email: widget.userRoleModel.email,
                              );

                              EasyLoading.showSuccess('An Email has been sent\nCheck your inbox');
                              setState(() {
                                isMailSent = true;
                              });
                            } catch (e) {
                              EasyLoading.showError(e.toString());
                            }
                          },
                          child: const Text('Forget password? '),
                        ).visible(!isMailSent),
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
              buttontext: 'Update',
              buttonDecoration: kButtonDecoration.copyWith(color: Constants.kMainColor),
              onPressed: (() async {
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
                  try {
                    EasyLoading.show(status: 'Loading...', dismissOnTap: false);
                    DatabaseReference dataRef = FirebaseDatabase.instance.ref("$constUserId/User Role/$userRoleKey");
                    DatabaseReference adminDataRef = FirebaseDatabase.instance.ref("Admin Panel/User Role/$adminRoleKey");
                    await dataRef.update({
                      'userTitle': titleController.text,
                      'salePermission': salePermission,
                      'partiesPermission': partiesPermission,
                      'purchasePermission': purchasePermission,
                      'productPermission': productPermission,
                      'profileEditPermission': profileEditPermission,
                      'addExpensePermission': addExpensePermission,
                      'lossProfitPermission': lossProfitPermission,
                      'dueListPermission': dueListPermission,
                      'stockPermission': stockPermission,
                      'reportsPermission': reportsPermission,
                      'salesListPermission': salesListPermission,
                      'purchaseListPermission': purchaseListPermission,
                    });
                    await adminDataRef.update({
                      'userTitle': titleController.text,
                      'salePermission': salePermission,
                      'partiesPermission': partiesPermission,
                      'purchasePermission': purchasePermission,
                      'productPermission': productPermission,
                      'profileEditPermission': profileEditPermission,
                      'addExpensePermission': addExpensePermission,
                      'lossProfitPermission': lossProfitPermission,
                      'dueListPermission': dueListPermission,
                      'stockPermission': stockPermission,
                      'reportsPermission': reportsPermission,
                      'salesListPermission': salesListPermission,
                      'purchaseListPermission': purchaseListPermission,
                    });
                    ref.refresh(userRoleProvider);

                    EasyLoading.showSuccess('Successfully Updated', duration: const Duration(milliseconds: 500));
                    // ignore: use_build_context_synchronously
                    Navigator.pop(context);
                  } catch (e) {
                    EasyLoading.dismiss();
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
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

Future<void> deleteUserRole({required String email, required String password, required String adminKey, required String userKey, required BuildContext context}) async {
  EasyLoading.show(status: 'Loading...');
  try {
    final userCredential = await FirebaseAuth.instance.signInWithCredential(EmailAuthProvider.credential(email: email, password: password));
    final user = userCredential.user;
    await user?.delete();
    DatabaseReference dataRef = FirebaseDatabase.instance.ref("$constUserId/User Role/$userKey");
    DatabaseReference adminDataRef = FirebaseDatabase.instance.ref("Admin Panel/User Role/$adminKey");

    await dataRef.remove();
    await adminDataRef.remove();

    EasyLoading.dismiss();
    // ignore: use_build_context_synchronously
    await showSussesScreenAndLogOut(context: context);
  } catch (e) {
    EasyLoading.dismiss();
    EasyLoading.showError(e.toString());
  }
}

Future showSussesScreenAndLogOut({required BuildContext context}) {
  return showDialog(
    context: context,
    barrierDismissible: false,
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
                      'Delete Successful',
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
                      buttonDecoration: kButtonDecoration.copyWith(color: Colors.green),
                      onPressed: (() {
                        const PhoneAuth().launch(context, isNewTask: true);
                        // const SplashScreen().launch(context, isNewTask: true);
                      }),
                      buttonTextColor: Colors.white,
                    ),
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
