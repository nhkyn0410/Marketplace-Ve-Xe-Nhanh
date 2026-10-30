import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

const _dockAssetRoot = 'assets/home/tabbar';
const _primary = Color(0xFF2B7EAD);
const _inactive = Color(0xFF74777B);
const _dockBackground = Color(0xFFEBF5FB);

class RouteDockTabBar extends StatelessWidget {
  const RouteDockTabBar({
    required this.currentIndex,
    required this.onTap,
    super.key,
  });

  final int currentIndex;
  final ValueChanged<int> onTap;

  static const labels = <String>[
    'Khám phá',
    'Mua vé',
    'Trang chủ',
    'Hành trình',
    'Tài khoản',
  ];

  static const iconAssets = <String>[
    '$_dockAssetRoot/explore.svg',
    '$_dockAssetRoot/ticket.svg',
    '$_dockAssetRoot/home_inactive.svg',
    '$_dockAssetRoot/journey.svg',
    '$_dockAssetRoot/account.svg',
  ];

  /// Tab mà thanh dock vừa hiển thị. Mỗi tab dựng thanh dock riêng, nên nhờ giá trị này
  /// bóng tròn trượt từ tab cũ sang tab mới thay vì nhảy thẳng.
  static int? _lastIndex;

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.paddingOf(context).bottom;
    final from = _lastIndex ?? currentIndex;
    _lastIndex = currentIndex;
    final duration = MediaQuery.disableAnimationsOf(context)
        ? Duration.zero
        : const Duration(milliseconds: 380);
    return LayoutBuilder(
      builder: (context, constraints) {
        final dockWidth = constraints.maxWidth.clamp(0.0, 390.0);
        return SizedBox(
          height: 120 + bottomInset,
          child: Stack(
            children: [
              Positioned(
                left: (constraints.maxWidth - dockWidth) / 2,
                top: 0,
                width: dockWidth,
                height: 120,
                child: SizedBox(
                  key: const Key('route-dock-tabbar'),
                  child: TweenAnimationBuilder<double>(
                    tween: Tween(
                      begin: from.toDouble(),
                      end: currentIndex.toDouble(),
                    ),
                    duration: duration,
                    curve: Curves.easeOutCubic,
                    builder: (context, position, _) => _DockCanvas(
                      currentIndex: currentIndex,
                      position: position,
                      onTap: onTap,
                    ),
                  ),
                ),
              ),
              if (bottomInset > 0)
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  height: bottomInset,
                  child: const ColoredBox(color: _dockBackground),
                ),
            ],
          ),
        );
      },
    );
  }
}

class _DockCanvas extends StatelessWidget {
  const _DockCanvas({
    required this.currentIndex,
    required this.position,
    required this.onTap,
  });

  final int currentIndex;

  /// Vị trí bóng tròn (chỉ số tab, có phần lẻ khi đang trượt).
  final double position;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final tabsInset = width * 5 / 390;
        final tabsWidth = width - tabsInset * 2;
        final slot = tabsWidth / 5;
        // Bóng ở Trang chủ to hơn (64 so với 58); đổi cỡ dần khi trượt qua.
        final homeness = (1 - (position - 2).abs()).clamp(0.0, 1.0);
        final bubbleSize = 58.0 + 6 * homeness;
        final activeCenter = tabsInset + slot * (position + .5);
        // Biểu tượng trong bóng hiện dần khi bóng tới tab mới.
        final arrival = (1 - (position - currentIndex).abs()).clamp(0.0, 1.0);

        return Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned(
              left: 0,
              right: 0,
              top: 16,
              height: 92,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: _dockBackground,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(30),
                  ),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x292B7EAD),
                      offset: Offset(0, 6),
                      blurRadius: 16,
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              left: width * 30 / 390,
              right: width * 30 / 390,
              top: 22,
              height: 9,
              child: SvgPicture.asset(
                '$_dockAssetRoot/route_line.svg',
                fit: BoxFit.fill,
                excludeFromSemantics: true,
              ),
            ),
            ...List.generate(5, (index) {
              return Positioned(
                left: tabsInset + slot * (index + .5) - 2.5,
                top: 24,
                width: 5,
                height: 5,
                child: SvgPicture.asset(
                  '$_dockAssetRoot/stop.svg',
                  excludeFromSemantics: true,
                ),
              );
            }),
            Positioned(
              left: width * 303 / 390,
              top: 12,
              width: 18,
              height: 18,
              child: SvgPicture.asset(
                '$_dockAssetRoot/bus_marker.svg',
                excludeFromSemantics: true,
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              top: 32,
              height: 76,
              child: DecoratedBox(
                key: const Key('route-dock-surface'),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(30)),
                  border: Border.fromBorderSide(
                    BorderSide(color: _dockBackground, width: 1.5),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Color(0x242B7EAD),
                      offset: Offset(0, 5),
                      blurRadius: 10,
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              left: activeCenter - bubbleSize / 2,
              top: 10 - 3 * homeness,
              width: bubbleSize,
              height: bubbleSize,
              child: DecoratedBox(
                key: const Key('route-dock-active-bubble'),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(color: _primary),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x292B7EAD),
                      offset: Offset(0, 6),
                      blurRadius: 8,
                    ),
                  ],
                ),
                child: Opacity(
                  opacity: arrival,
                  child: Padding(
                    padding: EdgeInsets.all((bubbleSize - 24) / 2),
                    child: SvgPicture.asset(
                      currentIndex == 2
                          ? '$_dockAssetRoot/home_active.svg'
                          : RouteDockTabBar.iconAssets[currentIndex],
                      colorFilter: currentIndex == 2
                          ? null
                          : const ColorFilter.mode(_primary, BlendMode.srcIn),
                      excludeFromSemantics: true,
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              left: activeCenter - 4,
              top: 3,
              width: 8,
              height: 8,
              child: SvgPicture.asset(
                '$_dockAssetRoot/active_stop.svg',
                excludeFromSemantics: true,
              ),
            ),
            Positioned(
              left: tabsInset,
              top: 6,
              width: tabsWidth,
              height: 100,
              child: Row(
                children: List.generate(5, (index) {
                  final active = index == currentIndex;
                  return Expanded(
                    child: Semantics(
                      selected: active,
                      button: true,
                      label: RouteDockTabBar.labels[index],
                      child: InkResponse(
                        key: Key('route-dock-tab-$index'),
                        onTap: () => onTap(index),
                        radius: 34,
                        child: Stack(
                          alignment: Alignment.topCenter,
                          children: [
                            Positioned(
                              top: 45,
                              left: 0,
                              right: 0,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Opacity(
                                    opacity: active ? 0 : 1,
                                    child: SizedBox.square(
                                      key: Key('route-dock-icon-$index'),
                                      dimension: 24,
                                      child: SvgPicture.asset(
                                        RouteDockTabBar.iconAssets[index],
                                        excludeFromSemantics: true,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 7),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 2,
                                    ),
                                    child: FittedBox(
                                      fit: BoxFit.scaleDown,
                                      child: Text(
                                        RouteDockTabBar.labels[index],
                                        key: Key('route-dock-label-$index'),
                                        maxLines: 1,
                                        style: TextStyle(
                                          fontFamily: 'Be Vietnam Pro',
                                          fontSize: 12,
                                          height: 1.5,
                                          fontWeight: active
                                              ? FontWeight.w600
                                              : FontWeight.w400,
                                          color: active ? _primary : _inactive,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
          ],
        );
      },
    );
  }
}

/// Nội dung một tab hiện dần và trượt nhẹ lên khi mở tab; thanh dock nằm ngoài nên đứng yên.
class TabEntrance extends StatefulWidget {
  const TabEntrance({required this.child, super.key});

  final Widget child;

  @override
  State<TabEntrance> createState() => _TabEntranceState();
}

class _TabEntranceState extends State<TabEntrance>
    with SingleTickerProviderStateMixin {
  late final _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 320),
  )..forward();
  late final _curve = CurvedAnimation(
    parent: _controller,
    curve: Curves.easeOutCubic,
  );
  // Bắt đầu từ 0.3 chứ không từ 0: tránh khung đầu trống trơn trông như nháy màn.
  late final _opacity = Tween<double>(begin: .3, end: 1).animate(_curve);
  late final _offset = Tween<Offset>(
    begin: const Offset(0, .02),
    end: Offset.zero,
  ).animate(_curve);

  @override
  void dispose() {
    _curve.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.disableAnimationsOf(context)) return widget.child;
    return FadeTransition(
      opacity: _opacity,
      child: SlideTransition(position: _offset, child: widget.child),
    );
  }
}
