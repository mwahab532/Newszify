import 'package:flutter/material.dart';
import 'package:mynewsapp/Provider/catagorynewsdata.dart';
import 'package:mynewsapp/style/style.dart';
import 'package:mynewsapp/widgets/ShimerList.dart';
import 'package:mynewsapp/widgets/catafgorices.dart';
import 'package:provider/provider.dart';

class Categories extends StatefulWidget {
  Categories({super.key});

  @override
  State<Categories> createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {
   String categoryName = "General";
  List<String> categoryList = [
    "General",
    "Business",
    "Sports",
    "Entertainment",
    "Health",
    "Technology",
  ];
 
  @override
  void initState() {
      final provider = Provider.of<Catagorynewsdata>(context, listen: false);
      if (!provider.isDataFetched) {
        provider.fetchcatagorydata(categoryName);
      }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final bool isLightMode = Theme.of(context).brightness == Brightness.light;
    return SafeArea(
      child: Scaffold(
        extendBody: true,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          elevation: 0,
          backgroundColor: Colors.transparent,
          title: Text(
            "News Categories",
            style: searchAppbartextstyle,
          ),
        ),
        body: Column(
          children: [
            SizedBox(
              height: 50,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: categoryList.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      setState(() {
                        categoryName = categoryList[index];
                      });
                      Provider.of<Catagorynewsdata>(context, listen: false)
                          .fetchcatagorydata(categoryName);
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      margin: EdgeInsets.symmetric(horizontal: 5),
                      decoration: BoxDecoration(
                        color: categoryName == categoryList[index]
                            ? Colors.red
                            : isLightMode
                                ? Colors.white
                                : Colors.black,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Center(
                        child: Text(
                          categoryList[index],
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(
              height: 8,
            ),
            Expanded(
              child: Consumer<Catagorynewsdata>(
                builder: (context, provider, child) {
                  if (provider.isloading) {
                    return ShimmerList();
                  }
                  if (provider.catagorynewsdata == null ||
                      provider.catagorynewsdata!.articles == null) {
                    return Center(
                      child: Text(
                        'No news data available',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    );
                  }
                  return ListView.builder(
                    itemCount: provider.catagorynewsdata!.articles!.length,
                    itemBuilder: (context, index) {
                      return catagoricesbuildnewsUI(context,
                          provider.catagorynewsdata!.articles![index], index);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
