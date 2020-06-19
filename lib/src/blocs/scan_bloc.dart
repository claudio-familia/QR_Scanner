

import 'dart:async';
import 'dart:core';

import 'package:qrscanner/src/providers/db_provider.dart';

class ScansBloc {
  static final ScansBloc _singleton = new ScansBloc._internal();

  factory ScansBloc() {
    return _singleton;
  }

  ScansBloc._internal() {
    getScans();
  }

  final _scansController = StreamController<List<ScanModel>>.broadcast();

  Stream<List<ScanModel>> get scansStream => _scansController.stream;

  dispose() {
    _scansController?.close();
  }

  getScans([String type = '']) async {
    _scansController.sink.add(await DBProvider.db.getScans(type));    
  }

  addScan(ScanModel newScan) async {
    DBProvider.db.insertScan(newScan);
    getScans();
  }

  deleteScan(int id) async {
    await DBProvider.db.deleteScans(id);
    getScans();
  }

  deleteAllScans() async {
    await DBProvider.db.deleteAllScans();
    getScans();
  }
}