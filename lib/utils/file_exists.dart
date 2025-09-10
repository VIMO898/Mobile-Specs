import 'package:flutter/services.dart' show rootBundle;

// Check if the image file exists.
Future<bool> fileExists(String fileName) async {
  try {
    await rootBundle.load(fileName);
    return true;
  } catch (_) {
    return false;
  }
}
