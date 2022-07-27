import 'dart:io';
import 'package:path_provider/path_provider.dart';

class ApiToLocale {
  Future<String> get _localPath async {
    final directory = await getExternalStorageDirectory();
    return directory!.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/locale_json.txt');
  }

  Future readCounter() async {
    try {
      final file = await _localFile;
      // Read the file
      final data = await file.readAsString();

      return data;
    } catch (e) {
      // If encountering an error, return 0
      return 0;
    }
  }

  Future<File> writeCounter(var data) async {
    final file = await _localFile;
    // Write the file
    return file.writeAsString('$data');
  }
}
