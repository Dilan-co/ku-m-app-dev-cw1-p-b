import 'package:flutter/material.dart';
import 'package:global_news_app/data/models/news_model.dart';
import 'package:global_news_app/data/services/database_service.dart';
import 'package:sqflite/sqflite.dart';

class News {
  //Table name
  final tableName = 'News';

  Future<void> createTable(Database database) async {
    await database.execute("""CREATE TABLE IF NOT EXISTS $tableName (
      "newsId" INTEGER NOT NULL,
      "sourceId" TEXT DEFAULT NULL,
      "sourceName" TEXT DEFAULT NULL,
      "author" TEXT DEFAULT NULL,
      "title" TEXT NOT NULL DEFAULT NULL,
      "description" TEXT DEFAULT NULL,
      "url" TEXT NOT NULL DEFAULT NULL,
      "urlToImage" TEXT DEFAULT NULL,
      "publishedAt" TEXT DEFAULT NULL,
      "content" TEXT DEFAULT NULL,
      PRIMARY KEY("newsId" AUTOINCREMENT)
    );""");
  }

  Future<int> createRecord({required NewsModel model}) async {
    final database = await DatabaseService().database;

    debugPrint("createRecord Done");

    return await database.insert(tableName, {
      "sourceId": model.sourceId,
      "sourceName": model.sourceName,
      "author": model.author,
      "title": model.title,
      "description": model.description,
      "url": model.url,
      "urlToImage": model.urlToImage,
      "publishedAt": model.publishedAt,
      "content": model.content,
    });
  }

  Future<List<NewsModel>> fetchAllRecords() async {
    final database = await DatabaseService().database;

    final data = await database.rawQuery(
        """SELECT * from $tableName ORDER BY COALESCE(newsId, sourceId, sourceName, author, title, description, url, urlToImage, publishedAt, content);""");

    debugPrint("fetchAllRecords Done");

    return data.map((data) => NewsModel.fromSqfliteDatabase(data)).toList();
  }

  Future<NewsModel> fetchById({required int newsId}) async {
    final database = await DatabaseService().database;
    final data = await database
        .rawQuery("""SELECT * from $tableName WHERE newsId = ?""", [newsId]);

    debugPrint("fetchById Done");

    return NewsModel.fromSqfliteDatabase(data.first);

    //To get a list of data <List<NewsModel>>
    // return data.map((data) => NewsModel.fromSqfliteDatabase(data))
    //     .toList();
  }

  Future<int> deleteRecord({required NewsModel model}) async {
    final database = await DatabaseService().database;

    int recordId = await database
        .delete(tableName, where: "newsId = ?", whereArgs: [model.newsId]);

    debugPrint("deleteRecord Done");
    return recordId;
  }
}
