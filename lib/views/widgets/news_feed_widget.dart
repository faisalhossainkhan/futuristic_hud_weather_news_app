import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../constants/app_constants.dart';
import '../../controllers/news_controller.dart';
import '../../model/news_models.dart';
import '../../theme/app_theme.dart';

enum NewsType { global, subContinent }

class NewsFeedWidget extends StatelessWidget {
  final String title;
  final NewsController newsController;
  final NewsType newsType;
  final ColorTheme theme;

  const NewsFeedWidget({
    super.key,
    required this.title,
    required this.newsController,
    required this.newsType,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14.0),
      decoration: AppTheme.getHudBoxDecoration(
        borderColor: theme.accent,
        shadowColor: theme.accent,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header with Search
          Container(
            padding: const EdgeInsets.only(bottom: 12.0),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: theme.accent.withValues(alpha:0.5),
                ),
              ),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Icon(Icons.public, color: theme.accent, size: 24),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        title,
                        style: AppTheme.getHudTextStyle(
                          color: theme.accent,
                          fontSize: 20.0,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.0,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    _SearchButton(
                      newsController: newsController,
                      theme: theme,
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                if (newsType == NewsType.global) _buildSourceTags(),
              ],
            ),
          ),
          const SizedBox(height: 12),
          // Search Results or News List
          Obx(() {
            if (newsController.currentSearchQuery.value.isNotEmpty) {
              return _SearchResults(
                newsController: newsController,
                theme: theme,
              );
            }

            final isLoading = newsType == NewsType.global
                ? newsController.isLoadingGlobal.value
                : newsController.isLoadingSubContinent.value;

            if (isLoading) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: CircularProgressIndicator(color: theme.primary),
                ),
              );
            }

            final news = newsType == NewsType.global
                ? newsController.globalNews
                : newsController.subContinentNews;

            if (news.isEmpty) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Text(
                    'NO NEWS AVAILABLE',
                    style: AppTheme.getHudTextStyle(
                      color: theme.accent,
                      fontSize: 14,
                    ),
                  ),
                ),
              );
            }

            return Column(
              children: news
                  .take(10)
                  .map((article) => _NewsArticleTile(
                article: article,
                newsController: newsController,
                theme: theme,
              ))
                  .toList(),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildSourceTags() {
    return Wrap(
      spacing: 8.0,
      runSpacing: 8.0,
      children: kGlobalNewsSources.take(6).map((source) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
          decoration: BoxDecoration(
            color: theme.primary.withValues(alpha:0.2),
            borderRadius: BorderRadius.circular(12.0),
            border: Border.all(color: theme.primary.withValues(alpha:0.5)),
          ),
          child: Text(
            source.name,
            style: AppTheme.getHudTextStyle(
              color: theme.primary,
              fontSize: 10,
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _SearchButton extends StatelessWidget {
  final NewsController newsController;
  final ColorTheme theme;

  const _SearchButton({
    required this.newsController,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.search, color: theme.primary),
      onPressed: () => _showSearchDialog(context),
    );
  }

  void _showSearchDialog(BuildContext context) {
    final searchController = TextEditingController();
    Get.dialog(
      AlertDialog(
        backgroundColor: kHudBackground,
        title: Text(
          'SEARCH NEWS',
          style: AppTheme.getHudTextStyle(
            color: theme.primary,
            fontSize: 18,
          ),
        ),
        content: TextField(
          controller: searchController,
          autofocus: true,
          style: AppTheme.getHudTextStyle(
            color: Colors.white,
            fontSize: 14,
          ),
          decoration: InputDecoration(
            hintText: 'Enter search query...',
            hintStyle: AppTheme.getHudTextStyle(
              color: Colors.grey,
              fontSize: 14,
            ),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: theme.primary),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: theme.accent),
            ),
            suffixIcon: IconButton(
              icon: Icon(Icons.clear, color: Colors.grey),
              onPressed: () => searchController.clear(),
            ),
          ),
          onSubmitted: (query) {
            if (query.trim().isNotEmpty) {
              newsController.searchNews(query);
              Get.back();
            }
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('CANCEL', style: TextStyle(color: theme.accent)),
          ),
          TextButton(
            onPressed: () {
              final query = searchController.text.trim();
              if (query.isNotEmpty) {
                newsController.searchNews(query);
                Get.back();
              }
            },
            child: Text('SEARCH', style: TextStyle(color: theme.primary)),
          ),
        ],
      ),
    );
  }
}

class _SearchResults extends StatelessWidget {
  final NewsController newsController;
  final ColorTheme theme;

  const _SearchResults({
    required this.newsController,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                'SEARCH: "${newsController.currentSearchQuery.value.toUpperCase()}"',
                style: AppTheme.getHudTextStyle(
                  color: theme.primary,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            IconButton(
              icon: Icon(Icons.close, color: theme.alert),
              onPressed: () => newsController.clearSearch(),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Obx(() {
          if (newsController.isSearching.value) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: CircularProgressIndicator(color: theme.primary),
              ),
            );
          }

          if (newsController.searchResults.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Text(
                  'NO RESULTS FOUND',
                  style: AppTheme.getHudTextStyle(
                    color: theme.accent,
                    fontSize: 14,
                  ),
                ),
              ),
            );
          }

          return Column(
            children: newsController.searchResults
                .take(10)
                .map((article) => _NewsArticleTile(
              article: article,
              newsController: newsController,
              theme: theme,
            ))
                .toList(),
          );
        }),
      ],
    );
  }
}

class _NewsArticleTile extends StatelessWidget {
  final NewsArticle article;
  final NewsController newsController;
  final ColorTheme theme;

  const _NewsArticleTile({
    required this.article,
    required this.newsController,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      // FIXED: Define isBookmarked using controller method
      final isBookmarked = newsController.isBookmarked(article);

      return GestureDetector(
        onTap: () => _showArticleDetail(context),
        child: Container(
          padding: const EdgeInsets.all(10.0),
          margin: const EdgeInsets.only(bottom: 10.0),
          decoration: BoxDecoration(
            border: Border.all(
              color: theme.accent.withValues(alpha:0.3),
            ),
            borderRadius: BorderRadius.circular(8.0),
            color: kHudBackground.withValues(alpha:0.5),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image
              ClipRRect(
                borderRadius: BorderRadius.circular(4.0),
                child: Image.network(
                  article.imageUrl ?? kPlaceholderImageUrl,
                  width: 80,
                  height: 60,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 80,
                      height: 60,
                      color: theme.primary.withValues(alpha:0.1),
                      child: Center(
                        child: Icon(
                          Icons.broken_image,
                          color: theme.alert.withValues(alpha:0.7),
                          size: 30,
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(width: 10),
              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            article.source,
                            style: AppTheme.getHudTextStyle(
                              color: theme.primary.withValues(alpha:0.8),
                              fontSize: 10,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 8),
                        // FIXED: Use defined isBookmarked variable
                        GestureDetector(
                          onTap: () => newsController.toggleBookmark(article),
                          child: Icon(
                            isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                            color: isBookmarked
                                ? theme.alert
                                : theme.accent.withValues(alpha:0.7),
                            size: 20,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      article.title,
                      style: AppTheme.getHudTextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            article.source,
                            style: AppTheme.getHudTextStyle(
                              color: Colors.grey,
                              fontSize: 10,
                            ).copyWith(fontStyle: FontStyle.italic),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '${article.time} UTC',
                          style: AppTheme.getHudTextStyle(
                            color: theme.accent.withValues(alpha:0.8),
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  void _showArticleDetail(BuildContext context) {
    Get.to(() => ArticleDetailView(
      article: article,
      newsController: newsController,
      theme: theme,
    ));
  }
}

class ArticleDetailView extends StatelessWidget {
  final NewsArticle article;
  final NewsController newsController;
  final ColorTheme theme;

  const ArticleDetailView({
    super.key,
    required this.article,
    required this.newsController,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    final categoryColor = AppTheme.getCategoryColor(article.category, theme);

    return Scaffold(
      backgroundColor: kHudBackground,
      appBar: AppBar(
        title: Text(
          'ARTICLE DETAIL',
          style: AppTheme.getHudTextStyle(
            color: theme.accent,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: kHudBackground,
        iconTheme: IconThemeData(color: theme.accent),
        elevation: 0,
        centerTitle: true,
        actions: [
          Obx(() {
            final isBookmarked = newsController.isBookmarked(article);
            return IconButton(
              icon: Icon(
                isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                color: isBookmarked ? theme.alert : theme.accent,
                size: 28,
              ),
              onPressed: () => newsController.toggleBookmark(article),
            );
          }),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Container(
            padding: const EdgeInsets.all(18.0),
            decoration: AppTheme.getHudBoxDecoration(
              borderColor: categoryColor,
              shadowColor: categoryColor.withValues(alpha:0.3),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image
                if (article.imageUrl != null)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Image.network(
                      article.imageUrl!,
                      width: double.infinity,
                      height: 220,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          width: double.infinity,
                          height: 220,
                          color: theme.primary.withValues(alpha:0.1),
                          child: Center(
                            child: Icon(
                              Icons.image_not_supported,
                              color: theme.alert,
                              size: 50,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                const SizedBox(height: 18),
                // Category and Time
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12.0,
                        vertical: 6.0,
                      ),
                      decoration: BoxDecoration(
                        color: categoryColor,
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: Text(
                        article.category,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Text(
                      '${article.time} UTC',
                      style: AppTheme.getHudTextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                // Title
                Text(
                  article.title,
                  style: AppTheme.getHudTextStyle(
                    color: Colors.white,
                    fontSize: 24.0,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 16),
                // Source
                Row(
                  children: [
                    Icon(Icons.source, color: theme.primary, size: 18),
                    const SizedBox(width: 8),
                    Text(
                      'SOURCE: ${article.source}',
                      style: AppTheme.getHudTextStyle(
                        color: theme.primary,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 16.0),
                  height: 1.0,
                  color: categoryColor.withValues(alpha:0.5),
                ),
                // Description
                if (article.description != null)
                  Container(
                    padding: const EdgeInsets.all(14.0),
                    decoration: BoxDecoration(
                      color: theme.primary.withValues(alpha:0.05),
                      borderRadius: BorderRadius.circular(8.0),
                      border: Border.all(
                        color: theme.primary.withValues(alpha:0.3),
                      ),
                    ),
                    child: Text(
                      article.description!,
                      style: AppTheme.getHudTextStyle(
                        color: Colors.white,
                        fontSize: 16.0,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                const SizedBox(height: 24),
                // External Link
                if (article.url != null)
                  Center(
                    child: OutlinedButton.icon(
                      icon: const Icon(Icons.open_in_browser, size: 20),
                      label: const Text('VIEW ORIGINAL SOURCE'),
                      onPressed: () async {
                        final uri = Uri.parse(article.url!);
                        if (await canLaunchUrl(uri)) {
                          await launchUrl(
                              uri, mode: LaunchMode.externalApplication);
                        }
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: theme.accent,
                        side: BorderSide(color: theme.accent, width: 2),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 14,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
