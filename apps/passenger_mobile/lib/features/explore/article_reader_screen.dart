import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:passenger_mobile/features/explore/article_api.dart';
import 'package:passenger_mobile/features/explore/article_markdown.dart';

const _ink = Color(0xFF142246);
const _body = Color(0xFF53617C);
const _blue = Color(0xFF078FC9);

/// Màn đọc một bài viết lấy từ API: ảnh bìa, chuyên mục, tiêu đề, nội dung Markdown và lời mời tìm chuyến.
class ArticleReaderScreen extends StatefulWidget {
  const ArticleReaderScreen({
    required this.slug,
    required this.loadArticle,
    this.onFindTrip,
    super.key,
  });

  final String slug;
  final Future<ArticleDetail> Function(String slug) loadArticle;
  final VoidCallback? onFindTrip;

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
        body: FutureBuilder<ArticleDetail>(
          future: _article,
          builder: (context, snapshot) {
            final article = snapshot.data;
            if (article != null) {
              return _ArticleBody(
                article: article,
                onFindTrip: widget.onFindTrip,
              );
            }
            return Stack(
              children: [
                Center(
                  child: snapshot.hasError
                      ? _LoadError(onRetry: _retry)
                      : const CircularProgressIndicator(color: _blue),
                ),
                const _BackButton(),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _ArticleBody extends StatelessWidget {
  const _ArticleBody({required this.article, this.onFindTrip});

  final ArticleDetail article;
  final VoidCallback? onFindTrip;

  @override
  Widget build(BuildContext context) {
    final cover = article.coverImageUrl;
    final bottomInset = MediaQuery.paddingOf(context).bottom;
    return Stack(
      children: [
        CustomScrollView(
          key: const Key('article-reader-scroll'),
          slivers: [
            SliverToBoxAdapter(
              child: SizedBox(
                height: 220,
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
                  const SizedBox(height: 20),
                  _TripCallToAction(onPressed: onFindTrip),
                ],
              ),
            ),
          ],
        ),
        const _BackButton(),
      ],
    );
  }
}

class _BackButton extends StatelessWidget {
  const _BackButton();

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 16,
      top: MediaQuery.paddingOf(context).top + 8,
      child: Material(
        color: Colors.white,
        shape: const CircleBorder(),
        elevation: 1,
        child: IconButton(
          key: const Key('article-reader-back'),
          tooltip: 'Quay lại',
          onPressed: () => Navigator.maybePop(context),
          icon: const Icon(Icons.chevron_left_rounded, color: _ink),
        ),
      ),
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
