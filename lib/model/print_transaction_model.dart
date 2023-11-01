import 'package:mobile_pos/model/due_transaction_model.dart';
import 'package:mobile_pos/model/personal_information_model.dart';
import 'package:mobile_pos/model/transition_model.dart';

class PrintTransactionModel {
  PrintTransactionModel({required this.transitionModel, required this.personalInformationModel});

  PersonalInformationModel personalInformationModel;
  TransitionModel? transitionModel;
}

class PrintPurchaseTransactionModel {
  PrintPurchaseTransactionModel({required this.purchaseTransitionModel, required this.personalInformationModel});

  PersonalInformationModel personalInformationModel;
  PurchaseTransitionModel? purchaseTransitionModel;
}

class PrintDueTransactionModel {
  PrintDueTransactionModel({required this.dueTransactionModel, required this.personalInformationModel});

  DueTransactionModel? dueTransactionModel;
  PersonalInformationModel personalInformationModel;
}
