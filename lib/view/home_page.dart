import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hangil/components/custom_logo.dart';
import 'package:hangil/controller/menu_controller.dart';
import 'package:hangil/controller/product_controller.dart';
import 'package:hangil/model/menu.dart';

class HomePage extends GetView<MenuController> {

  HomePage({this.param});

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
                  m.menus.length;
                  final List<bool> _selections = List.generate(m.menus.length, (index) => false);
                  param=param??"0";
                  _selections.length!=0?_selections[int.parse(param!)] = true:null;
                  String? nowCategory =_selections.length!=0? m.menus[int.parse(param!)].name:null;
                  return Obx(() => Text(m.menus.length.toString()));
                }),
              ],
            ),
          ))),
    );
  }
}
