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
  double height = 900,
  double textScale = 1,
  HomeSearchQuery? initialQuery,
  Future<HomeSearchQuery?> Function()? loadDefaultQuery,
  TripSearchRunner? searchTrips,
  TripBrowseRunner? browseTrips,
  OperatorFareLoader? loadOperatorFare,
  List<HomeOperator> operators = const [phuongTrang],
  ValueChanged<HomeSearchQuery>? onQueryChanged,
  ValueChanged<HomeOperator>? onOperatorSelected,
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
        searchCatalog: fakeCatalog(
          provinces: const [hcm, lamDong, khanhHoa],
          operators: operators,
        ),
        searchTrips: searchTrips,
        browseTrips: browseTrips,
        loadOperatorFare: loadOperatorFare,
        initialQuery: initialQuery,
        loadDefaultQuery: loadDefaultQuery,
        onQueryChanged: onQueryChanged,
        onOperatorSelected: onOperatorSelected,
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

Future<int?> _fares(String operatorId, HomeOperatorRoute route, DateTime _) {
  return Future.value(switch (operatorId) {
    'op-dl' => 250000,
    'op-pt' => 280000,
    _ => null,
  });
}

void main() {
  testWidgets('thẻ chuyến dùng logo nhà xe; tải lỗi vẫn có chữ thay thế trên nền xanh nhạt', (
    tester,
  ) async {
    const logo = 'https://cdn.example.test/hai-van-logo.png';
    await _pumpTicket(
      tester,
      width: 412,
      height: 1000,
      initialQuery: sampleQuery,
      searchTrips: (_, _, _) async => samplePage([
        sampleTrip('logo-trip', operatorName: 'Hải Vân', operatorLogoUrl: logo),
      ]),
    );
    final card = find.byKey(const ValueKey('ticket-trip-logo-trip'));
    final logoImage = find.byWidgetPredicate(
      (widget) => widget is Image && widget.image is NetworkImage &&
          (widget.image as NetworkImage).url == logo,
    );
    expect(find.descendant(of: card, matching: logoImage), findsOneWidget);
    expect(find.descendant(of: card, matching: find.text('H')), findsOneWidget);
    final scaffold = tester.widget<Scaffold>(find.byKey(const Key('ticket-screen')));
    expect(scaffold.backgroundColor, const Color(0xFFEFFAFF));
    final backdrop = tester.widget<DecoratedBox>(find.descendant(
      of: find.byWidget(scaffold.body!), matching: find.byType(DecoratedBox),
    ).first).decoration as BoxDecoration;
    expect(backdrop.color, const Color(0xFFEFFAFF));
    expect(backdrop.gradient, isNull);
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'chưa tìm lần nào: hiện chuyến sắp chạy, không cần nhập điểm đi / đến hay ngày; thẻ ghi ngày đi',
    (tester) async {
      final browsed = <int>[];
      await _pumpTicket(
        tester,
        width: 412,
        browseTrips: (filters, page) async {
          browsed.add(page);
          return samplePage([sampleTrip('t1')]);
        },
      );

      expect(browsed, [1]);
      expect(find.byKey(const Key('ticket-browse-hint')), findsOneWidget);
      expect(find.byKey(const ValueKey('ticket-trip-t1')), findsOneWidget);
      final gap =
          tester.getTopLeft(find.byKey(const ValueKey('ticket-trip-t1'))).dy -
          tester.getBottomLeft(find.byKey(const Key('ticket-browse-hint'))).dy;
      expect(
        gap,
        inInclusiveRange(8, 24),
        reason: 'Thẻ chuyến nằm sát lời hướng dẫn, không chừa khoảng trống lớn.',
      );
      expect(find.byKey(const ValueKey('ticket-trip-date-t1')), findsOneWidget);
      expect(find.byKey(const Key('ticket-pick-route')), findsNothing);
    },
  );

  testWidgets('Mua vé khám phá responsive không overflow ở các viewport', (
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
      expect(find.text('Khám phá chuyến đi'), findsOneWidget);
      expect(find.byKey(const Key('route-dock-tabbar')), findsOneWidget);
      expect(tester.takeException(), isNull, reason: 'viewport $width dp');
    }
  });

  testWidgets(
    'Chuyến xe: dùng điều kiện mang sang, chip gọn và chuyến sớm nhất trước',
    (tester) async {
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
            sampleTrip(
              't2',
              operatorName: 'Thành Bưởi',
              rating: null,
              reviewCount: 0,
            ),
          ]),
        ),
      );

      expect(calls, hasLength(1));
      expect(calls.single.query.from.id, 'hcm');
      expect(calls.single.query.to.id, 'lam-dong');
      expect(calls.single.filters.sort, TripSearchSort.departure);
      expect(find.byKey(const Key('ticket-journey-planner')), findsNothing);
      for (final (chip, label) in [
        ('explore-date-chip', '30/10/2026'),
        ('explore-passenger-chip', '1 khách'),
        ('explore-origin-chip', 'TP.HCM'),
        ('explore-destination-chip', 'Lâm Đồng'),
        ('explore-filter-chip', 'Bộ lọc'),
      ]) {
        expect(
          find.descendant(
            of: find.byKey(Key(chip)),
            matching: find.text(label),
          ),
          findsOneWidget,
          reason: label,
        );
      }
      expect(find.text('Chuyến đang mở bán'), findsOneWidget);
      expect(find.text('Giờ đi sớm nhất'), findsOneWidget);
      final first = find.byKey(const ValueKey('ticket-trip-t1'));
      expect(first, findsOneWidget);
      expect(
        find.descendant(of: first, matching: find.text('280.000 ₫')),
        findsOneWidget,
      );
      expect(
        find.descendant(of: first, matching: find.text('Chỉ còn 4 chỗ')),
        findsOneWidget,
      );
      expect(find.text('Chưa có đánh giá'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('chưa có điều kiện: tải điều kiện mặc định rồi tìm chuyến', (
    tester,
  ) async {
    final calls = <SearchCall>[];
    await _pumpTicket(
      tester,
      width: 390,
      loadDefaultQuery: () async => sampleQuery,
      searchTrips: _recording(calls, (_) => samplePage([sampleTrip('t1')])),
    );
    expect(calls.single.query.from.id, 'hcm');
    expect(find.byKey(const ValueKey('ticket-trip-t1')), findsOneWidget);
  });

  testWidgets('không có điều kiện mặc định: nhắc chọn điểm đi, điểm đến', (
    tester,
  ) async {
    await _pumpTicket(
      tester,
      width: 390,
      searchTrips: (_, _, _) async => samplePage([sampleTrip('t1')]),
    );
    expect(find.byKey(const Key('ticket-pick-route')), findsOneWidget);
    expect(find.text('Điểm đi'), findsOneWidget);
    expect(find.text('Điểm đến'), findsOneWidget);
  });

  testWidgets('đổi điểm đến qua chip thì tìm lại và báo điều kiện mới', (
    tester,
  ) async {
    final calls = <SearchCall>[];
    HomeSearchQuery? reported;
    await _pumpTicket(
      tester,
      width: 390,
      initialQuery: sampleQuery,
      searchTrips: _recording(calls, (_) => samplePage([sampleTrip('t1')])),
      onQueryChanged: (query) => reported = query,
    );
    expect(reported, isNull);

    await tester.tap(find.byKey(const Key('explore-destination-chip')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Khánh Hòa'));
    await tester.pumpAndSettle();

    expect(calls, hasLength(2));
    expect(calls.last.query.to.id, 'khanh-hoa');
    expect(reported!.to.id, 'khanh-hoa');
    expect(
      find.descendant(
        of: find.byKey(const Key('explore-destination-chip')),
        matching: find.text('Khánh Hòa'),
      ),
      findsOneWidget,
    );
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
      find.text(
        'Không thể kết nối máy chủ. Vui lòng kiểm tra mạng và thử lại.',
      ),
      findsOneWidget,
    );

    await tester.tap(find.text('Thử lại'));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('ticket-empty')), findsOneWidget);
    expect(find.textContaining('Chưa có chuyến phù hợp'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'chip Bộ lọc mở sheet lọc, áp dụng gửi tham số và đếm điều kiện',
    (tester) async {
      final calls = <SearchCall>[];
      await _pumpTicket(
        tester,
        width: 390,
        initialQuery: sampleQuery,
        searchTrips: _recording(calls, (_) => samplePage([sampleTrip('t1')])),
      );

      await tester.tap(find.byKey(const Key('explore-filter-chip')));
      await tester.pumpAndSettle();
      expect(find.text('Lọc chuyến'), findsOneWidget);
      await tester.tap(
        find.byKey(const ValueKey('ticket-filter-class-limousine')),
      );
      await tester.pump();
      await tester.tap(find.byKey(const Key('ticket-filter-apply')));
      await tester.pumpAndSettle();

      expect(calls.last.filters.vehicleClass, TripVehicleClass.limousine);
      expect(calls.last.filters.sort, TripSearchSort.departure);
      expect(find.text('Bộ lọc · 1'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );

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

  testWidgets('chuyển Chuyến xe và Nhà xe giữ animation', (tester) async {
    await _pumpTicket(
      tester,
      width: 390,
      initialQuery: sampleQuery,
      searchTrips: (_, _, _) async => samplePage([sampleTrip('t1')]),
    );
    final indicator = find.byKey(const Key('ticket-search-mode-indicator'));
    final startX = tester.getCenter(indicator).dx;

    await tester.tap(find.byKey(const Key('ticket-mode-operator')));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));
    expect(tester.getCenter(indicator).dx, greaterThan(startX));
    await tester.pumpAndSettle();
    expect(find.text('Nhà xe đang phục vụ'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'Nhà xe: xếp theo đánh giá, có giá vé từ, lọc khu vực còn nhà xe phục vụ',
    (tester) async {
      await _pumpTicket(
        tester,
        width: 412,
        height: 1400,
        initialQuery: sampleQuery,
        searchTrips: (_, _, _) async => samplePage([sampleTrip('t1')]),
        loadOperatorFare: _fares,
        operators: const [phuongTrang, thanhBuoi, dienLinh],
      );
      await tester.tap(find.byKey(const Key('ticket-mode-operator')));
      await tester.pumpAndSettle();

      expect(find.text('Đánh giá cao'), findsOneWidget);
      expect(find.text('Khu vực'), findsOneWidget);
      expect(find.text('Tuyến phục vụ'), findsOneWidget);
      final order = [
        for (final id in ['op-dl', 'op-pt', 'op-tb'])
          tester.getTopLeft(find.byKey(ValueKey('explore-operator-$id'))).dy,
      ];
      expect(order, orderedEquals([...order]..sort()));

      final dienLinhCard = find.byKey(const ValueKey('explore-operator-op-dl'));
      expect(
        find.descendant(
          of: dienLinhCard,
          matching: find.text('★ 4.9 · 1.2K đánh giá'),
        ),
        findsOneWidget,
      );
      expect(
        find.descendant(of: dienLinhCard, matching: find.text('250.000 ₫')),
        findsOneWidget,
      );
      expect(
        find.descendant(
          of: find.byKey(const ValueKey('explore-operator-op-tb')),
          matching: find.text('Chưa mở bán ngày 30/10'),
        ),
        findsOneWidget,
      );

      await tester.tap(find.byKey(const Key('explore-area-chip')));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Khánh Hòa'));
      await tester.pumpAndSettle();
      expect(
        find.byKey(const ValueKey('explore-operator-op-dl')),
        findsOneWidget,
      );
      expect(
        find.byKey(const ValueKey('explore-operator-op-pt')),
        findsNothing,
      );
      expect(find.text('Bộ lọc · 1'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'Xem chuyến của nhà xe mở kết quả riêng có chip nhà xe; quay lại về Nhà xe',
    (tester) async {
      final calls = <SearchCall>[];
      await _pumpTicket(
        tester,
        width: 412,
        height: 1000,
        initialQuery: sampleQuery,
        searchTrips: _recording(calls, (_) => samplePage([sampleTrip('t1')])),
        loadOperatorFare: _fares,
      );
      await tester.tap(find.byKey(const Key('ticket-mode-operator')));
      await tester.pumpAndSettle();

      await tester.tap(
        find.byKey(const ValueKey('explore-operator-op-pt-trips')),
      );
      await tester.pumpAndSettle();
      expect(find.text('Chuyến của Phương Trang'), findsOneWidget);
      await tester.tap(find.byKey(const Key('results-condition-apply')));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('trip-results-screen')), findsOneWidget);
      expect(calls.last.filters.operatorId, 'op-pt');
      expect(calls.last.query.from.id, 'hcm');
      expect(
        find.descendant(
          of: find.byKey(const ValueKey('results-chip-0')),
          matching: find.text('Phương Trang'),
        ),
        findsOneWidget,
      );
      expect(find.byKey(const Key('route-dock-tabbar')), findsNothing);

      await tester.tap(find.byKey(const Key('results-back')));
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('trip-results-screen')), findsNothing);
      expect(find.text('Nhà xe đang phục vụ'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('bấm thẻ nhà xe mở trang nhà xe, nút Xem chuyến vẫn giữ luồng cũ', (
    tester,
  ) async {
    HomeOperator? selected;
    await _pumpTicket(
      tester,
      width: 412,
      height: 1000,
      initialQuery: sampleQuery,
      searchTrips: _recording([], (_) => samplePage([sampleTrip('t1')])),
      loadOperatorFare: _fares,
      onOperatorSelected: (operator) => selected = operator,
    );
    await tester.tap(find.byKey(const Key('ticket-mode-operator')));
    await tester.pumpAndSettle();

    await tester.tap(
      find.byKey(const ValueKey('explore-operator-op-pt-trips')),
    );
    await tester.pumpAndSettle();
    expect(selected, isNull);
    expect(find.text('Chuyến của Phương Trang'), findsOneWidget);
    await tester.tapAt(const Offset(206, 20));
    await tester.pumpAndSettle();

    await tester.tap(
      find.byKey(const ValueKey('explore-operator-op-pt-profile')),
    );
    expect(selected?.id, 'op-pt');
    expect(tester.takeException(), isNull);
  });

  group('Chuyến của nhà xe', () {
    Future<void> pumpTrips(
      WidgetTester tester, {
      required TripBrowseRunner browseTrips,
      void Function(TripSummary, HomeSearchQuery?)? onTripSelected,
    }) async {
      tester.view.devicePixelRatio = 1;
      tester.view.physicalSize = const Size(412, 900);
      addTearDown(tester.view.resetDevicePixelRatio);
      addTearDown(tester.view.resetPhysicalSize);
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(fontFamily: 'Be Vietnam Pro'),
          home: OperatorTripsScreen(
            operatorId: 'op-pt',
            operatorName: 'Phương Trang',
            browseTrips: browseTrips,
            onTripSelected: onTripSelected,
          ),
        ),
      );
    }

    testWidgets('chỉ tải chuyến của nhà xe, bấm chuyến mở chi tiết', (
      tester,
    ) async {
      final filters = <TripSearchFilters>[];
      TripSummary? opened;
      await pumpTrips(
        tester,
        browseTrips: (value, page) async {
          filters.add(value);
          return samplePage([sampleTrip('t1')]);
        },
        onTripSelected: (trip, query) {
          opened = trip;
          expect(query, isNull);
        },
      );
      expect(find.byKey(const Key('operator-trips-loading')), findsOneWidget);
      await tester.pumpAndSettle();

      expect(filters.single.operatorId, 'op-pt');
      expect(find.text('Chuyến của Phương Trang'), findsOneWidget);
      await tester.tap(find.byKey(const ValueKey('operator-trip-t1')));
      expect(opened?.tripId, 't1');
      expect(tester.takeException(), isNull);
    });

    testWidgets('chưa có chuyến thì báo trống; lỗi thì thử lại được', (
      tester,
    ) async {
      var calls = 0;
      await pumpTrips(
        tester,
        browseTrips: (_, _) async {
          calls++;
          if (calls == 1) {
            throw const ApiFailure(status: 0, code: 'NETWORK', detail: 'x');
          }
          return samplePage(const []);
        },
      );
      await tester.pumpAndSettle();
      expect(find.text('Thử lại'), findsOneWidget);

      await tester.tap(find.text('Thử lại'));
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('operator-trips-empty')), findsOneWidget);
    });
  });
}
