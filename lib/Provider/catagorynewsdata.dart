import 'package:flutter/material.dart';
import 'package:mynewsapp/models/catagoricesModel.dart';
import 'package:mynewsapp/services/Newsapi.dart';

class Catagorynewsdata extends ChangeNotifier {
  NewsApiRepo _newsApiRepo = NewsApiRepo();
  CategoriesModel? _catagorynewsdata;
    bool isDataFetched = false;
  bool _isloading = false;
  bool get isloading => _isloading;
  CategoriesModel? get catagorynewsdata => _catagorynewsdata;

  Future<void> fetchcatagorydata(String category) async {
    _isloading = true;
    notifyListeners();
    try {
      _catagorynewsdata = await _newsApiRepo.FetchnewsCatagorices(category);
      isDataFetched = true;
    } catch (e) {
      isDataFetched = false;
      throw Exception("Error: $e");
    } finally {
      _isloading = false;
      notifyListeners();
    }
  }
}