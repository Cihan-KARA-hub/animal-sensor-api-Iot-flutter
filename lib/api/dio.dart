import 'package:dio/dio.dart';

void GetUser() async {
  final String url = 'https://jsonplaceholder.typicode.com/users';
  var dio = Dio();
  var response = await dio.get(url);
  print(response);
}

void createUser() async {
  var response = await Dio().post('https://postman-echo.com/post',
      data: {'int': 1, 'string': 'text'});
  print(response);
}
