import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/rendering.dart';
import 'package:file_picker/file_picker.dart';
import 'package:rk_solucoes/ffi.dart' as ffi;
import 'package:rk_solucoes/models/application_colors.dart';

const String _kMacOSDestination = "";

class HomeController extends GetxController {
  final _oldFile = Rx<File?>(null);
  final _numberOfColumns = Rx<int>(13);
  final isLoading = Rx<bool>(false);

  String get numberOfColumns => _numberOfColumns.value.toString();

  String? get selectedFilePath => _oldFile.value?.path;

  void addColumns() => _numberOfColumns.value += 1;

  void removeColumns() {
    if (_numberOfColumns.value > 0) {
      _numberOfColumns.value -= 1;
    }
  }

  Future<void> pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.any,
      allowMultiple: false,
      allowCompression: false,
      allowedExtensions: ['txt'],
      dialogTitle: 'Selecione o arquivo que será convertido',
    );

    if (result == null) {
      showNoFileSelectedSnackbar();
      return null;
    }

    _oldFile.value = File(result.files.first.path!);
  }

  void clearSelectedFile() => _oldFile.value = null;

  String getPlatformDivider() => Platform.isWindows ? '\\' : '/';

  Future<void> convertFile() async {
    if (_oldFile.value == null) return;

    final splitted_file_path = _oldFile.value!.path.split(getPlatformDivider());
    final fileName =
        splitted_file_path.removeLast().split('.').join('_result.');
    splitted_file_path.add(fileName);

    late final String destination;
    if (Platform.isMacOS) {
      if (_kMacOSDestination.isEmpty) {
        print("Setup _kMacOSDestination constant to debug");
        showErrorSnackBar();
        return;
      }

      destination = _kMacOSDestination;
    } else {
      destination = splitted_file_path.join(getPlatformDivider());
    }

    final newFile = File(destination);
    isLoading.value = true;

    try {
      await ffi.api.formatFile(
        inputFile: _oldFile.value!.path,
        outputFile: newFile.path,
        numberOfColumns: _numberOfColumns.value,
      );

      Get.back();

      showResultDialog(newFile.path);
    } catch (e) {
      print(e);
      Get.back();
      showErrorSnackBar();
    } finally {
      isLoading.value = false;
    }
  }

  void showNoFileSelectedSnackbar() {
    Get.showSnackbar(
      GetBar(
        snackPosition: SnackPosition.TOP,
        title: 'Informativo!',
        message: 'Nenhum arquivo selecionado!',
        duration: Duration(seconds: 4),
        borderRadius: 20,
        margin: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      ),
    );
  }

  void showResultDialog(String resultado) {
    Get.dialog(
      AlertDialog(
        title: Text("Sucesso!"),
        content: Column(
          children: [
            Text("O arquivo foi convertido com sucesso!"),
            Text("Arquivo resultado: $resultado"),
          ],
        ),
        actions: [
          TextButton(
            onPressed: Get.back,
            child: Text("OK"),
          ),
        ],
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
