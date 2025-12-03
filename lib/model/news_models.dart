import 'package:intl/intl.dart';

class NewsArticle {
  final int id;
  final String title;
  final String category;
  final String time;
  final String source;
  final String? description;
  final String? url;
  final String? imageUrl;
  final String? content;
  final DateTime publishedAt;

  NewsArticle({
    required this.id,
    required this.title,
    required this.category,
    required this.time,
    required this.source,
    this.description,
    this.url,
    this.imageUrl,
    this.content,
    required this.publishedAt,
  });

  /// Factory constructor to create NewsArticle from NewsAPI response
  factory NewsArticle.fromJson(Map<String, dynamic> json, int index) {
    final sourceName = json['source']['name'] ?? 'Unknown Source';
    final publishedAt = DateTime.parse(json['publishedAt']);
    final title = json['title']?.toString().toUpperCase() ?? '';
    final description = json['description']?.toString().toUpperCase() ?? '';
    final content = '$title $description';

    // Automatically categorize the article based on content
    final category = _categorizeNews(content);

    return NewsArticle(
      id: index,
      title: title,
      category: category,
      time: DateFormat('HH:mm').format(publishedAt),
      source: sourceName,
      description: json['description']?.toString() ?? 'No description available.',
      url: json['url']?.toString(),
      imageUrl: json['urlToImage']?.toString(),
      content: json['content']?.toString(),
      publishedAt: publishedAt,
    );
  }

  /// Categorize news based on keyword detection
  static String _categorizeNews(String content) {
    bool containsKeywords(List<String> keywords) {
      return keywords.any((keyword) => content.contains(keyword));
    }

    // Alert keywords - highest priority
    const alertKeywords = [
      'ALERT',
      'CRISIS',
      'OUTAGE',
      'EMERGENCY',
      'WARNING',
      'EVACUATION',
      'DISASTER',
      'HACK',
      'ATTACK',
      'BREACH',
      'THREAT',
    ];
    if (containsKeywords(alertKeywords)) return 'ALERT';

    // Business keywords
    const businessKeywords = [
      'BUSINESS',
      'FINANCE',
      'MARKET',
      'STOCK',
      'ECONOMY',
      'INVESTMENT',
      'MERGER',
      'ACQUISITION',
      'EARNINGS',
      'TRADING',
      'CEO',
      'COMPANY',
      'REVENUE',
      'PROFIT',
      'LOSS',
      'SHARES',
    ];
    if (containsKeywords(businessKeywords)) return 'BUSINESS';

    // Technology keywords
    const techKeywords = [
      'TECH',
      'AI',
      'ARTIFICIAL INTELLIGENCE',
      'QUANTUM',
      'ROBOT',
      'SOFTWARE',
      'CYBER',
      'SCIENCE',
      'RESEARCH',
      'DEVELOPMENT',
      'GADGET',
      'STARTUP',
      '5G',
      'CHIP',
      'COMPUTER',
      'INTERNET',
      'DATA',
      'CLOUD',
      'APP',
      'DIGITAL',
    ];
    if (containsKeywords(techKeywords)) return 'TECHNOLOGY';

    // Sports keywords
    const sportsKeywords = [
      'SPORT',
      'GAME',
      'LEAGUE',
      'CHAMPIONSHIP',
      'FOOTBALL',
      'BASKETBALL',
      'TENNIS',
      'CRICKET',
      'OLYMPICS',
      'RACE',
      'ATHLETE',
      'TEAM',
      'GOAL',
      'SCORE',
      'MATCH',
      'PLAYER',
      'TOURNAMENT',
      'WORLD CUP',
    ];
    if (containsKeywords(sportsKeywords)) return 'SPORTS';

    // Politics keywords
    const politicsKeywords = [
      'POLITICS',
      'GOVERNMENT',
      'ELECTION',
      'PRESIDENT',
      'PROTEST',
      'CONGRESS',
      'PARLIAMENT',
      'VOTE',
      'SENATE',
      'POLICY',
      'DIPLOMACY',
      'MINISTER',
      'PRIME MINISTER',
      'REPUBLICAN',
      'DEMOCRAT',
      'LAW',
      'LEGISLATION',
    ];
    if (containsKeywords(politicsKeywords)) return 'POLITICS';

    // Default to GENERAL
    return 'GENERAL';
  }

  /// Create a copy with modified fields
  NewsArticle copyWith({
    int? id,
    String? title,
    String? category,
    String? time,
    String? source,
    String? description,
    String? url,
    String? imageUrl,
    String? content,
    DateTime? publishedAt,
  }) {
    return NewsArticle(
      id: id ?? this.id,
      title: title ?? this.title,
      category: category ?? this.category,
      time: time ?? this.time,
      source: source ?? this.source,
      description: description ?? this.description,
      url: url ?? this.url,
      imageUrl: imageUrl ?? this.imageUrl,
      content: content ?? this.content,
      publishedAt: publishedAt ?? this.publishedAt,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'category': category,
      'time': time,
      'source': source,
      'description': description,
      'url': url,
      'imageUrl': imageUrl,
      'content': content,
      'publishedAt': publishedAt.toIso8601String(),
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is NewsArticle && other.id == id && other.url == url;
  }

  @override
  int get hashCode => id.hashCode ^ url.hashCode;
}