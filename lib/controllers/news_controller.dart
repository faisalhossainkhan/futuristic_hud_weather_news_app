import 'package:get/get.dart';
import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import '../../constants/app_constants.dart';
import '../model/news_models.dart';

/// News Controller
/// Manages news fetching from multiple sources, search, and bookmarks
class NewsController extends GetxController {

  /// Global news articles
  final RxList<NewsArticle> globalNews = <NewsArticle>[].obs;

  /// Sub-continent news articles
  final RxList<NewsArticle> subContinentNews = <NewsArticle>[].obs;

  /// Search results
  final RxList<NewsArticle> searchResults = <NewsArticle>[].obs;

  /// Loading states
  final RxBool isLoadingGlobal = false.obs;
  final RxBool isLoadingSubContinent = false.obs;
  final RxBool isSearching = false.obs;

  /// Error message
  final RxString errorMessage = ''.obs;

  /// Bookmarked article URLs
  final RxSet<String> bookmarkedUrls = <String>{}.obs;

  /// Current search query
  final RxString currentSearchQuery = ''.obs;

  /// Last update timestamps
  final Rx<DateTime?> lastGlobalUpdate = Rx<DateTime?>(null);
  final Rx<DateTime?> lastSubContinentUpdate = Rx<DateTime?>(null);

  /// Auto-refresh enabled
  final RxBool autoRefreshEnabled = true.obs;

  Timer? _refreshTimer;
  int _retryCountGlobal = 0;
  int _retryCountSubContinent = 0;

  @override
  void onInit() {
    super.onInit();
    _initializeNews();
  }

  @override
  void onClose() {
    _refreshTimer?.cancel();
    super.onClose();
  }

  /// Initialize news feeds on startup
  Future<void> _initializeNews() async {
    await Future.wait([
      fetchGlobalNews(),
      fetchSubContinentNews(),
    ]);
    _startAutoRefresh();
  }

  /// Start auto-refresh timer
  void _startAutoRefresh() {
    if (!FeatureFlags.enableAutoRefresh) return;

    _refreshTimer?.cancel();
    _refreshTimer = Timer.periodic(
      Duration(seconds: kNewsRefreshInterval),
          (_) {
        if (autoRefreshEnabled.value) {
          refreshAllNews(silent: true);
        }
      },
    );
  }

  /// Fetch global news from major sources
  Future<void> fetchGlobalNews({bool silent = false}) async {
    try {
      if (!silent) {
        isLoadingGlobal.value = true;
        errorMessage.value = '';
      }

      // Check if we should use mock data
      if (kUseMockNews || kNewsApiKey == 'YOUR_NEWSAPI_KEY') {
        await _loadMockGlobalNews();
        return;
      }

      // Create sources query string
      final sourcesIds = kGlobalNewsSources.map((s) => s.id).join(',');
      final uri = Uri.parse(
          '$kNewsBaseUrl/top-headlines?sources=$sourcesIds&pageSize=$kNewsPageSize&apiKey=$kNewsApiKey'
      );

      final response = await http.get(uri).timeout(
        kConnectionTimeout,
        onTimeout: () => throw TimeoutException(ErrorMessages.timeout),
      );

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        final articlesList = jsonResponse['articles'] as List;

        globalNews.value = articlesList
            .asMap()
            .entries
            .map((entry) => NewsArticle.fromJson(entry.value, entry.key))
            .toList();

        lastGlobalUpdate.value = DateTime.now();
        _retryCountGlobal = 0;

        if (!silent) {
          Get.snackbar(
            'Success',
            'Global news updated',
            snackPosition: SnackPosition.BOTTOM,
            duration: const Duration(seconds: 2),
          );
        }
      } else if (response.statusCode == 401) {
        throw Exception(ErrorMessages.invalidApiKey);
      } else if (response.statusCode == 429) {
        throw Exception('Rate limit exceeded. Please try again later.');
      } else {
        throw Exception('HTTP ${response.statusCode}: ${response.reasonPhrase}');
      }
    } catch (e) {
      _handleGlobalNewsError(e, silent);
    } finally {
      if (!silent) {
        isLoadingGlobal.value = false;
      }
    }
  }

  /// Load mock global news for testing
  Future<void> _loadMockGlobalNews() async {
    await Future.delayed(const Duration(milliseconds: 1500));

    globalNews.value = [
      NewsArticle(
        id: 1,
        title: 'EUROPEAN DATA CLOUD SECURED AFTER RANSOM ATTACK',
        category: 'TECHNOLOGY',
        time: '02:10',
        source: 'Al Jazeera',
        description: 'The massive breach was contained by joint forces.',
        url: 'https://mocklink.com/eu-hack',
        imageUrl: kPlaceholderImageUrl,
        content: 'Security report from Al Jazeera...',
        publishedAt: DateTime.now().subtract(const Duration(hours: 2)),
      ),
      NewsArticle(
        id: 2,
        title: 'GLOBAL FOOD SYNTHESIS INITIATIVE LAUNCHED',
        category: 'GENERAL',
        time: '01:55',
        source: 'BBC News',
        description: 'New labs in Africa and Asia aim to scale up algae-based food production.',
        url: 'https://mocklink.com/food-synth',
        imageUrl: kPlaceholderImageUrl,
        content: 'BBC reports on food innovation...',
        publishedAt: DateTime.now().subtract(const Duration(hours: 3)),
      ),
      NewsArticle(
        id: 3,
        title: 'SOCCER BOT LEAGUE EXPANDS TO SOUTH AMERICA',
        category: 'SPORTS',
        time: '01:40',
        source: 'ESPN',
        description: 'Brazilian and Argentine leagues join the international humanoid soccer circuit.',
        url: 'https://mocklink.com/soccer-bot',
        imageUrl: kPlaceholderImageUrl,
        content: 'Sports coverage from ESPN...',
        publishedAt: DateTime.now().subtract(const Duration(hours: 4)),
      ),
    ];

    lastGlobalUpdate.value = DateTime.now();
  }


  /// Fetch news from sub-continent countries
  Future<void> fetchSubContinentNews({bool silent = false}) async {
    try {
      if (!silent) {
        isLoadingSubContinent.value = true;
      }

      // Check if we should use mock data
      if (kUseMockNews || kNewsApiKey == 'YOUR_NEWSAPI_KEY') {
        await _loadMockSubContinentNews();
        return;
      }

      List<NewsArticle> allArticles = [];
      int articleId = 0;

      // Fetch news from each sub-continent country
      for (String countryCode in kSubContinentCountries) {
        try {
          final uri = Uri.parse(
              '$kNewsBaseUrl/top-headlines?country=$countryCode&pageSize=10&apiKey=$kNewsApiKey'
          );

          final response = await http.get(uri).timeout(
            kConnectionTimeout,
            onTimeout: () => throw TimeoutException(ErrorMessages.timeout),
          );

          if (response.statusCode == 200) {
            final jsonResponse = json.decode(response.body);
            final articlesList = jsonResponse['articles'] as List;

            final articles = articlesList.map((article) {
              final newsArticle = NewsArticle.fromJson(article, articleId);
              articleId++;
              return newsArticle;
            }).toList();

            allArticles.addAll(articles);
          }
        } catch (e) {
          //print('Error fetching news for $countryCode: $e');
          // Continue with other countries even if one fails
        }
      }

      // Sort by published date (most recent first)
      allArticles.sort((a, b) => b.publishedAt.compareTo(a.publishedAt));

      // Limit to max items
      subContinentNews.value = allArticles.take(kNewsPageSize).toList();
      lastSubContinentUpdate.value = DateTime.now();
      _retryCountSubContinent = 0;

      if (!silent) {
        Get.snackbar(
          'Success',
          'Sub-continent news updated',
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 2),
        );
      }
    } catch (e) {
      _handleSubContinentNewsError(e, silent);
    } finally {
      if (!silent) {
        isLoadingSubContinent.value = false;
      }
    }
  }

  /// Load mock sub-continent news for testing
  Future<void> _loadMockSubContinentNews() async {
    await Future.delayed(const Duration(milliseconds: 1500));

    subContinentNews.value = [
      NewsArticle(
        id: 10,
        title: 'INDIA LAUNCHES NEW SPACE MISSION TO MARS',
        category: 'TECHNOLOGY',
        time: '03:15',
        source: 'Times of India',
        description: 'ISRO announces ambitious new Mars exploration program.',
        url: 'https://mocklink.com/india-mars',
        imageUrl: kPlaceholderImageUrl,
        content: 'India space program update...',
        publishedAt: DateTime.now().subtract(const Duration(hours: 1)),
      ),
      NewsArticle(
        id: 11,
        title: 'BANGLADESH CRICKET TEAM WINS CHAMPIONSHIP',
        category: 'SPORTS',
        time: '02:45',
        source: 'The Daily Star',
        description: 'Historic victory in the regional cricket tournament.',
        url: 'https://mocklink.com/bd-cricket',
        imageUrl: kPlaceholderImageUrl,
        content: 'Cricket championship report...',
        publishedAt: DateTime.now().subtract(const Duration(hours: 2)),
      ),
      NewsArticle(
        id: 12,
        title: 'PAKISTAN ANNOUNCES ECONOMIC REFORMS',
        category: 'BUSINESS',
        time: '02:30',
        source: 'Dawn',
        description: 'New policies aimed at boosting economic growth.',
        url: 'https://mocklink.com/pk-economy',
        imageUrl: kPlaceholderImageUrl,
        content: 'Economic policy update...',
        publishedAt: DateTime.now().subtract(const Duration(hours: 3)),
      ),
    ];

    lastSubContinentUpdate.value = DateTime.now();
  }

  /// Search news articles
  Future<void> searchNews(String query) async {
    if (query.trim().isEmpty) {
      clearSearch();
      return;
    }

    // Validate query length
    if (query.length < ValidationRules.minSearchQueryLength) {
      Get.snackbar(
        'Error',
        'Search query too short. Minimum ${ValidationRules.minSearchQueryLength} characters.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    if (query.length > ValidationRules.maxSearchQueryLength) {
      Get.snackbar(
        'Error',
        'Search query too long. Maximum ${ValidationRules.maxSearchQueryLength} characters.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    try {
      isSearching.value = true;
      currentSearchQuery.value = query;

      // Check if we should use mock data
      if (kUseMockNews || kNewsApiKey == 'YOUR_NEWSAPI_KEY') {
        await _performMockSearch(query);
        return;
      }

      final uri = Uri.parse(
          '$kNewsBaseUrl/everything?q=${Uri.encodeQueryComponent(query)}&pageSize=$kMaxSearchResults&apiKey=$kNewsApiKey&sortBy=publishedAt'
      );

      final response = await http.get(uri).timeout(
        kConnectionTimeout,
        onTimeout: () => throw TimeoutException(ErrorMessages.timeout),
      );

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        final articlesList = jsonResponse['articles'] as List;

        searchResults.value = articlesList
            .asMap()
            .entries
            .map((entry) => NewsArticle.fromJson(entry.value, entry.key))
            .toList();

        Get.snackbar(
          'Search Complete',
          'Found ${searchResults.length} results',
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 2),
        );
      } else if (response.statusCode == 401) {
        throw Exception(ErrorMessages.invalidApiKey);
      } else {
        throw Exception('Search failed');
      }
    } catch (e) {
      //print('Search error: $e');
      errorMessage.value = ErrorMessages.searchFailed;

      Get.snackbar(
        'Search Error',
        ErrorMessages.searchFailed,
        snackPosition: SnackPosition.BOTTOM,
      );

      searchResults.clear();
    } finally {
      isSearching.value = false;
    }
  }

  /// Perform mock search for testing
  Future<void> _performMockSearch(String query) async {
    await Future.delayed(const Duration(milliseconds: 800));

    final lowerQuery = query.toLowerCase();

    // Filter existing news based on query
    final allNews = [...globalNews, ...subContinentNews];
    searchResults.value = allNews
        .where((article) =>
    article.title.toLowerCase().contains(lowerQuery) ||
        (article.description?.toLowerCase().contains(lowerQuery) ?? false))
        .toList();

    // If no results, create some mock results
    if (searchResults.isEmpty) {
      searchResults.value = [
        NewsArticle(
          id: 100,
          title: 'SEARCH RESULT: ${query.toUpperCase()} RELATED NEWS',
          category: 'GENERAL',
          time: '01:00',
          source: 'Search Engine',
          description: 'Mock search result for demonstration purposes.',
          url: 'https://mocklink.com/search',
          imageUrl: kPlaceholderImageUrl,
          content: 'Mock search content...',
          publishedAt: DateTime.now(),
        ),
      ];
    }
  }

  /// Clear search results
  void clearSearch() {
    searchResults.clear();
    currentSearchQuery.value = '';
  }

  // ==================== BOOKMARKS ====================

  /// Toggle bookmark for an article
  void toggleBookmark(NewsArticle article) {
    if (article.url == null) return;

    if (bookmarkedUrls.contains(article.url)) {
      bookmarkedUrls.remove(article.url);
      Get.snackbar(
        'Bookmark',
        SuccessMessages.bookmarkRemoved,
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 1),
      );
    } else {
      bookmarkedUrls.add(article.url!);
      Get.snackbar(
        'Bookmark',
        SuccessMessages.bookmarkAdded,
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 1),
      );
    }

    // TODO: Persist bookmarks to local storage
  }

  /// Check if article is bookmarked
  bool isBookmarked(NewsArticle article) {
    return article.url != null && bookmarkedUrls.contains(article.url!);
  }

  /// Get all bookmarked articles
  List<NewsArticle> get bookmarkedArticles {
    final allNews = [...globalNews, ...subContinentNews, ...searchResults];
    return allNews.where((article) => isBookmarked(article)).toList();
  }


  /// Refresh all news feeds
  Future<void> refreshAllNews({bool silent = false}) async {
    await Future.wait([
      fetchGlobalNews(silent: silent),
      fetchSubContinentNews(silent: silent),
    ]);
  }

  /// Retry global news fetch
  Future<void> retryGlobal() async {
    if (_retryCountGlobal < kMaxRetryAttempts) {
      _retryCountGlobal++;
      await fetchGlobalNews();
    } else {
      Get.snackbar(
        'Error',
        'Maximum retry attempts reached for global news',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  /// Retry sub-continent news fetch
  Future<void> retrySubContinent() async {
    if (_retryCountSubContinent < kMaxRetryAttempts) {
      _retryCountSubContinent++;
      await fetchSubContinentNews();
    } else {
      Get.snackbar(
        'Error',
        'Maximum retry attempts reached for sub-continent news',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  /// Toggle auto-refresh
  void toggleAutoRefresh(bool enabled) {
    autoRefreshEnabled.value = enabled;
    if (enabled) {
      _startAutoRefresh();
    } else {
      _refreshTimer?.cancel();
    }
  }

  /// Filter news by category
  List<NewsArticle> filterByCategory(List<NewsArticle> articles, String category) {
    if (category == 'ALL') return articles;
    return articles.where((article) => article.category == category).toList();
  }

  /// Get news by category from global feed
  List<NewsArticle> getGlobalByCategory(String category) {
    return filterByCategory(globalNews, category);
  }

  /// Get news by category from sub-continent feed
  List<NewsArticle> getSubContinentByCategory(String category) {
    return filterByCategory(subContinentNews, category);
  }

  /// Check if any news is loading
  bool get isAnyLoading =>
      isLoadingGlobal.value || isLoadingSubContinent.value || isSearching.value;

  /// Get total news count
  int get totalNewsCount => globalNews.length + subContinentNews.length;

  /// Get total bookmarks count
  int get bookmarksCount => bookmarkedUrls.length;

  /// Check if global data is stale
  bool get isGlobalDataStale {
    if (lastGlobalUpdate.value == null) return true;
    final now = DateTime.now();
    final difference = now.difference(lastGlobalUpdate.value!);
    return difference.inSeconds > kNewsRefreshInterval;
  }

  /// Check if sub-continent data is stale
  bool get isSubContinentDataStale {
    if (lastSubContinentUpdate.value == null) return true;
    final now = DateTime.now();
    final difference = now.difference(lastSubContinentUpdate.value!);
    return difference.inSeconds > kNewsRefreshInterval;
  }

  /// Get category statistics
  Map<String, int> get categoryStats {
    final allNews = [...globalNews, ...subContinentNews];
    final stats = <String, int>{};

    for (var article in allNews) {
      stats[article.category] = (stats[article.category] ?? 0) + 1;
    }

    return stats;
  }

  /// Handle global news errors
  void _handleGlobalNewsError(dynamic error, bool silent) {
    String message = ErrorMessages.newsUnavailable;

    if (error is TimeoutException) {
      message = ErrorMessages.timeout;
    } else if (error.toString().contains('Invalid API key')) {
      message = ErrorMessages.invalidApiKey;
    } else if (error.toString().contains('SocketException')) {
      message = ErrorMessages.networkError;
    } else if (error.toString().contains('Rate limit')) {
      message = 'Rate limit exceeded. Please try again later.';
    }

    errorMessage.value = message;

    if (!silent) {
      Get.snackbar(
        'Error',
        'Global news: $message',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Get.theme.colorScheme.error.withValues(alpha:0.1),
        duration: const Duration(seconds: 3),
      );
    }

    // Try to load mock data as fallback
    if (!kUseMockNews && _retryCountGlobal == 0) {
      _loadMockGlobalNews();
    }

    //print('Global News Error: $error');
  }

  /// Handle sub-continent news errors
  void _handleSubContinentNewsError(dynamic error, bool silent) {
    String message = ErrorMessages.newsUnavailable;

    if (error is TimeoutException) {
      message = ErrorMessages.timeout;
    } else if (error.toString().contains('SocketException')) {
      message = ErrorMessages.networkError;
    }

    if (!silent) {
      Get.snackbar(
        'Error',
        'Sub-continent news: $message',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Get.theme.colorScheme.error.withValues(alpha:0.1),
        duration: const Duration(seconds: 3),
      );
    }

    // Try to load mock data as fallback
    if (!kUseMockNews && _retryCountSubContinent == 0) {
      _loadMockSubContinentNews();
    }

    //print('Sub-continent News Error: $error');
  }
}