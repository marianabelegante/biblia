import 'package:flutter/material.dart';
import '../model/verse_model.dart';
import '../service/bible_service.dart';
import '../view/chapter_view.dart';
import '../view/verse_view.dart';

class BibleController {
  final BibleService _bibleService = BibleService();
  bool isLoading = false;

  /// Shows a loading dialog.
  void _showLoadingDialog(BuildContext context) {
    isLoading = true;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const Center(child: CircularProgressIndicator());
      },
    );
  }

  /// Hides the loading dialog.
  void _hideLoadingDialog(BuildContext context) {
    if (isLoading) {
      // Check if the navigator can be popped.
      if(Navigator.canPop(context)) {
          Navigator.of(context).pop();
      }
      isLoading = false;
    }
  }

  /// Shows an error message in a SnackBar.
  void _showErrorSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.redAccent,
      ),
    );
  }

  /// Navigates to the chapter selection view.
  void navigateToChapterView(BuildContext context, String bookName) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChapterView(bookName: bookName),
      ),
    );
  }

  /// Fetches verses based on a string reference and navigates to the results.
  Future<void> buscarPorReferencia(BuildContext context, String reference) async {
    if (reference.isEmpty) {
      _showErrorSnackbar(context, 'O campo de busca não pode estar vazio.');
      return;
    }
    
    // When coming from ChapterView, a dialog might already be open from a previous search.
    // Ensure no loading dialog is active before showing a new one.
    if(isLoading) _hideLoadingDialog(context);

    _showLoadingDialog(context);

    try {
      final verses = await _bibleService.getVerses(reference);
      _hideLoadingDialog(context);
      
      // Navigate to the VersesView screen with the result
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => VersesView(
            // Use the reference passed to the function for the title
            reference: reference.trim(),
            verses: verses,
          ),
        ),
      );
    } catch (e) {
      _hideLoadingDialog(context);
      _showErrorSnackbar(context, e.toString());
    }
  }
}
