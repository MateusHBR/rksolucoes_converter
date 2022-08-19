import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rk_solucoes/pages/home/home_page.dart';
import 'package:window_manager/window_manager.dart';
import 'bindings/application_bindings.dart';
import 'bindings/home_binding.dart';
import 'pages/splash/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();

  final appSize = Size(800, 600);
  WindowOptions windowOptions = WindowOptions(
    size: appSize,
    minimumSize: appSize,
    maximumSize: appSize,
    center: true,
    backgroundColor: Colors.transparent,
    skipTaskbar: false,
    titleBarStyle: TitleBarStyle.normal,
    title: 'RK Soluções',
  );

  windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
    await windowManager.focus();
  });

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final virtualWindowFrameBuilder = VirtualWindowFrameInit();

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialBinding: ApplicationBindings(),
      title: 'Flutter Demo',
      theme: ThemeData(primarySwatch: Colors.grey),
      home: SplashScreen(),
      builder: ((context, child) {
        return virtualWindowFrameBuilder(context, child);
      }),
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
