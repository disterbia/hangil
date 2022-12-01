import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:hangil/view/admin_page.dart';
import 'package:hangil/view/home_page.dart';

class MyRoutes {
  static const HOME = '/';
  static const ADMIN = '/mj';
}

class MyPages {
  static late final  router = GoRouter(

    errorBuilder: (context, state) => Container(),
    routes: [
      GoRoute(
        path: MyRoutes.HOME,
        builder: (context, state) => HomePage()
      ),
      GoRoute(
          path: MyRoutes.ADMIN,
          builder: (context, state) => AdminPage()
      ),
    ],
  );
}