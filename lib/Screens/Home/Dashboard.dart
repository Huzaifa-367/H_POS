import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:mobile_pos/Screens/Home/home_screen.dart';
import 'package:mobile_pos/Screens/Report/reports.dart';
import 'package:mobile_pos/Screens/Settings/settings_screen.dart';
import 'package:provider/provider.dart';
import 'package:restart_app/restart_app.dart';
import 'package:mobile_pos/generated/l10n.dart' as lang;
import '../../constant.dart';
import '../Sales/sales_contact.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int _selectedIndex = 0;
  bool isDeviceConnected = false;
  bool isAlertSet = false;
  bool isNoInternet = false;

  static final List<Widget> _widgetOptions = <Widget>[
    const HomeScreen(),
    const SalesContact(),
    Reports(isFromHome: false),
    const SettingScreen()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void signOutAutoLogin() async {
    CurrentUserData currentUserData = CurrentUserData();
    if (await currentUserData.isSubUserEmailNotFound() && isSubUser) {
      await FirebaseAuth.instance.signOut();
      Future.delayed(const Duration(milliseconds: 5000), () async {
        EasyLoading.showError('User is deleted');
      });
      Future.delayed(const Duration(milliseconds: 1000), () async {
        Restart.restartApp();
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isSubUser ? signOutAutoLogin() : null;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, _) {
        return Scaffold(
          body: Center(
            child: _widgetOptions.elementAt(_selectedIndex),
          ),
          bottomNavigationBar: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            elevation: 6.0,
            selectedItemColor: Constants.kMainColor,
            // ignore: prefer_const_literals_to_create_immutables
            items: [
              BottomNavigationBarItem(
                icon: const Icon(FeatherIcons.home),
                label: lang.S.of(context).home,
              ),
              BottomNavigationBarItem(
                icon: const Icon(FeatherIcons.shoppingCart),
                label: lang.S.of(context).sales,
              ),
              BottomNavigationBarItem(
                icon: const Icon(FeatherIcons.fileText),
                label: lang.S.of(context).reports,
              ),
              BottomNavigationBarItem(
                  icon: const Icon(FeatherIcons.settings),
                  label: lang.S.of(context).setting),
            ],
            currentIndex: _selectedIndex,
            onTap: _onItemTapped,
          ),
        );
      },
    );
  }
}
