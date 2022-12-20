import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_quill/flutter_quill.dart' as Quill hide Text;
import 'package:get_storage/get_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:hangil/components/custom_logo.dart';
import 'package:hangil/controller/admin_controller.dart';
import 'package:hangil/controller/menu_controller.dart';
import 'package:hangil/controller/product_controller.dart';
import 'package:hangil/model/menu.dart';
import 'package:hangil/util/custom_screen_width.dart';
import 'package:intl/intl.dart';

class DetailPage extends GetView<ProductController> {
  DetailPage({this.param,this.index});
  String? param;
  String? index;

  final _selections = <bool>[].obs;
  final screenHeight = Get.height.obs;
  final screenWidth = Get.width.obs;
  AdminController a = Get.put(AdminController());
  ProductController p = Get.put(ProductController());
  MenuController m = Get.put(MenuController());
  bool isDesktop = GetPlatform.isDesktop;
  final isReverse = false.obs;
  Quill.QuillController _controller = Quill.QuillController.basic();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  List<bool> priceList = [];
  bool priceIsNumber = true;
  @override
  Widget build(BuildContext context) {
    print(MediaQuery.of(context).size.width);
    // if(screenWidth.value<MediaQuery.of(context).size.width) {
    screenWidth.value = MediaQuery.of(context).size.width;
    screenHeight.value = MediaQuery.of(context).size.height;
    //  }
    return controller.obx((state) {
      if(p.product.value.id==null){
        p.findById(param!);
      }
        return Obx(() {
          if (p.isLoading.value) {
            return Center(
                child: Container(
                    height: 50, width: 50, child: CircularProgressIndicator()));
          }else {
            priceList.clear();
             int length = m.menus.length;
            // _selections.value = List.generate(length, (index) => false);
            // param = param ?? "0";
            // _selections.length != 0 ? _selections[int.parse(param!)] = true : null;
            //nowCategory =_selections.length!=0? m.menus[int.parse(param!)].id:null;
            //p.changeCategory(int.parse(param!));

              try {
                int.parse(p.product.value.price!);
               priceIsNumber=true;
              } catch (e) {
                priceIsNumber=false;
              }

            _controller = Quill.QuillController(
                document: Quill.Document.fromJson(jsonDecode(p.product.value.body!)),
                selection: TextSelection.collapsed(offset: 0));
            return SafeArea(
            child: Scaffold(
              key: _scaffoldKey,
              drawer: Drawer(width: screenWidth.value,
                child: SingleChildScrollView(
                  child: Padding(
                    padding:EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                child: Column(children: [
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
                          right: 20, top: 20, bottom: 10, left: 20),
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
                  GetStorage().read("id") ==
                      "fn34nfnv8avf9ni30an"
                      ? Row(
                    children: [
                      TextButton(
                          onPressed: () {
                            context.goNamed("/update",params: {"id":param!,"index":index!});
                            //Get.rootDelegate.toNamed("/update");
                          },
                          child: Text("수정")),
                      TextButton(
                          onPressed: () async {
                            await p.delete(p.product.value.id!,index!);
                            p.changeCategory(int.parse(index!));
                            context.go("/");
                            //Get.rootDelegate.toNamed("/");
                          },
                          child: Text("삭제")),
                    ],
                  )
                      : Container(),
                  Container(
                      width: screenWidth.value,
                      child: Divider(height: 1,

                      )),
                  Row(crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(flex: 2,
                        child: ConstrainedBox(constraints: BoxConstraints.tightFor(height: screenHeight.value),
                          child: Container(
                            child: GridView.builder(
                              padding: const EdgeInsets.all(0),
                              //physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: p.product.value.imageUrls!.length,
                              gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount:  2,
                                crossAxisSpacing: 1,
                                mainAxisSpacing: 1,
                                childAspectRatio: 0.8,
                              ),
                              itemBuilder: (context, index) {
                                    return CachedNetworkImage(
                                        imageUrl:
                                        p.product.value.imageUrls![index],
                                        imageBuilder:
                                            (context, imageProvider) =>
                                            Container(
                                              decoration: BoxDecoration(
                                                image: DecorationImage(
                                                  image: imageProvider,
                                                  fit: BoxFit.cover,
                                                  // colorFilter:
                                                  // ColorFilter.mode(Colors.red, BlendMode.colorBurn)
                                                ),
                                              ),
                                            ),
                                        //placeholder: (context, url) => CircularProgressIndicator(),
                                        errorWidget: (context, url, error) =>
                                            Icon(Icons.error),
                                      );
                              },
                            ),
                          ),
                        ),
                      ),SizedBox(width: 30,),
                      Expanded(flex: 1,
                        child: Container(
                          height: screenHeight.value,
                          child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(p.product.value.name!,style: TextStyle(fontSize: 40,fontWeight: FontWeight.bold),),
                              SizedBox(height: 10,),
                              Text(priceIsNumber ? NumberFormat("###,###,### 원").format(int.parse(
                                    p.product.value.price!))
                                    : p.product.value.price!,
                                  style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 40,),
                              Container(
                               // width: screenWidth / 1,
                                height: screenHeight / 1.7,
                                child: Quill.QuillEditor(
                                  scrollController: ScrollController(),
                                  scrollable: true,
                                  focusNode: FocusNode(),
                                  autoFocus: false,
                                  expands: false,
                                  padding: EdgeInsets.zero,
                                  controller: _controller,
                                  readOnly: true, // true for view only mode
                                ),
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 100,)
                  ,Container(
                      height: screenWidth.value<=CustomScreenWidth().smallSize ?
                      200 : 100,
                      width: screenWidth.value,
                      color: Colors.black,
                      child: Text(a.info.value.replaceAll('뷁', "\n"),style: TextStyle(color: Colors.white),)
                  )
                ]),
              ),
            ),
          );
          }
        });

    });
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
            primary:  Colors.transparent ,
            shadowColor: Colors.transparent,
            onPrimary: Colors.black),
        onPressed: () {
          // for (int j = 0; j < _selections.length; j++) {
          //   _selections[j] = i == j;
          // }
          //nowCategory = menus[i].id;
          // p.changeCategory(i);
          //_search.clear();
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
