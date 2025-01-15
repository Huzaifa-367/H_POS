import 'dart:io';
import 'dart:typed_data';

import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter/material.dart';
import 'package:mobile_pos/GlobalComponents/button_global.dart';
import 'package:mobile_pos/constant.dart';
import 'package:mobile_pos/currency.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:pdf/pdf.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:pdf/widgets.dart' as pw;

import 'package:mobile_pos/generated/l10n.dart' as lang;

class BarCodeGenerateScreen extends StatefulWidget {
  final String? productName;
  var productSalePrice, productCode;

  BarCodeGenerateScreen(
      {super.key,
      this.productName,
      required this.productCode,
      required this.productSalePrice});

  @override
  State<BarCodeGenerateScreen> createState() => _BarCodeGenerateScreenState();
}

class _BarCodeGenerateScreenState extends State<BarCodeGenerateScreen> {
  int barCodeQuantity = 10;

  @override
  void initState() {
    super.initState();
    BarCodeqty.text = '10';
  }

  Future<void> _generateAndSavePDF() async {
    final pdf = pw.Document();
    final barcodeWidgets = List<pw.Widget>.generate(
      barCodeQuantity,
      (index) => pw.BarcodeWidget(
        textStyle: pw.TextStyle(
          fontSize: 12,
          fontWeight: pw.FontWeight.bold,
        ),
        data: widget.productCode, // Replace with your barcode data
        barcode: pw.Barcode.code128(),
        width: 150,
        height: 50,
      ),
    );

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          final rows = <pw.Widget>[];

          // Calculate the number of rows and columns for your layout
          final rowsCount = (barcodeWidgets.length / 3).ceil();
          // Number of rows on a page
          const colsCount = 3;

          const double padding = 8.0; // Define the desired padding value

          for (int rowIndex = 0; rowIndex < rowsCount; rowIndex++) {
            final cols = <pw.Widget>[];

            for (int colIndex = 0; colIndex < colsCount; colIndex++) {
              final barcodeIndex = rowIndex * colsCount + colIndex;

              if (barcodeIndex < barcodeWidgets.length) {
                cols.add(
                  pw.Container(
                    padding: const pw.EdgeInsets.all(padding), // Apply padding
                    child: pw.Column(
                      children: <pw.Widget>[
                        pw.Text(
                          widget.productName!,
                          style: pw.TextStyle(
                            fontSize: 10,
                            fontWeight: pw.FontWeight.bold,
                          ),
                        ),
                        pw.Text(
                          '$currency: ${widget.productSalePrice!}',
                          style: pw.TextStyle(
                            fontSize: 10,
                            fontWeight: pw.FontWeight.bold,
                          ),
                        ),
                        barcodeWidgets[barcodeIndex], // Your barcode widget
                      ],
                    ),
                  ),
                );
              }
            }

            rows.add(
              pw.Row(
                children: cols,
              ),
            );
          }

          return rows;
        },
      ),
    );

    // Change the PDF file path to include the product name
    const pdfPath = "/storage/emulated/0/Download/";
    final pdfFilePath = '$pdfPath/${widget.productName!}.pdf';

    final pdfFileData = await pdf.save();
    final pdfFileBytes = Uint8List.fromList(pdfFileData);

    final pdfFile2 = File(pdfFilePath);

    await pdfFile2.writeAsBytes(pdfFileBytes);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('PDF file saved at: $pdfFilePath'),
      ),
    );
  }

  TextEditingController BarCodeqty = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        //key: _scaffoldKey,
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Container(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: ButtonGlobal(
                            //iconWidget: Icons.add,
                            buttontext: lang.S.of(context).generate,
                            //iconColor: Colors.white,
                            buttonDecoration: kButtonDecoration.copyWith(
                                color: Constants.kMainColor),
                            onPressed: () async {
                              setState(() {
                                barCodeQuantity = int.parse(BarCodeqty.text);
                              });
                            },
                          ),
                        ),
                        Expanded(
                          child: ButtonGlobal(
                            //iconWidget: Icons.add,
                            buttontext: lang.S.of(context).download,
                            //iconColor: Colors.white,
                            buttonDecoration: kButtonDecoration.copyWith(
                                color: Constants.kMainColor),
                            onPressed: () async {
                              final status = await Permission.storage.request();
                              if (status.isGranted) {
                                final barcodeWidgets = List<pw.Widget>.generate(
                                  barCodeQuantity,
                                  (index) => pw.BarcodeWidget(
                                    data: widget.productCode,
                                    barcode: pw.Barcode.code128(),
                                  ),
                                );

                                await _generateAndSavePDF();
                              } else {
                                print('Permission denied');
                              }
                            },
                          ),
                        ),
                        // ElevatedButton(
                        //   onPressed: () {
                        //     BarCodeqty.text = '10';
                        //     barCodeQuantity = 10;
                        //   },
                        //   child: const Text('Reset'),
                        // ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: AppTextField(
                        controller: BarCodeqty,
                        textFieldType: TextFieldType.PHONE,
                        // onChanged: (value) {
                        //   setState(() {
                        //     phoneNumber = value;
                        //   });
                        // },
                        decoration: InputDecoration(
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          labelText: lang.S.of(context).barCodeqty,
                          hintText: lang.S.of(context).enterBarCodeQty,
                          border: const OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Constants.kMainColor,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Constants().kBgColor),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: GridView.builder(
                    itemCount: barCodeQuantity,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      mainAxisSpacing: 15,
                      crossAxisSpacing: 15,
                      childAspectRatio: 1 / 1,
                    ),
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          Text(
                            widget.productName!,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '$currency: ${widget.productSalePrice!}',
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          BarcodeWidget(
                            data: '${widget.productCode}',
                            barcode: pw.Barcode.code128(),
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
