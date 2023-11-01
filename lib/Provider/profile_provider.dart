import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_pos/model/personal_information_model.dart';
import 'package:mobile_pos/repository/profile_details_repo.dart';

ProfileRepo profileRepo = ProfileRepo();
final profileDetailsProvider = FutureProvider.autoDispose<PersonalInformationModel>((ref) => profileRepo.getDetails());
