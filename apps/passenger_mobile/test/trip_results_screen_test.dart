import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_shared/mobile_shared.dart';
import 'package:passenger_mobile/features/home/home_models.dart';
import 'package:passenger_mobile/features/search/trip_search_form.dart';
import 'package:passenger_mobile/features/ticket/ticket_screen.dart';
import 'package:passenger_mobile/features/ticket/trip_search_models.dart';

import 'support/trip_search_fakes.dart';

/// Ngày đi cách hôm nay vài ngày để dải 5 ngày luôn có ngày đang chọn ở giữa.
DateTime _inDays(int days) {
  final now = DateTime.now();
  return DateTime(now.year, now.month, now.day + days);
}

HomeSearchQuery _query({
  DateTime? date,
  int passengers = 1,
  HomeSearchMode mode = HomeSearchMode.route,
  HomeOperator? operator,
}) {
  return HomeSearchQuery(
    mode: mode,
    from: hcm,
    to: lamDong,
    date: date ?? _inDays(3),
    passengers: passengers,
    operator: operator,
  );
}

String _dayLabel(DateTime day) => formatSearchDate(day).substring(0, 5);

Future<void> _pumpResults(
  WidgetTester tester, {
  required double width,
  double height = 900,
  double textScale = 1,
  HomeSearchQuery? query,
  TripSearchRunner? searchTrips,
  TripSearchFilters initialFilters = const TripSearchFilters(),
  String? operatorName,
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
      home: TripResultsScreen(
        query: query ?? _query(),
        searchCatalog: fakeCatalog(),
        searchTrips: searchTrips,
        initialFilters: initialFilters,
        operatorName: operatorName,
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
  testWidgets(
    'responsive: thanh công cụ nổi thay thanh 5 mục, không overflow',
    (tester) async {
      for (final width in <double>[320, 360, 375, 390, 412, 430, 480]) {
        await _pumpResults(
          tester,
          width: width,
          height: 720,
          searchTrips: (_, _, _) async => samplePage([sampleTrip('t1')]),
        );
        expect(find.byKey(const Key('trip-results-screen')), findsOneWidget);
        expect(find.byKey(const Key('results-floating-tools')), findsOneWidget);
        expect(find.byKey(const Key('route-dock-tabbar')), findsNothing);
        expect(tester.takeException(), isNull, reason: 'viewport $width dp');
      }
    },
  );

  testWidgets(
    'tóm tắt hành trình, dải ngày, số chuyến, thẻ chuyến, cuối danh sách',
    (tester) async {
      final day = _inDays(3);
      final calls = <SearchCall>[];
      await _pumpResults(
        tester,
        width: 412,
        height: 1400,
        query: _query(date: day),
        searchTrips: _recording(
          calls,
          (_) => samplePage([sampleTrip('t1'), sampleTrip('t2')]),
        ),
      );

      expect(calls.single.page, 1);
      expect(calls.single.query.date, day);
      expect(find.text('Chọn chuyến'), findsOneWidget);
      final summary = find.byKey(const Key('results-summary'));
      for (final text in ['TP.HCM', 'Lâm Đồng', '1 khách', '6h30']) {
        expect(
          find.descendant(of: summary, matching: find.text(text)),
          findsOneWidget,
          reason: text,
        );
      }
      expect(
        find.text('${formatVnWeekday(day)}, ${formatSearchDate(day)}'),
        findsOneWidget,
      );
      for (var offset = -2; offset <= 2; offset++) {
        expect(
          find.byKey(
            ValueKey('results-date-${_dayLabel(_inDays(3 + offset))}'),
          ),
          findsOneWidget,
        );
      }
      expect(find.text('2 chuyến phù hợp'), findsOneWidget);
      expect(find.byKey(const ValueKey('results-trip-t1')), findsOneWidget);
      expect(find.byKey(const Key('results-end')), findsOneWidget);
      expect(find.text('Lọc'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('đang tải, lỗi có nút Thử lại, rỗng có lời nhắn', (tester) async {
    final pending = Completer<TripSearchPage>();
    var attempt = 0;
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(412, 900);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.view.resetPhysicalSize);
    await tester.pumpWidget(
      MaterialApp(
        home: TripResultsScreen(
          query: _query(),
          searchCatalog: fakeCatalog(),
          searchTrips: (_, _, _) {
            attempt++;
            if (attempt == 1) return pending.future;
            return Future.value(samplePage(const []));
          },
        ),
      ),
    );
    await tester.pump();
    expect(find.byKey(const Key('results-loading')), findsOneWidget);

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
    expect(find.byKey(const Key('results-empty')), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'Lọc ở thanh nổi: gửi tham số BR-77, nút đếm điều kiện, chip gỡ được',
    (tester) async {
      final calls = <SearchCall>[];
      await _pumpResults(
        tester,
        width: 390,
        searchTrips: _recording(calls, (_) => samplePage([sampleTrip('t1')])),
      );

      await tester.tap(find.byKey(const Key('results-filter')));
      await tester.pumpAndSettle();
      expect(find.text('Lọc chuyến'), findsOneWidget);
      await tester.tap(
        find.byKey(const ValueKey('ticket-filter-form-sleeper')),
      );
      await tester.tap(
        find.byKey(const ValueKey('ticket-filter-class-limousine')),
      );
      await tester.tap(
        find.byKey(const ValueKey('ticket-filter-slot-morning')),
      );
      await tester.pump();
      await tester.tap(find.byKey(const Key('ticket-filter-apply')));
      await tester.pumpAndSettle();

      final filters = calls.last.filters;
      expect(filters.vehicleForm, TripVehicleForm.sleeper);
      expect(filters.vehicleClass, TripVehicleClass.limousine);
      expect(filters.departureSlot, TripDepartureSlot.morning);
      expect(find.text('Lọc · 3'), findsOneWidget);
      expect(find.text('Limousine'), findsOneWidget);

      await tester.tap(find.text('Limousine'));
      await tester.pumpAndSettle();
      expect(calls.last.filters.vehicleClass, isNull);
      expect(calls.last.filters.vehicleForm, TripVehicleForm.sleeper);
      expect(find.text('Lọc · 2'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('Sắp xếp: chọn trong sheet rồi Áp dụng mới tìm lại', (
    tester,
  ) async {
    final calls = <SearchCall>[];
    await _pumpResults(
      tester,
      width: 390,
      searchTrips: _recording(calls, (_) => samplePage([sampleTrip('t1')])),
    );

    await tester.tap(find.byKey(const Key('results-sort')));
    await tester.pumpAndSettle();
    expect(find.text('Sắp xếp chuyến'), findsOneWidget);
    expect(find.text('Đánh giá cao nhất'), findsNothing);
    await tester.tap(find.byKey(const ValueKey('results-sort-price')));
    await tester.pump();
    expect(calls, hasLength(1));
    await tester.tap(find.byKey(const Key('results-sort-apply')));
    await tester.pumpAndSettle();

    expect(calls.last.filters.sort, TripSearchSort.price);
    expect(find.text('Giá từ thấp đến cao'), findsOneWidget);
  });

  testWidgets(
    'Đổi ngày ở sheet và bấm ô ở dải ngày đều tìm lại theo ngày mới',
    (tester) async {
      final calls = <SearchCall>[];
      await _pumpResults(
        tester,
        width: 412,
        searchTrips: _recording(calls, (_) => samplePage([sampleTrip('t1')])),
      );

      await tester.tap(find.byKey(const Key('results-change-date')));
      await tester.pumpAndSettle();
      expect(find.text('Chọn ngày đi'), findsOneWidget);
      final nextDay = _inDays(4);
      await tester.tap(
        find.descendant(
          of: find.byKey(const Key('results-date-sheet-strip')),
          matching: find.byKey(ValueKey('results-date-${_dayLabel(nextDay)}')),
        ),
      );
      await tester.pump();
      expect(
        find.text('${formatVnWeekday(nextDay)}, ${formatSearchDate(nextDay)}'),
        findsWidgets,
      );
      await tester.tap(find.byKey(const Key('results-date-apply')));
      await tester.pumpAndSettle();
      expect(calls.last.query.date, nextDay);

      final earlier = _inDays(3);
      await tester.tap(
        find.byKey(ValueKey('results-date-${_dayLabel(earlier)}')),
      );
      await tester.pumpAndSettle();
      expect(calls.last.query.date, earlier);
      expect(calls, hasLength(3));
    },
  );

  testWidgets('Sửa tìm kiếm: đổi số khách rồi Cập nhật kết quả', (
    tester,
  ) async {
    final calls = <SearchCall>[];
    await _pumpResults(
      tester,
      width: 412,
      searchTrips: _recording(calls, (_) => samplePage([sampleTrip('t1')])),
    );

    await tester.tap(find.byKey(const Key('results-edit-search')));
    await tester.pumpAndSettle();
    expect(find.text('Sửa tìm kiếm'), findsOneWidget);
    await tester.tap(find.byKey(const Key('ticket-passenger-input')));
    await tester.pumpAndSettle();
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();
    await tester.tap(find.text('Xác nhận'));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('results-condition-apply')));
    await tester.pumpAndSettle();

    expect(calls.last.query.passengers, 2);
    expect(
      find.descendant(
        of: find.byKey(const Key('results-summary')),
        matching: find.text('2 khách'),
      ),
      findsOneWidget,
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('cuộn gần cuối thì tải trang tiếp theo', (tester) async {
    final calls = <SearchCall>[];
    await _pumpResults(
      tester,
      width: 390,
      height: 800,
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
    expect(find.byKey(const Key('results-end')), findsNothing);
    await tester.drag(
      find.byKey(const Key('trip-results-scroll')),
      const Offset(0, -3000),
    );
    await tester.pumpAndSettle();
    expect(calls.map((call) => call.page), [1, 2]);
    await tester.drag(
      find.byKey(const Key('trip-results-scroll')),
      const Offset(0, -3000),
    );
    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey('results-trip-t5')), findsOneWidget);
    expect(find.byKey(const Key('results-end')), findsOneWidget);
    expect(calls, hasLength(2));
  });

  testWidgets(
    'lọc sẵn một nhà xe: chip tên nhà xe, gỡ chip thì tìm mọi nhà xe',
    (tester) async {
      final calls = <SearchCall>[];
      await _pumpResults(
        tester,
        width: 412,
        initialFilters: const TripSearchFilters(operatorId: 'op-pt'),
        operatorName: 'Phương Trang',
        searchTrips: _recording(calls, (_) => samplePage([sampleTrip('t1')])),
      );

      expect(calls.single.filters.operatorId, 'op-pt');
      expect(find.text('Lọc · 1'), findsOneWidget);
      await tester.tap(find.byKey(const ValueKey('results-chip-0')));
      await tester.pumpAndSettle();
      expect(calls.last.filters.operatorId, isNull);
      expect(find.byKey(const ValueKey('results-chip-0')), findsNothing);
    },
  );

  testWidgets('tìm "Theo nhà xe" ở Trang chủ: nhà xe thành chip gỡ được', (
    tester,
  ) async {
    final calls = <SearchCall>[];
    await _pumpResults(
      tester,
      width: 412,
      query: _query(mode: HomeSearchMode.operator, operator: phuongTrang),
      searchTrips: _recording(calls, (_) => samplePage([sampleTrip('t1')])),
    );

    expect(calls.single.filters.operatorId, 'op-pt');
    expect(calls.single.query.mode, HomeSearchMode.route);
    expect(
      find.descendant(
        of: find.byKey(const ValueKey('results-chip-0')),
        matching: find.text('Phương Trang'),
      ),
      findsOneWidget,
    );
  });

  testWidgets('nút quay lại đóng màn Kết quả', (tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(412, 900);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.view.resetPhysicalSize);
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) => Scaffold(
            body: Center(
              child: TextButton(
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => TripResultsScreen(
                      query: _query(),
                      searchTrips: (_, _, _) async =>
                          samplePage([sampleTrip('t1')]),
                    ),
                  ),
                ),
                child: const Text('Mở kết quả'),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('Mở kết quả'));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('trip-results-screen')), findsOneWidget);

    await tester.tap(find.byKey(const Key('results-back')));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('trip-results-screen')), findsNothing);
    expect(find.text('Mở kết quả'), findsOneWidget);
  });

  testWidgets('bottom sheet bộ lọc cuộn và áp dụng không overflow', (
    tester,
  ) async {
    await _pumpResults(
      tester,
      width: 320,
      height: 568,
      textScale: 1.3,
      searchTrips: (_, _, _) async => samplePage([sampleTrip('t1')]),
    );

    await tester.tap(find.byKey(const Key('results-filter')));
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

    await tester.tap(find.byKey(const Key('ticket-filter-apply')));
    await tester.pumpAndSettle();
    expect(find.text('Lọc chuyến'), findsNothing);
    expect(tester.takeException(), isNull);
  });
}
