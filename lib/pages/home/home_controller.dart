import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'dart:io';

import 'package:rk_solucoes/models/application_colors.dart';

class HomeController extends GetxController {
  String _currentPath;
  File _oldFile;
  File _newFile;

  final _numberOfColumns = Rx<int>(13);
  final isLoading = Rx<bool>(false);

  String get numberOfColumns => _numberOfColumns.value.toString();

  void addColumns() => _numberOfColumns.value += 1;

  void removeColumns() {
    if (_numberOfColumns.value > 0) {
      _numberOfColumns.value -= 1;
    }
  }

  @override
  void onInit() {
    _currentPath = Directory.current.path;
    _oldFile = File("$_currentPath\\arquivo_que_será_convertido.txt");
    _newFile = File("$_currentPath\\resultado.txt");
    super.onInit();
  }

  Future<void> convertFile() async {
    isLoading.value = true;

    List listOfLinesInFile;
    try {
      print(_currentPath);
      listOfLinesInFile = _oldFile.readAsLinesSync();

      await Future(() {
        for (var item in listOfLinesInFile) {
          _newFile.writeAsStringSync(
            '$item\n'
                .replaceAll(" ", "")
                .padLeft(_numberOfColumns.value + 1, "0"),
            mode: FileMode.append,
          );
        }

        Get.back();
      });

      showSnackSuccessBar();
    } catch (_) {
      Get.back();
      showErrorSnackBar();
    } finally {
      isLoading.value = false;
    }
  }

  void showSnackSuccessBar() {
    Get.showSnackbar(
      GetBar(
        snackPosition: SnackPosition.TOP,
        title: 'Sucesso!',
        message: 'Arquivo convertido com sucesso!',
        backgroundColor: ApplicationColors.green,
        duration: Duration(seconds: 4),
        borderRadius: 20,
        margin: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      ),
    );
  }

  void showErrorSnackBar() {
    Get.showSnackbar(
      GetBar(
        snackPosition: SnackPosition.TOP,
        title: 'Ocorreu um erro!',
        message: 'Não foi possivel fazer a conversão, porfavor tente novamente',
        backgroundColor: ApplicationColors.red,
        duration: Duration(seconds: 4),
        borderRadius: 20,
        margin: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      ),
    );
  }
}
