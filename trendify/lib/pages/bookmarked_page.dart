import 'package:flutter/material.dart';

class BookmarkedPage extends StatelessWidget {
  final List<String> bookmarkedNews;

  const BookmarkedPage({Key? key, required this.bookmarkedNews}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bookmarked News'),
      ),
      body: ListView.builder(
        itemCount: bookmarkedNews.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(bookmarkedNews[index]),
          );
        },
      ),
    );
  }
}
