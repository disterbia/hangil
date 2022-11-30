import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:hangil/view/home_page.dart';

class MyRoutes {
  static const HOME = '/';
}

class MyPages {
  static late final  router = GoRouter(

    errorBuilder: (context, state) => Container(),
    routes: [
      GoRoute(
        path: MyRoutes.HOME,
        builder: (context, state) => HomePage()
      ),
    ],
  );
}