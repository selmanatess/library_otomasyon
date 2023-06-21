class BookClass {
  final String name;
  final String imageUrl;
  final String publisher;
  final String category;
  final int Pagecount;
  BookClass(
      {required this.Pagecount,
      required this.category,
      required this.imageUrl,
      required this.name,
      required this.publisher});

  Map<String, dynamic> getjson() => {
        "name": name,
        "imageUrl": imageUrl,
        "publisher": publisher,
        "category": category,
        "Pagecount": Pagecount
      };
}
