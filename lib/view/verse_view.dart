import 'package:flutter/material.dart';
import '../controller/study_controller.dart';
import '../model/verse_model.dart';

class VersesView extends StatelessWidget {
  final String reference;
  final List<Verse> verses;
  final StudyController _studyController = StudyController();

  VersesView({
    super.key,
    required this.reference,
    required this.verses,
  });

  @override
  Widget build(BuildContext context) {
    final String title = reference;

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: verses.length,
        itemBuilder: (context, index) {
          final verse = verses[index];
          final verseReference = '${verse.book_name} ${verse.chapter}:${verse.verse}';
          final fullVerseText = '$verseReference — ${verse.text}';

          return Card(
            margin: const EdgeInsets.symmetric(vertical: 6.0),
            child: InkWell(
              onTap: () {
                // Call the controller to generate the study
                _studyController.handleGenerateStudy(context, fullVerseText, verseReference);
              },
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: '${verse.verse} ',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      TextSpan(
                        text: verse.text,
                        style: const TextStyle(fontSize: 16, height: 1.5),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
