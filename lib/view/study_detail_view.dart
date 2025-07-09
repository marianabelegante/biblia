import 'package:flutter/material.dart';
import '../model/study_model.dart';
import 'webview_view.dart'; // Import the new WebView

class StudyDetailView extends StatelessWidget {
  final Study study;

  const StudyDetailView({super.key, required this.study});

  @override
  Widget build(BuildContext context) {
    final sections = _parseStudyText(study.studyText);
    final List<String> urls = _extractUrls(study.studyText);

    return Scaffold(
      appBar: AppBar(
        title: Text(study.verse),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (urls.isNotEmpty) ...[
              ...urls.map((url) => ElevatedButton.icon(
                    icon: const Icon(Icons.link),
                    label: const Text('Abrir Link de Referência'),
                    onPressed: () => _openWebView(context, url),
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  )),
              const SizedBox(height: 16),
            ],
            ...sections.entries.map((entry) {
              return Card(
                margin: const EdgeInsets.only(bottom: 16.0),
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        entry.key,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const Divider(height: 20),
                      Text(
                        entry.value,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              height: 1.5,
                            ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  /// Parses the study text into sections.
  Map<String, String> _parseStudyText(String text) {
    final sections = <String, String>{};
    final RegExp exp = RegExp(r'###\s*(.*?)([\s\S]*?)(?=\s*###|$)');
    final matches = exp.allMatches(text);

    for (final match in matches) {
      final title = match.group(1)?.trim() ?? '';
      final content = match.group(2)?.trim() ?? '';
      if (title.isNotEmpty && content.isNotEmpty) {
        sections[title] = content;
      }
    }
    if (sections.isEmpty && text.trim().isNotEmpty) {
      return {'Estudo Completo': text.replaceAll('###', '').trim()};
    }
    return sections;
  }

  /// Extracts URLs from the study text.
  List<String> _extractUrls(String text) {
    final RegExp urlRegex = RegExp(
      r'https?:\/\/(www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}([-a-zA-Z0-9()@:%_\+.~#?&//=]*)',
      caseSensitive: false,
    );
    return urlRegex.allMatches(text).map((m) => m.group(0)!).toList();
  }

  /// Navigates to the WebView screen.
  void _openWebView(BuildContext context, String url) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => WebViewView(url: url),
      ),
    );
  }
}
