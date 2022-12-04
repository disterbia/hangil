import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hangil/model/product.dart';

class ProductProvider{

  final _collection = "product";
  final _store = FirebaseFirestore.instance;

  Future<DocumentSnapshot> save(Product product) =>
      _store.collection(_collection).add(product.toJson()).then((v) async {
        await v.update({"id": v.id});
        return v.get();
      });
}