import 'package:flutter/material.dart';
import '../controller/bible_controller.dart';
import '../data/bible_data.dart'; // Import the new data file

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final BibleController _bibleController = BibleController();
  final _searchController = TextEditingController();

  // Load the list of books from our local data map
  final List<String> _bibleBooks = bibleChapterCount.keys.toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bíblia Sagrada'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildManualSearchField(),
            const SizedBox(height: 20),
            const Text(
              'Ou selecione um livro',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const Divider(),
            Expanded(child: _buildBookList()),
          ],
        ),
      ),
    );
  }

  // Widget for the manual search text field and button
  Widget _buildManualSearchField() {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _searchController,
            decoration: const InputDecoration(
              labelText: 'Digite a referência (ex: João 3)',
              border: OutlineInputBorder(),
            ),
            onSubmitted: (value) {
                _bibleController.buscarPorReferencia(context, _searchController.text);
            },
          ),
        ),
        const SizedBox(width: 8),
        IconButton(
          onPressed: () {
            _bibleController.buscarPorReferencia(context, _searchController.text);
          },
          icon: const Icon(Icons.search),
          style: IconButton.styleFrom(
            padding: const EdgeInsets.all(15),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(12)),
            )
          ),
        ),
      ],
    );
  }

  // Widget for the list of Bible books
  Widget _buildBookList() {
    return ListView.builder(
      itemCount: _bibleBooks.length,
      itemBuilder: (context, index) {
        final book = _bibleBooks[index];
        return ListTile(
          title: Text(book),
          trailing: const Icon(Icons.arrow_forward_ios, size: 14),
          // Updated onTap to navigate to the new ChapterView
          onTap: () => _bibleController.navigateToChapterView(context, book),
        );
      },
    );
  }
}
