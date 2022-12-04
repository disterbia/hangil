
import 'package:get/get.dart';
import 'package:hangil/model/menu.dart';
import 'package:hangil/repository/menu_repository.dart';

class MenuController extends GetxController with StateMixin{

  final MenuRepository _menuRepository = MenuRepository();
  final menus = <Menu>[].obs;
  RxBool isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    change(null,status: RxStatus.loading());
    findAll();
    change(null, status: RxStatus.success());
  }

  Future<void> findAll() async{
    change(null,status: RxStatus.loading());
    isLoading.value=true;
    List<Menu> menus = await _menuRepository.findAll();
    this.menus.value=menus;
    isLoading.value=false;
    change(null, status: RxStatus.success());
  }

  Future<void> save(String name) async {
    change(null,status: RxStatus.loading());
    await _menuRepository.save(Menu(name: name));
    isLoading.value=false;
    change(null, status: RxStatus.success());
  }

  Future<void> updateMenu(Menu menu) async {
    change(null,status: RxStatus.loading());

    await _menuRepository.update(menu);
    isLoading.value=false;

    change(null, status: RxStatus.success());
  }

  Future<void> delete(String id) async {
    change(null,status: RxStatus.loading());
    await _menuRepository.delete(id);
    isLoading.value=false;
    change(null, status: RxStatus.success());
  }


}