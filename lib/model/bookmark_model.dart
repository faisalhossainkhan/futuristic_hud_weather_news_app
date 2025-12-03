class BookmarkedArticle {
  final String url;
  final String title;
  final DateTime bookmarkedAt;

  BookmarkedArticle({
    required this.url,
    required this.title,
    required this.bookmarkedAt,
  });

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'url': url,
      'title': title,
      'bookmarkedAt': bookmarkedAt.toIso8601String(),
    };
  }

  /// Create from JSON
  factory BookmarkedArticle.fromJson(Map<String, dynamic> json) {
    return BookmarkedArticle(
      url: json['url'],
      title: json['title'],
      bookmarkedAt: DateTime.parse(json['bookmarkedAt']),
    );
  }
}