import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/auth_controller.dart';
import '../controller/bible_controller.dart';
import '../model/bible_model.dart';

class BibleView extends StatelessWidget {
  BibleView({super.key});

  final BibleController _bibleController = Get.put(BibleController());
  final AuthController _authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Obx(() {
          if (_bibleController.selectedBook.value == null) {
            return const Text('Livros da Bíblia');
          } else if (_bibleController.selectedChapter.value == null) {
            return Text(_bibleController.selectedBook.value!.name);
          } else {
            return Text('${_bibleController.selectedBook.value!.name} ${_bibleController.selectedChapter.value}');
          }
        }),
        leading: Obx(() {
          if (_bibleController.selectedBook.value != null) {
            return IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                _bibleController.resetToBookSelection();
              },
            );
          }
          return const SizedBox.shrink();
        }),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _authController.logout,
          ),
        ],
      ),
      body: Obx(() {
        if (_bibleController.isLoading.value && _bibleController.books.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }
        if (_bibleController.selectedBook.value == null) {
          return _buildBookList();
        } else if (_bibleController.selectedChapter.value == null) {
          return _buildChapterGrid(_bibleController.selectedBook.value!);
        } else {
          return _buildVerseList();
        }
      }),
    );
  }

  Widget _buildBookList() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            onChanged: _bibleController.filterBooks,
            decoration: const InputDecoration(
              labelText: 'Buscar Livro',
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(),
            ),
          ),
        ),
        Expanded(
          child: Obx(() => ListView.builder(
                itemCount: _bibleController.filteredBooks.length,
                itemBuilder: (context, index) {
                  final book = _bibleController.filteredBooks[index];
                  return ListTile(
                    title: Text(book.name),
                    onTap: () => _bibleController.selectBook(book),
                  );
                },
              )),
        ),
      ],
    );
  }

  Widget _buildChapterGrid(Book book) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 5,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: book.chapters,
      itemBuilder: (context, index) {
        final chapter = index + 1;
        return InkWell(
          onTap: () => _bibleController.fetchVerses(book.name, chapter),
          child: CircleAvatar(
            child: Text('$chapter'),
          ),
        );
      },
    );
  }

  Widget _buildVerseList() {
    return Obx(() {
      if (_bibleController.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }
      return ListView.builder(
        itemCount: _bibleController.verses.length,
        itemBuilder: (context, index) {
          final verse = _bibleController.verses[index];
          // Removido o botão de estudo com IA
          return ListTile(
            title: Text('${verse.number} ${verse.text}'),
          );
        },
      );
    });
  }
}
