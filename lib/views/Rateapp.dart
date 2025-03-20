import 'package:animated_rating_stars/animated_rating_stars.dart';
import 'package:flutter/material.dart';
import 'package:mynewsapp/style/style.dart';


class Rateatheapp extends StatefulWidget {
  const Rateatheapp({super.key});

  @override
  State<Rateatheapp> createState() => _RateatheappState();
}

class _RateatheappState extends State<Rateatheapp> {
  double _rating = 1;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Rate the App",
          style: Titletextstyle,
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Rating: $_rating',
              style: const TextStyle(fontSize: 24.0),
            ),
            AnimatedRatingStars(
              initialRating: 1,
              onChanged: (rating) {
                setState(() {
                  _rating = rating;
                });
              },
              displayRatingValue: true,
              interactiveTooltips: true,
              customFilledIcon: Icons.star,
              customHalfFilledIcon: Icons.star_half,
              customEmptyIcon: Icons.star_border,
              starSize: 30.0,
              animationDuration: const Duration(milliseconds: 500),
              animationCurve: Curves.easeInOut,
            ),
          ],
        ),
      ),
    );
  }
}
