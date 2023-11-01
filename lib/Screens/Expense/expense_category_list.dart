import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_pos/Screens/Expense/add_expense_category.dart';
import 'package:mobile_pos/model/expense_category_model.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../GlobalComponents/button_global.dart';
import '../../Provider/expense_category_proivder.dart';
import '../../constant.dart';
import 'package:mobile_pos/generated/l10n.dart' as lang;

class ExpenseCategoryList extends StatefulWidget {
  const ExpenseCategoryList({Key? key, this.mainContext}) : super(key: key);

  final BuildContext? mainContext;

  @override
  // ignore: library_private_types_in_public_api
  _ExpenseCategoryListState createState() => _ExpenseCategoryListState();
}

class _ExpenseCategoryListState extends State<ExpenseCategoryList> {
  final CurrentUserData currentUserData = CurrentUserData();
  bool showProgress = false;
  late String categoryName;

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, _) {
      final data = ref.watch(expenseCategoryProvider);
      final allCategory = ref.watch(expenseCategoryProvider);
      return Scaffold(
        appBar: AppBar(
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Image(
                image: AssetImage('images/x.png'),
              )),
          title: Text(
            lang.S.of(context).expenseCat,
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
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                lang.S.of(context).categoryName,
                style: GoogleFonts.poppins(
                  color: Colors.black,
                  fontSize: 16.0,
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: AppTextField(
                      textFieldType: TextFieldType.NAME,
                      onChanged: (value) {
                        setState(() {
                          categoryName = value;
                        });
                      },
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        hintText: 'Apple',
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        labelText: lang.S.of(context).categoryName,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: ButtonGlobalWithoutIcon(
                      buttontext: lang.S.of(context).save,
                      buttonDecoration:
                          kButtonDecoration.copyWith(color: Constants.kMainColor),
                      onPressed: () {
                        bool isAlreadyAdded = false;
                        allCategory.value?.forEach((element) {
                          if (element.categoryName
                              .toLowerCase()
                              .removeAllWhiteSpace()
                              .contains(
                                categoryName
                                    .toLowerCase()
                                    .removeAllWhiteSpace(),
                              )) {
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
                                .child('Expense Category');
                        categoryInformationRef.keepSynced(true);

                        ExpenseCategoryModel categoryModel =
                            ExpenseCategoryModel(
                          categoryName: categoryName,
                          categoryDescription: '',
                        );
                        isAlreadyAdded
                            ? EasyLoading.showError(
                                lang.S.of(context).alreadyAdded)
                            : categoryInformationRef.push().set(
                                  categoryModel.toJson(),
                                );
                        setState(
                          () {
                            showProgress = false;
                            isAlreadyAdded
                                ? null
                                : ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text("Data Saved Successfully"),
                                    ),
                                  );
                          },
                        );

                        ref.refresh(expenseCategoryProvider);
                        isAlreadyAdded ? null : Navigator.pop(context);
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
              //       ),
              //     ),
              //     const SizedBox(
              //       width: 10.0,
              //     ),
              //     Expanded(
              //       flex: 1,
              //       child: GestureDetector(
              //         onTap: () {
              //           const AddExpenseCategory().launch(context);
              //         },
              //         child: Container(
              //           padding: const EdgeInsets.only(left: 20.0, right: 20.0),
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
              data.when(data: (data) {
                return GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 20,
                    mainAxisSpacing: 10,
                    childAspectRatio: (1 / 0.35),
                  ),
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: data.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5.0),
                      child: GestureDetector(
                        onTap: () {
                          // const AddExpense().launch(context);
                          Navigator.pop(
                            context,
                            data[index].categoryName,
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.only(left: 10.0),
                          decoration: BoxDecoration(
                            color: Constants().kBgColor,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(8)),
                          ),
                          child: Center(
                            child: Text(
                              data[index].categoryName,
                              style: GoogleFonts.poppins(
                                fontSize: 18.0,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              }, error: (error, stackTrace) {
                return Text(error.toString());
              }, loading: () {
                return const CircularProgressIndicator();
              })
            ],
          ),
        ),
      );
    });
  }
}
