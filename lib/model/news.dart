import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class News extends ChangeNotifier {
  List<dynamic> _data = []; // Data fetched from the API
  bool _isLoading = false; // Track loading state
  bool _hasError = false; // Track error state

  List<dynamic> get data => _data;
  bool get isLoading => _isLoading;
  bool get hasError => _hasError;

  Future<void> fetchData() async {
    _isLoading = true; // Set loading state to true
    // notifyListeners();

    try {
      var url = Uri.https('prod-api.kpvgroup.com', '/news-service/api/v1/news',
          {'q': '{http}'});
      var response = await http.get(url);
      if (response.statusCode == 200) {
        var jsonResponse = convert.jsonDecode(response.body);
        _data = jsonResponse['data'];
      } else {
        _hasError = true; // Set error state to true
      }
    } catch (e) {
      _hasError = true; // Set error state to true in case of exception
    } finally {
      _isLoading =
          false; // Set loading state to false regardless of success or error
      notifyListeners(); // Notify listeners to rebuild UI
    }
  }
}
