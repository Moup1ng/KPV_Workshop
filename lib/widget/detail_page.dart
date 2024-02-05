import 'package:flutter/material.dart';
import '../model/newsdetail.dart';

class DetailPage extends StatefulWidget {
  final String id;

  const DetailPage({Key? key, required this.id}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  late Map<String, dynamic> _newsData = {};

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      final responseData = await fetchNewsDetail(widget.id);
      setState(() {
        _newsData = responseData;
      });
    } catch (e) {
      // ignore: avoid_print
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Detail News",
          style: TextStyle(
            fontFamily: 'Times New Roman',
          ),
        ),
      ),
      body: _newsData.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Main image
                  if (_newsData['image'] != null)
                    GestureDetector(
                      child: Container(
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color:
                                  Colors.grey.withOpacity(0.5), // shadow color
                              spreadRadius: 5, // spread radius
                              blurRadius: 20, // blur radius
                              offset: const Offset(
                                  0, 5), // changes position of shadow
                            ),
                          ],
                        ),
                        child: Image.network(
                          'https://public-kpv-bucket.s3.ap-southeast-1.amazonaws.com/resized/medium/${_newsData['image']}',
                          width: double.infinity,
                          height: 200,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),

                  const SizedBox(height: 16),
                  // Title
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      _newsData['title'],
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Detail
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      _newsData['detail'],
                      style: const TextStyle(fontSize: 11),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Display additional images if available
                  if (_newsData['additionalInfo'] != null &&
                      _newsData['additionalInfo'].isNotEmpty)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.0),
                          child: Text(
                            'ຮູບພາບເພີ່ມເຕີມ',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Column(
                          children:
                              _newsData['additionalInfo'].map<Widget>((info) {
                            return Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: info['image'].map<Widget>((image) {
                                  return GestureDetector(
                                    onTap: () {
                                      // Navigate to full screen image view
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => FullScreenImage(
                                            imageUrl:
                                                'https://public-kpv-bucket.s3.ap-southeast-1.amazonaws.com/resized/medium/$image',
                                          ),
                                        ),
                                      );
                                    },
                                    child: Image.network(
                                      'https://public-kpv-bucket.s3.ap-southeast-1.amazonaws.com/resized/medium/$image',
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                        // Show error message if image fails to load
                                        return Center(
                                          child: Text(
                                              'Failed to load image: $error'),
                                        );
                                      },
                                    ),
                                  );
                                }).toList(),
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                ],
              ),
            ),
    );
  }
}

class FullScreenImage extends StatelessWidget {
  final String imageUrl;

  const FullScreenImage({Key? key, required this.imageUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Picture",
          style: TextStyle(
            fontFamily: 'Times New Roman',
          ),
        ),
      ),
      body: Center(
        child: Image.network(
          imageUrl,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            // Show error message if image fails to load
            return Center(child: Text('Failed to load image: $error'));
          },
        ),
      ),
    );
  }
}
