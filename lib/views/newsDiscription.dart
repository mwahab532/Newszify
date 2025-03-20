import 'package:flutter/material.dart';
import 'package:mynewsapp/models/NewschannelsApis.dart';
import 'package:url_launcher/url_launcher.dart';

class NewsDescription extends StatelessWidget {
 final Articles articles;
  const NewsDescription({Key? key, required this.articles}) : super(key: key);

  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.inAppBrowserView)) {
      throw "Could not launch $url";
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        extendBody: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: Text("News Details", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image.network(
                  articles.urlToImage ??
                      "https://static.vecteezy.com/system/resources/previews/022/059/000/non_2x/no-image-available-icon-vector.jpg",
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Icon(Icons.broken_image, size: 100),
                ),
              ),
              SizedBox(height: 16),
              Text(
                articles.title ?? "No title available",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                articles.description ?? "No description available",
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.justify,
              ),
              SizedBox(height: 20),
              Center(
                child: ElevatedButton.icon(
                  label: Text("To Learn More, Click Here"),
                  icon: Icon(Icons.link),
                  onPressed: () {
                    if (articles.url != null) {
                      _launchURL(articles.url.toString());
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("URL not available for this article.")),
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
