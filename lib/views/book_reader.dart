import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BookReader extends StatefulWidget {
  const BookReader({Key? key});

  @override
  State<BookReader> createState() => _BookReaderState();
}

class _BookReaderState extends State<BookReader> {
  late Future<DocumentSnapshot<Map<String, dynamic>>> _bookFuture;
  final String bookId = "3b2snu24t3nGHFvDAVOD";

  @override
  void initState() {
    super.initState();
    _bookFuture = _fetchBookData(bookId);
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> _fetchBookData(
      String bookId) async {
    return await FirebaseFirestore.instance
        .collection('books')
        .doc(bookId)
        .get();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff14161B),
      body: Column(
        children: [
          Stack(
            children: [
              Container(
                height: 200,
                decoration: BoxDecoration(
                  color: Color(0xff414141),
                ),
              ),
              Positioned(
                top: 8,
                right: 8,
                child: Chip(
                  backgroundColor: Color(0xff141314),
                  label: Text(
                    "audio",
                    style: TextStyle(color: Color(0xff83899F)),
                  ),
                  avatar: InkWell(
                    onTap: () {},
                    child: Icon(
                      Icons.pause_circle_outline_rounded,
                      color: Color(0xff43F45F),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Expanded(
            child: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
              future: _bookFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else {
                  final title = snapshot.data!.get('title');
                  final content =
                      snapshot.data!.get('content') as List<dynamic>;

                  return SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        children: content
                            .map((para) => parawidget(para.toString()))
                            .toList(),
                      ),
                    ),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget parawidget(String text) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: 300,
        color: Colors.amber,
        child: Text(
          text,
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
