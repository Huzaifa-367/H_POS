// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Add User Role`
  String get addUserRole {
    return Intl.message(
      'Add User Role',
      name: 'addUserRole',
      desc: '',
      args: [],
    );
  }

  /// `No User Role Found`
  String get noRoleFound {
    return Intl.message(
      'No User Role Found',
      name: 'noRoleFound',
      desc: '',
      args: [],
    );
  }

  /// `Your Package Will Expire in 5 Day`
  String get yourPackageExpiredInDays {
    return Intl.message(
      'Your Package Will Expire in 5 Day',
      name: 'yourPackageExpiredInDays',
      desc: '',
      args: [],
    );
  }

  /// `Your Package Will Expire Today\n\nPlease Purchase again`
  String get yourPackageExpiredToday {
    return Intl.message(
      'Your Package Will Expire Today\n\nPlease Purchase again',
      name: 'yourPackageExpiredToday',
      desc: '',
      args: [],
    );
  }

  /// `Contact Us`
  String get contactUs {
    return Intl.message(
      'Contact Us',
      name: 'contactUs',
      desc: '',
      args: [],
    );
  }

  /// `Write your message here`
  String get writeYourMessageHere {
    return Intl.message(
      'Write your message here',
      name: 'writeYourMessageHere',
      desc: '',
      args: [],
    );
  }

  /// `Send Message`
  String get sendMessage {
    return Intl.message(
      'Send Message',
      name: 'sendMessage',
      desc: '',
      args: [],
    );
  }

  /// `Send your Email`
  String get sendYourEmail {
    return Intl.message(
      'Send your Email',
      name: 'sendYourEmail',
      desc: '',
      args: [],
    );
  }

  /// `Back To Home`
  String get backToHome {
    return Intl.message(
      'Back To Home',
      name: 'backToHome',
      desc: '',
      args: [],
    );
  }

  /// `Promo Code`
  String get promoCode {
    return Intl.message(
      'Promo Code',
      name: 'promoCode',
      desc: '',
      args: [],
    );
  }

  /// `Submit`
  String get submit {
    return Intl.message(
      'Submit',
      name: 'submit',
      desc: '',
      args: [],
    );
  }

  /// `See all promo code`
  String get seeAllPromoCode {
    return Intl.message(
      'See all promo code',
      name: 'seeAllPromoCode',
      desc: '',
      args: [],
    );
  }

  /// `Categories`
  String get categories {
    return Intl.message(
      'Categories',
      name: 'categories',
      desc: '',
      args: [],
    );
  }

  /// `Enter your phone number`
  String get enterYourPhoneNumber {
    return Intl.message(
      'Enter your phone number',
      name: 'enterYourPhoneNumber',
      desc: '',
      args: [],
    );
  }

  /// `Enter Barcode Quantity`
  String get enterBarCodeQty {
    return Intl.message(
      'Enter Barcode Quantity',
      name: 'enterBarCodeQty',
      desc: '',
      args: [],
    );
  }

  /// `Enter Full Address`
  String get enterFullAddress {
    return Intl.message(
      'Enter Full Address',
      name: 'enterFullAddress',
      desc: '',
      args: [],
    );
  }

  /// `Enter your email address`
  String get enterYourEmailAddress {
    return Intl.message(
      'Enter your email address',
      name: 'enterYourEmailAddress',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a password`
  String get pleaseEnterAPassword {
    return Intl.message(
      'Please enter a password',
      name: 'pleaseEnterAPassword',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a confirm password`
  String get pleaseEnterAConfirmPassword {
    return Intl.message(
      'Please enter a confirm password',
      name: 'pleaseEnterAConfirmPassword',
      desc: '',
      args: [],
    );
  }

  /// `Enter your name`
  String get enterYourName {
    return Intl.message(
      'Enter your name',
      name: 'enterYourName',
      desc: '',
      args: [],
    );
  }

  /// `Add New Address`
  String get addNewAddress {
    return Intl.message(
      'Add New Address',
      name: 'addNewAddress',
      desc: '',
      args: [],
    );
  }

  /// `First Name`
  String get firstName {
    return Intl.message(
      'First Name',
      name: 'firstName',
      desc: '',
      args: [],
    );
  }

  /// `Last Name`
  String get lastName {
    return Intl.message(
      'Last Name',
      name: 'lastName',
      desc: '',
      args: [],
    );
  }

  /// `Country`
  String get country {
    return Intl.message(
      'Country',
      name: 'country',
      desc: '',
      args: [],
    );
  }

  /// `Bangladesh`
  String get bangladesh {
    return Intl.message(
      'Bangladesh',
      name: 'bangladesh',
      desc: '',
      args: [],
    );
  }

  /// `Apply`
  String get apply {
    return Intl.message(
      'Apply',
      name: 'apply',
      desc: '',
      args: [],
    );
  }

  /// `Delivery Address`
  String get deliveryAddress {
    return Intl.message(
      'Delivery Address',
      name: 'deliveryAddress',
      desc: '',
      args: [],
    );
  }

  /// `No data available`
  String get noDataAvailabe {
    return Intl.message(
      'No data available',
      name: 'noDataAvailabe',
      desc: '',
      args: [],
    );
  }

  /// `Add Delivery`
  String get addDelivery {
    return Intl.message(
      'Add Delivery',
      name: 'addDelivery',
      desc: '',
      args: [],
    );
  }

  /// `Description`
  String get description {
    return Intl.message(
      'Description',
      name: 'description',
      desc: '',
      args: [],
    );
  }

  /// `Add Note`
  String get addNote {
    return Intl.message(
      'Add Note',
      name: 'addNote',
      desc: '',
      args: [],
    );
  }

  /// `Image`
  String get image {
    return Intl.message(
      'Image',
      name: 'image',
      desc: '',
      args: [],
    );
  }

  /// `Please connect the printer first`
  String get pleaseConnectThePrinterFirst {
    return Intl.message(
      'Please connect the printer first',
      name: 'pleaseConnectThePrinterFirst',
      desc: '',
      args: [],
    );
  }

  /// `Select Category`
  String get selectCategory {
    return Intl.message(
      'Select Category',
      name: 'selectCategory',
      desc: '',
      args: [],
    );
  }

  /// `Enter expense date`
  String get enterExpenseDate {
    return Intl.message(
      'Enter expense date',
      name: 'enterExpenseDate',
      desc: '',
      args: [],
    );
  }

  /// `Enter Name`
  String get enterName {
    return Intl.message(
      'Enter Name',
      name: 'enterName',
      desc: '',
      args: [],
    );
  }

  /// `Enter Amount`
  String get enterAmount {
    return Intl.message(
      'Enter Amount',
      name: 'enterAmount',
      desc: '',
      args: [],
    );
  }

  /// `Enter reference number`
  String get enterRefNumber {
    return Intl.message(
      'Enter reference number',
      name: 'enterRefNumber',
      desc: '',
      args: [],
    );
  }

  /// `Fashion`
  String get fashions {
    return Intl.message(
      'Fashion',
      name: 'fashions',
      desc: '',
      args: [],
    );
  }

  /// `Bill To`
  String get billTO {
    return Intl.message(
      'Bill To',
      name: 'billTO',
      desc: '',
      args: [],
    );
  }

  /// `Total Due`
  String get totalDue {
    return Intl.message(
      'Total Due',
      name: 'totalDue',
      desc: '',
      args: [],
    );
  }

  /// `Payment Amounts`
  String get paymentsAmount {
    return Intl.message(
      'Payment Amounts',
      name: 'paymentsAmount',
      desc: '',
      args: [],
    );
  }

  /// `Remaining Due`
  String get remainingDue {
    return Intl.message(
      'Remaining Due',
      name: 'remainingDue',
      desc: '',
      args: [],
    );
  }

  /// `Thank you for your due payment`
  String get thankYouForYourDuePayment {
    return Intl.message(
      'Thank you for your due payment',
      name: 'thankYouForYourDuePayment',
      desc: '',
      args: [],
    );
  }

  /// `Print`
  String get print {
    return Intl.message(
      'Print',
      name: 'print',
      desc: '',
      args: [],
    );
  }

  /// `Unit Price`
  String get unitPirce {
    return Intl.message(
      'Unit Price',
      name: 'unitPirce',
      desc: '',
      args: [],
    );
  }

  /// `Total Price`
  String get totalPrice {
    return Intl.message(
      'Total Price',
      name: 'totalPrice',
      desc: '',
      args: [],
    );
  }

  /// `Total Vat`
  String get totalVat {
    return Intl.message(
      'Total Vat',
      name: 'totalVat',
      desc: '',
      args: [],
    );
  }

  /// `Delivery Charge`
  String get deliveryCharge {
    return Intl.message(
      'Delivery Charge',
      name: 'deliveryCharge',
      desc: '',
      args: [],
    );
  }

  /// `Total Payable`
  String get totalPayable {
    return Intl.message(
      'Total Payable',
      name: 'totalPayable',
      desc: '',
      args: [],
    );
  }

  /// `Thak you for your purchase`
  String get thakYouForYourPurchase {
    return Intl.message(
      'Thak you for your purchase',
      name: 'thakYouForYourPurchase',
      desc: '',
      args: [],
    );
  }

  /// `Please connect your bluetooth printer`
  String get pleaseConnectYourBlutohPrinter {
    return Intl.message(
      'Please connect your bluetooth printer',
      name: 'pleaseConnectYourBlutohPrinter',
      desc: '',
      args: [],
    );
  }

  /// `Edit Socail Media`
  String get editSocailMedia {
    return Intl.message(
      'Edit Socail Media',
      name: 'editSocailMedia',
      desc: '',
      args: [],
    );
  }

  /// `Social Marketing`
  String get socialMarketing {
    return Intl.message(
      'Social Marketing',
      name: 'socialMarketing',
      desc: '',
      args: [],
    );
  }

  /// `Share`
  String get share {
    return Intl.message(
      'Share',
      name: 'share',
      desc: '',
      args: [],
    );
  }

  /// `Notification`
  String get notification {
    return Intl.message(
      'Notification',
      name: 'notification',
      desc: '',
      args: [],
    );
  }

  /// `Purchase Alarm`
  String get purchaseAlarm {
    return Intl.message(
      'Purchase Alarm',
      name: 'purchaseAlarm',
      desc: '',
      args: [],
    );
  }

  /// `Purchase Confirmed`
  String get purchaseConfirmed {
    return Intl.message(
      'Purchase Confirmed',
      name: 'purchaseConfirmed',
      desc: '',
      args: [],
    );
  }

  /// `Payment Complete`
  String get paymentComplete {
    return Intl.message(
      'Payment Complete',
      name: 'paymentComplete',
      desc: '',
      args: [],
    );
  }

  /// `Return`
  String get retur {
    return Intl.message(
      'Return',
      name: 'retur',
      desc: '',
      args: [],
    );
  }

  /// `Send Sms`
  String get sendSms {
    return Intl.message(
      'Send Sms',
      name: 'sendSms',
      desc: '',
      args: [],
    );
  }

  /// `Received the Pin`
  String get recivethePin {
    return Intl.message(
      'Received the Pin',
      name: 'recivethePin',
      desc: '',
      args: [],
    );
  }

  /// `Start New Sale`
  String get startNewSale {
    return Intl.message(
      'Start New Sale',
      name: 'startNewSale',
      desc: '',
      args: [],
    );
  }

  /// `Payment`
  String get payment {
    return Intl.message(
      'Payment',
      name: 'payment',
      desc: '',
      args: [],
    );
  }

  /// `Master Card`
  String get masterCard {
    return Intl.message(
      'Master Card',
      name: 'masterCard',
      desc: '',
      args: [],
    );
  }

  /// `Instruction`
  String get instrucation {
    return Intl.message(
      'Instruction',
      name: 'instrucation',
      desc: '',
      args: [],
    );
  }

  /// `Cash`
  String get cash {
    return Intl.message(
      'Cash',
      name: 'cash',
      desc: '',
      args: [],
    );
  }

  /// `Invoice viewer`
  String get invoiceViewr {
    return Intl.message(
      'Invoice viewer',
      name: 'invoiceViewr',
      desc: '',
      args: [],
    );
  }

  /// `Size`
  String get size {
    return Intl.message(
      'Size',
      name: 'size',
      desc: '',
      args: [],
    );
  }

  /// `Color`
  String get color {
    return Intl.message(
      'Color',
      name: 'color',
      desc: '',
      args: [],
    );
  }

  /// `Weight`
  String get weight {
    return Intl.message(
      'Weight',
      name: 'weight',
      desc: '',
      args: [],
    );
  }

  /// `Capacity`
  String get capacity {
    return Intl.message(
      'Capacity',
      name: 'capacity',
      desc: '',
      args: [],
    );
  }

  /// `Type`
  String get type {
    return Intl.message(
      'Type',
      name: 'type',
      desc: '',
      args: [],
    );
  }

  /// `You want to delete this product?`
  String get youWantTodeletetheProduct {
    return Intl.message(
      'You want to delete this product?',
      name: 'youWantTodeletetheProduct',
      desc: '',
      args: [],
    );
  }

  /// `Delete`
  String get delete {
    return Intl.message(
      'Delete',
      name: 'delete',
      desc: '',
      args: [],
    );
  }

  /// `Contact Details`
  String get contactDetials {
    return Intl.message(
      'Contact Details',
      name: 'contactDetials',
      desc: '',
      args: [],
    );
  }

  /// `Clarence`
  String get clarence {
    return Intl.message(
      'Clarence',
      name: 'clarence',
      desc: '',
      args: [],
    );
  }

  /// `Call`
  String get call {
    return Intl.message(
      'Call',
      name: 'call',
      desc: '',
      args: [],
    );
  }

  /// `Message`
  String get messege {
    return Intl.message(
      'Message',
      name: 'messege',
      desc: '',
      args: [],
    );
  }

  /// `Daily Transaction`
  String get dailyTransaction {
    return Intl.message(
      'Daily Transaction',
      name: 'dailyTransaction',
      desc: '',
      args: [],
    );
  }

  /// `Promo`
  String get promo {
    return Intl.message(
      'Promo',
      name: 'promo',
      desc: '',
      args: [],
    );
  }

  /// `Send`
  String get send {
    return Intl.message(
      'Send',
      name: 'send',
      desc: '',
      args: [],
    );
  }

  /// `Easy to use mobile pos`
  String get easyToUseThePos {
    return Intl.message(
      'Easy to use mobile pos',
      name: 'easyToUseThePos',
      desc: '',
      args: [],
    );
  }

  /// `Sales Pro app is free, easy to use. In fact, it's one of the best  POS systems around the world.`
  String get easytheusedesciption {
    return Intl.message(
      'Sales Pro app is free, easy to use. In fact, it\'s one of the best  POS systems around the world.',
      name: 'easytheusedesciption',
      desc: '',
      args: [],
    );
  }

  /// `Chose Your Features`
  String get choseYourFeature {
    return Intl.message(
      'Chose Your Features',
      name: 'choseYourFeature',
      desc: '',
      args: [],
    );
  }

  /// `Features are the important part which makes Sales Pro different from traditional solutions.`
  String get choseyourfeatureDesciption {
    return Intl.message(
      'Features are the important part which makes Sales Pro different from traditional solutions.',
      name: 'choseyourfeatureDesciption',
      desc: '',
      args: [],
    );
  }

  /// `All business solutions`
  String get allBusinessSolutions {
    return Intl.message(
      'All business solutions',
      name: 'allBusinessSolutions',
      desc: '',
      args: [],
    );
  }

  /// `Sales Pro is a complete business solution with stock, account, sales, expense & loss/profit.`
  String get allBusinessolutionDescrip {
    return Intl.message(
      'Sales Pro is a complete business solution with stock, account, sales, expense & loss/profit.',
      name: 'allBusinessolutionDescrip',
      desc: '',
      args: [],
    );
  }

  /// `Skip`
  String get skip {
    return Intl.message(
      'Skip',
      name: 'skip',
      desc: '',
      args: [],
    );
  }

  /// `Next`
  String get next {
    return Intl.message(
      'Next',
      name: 'next',
      desc: '',
      args: [],
    );
  }

  /// `A new update available\nPlease update your app`
  String get anewUpdateAvailable {
    return Intl.message(
      'A new update available\nPlease update your app',
      name: 'anewUpdateAvailable',
      desc: '',
      args: [],
    );
  }

  /// `Skip the update`
  String get skipTheUpdate {
    return Intl.message(
      'Skip the update',
      name: 'skipTheUpdate',
      desc: '',
      args: [],
    );
  }

  /// `Remember me later`
  String get rememberMeLater {
    return Intl.message(
      'Remember me later',
      name: 'rememberMeLater',
      desc: '',
      args: [],
    );
  }

  /// `Developed By Huzaifa`
  String get developedBy {
    return Intl.message(
      'Developed By Huzaifa',
      name: 'developedByHuzaifa',
      desc: '',
      args: [],
    );
  }

  /// `Loss/Profit`
  String get lossOrProfit {
    return Intl.message(
      'Loss/Profit',
      name: 'lossOrProfit',
      desc: '',
      args: [],
    );
  }

  /// `Expense`
  String get expense {
    return Intl.message(
      'Daily Expenses',
      name: 'dailyexpense',
      desc: '',
      args: [],
    );
  }

  /// `Expense`
  String get expenses {
    return Intl.message(
      'Expenses',
      name: 'expense',
      desc: '',
      args: [],
    );
  }

  /// `Parties`
  String get parties {
    return Intl.message(
      'Source',
      name: 'source',
      desc: '',
      args: [],
    );
  }

  /// `Home`
  String get home {
    return Intl.message(
      'Home',
      name: 'home',
      desc: '',
      args: [],
    );
  }

  /// `Sales`
  String get sales {
    return Intl.message(
      'Sales',
      name: 'sales',
      desc: '',
      args: [],
    );
  }

  /// `Setting`
  String get setting {
    return Intl.message(
      'Setting',
      name: 'setting',
      desc: '',
      args: [],
    );
  }

  /// `Purchase Now`
  String get purchaseNow {
    return Intl.message(
      'Purchase Now',
      name: 'purchaseNow',
      desc: '',
      args: [],
    );
  }

  /// `Payment Methods`
  String get paymentMethods {
    return Intl.message(
      'Payment Methods',
      name: 'paymentMethods',
      desc: '',
      args: [],
    );
  }

  /// `Save`
  String get save {
    return Intl.message(
      'Save',
      name: 'save',
      desc: '',
      args: [],
    );
  }

  /// `Update`
  String get update {
    return Intl.message(
      'Update',
      name: 'update',
      desc: '',
      args: [],
    );
  }

  /// `Continue`
  String get continueButton {
    return Intl.message(
      'Continue',
      name: 'continueButton',
      desc: '',
      args: [],
    );
  }

  /// `Name`
  String get name {
    return Intl.message(
      'Name',
      name: 'name',
      desc: '',
      args: [],
    );
  }

  /// `Phone Number`
  String get phone {
    return Intl.message(
      'Phone Number',
      name: 'phone',
      desc: '',
      args: [],
    );
  }

  /// `BarCodeqty`
  String get barCodeqty {
    return Intl.message(
      'Barcode Quantity',
      name: 'BarCodeqty',
      desc: '',
      args: [],
    );
  }

  /// `Email Address`
  String get email {
    return Intl.message(
      'Email Address',
      name: 'email',
      desc: '',
      args: [],
    );
  }

  /// `Address`
  String get address {
    return Intl.message(
      'Address',
      name: 'address',
      desc: '',
      args: [],
    );
  }

  /// `Previous Due`
  String get previousDue {
    return Intl.message(
      'Previous Due',
      name: 'previousDue',
      desc: '',
      args: [],
    );
  }

  /// `Select Your Language`
  String get selectLang {
    return Intl.message(
      'Select Your Language',
      name: 'selectLang',
      desc: '',
      args: [],
    );
  }

  /// `Add Contact`
  String get addContact {
    return Intl.message(
      'Add Contact',
      name: 'addContact',
      desc: '',
      args: [],
    );
  }

  /// `More Info`
  String get moreInfo {
    return Intl.message(
      'More Info',
      name: 'moreInfo',
      desc: '',
      args: [],
    );
  }

  /// `Retailer`
  String get retailer {
    return Intl.message(
      'Retailer',
      name: 'retailer',
      desc: '',
      args: [],
    );
  }

  /// `Dealer`
  String get dealer {
    return Intl.message(
      'Dealer',
      name: 'dealer',
      desc: '',
      args: [],
    );
  }

  /// `Wholesaler`
  String get wholesaler {
    return Intl.message(
      'Wholesaler',
      name: 'wholesaler',
      desc: '',
      args: [],
    );
  }

  /// `Supplier`
  String get supplier {
    return Intl.message(
      'Supplier',
      name: 'supplier',
      desc: '',
      args: [],
    );
  }

  /// `Customer Details`
  String get CustomerDetails {
    return Intl.message(
      'Customer Details',
      name: 'CustomerDetails',
      desc: '',
      args: [],
    );
  }

  /// `Recent Transactions`
  String get recentTransaction {
    return Intl.message(
      'Recent Transactions',
      name: 'recentTransaction',
      desc: '',
      args: [],
    );
  }

  /// `Total Products`
  String get totalProduct {
    return Intl.message(
      'Total Products',
      name: 'totalProduct',
      desc: '',
      args: [],
    );
  }

  /// `Total`
  String get total {
    return Intl.message(
      'Total',
      name: 'total',
      desc: '',
      args: [],
    );
  }

  /// `Paid`
  String get paid {
    return Intl.message(
      'Paid',
      name: 'paid',
      desc: '',
      args: [],
    );
  }

  /// `UnPaid`
  String get unPaid {
    return Intl.message(
      'UnPaid',
      name: 'unPaid',
      desc: '',
      args: [],
    );
  }

  /// `Due`
  String get due {
    return Intl.message(
      'Due',
      name: 'due',
      desc: '',
      args: [],
    );
  }

  /// `Click to connect`
  String get connect {
    return Intl.message(
      'Click to connect',
      name: 'connect',
      desc: '',
      args: [],
    );
  }

  /// `Try Again`
  String get tryAgain {
    return Intl.message(
      'Try Again',
      name: 'tryAgain',
      desc: '',
      args: [],
    );
  }

  /// `Loading`
  String get loading {
    return Intl.message(
      'Loading',
      name: 'loading',
      desc: '',
      args: [],
    );
  }

  /// `View All`
  String get viewAll {
    return Intl.message(
      'View All',
      name: 'viewAll',
      desc: '',
      args: [],
    );
  }

  /// `Parties List`
  String get partyList {
    return Intl.message(
      'Parties List',
      name: 'partyList',
      desc: '',
      args: [],
    );
  }

  /// `Please Add A Customer`
  String get addCustomer {
    return Intl.message(
      'Add A Customer',
      name: 'addCustomer',
      desc: '',
      args: [],
    );
  }

  /// `Please Add A Customer`
  String get download {
    return Intl.message(
      'Download',
      name: 'download',
      desc: '',
      args: [],
    );
  }

  /// `Please Add A Customer`
  String get generate {
    return Intl.message(
      'Generate',
      name: 'generate',
      desc: '',
      args: [],
    );
  }
  /// `Update Contact`
  String get updateContact {
    return Intl.message(
      'Update Contact',
      name: 'updateContact',
      desc: '',
      args: [],
    );
  }

  /// `Due List`
  String get dueList {
    return Intl.message(
      'Due Records',
      name: 'dueRecords',
      desc: '',
      args: [],
    );
  }

  /// `Collect Due`
  String get collectDue {
    return Intl.message(
      'Collect Due',
      name: 'collectDue',
      desc: '',
      args: [],
    );
  }

  /// `Date`
  String get date {
    return Intl.message(
      'Date',
      name: 'date',
      desc: '',
      args: [],
    );
  }

  /// `Due Amount: `
  String get dueAmount {
    return Intl.message(
      'Due Amount: ',
      name: 'dueAmount',
      desc: '',
      args: [],
    );
  }

  /// `Customer Name`
  String get customerName {
    return Intl.message(
      'Customer Name',
      name: 'customerName',
      desc: '',
      args: [],
    );
  }

  /// `Total Amount`
  String get totalAmount {
    return Intl.message(
      'Total Amount',
      name: 'totalAmount',
      desc: '',
      args: [],
    );
  }

  /// `Paid Amount`
  String get paidAmount {
    return Intl.message(
      'Paid Amount',
      name: 'paidAmount',
      desc: '',
      args: [],
    );
  }

  /// `Payment Type`
  String get paymentTypes {
    return Intl.message(
      'Payment Type',
      name: 'paymentTypes',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get cancel {
    return Intl.message(
      'Cancel',
      name: 'cancel',
      desc: '',
      args: [],
    );
  }

  /// `Expense Report`
  String get expenseReport {
    return Intl.message(
      'Expense Report',
      name: 'expenseReport',
      desc: '',
      args: [],
    );
  }

  /// `From Date`
  String get fromDate {
    return Intl.message(
      'From Date',
      name: 'fromDate',
      desc: '',
      args: [],
    );
  }

  /// `To Date`
  String get toDate {
    return Intl.message(
      'To Date',
      name: 'toDate',
      desc: '',
      args: [],
    );
  }

  /// `Expense For`
  String get expenseFor {
    return Intl.message(
      'Expense For',
      name: 'expenseFor',
      desc: '',
      args: [],
    );
  }

  /// `Amount`
  String get amount {
    return Intl.message(
      'Amount',
      name: 'amount',
      desc: '',
      args: [],
    );
  }

  /// `No Data Available`
  String get noData {
    return Intl.message(
      'No Data Available',
      name: 'noData',
      desc: '',
      args: [],
    );
  }

  /// `Total Expense`
  String get totalExpense {
    return Intl.message(
      'Total Expense',
      name: 'totalExpense',
      desc: '',
      args: [],
    );
  }

  /// `Add Expense`
  String get addExpense {
    return Intl.message(
      'Add Expense',
      name: 'addExpense',
      desc: '',
      args: [],
    );
  }

  /// `Expense Date`
  String get expenseDate {
    return Intl.message(
      'Expense Date',
      name: 'expenseDate',
      desc: '',
      args: [],
    );
  }

  /// `Reference Number`
  String get referenceNo {
    return Intl.message(
      'Reference Number',
      name: 'referenceNo',
      desc: '',
      args: [],
    );
  }

  /// `Note`
  String get note {
    return Intl.message(
      'Note',
      name: 'note',
      desc: '',
      args: [],
    );
  }

  /// `Expense Categories`
  String get expenseCat {
    return Intl.message(
      'Expense Categories',
      name: 'expenseCat',
      desc: '',
      args: [],
    );
  }

  /// `Search`
  String get search {
    return Intl.message(
      'Search',
      name: 'search',
      desc: '',
      args: [],
    );
  }

  /// `Select`
  String get select {
    return Intl.message(
      'Select',
      name: 'select',
      desc: '',
      args: [],
    );
  }

  /// `Add Expense Category`
  String get addExpenseCat {
    return Intl.message(
      'Add Expense Category',
      name: 'addExpenseCat',
      desc: '',
      args: [],
    );
  }

  /// `Category name`
  String get categoryName {
    return Intl.message(
      'Category name',
      name: 'categoryName',
      desc: '',
      args: [],
    );
  }

  /// `Already Added`
  String get alreadyAdded {
    return Intl.message(
      'Already Added',
      name: 'alreadyAdded',
      desc: '',
      args: [],
    );
  }

  /// `What's New`
  String get whatNew {
    return Intl.message(
      'What\'s New',
      name: 'whatNew',
      desc: '',
      args: [],
    );
  }

  /// `Loss/Profit`
  String get lp {
    return Intl.message(
      'Loss/Profit',
      name: 'lp',
      desc: '',
      args: [],
    );
  }

  /// `Profit`
  String get profit {
    return Intl.message(
      'Profit',
      name: 'profit',
      desc: '',
      args: [],
    );
  }

  /// `Loss`
  String get loss {
    return Intl.message(
      'Loss',
      name: 'loss',
      desc: '',
      args: [],
    );
  }

  /// `Loss/Profit Details`
  String get lpDetails {
    return Intl.message(
      'Loss/Profit Details',
      name: 'lpDetails',
      desc: '',
      args: [],
    );
  }

  /// `Invoice`
  String get invoice {
    return Intl.message(
      'Invoice',
      name: 'invoice',
      desc: '',
      args: [],
    );
  }

  /// `Date:`
  String get dates {
    return Intl.message(
      'Date:',
      name: 'dates',
      desc: '',
      args: [],
    );
  }

  /// `Mobile:`
  String get mobile {
    return Intl.message(
      'Mobile:',
      name: 'mobile',
      desc: '',
      args: [],
    );
  }

  /// `Product`
  String get product {
    return Intl.message(
      'Product',
      name: 'product',
      desc: '',
      args: [],
    );
  }

  /// `Quantity`
  String get quantity {
    return Intl.message(
      'Qty',
      name: 'qty',
      desc: '',
      args: [],
    );
  }

  /// `Discount`
  String get discount {
    return Intl.message(
      'Discount',
      name: 'discount',
      desc: '',
      args: [],
    );
  }

  /// `Total Loss`
  String get totalLoss {
    return Intl.message(
      'Total Loss',
      name: 'totalLoss',
      desc: '',
      args: [],
    );
  }

  /// `Total Profit`
  String get totalProfit {
    return Intl.message(
      'Total Profit',
      name: 'totalProfit',
      desc: '',
      args: [],
    );
  }

  /// `Product List`
  String get productList {
    return Intl.message(
      'Product List',
      name: 'productList',
      desc: '',
      args: [],
    );
  }

  /// `Stock`
  String get stock {
    return Intl.message(
      'Stock',
      name: 'stock',
      desc: '',
      args: [],
    );
  }

  /// `Add New Product`
  String get addNewProduct {
    return Intl.message(
      'Add New Product',
      name: 'addNewProduct',
      desc: '',
      args: [],
    );
  }

  /// `Product name`
  String get productName {
    return Intl.message(
      'Product name',
      name: 'productName',
      desc: '',
      args: [],
    );
  }

  /// `Product Code`
  String get productCode {
    return Intl.message(
      'Product Code',
      name: 'productCode',
      desc: '',
      args: [],
    );
  }

  /// `Purchase Price`
  String get purchasePrice {
    return Intl.message(
      'Purchase Price',
      name: 'purchasePrice',
      desc: '',
      args: [],
    );
  }

  /// `MRP`
  String get mrp {
    return Intl.message(
      'MRP',
      name: 'mrp',
      desc: '',
      args: [],
    );
  }

  /// `WholeSale Price`
  String get wholeSalePrice {
    return Intl.message(
      'WholeSale Price',
      name: 'wholeSalePrice',
      desc: '',
      args: [],
    );
  }

  /// `Dealer price`
  String get dealerPrice {
    return Intl.message(
      'Dealer price',
      name: 'dealerPrice',
      desc: '',
      args: [],
    );
  }

  /// `Manufacturer`
  String get manufacturer {
    return Intl.message(
      'Manufacturer',
      name: 'manufacturer',
      desc: '',
      args: [],
    );
  }

  /// `Save and Publish`
  String get saveNPublish {
    return Intl.message(
      'Save and Publish',
      name: 'saveNPublish',
      desc: '',
      args: [],
    );
  }

  /// `Brands`
  String get brands {
    return Intl.message(
      'Brands',
      name: 'brands',
      desc: '',
      args: [],
    );
  }

  /// `Add Brand`
  String get addBrand {
    return Intl.message(
      'Add New Brand',
      name: 'addNewBrand',
      desc: '',
      args: [],
    );
  }

  /// `Brand name`
  String get brandName {
    return Intl.message(
      'Brand name',
      name: 'brandName',
      desc: '',
      args: [],
    );
  }

  /// `Add Unit`
  String get addUnit {
    return Intl.message(
      'Add New Unit',
      name: 'addNewUnit',
      desc: '',
      args: [],
    );
  }

  /// `Unit name`
  String get unitName {
    return Intl.message(
      'Unit name',
      name: 'unitName',
      desc: '',
      args: [],
    );
  }

  /// `Units`
  String get units {
    return Intl.message(
      'Units',
      name: 'units',
      desc: '',
      args: [],
    );
  }

  /// `Please Add A Product`
  String get addProduct {
    return Intl.message(
      'Please Add A Product',
      name: 'addProduct',
      desc: '',
      args: [],
    );
  }

  /// `Update Product`
  String get updateProduct {
    return Intl.message(
      'Update Product',
      name: 'updateProduct',
      desc: '',
      args: [],
    );
  }

  /// `Sale Price`
  String get salePrice {
    return Intl.message(
      'Sale Price',
      name: 'salePrice',
      desc: '',
      args: [],
    );
  }

  /// `Profile`
  String get profile {
    return Intl.message(
      'Profile',
      name: 'profile',
      desc: '',
      args: [],
    );
  }

  /// `Edit`
  String get edit {
    return Intl.message(
      'Edit',
      name: 'edit',
      desc: '',
      args: [],
    );
  }

  /// `Business Category`
  String get businessCat {
    return Intl.message(
      'Business Category',
      name: 'businessCat',
      desc: '',
      args: [],
    );
  }

  /// `Language`
  String get language {
    return Intl.message(
      'Language',
      name: 'language',
      desc: '',
      args: [],
    );
  }

  /// `Change Password`
  String get changePassword {
    return Intl.message(
      'Change Password',
      name: 'changePassword',
      desc: '',
      args: [],
    );
  }

  /// `Update Your Profile`
  String get updateProfile {
    return Intl.message(
      'Update Your Profile',
      name: 'updateProfile',
      desc: '',
      args: [],
    );
  }

  /// `Company & Business Name`
  String get businessName {
    return Intl.message(
      'Company & Business Name',
      name: 'businessName',
      desc: '',
      args: [],
    );
  }

  /// `Add Purchase`
  String get addPurchase {
    return Intl.message(
      'Add Purchase',
      name: 'addPurchase',
      desc: '',
      args: [],
    );
  }

  /// `Inv No.`
  String get inv {
    return Intl.message(
      'Inv No.',
      name: 'inv',
      desc: '',
      args: [],
    );
  }

  /// `Supplier Name`
  String get supplierName {
    return Intl.message(
      'Supplier Name',
      name: 'supplierName',
      desc: '',
      args: [],
    );
  }

  /// `Item Added`
  String get itemAdded {
    return Intl.message(
      'Item Added',
      name: 'itemAdded',
      desc: '',
      args: [],
    );
  }

  /// `Add Items`
  String get addItems {
    return Intl.message(
      'Add Items',
      name: 'addItems',
      desc: '',
      args: [],
    );
  }

  /// `Sub Total`
  String get subTotal {
    return Intl.message(
      'Sub Total',
      name: 'subTotal',
      desc: '',
      args: [],
    );
  }

  /// `Return Amount`
  String get returnAmount {
    return Intl.message(
      'Return Amount',
      name: 'returnAmount',
      desc: '',
      args: [],
    );
  }

  /// `Choose a Supplier`
  String get chooseSupplier {
    return Intl.message(
      'Choose a Supplier',
      name: 'chooseSupplier',
      desc: '',
      args: [],
    );
  }

  /// `No Supplier Available`
  String get noSupplier {
    return Intl.message(
      'No Supplier Available',
      name: 'noSupplier',
      desc: '',
      args: [],
    );
  }

  /// `Sales Details`
  String get salesDetails {
    return Intl.message(
      'Sales Details',
      name: 'salesDetails',
      desc: '',
      args: [],
    );
  }

  /// `Edit Purchase Invoice`
  String get editPurchaseInvoice {
    return Intl.message(
      'Edit Purchase Invoice',
      name: 'editPurchaseInvoice',
      desc: '',
      args: [],
    );
  }

  /// `Purchase List`
  String get purchaseList {
    return Intl.message(
      'Purchase List',
      name: 'purchaseList',
      desc: '',
      args: [],
    );
  }

  /// `Please Add A Purchase`
  String get addAPurchase {
    return Intl.message(
      'Please Add A Purchase',
      name: 'addAPurchase',
      desc: '',
      args: [],
    );
  }

  /// `Due Report`
  String get dueReport {
    return Intl.message(
      'Due Report',
      name: 'dueReport',
      desc: '',
      args: [],
    );
  }

  /// `Fully Paid`
  String get fullyPaid {
    return Intl.message(
      'Fully Paid',
      name: 'fullyPaid',
      desc: '',
      args: [],
    );
  }

  /// `Still Unpaid`
  String get stillUnpaid {
    return Intl.message(
      'Still Unpaid',
      name: 'stillUnpaid',
      desc: '',
      args: [],
    );
  }

  /// `Purchase Report`
  String get purchaseReport {
    return Intl.message(
      'Purchase Report',
      name: 'purchaseReport',
      desc: '',
      args: [],
    );
  }

  /// `Connect your printer`
  String get connectPrinter {
    return Intl.message(
      'Connect your printer',
      name: 'connectPrinter',
      desc: '',
      args: [],
    );
  }

  /// `Click to connect`
  String get clickToConnect {
    return Intl.message(
      'Click to connect',
      name: 'clickToConnect',
      desc: '',
      args: [],
    );
  }

  /// `Please Collect A Due`
  String get collectDues {
    return Intl.message(
      'Please Collect A Due',
      name: 'collectDues',
      desc: '',
      args: [],
    );
  }

  /// `Please Add A Purchase`
  String get addNewPurchase {
    return Intl.message(
      'Please Add A Purchase',
      name: 'addNewPurchase',
      desc: '',
      args: [],
    );
  }

  /// `Sales Report`
  String get salesReport {
    return Intl.message(
      'Sales Report',
      name: 'salesReport',
      desc: '',
      args: [],
    );
  }

  /// `Please Add A Sale`
  String get addSale {
    return Intl.message(
      'Please Add A Sale',
      name: 'addSale',
      desc: '',
      args: [],
    );
  }

  /// `Reports`
  String get reports {
    return Intl.message(
      'Reports',
      name: 'reports',
      desc: '',
      args: [],
    );
  }

  /// `Choose a Customer`
  String get chooseCustomer {
    return Intl.message(
      'Choose a Customer',
      name: 'chooseCustomer',
      desc: '',
      args: [],
    );
  }

  /// `Add Sales`
  String get addSales {
    return Intl.message(
      'Add Sales',
      name: 'addSales',
      desc: '',
      args: [],
    );
  }

  /// `Sales List`
  String get saleList {
    return Intl.message(
      'Sales List',
      name: 'saleList',
      desc: '',
      args: [],
    );
  }

  /// `Edit Sales Invoice`
  String get editSalesInvoice {
    return Intl.message(
      'Edit Sales Invoice',
      name: 'editSalesInvoice',
      desc: '',
      args: [],
    );
  }

  /// `Previous Pay Amount`
  String get previousPayAmount {
    return Intl.message(
      'Previous Pay Amount',
      name: 'previousPayAmount',
      desc: '',
      args: [],
    );
  }

  /// `Printing Option`
  String get printing {
    return Intl.message(
      'Printing Option',
      name: 'printing',
      desc: '',
      args: [],
    );
  }

  /// `Printing Option`
  String get themecolor {
    return Intl.message(
      'Theme Color',
      name: 'themecolor',
      desc: '',
      args: [],
    );
  }

  /// `Subscription`
  String get subscription {
    return Intl.message(
      'Subscription',
      name: 'subscription',
      desc: '',
      args: [],
    );
  }

  /// `User Role`
  String get userRole {
    return Intl.message(
      'User Role',
      name: 'userRole',
      desc: '',
      args: [],
    );
  }

  /// `Currency`
  String get currency {
    return Intl.message(
      'Currency',
      name: 'currency',
      desc: '',
      args: [],
    );
  }

  /// `Log Out`
  String get logOut {
    return Intl.message(
      'Log Out',
      name: 'logOut',
      desc: '',
      args: [],
    );
  }

  /// `Stock List`
  String get stockList {
    return Intl.message(
      'Stock Inventory',
      name: 'stockInventory',
      desc: '',
      args: [],
    );
  }

  /// `Purchase`
  String get purchase {
    return Intl.message(
      'Purchase',
      name: 'purchase',
      desc: '',
      args: [],
    );
  }

  /// `Sale`
  String get sale {
    return Intl.message(
      'Sale',
      name: 'sale',
      desc: '',
      args: [],
    );
  }

  /// `Your Package`
  String get yourPack {
    return Intl.message(
      'Your Package',
      name: 'yourPack',
      desc: '',
      args: [],
    );
  }

  /// `Free Plan`
  String get freePlan {
    return Intl.message(
      'Free Plan',
      name: 'freePlan',
      desc: '',
      args: [],
    );
  }

  /// `You are using `
  String get youRUsing {
    return Intl.message(
      'You are using ',
      name: 'youRUsing',
      desc: '',
      args: [],
    );
  }

  /// `Free Package`
  String get freePack {
    return Intl.message(
      'Free Package',
      name: 'freePack',
      desc: '',
      args: [],
    );
  }

  /// `Premium Plan`
  String get premiumPlan {
    return Intl.message(
      'Premium Plan',
      name: 'premiumPlan',
      desc: '',
      args: [],
    );
  }

  /// `Package Features`
  String get packFeatures {
    return Intl.message(
      'Package Features',
      name: 'packFeatures',
      desc: '',
      args: [],
    );
  }

  /// `Unlimited`
  String get unlimited {
    return Intl.message(
      'Unlimited',
      name: 'unlimited',
      desc: '',
      args: [],
    );
  }

  /// `Update Now`
  String get updateNow {
    return Intl.message(
      'Update Now',
      name: 'updateNow',
      desc: '',
      args: [],
    );
  }

  /// `Purchase Premium Plan`
  String get purchasePremium {
    return Intl.message(
      'Purchase Premium Plan',
      name: 'purchasePremium',
      desc: '',
      args: [],
    );
  }

  /// `Buy premium Plan`
  String get buyPremium {
    return Intl.message(
      'Buy premium Plan',
      name: 'buyPremium',
      desc: '',
      args: [],
    );
  }

  /// `Pay With Paypal`
  String get paypalPay {
    return Intl.message(
      'Pay With Paypal',
      name: 'paypalPay',
      desc: '',
      args: [],
    );
  }

  /// `You Have Got An Email`
  String get gotEmail {
    return Intl.message(
      'You Have Got An Email',
      name: 'gotEmail',
      desc: '',
      args: [],
    );
  }

  /// `We Have Send An Email with instructions on how to reset password to:`
  String get sendEmail {
    return Intl.message(
      'We Have Send An Email with instructions on how to reset password to:',
      name: 'sendEmail',
      desc: '',
      args: [],
    );
  }

  /// `Check Email`
  String get checkEmail {
    return Intl.message(
      'Check Email',
      name: 'checkEmail',
      desc: '',
      args: [],
    );
  }

  /// `Close`
  String get close {
    return Intl.message(
      'Close',
      name: 'close',
      desc: '',
      args: [],
    );
  }

  /// `Forgot password`
  String get forgotPassword {
    return Intl.message(
      'Forgot password',
      name: 'forgotPassword',
      desc: '',
      args: [],
    );
  }

  /// `Please enter your email address below to receive password Reset Link.`
  String get enterEmail {
    return Intl.message(
      'Please enter your email address below to receive password Reset Link.',
      name: 'enterEmail',
      desc: '',
      args: [],
    );
  }

  /// `Send Reset Link`
  String get sendLink {
    return Intl.message(
      'Send Reset Link',
      name: 'sendLink',
      desc: '',
      args: [],
    );
  }

  /// `Email`
  String get emailText {
    return Intl.message(
      'Email',
      name: 'emailText',
      desc: '',
      args: [],
    );
  }

  /// `Password`
  String get password {
    return Intl.message(
      'Password',
      name: 'password',
      desc: '',
      args: [],
    );
  }

  /// `Log In`
  String get logIn {
    return Intl.message(
      'Log In',
      name: 'logIn',
      desc: '',
      args: [],
    );
  }

  /// `Haven't any account?`
  String get noAcc {
    return Intl.message(
      'Haven\'t any account?',
      name: 'noAcc',
      desc: '',
      args: [],
    );
  }

  /// `Register`
  String get register {
    return Intl.message(
      'Register',
      name: 'register',
      desc: '',
      args: [],
    );
  }

  /// `Phone Verification`
  String get phoneVerification {
    return Intl.message(
      'Phone Verification',
      name: 'phoneVerification',
      desc: '',
      args: [],
    );
  }

  /// `We need to register your phone without getting started!`
  String get registerTitle {
    return Intl.message(
      'We need to register your phone without getting started!',
      name: 'registerTitle',
      desc: '',
      args: [],
    );
  }

  /// `Send the code`
  String get sendCode {
    return Intl.message(
      'Send the code',
      name: 'sendCode',
      desc: '',
      args: [],
    );
  }

  /// `Staff Login`
  String get staffLogin {
    return Intl.message(
      'Staff Login',
      name: 'staffLogin',
      desc: '',
      args: [],
    );
  }

  /// `Login With Email`
  String get logInWithMail {
    return Intl.message(
      'Login With Email',
      name: 'logInWithMail',
      desc: '',
      args: [],
    );
  }

  /// `Setup Your Profile`
  String get setUpProfile {
    return Intl.message(
      'Setup Your Profile',
      name: 'setUpProfile',
      desc: '',
      args: [],
    );
  }

  /// `Update your profile to connect your doctor with better impression`
  String get setUpDesc {
    return Intl.message(
      'Update your profile to connect your doctor with better impression',
      name: 'setUpDesc',
      desc: '',
      args: [],
    );
  }

  /// `Gallery`
  String get gallery {
    return Intl.message(
      'Gallery',
      name: 'gallery',
      desc: '',
      args: [],
    );
  }

  /// `Camera`
  String get camera {
    return Intl.message(
      'Camera',
      name: 'camera',
      desc: '',
      args: [],
    );
  }

  /// `Company Address`
  String get companyAddress {
    return Intl.message(
      'Company Address',
      name: 'companyAddress',
      desc: '',
      args: [],
    );
  }

  /// `Opening Balance`
  String get openingBalance {
    return Intl.message(
      'Opening Balance',
      name: 'openingBalance',
      desc: '',
      args: [],
    );
  }

  /// `Confirm Password`
  String get confirmPass {
    return Intl.message(
      'Confirm Password',
      name: 'confirmPass',
      desc: '',
      args: [],
    );
  }

  /// `Already have an account?`
  String get haveAcc {
    return Intl.message(
      'Already have an account?',
      name: 'haveAcc',
      desc: '',
      args: [],
    );
  }

  /// `Login With Phone`
  String get loginWithPhone {
    return Intl.message(
      'Login With Phone',
      name: 'loginWithPhone',
      desc: '',
      args: [],
    );
  }

  /// `Edit Phone Number ?`
  String get editPhone {
    return Intl.message(
      'Edit Phone Number ?',
      name: 'editPhone',
      desc: '',
      args: [],
    );
  }

  /// `Create a Free Account`
  String get createAcc {
    return Intl.message(
      'Create a Free Account',
      name: 'createAcc',
      desc: '',
      args: [],
    );
  }

  /// `Congratulations`
  String get congratulation {
    return Intl.message(
      'Congratulations',
      name: 'congratulation',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'af'),
      Locale.fromSubtags(languageCode: 'ar'),
      Locale.fromSubtags(languageCode: 'az'),
      Locale.fromSubtags(languageCode: 'bn'),
      Locale.fromSubtags(languageCode: 'bs'),
      Locale.fromSubtags(languageCode: 'cs'),
      Locale.fromSubtags(languageCode: 'da'),
      Locale.fromSubtags(languageCode: 'de'),
      Locale.fromSubtags(languageCode: 'el'),
      Locale.fromSubtags(languageCode: 'es'),
      Locale.fromSubtags(languageCode: 'fa'),
      Locale.fromSubtags(languageCode: 'fi'),
      Locale.fromSubtags(languageCode: 'fr'),
      Locale.fromSubtags(languageCode: 'he'),
      Locale.fromSubtags(languageCode: 'hi'),
      Locale.fromSubtags(languageCode: 'hr'),
      Locale.fromSubtags(languageCode: 'hu'),
      Locale.fromSubtags(languageCode: 'id'),
      Locale.fromSubtags(languageCode: 'it'),
      Locale.fromSubtags(languageCode: 'ja'),
      Locale.fromSubtags(languageCode: 'kk'),
      Locale.fromSubtags(languageCode: 'km'),
      Locale.fromSubtags(languageCode: 'kn'),
      Locale.fromSubtags(languageCode: 'ko'),
      Locale.fromSubtags(languageCode: 'lo'),
      Locale.fromSubtags(languageCode: 'mr'),
      Locale.fromSubtags(languageCode: 'ms'),
      Locale.fromSubtags(languageCode: 'my'),
      Locale.fromSubtags(languageCode: 'ne'),
      Locale.fromSubtags(languageCode: 'nl'),
      Locale.fromSubtags(languageCode: 'pl'),
      Locale.fromSubtags(languageCode: 'pt'),
      Locale.fromSubtags(languageCode: 'ro'),
      Locale.fromSubtags(languageCode: 'ru'),
      Locale.fromSubtags(languageCode: 'si'),
      Locale.fromSubtags(languageCode: 'sk'),
      Locale.fromSubtags(languageCode: 'sq'),
      Locale.fromSubtags(languageCode: 'sr'),
      Locale.fromSubtags(languageCode: 'sv'),
      Locale.fromSubtags(languageCode: 'sw'),
      Locale.fromSubtags(languageCode: 'ta'),
      Locale.fromSubtags(languageCode: 'th'),
      Locale.fromSubtags(languageCode: 'tr'),
      Locale.fromSubtags(languageCode: 'uk'),
      Locale.fromSubtags(languageCode: 'ur'),
      Locale.fromSubtags(languageCode: 'vi'),
      Locale.fromSubtags(languageCode: 'zh'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
