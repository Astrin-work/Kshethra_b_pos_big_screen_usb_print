
import 'dart:convert';
import 'package:dio/dio.dart';

class GoogleTranslatorService {
  final Dio _dio = Dio();
  final String apiKey = 'AIzaSyCIucA0U4qqBUua76FUGQIYsavu_ZDhuDY';

  Future<String> translateText(String text, String targetLang, {String sourceLang = 'auto'}) async {
    final String url = 'https://translation.googleapis.com/language/translate/v2?key=$apiKey';

    try {
      final response = await _dio.post(
        url,
        data: jsonEncode({
          'q': text,
          'source': sourceLang,
          'target': targetLang,
          'format': 'text',
        }),
        options: Options(
          headers: {
            'Content-Type': 'application/json',
          },
          validateStatus: (status) => status! < 500,
        ),
      );

      // Debug full response
      print("✅ Response Data:");
      print(const JsonEncoder.withIndent('  ').convert(response.data));

      if (response.statusCode == 200) {
        final translatedText = response.data['data']['translations'][0]['translatedText'];
        return translatedText;
      } else {
        throw Exception('Translation API Error: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Translation failed: $e');
      throw Exception('Translation failed');
    }
  }
}
