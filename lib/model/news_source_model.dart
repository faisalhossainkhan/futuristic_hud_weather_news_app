// News source configuration
class NewsSource {
  final String id;
  final String name;
  final String category;
  final String? country;
  final String? language;

  const NewsSource({
    required this.id,
    required this.name,
    required this.category,
    this.country,
    this.language,
  });

  /// Create a copy with modified fields
  NewsSource copyWith({
    String? id,
    String? name,
    String? category,
    String? country,
    String? language,
  }) {
    return NewsSource(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      country: country ?? this.country,
      language: language ?? this.language,
    );
  }
}
