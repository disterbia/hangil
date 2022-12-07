import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_quill/flutter_quill.dart' as Quill hide Text;
import 'package:hangil/components/custom_logo.dart';
import 'package:hangil/controller/product_controller.dart';

class DetailPage extends GetView<ProductController> {
  DetailPage({this.param});

  String? param;
  ProductController p = Get.put(ProductController());
  bool isDesktop = GetPlatform.isDesktop;
  final screenHeight = Get.height.obs;
  final screenWidth = Get.width.obs;
  Quill.QuillController _controller = Quill.QuillController.basic();

  @override
  Widget build(BuildContext context) {
    if(screenWidth.value<MediaQuery.of(context).size.width) {
      screenWidth.value = MediaQuery.of(context).size.width;
    }
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
            _controller = Quill.QuillController(
                document: Quill.Document.fromJson(jsonDecode(p.product.value.body!)),
                selection: TextSelection.collapsed(offset: 0));
            return SafeArea(
            child: Scaffold(
              body: SingleChildScrollView(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Column(children: [
                    ConstrainedBox(constraints: BoxConstraints(
                  maxWidth: screenWidth.value,
                  ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(),
                          CustomLogo(),
                          Container(
                              child: IconButton(
                            onPressed: () {},
                            icon: Image.asset("assets/kakao.png"),
                            iconSize: 70,
                          )),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        Container(
                          width: screenWidth * 0.66,
                          child: GridView.builder(
                            padding: const EdgeInsets.all(10.0),
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: p.product.value.imageUrls!.length,
                            gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount:  2,
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 20,
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
                        Container(
                          width: screenWidth * 0.33,
                          child: Column(
                            children: [
                              Text(p.product.value.name!),
                              Container(
                                width: screenWidth / 2,
                                height: screenHeight / 2,
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
                        )
                      ],
                    )
                  ]),
                ),
              ),
            ),
          );
          }
        });

    });
  }
}
