import 'dart:io';

import 'package:download_assets/download_assets.dart';
import 'package:flutter/material.dart';

class AssetDownloads extends StatefulWidget {
  const AssetDownloads({Key? key}) : super(key: key);

  @override
  State<AssetDownloads> createState() => _AssetDownloadsState();
}

class _AssetDownloadsState extends State<AssetDownloads> {
  DownloadAssetsController downloadAssetsController =
      DownloadAssetsController();
  String message = "Press the download button to start the download";
  bool downloaded = false;

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future _init() async {
    await downloadAssetsController.init();
    downloaded = await downloadAssetsController.assetsDirAlreadyExists();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Download And Load from assets"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(message),
          Column(
            children: [
              if (downloaded)
                Container(
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: FileImage(File(
                          "${downloadAssetsController.assetsDir}/dart.jpeg")),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              if (downloaded)
                Container(
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: FileImage(File(
                          "${downloadAssetsController.assetsDir}/flutter.png")),
                      fit: BoxFit.cover,
                    ),
                  ),
                )
            ],
          ),
          const SizedBox(
            height: 40,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              FloatingActionButton(
                onPressed: _downloadAssets,
                tooltip: 'Increment',
                child: const Icon(Icons.arrow_downward),
              ),
              const SizedBox(
                width: 25,
              ),
              FloatingActionButton(
                onPressed: _refresh,
                tooltip: 'Refresh',
                child: const Icon(Icons.refresh),
              ),
            ],
          ),
        ],
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Future _refresh() async {
    await downloadAssetsController.clearAssets();
    await _downloadAssets();
  }

  Future _downloadAssets() async {
    bool assetsDownloaded =
        await downloadAssetsController.assetsDirAlreadyExists();

    if (assetsDownloaded) {
      setState(() {
        message = "Click in refresh button to force download";
      });
      return;
    }

    try {
      await downloadAssetsController.startDownload(
        assetsUrl:
            "https://github.com/edjostenes/download_assets/raw/master/assets.zip",
        onProgress: (progressValue) {
          downloaded = false;
          setState(() {
            if (progressValue < 100) {
              message = "Downloading - ${progressValue.toStringAsFixed(2)}";
            } else {
              message =
                  "Download completed\nClick in refresh button to force download";

              downloaded = true;
            }
          });
        },
      );
    } on DownloadAssetsException catch (e) {
      setState(() {
        downloaded = false;
        message = "Error: ${e.toString()}";
      });
    }
  }
}
