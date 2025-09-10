import 'dart:convert';

import 'package:http/http.dart' as http;

abstract class BaseCurrencyRatesRepository {
  Future<Map<String, double>> getLatestRates(String baseCurrency);
}

class CurrencyRatesRepository implements BaseCurrencyRatesRepository {
  @override
  Future<Map<String, double>> getLatestRates(String baseCurrency) async {
    final url =
        Uri.parse('https://api.apilayer.com/fixer/latest?base=$baseCurrency');
    try {
      final response = await http.get(url, headers: {
        'apikey': 'blDaguOYjaMLD6CJbJf9VEeM9bFLRFmj',
      });
      final data = json.decode(response.body);
      final rates = data['rates'];
      return rates;
    } catch (error) {
      rethrow;
    }
  }
}
