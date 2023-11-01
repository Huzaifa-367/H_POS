import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../model/currency_model.dart';
import '../repository/currency_repo.dart';

CurrencyRepo currencyRepo = CurrencyRepo();
final currencyProvider = FutureProvider<List<CurrencyModel>>((ref) => currencyRepo.getAllCurrency());
