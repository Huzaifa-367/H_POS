import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:mobile_pos/GlobalComponents/button_global.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../constant.dart';
import '../Home/Dashboard.dart';
import 'language_provider.dart';
import 'package:mobile_pos/generated/l10n.dart' as lang;

class SelectLanguage extends StatefulWidget {
  const SelectLanguage({super.key});

  @override
  State<SelectLanguage> createState() => _SelectLanguageState();
}

class _SelectLanguageState extends State<SelectLanguage> {
  List<String> languageList = [
    'English',
    // 'Hindi',
    'Urdu',
  ];

  String selectedLanguage = 'English';

  Future<void> saveData(String data) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('lang', data);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: ButtonGlobalWithoutIcon(
          buttontext: lang.S.of(context).save,
          buttonDecoration: kButtonDecoration.copyWith(
            color: Constants.kMainColor,
            borderRadius: BorderRadius.circular(6.0),
          ),
          onPressed: () async {
            await saveData(selectedLanguage).then(
              (value) => Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => const Dashboard())),
            );
            setState(
              () {},
            );
          },
          buttonTextColor: Colors.white),
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Icon(
            FeatherIcons.x,
            color: kTitleColor,
          ),
        ),
        centerTitle: true,
        title: Text(
          lang.S.of(context).selectLang,
          style: const TextStyle(color: kTitleColor),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            ListView.builder(
              padding:
                  const EdgeInsets.only(left: 10.0, right: 10.0, bottom: 10),
              itemCount: languageList.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (_, index) {
                return StatefulBuilder(
                  builder: (_, i) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10.0),
                      child: ListTile(
                        onTap: () {
                          setState(() {
                            selectedLanguage = languageList[index];
                            selectedLanguage == 'English'
                                ? context
                                    .read<LanguageChangeProvider>()
                                    .changeLocale("en")
                                : selectedLanguage == 'Urdu'
                                    ? context
                                        .read<LanguageChangeProvider>()
                                        .changeLocale("ur")
                                    : selectedLanguage == 'Hindi'
                                        ? context
                                            .read<LanguageChangeProvider>()
                                            .changeLocale("hi")
                                        : context
                                            .read<LanguageChangeProvider>()
                                            .changeLocale("en");
                          });
                        },
                        contentPadding:
                            const EdgeInsets.only(left: 10, right: 10.0),
                        horizontalTitleGap: 10,
                        title: Text(languageList[index]),
                        trailing: Icon(
                          selectedLanguage == languageList[index]
                              ? Icons.radio_button_checked_outlined
                              : Icons.circle_outlined,
                          color: selectedLanguage == languageList[index]
                              ? Constants.kMainColor
                              : Constants().kBgColor,
                        ),
                      ),
                    );
                  },
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
