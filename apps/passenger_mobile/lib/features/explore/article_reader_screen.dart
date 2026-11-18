import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:passenger_mobile/features/explore/article_api.dart';
import 'package:passenger_mobile/features/explore/article_markdown.dart';
import 'package:passenger_mobile/features/explore/explore_screen.dart';

const _ink = Color(0xFF142246);
const _body = Color(0xFF53617C);
const _blue = Color(0xFF078FC9);

/// Màn đọc một bài viết lấy từ API: ảnh bìa, chuyên mục, tiêu đề, nội dung Markdown và lời mời tìm chuyến.
class ArticleReaderScreen extends StatefulWidget {
  const ArticleReaderScreen({
    required this.slug,
    required this.loadArticle,
    this.onFindTrip,
    this.loadRelated,
    super.key,
  });

  final String slug;
  final Future<ArticleDetail> Function(String slug) loadArticle;
  final VoidCallback? onFindTrip;

  /// Bài cùng chuyên mục (slug chuyên mục, slug bài đang đọc); `null` = không hiện khối.
  final Future<List<ExploreArticle>> Function(
    String categorySlug,
    String excludeSlug,
  )?
  loadRelated;

  @override
  State<ArticleReaderScreen> createState() => _ArticleReaderScreenState();
}

class _ArticleReaderScreenState extends State<ArticleReaderScreen> {
  late Future<ArticleDetail> _article = widget.loadArticle(widget.slug);

  void _retry() {
    setState(() {
      _article = widget.loadArticle(widget.slug);
    });
  }

  void _openRelated(ExploreArticle article) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => ArticleReaderScreen(
          slug: article.slug,
          loadArticle: widget.loadArticle,
          onFindTrip: widget.onFindTrip,
          loadRelated: widget.loadRelated,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: Colors.white,
      ),
      child: Scaffold(
        key: const Key('article-reader-screen'),
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
          elevation: 0,
          scrolledUnderElevation: 1,
          shadowColor: const Color(0x1A21404F),
          centerTitle: true,
          leading: IconButton(
            key: const Key('article-reader-back'),
            tooltip: 'Quay lại',
            onPressed: () => Navigator.maybePop(context),
            icon: const Icon(Icons.arrow_back_ios_new_rounded, color: _ink, size: 20),
          ),
          title: const Text(
            'Bài viết',
            style: TextStyle(
              color: _ink,
              fontSize: 17,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        body: FutureBuilder<ArticleDetail>(
          future: _article,
          builder: (context, snapshot) {
            final article = snapshot.data;
            if (article != null) {
              final loadRelated = widget.loadRelated;
              return _ArticleBody(
                article: article,
                onFindTrip: widget.onFindTrip,
                related: loadRelated == null || article.categorySlug.isEmpty
                    ? null
                    : _RelatedArticles(
                        // Chỉ tải một lần cho mỗi bài.
                        key: ValueKey('related-${article.slug}'),
                        load: () =>
                            loadRelated(article.categorySlug, article.slug),
                        onOpen: _openRelated,
                      ),
              );
            }
            return Center(
              child: snapshot.hasError
                  ? _LoadError(onRetry: _retry)
                  : const CircularProgressIndicator(color: _blue),
            );
          },
        ),
      ),
    );
  }
}

class _ArticleBody extends StatelessWidget {
  const _ArticleBody({required this.article, this.onFindTrip, this.related});

  final ArticleDetail article;
  final VoidCallback? onFindTrip;
  final Widget? related;

  @override
  Widget build(BuildContext context) {
    final cover = article.coverImageUrl;
    final bottomInset = MediaQuery.paddingOf(context).bottom;
    return CustomScrollView(
      key: const Key('article-reader-scroll'),
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: SizedBox(
                height: 190,
                width: double.infinity,
                child: cover == null || cover.isEmpty
                    ? Image.asset(articleFallbackAsset, fit: BoxFit.cover)
                    : Image.network(
                        cover,
                        fit: BoxFit.cover,
                        errorBuilder: (_, _, _) => Image.asset(
                          articleFallbackAsset,
                          fit: BoxFit.cover,
                        ),
                      ),
              ),
            ),
          ),
        ),
        SliverPadding(
          padding: EdgeInsets.fromLTRB(18, 16, 18, 24 + bottomInset),
          sliver: SliverList.list(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  key: const Key('article-reader-category'),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF8DE5B6),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    article.categoryName,
                    style: const TextStyle(
                      color: Color(0xFF0E5C35),
                      fontSize: 11,
                      height: 1.4,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                article.title,
                key: const Key('article-reader-title'),
                style: const TextStyle(
                  color: Color(0xFF101E44),
                  fontSize: 21,
                  height: 1.45,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                '${_formatDate(article.publishedAt)}   ·   '
                '${article.readingMinutes} phút đọc   ·   Vé Xe Nhanh',
                style: const TextStyle(
                  color: Color(0xFF7B8A9F),
                  fontSize: 12,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 14),
              const Divider(height: 1, color: Color(0xFFE0E6EE)),
              const SizedBox(height: 14),
              if (article.summary.isNotEmpty) ...[
                Text(
                  article.summary,
                  style: const TextStyle(
                    color: _ink,
                    fontSize: 15,
                    height: 1.6,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 14),
              ],
              ArticleMarkdown(data: article.contentMarkdown),
              ?related,
              const SizedBox(height: 20),
              _TripCallToAction(onPressed: onFindTrip),
            ],
          ),
        ),
      ],
    );
  }
}

/// "Bài viết liên quan": tối đa 3 bài cùng chuyên mục; không có bài hoặc tải lỗi thì ẩn (SCR-PSG-37).
class _RelatedArticles extends StatefulWidget {
  const _RelatedArticles({required this.load, required this.onOpen, super.key});

  final Future<List<ExploreArticle>> Function() load;
  final ValueChanged<ExploreArticle> onOpen;

  @override
  State<_RelatedArticles> createState() => _RelatedArticlesState();
}

class _RelatedArticlesState extends State<_RelatedArticles> {
  late final Future<List<ExploreArticle>> _items = widget.load();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<ExploreArticle>>(
      future: _items,
      builder: (context, snapshot) {
        final items = snapshot.data ?? const <ExploreArticle>[];
        if (items.isEmpty) return const SizedBox.shrink();
        return Padding(
          key: const Key('article-reader-related'),
          padding: const EdgeInsets.only(top: 22),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Bài viết liên quan',
                style: TextStyle(
                  color: _ink,
                  fontSize: 16,
                  height: 1.5,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              for (final item in items)
                InkWell(
                  key: ValueKey('article-reader-related-${item.slug}'),
                  borderRadius: BorderRadius.circular(12),
                  onTap: () => widget.onOpen(item),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: SizedBox.square(
                            dimension: 56,
                            child: _RelatedCover(article: item),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.title,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: _ink,
                                  fontSize: 13.5,
                                  height: 1.4,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                _formatDate(item.publishedAt),
                                style: const TextStyle(
                                  color: Color(0xFF7B8A9F),
                                  fontSize: 11.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}

class _RelatedCover extends StatelessWidget {
  const _RelatedCover({required this.article});

  final ExploreArticle article;

  @override
  Widget build(BuildContext context) {
    final cover = article.coverImageUrl;
    final fallback = Image.asset(article.fallbackAsset, fit: BoxFit.cover);
    if (cover == null || cover.isEmpty) return fallback;
    return Image.network(
      cover,
      fit: BoxFit.cover,
      errorBuilder: (_, _, _) => fallback,
    );
  }
}

class _LoadError extends StatelessWidget {
  const _LoadError({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Không tải được bài viết. Vui lòng thử lại.',
            textAlign: TextAlign.center,
            style: TextStyle(color: _body, fontSize: 14, height: 1.5),
          ),
          const SizedBox(height: 12),
          FilledButton(
            key: const Key('article-reader-retry'),
            onPressed: onRetry,
            style: FilledButton.styleFrom(backgroundColor: _blue),
            child: const Text('Thử lại'),
          ),
        ],
      ),
    );
  }
}

class _TripCallToAction extends StatelessWidget {
  const _TripCallToAction({this.onPressed});

  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFE6F6FF),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Sẵn sàng lên đường?',
            style: TextStyle(
              color: _ink,
              fontSize: 16,
              height: 1.5,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Tìm chuyến xe phù hợp cho hành trình của bạn.',
            style: TextStyle(
              color: Color(0xFF597D9F),
              fontSize: 12,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 40,
            child: FilledButton(
              key: const Key('article-reader-find-trip'),
              onPressed: onPressed,
              style: FilledButton.styleFrom(
                backgroundColor: _blue,
                shape: const StadiumBorder(),
              ),
              child: const Text('Tìm chuyến đi  ›'),
            ),
          ),
        ],
      ),
    );
  }
}

String _formatDate(DateTime value) {
  final local = value.toLocal();
  return '${local.day.toString().padLeft(2, '0')}/'
      '${local.month.toString().padLeft(2, '0')}/${local.year}';
}
