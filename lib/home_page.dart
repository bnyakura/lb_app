import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'product_detail_page.dart'; // Import the new page

class CRUDEoperation extends StatefulWidget {
  const CRUDEoperation({Key? key}) : super(key: key);

  @override
  State<CRUDEoperation> createState() => _CRUDEoperationState();
}

class _CRUDEoperationState extends State<CRUDEoperation> {
  final CollectionReference myItems = FirebaseFirestore.instance.collection("LBproducts");
  String searchText = "";

  @override
  Widget build(BuildContext context) {
    print('CRUDEoperation build method called');
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.blue,
        title: const Text("A Lucky Brand Products"),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60.0),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  searchText = value;
                });
              },
              decoration: InputDecoration(
                hintText: 'Search products...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
          ),
        ),
      ),
      body: StreamBuilder(
        stream: myItems.snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
          if (streamSnapshot.hasError) {
            print('Stream has error: ${streamSnapshot.error}');
            return Center(
              child: Text('Error: ${streamSnapshot.error}'),
            );
          }

          if (streamSnapshot.connectionState == ConnectionState.waiting) {
            print('Stream is waiting for data...');
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (streamSnapshot.hasData) {
            print('Stream has data');
            final List<DocumentSnapshot> items = streamSnapshot.data!.docs
                .where((doc) =>
            doc['name'].toLowerCase().contains(searchText.toLowerCase()) ||
                doc['sku'].toLowerCase().contains(searchText.toLowerCase()))
                .toList();

            if (items.isEmpty) {
              print('No items found');
            } else {
              print('Found ${items.length} items');
            }
            return ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                final DocumentSnapshot documentSnapshot = items[index];
                final String sku = documentSnapshot['sku'];
                final String name = documentSnapshot['name'];

                return Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    border: Border(
                      bottom: BorderSide(
                        color: Colors.grey.shade400,
                        width: 1.0,
                      ),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10.0,
                      vertical: 10.0,
                    ),
                    child: ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(
                        '$sku | $name',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ),
                      subtitle: Text(
                        '\$${documentSnapshot['Price'].toString()}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.blue,
                        ),
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProductDetailPage(documentSnapshot: documentSnapshot),
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
            );

          }

          print('No data in stream');
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
