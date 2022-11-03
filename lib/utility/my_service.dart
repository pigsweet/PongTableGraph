import 'package:dio/dio.dart';

class MyService {
  Future<void> insertNumber({required String number}) async {
    String urlApi =
        'https://www.androidthai.in.th/fluttertraining/insertNumberPong.php?isAdd=true&number=$number';

    await Dio().get(urlApi).then((value) => print('Insert Number Success'));
  }
}
