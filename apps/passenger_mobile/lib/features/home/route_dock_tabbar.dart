import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

const _dockAssetRoot = 'assets/home/tabbar';
const _primary = Color(0xFF2B7EAD);
const _inactive = Color(0xFF74777B);

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
    return SizedBox(
      height: 120 + bottomInset,
      child: Padding(
        padding: EdgeInsets.only(bottom: bottomInset),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final width = math.min(390.0, constraints.maxWidth);
            return Align(
              alignment: Alignment.bottomCenter,
              child: SizedBox(
                key: const Key('route-dock-tabbar'),
                width: width,
                height: 120,
                child: _DockCanvas(currentIndex: currentIndex, onTap: onTap),
              ),
            );
          },
        ),
      ),
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
        final slot = width / 5;
        final bubbleSize = width < 350 ? 58.0 : 64.0;
        final activeCenter = slot * (currentIndex + .5);
        final iconSize = width < 350 ? 22.0 : 24.0;
        final labelFontSize = width < 350 ? 10.5 : 12.0;

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
                  color: const Color(0xFFEBF5FB),
                  borderRadius: BorderRadius.circular(30),
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
                left: slot * (index + .5) - 2.5,
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
              child: SvgPicture.asset(
                '$_dockAssetRoot/capsule_notch.svg',
                fit: BoxFit.fill,
                excludeFromSemantics: true,
              ),
            ),
            Positioned(
              left: activeCenter - bubbleSize / 2,
              top: width < 350 ? 10 : 7,
              width: bubbleSize,
              height: bubbleSize,
              child: DecoratedBox(
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
                  padding: EdgeInsets.all((bubbleSize - iconSize) / 2),
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
              left: 0,
              right: 0,
              top: 51,
              height: 57,
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
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Opacity(
                              opacity: active ? 0 : 1,
                              child: SvgPicture.asset(
                                RouteDockTabBar.iconAssets[index],
                                width: iconSize,
                                height: iconSize,
                                excludeFromSemantics: true,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 2,
                              ),
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text(
                                  RouteDockTabBar.labels[index],
                                  maxLines: 1,
                                  style: TextStyle(
                                    fontFamily: 'Be Vietnam Pro',
                                    fontSize: labelFontSize,
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
