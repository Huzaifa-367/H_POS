import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_pos/Provider/category,brans,units_provide.dart';
import 'package:mobile_pos/Screens/Products/Model/unit_model.dart';
import 'package:mobile_pos/constant.dart';
import 'package:nb_utils/nb_utils.dart';
import '../../GlobalComponents/button_global.dart';
import 'add_units_UnUsed.dart';
import 'package:mobile_pos/generated/l10n.dart' as lang;

// ignore: must_be_immutable
class UnitList extends StatefulWidget {
  const UnitList({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _UnitListState createState() => _UnitListState();
}

class _UnitListState extends State<UnitList> {
  bool showProgress = false;
  late String unitsName;

  ////
  String search = '';

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, __) {
      final allUnits = ref.watch(unitsProvider);
      final unitData = ref.watch(unitsProvider);
      return Scaffold(
        appBar: AppBar(
          title: Text(
            lang.S.of(context).units,
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
                Text(
                  lang.S.of(context).addUnit,
                  style: GoogleFonts.poppins(
                    color: Colors.black,
                    fontSize: 16.0,
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: AppTextField(
                        textFieldType: TextFieldType.NAME,
                        onChanged: (value) {
                          setState(() {
                            unitsName = value;
                          });
                        },
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          hintText: 'kg',
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          labelText: lang.S.of(context).unitName,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: ButtonGlobalWithoutIcon(
                        buttontext: lang.S.of(context).save,
                        buttonDecoration:
                            kButtonDecoration.copyWith(color: Constants.kMainColor),
                        onPressed: () async {
                          bool isAlreadyAdded = false;
                          allUnits.value?.forEach((element) {
                            if (element.unitName
                                    .toLowerCase()
                                    .removeAllWhiteSpace() ==
                                unitsName.toLowerCase().removeAllWhiteSpace()) {
                              isAlreadyAdded = true;
                            }
                          });
                          setState(() {
                            showProgress = true;
                          });
                          final DatabaseReference unitInformationRef =
                              FirebaseDatabase.instance
                                  .ref()
                                  .child(constUserId)
                                  .child('Units');
                          unitInformationRef.keepSynced(true);
                          UnitModel unitModel = UnitModel(unitsName);
                          isAlreadyAdded
                              ? EasyLoading.showError('Already Added')
                              : unitInformationRef
                                  .push()
                                  .set(unitModel.toJson());
                          setState(() {
                            showProgress = false;
                            isAlreadyAdded
                                ? null
                                : ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content:
                                            Text("Data Saved Successfully")));
                          });

                          ref.refresh(unitsProvider);

                          // ignore: use_build_context_synchronously
                          //isAlreadyAdded ? null : Navigator.pop(context);
                        },
                        buttonTextColor: Colors.white,
                      ),
                    ),
                  ],
                ),
                Divider(
                  thickness: 1.5,
                  color: Constants().kBgColor,
                ),
                const SizedBox(
                  height: 10,
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
                //         onChanged: (value) {
                //           setState(() {
                //             search = value;
                //           });
                //         },
                //       ),
                //     ),
                //     const SizedBox(
                //       width: 10.0,
                //     ),
                //     Expanded(
                //       flex: 1,
                //       child: GestureDetector(
                //         onTap: () {
                //           const AddUnits().launch(context);
                //         },
                //         child: Container(
                //           padding:
                //               const EdgeInsets.only(left: 20.0, right: 20.0),
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
                // const SizedBox(
                //   height: 10,
                // ),

                unitData.when(data: (data) {
                  return GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 20,
                        mainAxisSpacing: 10,
                        childAspectRatio: (1 / 0.35),
                      ),
                      shrinkWrap: true,
                      itemCount: data.length,
                      itemBuilder: (context, i) {
                        return data[i].unitName.contains(search)
                            ? Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 5.0),
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.pop(context, data[i].unitName);
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.only(left: 10.0),
                                    decoration: BoxDecoration(
                                      color: Constants().kBgColor,
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(8)),
                                    ),
                                    alignment: Alignment.center,
                                    child: Text(
                                      data[i].unitName,
                                      style: GoogleFonts.poppins(
                                        fontSize: 18.0,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            : Container();
                      });
                }, error: (_, __) {
                  return Container();
                }, loading: () {
                  return const CircularProgressIndicator();
                }),
                // SingleChildScrollView(
                //   child: FirebaseAnimatedList(
                //     controller: ScrollController(keepScrollOffset: false),
                //     defaultChild: Padding(
                //       padding: const EdgeInsets.only(top: 30.0, bottom: 30.0),
                //       child: Loader(
                //         color: Colors.white.withOpacity(0.2),
                //         size: 60,
                //       ),
                //     ),
                //     scrollDirection: Axis.vertical,
                //     shrinkWrap: true,
                //     physics: const NeverScrollableScrollPhysics(),
                //     query:
                //         // ignore: deprecated_member_use
                //         FirebaseDatabase.instance
                //             .reference()
                //             .child(constUserId)
                //             .child('Units'),
                //     itemBuilder: (context, snapshot, animation, index) {
                //       final json = snapshot.value as Map<dynamic, dynamic>;
                //       final title = UnitModel.fromJson(json);
                //       return title.unitName.contains(search)
                //           ? Padding(
                //               padding: const EdgeInsets.only(
                //                   left: 10.0, right: 10.0),
                //               child: Row(
                //                 children: [
                //                   Expanded(
                //                     flex: 3,
                //                     child: Text(
                //                       title.unitName,
                //                       style: GoogleFonts.poppins(
                //                         fontSize: 18.0,
                //                         color: Colors.black,
                //                       ),
                //                     ),
                //                   ),
                //                   Expanded(
                //                     flex: 1,
                //                     child: ButtonGlobalWithoutIcon(
                //                       buttontext: 'Select',
                //                       buttonDecoration: kButtonDecoration
                //                           .copyWith(color: kDarkWhite),
                //                       onPressed: () {
                //                         Navigator.pop(
                //                             context, title.unitName.toString());
                //                         // AddProduct(
                //                         //   unitsName: title.unitName,
                //                         // ).launch(context);
                //                       },
                //                       buttonTextColor: Colors.black,
                //                     ),
                //                   ),
                //                 ],
                //               ),
                //             )
                //           : Container();
                //     },
                //   ),
                // ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
