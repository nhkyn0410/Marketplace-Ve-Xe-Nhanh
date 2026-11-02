import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

const _assetRoot = 'assets/explore';
const _designWidth = 412.0;
const _designHeight = 1584.0;
const _ink = Color(0xFF142246);
const _body = Color(0xFF53617C);
const _blue = Color(0xFF078FC9);

class ArticleDetailScreen extends StatelessWidget {
  const ArticleDetailScreen({this.onFindTrip, super.key});

  final VoidCallback? onFindTrip;

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: Colors.white,
      ),
      child: Scaffold(
        key: const Key('article-detail-screen'),
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          key: const Key('article-detail-scroll'),
          child: _ScaledArticleCanvas(
            onBack: () => Navigator.maybePop(context),
            onFindTrip: onFindTrip,
          ),
        ),
      ),
    );
  }
}

class _ScaledArticleCanvas extends StatelessWidget {
  const _ScaledArticleCanvas({required this.onBack, this.onFindTrip});

  final VoidCallback onBack;
  final VoidCallback? onFindTrip;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final scale = math.min(1.0, constraints.maxWidth / _designWidth);
        return SizedBox(
          width: constraints.maxWidth,
          height: _designHeight * scale,
          child: FittedBox(
            alignment: Alignment.topCenter,
            fit: BoxFit.contain,
            child: SizedBox(
              width: _designWidth,
              height: _designHeight,
              child: _ArticleCanvas(onBack: onBack, onFindTrip: onFindTrip),
            ),
          ),
        );
      },
    );
  }
}

class _ArticleCanvas extends StatelessWidget {
  const _ArticleCanvas({required this.onBack, this.onFindTrip});

  final VoidCallback onBack;
  final VoidCallback? onFindTrip;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          left: 0,
          top: 0,
          width: 412,
          height: 194,
          child: ClipRRect(
            key: const Key('article-detail-hero'),
            borderRadius: BorderRadius.circular(14),
            child: Image.asset(
              '$_assetRoot/detail_phu_yen_hero.png',
              fit: BoxFit.cover,
            ),
          ),
        ),
        Positioned(
          left: 16,
          top: 45,
          width: 32,
          height: 32,
          child: Material(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            child: InkWell(
              key: const Key('article-detail-back'),
              onTap: onBack,
              borderRadius: BorderRadius.circular(16),
              child: const Center(
                child: Text(
                  '‹',
                  style: TextStyle(
                    color: Color(0xFF142246),
                    fontFamily: 'Be Vietnam Pro',
                    fontSize: 28,
                    height: 1,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ),
          ),
        ),
        Positioned(
          left: 18,
          top: 210,
          width: 376,
          child: _ArticleContent(onFindTrip: onFindTrip),
        ),
      ],
    );
  }
}

class _ArticleContent extends StatelessWidget {
  const _ArticleContent({this.onFindTrip});

  final VoidCallback? onFindTrip;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _CategoryBadge(),
        const SizedBox(height: 14),
        const _ArticleTitle(),
        const SizedBox(height: 14),
        const Text(
          '16/10/2026   ·   6 phút đọc   ·   Vé Xe Nhanh',
          key: Key('article-detail-metadata'),
          style: TextStyle(
            color: Color(0xFF7B8A9F),
            fontFamily: 'Be Vietnam Pro',
            fontSize: 10,
            height: 1.5,
            fontWeight: FontWeight.w400,
          ),
        ),
        const SizedBox(height: 14),
        const SizedBox(
          key: Key('article-detail-divider'),
          width: 376,
          height: 1,
          child: ColoredBox(color: Color(0xFFE0E6EE)),
        ),
        const SizedBox(height: 14),
        const SizedBox(
          width: 376,
          child: Text(
            'Phú Yên là điểm đến khiến người ta yêu ngay từ cái nhìn đầu tiên: biển xanh trong vắt, những ghềnh đá kỳ vĩ, làng chài bình yên và hoàng hôn đẹp nao lòng. Nếu bạn đang tìm một hành trình để “sạc lại năng lượng”, Phú Yên chắc chắn là lựa chọn không thể bỏ qua.',
            key: Key('article-detail-introduction'),
            style: TextStyle(
              color: _body,
              fontFamily: 'Be Vietnam Pro',
              fontSize: 13,
              height: 1.5,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        const SizedBox(height: 14),
        const _ArticleSection(
          number: '1',
          title: 'Biển xanh và những điểm đến làm say lòng người',
          body: 'Phú Yên sở hữu những bãi biển hoang sơ, nước biển trong xanh và bờ cát mịn màng như Bãi Xép, Bãi Môn. Đặc biệt, Gành Đá Đĩa với những khối đá basalt độc đáo là điểm đến biểu tượng mà bất kỳ du khách nào cũng muốn một lần chiêm ngưỡng.',
          imageAsset: '$_assetRoot/detail_rock_coast.png',
        ),
        const SizedBox(height: 14),
        const _SeaQuoteCard(),
        const SizedBox(height: 14),
        const _ArticleSection(
          number: '2',
          title: 'Hoàng hôn Phú Yên – khoảnh khắc không thể bỏ lỡ',
          body: 'Khi mặt trời dần buông, cả vùng biển Phú Yên như khoác lên mình tấm áo vàng rực rỡ. Từ Hải đăng Mũi Điện – điểm đón bình minh đầu tiên trên đất liền Việt Nam – đến những ghềnh đá ven biển, hoàng hôn ở Phú Yên luôn khiến lòng người xao xuyến.',
          imageAsset: '$_assetRoot/detail_phu_yen_sunset.png',
        ),
        const SizedBox(height: 14),
        const _ArticleSection(
          number: '3',
          title: 'Ẩm thực dân dã, đậm vị biển cả',
          body: 'Đến Phú Yên, đừng quên thưởng thức những món ngon đậm chất miền biển như mắt cá ngừ đại dương, bánh hỏi lòng heo, tôm hùm, cua huỳnh đế... Ẩm thực nơi đây không chỉ ngon mà còn mang đậm hương vị quê hương, mộc mạc và chân thành.',
          imageAsset: '$_assetRoot/detail_phu_yen_food.png',
        ),
        const SizedBox(height: 14),
        _TripCallToAction(onPressed: onFindTrip),
      ],
    );
  }
}

class _CategoryBadge extends StatelessWidget {
  const _CategoryBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      key: const Key('article-detail-category'),
      width: 72,
      height: 23,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      decoration: BoxDecoration(
        color: const Color(0xFF8DE5B6),
        borderRadius: BorderRadius.circular(10),
      ),
      alignment: Alignment.topLeft,
      child: const Text(
        'Cẩm nang',
        maxLines: 1,
        style: TextStyle(
          color: Color(0xFF0E5C35),
          fontFamily: 'Be Vietnam Pro',
          fontSize: 9,
          height: 1.4,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _ArticleTitle extends StatelessWidget {
  const _ArticleTitle();

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      width: 376,
      child: Text.rich(
        key: Key('article-detail-title'),
        TextSpan(
          children: [
            TextSpan(text: '“'),
            TextSpan(
              text: 'Đi đi em, còn do dự trời tối mất',
              style: TextStyle(
                color: Color(0xFF111317),
                fontWeight: FontWeight.w500,
                fontStyle: FontStyle.italic,
              ),
            ),
            TextSpan(
              text: '” — Phú Yên xanh ngây ngất, chần chừ lỡ cả hoàng hôn!',
            ),
          ],
        ),
        style: TextStyle(
          color: Color(0xFF101E44),
          fontFamily: 'Be Vietnam Pro',
          fontSize: 21,
          height: 1.5,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _ArticleSection extends StatelessWidget {
  const _ArticleSection({
    required this.number,
    required this.title,
    required this.body,
    required this.imageAsset,
  });

  final String number;
  final String title;
  final String body;
  final String imageAsset;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      key: Key('article-detail-section-$number'),
      width: 376,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 24,
                height: 24,
                decoration: const BoxDecoration(
                  color: _blue,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Text(
                  number,
                  style: const TextStyle(
                    color: Colors.white,
                    fontFamily: 'Be Vietnam Pro',
                    fontSize: 14,
                    height: 1.5,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    color: _ink,
                    fontFamily: 'Be Vietnam Pro',
                    fontSize: 15,
                    height: 1.5,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 160,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 206,
                  child: Text(
                    body,
                    style: const TextStyle(
                      color: _body,
                      fontFamily: 'Be Vietnam Pro',
                      fontSize: 12,
                      height: 1.5,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                ClipRRect(
                  key: Key('article-detail-section-image-$number'),
                  borderRadius: BorderRadius.circular(9),
                  child: SizedBox(
                    width: 158,
                    height: 160,
                    child: Image.asset(imageAsset, fit: BoxFit.cover),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SeaQuoteCard extends StatelessWidget {
  const _SeaQuoteCard();

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      key: const Key('article-detail-quote-card'),
      borderRadius: BorderRadius.circular(14),
      child: SizedBox(
        width: 376,
        height: 205,
        child: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                '$_assetRoot/detail_blue_sea_quote.png',
                fit: BoxFit.cover,
              ),
            ),
            const Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    stops: [0, .62, 1],
                    colors: [
                      Color(0xFFFFF7ED),
                      Color(0xE8FFF7ED),
                      Color(0x1FFFF7ED),
                    ],
                  ),
                ),
              ),
            ),
            const Positioned(
              left: 15,
              top: 2,
              child: Text(
                '“',
                style: TextStyle(
                  color: Color(0xFF008FCE),
                  fontFamily: 'Be Vietnam Pro',
                  fontSize: 38,
                  height: 1.5,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const Positioned(
              left: 20,
              top: 42,
              child: Text(
                'Mình đi đến nơi có',
                style: TextStyle(
                  color: _ink,
                  fontFamily: 'Be Vietnam Pro',
                  fontSize: 22,
                  height: 1.5,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const Positioned(
              left: 20,
              top: 75,
              child: Text(
                'biển bạc núi xanh  ”',
                style: TextStyle(
                  color: _blue,
                  fontFamily: 'Be Vietnam Pro',
                  fontSize: 19,
                  height: 1.5,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const Positioned(
              left: 12,
              top: 108,
              width: 260,
              child: Text(
                'Phú Yên là nơi biển ôm núi biếc, nắng vương trên những cung đường và hoàng hôn níu bước chân người. Đôi khi, thanh xuân chỉ cần một tấm vé xe và chút can đảm để lên đường. Bởi Phú Yên đẹp đến nao lòng, thử một làm đứa nhóc, sớm thức dậy ở một nơi xa.',
                style: TextStyle(
                  color: _body,
                  fontFamily: 'Be Vietnam Pro',
                  fontSize: 11,
                  height: 1.5,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            const Positioned(
              left: 280,
              top: 167,
              width: 86,
              child: Text(
                'Đưa nhau đi trốn - Đen ft. Linh Cáo',
                style: TextStyle(
                  color: Color(0xFF080808),
                  fontFamily: 'Be Vietnam Pro',
                  fontSize: 10,
                  height: 1.65,
                  fontWeight: FontWeight.w200,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          ],
        ),
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
      key: const Key('article-detail-cta-card'),
      width: 376,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFE6F6FF),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Muốn đi Phú Yên ngay?',
            style: TextStyle(
              color: _ink,
              fontFamily: 'Be Vietnam Pro',
              fontSize: 16,
              height: 1.5,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Tìm chuyến phù hợp để săn biển xanh\nvà hoàng hôn đẹp nhất.',
            style: TextStyle(
              color: Color(0xFF597D9F),
              fontFamily: 'Be Vietnam Pro',
              fontSize: 12,
              height: 1.5,
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: 348,
            height: 38,
            child: FilledButton(
              key: const Key('article-detail-find-trip'),
              onPressed: onPressed,
              style: FilledButton.styleFrom(
                padding: EdgeInsets.zero,
                backgroundColor: _blue,
                foregroundColor: Colors.white,
                disabledBackgroundColor: _blue,
                disabledForegroundColor: Colors.white,
                shape: const StadiumBorder(),
                textStyle: const TextStyle(
                  fontFamily: 'Be Vietnam Pro',
                  fontSize: 13,
                  height: 1.5,
                  fontWeight: FontWeight.w600,
                ),
              ),
              child: const Text('Tìm chuyến đi  ›'),
            ),
          ),
        ],
      ),
    );
  }
}
