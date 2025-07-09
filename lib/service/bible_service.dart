import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/verse_model.dart';

class BibleService {
  final String _baseUrl = 'https://bible-api.com';

  /// Fetches verses for a given Bible reference (e.g., "John 3:16" or "João 3").
  ///
  /// The [reference] is URI-encoded to handle spaces and special characters.
  Future<List<Verse>> getVerses(String reference) async {
    // Sanitize the reference by replacing spaces with '+'
    final sanitizedReference = reference.trim().replaceAll(' ', '+');
    final url = Uri.parse('$_baseUrl/$sanitizedReference?translation=almeida');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<dynamic> versesJson = data['verses'];
        return versesJson.map((json) => Verse.fromJson(json)).toList();
      } else if (response.statusCode == 404) {
        // Handle cases where the reference is not found
        throw 'A referência "${reference.trim()}" não foi encontrada. Verifique e tente novamente.';
      } else {
        // Handle other server-side errors
        throw 'Ocorreu um erro no servidor. Tente novamente mais tarde.';
      }
    } catch (e) {
      // Handle network errors or other exceptions
      // Re-throw the specific error from the logic above or a generic one.
      if (e is String) rethrow;
      throw 'Erro de conexão. Verifique sua internet e tente novamente.';
    }
  }
}
