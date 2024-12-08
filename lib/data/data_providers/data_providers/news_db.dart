import 'package:global_news_app/data/data_providers/data_providers/news.dart';
import 'package:sqflite/sqflite.dart';

class NewsDB {
  //Creating tables for forms
  Future<void> createTables({required Database database}) async {
    //Add all tables for Forms here
    News().createTable(database);
  }
}
