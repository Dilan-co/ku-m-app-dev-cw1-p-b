import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:global_news_app/data/models/news_model.dart';

class StateController extends GetxController {
  RxString externalStoragePath = "".obs;
  RxString documentsDirectoryPath = "".obs;

  RxList<NewsModel> savedNewsList = <NewsModel>[].obs;

  //API Key
  String apiKey = "9b5cb5b59f9f4be6b477c6231d86b734";
  //Base Url for API
  String baseUrl = "https://newsapi.org/v2";

  String? selectedMainCategory = "top-headlines";
  String? selectedSubCategory;
  String? selectedSource;
  String? selectedCountry;
  String? selectedCountryKey;

  setExternalStoragePath(String path) {
    externalStoragePath(path);
    debugPrint(path);
  }

  getExternalStoragePath() {
    return externalStoragePath();
  }

  setDocumentsDirectoryPath(String path) {
    documentsDirectoryPath(path);
    debugPrint(path);
  }

  getDocumentsDirectoryPath() {
    return documentsDirectoryPath();
  }

  setSavedNewsList(List<NewsModel> list) {
    savedNewsList(list);
  }

  getSavedNewsList() {
    return savedNewsList();
  }
}
