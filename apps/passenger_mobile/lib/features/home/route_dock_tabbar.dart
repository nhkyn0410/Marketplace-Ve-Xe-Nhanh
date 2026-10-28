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

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.paddingOf(context).bottom;
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
                  child: _DockCanvas(currentIndex: currentIndex, onTap: onTap),
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
  const _DockCanvas({required this.currentIndex, required this.onTap});

  final int currentIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final tabsInset = width * 5 / 390;
        final tabsWidth = width - tabsInset * 2;
        final slot = tabsWidth / 5;
        final bubbleSize = currentIndex == 2 ? 64.0 : 58.0;
        final activeCenter = tabsInset + slot * (currentIndex + .5);

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
              top: currentIndex == 2 ? 7 : 10,
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
