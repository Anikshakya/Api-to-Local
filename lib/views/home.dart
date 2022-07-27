// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:local_api/model/news_api_model.dart';
import 'package:local_api/services/api_to_locale.dart';
import 'package:local_api/services/news_api_service.dart';
import 'package:local_api/tile/news_data_tile.dart';
import 'package:local_api/views/locale_news_page.dart';
import 'package:local_api/views/asset_downloads.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  NewsApi? newsArticle;
  bool _loading = true;

  //GetStorage
  final box = GetStorage();

  ApiToLocale data = ApiToLocale();

  @override
  void initState() {
    GetStorage.init();
    JsonParseService.getData().then((value) {
      setState(() {
        newsArticle = value;
        _loading = false;
        data.writeCounter(value);
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //-----AppBar-----
      appBar: AppBar(
        title: const Text("NewsData From DioCache"),
        centerTitle: true,
      ),
      //-----Drawer-----
      drawer: SafeArea(
        child: Drawer(
          child: ListView(
            // Important: Remove any padding from the ListView.
            padding: const EdgeInsets.all(20),
            children: [
              ListTile(
                leading: const Icon(Icons.newspaper),
                title: const Text(
                  'NewsPage from GetStorage',
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const LocaleNewsPage()));
                },
              ),
              ListTile(
                leading: const Icon(Icons.newspaper),
                title: const Text(
                  'NewsPage from PathProvider',
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () => Navigator.push(context,
                    MaterialPageRoute(builder: (context) => AssetDownloads())),
                child: ListTile(
                  leading: const Icon(Icons.newspaper),
                  title: const Text(
                    'Assets Download and load',
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),

      //-----Body-----
      body: _loading == true && newsArticle == null
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Total News: " + newsArticle!.totalResults.toString()),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: newsArticle!.articles!.length,
                    itemBuilder: (context, index) {
                      return NewsTile(
                        description: newsArticle!.articles![index].description
                            .toString(),
                        image:
                            newsArticle!.articles![index].urlToImage.toString(),
                        title: newsArticle!.articles![index].title.toString(),
                        author: newsArticle!.articles![index].author.toString(),
                        time: newsArticle!.articles![index].publishedAt!
                            .toLocal()
                            .toString(),
                      );
                    },
                  ),
                ],
              ),
            ),
    );
  }
}
