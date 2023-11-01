import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../model/expense_category_model.dart';
import '../repository/expense)category_repo.dart';

ExpenseCategoryRepo expenseCategoryRepo = ExpenseCategoryRepo();
final expenseCategoryProvider = FutureProvider.autoDispose<List<ExpenseCategoryModel>>((ref) => expenseCategoryRepo.getAllExpenseCategory());
