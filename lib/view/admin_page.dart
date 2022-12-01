import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hangil/components/custom_text_form_field.dart';
import 'package:hangil/controller/menu_controller.dart';
import 'package:hangil/controller/product_controller.dart';
import 'package:hangil/model/menu.dart';
import 'package:hangil/util/text_validate.dart';

class AdminPage extends GetView<MenuController> {
  MenuController m = Get.put(MenuController());
  ProductController p = Get.put(ProductController());
  List<TextEditingController> _menuControllerList = [];
  final _formKey = GlobalKey<FormState>();
  final textFormList = <Widget>[].obs;
  final textList = <Widget>[].obs;
  RxBool visible = false.obs;
  TextEditingController t = TextEditingController();

  List<String> deleteList = [];

  Widget menuTextForm(int index) {
    return CustomTextFormField(
      controller: _menuControllerList[index],
      hint: "카테고리 이름",
      funValidator: validateContent(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(
      body: SingleChildScrollView(
        child: controller.obx((state) {
          _menuControllerList = [];
          textFormList.value =[];
          textList.value=[];
          visible.value = false;
          for (int i = 0; i < m.menus.length; i++) {
            //if(length<=_menuControllerList.length) break;
            _menuControllerList.add(TextEditingController());
            _menuControllerList[i].text = m.menus[i].name!;
            textList.add(Text(m.menus[i].name!,style: TextStyle(fontSize: 20),));
            textFormList.add(menuTextForm(i));
          }
          return Obx(() => Column(
                children: [
                  ElevatedButton(
                      onPressed: () {
                        visible.value = !visible.value;
                      },
                      child: Text(visible.value ? "취소" : "메뉴수정")),
                  Form(
                    key: _formKey,
                    child: Container(
                        height: 100,
                        child: Center(
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: textFormList.length,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) {
                              return Row(
                                children: [
                                  visible.value?textList[index]:textFormList[index],
                                  visible.value
                                      ? TextButton(
                                          onPressed: () {
                                            showDialog(
                                                context: context,
                                                builder: (context) => AlertDialog(
                                                      title: Text("삭제 확인"),
                                                      content: Text(
                                                          "해당 카테고리에 포함된 모든 상품들이 삭제됩니다."),
                                                      actions: [
                                                        TextButton(
                                                          child: Text("OK"),
                                                          onPressed: () async{
                                                            await m.delete(m.menus[index].id!);
                                                            await m.findAll();
                                                            visible.value = false;
                                                            return Navigator.of(context).pop();
                                                          },
                                                        ),
                                                        TextButton(
                                                            onPressed: () {
                                                              return Navigator.of(context).pop();
                                                            },
                                                            child: Text("Cancel"))
                                                      ],
                                                    ));
                                          },
                                          child: Text("삭제"),
                                        )
                                      : Container(),
                                  visible.value &&
                                          index == textFormList.length - 1
                                      ? TextButton(
                                          onPressed: () {
                                            showDialog(
                                                context: context,
                                                builder: (context) => AlertDialog(
                                                  title: Text("메뉴 추가"),
                                                  content: CustomTextFormField(
                                                    hint: "카테고리 이름",
                                                    controller: t,
                                                    funSubmit: validateContent(),
                                                  ),
                                                  actions: [
                                                    TextButton(
                                                      child: Text("완료"),
                                                      onPressed: () async{
                                                         Navigator.of(context).pop();
                                                        await m.save(t.text);
                                                        await m.findAll();
                                                        visible.value = false;
                                                        return;
                                                      },
                                                    ),
                                                    TextButton(
                                                        onPressed: () {
                                                          return Navigator.of(context).pop();
                                                        },
                                                        child: Text("Cancel"))
                                                  ],
                                                ));
                                          },
                                          child: Text("추가하기"))
                                      : Container(),
                                  VerticalDivider()
                                ],
                              );
                            },
                          ),
                        )),
                  ),

                  visible.value ? Container() :
                  ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          for (int i = 0; i < textFormList.length; i++) {
                              await m.updateMenu(Menu(id: m.menus[i].id, name: _menuControllerList[i].text));
                              await m.findAll();
                          }
                        }
                        //await m.findAll();
                      },
                      child: Text("적용")),
                  Divider(color: Colors.black,),
                  Row(children: [
                    Expanded(child: Container(color: Colors.red,height: 1000,)),
                    Expanded(child: Container(color: Colors.blue,height: 1000,))
                  ],)
                ],
              ));
        }),
      ),
    ));
  }
}
