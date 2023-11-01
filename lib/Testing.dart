// import 'dart:convert';

// class Category {
//   String? Category_Name;
//   String? Image;
//   Category({
//     required this.Category_Name,
//     required this.Image,
//   });

//   Category copyWith({
//     String? Category_Name,
//     String? Image,
//   }) {
//     return Category(
//       Category_Name: Category_Name ?? this.Category_Name,
//       Image: Image ?? this.Image,
//     );
//   }

//   Map<String, dynamic> toMap() {
//     final result = <String, dynamic>{};
  
//     if(Category_Name != null){
//       result.addAll({'Category_Name': Category_Name});
//     }
//     if(Image != null){
//       result.addAll({'Image': Image});
//     }
  
//     return result;
//   }

//   factory Category.fromMap(Map<String, dynamic> map) {
//     return Category(
//       Category_Name: map['Category_Name'],
//       Image: map['Image'],
//     );
//   }

//   String toJson() => json.encode(toMap());

//   factory Category.fromJson(String source) => Category.fromMap(json.decode(source));

//   @override
//   String toString() => 'Category(Category_Name: $Category_Name, Image: $Image)';

//   @override
//   bool operator ==(Object other) {
//     if (identical(this, other)) return true;
  
//     return other is Category &&
//       other.Category_Name == Category_Name &&
//       other.Image == Image;
//   }

//   @override
//   int get hashCode => Category_Name.hashCode ^ Image.hashCode;
// }
