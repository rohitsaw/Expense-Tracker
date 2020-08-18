import 'package:flutter/foundation.dart';

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import 'package:flutter/material.dart';

class TransactionCategory {
  final String category;
  TransactionCategory(this.category);
}

class Transaction {
  final int id;
  final String title;
  final int amount;
  final DateTime date;
  final TransactionCategory category;

  Transaction({
    @required this.id,
    @required this.title,
    @required this.amount,
    @required this.date,
    @required this.category,
  });

  String get getCategory {
    return category.category;
  }
}

class CategoryListProvider with ChangeNotifier {
  List<TransactionCategory> _allCategory = [];
  dynamic _database;

  int get noOfCategory {
    return _allCategory.length;
  }

  // get all categories
  List<String> get allCategory {
    return _allCategory.map((e) => e.category).toList();
  }

  // populate in memory Category list
  Future<void> loadCategories() async {
    _allCategory = await fetchAndLoadCat;
  }

  // fetch and return category list from database
  Future<List<TransactionCategory>> get fetchAndLoadCat async {
    _database = openDatabase(
      join(await getDatabasesPath(), 'database.db'),
      onCreate: (db, version) {
        db.execute(
          "CREATE TABLE txn(id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, title TEXT, amount INTEGER, date Text, category Text)",
        );
        db.execute(
          "CREATE TABLE cat(category TEXT UNIQUE)",
        );
      },
      version: 1,
    );
    final Database db = await _database;
    final List<Map<String, dynamic>> maps = await db.query('cat');

    return List.generate(maps.length, (i) {
      return TransactionCategory(
        maps[i]['category'],
      );
    });
  }

  void addCategory(String cat) async {
    if (_allCategory.any((element) => element.category == cat)) {
      return;
    }

    final Database db = await _database;
    await db.insert(
      'cat',
      {
        'category': cat,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    _allCategory.add(TransactionCategory(cat));

    print("add category successfull");
    notifyListeners();
  }

  void deleteCategory(String cat) async {
    final Database db = await _database;

    await db.delete(
      'cat',
      where: "category = ?",
      whereArgs: [cat],
    );
    _allCategory.removeWhere((element) => element.category == cat);
    print("category delete from database");
    notifyListeners();
  }
}

class TransactionListProvider with ChangeNotifier {
  List<Transaction> _allTransactions = [];
  dynamic _database;
  // getter for all transaction list
  List<Transaction> get getAllTransactions {
    return [..._allTransactions];
  }

  // populate in memory transactions list
  Future<void> loadTransactions() async {
    _allTransactions = await fetchAndLoadTxn;
  }

  // fetch and returns all transactions list from database
  Future<List<Transaction>> get fetchAndLoadTxn async {
    _database = openDatabase(
      join(await getDatabasesPath(), 'database.db'),
      onCreate: (db, version) {
        db.execute(
          "CREATE TABLE txn(id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, title TEXT, amount INTEGER, date Text, category Text)",
        );
        db.execute("CREATE TABLE cat(category TEXT UNIQUE)");
        print("two table create");
      },
      version: 1,
    );
    final Database db = await _database;
    final List<Map<String, dynamic>> maps = await db.query('txn');

    return List.generate(maps.length, (i) {
      return Transaction(
        id: maps[i]['id'],
        title: maps[i]['title'],
        amount: maps[i]['amount'],
        date: DateTime.parse(maps[i]['date']),
        category: TransactionCategory(maps[i]['category']),
      );
    });
  }

  // getter for last seven days transaction list
  List<Map<String, dynamic>> get lastSevenDays {
    Map<String, int> mp = {};
    Map<int, String> dayData = {
      1: "Mon",
      2: "Tue",
      3: "Wed",
      4: "Thur",
      5: "Fri",
      6: "Sat",
      7: "Sun"
    };
    DateTime lastDate = DateTime.now().subtract(
      Duration(days: 7),
    );
    _allTransactions.forEach((element) {
      if (element.date.isAfter(lastDate)) {
        if (mp[dayData[element.date.weekday]] == null)
          mp[dayData[element.date.weekday]] = 0;
        mp[dayData[element.date.weekday]] += element.amount;
      }
    });

    List<Map<String, dynamic>> lastSevenDaysList = [];
    for (int i = lastDate.weekday + 1; i <= 7; i++) {
      lastSevenDaysList.add({'day': dayData[i], 'amount': mp[dayData[i]] ?? 0});
    }
    for (int i = 1; i <= lastDate.weekday; i++) {
      lastSevenDaysList.add({'day': dayData[i], 'amount': mp[dayData[i]] ?? 0});
    }

    return lastSevenDaysList;
  }

  // getter for category wise transaction data
  Map<String, Map<String, int>> categoryWiseTransactions() {
    Map<String, Map<String, int>> mp = Map();

    _allTransactions.forEach((element) {
      if (mp[element.getCategory] == null) {
        mp[element.getCategory] = {'length': 0, 'total': 0};
      }
      mp[element.getCategory]['length'] += 1;
      mp[element.getCategory]['total'] += element.amount;
    });

    return mp;
  }

  // getter for specific category transaction list
  List<Transaction> filterTransactions(String cat) {
    List<Transaction> tx = [];

    _allTransactions.forEach((element) {
      if (element.getCategory == cat) {
        tx.add(element);
      }
    });

    return tx;
  }

  // getter for total number of transaction
  int get noOfTransactions {
    return _allTransactions.length;
  }

  // add new transaction
  Future<void> addTransaction(
      String title, int amount, DateTime date, String category) async {
    final Database db = await _database;
    int id = await db.insert(
      'txn',
      {
        'title': title,
        'amount': amount,
        'date': date.toIso8601String(),
        'category': category,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    Transaction txn = Transaction(
      id: id,
      title: title,
      amount: amount,
      date: date,
      category: TransactionCategory(category),
    );
    _allTransactions.add(txn);
    notifyListeners();
  }

  // delete a transaction by id
  Future<void> deleteTrasaction(int id) async {
    final db = await _database;
    await db.delete(
      'txn',
      where: "id = ?",
      whereArgs: [id],
    );

    _allTransactions.removeWhere((element) => element.id == id);
    notifyListeners();
  }

  // delete all transaction of specific category
  void deleteCategoryTransaction(String cat) async {
    final db = await _database;
    await db.delete(
      'txn',
      where: "category = ?",
      whereArgs: [cat],
    );
    print("DELETE SUCCESSFULL BY CATEGORY");
    _allTransactions.removeWhere((element) => element.getCategory == cat);
    notifyListeners();
  }
}
