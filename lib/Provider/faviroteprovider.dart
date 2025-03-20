import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mynewsapp/models/NewschannelsApis.dart';

class FavoriteProvider extends ChangeNotifier {
  final Set<Articles> _favoriteNewsSet = {};
  final Map<int, bool> _isTappedMap = {};
  String _selectedChannelName = '';

  List<Articles> get favoriteNewsList => _favoriteNewsSet.toList();
  bool isTapped(int index) => _isTappedMap[index] ?? false;
  String get selectedChannelName => _selectedChannelName;

  FavoriteProvider() {
    _loadFavorites(); // Load favorites on startup
  }

  // 🔹 Toggle Favorite and Store in SharedPreferences
  void toggleFavoriteStatus(Articles article, int index) async {
    if (_favoriteNewsSet.contains(article)) {
      _favoriteNewsSet.remove(article);
      _isTappedMap[index] = false;
    } else {
      _favoriteNewsSet.add(article);
      _isTappedMap[index] = true;
    }
    await _saveFavorites(); // Save updated list
    notifyListeners();
  }

  Future<void> _saveFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final favoriteJson = jsonEncode(_favoriteNewsSet.map((e) => e.toJson()).toList());
    await prefs.setString('favoriteNews', favoriteJson);
  }

  // 🔹 Load Favorite Articles from SharedPreferences
  Future<void> _loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final favoriteJson = prefs.getString('favoriteNews');
    if (favoriteJson != null) {
      final List<dynamic> decodedList = jsonDecode(favoriteJson);
      _favoriteNewsSet.addAll(decodedList.map((e) => Articles.fromJson(e)));
      notifyListeners();
    }
  }

  void setFilter(String channelFilter) {
    _selectedChannelName = channelFilter;
    notifyListeners();
  }

  List<Articles> get filteredNews {
    if (_selectedChannelName.isEmpty) {
      return favoriteNewsList;
    }
    return _favoriteNewsSet
        .where((article) => article.source?.name == _selectedChannelName)
        .toList();
  }
}
