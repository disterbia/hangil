import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hangil/components/custom_logo.dart';
import 'package:hangil/controller/product_controller.dart';

class DetailPage extends GetView<ProductController> {

  DetailPage({this.param});
  String? param;
  ProductController p = Get.put(ProductController());
  bool isDesktop = GetPlatform.isDesktop;
  double screenHeight=Get.height;
  double screenWidth=Get.width;


  @override
  Widget build(BuildContext context) {
    return controller.obx((state) {
      return Obx(() {
        return SafeArea(child: Scaffold(
          body: SingleChildScrollView(
            child: SingleChildScrollView(scrollDirection: Axis.horizontal,
              child: Column(children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(),
                    CustomLogo(),
                    Container(
                        child: IconButton(onPressed: (){}, icon: Image.asset("assets/kakao.png"),iconSize: 70, )),
                  ],
                ),
                Row(children: [
                  Container(width: screenWidth*0.66,),
                  Container(width: screenWidth*0.33,)
                ],)
              ]),
            ),
          ),
      ),);
      });
    });
  }
}
