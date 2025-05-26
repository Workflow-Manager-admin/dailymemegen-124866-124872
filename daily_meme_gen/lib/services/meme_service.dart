import 'dart:convert';
import 'package:http/http.dart' as http;

class MemeService {
  static const String _apiUrl = 'https://meme-api.com/gimme';

  // PUBLIC_INTERFACE
  /// Fetches a random meme from the API
  Future<Map<String, dynamic>> getRandomMeme() async {
    try {
      final response = await http.get(Uri.parse(_apiUrl));
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load meme');
      }
    } catch (e) {
      throw Exception('Failed to connect to meme service: $e');
    }
  }

  // PUBLIC_INTERFACE
  /// Fetches the meme of the day (uses the same endpoint for now)
  Future<Map<String, dynamic>> getMemeOfTheDay() async {
    return getRandomMeme(); // For now, using random meme as meme of the day
  }
}
