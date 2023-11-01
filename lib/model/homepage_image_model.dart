class HomePageImageModel {
  late String imageUrl;

  HomePageImageModel({required this.imageUrl});

  HomePageImageModel.fromJson(Map<String, dynamic> json) : imageUrl = json['imageUrl'];
}
