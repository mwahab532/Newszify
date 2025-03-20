import 'package:flutter/material.dart';
import 'package:mynewsapp/models/NewschannelsApis.dart';
import 'package:mynewsapp/services/Newsapi.dart';

class Newsapiprovider extends ChangeNotifier {
  NewsApiRepo _newsApiRepo = NewsApiRepo();
  newschannelsApisModels? _newsdata;
  bool _isloading = false;
  bool isDataFetched = false;
  newschannelsApisModels? get newsdata => _newsdata;
  bool get isloading => _isloading;
  void setLoading(bool value) {
    _isloading = value;
    notifyListeners();
  }

  void setDataFetched(bool value) {
    isDataFetched = value;
    notifyListeners();
  }
  Future<void> fetchnewsdata(String channelname) async {
    _isloading = true;
    notifyListeners();
    try {
      _newsdata = await _newsApiRepo.getNewsheadlines(channelname);
      isDataFetched = true;
    } catch (e) {
      throw Exception(e);
    } finally {
      _isloading = false;
      notifyListeners();
    }
  }
}
