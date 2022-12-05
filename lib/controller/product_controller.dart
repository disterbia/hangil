import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:hangil/controller/menu_controller.dart';
import 'package:hangil/model/product.dart';
import 'package:hangil/repository/product_repository.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as Path;

class ProductController extends GetxController with StateMixin {
  final ProductRepository _productRepository = ProductRepository();
  MenuController m = Get.put(MenuController());
  final products = <Product>[].obs;
  final product = Product().obs;
  final productsList =<List<Product>>[].obs;
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    findAll();
  }

  Future<void> findAll() async{
    productsList.clear();
    change(null,status: RxStatus.loading());
    await m.findAll();
    for(int i =0;i<m.menus.length;i++){
      await findByCategory(m.menus[i].id!);
    }
    // /changeCategory(0);
    isLoading.value=false;
    change(null, status: RxStatus.success());
  }

  Future<void> findById(String id) async {
   // change(null,status: RxStatus.loading());
    isLoading.value=true;
    Product product = await _productRepository.findById(id);
    this.product.value = product;
    isLoading.value=false;
    //change(null, status: RxStatus.success());
  }

  Future<void> findByCategory(String category) async {
    change(null,status: RxStatus.loading());
    isLoading.value=true;
    List<Product> products = await _productRepository.findByCategory(category);
    this.products.value=products;
    productsList.add(products);
    isLoading.value=false;
    change(null, status: RxStatus.success());
  }

  void changeCategory(int index){
    products.value=productsList[index];
  }



  Future<void> uploadImageToStorage(
      List<XFile>? pickedFile, Product product) async {
    if (pickedFile == null) return;
    List<String> urlList = [];
    change(null, status: RxStatus.loading());
    for (int i = 0; i < pickedFile.length; i++) {
      Reference _reference = FirebaseStorage.instance.ref().child(
          'product/${product.category}/${Path.basename(pickedFile[i].path)}');
      await _reference
          .putData(
        await pickedFile[i].readAsBytes(),
        SettableMetadata(contentType: 'image/jpeg'),
      )
          .whenComplete(() async {
        await _reference.getDownloadURL().then((value) {
          urlList.add(value);
          print(value);
        });
      });
    }
    Product newProduct = Product(
        name: product.name,
        comment: product.comment,
        price: product.price,
        category: product.category,
        body: product.body,
        imageUrls: urlList
    );
    await save(newProduct);

    change(null, status: RxStatus.success());
  }

  Future<void> save(Product newProduct) async {
    change(null, status: RxStatus.loading());
    Product product = await _productRepository.save(newProduct);
    //this.product.value=product;
    change(null, status: RxStatus.success());
  }
}
