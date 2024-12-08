import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:global_news_app/controllers/state_controller.dart';
import 'package:global_news_app/data/models/news_model.dart';
import 'package:http/http.dart' as http;

class ApiDataService {
  final StateController stateController = Get.find();

  Future<List<NewsModel>> getFeaturedNews(String? country) async {
    String dataUrl = '${stateController.baseUrl}/top-headlines';

    // Create query parameters map
    Map<String, String> queryParams = {
      'apiKey': stateController.apiKey,
      'category': 'general',
      'language': 'en',
    };

    // Add 'country' query parameter if country is not null
    if (country != null) {
      queryParams['country'] = country;
    }

    //URI with the query parameters
    Uri uri = Uri.parse(dataUrl).replace(queryParameters: queryParams);

    try {
      final response = await http.get(
        uri,
      );
      debugPrint(
          "Response status code from getData request -->> ${response.statusCode}");
      if (response.statusCode == 200) {
        var responseDecoded = await json.decode(response.body);
        debugPrint("Response from getData Decoded -->> $responseDecoded");

        List<dynamic> articles = responseDecoded["articles"];

        if (articles.isNotEmpty) {
          //Map the articles to NewsModel objects
          List<NewsModel> newsList = articles.map((article) {
            return NewsModel.fromApiResponse(article);
          }).toList();
          debugPrint("List of News: $newsList");
          return newsList;
        } else {
          debugPrint("No articles found");
          return [];
        }
      } else {
        debugPrint("GET News Data Failed");
        return [];
      }
    } catch (e) {
      debugPrint("GET News Error : $e");
      return [];
    }
  }

  Future<List<NewsModel>> getNewsByCategory(
      {required String? mainCategory,
      required String? subCategory,
      required String? source,
      required String? country}) async {
    String dataUrl = '${stateController.baseUrl}/$mainCategory';

    // Create query parameters map
    Map<String, String> queryParams = {
      'apiKey': stateController.apiKey,
      'language': 'en',
    };

    // Add 'category' query parameter if category is not null
    if (subCategory != null) {
      queryParams['category'] = subCategory;
    }
    // Add 'sources' query parameter if sources is not null
    if (source != null) {
      queryParams['sources'] = source;
    }
    // Add 'country' query parameter if country is not null
    if (country != null) {
      queryParams['country'] = country;
    }

    //URI with the query parameters
    Uri uri = Uri.parse(dataUrl).replace(queryParameters: queryParams);

    try {
      final response = await http.get(
        uri,
      );
      debugPrint(
          "Response status code from getData request -->> ${response.statusCode}");
      if (response.statusCode == 200) {
        var responseDecoded = await json.decode(response.body);
        debugPrint("Response from getData Decoded -->> $responseDecoded");

        List<dynamic> articles = responseDecoded["articles"];

        if (articles.isNotEmpty) {
          //Map the articles to NewsModel objects
          List<NewsModel> newsList = articles.map((article) {
            return NewsModel.fromApiResponse(article);
          }).toList();
          debugPrint("List of News: $newsList");
          return newsList;
        } else {
          debugPrint("No articles found");
          return [];
        }
      } else {
        debugPrint("GET News Data Failed");
        return [];
      }
    } catch (e) {
      debugPrint("GET News Error : $e");
      return [];
    }
  }

  Future<List<NewsModel>> getNewsSearchResults(String? query) async {
    String dataUrl = '${stateController.baseUrl}/everything';

    // Create query parameters map
    Map<String, String> queryParams = {
      'apiKey': stateController.apiKey,
      'language': 'en',
    };

    // Add 'q' query parameter if query is not null
    if (query != null && query != "") {
      queryParams['q'] = query;
    }

    //URI with the query parameters
    Uri uri = Uri.parse(dataUrl).replace(queryParameters: queryParams);

    try {
      final response = await http.get(
        uri,
      );
      debugPrint(
          "Response status code from getData request -->> ${response.statusCode}");
      if (response.statusCode == 200) {
        var responseDecoded = await json.decode(response.body);
        debugPrint("Response from getData Decoded -->> $responseDecoded");

        List<dynamic> articles = responseDecoded["articles"];

        if (articles.isNotEmpty) {
          //Map the articles to NewsModel objects
          List<NewsModel> newsList = articles.map((article) {
            return NewsModel.fromApiResponse(article);
          }).toList();
          debugPrint("List of News: $newsList");
          return newsList;
        } else {
          debugPrint("No articles found");
          return [];
        }
      } else {
        debugPrint("GET News Data Failed");
        return [];
      }
    } catch (e) {
      debugPrint("GET News Error : $e");
      return [];
    }
  }
}
