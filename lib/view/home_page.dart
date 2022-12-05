import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:hangil/components/custom_logo.dart';
import 'package:hangil/controller/menu_controller.dart';
import 'package:hangil/controller/product_controller.dart';
import 'package:hangil/model/menu.dart';
import 'package:intl/intl.dart';

class HomePage extends GetView<ProductController> {

  HomePage({this.param});

  final _search = TextEditingController();
  MenuController m = Get.put(MenuController());
  ProductController p = Get.put(ProductController());

  final _selections = <bool>[].obs;
  String? param;
  bool isDeskTop = GetPlatform.isDesktop;
  double screenHeight = Get.height;
  double screenWidth = Get.width;



  @override
  Widget build(BuildContext context) {
    return controller.obx((state) {
      if (p.isLoading.value) {
        return Center(
            child: Container(
                height: 50, width: 50, child: CircularProgressIndicator()));
      }
      else{
        int length = m.menus.length;
        _selections.value = List.generate(length, (index) => false);
        param=param??"0";
        _selections.length!=0?_selections[int.parse(param!)] = true:null;
        //nowCategory =_selections.length!=0? m.menus[int.parse(param!)].id:null;
        p.changeCategory(int.parse(param!));


      }
        return Obx(
          () {
            return SafeArea(
              child: Scaffold(
                  body: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(),
                                CustomLogo(),
                                Container(
                                    height: 70,
                                    child: Row(
                                      children: [
                                        Image.asset("assets/kakao.png")
                                      ],
                                    )),
                              ],
                            ),
                            isDeskTop
                                ? Row(children: createButton(0, 6,context))
                                : Column(
                              children: [
                                Row(children: createButton(0, 3,context)),
                                Row(children: createButton(3, 6,context))
                              ],
                            ),
                            Container(
                              width: screenWidth,
                              child: GridView.builder(
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: p.products.length,
                                gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: isDeskTop ? 4 : 2,
                                  crossAxisSpacing: 10,
                                  mainAxisSpacing: 20,
                                  childAspectRatio: isDeskTop ? 0.8 : 0.7,
                                ),
                                itemBuilder: (context, index) {
                                  return Column(
                                    children: [
                                      Expanded(
                                        flex: 10,
                                        child: CachedNetworkImage(
                                          imageUrl:
                                          p.products[index].imageUrls![0]!,
                                          imageBuilder:
                                              (context, imageProvider) =>
                                              GestureDetector(
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    image: DecorationImage(
                                                      image: imageProvider,
                                                      fit: BoxFit.cover,
                                                      // colorFilter:
                                                      // ColorFilter.mode(Colors.red, BlendMode.colorBurn)
                                                    ),
                                                  ),
                                                ),
                                                onTap: () async {
                                                  String param =
                                                  p.products[index].id!;
                                                  await p.findById(param);
                                                  context.go("/detail/$param");
                                                  // Get.to(() => DetailPage(),
                                                  //     transition: Transition.size);
                                                },
                                              ),
                                          //placeholder: (context, url) => CircularProgressIndicator(),
                                          errorWidget: (context, url, error) =>
                                              Icon(Icons.error),
                                        ),
                                      ),
                                      Expanded(
                                          child: Text(
                                            p.products[index].name!,
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          )),
                                      Expanded(
                                          child:
                                          Text(p.products[index].comment!)),
                                      // Expanded(
                                      //     child: Text(
                                      //       NumberFormat("###,###,### 원")
                                      //           .format(p.products[index].price!),
                                      //       style: TextStyle(color: Colors.orange),
                                      //     )),
                                    ],
                                  );
                                },
                              ),
                            )
                          ],
                        ),
                      ))),
            );
          },
      );
      },
    );
  }
  List<Widget> createButton(int a, int b,BuildContext context) {
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
          //nowCategory = menus[i].id;
          // p.changeCategory(i);
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
}
