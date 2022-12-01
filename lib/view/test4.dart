import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';

class Test4 extends StatelessWidget {
  QuillController _controller = QuillController.basic();


  @override
  Widget build(BuildContext context) {

    _controller = QuillController(
        document: Document.fromJson(jsonDecode('[{"insert":"tttsㄴㄴfsfsf\\nf"},{"insert":"ffffffff","attributes":{"bold":true}},{"insert":"\\naaaaaaaaaa"},{"insert":"\\n","attributes":{"header":2}}]')),
        selection: TextSelection.collapsed(offset: 0));
    return Scaffold(
      body: Column(
        children: [
          ElevatedButton(onPressed: (){

            var json = jsonEncode(_controller.document.toDelta().toJson());
            // var ajson=json.replaceAll("\\n","\\\\n");
            print(json);
          }, child: Container()),
          //QuillToolbar.basic(controller: _controller,),
          Container(width: 50,
            child: QuillEditor.basic(
              controller: _controller,
              readOnly: true, // true for view only mode
            ),
          )
        ],
      ),
    );
  }
}
