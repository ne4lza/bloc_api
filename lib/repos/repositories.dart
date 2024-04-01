import 'dart:convert';

import 'package:bloc_api/models/user_model.dart';
import 'package:http/http.dart' as http;

class UserRepository{
  //https://reqres.in/api/users?page=2c
  String endPoint = "https://reqres.in/api/users?page=2c";
  Future<List<UserModel>> getUsers() async {
    http.Response response = await http.get(Uri.parse(endPoint));
    if(response.statusCode == 200){
      final List result = jsonDecode(response.body)['data'];
      return result.map((e) => UserModel.fromJson((e))).toList();
    }else{
      throw Exception(response.reasonPhrase);
    }
  }
}