// ignore_for_file: non_constant_identifier_names

class Verse {
  final String book_name;
  final int chapter;
  final int verse;
  final String text;

  Verse({
    required this.book_name,
    required this.chapter,
    required this.verse,
    required this.text,
  });

  factory Verse.fromJson(Map<String, dynamic> json) {
    return Verse(
      book_name: json['book_name'],
      chapter: json['chapter'],
      verse: json['verse'],
      text: json['text'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'book_name': book_name,
      'chapter': chapter,
      'verse': verse,
      'text': text,
    };
  }
}
