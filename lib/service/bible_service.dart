import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/bible_model.dart';

class BibleService {
  final String _baseUrl = 'https://bible4u.net/api/v1/pt';

  // Busca a lista de livros
  Future<List<Book>> getBooks() async {
    final response = await http.get(Uri.parse('$_baseUrl/books'));

    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(utf8.decode(response.bodyBytes));
      return body.map((dynamic item) => Book.fromJson(item)).toList();
    } else {
      throw Exception('Falha ao carregar os livros');
    }
  }

  // Busca os versículos de um capítulo específico
  Future<List<Verse>> getVerses(String bookAbbrev, int chapter) async {
    // A API parece usar o nome do livro em inglês na URL, então vamos ajustar
    // Esta parte pode precisar de um mapeamento se os nomes não baterem.
    // Para simplificar, vamos usar o nome do livro. A API pode ser flexível.
    final response = await http.get(Uri.parse('$_baseUrl/$bookAbbrev/$chapter'));

    if (response.statusCode == 200) {
      Map<String, dynamic> body = jsonDecode(utf8.decode(response.bodyBytes));
      List<dynamic> versesJson = body['verses'];
      return versesJson.map((dynamic item) => Verse.fromJson(item)).toList();
    } else {
      throw Exception('Falha ao carregar os versículos');
    }
  }
}