import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mynewsapp/models/catagoricesModel.dart';
import 'package:mynewsapp/views/CatagroicesNewsDiscrip.dart';

Widget catagoricesbuildnewsUI(
  BuildContext context,
  Article articles,
  int index,
) {
  DateTime dateTime = DateTime.parse(articles.publishedAt.toString());
  final format = DateFormat("dd,MMMM,yyyy");
  return Container(
    width: MediaQuery.of(context).size.width,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: () {
            final route = MaterialPageRoute(
              builder: (context) => Catagroicesnewsdiscrip(
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
        SizedBox(height: 7),
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
                  fontSize: 15,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
        SizedBox(
          height: 8,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                format.format(dateTime),
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
              Text(
                articles.title.toString(),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 17.0,
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 12,
        )
      ],
    ),
  );
}
