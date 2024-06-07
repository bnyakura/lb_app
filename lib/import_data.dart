import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:csv/csv.dart';

class ImportData {
  static Future<void> importCsvToFirestore() async {
    final firestore = FirebaseFirestore.instance;
    final collection = firestore.collection('LBproducts');

    try {
      final csvData = await rootBundle.loadString('assets/products.csv');
      List<List<dynamic>> csvTable = CsvToListConverter().convert(csvData);

      for (var i = 1; i < csvTable.length; i++) {
        final row = csvTable[i];
        final data = {
          'sku': row[0],
          'name': row[1],
          'description': row[2],
          'Price': row[3],
        };

        await collection.doc(row[0]).set(data);
      }
      print('CSV data imported successfully');
    } catch (e) {
      print('Error importing CSV data: $e');
    }
  }
}
