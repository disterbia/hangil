import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:hangil/view/admin_page.dart';
import 'package:hangil/view/home_page.dart';
import 'package:hangil/view/test4.dart';

class MyRoutes {
  static const HOME = '/';
  static const HOME2 = '/home/:index';
  static const ADMIN = '/mj';
  static const TEST4 = '/test4';
}

class MyPages {
  static late final  router = GoRouter(
    redirect: (state){
      if(state.subloc=="/") return '/home/0';
    },
    errorBuilder: (context, state) => Container(),
    routes: [
      GoRoute(
        path: MyRoutes.HOME,
        builder: (context, state) => HomePage()
      ),
      GoRoute(
          path: MyRoutes.HOME2,
          builder: (context, state) => HomePage(param:state.params['index'])
      ),
      GoRoute(
          path: MyRoutes.ADMIN,
          builder: (context, state) => AdminPage()
      ),
      GoRoute(
          path: MyRoutes.TEST4,
          builder: (context, state) => Test4()
      ),
    ],
  );
}