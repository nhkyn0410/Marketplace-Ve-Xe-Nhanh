import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_shared/mobile_shared.dart';
import 'package:passenger_mobile/features/home/home_models.dart';
import 'package:passenger_mobile/features/ticket/ticket_screen.dart';
import 'package:passenger_mobile/features/ticket/trip_search_models.dart';

import 'support/trip_search_fakes.dart';

Future<void> _pumpTicket(
  WidgetTester tester, {
  required double width,
  double height = 800,
  double textScale = 1,
  HomeSearchQuery? initialQuery,
  TripSearchRunner? searchTrips,
  ValueChanged<HomeSearchQuery>? onQueryChanged,
}) async {
  tester.view.devicePixelRatio = 1;
  tester.view.physicalSize = Size(width, height);
  addTearDown(tester.view.resetDevicePixelRatio);
  addTearDown(tester.view.resetPhysicalSize);

  await tester.pumpWidget(
    MaterialApp(
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Be Vietnam Pro',
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF2B7EAD)),
      ),
      builder: (context, child) {
        final media = MediaQuery.of(context);
        return MediaQuery(
          data: media.copyWith(textScaler: TextScaler.linear(textScale)),
          child: child!,
        );
      },
      home: TicketScreen(
        onTabSelected: (_) {},
        searchCatalog: fakeCatalog(),
        searchTrips: searchTrips,
        initialQuery: initialQuery,
        onQueryChanged: onQueryChanged,
      ),
    ),
  );
  await tester.pumpAndSettle();
}

TripSearchRunner _recording(
  List<SearchCall> calls,
  TripSearchPage Function(SearchCall call) respond,
) {
  return (query, filters, page) async {
    final call = SearchCall(query, filters, page);
    calls.add(call);
    return respond(call);
  };
}

void main() {
  testWidgets('Mua vé responsive không bottom overflow ở các viewport', (
    tester,
  ) async {
    for (final width in <double>[320, 360, 375, 390, 412, 430, 480]) {
      await _pumpTicket(
        tester,
        width: width,
        height: 720,
        initialQuery: sampleQuery,
        searchTrips: (_, _, _) async => samplePage([sampleTrip('t1')]),
      );
      expect(find.byKey(const Key('ticket-screen')), findsOneWidget);
      expect(find.byKey(const Key('ticket-journey-planner')), findsOneWidget);
      expect(find.byKey(const Key('route-dock-tabbar')), findsOneWidget);
      expect(tester.takeException(), isNull, reason: 'viewport $width dp');
    }
  });

  testWidgets('chưa tìm: form trống, gợi ý chọn điểm rồi bấm Tìm chuyến', (
    tester,
  ) async {
    await _pumpTicket(tester, width: 390);
    expect(find.text('Chọn điểm đi'), findsOneWidget);
    expect(find.text('Chọn điểm đến'), findsOneWidget);
    expect(find.textContaining('rồi bấm "Tìm chuyến"'), findsOneWidget);

    await tester.tap(find.byKey(const Key('ticket-search-button')));
    await tester.pump();
    expect(
      find.text('Vui lòng chọn điểm đi và điểm đến từ danh mục.'),
      findsOneWidget,
    );
  });

  testWidgets('mang điều kiện từ Trang chủ: tìm ngay, hiện thẻ chuyến từ API', (
    tester,
  ) async {
    final calls = <SearchCall>[];
    await _pumpTicket(
      tester,
      width: 412,
      height: 1000,
      initialQuery: sampleQuery,
      searchTrips: _recording(
        calls,
        (_) => samplePage([
          sampleTrip('t1', seats: 4),
          sampleTrip('t2', operatorName: 'Thành Bưởi', rating: null, reviewCount: 0),
        ]),
      ),
    );

    expect(calls, hasLength(1));
    expect(calls.single.page, 1);
    expect(calls.single.query.from.id, 'hcm');
    expect(find.text('TP. Hồ Chí Minh'), findsWidgets);
    expect(find.text('2 chuyến phù hợp'), findsOneWidget);
    final first = find.byKey(const ValueKey('ticket-trip-t1'));
    expect(first, findsOneWidget);
    expect(
      find.descendant(of: first, matching: find.text('280.000 ₫')),
      findsOneWidget,
    );
    expect(
      find.descendant(of: first, matching: find.text('07:00')),
      findsOneWidget,
    );
    expect(
      find.descendant(of: first, matching: find.text('6h30')),
      findsOneWidget,
    );
    expect(
      find.descendant(of: first, matching: find.text('4.7 (12 đánh giá)')),
      findsOneWidget,
    );
    expect(
      find.descendant(of: first, matching: find.text('Chỉ còn 4 chỗ')),
      findsOneWidget,
    );
    expect(find.text('Chưa có đánh giá'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('đang tải, lỗi có nút Thử lại, rỗng có lời nhắn', (tester) async {
    final pending = Completer<TripSearchPage>();
    var attempt = 0;
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(412, 900);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.view.resetPhysicalSize);
    await tester.pumpWidget(
      MaterialApp(
        home: TicketScreen(
          onTabSelected: (_) {},
          searchCatalog: fakeCatalog(),
          initialQuery: sampleQuery,
          searchTrips: (_, _, _) {
            attempt++;
            if (attempt == 1) return pending.future;
            return Future.value(samplePage(const []));
          },
        ),
      ),
    );
    await tester.pump();
    expect(find.byKey(const Key('ticket-loading')), findsOneWidget);

    pending.completeError(
      const ApiFailure(status: 0, code: 'NETWORK_ERROR', detail: 'x'),
    );
    await tester.pumpAndSettle();
    expect(
      find.text('Không thể kết nối máy chủ. Vui lòng kiểm tra mạng và thử lại.'),
      findsOneWidget,
    );

    await tester.tap(find.text('Thử lại'));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('ticket-empty')), findsOneWidget);
    expect(find.textContaining('Chưa có chuyến phù hợp'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('bộ lọc gửi đúng tham số BR-77 + giờ đón; chip lọc gỡ được', (
    tester,
  ) async {
    final calls = <SearchCall>[];
    await _pumpTicket(
      tester,
      width: 390,
      height: 900,
      initialQuery: sampleQuery,
      searchTrips: _recording(calls, (_) => samplePage([sampleTrip('t1')])),
    );

    await tester.tap(find.byKey(const Key('ticket-filter-chip')));
    await tester.pumpAndSettle();
    expect(find.text('Lọc chuyến'), findsOneWidget);
    expect(find.text('Cabin'), findsOneWidget);
    await tester.tap(find.byKey(const ValueKey('ticket-filter-form-sleeper')));
    await tester.tap(
      find.byKey(const ValueKey('ticket-filter-class-limousine')),
    );
    await tester.tap(find.byKey(const ValueKey('ticket-filter-slot-morning')));
    await tester.pump();
    await tester.tap(find.byKey(const Key('ticket-filter-apply')));
    await tester.pumpAndSettle();

    final filters = calls.last.filters;
    expect(filters.vehicleForm, TripVehicleForm.sleeper);
    expect(filters.vehicleClass, TripVehicleClass.limousine);
    expect(filters.departureSlot, TripDepartureSlot.morning);
    expect(filters.activeCount, 3);
    expect(find.text('Limousine'), findsOneWidget);

    await tester.ensureVisible(find.text('Limousine'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Limousine'));
    await tester.pumpAndSettle();
    expect(calls.last.filters.vehicleClass, isNull);
    expect(calls.last.filters.vehicleForm, TripVehicleForm.sleeper);
    expect(tester.takeException(), isNull);
  });

  testWidgets('sắp xếp theo giá gửi lại tìm kiếm', (tester) async {
    final calls = <SearchCall>[];
    await _pumpTicket(
      tester,
      width: 390,
      initialQuery: sampleQuery,
      searchTrips: _recording(calls, (_) => samplePage([sampleTrip('t1')])),
    );
    await tester.tap(find.byKey(const Key('ticket-sort-chip')));
    await tester.pumpAndSettle();
    expect(find.text('Đánh giá cao nhất'), findsNothing);
    await tester.tap(find.byKey(const ValueKey('ticket-sort-price')));
    await tester.pumpAndSettle();
    expect(calls.last.filters.sort, TripSearchSort.price);
    expect(find.text('Giá thấp nhất'), findsOneWidget);
  });

  testWidgets('cuộn gần cuối thì tải trang tiếp theo', (tester) async {
    final calls = <SearchCall>[];
    await _pumpTicket(
      tester,
      width: 390,
      height: 800,
      initialQuery: sampleQuery,
      searchTrips: _recording(calls, (call) {
        final offset = (call.page - 1) * 3;
        return samplePage(
          [for (var i = 0; i < 3; i++) sampleTrip('t${offset + i}')],
          total: 6,
          page: call.page,
          limit: 3,
        );
      }),
    );
    await tester.drag(
      find.byKey(const Key('ticket-content-scroll')),
      const Offset(0, -3000),
    );
    await tester.pumpAndSettle();
    expect(calls.map((call) => call.page), [1, 2]);
    await tester.drag(
      find.byKey(const Key('ticket-content-scroll')),
      const Offset(0, -3000),
    );
    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey('ticket-trip-t5')), findsOneWidget);
    expect(calls, hasLength(2));
  });

  testWidgets('bấm Tìm chuyến ở Mua vé báo điều kiện mới cho màn cha', (
    tester,
  ) async {
    HomeSearchQuery? reported;
    await _pumpTicket(
      tester,
      width: 390,
      height: 900,
      initialQuery: sampleQuery,
      searchTrips: (_, _, _) async => samplePage([sampleTrip('t1')]),
      onQueryChanged: (query) => reported = query,
    );
    expect(reported, isNull);
    await tester.tap(find.byKey(const Key('ticket-swap-locations')));
    await tester.pump();
    await tester.tap(find.byKey(const Key('ticket-search-button')));
    await tester.pumpAndSettle();
    expect(reported!.from.id, 'lam-dong');
    expect(reported!.to.id, 'hcm');
  });

  testWidgets('chuyển Theo chuyến và Theo nhà xe giữ animation', (
    tester,
  ) async {
    await _pumpTicket(tester, width: 390);
    final indicator = find.byKey(const Key('ticket-search-mode-indicator'));
    final startX = tester.getCenter(indicator).dx;

    await tester.tap(find.byKey(const Key('ticket-mode-operator')));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));
    final movingX = tester.getCenter(indicator).dx;

    expect(movingX, greaterThan(startX));
    expect(find.byKey(const ValueKey('ticket-operator-input')), findsOneWidget);
    await tester.pumpAndSettle();
    expect(find.text('Chọn nhà xe'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('bottom sheet bộ lọc cuộn và áp dụng không overflow', (
    tester,
  ) async {
    await _pumpTicket(
      tester,
      width: 320,
      height: 568,
      textScale: 1.3,
      initialQuery: sampleQuery,
      searchTrips: (_, _, _) async => samplePage([sampleTrip('t1')]),
    );

    await tester.ensureVisible(find.byKey(const Key('ticket-filter-chip')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('ticket-filter-chip')));
    await tester.pumpAndSettle();
    expect(find.text('Lọc chuyến'), findsOneWidget);
    expect(tester.takeException(), isNull);

    await tester.scrollUntilVisible(
      find.text('Nhà xe'),
      350,
      scrollable: find.descendant(
        of: find.byKey(const Key('ticket-filter-scroll')),
        matching: find.byType(Scrollable),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Nhà xe'), findsOneWidget);
    expect(tester.takeException(), isNull);

    await tester.tap(find.byKey(const Key('ticket-filter-apply')));
    await tester.pumpAndSettle();
    expect(find.text('Lọc chuyến'), findsNothing);
    expect(tester.takeException(), isNull);
  });
}
