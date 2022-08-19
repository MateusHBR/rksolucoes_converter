import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rk_solucoes/pages/home/home_page.dart';

import 'bindings/application_bindings.dart';
import 'bindings/home_binding.dart';
import 'pages/splash/splash_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialBinding: ApplicationBindings(),
      title: 'Flutter Demo',
      theme: ThemeData(primarySwatch: Colors.grey),
      home: SplashScreen(),
      getPages: [
        GetPage(
          name: HomePage.homePage,
          page: () => HomePage(
            controller: Get.find(),
          ),
          binding: HomeBinding(),
        ),
      ],
    );
  }
}
