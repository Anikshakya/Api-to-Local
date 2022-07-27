import 'package:dio/dio.dart';
import 'package:dio_http_cache/dio_http_cache.dart';
import 'package:local_api/model/news_api_model.dart';
import 'package:get_storage/get_storage.dart';

var box = GetStorage();

class JsonParseService {
  static const String url =
      'https://newsapi.org/v2/top-headlines?country=us&category=business&apiKey=dfa139880f12455994ca5ed92da0b085';

  static getData() async {
    try {
      Dio dio = Dio();
      dio.interceptors.add(DioCacheManager(
        CacheConfig(baseUrl: "https://newsapi.org/v2/"),
      ).interceptor);
      final response = await dio.get(url,
          options: buildCacheOptions(const Duration(days: 1)));
      if (200 == response.statusCode) {
        final articleData = NewsApi.fromJson(response.data);
        box.write("localeStorage", articleData);
        return articleData;
      } else {
        return <NewsApi>[];
      }
    } catch (e) {
      return <NewsApi>[];
    }
  }
}
