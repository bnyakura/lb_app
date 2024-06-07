import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:html/parser.dart' as html_parser;

class ProductDetailPage extends StatelessWidget {
  final DocumentSnapshot documentSnapshot;

  const ProductDetailPage({Key? key, required this.documentSnapshot}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String sku = documentSnapshot['sku'];
    final String name = documentSnapshot['name'];

    // Safely get the price as a double
    final price = documentSnapshot['Price'];
    final double priceValue;
    if (price is int) {
      priceValue = price.toDouble();
    } else if (price is double) {
      priceValue = price;
    } else {
      priceValue = 0.0; // or handle this case appropriately
    }

    // Check if the 'description' field exists in the document snapshot
    final Map<String, dynamic>? data = documentSnapshot.data() as Map<String, dynamic>?;

    final String description = data != null && data.containsKey('description')
        ? data['description']
        : '';

    // Parse the HTML description
    final html_document = html_parser.parse(description);
    final String parsedDescription = html_document.body!.text;

    return Scaffold(
      appBar: AppBar(
        title: Text(name),
      ),
      body: Container(
        color: Color(0xFFF6F6F6),
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '$sku | $name',
                style: TextStyle(
                  fontSize: 18,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16),
              Text(
                '\$$priceValue',
                style: TextStyle(
                  fontSize: 16,

                  fontFamily: 'Inter',
                  color: Colors.blue.shade900,
                ),
              ),
              SizedBox(height: 16),
              Text(
                'Description:',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Container(
                margin: EdgeInsets.symmetric(vertical: 10),
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(color: Color(0xFFC5C5C5)),
                ),
                child: Text(
                  parsedDescription,
                  style: TextStyle(
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
