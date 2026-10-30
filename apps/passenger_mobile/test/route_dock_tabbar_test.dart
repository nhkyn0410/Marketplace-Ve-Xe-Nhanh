import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:passenger_mobile/features/home/route_dock_tabbar.dart';

Future<void> _pumpDock(
  WidgetTester tester, {
  required double width,
  double bottomInset = 0,
  int currentIndex = 2,
  ValueChanged<int>? onTap,
}) async {
  tester.view.devicePixelRatio = 1;
  tester.view.physicalSize = Size(width, 800);
  addTearDown(tester.view.resetDevicePixelRatio);
  addTearDown(tester.view.resetPhysicalSize);

  await tester.pumpWidget(
    MaterialApp(
      home: Builder(
        builder: (context) {
          final media = MediaQuery.of(context);
          return MediaQuery(
            data: media.copyWith(padding: EdgeInsets.only(bottom: bottomInset)),
            child: Scaffold(
              bottomNavigationBar: RouteDockTabBar(
                currentIndex: currentIndex,
                onTap: onTap ?? (_) {},
              ),
            ),
          );
        },
      ),
    ),
  );
  // Bóng tròn trượt từ tab vẽ trước đó; chờ trượt xong.
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('dock bám kích thước Figma và căn giữa trên màn hình rộng', (
    tester,
  ) async {
    for (final width in <double>[320, 360, 390, 430, 480]) {
      await _pumpDock(tester, width: width);

      final rect = tester.getRect(find.byKey(const Key('route-dock-tabbar')));
      final expectedWidth = width > 390 ? 390.0 : width;
      expect(rect.width, expectedWidth, reason: 'viewport $width dp');
      expect(
        rect.left,
        (width - expectedWidth) / 2,
        reason: 'viewport $width dp',
      );
      expect(rect.bottom, 800, reason: 'viewport $width dp');
      expect(tester.takeException(), isNull, reason: 'viewport $width dp');
    }
  });

  testWidgets('dock chừa vùng thao tác hệ thống mà không tạo overflow', (
    tester,
  ) async {
    await _pumpDock(tester, width: 390, bottomInset: 34);

    final rect = tester.getRect(find.byKey(const Key('route-dock-tabbar')));
    expect(rect.left, 0);
    expect(rect.right, 390);
    expect(rect.bottom, 766);
    expect(tester.takeException(), isNull);
  });

  testWidgets('dock giữ nguyên callback điều hướng hiện tại', (tester) async {
    int? tappedIndex;
    await _pumpDock(tester, width: 390, onTap: (index) => tappedIndex = index);

    await tester.tap(find.byKey(const Key('route-dock-tab-4')));
    expect(tappedIndex, 4);
  });

  testWidgets('khung trắng luôn là capsule liền mạch khi đổi tab active', (
    tester,
  ) async {
    for (final currentIndex in <int>[2, 4]) {
      await _pumpDock(tester, width: 390, currentIndex: currentIndex);

      final surfaceFinder = find.byKey(const Key('route-dock-surface'));
      final surface = tester.widget<DecoratedBox>(surfaceFinder);
      final decoration = surface.decoration as BoxDecoration;
      final rect = tester.getRect(surfaceFinder);

      expect(rect, const Rect.fromLTWH(0, 712, 390, 76));
      expect(
        decoration.borderRadius,
        const BorderRadius.all(Radius.circular(30)),
      );
      expect(decoration.color, Colors.white);
      expect(tester.takeException(), isNull);
    }
  });

  testWidgets('icon, nhãn và bubble giữ đúng kích thước Figma', (tester) async {
    await _pumpDock(tester, width: 320, currentIndex: 4);

    for (var index = 0; index < 5; index++) {
      expect(
        tester.getSize(find.byKey(Key('route-dock-icon-$index'))),
        const Size.square(24),
      );
      final iconRect = tester.getRect(
        find.byKey(Key('route-dock-icon-$index')),
      );
      final labelRect = tester.getRect(
        find.byKey(Key('route-dock-label-$index')),
      );
      expect(labelRect.top - iconRect.bottom, closeTo(7, .01));
    }
    expect(
      tester.getSize(find.byKey(const Key('route-dock-active-bubble'))),
      const Size.square(58),
    );

    await _pumpDock(tester, width: 390, currentIndex: 2);
    expect(
      tester.getSize(find.byKey(const Key('route-dock-active-bubble'))),
      const Size.square(64),
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('đổi tab: bóng tròn trượt từ tab cũ sang tab mới', (
    tester,
  ) async {
    await _pumpDock(tester, width: 390, currentIndex: 0);
    double bubbleCenter() =>
        tester.getCenter(find.byKey(const Key('route-dock-active-bubble'))).dx;
    final start = bubbleCenter();

    await _pumpDock(tester, width: 390, currentIndex: 4);
    final end = bubbleCenter();
    expect(end, greaterThan(start + 250));

    // Dựng thanh dock mới ở tab 1 (như khi mở tab khác): bóng bắt đầu từ tab 4.
    await tester.pumpWidget(const SizedBox());
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          bottomNavigationBar: RouteDockTabBar(currentIndex: 1, onTap: (_) {}),
        ),
      ),
    );
    await tester.pump(const Duration(milliseconds: 60));
    final midway = bubbleCenter();
    expect(midway, lessThan(end));
    expect(midway, greaterThan(start));
    await tester.pumpAndSettle();
    expect(bubbleCenter(), closeTo(start + (end - start) / 4, 1));
  });

  testWidgets('nội dung tab hiện dần khi mở, tắt hiệu ứng thì hiện ngay', (
    tester,
  ) async {
    double opacity() => tester
        .widget<FadeTransition>(
          find.descendant(
            of: find.byType(TabEntrance),
            matching: find.byType(FadeTransition),
          ),
        )
        .opacity
        .value;

    await tester.pumpWidget(
      const MaterialApp(home: TabEntrance(child: Text('Nội dung'))),
    );
    expect(opacity(), closeTo(.3, .001));
    await tester.pump(const Duration(milliseconds: 120));
    expect(opacity(), inExclusiveRange(.3, 1));
    await tester.pumpAndSettle();
    expect(opacity(), 1);

    await tester.pumpWidget(
      const MediaQuery(
        data: MediaQueryData(disableAnimations: true),
        child: MaterialApp(home: TabEntrance(child: Text('Ngay'))),
      ),
    );
    expect(
      find.descendant(
        of: find.byType(TabEntrance),
        matching: find.byType(FadeTransition),
      ),
      findsNothing,
    );
  });

  testWidgets(
    'dock ẩn khi cuộn: dải nền nút điều hướng hệ thống vẫn đứng yên',
    (tester) async {
      tester.view.devicePixelRatio = 1;
      tester.view.physicalSize = const Size(390, 800);
      addTearDown(tester.view.reset);
      int? tapped;
      Widget dock(bool visible) => MaterialApp(
        home: MediaQuery(
          data: const MediaQueryData(
            size: Size(390, 800),
            padding: EdgeInsets.only(bottom: 48),
          ),
          child: Scaffold(
            bottomNavigationBar: RouteDockTabBar(
              currentIndex: 2,
              onTap: (index) => tapped = index,
              visible: visible,
              slideKey: const Key('dock-slide'),
            ),
          ),
        ),
      );

      await tester.pumpWidget(dock(true));
      await tester.pumpAndSettle();
      await tester.pumpWidget(dock(false));
      await tester.pumpAndSettle();

      expect(
        tester
            .widget<AnimatedSlide>(find.byKey(const Key('dock-slide')))
            .offset,
        const Offset(0, 1),
      );
      final inset = tester.getRect(
        find.byKey(const Key('route-dock-system-inset')),
      );
      expect(inset.bottom, 800);
      expect(inset.height, 48);
      // Dock ẩn thì không nhận chạm.
      await tester.tap(
        find.byKey(const Key('route-dock-tab-0')),
        warnIfMissed: false,
      );
      expect(tapped, isNull);
    },
  );

  testWidgets('nền thanh trạng thái chỉ hiện khi nội dung đã cuộn', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: MediaQuery(
          data: const MediaQueryData(
            size: Size(390, 800),
            padding: EdgeInsets.only(top: 40),
          ),
          child: ScrolledStatusBarScrim(
            color: Colors.white,
            child: ListView(
              key: const Key('scrim-list'),
              children: [for (var i = 0; i < 40; i++) Text('Dòng $i')],
            ),
          ),
        ),
      ),
    );
    double opacity() => tester
        .widget<AnimatedOpacity>(find.byKey(const Key('status-bar-scrim')))
        .opacity;
    expect(opacity(), 0);
    expect(
      tester.getSize(find.byKey(const Key('status-bar-scrim'))).height,
      40,
    );

    await tester.drag(
      find.byKey(const Key('scrim-list')),
      const Offset(0, -200),
    );
    await tester.pumpAndSettle();
    expect(opacity(), 1);

    await tester.drag(
      find.byKey(const Key('scrim-list')),
      const Offset(0, 400),
    );
    await tester.pumpAndSettle();
    expect(opacity(), 0);
  });
}
