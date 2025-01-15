import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_pos/Provider/Report_Click_Provider.dart';
import 'package:mobile_pos/Screens/Authentication/forgot_password.dart';
import 'package:mobile_pos/Screens/Authentication/login_form.dart';
import 'package:mobile_pos/Screens/Authentication/register_form.dart';
import 'package:mobile_pos/Screens/Authentication/sign_in.dart';
import 'package:mobile_pos/Screens/Delivery/delivery_address_list.dart';
import 'package:mobile_pos/Screens/Expense/expense_list.dart';
import 'package:mobile_pos/Screens/Home/home.dart';
import 'package:mobile_pos/Screens/Parties_Customers/parties_list.dart';
import 'package:mobile_pos/Screens/Payment/payment_options.dart';
import 'package:mobile_pos/Screens/Products/add_product.dart';
import 'package:mobile_pos/Screens/Products/product_list.dart';
import 'package:mobile_pos/Screens/Profile/profile_screen.dart';
import 'package:mobile_pos/Screens/Purchase/purchase_contact.dart';
import 'package:mobile_pos/Screens/Report/reports.dart';
import 'package:mobile_pos/Screens/Sales/add_discount.dart';
import 'package:mobile_pos/Screens/Sales/add_promo_code.dart';
import 'package:mobile_pos/Screens/Sales/sales_contact.dart';
import 'package:mobile_pos/Screens/Sales/sales_details.dart';
import 'package:mobile_pos/Screens/Sales/sales_list.dart';
import 'package:mobile_pos/Screens/stock_list/stock_list.dart';
import 'package:mobile_pos/Screens/SplashScreen/on_board.dart';
import 'package:mobile_pos/Screens/SplashScreen/splash_screen.dart';
import 'package:mobile_pos/constant.dart';
import 'Screens/Due Calculation/due_calculation_contact_screen.dart';
import 'Screens/Loss_Profit/loss_profit_screen.dart';
import 'Screens/Products/update_product.dart';
import 'Screens/Purchase List/purchase_list_screen.dart';
import 'Screens/Purchase/choose_supplier_screen.dart';
import 'Screens/Sales List/sales_list_screen.dart';
import 'Screens/language/language_provider.dart';
import 'firebase_options.dart';
import 'generated/l10n.dart';
import 'package:provider/provider.dart' as pro;

void main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(
      name: appName,
      options: DefaultFirebaseOptions.currentPlatform,
    );
    FirebaseDatabase.instance.setPersistenceEnabled(true);

    runApp(
      pro.MultiProvider(
        providers: [
          pro.ChangeNotifierProvider(create: (context) => VisibilityProvider()),
          pro.ChangeNotifierProvider(create: (context) => ColorProvider()),
        ],
        child: const ProviderScope(
          child: MyApp(),
        ),
      ),
    );
  } catch (e) {
    print(e);
  }
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    //init();
    return pro.ChangeNotifierProvider<LanguageChangeProvider>(
      create: (context) => LanguageChangeProvider(),
      child: Builder(
        builder: (context) => MaterialApp(
          theme:
              ThemeData(useMaterial3: true, primaryColor: Constants.kMainColor),
          debugShowCheckedModeBanner: false,
          locale: pro.Provider.of<LanguageChangeProvider>(context, listen: true)
              .currentLocale,
          localizationsDelegates: const [
            S.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: S.delegate.supportedLocales,
          title: appName,
          initialRoute: '/',
          builder: EasyLoading.init(),
          routes: {
            '/': (context) => const SplashScreen(),
            // '/': (context) => const ScrollToWidgetExample(),
            '/onBoard': (context) => const OnBoard(),
            '/signIn': (context) => const SignInScreen(),
            '/loginForm': (context) => const LoginForm(),
            '/signup': (context) => const RegisterScreen(),
            '/purchaseCustomer': (context) => const PurchaseContact(),
            '/forgotPassword': (context) => const ForgotPassword(),
            // '/success': (context) =>  SuccessScreen(),
            // '/setupProfile': (context) => const ProfileSetup(),
            '/home': (context) => const Home(),
            '/profile': (context) => const ProfileScreen(),
            // ignore: missing_required_param

            '/AddProducts': (context) => AddProduct(),
            '/UpdateProducts': (context) => UpdateProduct(),

            '/Products': (context) => const ProductList(),
            '/SalesList': (context) => const SalesScreen(),
            // ignore: missing_required_param
            '/SalesDetails': (context) => SalesDetails(),
            // ignore: prefer_const_constructors
            '/salesCustomer': (context) => SalesContact(),
            '/addPromoCode': (context) => const AddPromoCode(),
            '/addDiscount': (context) => const AddDiscount(),
            '/Sales': (context) => const SalesContact(),
            '/Parties': (context) => const CustomerList(),
            '/Expense': (context) => const ExpenseList(),
            '/Stock': (context) => const StockList(),
            '/Purchase': (context) => const PurchaseContacts(),
            '/Delivery': (context) => const DeliveryAddress(),
            '/Reports': (context) => Reports(isFromHome: false),
            '/Due List': (context) => const DueCalculationContactScreen(),
            '/PaymentOptions': (context) => const PaymentOptions(),
            '/Sales List': (context) => const SalesListScreen(),
            '/Purchase List': (context) => const PurchaseListScreen(),
            '/Loss/Profit': (context) => const LossProfitScreen(),
          },
        ),
      ),
    );
  }
}
