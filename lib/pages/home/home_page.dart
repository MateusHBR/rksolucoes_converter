import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'home_controller.dart';

class HomePage extends StatelessWidget {
  static const homePage = '/home';

  final HomeController _controller;

  const HomePage({
    Key key,
    @required HomeController controller,
  })  : _controller = controller,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'RK Soluções LTDA',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
      ),
      body: Container(
        width: size.width,
        height: size.height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Número de colunas desejadas:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  color: Colors.black,
                  icon: Icon(Icons.remove),
                  onPressed: _controller.removeColumns,
                ),
                SizedBox(width: 20),
                Obx(
                  () => Text(
                    _controller.numberOfColumns,
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ),
                SizedBox(width: 20),
                IconButton(
                  color: Colors.black,
                  icon: Icon(Icons.add),
                  onPressed: _controller.addColumns,
                ),
              ],
            ),
            SizedBox(height: 80),
            _convertButton(),
          ],
        ),
      ),
    );
  }

  Widget _convertButton() {
    return ElevatedButton(
      style: ButtonStyle(
        padding: MaterialStateProperty.all(
          EdgeInsets.symmetric(horizontal: 50, vertical: 20),
        ),
      ),
      child: Text(
        'Converter',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.white,
          fontSize: 18,
        ),
      ),
      onPressed: () async {
        _showDialog();
        await _controller.convertFile();
      },
    );
  }

  void _showDialog() {
    Get.dialog(
      Center(
        child: Container(
          child: CircularProgressIndicator(),
        ),
      ),
      barrierDismissible: false,
    );
  }
}
