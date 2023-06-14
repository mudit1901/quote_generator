import 'dart:convert';

import 'quote.dart';
import 'package:http/http.dart' as http;

class QuoteService {
  static Future<Quote> getRandomQuote() async {
    final response =
        await http.get(Uri.parse('https://api.quotable.io/random'));

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return Quote.fromJson(json);
    } else {
      throw Exception('Failed to load quote');
    }
  }
}
