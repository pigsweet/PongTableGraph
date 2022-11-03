import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:pongtablegraph/models/number_model.dart';

class AppController extends GetxController {
  RxInt indexBodys = 0.obs;
  RxList<NumberModel> numberModels = <NumberModel>[].obs;

  Future<void> readAllNumber() async {
    String urlAPI =
        'https://www.androidthai.in.th/fluttertraining/getAllNumberPong.php';

    if (numberModels.isNotEmpty) {
      numberModels.clear();
    }
    await Dio().get(urlAPI).then((value) {
      print('value frome readAllNumber = $value');

      for (var element in json.decode(value.data)) {
        print("element = $element");

        NumberModel model = NumberModel.fromMap(element);
        numberModels.add(model);
      }
    });
  }
}
