import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hangil/repository/admin_repository.dart';

class AdminController extends GetxController{

  AdminRepository _adminRepository = AdminRepository();

  Future<bool> findByPassword(String password) async {
    dynamic result=await _adminRepository.findByPassword(password);
    if(result!=null){
      await GetStorage().write("id", result);
      return true;
      }
    return false;
  }
}