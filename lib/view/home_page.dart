import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:hangil/components/custom_logo.dart';
import 'package:hangil/controller/admin_controller.dart';
import 'package:hangil/controller/menu_controller.dart';
import 'package:hangil/controller/product_controller.dart';
import 'package:hangil/model/menu.dart';
import 'package:hangil/util/custom_screen_width.dart';
import 'package:intl/intl.dart';
import 'package:responsive_framework/responsive_framework.dart';

class HomePage extends GetView<ProductController> {
  HomePage({this.param});

  final _search = TextEditingController();
  AdminController a = Get.put(AdminController());
  MenuController m = Get.put(MenuController());
  ProductController p = Get.put(ProductController());


  final _selections = <bool>[].obs;
  String? param;
  final screenHeight = Get.height.obs;
  final screenWidth = Get.width.obs;
  bool priceIsNumber = true;
  final isReverse = false.obs;
  List<bool> priceList = [];
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    print(MediaQuery.of(context).size.width);
    // if(screenWidth.value<MediaQuery.of(context).size.width) {
    screenWidth.value = MediaQuery.of(context).size.width;
    screenHeight.value = MediaQuery.of(context).size.height;
    //  }
    return controller.obx((state) {
      if (p.isLoading.value) {
        return Center(
            child: Container(
                height: 50, width: 50, child: CircularProgressIndicator()));
      } else {
        priceList.clear();
        int length = m.menus.length;
        _selections.value = List.generate(length, (index) => false);
        param = param ?? "0";
        _selections.length != 0 ? _selections[int.parse(param!)] = true : null;
        //nowCategory =_selections.length!=0? m.menus[int.parse(param!)].id:null;
        p.changeCategory(int.parse(param!));
        for (int i = 0; i < p.products.length; i++) {
          try {
            int.parse(p.products[i].price!);
            priceList.add(true);
          } catch (e) {
            priceList.add(false);
          }
        }
      }
      return Obx(
        () {
          return SafeArea(
            child: Scaffold(
                key: _scaffoldKey,
                drawer: Drawer(width: screenWidth.value,
                  child: SingleChildScrollView(
                    child: Padding(
                      padding:EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(),
                            CustomLogo(),
                            MouseRegion(cursor: SystemMouseCursors.click,
                                child: GestureDetector(
                                  onTap: ()=>Navigator.of(context).pop(),
                                    child: Icon(Icons.close,size: 30))),
                          ],),
                          Container(width: screenWidth.value,child: Divider(thickness: 2,)),
                          Column(
                            children: createButton(0, m.menus.length, context),)

                        ],
                      ),
                    ),
                  ),
                ),
                body: SingleChildScrollView(
                    reverse: isReverse.value,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 25,
                          color: Colors.black,
                          width: screenWidth.value,
                          child: Center(
                              child: MouseRegion(
                                cursor: SystemMouseCursors.click,
                                child: GestureDetector(
                                    onTap: () =>
                                        isReverse.value = !isReverse.value,
                                    child: Text(
                                      "회사 정보 안내",
                                      style: TextStyle(color: Colors.white,fontSize: 10),
                                    )),
                              )),
                        ),
                        ConstrainedBox(
                          constraints: BoxConstraints(
                            maxWidth: screenWidth.value,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(
                                right: 30, top: 20, bottom: 10, left: 20),
                            child: Row(
                              mainAxisAlignment: screenWidth.value <= CustomScreenWidth().menuSize
                                  ? MainAxisAlignment.spaceBetween
                                  : MainAxisAlignment.start,
                              children: [
                                if (screenWidth.value < CustomScreenWidth().menuSize)
                                  MouseRegion(
                                    cursor: SystemMouseCursors.click,
                                    child: GestureDetector(
                                        onTap: () => _scaffoldKey.currentState!.openDrawer(),
                                        child: Icon(Icons.menu)),
                                  ),
                                CustomLogo(),
                                if (screenWidth.value >= CustomScreenWidth().menuSize)
                                  Expanded(
                                      flex: 4,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: createButton(0, m.menus.length, context),
                                      )),
                                if (screenWidth.value >= CustomScreenWidth().middleSize)
                                  Text("상담/문의->",
                                    style: TextStyle(fontSize: 15, color: Colors.grey),
                                  ),
                                if (screenWidth.value >=
                                    CustomScreenWidth().menuSize)
                                  SizedBox(width: 10,),
                                MouseRegion(
                                  cursor: SystemMouseCursors.click,
                                  child: GestureDetector(
                                      onTap: () => context.go("/"),
                                      child: Image.asset(
                                        "assets/kakao.png",
                                        height: 60,
                                      )),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                            width: screenWidth.value,
                            child: Divider(
                              thickness: 2,
                            )),
                        Padding(
                          padding: EdgeInsets.only(
                              left: screenWidth.value <=
                                      CustomScreenWidth().bigSize
                                  ? 10.0
                                  : 10 + (screenWidth.value / 50),
                              right: screenWidth.value <=
                                      CustomScreenWidth().bigSize
                                  ? 10.0
                                  : 10 + (screenWidth.value / 50),
                              bottom: 0,
                              top: 0),
                          child: Row(
                            children: [
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                m.menus[int.parse(param!)].name!,
                                style: TextStyle(
                                  fontSize: 30,fontStyle: FontStyle.italic
                                ),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Column(
                                children: [
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    "[${p.products.length}]",
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                        // isDeskTop
                        //     ? Row(children: createButton(0, 6,context))
                        //     : Column(
                        //   children: [
                        //     Row(children: createButton(0, 3,context)),
                        //     Row(children: createButton(3, 6,context))
                        //   ],
                        // ),
                        Container(
                          width: screenWidth.value ,
                          child: GridView.builder(
                            padding: screenWidth.value<=CustomScreenWidth().smallSize
                                ? EdgeInsets.symmetric(vertical: 10,horizontal: 0):
                            EdgeInsets.only(
                                left: screenWidth.value <=
                                        CustomScreenWidth().bigSize
                                    ? 10.0
                                    : 10 + (screenWidth.value / 50),
                                right: screenWidth.value <=
                                        CustomScreenWidth().bigSize
                                    ? 10.0
                                    : 10 + (screenWidth.value / 50),
                                bottom: 10,
                                top: 10),
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: p.products.length,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: screenWidth.value <=
                                      CustomScreenWidth().smallSize
                                  ? 2
                                  : screenWidth.value <=
                                          CustomScreenWidth().middleSize
                                      ? 3
                                      : 4,
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 20,
                              childAspectRatio: screenWidth.value<=CustomScreenWidth().bigSize?0.7:0.8,
                            ),
                            itemBuilder: (context, index) {
                              return Column(
                                children: [
                                  Expanded(
                                    flex: 1,
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
                                              fit: BoxFit.fill,
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
                                  SizedBox(height: 10,),
                                  Text(
                                    p.products[index].name!,
                                    style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold),
                                  ),
                                  Text(p.products[index].comment!),
                                  Text(
                                    priceList[index]
                                    ? NumberFormat("###,###,### 원")
                                        .format(int.parse(
                                            p.products[index].price!))
                                    : p.products[index].price!,
                                    style: TextStyle(color: Colors.orange),
                                  ),
                                ],
                              );
                            },
                          ),
                        ),SizedBox(height: 100,),
                        if(p.products.length<5)
                        SizedBox(height: 200,),
                        Container(
                          height: screenWidth.value<=CustomScreenWidth().smallSize ?
                          200 : 130,
                          width: screenWidth.value,
                          color: Colors.black,
                          child: Text(a.info.value.replaceAll('뷁', "\n"),style: TextStyle(color: Colors.white),)
                        )
                      ],
                    ))),
          );
        },
      );
    },
        onLoading: Center(
            child: Container(
                height: 50, width: 50, child: CircularProgressIndicator())));
  }

  List<Widget> createButton(int a, int b, BuildContext context) {
    int length = m.menus.length;
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
        child: Text(menus[i].name!,
            style: TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.bold)),
      ));
    }
    return list;
  }
}
