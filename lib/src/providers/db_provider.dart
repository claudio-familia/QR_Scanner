
import 'dart:io';

import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

import 'package:qrscanner/src/models/scan_model.dart';
export 'package:qrscanner/src/models/scan_model.dart';

class DBProvider {
  static Database _database;
  static final DBProvider db = DBProvider._();

  DBProvider._();

  Future<Database> get database async {
    
    if( _database != null ) return _database;

    _database = await initDB();

    return _database;
  }

  initDB() async {
    
    Directory documentPath = await getApplicationDocumentsDirectory();

    final path = join( documentPath.path, 'ScansDB.db' );

    return await openDatabase(
      path,
      version: 1,
      onOpen: (db) {},
      onCreate: (Database db, int version) async {        
        await db.execute(
          'CREATE TABLE Scans('
          ' id INTEGER PRIMARY KEY, '
          ' type TEXT, '
          ' value TEXT '
          ')'
        );
      }
    );
  }

  Future<int> insertScan(ScanModel newScan) async {
    final db = await database;
    final response = await db.insert('Scans', newScan.toJson());
    return response;
  }

  Future<int> updateScan(ScanModel scan) async {
    final db = await database;
    final response = await db.update('Scans', scan.toJson(), 
                                    where: 'id = ?', 
                                    whereArgs: [scan.id]);
    return response;
  }

  Future<int> deleteScans(int id) async {
    final db = await database;
    final response = await db.delete('Scans', where: 'id = ?', whereArgs: [id]);
    return response;
  }

  Future<int> deleteAllScans() async {
    final db = await database;
    final response = await db.delete('Scans');
    return response;
  }

  Future<List<ScanModel>> getScans([String type = '']) async {
    final db = await database;
    final request = type == '' ?
                    await db.query('Scans') :
                    await db.query('Scans', where: 'type = ?', whereArgs: [type]);
    
    final response = request.isNotEmpty ? request.map((item) => 
                                          ScanModel.fromJson(item)).toList()
                                          : <ScanModel>[];

    return response;
  }

  Future<ScanModel> getScansById( int id ) async {
    final db = await database;
    final response = await db.query('Scans', where: 'id = ?', whereArgs: [id]);
    return response.isNotEmpty ? ScanModel.fromJson(response.first) : [];
  }
}