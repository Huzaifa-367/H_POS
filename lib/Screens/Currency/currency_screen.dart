import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_pos/Provider/currency_provider.dart';
import 'package:mobile_pos/model/currency_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../constant.dart';
import '../../currency.dart';

class CurrencyScreen extends StatefulWidget {
  const CurrencyScreen({Key? key}) : super(key: key);

  @override
  State<CurrencyScreen> createState() => _CurrencyScreenState();
}

class _CurrencyScreenState extends State<CurrencyScreen> {
  CurrencyModel selectedCurrency =
      CurrencyModel(name: currencyName, symbol: currency);

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, __) {
      final data = ref.watch(currencyProvider);
      return Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text(
            'Currency',
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
            child: data.when(data: (currencys) {
              if (currencys.isNotEmpty) {
                return ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: currencys.length,
                  shrinkWrap: true,
                  itemBuilder: (BuildContext context, int index) {
                    return Card(
                      child: ClipRRect(
                        // Wrap the ListTile with ClipRRect
                        borderRadius: BorderRadius.circular(
                            10.0), // Set your desired BorderRadius

                        child: ListTile(
                          selected:
                              selectedCurrency.name == currencys[index].name,
                          selectedColor: Colors.white,
                          selectedTileColor:
                              Constants.kMainColor.withOpacity(.7),
                          onTap: () {
                            setState(() {
                              selectedCurrency = currencys[index];
                            });
                          },
                          title: Text(
                              '${currencys[index].name} - ${currencys[index].symbol}'),
                          trailing: const Icon(
                            (Icons.arrow_forward_ios),
                          ),
                        ),
                      ),
                    );
                  },
                );
              } else {
                return const Center(child: Text("No Currency Found"));
              }
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
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(10.0),
          child: GestureDetector(
            onTap: () async {
              final prefs = await SharedPreferences.getInstance();
              await prefs.setString('currency', selectedCurrency.symbol);
              await prefs.setString('currencyName', selectedCurrency.name);
              setState(() {
                currency = selectedCurrency.symbol;
                currencyName = selectedCurrency.name;
                Navigator.pop(context);
              });
            },
            child: Container(
              height: 50,
              decoration: BoxDecoration(
                color: Constants.kMainColor,
                borderRadius: const BorderRadius.all(Radius.circular(10)),
              ),
              child: const Center(
                child: Text(
                  'Save',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
          ),
        ),
      );
    });
  }
}
