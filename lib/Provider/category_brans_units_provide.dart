// ignore_for_file: file_names

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_pos/GlobalComponents/Model/category_model.dart';
import 'package:mobile_pos/Screens/Products/Model/brands_model.dart';
import 'package:mobile_pos/repository/category_brans_units_repo.dart';

import '../Screens/Products/Model/unit_model.dart';

CategoryRepo categoryRepo = CategoryRepo();
final categoryProvider = FutureProvider.autoDispose<List<CategoryModel>>(
    (ref) => categoryRepo.getAllCategory());

BrandsRepo brandsRepo = BrandsRepo();
final brandsProvider = FutureProvider.autoDispose<List<BrandsModel>>(
    (ref) => brandsRepo.getAllBrand());

UnitsRepo unitsRepo = UnitsRepo();
final unitsProvider = FutureProvider.autoDispose<List<UnitModel>>(
    (ref) => unitsRepo.getAllUnits());
