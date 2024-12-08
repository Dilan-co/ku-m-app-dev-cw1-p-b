import 'dart:async';

import 'package:flutter/material.dart';
import 'package:global_news_app/data/data_providers/data_providers/news_db.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseService {
  static Database? _database;
  static final _initCompleter = Completer<Database>();

  Future<Database> get database async {
    if (_database != null) return _database!;
    if (!_initCompleter.isCompleted) {
      _initCompleter.complete(initializeDatabase());
    }
    _database = await _initCompleter.future;
    return _database!;
  }

  Future<String> get fullPath async {
    const dbName = "news.db";
    final path = await getDatabasesPath();
    return join(path, dbName);
  }

  Future<Database> initializeDatabase() async {
    final path = await fullPath;
    return await openDatabase(
      path,
      version: 1,
      onCreate: createDatabase,
      onOpen: (db) async {
        debugPrint("Database opened successfully.");
      },
      singleInstance: true,
    );
  }

  Future<void> createDatabase(Database database, int version) async {
    try {
      //Enable Foreign Keys
      await database.execute('PRAGMA foreign_keys = ON;');
      await NewsDB().createTables(database: database);
      debugPrint("Tables created successfully.");
    } catch (e) {
      debugPrint("Error creating tables: $e");
      rethrow;
    }
  }
}
