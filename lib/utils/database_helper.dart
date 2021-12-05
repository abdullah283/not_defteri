import 'dart:io';
import 'package:bolum_28_not_sepeti/model/kategori.dart';
import 'package:bolum_28_not_sepeti/model/notlar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:typed_data';

class DatabaseHelper {
  static DatabaseHelper? _databaseHelper;
  static Database? _database;
  //***************DatabaseHelper için kurucu metot olusturuluyor.*************//
  factory DatabaseHelper() {
    if (_databaseHelper == null) {
      debugPrint('databaseHelper bos du olusturulacak');
      _databaseHelper = DatabaseHelper._internal();
      return _databaseHelper!;
    } else {
      debugPrint('databaseHelper daha once olusturulmus');
      return _databaseHelper!;
    }
  }
  DatabaseHelper._internal();
  //***************Database yani veri tabanimiz olusturuluyor.*************//
  Future<Database> _getDatabase() async {
    if (_database == null) {
      debugPrint('database bos du olusturulacak');
      _database = await initializeDatabase();
      return _database!;
    } else {
      debugPrint('database daha once olusturulmus');
      return _database!;
    }
  }

  Future<Database> initializeDatabase() async {
    Database? _db;

    var databasesPath = await getDatabasesPath();

    var path = join(databasesPath, "myNotlar.db");

// Check if the database exists
    var exists = await databaseExists(path);

    if (!exists) {
      // Should happen only the first time you launch your application
      debugPrint("Creating new copy from asset");

      // Make sure the parent directory exists
      try {
        await Directory(dirname(path)).create(recursive: true);
      } catch (_) {}

      // Copy from asset
      ByteData data = await rootBundle.load(join("assets", "notlar.db"));
      List<int> bytes =
          data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

      // Write and flush the bytes written
      await File(path).writeAsBytes(bytes, flush: true);
    } else {
      debugPrint("Opening existing database");
    }
// open the database
    _db = await openDatabase(path, readOnly: false);

    return _db;
  }

  //***************Kategori tablosu icin CRUD islemlerin yapilmasi*************//
  Future<List<Map<String, dynamic>>> mapKategorileriGetir() async {
    var db = await _getDatabase();
    var sonuc = await db.query('Kategori');

    return sonuc;
  }

  Future<List<Kategori>> kategorileriGetir() async {
    List<Kategori> tumKategorileri = [];
    var mapler = await mapKategorileriGetir();
    for (Map<String, dynamic> gezginci in mapler) {
      tumKategorileri.add(Kategori.fromMap(gezginci));
    }
    return tumKategorileri;
  }

  Future<int> insertKategoriTable(Kategori kategori) async {
    var db = await _getDatabase();
    int sonuc = await db.insert('Kategori', kategori.toMap(),
        nullColumnHack: '${kategori.kategoriId}');
    return sonuc;
  }

  Future<int> updateKategoriTable(Kategori kategori) async {
    var db = await _getDatabase();
    var sonuc = await db.update('Kategori', kategori.toMap(),
        where: 'kategoriId=?', whereArgs: [kategori.kategoriId]);
    return sonuc;
  }

  Future<int> deleteKategoriTable(int id) async {
    var db = await _getDatabase();
    var sonuc =
        await db.delete('Kategori', where: "kategoriId=?", whereArgs: [id]);
    return sonuc;
  }

  Future<int> deleteAllKategoriTable() async {
    var db = await _getDatabase();
    var sonuc = await db.delete('Kategori');
    return sonuc;
  }

  //***************Not tablosu icin CRUD islemlerin yapilmasi*************//
  Future<List<Map<String, dynamic>>> mapNotlariGetir() async {
    var db = await _getDatabase();
    var sonuc = await db.rawQuery(
        'select * from "not" inner join kategori on kategori.kategoriID="not".kategoriID order by notID Desc; ');
    return sonuc;
  }

  Future<List<Not>> notlariGetir() async {
    List<Not> tumNotlar = [];
    var mapler = await mapNotlariGetir();
    for (Map<String, dynamic> gezginci in mapler) {
      tumNotlar.add(Not.fromMap(gezginci));
    }
    debugPrint('notlari Getir Calisti');
    return tumNotlar;
  }

  Future<int> insertNotTable(Not not) async {
    var db = await _getDatabase();
    int sonuc = await db.insert('Not', not.toMap());
    return sonuc;
  }

  Future<int> updateNotTable(Not not) async {
    var db = await _getDatabase();
    var sonuc = await db
        .update('Not', not.toMap(), where: 'notId=?', whereArgs: [not.notId]);
    return sonuc;
  }

  Future<int> deleteNotTable(int id) async {
    var db = await _getDatabase();
    var sonuc = await db.delete('Not', where: 'notId=?', whereArgs: [id]);
    return sonuc;
  }

  Future<int> deleteAlNotTable() async {
    var db = await _getDatabase();
    var sonuc = await db.delete('Not');
    return sonuc;
  }

  String dateFormat(DateTime tm) {
    DateTime today = new DateTime.now();
    Duration oneDay = new Duration(days: 1);
    Duration twoDay = new Duration(days: 2);
    Duration oneWeek = new Duration(days: 7);
    String? month;
    switch (tm.month) {
      case 1:
        month = "Ocak";
        break;
      case 2:
        month = "Şubat";
        break;
      case 3:
        month = "Mart";
        break;
      case 4:
        month = "Nisan";
        break;
      case 5:
        month = "Mayıs";
        break;
      case 6:
        month = "Haziran";
        break;
      case 7:
        month = "Temmuz";
        break;
      case 8:
        month = "Ağustos";
        break;
      case 9:
        month = "Eylük";
        break;
      case 10:
        month = "Ekim";
        break;
      case 11:
        month = "Kasım";
        break;
      case 12:
        month = "Aralık";
        break;
    }

    Duration difference = today.difference(tm);

    if (difference.compareTo(oneDay) < 1) {
      return "Bugün";
    } else if (difference.compareTo(twoDay) < 1) {
      return "Dün";
    } else if (difference.compareTo(oneWeek) < 1) {
      switch (tm.weekday) {
        case 1:
          return "Pazartesi";
        case 2:
          return "Salı";
        case 3:
          return "Çarşamba";
        case 4:
          return "Perşembe";
        case 5:
          return "Cuma";
        case 6:
          return "Cumartesi";
        case 7:
          return "Pazar";
      }
    } else if (tm.year == today.year) {
      return '${tm.day} $month';
    } else {
      return '${tm.day} $month ${tm.year}';
    }
    return "";
  }
}
