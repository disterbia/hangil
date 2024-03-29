import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CustomLogo extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MouseRegion(cursor: SystemMouseCursors.click,
      child: GestureDetector(
          onTap: () => context.go("/"),
          child: Image.asset("assets/logo.png",height: 80,)),
    );
  }
}