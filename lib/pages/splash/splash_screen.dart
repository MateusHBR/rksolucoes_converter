import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rk_solucoes/images/images.dart';
import 'package:rk_solucoes/pages/home/home_page.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late Animation _animation;
  late AnimationController _animationController;

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1500),
    )..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          Get.offAndToNamed(HomePage.homePage);
        }
      });

    _animation = Tween(
      begin: 0.0,
      end: 1.0,
    ).animate(_animationController);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _animationController.forward();

    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        child: Center(
          child: FadeTransition(
            opacity: _animationController,
            child: Image.asset(
              Images.logo,
            ),
          ),
        ),
      ),
    );
  }
}
