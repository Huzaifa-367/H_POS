import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../model/homepage_image_model.dart';
import '../repository/home_page_images.dart';

HomePageImageRepo imageRepo = HomePageImageRepo();
final homepageImageProvider = FutureProvider<List<HomePageImageModel>>((ref) => imageRepo.getAllHomePageImage());
