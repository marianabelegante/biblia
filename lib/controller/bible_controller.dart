import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../model/bible_model.dart';
import '../service/bible_service.dart';

class BibleController extends GetxController {
  final BibleService _bibleService = BibleService();
  final TextEditingController searchController = TextEditingController();

  var books = <Book>[].obs;
  var filteredBooks = <Book>[].obs;
  var verses = <Verse>[].obs;
  var isLoading = true.obs;
  var selectedBook = Rx<Book?>(null);
  var selectedChapter = Rx<int?>(null);

  @override
  void onInit() {
    super.onInit();
    fetchBooks();
    searchController.addListener(() {
      filterBooks(searchController.text);
    });
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }

  void fetchBooks() async {
    try {
      isLoading.value = true;
      var fetchedBooks = await _bibleService.getBooks();
      books.assignAll(fetchedBooks);
      filteredBooks.assignAll(fetchedBooks);
    } catch (e) {
      Get.snackbar('Erro', 'Não foi possível carregar os livros.');
      print(e);
    } finally {
      isLoading.value = false;
    }
  }

  void filterBooks(String query) {
    if (query.isEmpty) {
      filteredBooks.assignAll(books);
    } else {
      filteredBooks.assignAll(books
          .where((book) => book.name.toLowerCase().contains(query.toLowerCase()))
          .toList());
    }
  }

  void selectBook(Book book) {
    selectedBook.value = book;
    selectedChapter.value = null; // Reseta o capítulo ao selecionar um novo livro
    verses.clear();
  }

  void fetchVerses(String bookName, int chapter) async {
    try {
      isLoading.value = true;
      selectedChapter.value = chapter;
      // A API pode requerer abreviações ou nomes específicos.
      // Aqui usamos o nome do livro, que pode precisar de ajuste.
      var fetchedVerses = await _bibleService.getVerses(bookName, chapter);
      verses.assignAll(fetchedVerses);
    } catch (e) {
      Get.snackbar('Erro', 'Não foi possível carregar o capítulo.');
      print(e);
    } finally {
      isLoading.value = false;
    }
  }

  void resetToBookSelection() {
    selectedBook.value = null;
    selectedChapter.value = null;
    verses.clear();
  }
}
