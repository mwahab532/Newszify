import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:mynewsapp/models/NewschannelsApis.dart';
import 'package:mynewsapp/models/catagoricesModel.dart';

class NewsApiRepo {
  Future<newschannelsApisModels?> getNewsheadlines(String channelname) async {
    String apiendpoint =
        "https://newsapi.org/v2/top-headlines?sources=$channelname&apiKey=Apikey";
    try {
      final response = await http.get(Uri.parse(apiendpoint));
      if (kDebugMode) {
        print(response.body);
      }
      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        return newschannelsApisModels.fromJson(body);
      } else {
        throw Exception("Something went wrong! No Data is avialble right now");
      }
    } catch (e) {
      print("error:$e");
    }
    return null;
  }

  Future<CategoriesModel> FetchnewsCatagorices(String category) async {
    String apiendpoint =
        "https://newsapi.org/v2/everything?q=$category&apiKey=ApiKey";
    try {
      final response = await http.get(Uri.parse(apiendpoint));
      if (kDebugMode) {
        print(response.body);
      }
      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        return CategoriesModel.fromJson(body);
      } else {
        throw Exception("Something went wrong! No Data is avialble right now");
      }
    } catch (e) {
      print("error:$e");
    }
    return FetchnewsCatagorices(category);
  }
}
