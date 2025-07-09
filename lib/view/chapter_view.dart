import 'package:flutter/material.dart';
import '../controller/bible_controller.dart';
import '../data/bible_data.dart';

class ChapterView extends StatelessWidget {
  final String bookName;
  final BibleController _bibleController = BibleController();

  ChapterView({super.key, required this.bookName});

  @override
  Widget build(BuildContext context) {
    // Get the number of chapters for the selected book from our local map.
    final int chapterCount = bibleChapterCount[bookName] ?? 0;

    return Scaffold(
      appBar: AppBar(
        title: Text("Capítulos de $bookName"),
      ),
      body: ListView.builder(
        itemCount: chapterCount,
        itemBuilder: (context, index) {
          final chapter = index + 1;
          return ListTile(
            title: Text('Capítulo $chapter'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 14),
            onTap: () {
              // When a chapter is tapped, call the controller to fetch and display verses.
              final reference = '$bookName $chapter';
              _bibleController.buscarPorReferencia(context, reference);
            },
          );
        },
      ),
    );
  }
}
