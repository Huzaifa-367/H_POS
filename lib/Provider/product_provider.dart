import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_pos/model/product_model.dart';
import 'package:mobile_pos/repository/product_repo.dart';

ProductRepo productRepo = ProductRepo();
final productProvider = FutureProvider.autoDispose<List<ProductModel>>((ref) => productRepo.getAllProduct());
