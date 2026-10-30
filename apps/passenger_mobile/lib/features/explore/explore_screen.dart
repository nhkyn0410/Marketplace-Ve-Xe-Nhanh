import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:passenger_mobile/features/explore/article_api.dart';
import 'package:passenger_mobile/features/explore/article_detail_screen.dart';
import 'package:passenger_mobile/features/explore/article_reader_screen.dart';
import 'package:passenger_mobile/features/home/home_models.dart';
import 'package:passenger_mobile/features/home/route_dock_tabbar.dart';

const _assetRoot = 'assets/explore';
const _designWidth = 412.0;
const _designContentHeight = 1389.0;
const _pageBackground = Color(0xFFEFFAFF);
const _ink = Color(0xFF0B1739);
const _primary = Color(0xFF1589BD);
const _secondary = Color(0xFF5D7A97);

class ExploreArticle {
  const ExploreArticle({
    required this.slug,
    required this.title,
    required this.category,
    required this.publishedAt,
    required this.fallbackAsset,
    this.coverImageUrl,
    this.readingTimeMinutes,
    this.featuredImageHeight,
    this.featuredImageOffsetY,
  });

  final String slug;
  final String title;
  final String category;
  final DateTime publishedAt;
  final String fallbackAsset;
  final String? coverImageUrl;
  final int? readingTimeMinutes;
  final double? featuredImageHeight;
  final double? featuredImageOffsetY;
}

class ExploreFeed {
  const ExploreFeed({required this.featured, required this.latest});

  final ExploreArticle? featured;
  final List<ExploreArticle> latest;
}

final _figmaFeed = ExploreFeed(
  featured: ExploreArticle(
    slug: 'phu-yen-xanh-ngay-ngat',
    title: '“Đi đi em, còn do dự trời tối mất” — Phú Yên xanh ngây ngất, chần chừ là lỡ cả hoàng hôn!',
    category: 'Cẩm nang',
    publishedAt: DateTime.utc(2026, 10, 16),
    readingTimeMinutes: 6,
    fallbackAsset: '$_assetRoot/featured_phu_yen.png',
  ),
  latest: [
    ExploreArticle(
      slug: 'hai-ngay-o-da-lat',
      title: 'Một chuyến đi 2 ngày: đủ để Đà Lạt khiến bạn nhớ mãi',
      category: 'Cẩm nang',
      publishedAt: DateTime.utc(2026, 10, 16),
      fallbackAsset: '$_assetRoot/article_da_lat_church.jpg',
    ),
    ExploreArticle(
      slug: 'kinh-nghiem-chuyen-di-xa',
      title: 'Kinh nghiệm chuẩn bị cho chuyến đi xa cho người mới',
      category: 'Mẹo du lịch',
      publishedAt: DateTime.utc(2026, 10, 16),
      fallbackAsset: '$_assetRoot/article_road_trip.png',
    ),
    ExploreArticle(
      slug: 'diem-dung-chan-tp-hcm-da-lat',
      title: 'Top điểm dừng chân thú vị trên tuyến TP. Hồ Chí Minh → Đà Lạt',
      category: 'Cẩm nang',
      publishedAt: DateTime.utc(2026, 10, 16),
      fallbackAsset: '$_assetRoot/article_stop.png',
    ),
  ],
);

final _guideFeed = ExploreFeed(
  featured: _figmaFeed.featured,
  latest: [
    _figmaFeed.latest[0],
    _figmaFeed.latest[2],
    ExploreArticle(
      slug: 'lao-cai-ban-lang-hmong',
      title: 'Lào Cai: Bản làng H’Mông, ruộng bậc thang và văn hóa vùng biên',
      category: 'Cẩm nang',
      publishedAt: DateTime.utc(2026, 10, 16),
      fallbackAsset: '$_assetRoot/guide_lao_cai.png',
    ),
    ExploreArticle(
      slug: 'thung-lung-thieng-gach-co',
      title:
          'Lạc bước giữa thung lũng thiêng, nghe gạch cổ kể chuyện nghìn năm',
      category: 'Cẩm nang',
      publishedAt: DateTime.utc(2026, 10, 16),
      fallbackAsset: '$_assetRoot/guide_sacred_valley.png',
    ),
  ],
);

final _tipsFeed = ExploreFeed(
  featured: ExploreArticle(
    slug: 'meo-chon-ghe-xe',
    title:
        'Đừng để chuyến đi mất vui chỉ vì chiếc ghế: mẹo nhỏ, khác biệt lớn !',
    category: 'Mẹo du lịch',
    publishedAt: DateTime.utc(2026, 10, 16),
    readingTimeMinutes: 6,
    fallbackAsset: '$_assetRoot/tips_featured_seat.png',
    featuredImageHeight: 512.4,
    featuredImageOffsetY: -225,
  ),
  latest: [
    _figmaFeed.latest[1],
    ExploreArticle(
      slug: 'checklist-do-dung-cho-nguoi-hay-voi',
      title:
          'Lên xe rồi mới biết mình quên đồ ? Checklist gọn cho người hay vội',
      category: 'Mẹo du lịch',
      publishedAt: DateTime.utc(2026, 10, 16),
      fallbackAsset: '$_assetRoot/tips_checklist.png',
    ),
    ExploreArticle(
      slug: 'bi-quyet-di-xe-dem',
      title: 'Đi xe đêm sao cho khỏe: vài bí quyết đáng bỏ túi',
      category: 'Mẹo du lịch',
      publishedAt: DateTime.utc(2026, 10, 16),
      fallbackAsset: '$_assetRoot/tips_night_bus.png',
    ),
    ExploreArticle(
      slug: 'chon-diem-don-khong-chay-voi',
      title: 'Chọn điểm đón như nào để không phải chạy vội phút chốt ?',
      category: 'Mẹo du lịch',
      publishedAt: DateTime.utc(2026, 10, 16),
      fallbackAsset: '$_assetRoot/tips_pickup_point.png',
    ),
  ],
);

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({
    required this.onTabSelected,
    this.loadFeed,
    this.loadArticle,
    this.loadPromotions,
    super.key,
  });

  final ValueChanged<int> onTabSelected;

  /// Bài viết của chuyên mục (`null` = tất cả) khớp từ khóa (`null` = không lọc) từ API;
  /// không truyền thì dùng dữ liệu mẫu Figma.
  final Future<ExploreFeed> Function(String? category, String? query)? loadFeed;

  /// Nội dung một bài viết theo slug, cho màn đọc bài.
  final Future<ArticleDetail> Function(String slug)? loadArticle;

  /// Khuyến mãi đang chạy cho khối "Khuyến mãi nổi bật"; không có thì ẩn khối (chế độ API).
  final Future<List<HomePromotion>> Function()? loadPromotions;

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  final _searchController = TextEditingController();
  String _category = 'all';
  bool _dockVisible = true;
  final _remoteFeeds = <String, Future<ExploreFeed>>{};

  /// Từ khóa đã gửi ở ô tìm kiếm; rỗng = không lọc.
  String _query = '';
  HomePromotion? _promotion;

  String get _feedKey => '$_category|$_query';

  /// Feed API của chuyên mục + từ khóa đang chọn, tải một lần; `null` khi dùng dữ liệu mẫu.
  Future<ExploreFeed>? get _remoteFeed {
    final load = widget.loadFeed;
    if (load == null) return null;
    return _remoteFeeds.putIfAbsent(
      _feedKey,
      () => load(
        _category == 'all' ? null : _category,
        _query.isEmpty ? null : _query,
      ),
    );
  }

  void _retryFeed() {
    setState(() {
      _remoteFeeds.remove(_feedKey);
    });
  }

  void _search(String text) {
    final query = text.trim();
    if (query == _query) return;
    setState(() => _query = query);
  }

  @override
  void initState() {
    super.initState();
    widget.loadPromotions?.call().then((items) {
      if (mounted && items.isNotEmpty) setState(() => _promotion = items.first);
    }, onError: (_) {});
  }

  Future<void> _copyPromotionCode(String code) async {
    await Clipboard.setData(ClipboardData(text: code));
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(content: Text('Đã chép mã $code. Dán mã khi đặt vé.')),
      );
  }

  void _findTrip() {
    Navigator.of(context).pop();
    widget.onTabSelected(1);
  }

  /// Hành động khi chạm một bài; `null` = bài mẫu chưa có màn đọc.
  VoidCallback? _articleAction(ExploreArticle article) {
    final loadArticle = widget.loadArticle;
    if (widget.loadFeed != null && loadArticle != null) {
      return () => Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (_) => ArticleReaderScreen(
            slug: article.slug,
            loadArticle: loadArticle,
            onFindTrip: _findTrip,
          ),
        ),
      );
    }
    return article.slug == 'phu-yen-xanh-ngay-ngat' ? _openPhuYenArticle : null;
  }

  ExploreFeed get _feed => switch (_category) {
    'cam-nang' => _guideFeed,
    'meo-du-lich' => _tipsFeed,
    _ => _figmaFeed,
  };

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _selectCategory(String category) {
    if (_category == category) return;
    setState(() => _category = category);
  }

  void _openPhuYenArticle() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => ArticleDetailScreen(
          onFindTrip: () {
            Navigator.of(context).pop();
            widget.onTabSelected(1);
          },
        ),
      ),
    );
  }

  bool _handleUserScroll(UserScrollNotification notification) {
    if (notification.metrics.axis != Axis.vertical) return false;
    final shouldShow = switch (notification.direction) {
      ScrollDirection.forward => true,
      ScrollDirection.reverse => false,
      ScrollDirection.idle =>
        notification.metrics.pixels <= 0 ? true : _dockVisible,
    };
    if (shouldShow != _dockVisible && mounted) {
      setState(() => _dockVisible = shouldShow);
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: const Key('explore-screen'),
      backgroundColor: _pageBackground,
      extendBody: true,
      bottomNavigationBar: RouteDockTabBar(
        currentIndex: 0,
        onTap: widget.onTabSelected,
        visible: _dockVisible,
        slideKey: const Key('explore-bottom-dock-animation'),
      ),
      body: TabEntrance(
        child: Stack(
          children: [
            const Positioned(
              left: 0,
              right: 0,
              top: 0,
              height: 275,
              child: _ExploreBackdrop(),
            ),
            SafeArea(
              bottom: false,
              child: NotificationListener<UserScrollNotification>(
                onNotification: _handleUserScroll,
                child: CustomScrollView(
                  key: const Key('explore-content-scroll'),
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,
                  slivers: [
                    SliverToBoxAdapter(
                      child: FutureBuilder<ExploreFeed>(
                        future: _remoteFeed,
                        builder: (context, snapshot) {
                          final remote = widget.loadFeed != null;
                          final status = !remote
                              ? _FeedStatus.ready
                              : snapshot.hasError
                              ? _FeedStatus.failed
                              : snapshot.connectionState == ConnectionState.done
                              ? _FeedStatus.ready
                              : _FeedStatus.loading;
                          return _ScaledExploreCanvas(
                            feed: remote ? snapshot.data ?? _noArticles : _feed,
                            status: status,
                            onRetry: _retryFeed,
                            category: _category,
                            searchController: _searchController,
                            onCategorySelected: _selectCategory,
                            onSearch: _search,
                            articleAction: _articleAction,
                            // Dữ liệu mẫu giữ khối khuyến mãi Figma; chế độ API chỉ hiện khuyến mãi thật.
                            promotion: remote
                                ? _promotion
                                : _samplePromotionMarker,
                            onPromotionTap: _promotion == null
                                ? null
                                : () => _copyPromotionCode(_promotion!.code),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ExploreBackdrop extends StatelessWidget {
  const _ExploreBackdrop();

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.asset('$_assetRoot/background_mountains.png', fit: BoxFit.cover),
        const DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: [0, .55, 1],
              colors: [Color(0xA8F0FAFF), Color(0xC7F0FAFF), Color(0xFFF0FAFF)],
            ),
          ),
        ),
      ],
    );
  }
}

class _ScaledExploreCanvas extends StatelessWidget {
  const _ScaledExploreCanvas({
    required this.feed,
    required this.category,
    required this.searchController,
    required this.onCategorySelected,
    required this.articleAction,
    required this.status,
    required this.onRetry,
    required this.onSearch,
    required this.promotion,
    required this.onPromotionTap,
  });

  final ExploreFeed feed;
  final String category;
  final TextEditingController searchController;
  final ValueChanged<String> onCategorySelected;
  final VoidCallback? Function(ExploreArticle article) articleAction;
  final _FeedStatus status;
  final VoidCallback onRetry;
  final ValueChanged<String> onSearch;

  /// Khuyến mãi ở khối dưới; `null` = ẩn khối; [_samplePromotionMarker] = khối mẫu Figma.
  final HomePromotion? promotion;
  final VoidCallback? onPromotionTap;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final scale = math.min(1.0, constraints.maxWidth / _designWidth);
        return SizedBox(
          height: _designContentHeight * scale,
          width: constraints.maxWidth,
          child: FittedBox(
            alignment: Alignment.topCenter,
            fit: BoxFit.contain,
            child: SizedBox(
              width: _designWidth,
              height: _designContentHeight,
              child: _ExploreCanvas(
                feed: feed,
                category: category,
                searchController: searchController,
                onCategorySelected: onCategorySelected,
                articleAction: articleAction,
                status: status,
                onRetry: onRetry,
                onSearch: onSearch,
                promotion: promotion,
                onPromotionTap: onPromotionTap,
              ),
            ),
          ),
        );
      },
    );
  }
}

class _ExploreCanvas extends StatelessWidget {
  const _ExploreCanvas({
    required this.feed,
    required this.category,
    required this.searchController,
    required this.onCategorySelected,
    required this.articleAction,
    required this.status,
    required this.onRetry,
    required this.onSearch,
    required this.promotion,
    required this.onPromotionTap,
  });

  final ExploreFeed feed;
  final String category;
  final TextEditingController searchController;
  final ValueChanged<String> onCategorySelected;
  final VoidCallback? Function(ExploreArticle article) articleAction;
  final _FeedStatus status;
  final VoidCallback onRetry;
  final ValueChanged<String> onSearch;

  /// Khuyến mãi ở khối dưới; `null` = ẩn khối; [_samplePromotionMarker] = khối mẫu Figma.
  final HomePromotion? promotion;
  final VoidCallback? onPromotionTap;

  @override
  Widget build(BuildContext context) {
    final categoryView = category != 'all';
    final tipsView = category == 'meo-du-lich';
    final featuredHeight = tipsView ? 252.0 : 271.0;
    final latestHeadingTop = categoryView ? 468.0 : 463.0;
    final latestListTop = categoryView ? 506.0 : 501.0;
    return Stack(
      clipBehavior: Clip.none,
      children: [
        // Tiêu đề cùng kiểu, cùng vị trí với tab Mua vé (cách thanh trạng thái 14, lề 20).
        const Positioned(left: 20, top: 14, child: _ExploreHeading()),
        Positioned(
          left: 18,
          top: 89,
          width: 376,
          height: 40,
          child: _ExploreSearchField(
            controller: searchController,
            onSubmitted: onSearch,
          ),
        ),
        Positioned(
          left: 60,
          top: 142,
          width: 272,
          height: 30,
          child: _ExploreCategories(
            selected: category,
            onSelected: onCategorySelected,
          ),
        ),
        if (feed.featured != null)
          Positioned(
            left: 14,
            top: 185,
            width: 384,
            height: featuredHeight,
            child: _FeaturedArticleCard(
              article: feed.featured!,
              categoryView: categoryView,
              compact: tipsView,
              onTap: articleAction(feed.featured!),
            ),
          )
        else
          Positioned(
            left: 14,
            top: 185,
            width: 384,
            height: 271,
            child: _EmptyExploreCard(status: status, onRetry: onRetry),
          ),
        Positioned(
          left: 19,
          top: latestHeadingTop,
          child: const Text(
            'Bài viết mới nhất',
            style: TextStyle(
              color: _ink,
              fontFamily: 'Be Vietnam Pro',
              fontSize: 18,
              height: 1.4,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Positioned(
          left: 14,
          top: latestListTop,
          width: 384,
          child: _LatestArticles(
            articles: feed.latest,
            hideEmptyMessage:
                status != _FeedStatus.ready || feed.featured == null,
            articleAction: articleAction,
          ),
        ),
        if (!categoryView && promotion != null) ...[
          const Positioned(
            left: 14,
            top: 1096,
            width: 384,
            height: 24,
            child: _PromotionHeading(),
          ),
          Positioned(
            left: 14,
            top: 1126,
            width: 384,
            height: 98,
            child: _PromotionCard(
              promotion: identical(promotion, _samplePromotionMarker)
                  ? null
                  : promotion,
              onTap: onPromotionTap,
            ),
          ),
          if (identical(promotion, _samplePromotionMarker))
            const Positioned(left: 195, top: 1230, child: _CarouselDots()),
        ],
      ],
    );
  }
}

class _ExploreHeading extends StatelessWidget {
  const _ExploreHeading();

  @override
  Widget build(BuildContext context) {
    // Cùng kiểu chữ với tiêu đề tab Mua vé ("Khám phá chuyến đi").
    return const SizedBox(
      width: 372,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Khám phá hành trình',
            key: Key('explore-heading-primary'),
            style: TextStyle(
              color: Color(0xFF09243D),
              fontFamily: 'Be Vietnam Pro',
              fontSize: 24,
              height: 34 / 24,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 3),
          Text(
            'Bài viết, cẩm nang và ưu đãi cho chuyến đi',
            style: TextStyle(
              color: Color(0xFF607A8E),
              fontFamily: 'Be Vietnam Pro',
              fontSize: 13,
              height: 19 / 13,
            ),
          ),
        ],
      ),
    );
  }
}

class _ExploreSearchField extends StatelessWidget {
  const _ExploreSearchField({
    required this.controller,
    required this.onSubmitted,
  });

  final TextEditingController controller;

  /// Gửi từ khóa (bàn phím "Tìm"); xóa hết rồi gửi = bỏ lọc.
  final ValueChanged<String> onSubmitted;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      key: const Key('explore-search-frame'),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          const SizedBox(width: 16),
          SizedBox.square(
            dimension: 22,
            child: Center(
              child: SvgPicture.asset(
                '$_assetRoot/search.svg',
                width: 19.2167,
                height: 19.2167,
                excludeFromSemantics: true,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: TextField(
              key: const Key('explore-search-field'),
              controller: controller,
              onSubmitted: (text) {
                FocusScope.of(context).unfocus();
                onSubmitted(text);
              },
              textInputAction: TextInputAction.search,
              maxLines: 1,
              style: const TextStyle(
                color: _ink,
                fontFamily: 'Be Vietnam Pro',
                fontSize: 14,
                height: 1.4,
                fontWeight: FontWeight.w400,
              ),
              decoration: const InputDecoration(
                border: InputBorder.none,
                isCollapsed: true,
                hintText: 'Tìm bài viết, cẩm nang...',
                hintStyle: TextStyle(
                  color: Color(0xFF74879E),
                  fontFamily: 'Be Vietnam Pro',
                  fontSize: 14,
                  height: 1.4,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
        ],
      ),
    );
  }
}

class _ExploreCategories extends StatelessWidget {
  const _ExploreCategories({required this.selected, required this.onSelected});

  final String selected;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _CategoryChip(
          key: const Key('explore-category-all'),
          width: 70,
          label: 'Tất cả',
          selected: selected == 'all',
          onTap: () => onSelected('all'),
        ),
        const SizedBox(width: 8),
        _CategoryChip(
          key: const Key('explore-category-guide'),
          width: 86,
          label: 'Cẩm nang',
          selected: selected == 'cam-nang',
          onTap: () => onSelected('cam-nang'),
        ),
        const SizedBox(width: 8),
        _CategoryChip(
          key: const Key('explore-category-tips'),
          width: 100,
          label: 'Mẹo du lịch',
          selected: selected == 'meo-du-lich',
          onTap: () => onSelected('meo-du-lich'),
        ),
      ],
    );
  }
}

class _CategoryChip extends StatelessWidget {
  const _CategoryChip({
    required this.width,
    required this.label,
    required this.selected,
    required this.onTap,
    super.key,
  });

  final double width;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      selected: selected,
      button: true,
      label: label,
      child: Material(
        color: selected ? _primary : const Color(0xFFE0F3FD),
        borderRadius: BorderRadius.circular(18),
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: onTap,
          child: SizedBox(
            width: width,
            height: 30,
            child: Center(
              child: Text(
                label,
                style: TextStyle(
                  color: selected ? Colors.white : _secondary,
                  fontFamily: 'Be Vietnam Pro',
                  fontSize: 12,
                  height: 1.4,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _FeaturedArticleCard extends StatelessWidget {
  const _FeaturedArticleCard({
    required this.article,
    required this.categoryView,
    required this.compact,
    this.onTap,
  });

  final ExploreArticle article;
  final bool categoryView;
  final bool compact;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final titleParts = article.title.split(' — ');
    return ClipRRect(
      key: const Key('explore-featured-card'),
      borderRadius: BorderRadius.circular(14),
      child: Material(
        color: Colors.white,
        child: InkWell(
          key: const Key('explore-featured-action'),
          onTap: onTap,
          child: Stack(
            children: [
              Positioned(
                left: 0,
                top: 0,
                width: 384,
                height: categoryView ? 151 : 150,
                child: ClipRect(child: _featuredImage(article)),
              ),
              Positioned(
                left: categoryView && !compact ? 15 : 16,
                top: categoryView ? 158 : 162,
                child: _ArticleCategoryBadge(
                  category: article.category,
                  uppercase: !categoryView,
                ),
              ),
              Positioned(
                left: 16,
                top: 184,
                width: 354,
                child: Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: titleParts.first,
                        style: TextStyle(
                          color: titleParts.length > 1
                              ? const Color(0xFF1F52A3)
                              : _ink,
                        ),
                      ),
                      if (titleParts.length > 1)
                        TextSpan(text: ' — ${titleParts.skip(1).join(' — ')}'),
                    ],
                  ),
                  key: const Key('explore-featured-title'),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: _ink,
                    fontFamily: 'Be Vietnam Pro',
                    fontSize: 16,
                    height: 1.4,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Positioned(
                left: 16,
                top: compact ? 229 : 252,
                child: Text(
                  [
                    _formatDate(article.publishedAt),
                    if (article.readingTimeMinutes case final minutes?)
                      '$minutes phút đọc',
                  ].join('   ·   '),
                  style: const TextStyle(
                    color: Color(0xFF71869F),
                    fontFamily: 'Be Vietnam Pro',
                    fontSize: 11,
                    height: 1.4,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _featuredImage(ExploreArticle article) {
    final url = article.coverImageUrl;
    if (url != null && url.isNotEmpty) {
      return _NetworkOrAssetImage(
        url: url,
        fallbackAsset: article.fallbackAsset,
        fit: BoxFit.cover,
      );
    }
    final imageHeight = article.featuredImageHeight ?? 508.47;
    final offsetY = article.featuredImageOffsetY ?? -208.43;
    return OverflowBox(
      alignment: Alignment.topLeft,
      maxWidth: 384,
      maxHeight: imageHeight,
      child: Transform.translate(
        offset: Offset(-.42, offsetY),
        child: SizedBox(
          width: 384,
          height: imageHeight,
          child: Image.asset(article.fallbackAsset, fit: BoxFit.fill),
        ),
      ),
    );
  }
}

class _ArticleCategoryBadge extends StatelessWidget {
  const _ArticleCategoryBadge({
    required this.category,
    this.uppercase = true,
    super.key,
  });

  final String category;
  final bool uppercase;

  bool get _isTip => category.toLowerCase().contains('mẹo');

  @override
  Widget build(BuildContext context) {
    final height = uppercase ? 18.0 : 20.0;
    final horizontalPadding = uppercase ? 9.0 : 10.0;
    return Container(
      height: height,
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      decoration: BoxDecoration(
        color: _isTip ? const Color(0xFFFCEBCC) : const Color(0xFF8DE5B6),
        borderRadius: BorderRadius.circular(height / 2),
      ),
      child: Center(
        widthFactor: 1,
        child: Text(
          uppercase ? category.toUpperCase() : category,
          style: TextStyle(
            color: _isTip ? const Color(0xFFF04438) : const Color(0xFF0E5C35),
            fontFamily: 'Be Vietnam Pro',
            fontSize: 10,
            height: 1.4,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

class _LatestArticles extends StatelessWidget {
  const _LatestArticles({
    required this.articles,
    required this.articleAction,
    this.hideEmptyMessage = false,
  });

  final List<ExploreArticle> articles;
  final VoidCallback? Function(ExploreArticle article) articleAction;

  /// Đang tải, lỗi hoặc không có bài nào: thẻ phía trên đã báo, không lặp "chưa có bài viết".
  final bool hideEmptyMessage;

  @override
  Widget build(BuildContext context) {
    if (articles.isEmpty && hideEmptyMessage) return const SizedBox.shrink();
    if (articles.isEmpty) {
      return const SizedBox(
        height: 588,
        child: Center(
          child: Text(
            'Chưa có bài viết trong chuyên mục này.',
            style: TextStyle(
              color: _secondary,
              fontFamily: 'Be Vietnam Pro',
              fontSize: 14,
            ),
          ),
        ),
      );
    }
    final visible = articles.toList(growable: false);
    return Column(
      children: [
        for (var index = 0; index < visible.length; index++)
          _LatestArticleRow(
            article: visible[index],
            index: index,
            onTap: articleAction(visible[index]),
          ),
      ],
    );
  }
}

class _LatestArticleRow extends StatelessWidget {
  const _LatestArticleRow({
    required this.article,
    required this.index,
    this.onTap,
  });

  final ExploreArticle article;
  final int index;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      key: Key('explore-latest-row-$index'),
      width: 384,
      height: 196,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: Stack(
          children: [
            const Positioned(
              left: 4,
              top: 0,
              width: 376,
              height: 1,
              child: ColoredBox(color: Color(0xFFD8E6ED)),
            ),
            Positioned(
              left: 4,
              top: 24,
              width: 240,
              height: 148,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _ArticleCategoryBadge(
                    key: Key('explore-latest-badge-$index'),
                    category: article.category,
                    uppercase: false,
                  ),
                  const SizedBox(height: 14),
                  Text(
                    article.title,
                    maxLines: 4,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: _ink,
                      fontFamily: 'Be Vietnam Pro',
                      fontSize: 14,
                      height: 1.5,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              left: 264,
              top: 24,
              width: 116,
              height: 148,
              child: ClipRRect(
                key: Key('explore-latest-image-$index'),
                borderRadius: BorderRadius.circular(6),
                child: _NetworkOrAssetImage(
                  url: article.coverImageUrl,
                  fallbackAsset: article.fallbackAsset,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Trạng thái feed bài viết lấy từ API.
enum _FeedStatus { loading, ready, failed }

const _noArticles = ExploreFeed(featured: null, latest: []);

class _EmptyExploreCard extends StatelessWidget {
  const _EmptyExploreCard({required this.status, required this.onRetry});

  final _FeedStatus status;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    const style = TextStyle(
      color: _secondary,
      fontFamily: 'Be Vietnam Pro',
      fontSize: 14,
      height: 1.4,
    );
    return DecoratedBox(
      key: const Key('explore-empty-card'),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: switch (status) {
            _FeedStatus.loading => const CircularProgressIndicator(
              color: _primary,
            ),
            _FeedStatus.failed => Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Không tải được bài viết.',
                  textAlign: TextAlign.center,
                  style: style,
                ),
                TextButton(
                  key: const Key('explore-retry'),
                  onPressed: onRetry,
                  child: const Text('Thử lại'),
                ),
              ],
            ),
            _FeedStatus.ready => const Text(
              'Chưa có bài viết phù hợp. Hãy thử chuyên mục khác.',
              textAlign: TextAlign.center,
              style: style,
            ),
          },
        ),
      ),
    );
  }
}

class _PromotionHeading extends StatelessWidget {
  const _PromotionHeading();

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            'Khuyến mãi nổi bật',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: _ink,
              fontFamily: 'Be Vietnam Pro',
              fontSize: 17,
              height: 1.4,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        SizedBox(width: 8),
        Text(
          'Xem tất cả ›',
          style: TextStyle(
            color: Color(0xFF1689D9),
            fontFamily: 'Be Vietnam Pro',
            fontSize: 10,
            height: 1.4,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

/// Đánh dấu "dùng khối khuyến mãi mẫu Figma" (chế độ dữ liệu mẫu).
const _samplePromotionMarker = HomePromotion(
  code: '',
  name: '',
  isPercent: true,
  discountValue: 30,
  minOrder: 0,
);

class _PromotionCard extends StatelessWidget {
  const _PromotionCard({this.promotion, this.onTap});

  /// `null` = nội dung mẫu Figma.
  final HomePromotion? promotion;

  /// Chạm để chép mã.
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final promotion = this.promotion;
    final title =
        promotion?.name ?? 'Ưu đãi giảm giá\ncho hành trình cuối tuần';
    final subtitle = promotion == null
        ? 'Tiết kiệm chi phí, thêm niềm vui\ncho mỗi chuyến đi'
        : '${promotionConditions(promotion)}\nMã: ${promotion.code}';
    final badgeLabel = promotion == null ? 'Giảm đến' : 'Giảm';
    final badgeValue = promotion == null
        ? '30%'
        : promotion.isPercent
        ? '${promotion.discountValue}%'
        : shortVnd(promotion.discountValue);
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        key: const Key('explore-promotion-card'),
        borderRadius: BorderRadius.circular(11),
        child: ColoredBox(
          color: const Color(0xFFFFF2DE),
          child: Stack(
            children: [
              Positioned.fill(
                child: Image.asset(
                  '$_assetRoot/promotion_weekend.png',
                  fit: BoxFit.cover,
                ),
              ),
              const Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      stops: [0, .45, .75],
                      colors: [
                        Color(0xFFFFF5E0),
                        Color(0xFAFFF5E0),
                        Color(0x00FFF5E0),
                      ],
                    ),
                  ),
                ),
              ),
              const Positioned(
                left: 16,
                top: 7,
                child: Text(
                  'KHUYẾN MÃI',
                  style: TextStyle(
                    color: Color(0xFFF08718),
                    fontFamily: 'Be Vietnam Pro',
                    fontSize: 8,
                    height: 1.4,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Positioned(
                left: 16,
                top: 21,
                width: 250,
                child: Text(
                  title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: _ink,
                    fontFamily: 'Be Vietnam Pro',
                    fontSize: 11,
                    height: 1.4,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Positioned(
                left: 16,
                top: 54,
                width: 250,
                child: Text(
                  subtitle,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Color(0xFF667B91),
                    fontFamily: 'Be Vietnam Pro',
                    fontSize: 8,
                    height: 1.4,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              Positioned(
                left: 16,
                top: 77,
                child: Container(
                  width: 76,
                  height: 17,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFF862A),
                    borderRadius: BorderRadius.circular(9),
                  ),
                  child: Center(
                    child: Text(
                      promotion == null ? 'Xem ưu đãi ›' : 'Chép mã ›',
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Be Vietnam Pro',
                        fontSize: 8,
                        height: 1.4,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 297,
                top: 11.8,
                width: 83.354,
                height: 61.453,
                child: Center(
                  child: Transform.rotate(
                    angle: -10 * math.pi / 180,
                    child: Container(
                      width: 76,
                      height: 49,
                      decoration: BoxDecoration(
                        color: const Color(0xFFFF862A),
                        borderRadius: BorderRadius.circular(7),
                      ),
                      child: Stack(
                        children: [
                          Positioned(
                            left: 13,
                            top: 5,
                            child: Text(
                              badgeLabel,
                              style: const TextStyle(
                                color: Colors.white,
                                fontFamily: 'Be Vietnam Pro',
                                fontSize: 9,
                                height: 1.4,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          Positioned(
                            left: 12,
                            right: 4,
                            top: 15,
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              alignment: Alignment.centerLeft,
                              child: Text(
                                badgeValue,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'Be Vietnam Pro',
                                  fontSize: 23,
                                  height: 1.4,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CarouselDots extends StatelessWidget {
  const _CarouselDots();

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        _CarouselDot(color: Color(0xFF1689ED)),
        SizedBox(width: 6),
        _CarouselDot(color: Color(0xFFC1DCEC)),
        SizedBox(width: 6),
        _CarouselDot(color: Color(0xFFC1DCEC)),
      ],
    );
  }
}

class _CarouselDot extends StatelessWidget {
  const _CarouselDot({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      child: const SizedBox.square(dimension: 4),
    );
  }
}

class _NetworkOrAssetImage extends StatelessWidget {
  const _NetworkOrAssetImage({
    required this.url,
    required this.fallbackAsset,
    required this.fit,
  });

  final String? url;
  final String fallbackAsset;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    final source = url;
    if (source == null || source.isEmpty) {
      return Image.asset(fallbackAsset, fit: fit);
    }
    return Image.network(
      source,
      fit: fit,
      errorBuilder: (_, _, _) => Image.asset(fallbackAsset, fit: fit),
    );
  }
}

String _formatDate(DateTime value) {
  final local = value.toLocal();
  return '${local.day.toString().padLeft(2, '0')}/'
      '${local.month.toString().padLeft(2, '0')}/${local.year}';
}
