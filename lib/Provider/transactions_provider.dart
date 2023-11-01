import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_pos/model/transition_model.dart';

import '../repository/transactions_repo.dart';

TransitionRepo transitionRepo = TransitionRepo();
final transitionProvider = FutureProvider<List<TransitionModel>>((ref) => transitionRepo.getAllTransition());

PurchaseTransitionRepo purchaseTransitionRepo = PurchaseTransitionRepo();
final purchaseTransitionProvider = FutureProvider<List<dynamic>>((ref) => purchaseTransitionRepo.getAllTransition());
