import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mynewsapp/Provider/faviroteprovider.dart';
import 'package:mynewsapp/models/NewschannelsApis.dart';
import 'package:mynewsapp/services/Newsapi.dart';
import 'package:mynewsapp/style/style.dart';
import 'package:mynewsapp/views/newsDiscription.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class favorite extends StatelessWidget {
  favorite({super.key});

  NewsApiRepo newsApiRepo = NewsApiRepo();
  Articles? articles;
  @override
  Widget build(BuildContext context) {
    final favirote = Provider.of<FavoriteProvider>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(
          "Saved News",
          style: favoriteappbattextstyle,
        ),
      ),
      body: favirote.favoriteNewsList.isEmpty
          ? Center(
              child: Text(
                "No favirote News is added yet",
                style: favoriteEmptybodytextstyle,
              ),
            )
          : ListView.builder(
              itemCount: favirote.favoriteNewsList.reversed.length,
              itemBuilder: (context, index) {
                final articles = favirote.favoriteNewsList[index];
                DateTime dateTime =
                    DateTime.parse(articles.publishedAt.toString());
                final format = DateFormat("dd,MMMM,yyyy");
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      InkWell(
                        onTap: () {
                          final route = MaterialPageRoute(
                            builder: (context) => NewsDescription(
                              articles: articles,
                            ),
                          );
                          Navigator.push(context, route);
                        },
                        child: Container(
                          height: 200.0,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          child: CachedNetworkImage(
                            imageUrl: articles.urlToImage ??
                                "https://static.vecteezy.com/system/resources/previews/022/059/000/non_2x/no-image-available-icon-vector.jpg",
                            fit: BoxFit.cover,
                            filterQuality: FilterQuality.high,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 8.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: EdgeInsets.all(6.0),
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                            child: Text(
                              articles.source!.name.toString(),
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              favirote.toggleFavoriteStatus(
                                articles,
                                index,
                              );
                            },
                            icon: favirote.favoriteNewsList.contains(articles)
                                ? Icon(
                                    Icons.bookmark_add,
                                    color: Colors.red,
                                  )
                                : Icon(Icons.bookmark_outline),
                          )
                        ],
                      ),
                      Text(format.format(dateTime)),
                      SizedBox(
                        height: 8.0,
                      ),
                      Text(
                        articles.title.toString(),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
