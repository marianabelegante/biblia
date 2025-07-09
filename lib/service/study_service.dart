import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/study_model.dart';

class StudyService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Generates a Bible study for a given verse using the OpenAI API.
  ///
  /// [fullVerseText]: The complete verse text, e.g., "João 3:16 — Porque Deus amou...".
  Future<String> generateStudy(String fullVerseText) async {
    final apiKey = dotenv.env['OPENAI_API_KEY'];
    if (apiKey == null || apiKey.isEmpty) {
      throw 'Chave da API da OpenAI não encontrada no arquivo .env';
    }

    const apiUrl = 'https://api.openai.com/v1/chat/completions';
    final prompt = """
    Explique o versículo abaixo em português, de forma clara e objetiva para um iniciante. Separe a resposta em três partes distintas usando os seguintes títulos exatos:
    
    ### Contexto Histórico
    
    ### Aplicação Prática
    
    ### Referências Cruzadas
    
    Versículo: "$fullVerseText"
    """;

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $apiKey',
        },
        body: jsonEncode({
          'model': 'gpt-3.5-turbo',
          'messages': [
            {'role': 'user', 'content': prompt}
          ],
          'max_tokens': 500,
          'temperature': 0.7,
        }),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(utf8.decode(response.bodyBytes));
        return data['choices'][0]['message']['content'].trim();
      } else {
        final errorBody = json.decode(response.body);
        throw 'Erro na API da OpenAI: ${errorBody['error']['message']}';
      }
    } catch (e) {
      // Rethrow custom or network errors.
      rethrow;
    }
  }

  /// Saves a generated study to Firestore for the current user.
  ///
  /// [study]: The [Study] object containing the verse, text, and timestamp.
  Future<void> saveStudy(Study study) async {
    final user = _auth.currentUser;
    if (user == null) {
      throw 'Usuário não autenticado. Faça login para salvar estudos.';
    }

    try {
      await _firestore
          .collection('studies')
          .doc(user.uid)
          .collection('user_studies')
          .add(study.toJson());
    } catch (e) {
      throw 'Erro ao salvar o estudo no Firestore. Tente novamente.';
    }
  }
}
