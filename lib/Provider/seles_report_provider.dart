import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../Screens/Sales/Model/sales_report.dart';
import '../repository/sales_report_repo.dart';

SalesReportRepo salesReportRepo = SalesReportRepo();
final salesReportProvider = FutureProvider.autoDispose<List<SalesReport>>((ref) => salesReportRepo.getAllSalesReport());
