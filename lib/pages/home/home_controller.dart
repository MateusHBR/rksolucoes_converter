import 'dart:io';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart' as path;
import 'package:flutter/rendering.dart';
import 'package:file_picker/file_picker.dart';
import 'package:rk_solucoes/models/application_colors.dart';

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

  Future<File?> pickFile() async {
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
    final splitted_file_path = _oldFile.value!.path.split(getPlatformDivider())
      ..removeLast()
      ..add('rk_convert_result.txt');
    final destination = splitted_file_path.join(getPlatformDivider());
    print(destination);
    final newFile = File(destination);
    isLoading.value = true;

    try {
      print(_oldFile.value!.path);

      final listOfLinesInFile = await _oldFile.value!.readAsLines();

      for (var item in listOfLinesInFile) {
        await newFile.writeAsString(
          '$item\n'
              .replaceAll(" ", "")
              .padLeft(_numberOfColumns.value + 1, "0"),
          mode: FileMode.write,
        );
      }
      Get.back();

      showSnackSuccessBar();
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
