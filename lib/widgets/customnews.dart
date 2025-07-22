import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mynewsapp/Provider/faviroteprovider.dart';
import 'package:mynewsapp/models/NewschannelsApis.dart';
import 'package:mynewsapp/views/newsDiscription.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:share_plus/share_plus.dart';

Widget buildNewsUI(BuildContext context, Articles articles, int index,
    FavoriteProvider favirote,
    {int? selectedIndex}) {
  if (selectedIndex != null && selectedIndex != index) {
    return SizedBox.shrink(); // Return an empty widget if not matching
  }

  DateTime dateTime = DateTime.parse(articles.publishedAt.toString());
  final format = DateFormat("dd, MMMM yyyy");

  bool isFavorite =
      favirote.favoriteNewsList.any((item) => item.title == articles.title);

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => NewsDescription(
                articles: articles,
              ),
            ),
          );
        },
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20.0),
          child: CachedNetworkImage(
            imageUrl: articles.urlToImage != null &&
                    articles.urlToImage!.isNotEmpty
                ? articles.urlToImage!
                : "https://static.vecteezy.com/system/resources/previews/022/059/000/non_2x/no-image-available-icon-vector.jpg",
            height: 200.0,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
        ),
      ),
      SizedBox(height: 8.0),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: Container(
              padding: EdgeInsets.all(6.0),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(30.0),
              ),
              child: Text(
                articles.source?.name ?? "Unknown Source",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
            ElevatedButton(
            child: Text("Share"),
            onPressed: () {
              Share.share(articles.url ?? "No URL Available");
            },
          ),
          IconButton(
            icon: isFavorite
                ? Icon(Icons.bookmark, color: Colors.red)
                : Icon(Icons.bookmark),
            onPressed: () {
              favirote.toggleFavoriteStatus(articles, index);
            },
          ),
        ],
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              format.format(dateTime),
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              articles.title ?? "No Title Available",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
            ),
          ],
        ),
      ),
      SizedBox(height: 12.0),
    ],
  );
}
