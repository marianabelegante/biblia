import 'package:cloud_firestore/cloud_firestore.dart';

class Study {
  final String id;
  final String verse;
  final String studyText;
  final DateTime createdAt;

  Study({
    required this.id,
    required this.verse,
    required this.studyText,
    required this.createdAt,
  });

  // Factory constructor to create a Study instance from a Firestore document
  factory Study.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Study(
      id: doc.id,
      verse: data['verse'] ?? 'Referência indisponível',
      studyText: data['studyText'] ?? 'Texto indisponível',
      // Convert Firestore Timestamp to DateTime
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }

  // Method to convert a Study instance to a JSON object for Firestore
  Map<String, dynamic> toJson() {
    return {
      'verse': verse,
      'studyText': studyText,
      'createdAt': Timestamp.fromDate(createdAt), // Convert DateTime to Firestore Timestamp
    };
  }
}
