import 'package:flutter/material.dart';
import '../model/study_model.dart';
import '../service/study_service.dart';
import '../view/study_detail_view.dart';

class StudyLibraryController {
  final StudyService _studyService = StudyService();

  /// Fetches the list of saved studies for the current user.
  Future<List<Study>> fetchSavedStudies() {
    try {
      return _studyService.getSavedStudies();
    } catch (e) {
      // The error will be caught by the FutureBuilder in the view.
      rethrow;
    }
  }

  /// Navigates to the detail view for a selected study.
  void navigateToStudyDetail(BuildContext context, Study study) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => StudyDetailView(study: study),
      ),
    );
  }
}
