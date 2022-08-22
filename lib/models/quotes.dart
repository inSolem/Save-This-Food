class Quotes {
  final String quote;
  final String author;

  Quotes({
    required this.quote,
    required this.author,
  });

  static Quotes fromJson(Map<String, dynamic> json) => Quotes(
        quote: json["quote"],
        author: json["author"],
      );
}
