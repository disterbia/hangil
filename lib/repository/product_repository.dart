import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hangil/model/product.dart';
import 'package:hangil/provider/product_provider.dart';

class ProductRepository{
  final ProductProvider _productProvider = ProductProvider();

  Future<Product> save(Product product) async {
    DocumentSnapshot result = await _productProvider.save(product);
    return Product.fromJson(result.data() as Map<String, dynamic>);
  }

}