import 'package:path/path.dart' as path;

import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

import 'articles.dart';

class ConfigDBProv with ChangeNotifier {
  late final _dbPath;
  late final _dbName;
  late final Future<Database> _database;

  ConfigDBProv() {
    _database = init();
  }

  Future<Database> init() async {
    _dbPath = await getDatabasesPath();
    _dbName = path.join(_dbPath, 'shouvikArticles2.db');
    return openDatabase(
      _dbName,
      onCreate: (db, version) {
        return db.execute(
          "CREATE TABLE article(id INTEGER PRIMARY KEY AUTOINCREMENT, nom TEXT, CUP TEXT, personneQuiAjoute TEXT, dateAjout TEXT, status INTEGER)",
        );
      },
      version: 1,
    );
  }

  get database => _database;

  Future<List<Article>> getAllArticles() async {
    final db = await _database;
    final List<Map<String, dynamic>> maps = await db.query('article');

    return List.generate(maps.length, (i) {
      return Article(
        id: maps[i]['id'].toString(),
        nom: maps[i]['nom'],
        CUP: maps[i]['cup'],
        personneQuiAjoute: maps[i]['personneQuiAjoute'],
        dateAjout: DateTime.parse(maps[i]['dateAjout']),
        status: maps[i]['status'] == 0
            ? ArticleStatus.enAttente
            : maps[i]['status'] == 1
                ? ArticleStatus.trouve
                : ArticleStatus.pasTrouve,
      );
    });
  }

  Future<void> updateArticleStatus(String id, int status) async {
    final db = await database;
    await db.update(
      'article',
      {'status': status},
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
