// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:local_api/tile/news_data_tile.dart';

class LocaleNewsPage extends StatefulWidget {
  const LocaleNewsPage({Key? key}) : super(key: key);

  @override
  State<LocaleNewsPage> createState() => _LocaleNewsPageState();
}

class _LocaleNewsPageState extends State<LocaleNewsPage> {
  late final localeData;
  bool? _loading = true;
  @override
  void initState() {
    setState(() {
      // localeData = NewsApi.fromJson(box.read('localeStorage'));
      localeData = box.read('localeStorage');
      _loading = false;
    });
    // GetStorage.init();
    super.initState();
  }

  //GetStorage
  final box = GetStorage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //-----AppBar-----
      appBar: AppBar(
        title: const Text("NewsData from GetStorage"),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),

      //-----Body-----
      body: _loading == true
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              shrinkWrap: true,
              itemCount: localeData.articles.length,
              itemBuilder: (context, index) {
                return NewsTile(
                  description:
                      localeData!.articles![index].description.toString(),
                  image: localeData!.articles![index].urlToImage.toString(),
                  title: localeData!.articles![index].title.toString(),
                  author: localeData!.articles![index].author.toString(),
                  time: localeData!.articles![index].publishedAt!
                      .toLocal()
                      .toString(),
                );
              },
            ),
    );
  }
}
