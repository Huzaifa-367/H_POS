import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_pos/Screens/Parties_Customers/Model/customer_model.dart';
import 'package:mobile_pos/repository/customer_repo.dart';

CustomerRepo customerRepo = CustomerRepo();
final customerProvider = FutureProvider.autoDispose<List<CustomerModel>>((ref) => customerRepo.getAllCustomers());
