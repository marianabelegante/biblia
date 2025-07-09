import 'package:flutter/material.dart';
import '../controller/study_controller.dart';

class StudyView extends StatelessWidget {
  final String verseReference;
  final String studyText;
  final StudyController _studyController = StudyController();

  StudyView({
    super.key,
    required this.verseReference,
    required this.studyText,
  });

  @override
  Widget build(BuildContext context) {
    // A chamada para a função de parse agora usa a nova implementação.
    final sections = _parseStudyText(studyText);

    return Scaffold(
      appBar: AppBar(
        title: Text('Estudo de $verseReference'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: sections.entries.map((entry) {
            return Card(
              margin: const EdgeInsets.only(bottom: 16.0),
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      entry.key, // Título da Seção
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const Divider(height: 20),
                    Text(
                      entry.value, // Conteúdo da Seção
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            height: 1.5,
                          ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          _studyController.handleSaveStudy(context, verseReference, studyText);
        },
        label: const Text('Salvar Estudo'),
        icon: const Icon(Icons.save),
      ),
    );
  }

  /// Parses the raw study text from OpenAI into a map of sections.
  /// This version has been rewritten to be simple and syntactically correct.
  Map<String, String> _parseStudyText(String text) {
    final sections = <String, String>{};
    
    // The RegExp is now correctly defined on a single line.
    final RegExp exp = RegExp(r'###\s*(.*?) ([\s\S]*?)(?=\s*###|$)');
    final matches = exp.allMatches(text);

    for (final match in matches) {
      // Group 1 captures the title, Group 2 captures the content.
      final title = match.group(1)?.trim() ?? '';
      final content = match.group(2)?.trim() ?? '';

      if (title.isNotEmpty && content.isNotEmpty) {
        sections[title] = content;
      }
    }

    // A simple and safe fallback: if no sections were parsed but the text is not empty,
    // show the entire text under a generic title. This prevents crashes.
    if (sections.isEmpty && text.trim().isNotEmpty) {
      return {'Estudo Completo': text.replaceAll('###', '').trim()};
    }

    return sections;
  }
}
