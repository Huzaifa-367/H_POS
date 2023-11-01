import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../Screens/Purchase/Model/purchase_report.dart';
import '../repository/purchase_report_repo.dart';

PurchaseReportRepo purchaseReportRepo = PurchaseReportRepo();
final purchaseReportProvider = FutureProvider<List<PurchaseReport>>((ref) => purchaseReportRepo.getAllPurchaseReport());
