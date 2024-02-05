import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import 'package:intl/intl.dart';
import 'detail_page.dart';
import '../model/news.dart';

class newHomes extends StatefulWidget {
  const newHomes({Key? key}) : super(key: key);

  @override
  _MyWidgetState createState() => _MyWidgetState();
}

class _MyWidgetState extends State<newHomes> {
  @override
  void initState() {
    super.initState();
    Provider.of<News>(context, listen: false)
        .fetchData(); // Fetch data when the widget is initialized
  }

  // Function to decode the title field
  String decodeTitle(String encodedTitle) {
    List<int> bytes = encodedTitle.toString().codeUnits;
    return utf8.decode(bytes);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<News>(
        builder: (context, newsProvider, _) {
          if (newsProvider.isLoading) {
            // Show loading indicator if data is loading
            return Center(child: CircularProgressIndicator());
          } else if (newsProvider.hasError) {
            // Show error message if there's an error
            return Center(child: Text('Error fetching news data'));
          } else {
            // Display news data
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
              child: ListView.builder(
                itemCount: newsProvider.data.length,
                itemBuilder: (BuildContext context, int index) {
                  String decodedTitle =
                      decodeTitle(newsProvider.data[index]['title']);
                  String imageName = newsProvider.data[index]['image'];
                  String imageUrl = imageName != null
                      ? 'https://public-kpv-bucket.s3.ap-southeast-1.amazonaws.com/resized/medium/$imageName'
                      : '';
                  String createdAtString =
                      newsProvider.data[index]['created_at'];
                  DateTime createdAt = DateTime.parse(createdAtString);
                  String formattedCreatedAt =
                      DateFormat('yyyy-MM-dd').format(createdAt);

                  String id = newsProvider.data[index]
                      ['id']; // Accessing id from the data

                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailPage(id: id),
                        ),
                      );
                    },
                    child: Card(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          if (imageName != null)
                            Image.network(
                              imageUrl,
                              fit: BoxFit.cover,
                              height: 250,
                            ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  decodedTitle,
                                  style: const TextStyle(
                                    fontSize: 15,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(
                                      formattedCreatedAt,
                                      style: const TextStyle(
                                        fontSize: 15,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            );
          }
        },
      ),
    );
  }
}
