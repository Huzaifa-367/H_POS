import 'package:flutter/material.dart';
import 'package:mobile_pos/Screens/Home/home_screen.dart';
import 'package:mobile_pos/generated/l10n.dart' as lang;

class GridItems {
  Key? key;
  final String title, icon, route;

  GridItems(
      {this.key, required this.title, required this.icon, required this.route});
}

List<GridItems> getFreeIcons({required BuildContext context}) {
  List<GridItems> freeIcons = [
    GridItems(
        title: lang.S.of(context).sale,
        icon: 'images/sales1.png',
        route: 'Sales'),
    GridItems(
      title: lang.S.of(context).lossOrProfit,
      icon: 'images/lossprofit.png',
      route: 'Loss/Profit',
    ),
    GridItems(
        title: lang.S.of(context).parties,
        icon: 'images/parties1.png',
        route: 'Parties'),
    GridItems(
        title: lang.S.of(context).purchase,
        icon: 'images/purchase1.png',
        route: 'Purchase'),
    GridItems(
        title: lang.S.of(context).product,
        icon: 'images/product1.png',
        route: 'Products'),
    GridItems(
        title: lang.S.of(context).dueList,
        icon: 'images/duelist.png',
        route: 'Due List'),
    GridItems(
        title: lang.S.of(context).stockList,
        icon: 'images/stock1.png',
        route: 'Stock'),

    GridItems(
        title: lang.S.of(context).reports,
        icon: 'images/reports1.png',
        route: 'Reports'),
    // GridItems(
    //   title: lang.S.of(context).saleList,
    //   icon: 'images/saleslist.png',
    //   route: 'Sales List',
    // ),
    // GridItems(
    //   title: lang.S.of(context).purchaseList,
    //   icon: 'images/purchaselist.png',
    //   route: 'Purchase List',
    // ),

    GridItems(
      title: lang.S.of(context).expense,
      icon: 'images/expenses.png',
      route: 'Expense',
    ),
    // GridItems(
    //   title: 'Delivery',
    //   icon: 'images/delivery.png',
    // ),
    // GridItems(
    //   title: 'Calculator',
    //   icon: 'images/calculator.png',
    // ),
    // GridItems(
    //   title: 'Expense',
    //   icon: 'images/expenses.png',
    // )
  ];
  return freeIcons;
}

List<GridItems> freeIcons = [];

List<GridItems> businessIcons = [
  GridItems(
    title: 'Warehouse',
    icon: 'images/warehouse.png',
    route: 'Warehouse',
  ),
  GridItems(
    title: 'SalesReturn',
    icon: 'images/salesreturn.png',
    route: 'SalesReturn',
  ),
  GridItems(
    title: 'SalesList',
    icon: 'images/salelist.png',
    route: 'SalesList',
  ),
  GridItems(
    title: 'Quotation',
    icon: 'images/quotation.png',
    route: 'Quotation',
  ),
  GridItems(
    title: 'OnlineStore',
    icon: 'images/onlinestore.png',
    route: 'OnlineStore',
  ),
  GridItems(
    title: 'Supplier',
    icon: 'images/supplier.png',
    route: 'Supplier',
  ),
  GridItems(
    title: 'Invoice',
    icon: 'images/invoice.png',
    route: 'Invoice',
  ),
  GridItems(
    title: 'Stock',
    icon: 'images/stock.png',
    route: 'Stock',
  ),
  GridItems(
    title: 'Ledger',
    icon: 'images/ledger.png',
    route: 'Ledger',
  ),
  GridItems(
    title: 'Dashboard',
    icon: 'images/dashboard.png',
    route: 'Dashboard',
  ),
  GridItems(
    title: 'Bank',
    icon: 'images/bank.png',
    route: 'Bank',
  ),
  GridItems(
    title: 'Barcode',
    icon: 'images/barcodescan.png',
    route: 'Barcode',
  )
];

List<GridItems> enterpriseIcons = [
  GridItems(
    title: 'Branch',
    icon: 'images/branch.png',
    route: 'Branch',
  ),
  GridItems(
    title: 'Damage',
    icon: 'images/damage.png',
    route: 'Damage',
  ),
  GridItems(
    title: 'Adjustment',
    icon: 'images/adjustment.png',
    route: 'Adjustment',
  ),
  GridItems(
    title: 'Transaction',
    icon: 'images/transaction.png',
    route: 'Transaction',
  ),
  GridItems(
    title: 'Gift',
    icon: 'images/gift.png',
    route: 'Gift',
  ),
  GridItems(
    title: 'Loss&Profit',
    icon: 'images/lossProfit.png',
    route: 'Loss&Profit',
  ),
  GridItems(
    title: 'Income',
    icon: 'images/income.png',
    route: 'Income',
  ),
  GridItems(
    title: 'OnlineOrder',
    icon: 'images/onlineorder.png',
    route: 'OnlineOrder',
  ),
  GridItems(
    title: 'UserRole',
    icon: 'images/userrole.png',
    route: 'UserRole',
  ),
  GridItems(
    title: 'Backup',
    icon: 'images/backup.png',
    route: 'Backup',
  ),
  GridItems(
    title: 'Return',
    icon: 'images/return.png',
    route: 'Return',
  )
];
