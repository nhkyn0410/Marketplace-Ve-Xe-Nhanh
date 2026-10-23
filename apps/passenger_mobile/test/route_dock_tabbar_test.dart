import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:passenger_mobile/features/home/route_dock_tabbar.dart';

Future<void> _pumpDock(
  WidgetTester tester, {
  required double width,
  double bottomInset = 0,
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
                currentIndex: 2,
                onTap: onTap ?? (_) {},
              ),
            ),
          );
        },
      ),
    ),
  );
  await tester.pump();
}

void main() {
  testWidgets('dock chiếm toàn bộ chiều rộng trên các màn hình điện thoại', (
    tester,
  ) async {
    for (final width in <double>[320, 360, 390, 430, 480]) {
      await _pumpDock(tester, width: width);

      final rect = tester.getRect(find.byKey(const Key('route-dock-tabbar')));
      expect(rect.left, 0, reason: 'viewport $width dp');
      expect(rect.right, width, reason: 'viewport $width dp');
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
}
