import 'package:http/http.dart' as http;
import 'dart:convert';

Future<Map<String, dynamic>> fetchNewsDetail(String id) async {
  final response = await http.get(Uri.parse('https://prod-api.kpvgroup.com/news-service/api/v1/news/$id'));
  if (response.statusCode == 200) {
    final responseData = jsonDecode(response.body)['data'];
    final title = decodeTitle(responseData['title']);
    final detail = decodeTitle(responseData['detail']);
    return {
      ...responseData,
      'title': title,
      'detail': detail,
    };
  } else {
    throw Exception('Failed to load news');
  }
}

String decodeTitle(String encodedTitle) {
  List<int> bytes = encodedTitle.toString().codeUnits;
  return utf8.decode(bytes);
}
