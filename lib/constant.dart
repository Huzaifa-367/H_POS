import 'dart:convert';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:mobile_pos/Provider/Report_Click_Provider.dart';
import 'package:mobile_pos/model/user_role_model.dart';
import 'package:nb_utils/nb_utils.dart';

// const Constants.kMainColor = Color(0xFF3F8CFF);
// const Constants.kMainColor = Color(0xFF007AD0);

class ColorProvider with ChangeNotifier {
  Color _selectedColor = const Color.fromARGB(255, 58, 209, 161);

  Color get selectedColor => _selectedColor;

  void setSelectedColor(Color colorName) async {
    _selectedColor = colorName;
// Update Constants.kMainColor in the Constants class
    Constants.kMainColor = _selectedColor;
    notifyListeners();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('selectedColor', _selectedColor.toString());
    print("Saved Color Prefrences:  ${_selectedColor.toString()}");
  }
}

Color? selectedColor;
Color newColor = Colors.lightGreen;

class Constants {
  static final ColorProvider colorProvider = ColorProvider();
  static Color kMainColor = colorProvider.selectedColor;
  Color kBgColor = kMainColor.withOpacity(0.1);
}

double totalExpense = 0;
double totalProfit = 0;
//var selectedcolor = 'Purple';
//Color? Constants.kMainColor = ColorProvider().selectedColor;
//Color? Constants.kMainColor = const Color.fromARGB(255, 88, 233, 187);

const kGreyTextColor = Color(0xFF828282);
const kBorderColorTextField = Color(0xFFC2C2C2);
const kDarkWhite = Color(0xFFF1F7F7);
const kPremiumPlanColor = Color(0xFF8752EE);
const kPremiumPlanColor2 = Color(0xFFFF5F00);
const kTitleColor = Color(0xFF000000);

bool connected = false;
bool isPrintEnable = false;
List<String> paymentsTypeList = ['Cash', 'Card', 'Check', 'Mobile Pay', 'Due'];
bool isExpiringInFiveDays = false;
bool isExpiringInOneDays = false;
const String appVersion = '5.2';
const String appName = 'H POS';
String paypalClientId = '';
String paypalClientSecret = '';
const bool sandbox = true;
var loggedinUserEmail;

String purchaseCode = '528cdb9a-5d37-4292-a2b5-b792d5eca03a';

const kButtonDecoration = BoxDecoration(
  borderRadius: BorderRadius.all(
    Radius.circular(5),
  ),
);

const kInputDecoration = InputDecoration(
  hintStyle: TextStyle(color: kBorderColorTextField),
  filled: true,
  fillColor: Colors.white70,
  enabledBorder: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(8.0)),
    borderSide: BorderSide(color: kBorderColorTextField, width: 2),
  ),
  focusedBorder: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(6.0)),
    borderSide: BorderSide(color: kBorderColorTextField, width: 2),
  ),
);

OutlineInputBorder outlineInputBorder() {
  return OutlineInputBorder(
    borderRadius: BorderRadius.circular(1.0),
    borderSide: const BorderSide(color: kBorderColorTextField),
  );
}

final otpInputDecoration = InputDecoration(
  contentPadding: const EdgeInsets.symmetric(vertical: 5.0),
  border: outlineInputBorder(),
  focusedBorder: outlineInputBorder(),
  enabledBorder: outlineInputBorder(),
);

List<String> businessCategory = [
  'Fashion Store',
  'Electronics Store',
  'Computer Store',
  'Vegetable Store',
  'Sweet Store',
  'Meat Store'
];
List<String> language = ['English'];

List<String> productCategory = [
  'Fashion',
  'Electronics',
  'Computer',
  'Gadgets',
  'Watches',
  'Cloths'
];

///______________________________________________________________________________________________
String constUserId = '';
bool isSubUser = false;
String subUserTitle = '';
String subUserEmail = '';
bool isSubUserDeleted = true;
//

UserRoleModel finalUserRoleModel = UserRoleModel(
  email: '',
  userTitle: '',
  databaseId: '',
  salePermission: true,
  partiesPermission: true,
  purchasePermission: true,
  productPermission: true,
  profileEditPermission: true,
  addExpensePermission: true,
  lossProfitPermission: true,
  dueListPermission: true,
  stockPermission: true,
  reportsPermission: true,
  salesListPermission: true,
  purchaseListPermission: true,
);

class CurrentUserData {
  void getUserData() async {
    final prefs = await SharedPreferences.getInstance();
    constUserId = prefs.getString('userId') ?? '';
    isSubUser = prefs.getBool('isSubUser') ?? false;
    subUserEmail = prefs.getString('subUserEmail') ?? '';
    await updateData();
  }

  Future<void> updateData() async {
    // bool subUserEmailMatch = false;
    final prefs = await SharedPreferences.getInstance();
    final ref = FirebaseDatabase.instance.ref(constUserId).child('User Role');
    ref.keepSynced(true);
    ref.orderByKey().get().then((value) async {
      for (var element in value.children) {
        var data =
            UserRoleModel.fromJson(jsonDecode(jsonEncode(element.value)));
        if (data.email == subUserEmail) {
          isSubUserDeleted = false;
          finalUserRoleModel = data;
          await prefs.setString('userTitle', data.userTitle);
          subUserTitle = prefs.getString('userTitle') ?? '';
        }
      }
    });
  }

  Future<bool> isSubUserEmailNotFound() async {
    bool isMailMatch = true;
    final ref = FirebaseDatabase.instance.ref(constUserId).child('User Role');

    await ref.orderByKey().get().then((value) async {
      for (var element in value.children) {
        var data =
            UserRoleModel.fromJson(jsonDecode(jsonEncode(element.value)));
        if (data.email == subUserEmail) {
          isMailMatch = false;
          return;
        }
      }
    });
    return isMailMatch;
  }

  void putUserData(
      {required String userId,
      required bool isSubUser,
      required String title,
      required String email}) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('userId', userId);
    await prefs.setString('subUserEmail', email);
    await prefs.setString('userTitle', title);
    await prefs.setBool('isSubUser', isSubUser);
    getUserData();
  }
}

bool newSelect = false;
