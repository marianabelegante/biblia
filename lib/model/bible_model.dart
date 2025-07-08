class Book {
  final int id;
  final String name;
  final int chapters;

  Book({required this.id, required this.name, required this.chapters});

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      id: json['id'],
      name: json['name'],
      chapters: json['chapters'],
    );
  }
}

class Verse {
  final int number;
  final String text;

  Verse({required this.number, required this.text});

  factory Verse.fromJson(Map<String, dynamic> json) {
    return Verse(
      number: json['number'],
      text: json['text'],
    );
  }
}