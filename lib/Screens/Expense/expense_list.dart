import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:mobile_pos/GlobalComponents/button_global.dart';
import 'package:mobile_pos/Provider/all_expanse_provider.dart';
import 'package:mobile_pos/Screens/Expense/add_erxpense.dart';
import 'package:mobile_pos/model/expense_model.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../constant.dart';
import '../../currency.dart';
import 'package:mobile_pos/generated/l10n.dart' as lang;

class ExpenseList extends StatefulWidget {
  const ExpenseList({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _ExpenseListState createState() => _ExpenseListState();
}

class _ExpenseListState extends State<ExpenseList> {
  final dateController = TextEditingController();
  TextEditingController fromDateTextEditingController =
      TextEditingController(text: DateFormat.yMMMd().format(DateTime(2021)));
  TextEditingController toDateTextEditingController =
      TextEditingController(text: DateFormat.yMMMd().format(DateTime.now()));
  DateTime fromDate = DateTime(2021);
  DateTime toDate = DateTime.now();

  @override
  void dispose() {
    dateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    totalExpense = 0;
    return Consumer(builder: (context, ref, __) {
      final expenseData = ref.watch(expenseProvider);

      return Scaffold(
        appBar: AppBar(
          title: Text(
            lang.S.of(context).expenseReport,
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
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                      right: 10.0, left: 10.0, top: 10, bottom: 10),
                  child: Row(
                    children: [
                      Expanded(
                        child: AppTextField(
                          textFieldType: TextFieldType.NAME,
                          readOnly: true,
                          controller: fromDateTextEditingController,
                          decoration: InputDecoration(
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            labelText: lang.S.of(context).fromDate,
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Constants
                                      .kMainColor), // Change the border color when focused
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Constants()
                                      .kBgColor), // Change the border color when not focused
                            ),
                            border: const OutlineInputBorder(),
                            suffixIcon: IconButton(
                              onPressed: () async {
                                final DateTime? picked = await showDatePicker(
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(2015, 8),
                                  lastDate: DateTime(2101),
                                  context: context,
                                );
                                setState(() {
                                  fromDateTextEditingController.text =
                                      DateFormat.yMMMd()
                                          .format(picked ?? DateTime.now());
                                  fromDate = picked!;
                                  totalExpense = 0;
                                });
                              },
                              icon: Icon(
                                FeatherIcons.calendar,
                                color: Constants.kMainColor,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: AppTextField(
                          textFieldType: TextFieldType.NAME,
                          readOnly: true,
                          controller: toDateTextEditingController,
                          decoration: InputDecoration(
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            labelText: lang.S.of(context).toDate,
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Constants
                                      .kMainColor), // Change the border color when focused
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Constants()
                                      .kBgColor), // Change the border color when not focused
                            ),
                            border: const OutlineInputBorder(),
                            suffixIcon: IconButton(
                              onPressed: () async {
                                final DateTime? picked = await showDatePicker(
                                  initialDate: toDate,
                                  firstDate: DateTime(2015, 8),
                                  lastDate: DateTime(2101),
                                  context: context,
                                );

                                setState(() {
                                  toDateTextEditingController.text =
                                      DateFormat.yMMMd()
                                          .format(picked ?? DateTime.now());
                                  picked!.isToday
                                      ? toDate = DateTime.now()
                                      : toDate = picked;
                                  totalExpense = 0;
                                });
                              },
                              icon: Icon(
                                FeatherIcons.calendar,
                                color: Constants.kMainColor,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                ///__________expense_data_table____________________________________________
                Container(
                  width: context.width(),
                  height: 50,
                  padding: const EdgeInsets.all(10),
                  decoration: const BoxDecoration(color: kDarkWhite),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: 130,
                        child: Text(
                          lang.S.of(context).expenseFor,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 100,
                        child: Text(
                          lang.S.of(context).date,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Container(
                        alignment: Alignment.centerRight,
                        width: 70,
                        child: Text(
                          lang.S.of(context).amount,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                    ],
                  ),
                ),

                expenseData.when(data: (mainData) {
                  if (mainData.isNotEmpty) {
                    final List<ExpenseModel> data = mainData.reversed.toList();
                    totalExpense = 0;
                    for (var element in data) {
                      if ((fromDate.isBefore(
                                  DateTime.parse(element.expenseDate)) ||
                              DateTime.parse(element.expenseDate)
                                  .isAtSameMomentAs(fromDate)) &&
                          (toDate.isAfter(
                                  DateTime.parse(element.expenseDate)) ||
                              DateTime.parse(element.expenseDate)
                                  .isAtSameMomentAs(toDate))) {
                        totalExpense += element.amount.toDouble();
                      }
                    }
                    return SizedBox(
                      width: context.width(),
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: data.length,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (BuildContext context, int index) {
                          return (fromDate.isBefore(DateTime.parse(
                                          data[index].expenseDate)) ||
                                      DateTime.parse(data[index].expenseDate)
                                          .isAtSameMomentAs(fromDate)) &&
                                  (toDate.isAfter(DateTime.parse(
                                          data[index].expenseDate)) ||
                                      DateTime.parse(data[index].expenseDate)
                                          .isAtSameMomentAs(toDate))
                              ? Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          SizedBox(
                                            width: 130,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  data[index].expanseFor,
                                                  maxLines: 2,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: const TextStyle(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                const SizedBox(height: 5),
                                                Text(
                                                  data[index].category == ''
                                                      ? 'Not Provided'
                                                      : data[index].category,
                                                  maxLines: 2,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: const TextStyle(
                                                    color: kPremiumPlanColor2,
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                            width: 100,
                                            child: Text(
                                              DateFormat.yMMMd().format(
                                                  DateTime.parse(
                                                      data[index].expenseDate)),
                                              style: const TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ),
                                          Container(
                                            alignment: Alignment.centerRight,
                                            width: 70,
                                            child: Text(data[index].amount),
                                          )
                                        ],
                                      ),
                                    ),
                                    Container(
                                      height: 1,
                                      color: Colors.black12,
                                    )
                                  ],
                                )
                              : Container();
                        },
                      ),
                    );
                  } else {
                    return Padding(
                      padding: const EdgeInsets.all(20),
                      child: Center(
                        child: Text(lang.S.of(context).noData),
                      ),
                    );
                  }
                }, error: (Object error, StackTrace? stackTrace) {
                  return Text(error.toString());
                }, loading: () {
                  return Center(
                      child: CircularProgressIndicator(
                    color: Constants.kMainColor,
                  ));
                }),
              ],
            ),
          ),
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ///_________total______________________________________________
              Container(
                height: 50,
                padding: const EdgeInsets.all(10),
                decoration: const BoxDecoration(color: kDarkWhite),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      lang.S.of(context).totalExpense,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '$currency: $totalExpense',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  ],
                ),
              ),

              ///________button________________________________________________
              ButtonGlobalWithoutIcon(
                buttontext: lang.S.of(context).addExpense,
                buttonDecoration:
                    kButtonDecoration.copyWith(color: Constants.kMainColor),
                onPressed: () {
                  const AddExpense().launch(context);
                },
                buttonTextColor: Colors.white,
              ),
            ],
          ),
        ),
      );
    });
  }
}
