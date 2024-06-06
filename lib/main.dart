import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'home_page.dart';
import 'import_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp();
    FirebaseFirestore.instance.settings = const Settings(persistenceEnabled: true);
    print('Firebase initialized successfully');
    await ImportData.importCsvToFirestore(); // Import CSV data to Firestore
    runApp(MyApp());
  } catch (e) {
    print('Failed to initialize Firebase: $e');
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print('MyApp build method called');
    return MaterialApp(
      home: CRUDEoperation(),
    );
  }
}

