import 'package:flutter/material.dart';
import 'package:mynewsapp/Provider/faviroteprovider.dart';
import 'package:mynewsapp/Provider/newsapipeovider.dart';
import 'package:mynewsapp/fillterbuttion.dart';
import 'package:mynewsapp/style/style.dart';
import 'package:mynewsapp/widgets/ShimerList.dart';
import 'package:mynewsapp/widgets/customnews.dart';
import 'package:provider/provider.dart';

class News extends StatefulWidget {
  News({Key? key}) : super(key: key);

  @override
  State<News> createState() => _NewsState();
}

class _NewsState extends State<News> {
  String channelname = 'bbc-news';

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<Newsapiprovider>(context, listen: false);
      if (!provider.isDataFetched) {
        provider.setLoading(true); // Set loading to true
        provider.fetchnewsdata(channelname).then((_) {
          provider
              .setLoading(false); // Set loading to false after data is fetched
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: true,
      child: Scaffold(
        extendBody: true,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.transparent,
          title: Text(
            "Top News headlines",
            style: Titletextstyle,
          ),
          actions: [
            Consumer<Newsapiprovider>(
              builder: (context, newsProvider, _) {
                return PopupMenuButton<FilterButtonList>(
                  icon: const Icon(Icons.more_vert),
                  onSelected: (FilterButtonList item) {
                    String channelname;
                    switch (item) {
                      case FilterButtonList.bbcNews:
                        channelname = 'bbc-news';
                        break;
                      case FilterButtonList.abcNews:
                        channelname = 'abc-news';
                        break;
                      case FilterButtonList.associatedpress:
                        channelname = 'associated-press';
                        break;
                      case FilterButtonList.bloomberg:
                        channelname = 'bloomberg';
                        break;
                      case FilterButtonList.aljazeeraEnglish:
                        channelname = 'al-jazeera-english';
                        break;
                      case FilterButtonList.businessInsider:
                        channelname = 'business-insider';
                        break;
                      case FilterButtonList.cnn:
                        channelname = 'cnn';
                        break;
                    }
                    newsProvider.setLoading(true); // Set loading to true
                    newsProvider.fetchnewsdata(channelname).then((_) {
                      newsProvider.setLoading(
                          false); // Set loading to false after data is fetched
                    });
                  },
                  itemBuilder: (context) => <PopupMenuEntry<FilterButtonList>>[
                    const PopupMenuItem(
                      value: FilterButtonList.bbcNews,
                      child: Text("BBC News"),
                    ),
                    const PopupMenuItem(
                      value: FilterButtonList.abcNews,
                      child: Text("ABC News"),
                    ),
                    const PopupMenuItem(
                      value: FilterButtonList.associatedpress,
                      child: Text("Associated Press"),
                    ),
                    const PopupMenuItem(
                      value: FilterButtonList.bloomberg,
                      child: Text("Bloomberg"),
                    ),
                    const PopupMenuItem(
                      value: FilterButtonList.businessInsider,
                      child: Text("Business Insider"),
                    ),
                    const PopupMenuItem(
                      value: FilterButtonList.aljazeeraEnglish,
                      child: Text("Al Jazeera"),
                    ),
                    const PopupMenuItem(
                      value: FilterButtonList.cnn,
                      child: Text("CNN"),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
        body: Consumer<Newsapiprovider>(
          builder: (context, provider, child) {
            if (provider.isloading) {
              return const ShimmerList();
            }
            if (provider.newsdata == null ||
                provider.newsdata!.newsarticles == null) {
              return provider.isDataFetched
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Unable to load data at the moment! Try again',
                            style: errortextstyle,
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    )
                  : const ShimmerList();
            }
            final articles = provider.newsdata!.newsarticles!;
            return RefreshIndicator(
              onRefresh: () async {
                await Future.delayed(Duration(seconds: 5));
                await provider.fetchnewsdata(channelname);
              },
              child: ListView.builder(
                itemCount: articles.length,
                itemBuilder: (context, index) {
                  final article = articles[index];
                  return Consumer<FavoriteProvider>(
                    builder: (context, favoriteProvider, _) {
                      return buildNewsUI(
                        context,
                        article,
                        index,
                        favoriteProvider,
                      );
                    },
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
