import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  final String? id;
  final String? name;
  final String? comment;
  final int? price;
  final String? category;
  final List<dynamic>? imageUrls;
  final DateTime? created;

  Product({this.id,
    this.name,
    this.comment,
    this.price,
    this.category,
    this.imageUrls,
    this.created,});

  Product.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        name = json["name"],
        comment = json["comment"],
        price = json["price"],
        category = json["category"],
        imageUrls = json["image_urls"],
        created = json["created"].toDate();

  Map<String, dynamic> toJson() =>
      {
        "name": name,
        "comment": comment,
        "price": price,
        "category": category,
        "image_urls": imageUrls,
        "created": FieldValue.serverTimestamp(),
      };
}
