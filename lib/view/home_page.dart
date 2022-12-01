import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:hangil/components/custom_logo.dart';
import 'package:hangil/controller/menu_controller.dart';
import 'package:hangil/controller/product_controller.dart';
import 'package:hangil/model/menu.dart';

class HomePage extends GetView<MenuController> {

  HomePage({this.param});

  final _search = TextEditingController();
  MenuController m = Get.put(MenuController());
  ProductController p = Get.put(ProductController());

  String? param;
  bool isDeskTop = GetPlatform.isDesktop;
  double screenHeight = Get.height;
  double screenWidth = Get.width;



  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(body:SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Row(mainAxisAlignment:MainAxisAlignment.spaceBetween ,
                  children: [
                    Container(),
                    CustomLogo(),
                    Container(height:70,child: Row(
                      children: [
                        Image.asset("assets/kakao.png")
                      ],
                    )),
                  ],
                ),
                controller.obx((state) {

                  final List<bool> _selections = List.generate(m.menus.length, (index) => false);
                  param=param??"0";
                  _selections.length!=0?_selections[int.parse(param!)] = true:null;
                  String? nowCategory =_selections.length!=0? m.menus[int.parse(param!)].name:null;

                  List<Widget> createButton(int a, int b) {
                    int length=m.menus.length;
                    List<Menu> menus = m.menus;
                    List<Widget> list = [];
                    for (int i = a; i < length; i++) {
                      if (i == b) break;
                      list.add(ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            minimumSize: Size(50, 50),
                            primary: _selections[i] ? Colors.grey : Colors.transparent,
                            shadowColor: Colors.transparent,
                            onPrimary: Colors.black),
                        onPressed: () {
                          for (int j = 0; j < _selections.length; j++) {
                            _selections[j] = i == j;
                          }
                          nowCategory = menus[i].name;
                          //p.changeCategory(categorxis[i]);
                          _search.clear();
                          // WidgetsBinding.instance!.addPersistentFrameCallback((_) {
                          context.go("/home/$i");
                          // });
                        },
                        child: Text(menus[i].name!, style: TextStyle(color: Colors.black)),
                      ));
                    }
                    return list;
                  }

                  return Obx(() => Text(m.menus.length.toString()));
                }),
              ],
            ),
          ))),
    );
  }
}
