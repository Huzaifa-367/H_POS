import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_pos/repository/delivery_repo.dart';

import '../Screens/Delivery/Model/delivery_model.dart';

DeliveryRepo deliveryRepo = DeliveryRepo();

final deliveryAddressProvider = FutureProvider<List<DeliveryModel>>((ref) => deliveryRepo.getAllDelivery());
