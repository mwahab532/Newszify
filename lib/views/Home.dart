import 'package:flutter/material.dart';
import 'package:mynewsapp/views/News.dart';
import 'package:mynewsapp/views/Newscartagorices.dart';
import 'package:mynewsapp/views/profile.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _currentIndex = 0;
  List<Widget> screen = [News(), Categories(),ProfileScreen()];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screen[_currentIndex],
      bottomNavigationBar: SalomonBottomBar(
        currentIndex: _currentIndex,
        onTap: (i) => setState(() => _currentIndex = i),
        items: [
          SalomonBottomBarItem(
            icon: Icon(Icons.home),
            title: Text("Home"),
          ),
          SalomonBottomBarItem(
            icon: Icon(Icons.category_sharp),
            title: Text("Catagorices"),
          ),
          SalomonBottomBarItem(
            icon: Icon(Icons.person),
            title: Text("Profile"),
          ),
        ],
      ),
    );
  }
}
