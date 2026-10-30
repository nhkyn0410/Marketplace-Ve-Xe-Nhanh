import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mobile_shared/mobile_shared.dart';
import 'package:passenger_mobile/features/home/home_models.dart';
import 'package:passenger_mobile/features/home/route_dock_tabbar.dart';
import 'package:passenger_mobile/features/search/trip_search_form.dart';
import 'package:passenger_mobile/features/ticket/trip_search_models.dart';

part 'trip_results_screen.dart';

const _assetRoot = 'assets/ticket';
const _resultsAssetRoot = 'assets/ticket/results';
const _homeAssetRoot = 'assets/home';
const _primary = Color(0xFF2B7EAD);
const _primaryDark = Color(0xFF09243D);
const _primarySoft = Color(0xFFEBF5FB);
const _secondary = Color(0xFF607A8E);
const _chipBorder = Color(0xFF95C8E8);
const _pageBackground = Color(0xFFEFFAFF);

/// Giá vé thấp nhất của một nhà xe trên một tuyến vào ngày đi; `null` khi ngày
/// đó nhà xe không có chuyến mở bán.
typedef OperatorFareLoader = Future<int?> Function(
  String operatorId,
  HomeOperatorRoute route,
  DateTime date,
);

/// Tab Mua vé: khám phá chuyến xe đang mở bán và nhà xe (Figma "Mua vé ·
/// Khám phá"). Chọn chuyến theo điều kiện đã nhập nằm ở [TripResultsScreen].
class TicketScreen extends StatefulWidget {
  const TicketScreen({
    required this.onTabSelected,
    this.searchCatalog,
    this.searchTrips,
    this.browseTrips,
    this.loadOperatorFare,
    this.initialQuery,
    this.loadDefaultQuery,
    this.onQueryChanged,
    this.onTripSelected,
    super.key,
  });

  final ValueChanged<int> onTabSelected;
  final TripSearchCatalog? searchCatalog;
  final TripSearchRunner? searchTrips;

  /// Chưa có điều kiện tìm: xem mọi chuyến sắp chạy, không cần nhập điểm đi /
  /// đến hay ngày (ưu tiên hơn [loadDefaultQuery]).
  final TripBrowseRunner? browseTrips;
  final OperatorFareLoader? loadOperatorFare;

  /// Bấm một chuyến trong danh sách (mở chi tiết chuyến); `query` = `null` khi
  /// đang xem chuyến sắp chạy.
  final void Function(TripSummary trip, HomeSearchQuery? query)? onTripSelected;

  /// Điều kiện lần tìm trước (Trang chủ / lần khám phá trước): ngày, số khách,
  /// điểm đi – đến của chế độ Chuyến xe.
  final HomeSearchQuery? initialQuery;

  /// Điều kiện mặc định khi chưa có [initialQuery]; trả `null` thì chờ người
  /// dùng chọn điểm đi, điểm đến.
  final Future<HomeSearchQuery?> Function()? loadDefaultQuery;

  /// Báo điều kiện vừa đổi để giữ lại khi rời tab.
  final ValueChanged<HomeSearchQuery>? onQueryChanged;

  @override
  State<TicketScreen> createState() => _TicketScreenState();
}

class _TicketScreenState extends State<TicketScreen>
    with TripSearchFormState<TicketScreen> {
  final _scrollController = ScrollController();
  bool _dockVisible = true;

  /// `route` = chế độ Chuyến xe, `operator` = chế độ Nhà xe.
  HomeSearchMode _mode = HomeSearchMode.route;

  HomeSearchQuery? _query;

  /// Đang xem chuyến sắp chạy (chưa có điểm đi / đến) — [_query] là `null`.
  bool _browsing = false;
  TripSearchFilters _filters = const TripSearchFilters();
  TripSearchPage? _page;
  List<TripSummary> _trips = const [];
  bool _loading = false;
  bool _loadingMore = false;
  String? _error;
  int _request = 0;

  Future<List<HomeOperator>>? _operators;
  HomeLocation? _operatorArea;
  HomeOperatorRoute? _operatorRoute;
  final _fares = <String, Future<int?>>{};

  @override
  TripSearchCatalog? get searchCatalog => widget.searchCatalog;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_maybeLoadMore);
    final query = widget.initialQuery;
    if (query != null) {
      _applyContext(query);
      _search(_contextQuery()!);
    } else if (widget.browseTrips != null) {
      _browse();
    } else {
      _loadDefaultContext();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tripsMode = _mode == HomeSearchMode.route;
    return Scaffold(
      key: const Key('ticket-screen'),
      extendBody: true,
      backgroundColor: _pageBackground,
      bottomNavigationBar: RouteDockTabBar(
        currentIndex: 1,
        onTap: widget.onTabSelected,
        visible: _dockVisible,
        slideKey: const Key('ticket-bottom-dock-animation'),
      ),
      body: TabEntrance(
        statusBarColor: _pageBackground,
        child: AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle.dark.copyWith(
            statusBarColor: Colors.transparent,
            systemNavigationBarColor: _pageBackground,
          ),
          child: DecoratedBox(
            decoration: const BoxDecoration(color: _pageBackground),
            // Header tự chừa thanh trạng thái để ảnh nền tràn lên sau nó.
            child: SafeArea(
              top: false,
              bottom: false,
              child: NotificationListener<UserScrollNotification>(
                onNotification: _handleUserScroll,
                child: CustomScrollView(
                  key: const Key('ticket-content-scroll'),
                  controller: _scrollController,
                  slivers: [
                    SliverToBoxAdapter(
                      child: _ExploreHeader(
                        mode: _mode,
                        onModeChanged: _selectMode,
                      ),
                    ),
                    SliverPadding(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                      sliver: SliverToBoxAdapter(
                        child: tripsMode ? _tripChips() : _operatorChips(),
                      ),
                    ),
                    SliverPadding(
                      padding: const EdgeInsets.fromLTRB(15, 20, 15, 16),
                      sliver: SliverToBoxAdapter(
                        child: _ExploreListHeading(
                          title: tripsMode
                              ? 'Chuyến đang mở bán'
                              : 'Nhà xe đang phục vụ',
                          trailing: tripsMode
                              ? 'Giờ đi sớm nhất'
                              : 'Đánh giá cao',
                        ),
                      ),
                    ),
                    if (tripsMode) ..._tripSlivers() else _operatorSliver(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _tripChips() {
    final filterCount = _filters.activeCount;
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _ExploreChip(
                key: const Key('explore-date-chip'),
                label: formatSearchDate(searchDate),
                onTap: () => _editContext(pickSearchDate),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _ExploreChip(
                key: const Key('explore-passenger-chip'),
                label: '$searchPassengers khách',
                onTap: () => _editContext(pickSearchPassengers),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        _quickFilterRow(
          _ExploreChip(
            key: const Key('explore-origin-chip'),
            label: _compactPlace(searchFrom?.name ?? 'Điểm đi'),
            onTap: () => _editContext(() => pickSearchLocation(isOrigin: true)),
          ),
          _ExploreChip(
            key: const Key('explore-destination-chip'),
            label: _compactPlace(searchTo?.name ?? 'Điểm đến'),
            onTap: () =>
                _editContext(() => pickSearchLocation(isOrigin: false)),
          ),
          _ExploreChip(
            key: const Key('explore-filter-chip'),
            label: filterCount == 0 ? 'Bộ lọc' : 'Bộ lọc · $filterCount',
            onTap: _openFilters,
          ),
        ),
      ],
    );
  }

  Widget _operatorChips() {
    final filterCount =
        (_operatorArea == null ? 0 : 1) + (_operatorRoute == null ? 0 : 1);
    return _quickFilterRow(
      _ExploreChip(
        key: const Key('explore-area-chip'),
        label: _compactPlace(_operatorArea?.name ?? 'Khu vực'),
        onTap: _pickOperatorArea,
      ),
      _ExploreChip(
        key: const Key('explore-route-chip'),
        label: _operatorRoute == null
            ? 'Tuyến phục vụ'
            : _routeLabel(_operatorRoute!),
        onTap: _pickOperatorRoute,
      ),
      _ExploreChip(
        key: const Key('explore-operator-filter-chip'),
        label: filterCount == 0 ? 'Bộ lọc' : 'Bộ lọc · $filterCount',
        onTap: _openOperatorFilters,
      ),
    );
  }

  /// Hàng chip lọc nhanh theo Figma: 128 · 128 · 108, cách nhau 8.
  Widget _quickFilterRow(Widget first, Widget second, Widget filter) {
    return Row(
      children: [
        Expanded(flex: 32, child: first),
        const SizedBox(width: 8),
        Expanded(flex: 32, child: second),
        const SizedBox(width: 8),
        Expanded(flex: 27, child: filter),
      ],
    );
  }

  List<Widget> _tripSlivers() {
    final query = _query;
    if (_loading) {
      return const [
        SliverPadding(
          padding: EdgeInsets.only(top: 32, bottom: 142),
          sliver: SliverToBoxAdapter(
            child: Center(
              child: CircularProgressIndicator(key: Key('ticket-loading')),
            ),
          ),
        ),
      ];
    }
    final error = _error;
    if (error != null) {
      return [
        _messageSliver(
          _ResultMessage(
            icon: Icons.wifi_off_outlined,
            message: error,
            actionLabel: 'Thử lại',
            onAction: query != null
                ? () => _search(query)
                : _browsing
                ? _browse
                : _loadDefaultContext,
          ),
        ),
      ];
    }
    if (query == null && !_browsing) {
      return [
        _messageSliver(
          const _ResultMessage(
            key: Key('ticket-pick-route'),
            icon: Icons.travel_explore,
            message: 'Chọn điểm đi và điểm đến để xem chuyến đang mở bán.',
          ),
        ),
      ];
    }
    if (_trips.isEmpty) {
      final filtered = _filters.activeCount > 0;
      return [
        _messageSliver(
          _ResultMessage(
            key: const Key('ticket-empty'),
            icon: Icons.directions_bus_outlined,
            message: filtered
                ? 'Không có chuyến khớp bộ lọc. Hãy bỏ bớt bộ lọc.'
                : _browsing
                ? 'Chưa có chuyến sắp chạy trong 14 ngày tới.'
                : 'Chưa có chuyến phù hợp. Hãy thử ngày khác hoặc địa điểm khác.',
            actionLabel: filtered ? 'Bỏ lọc' : null,
            onAction: filtered ? () => _applyFilters(_filters.cleared()) : null,
          ),
        ),
      ];
    }
    return [
      if (_browsing)
        _messageSliver(
          const Padding(
            key: Key('ticket-browse-hint'),
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: Text(
              'Chuyến sắp chạy của mọi tuyến trong 14 ngày tới. Chọn điểm đi, điểm đến để tìm đúng chuyến.',
              style: TextStyle(color: Color(0xFF607A8E), fontSize: 13),
            ),
          ),
        ),
      ..._widenedSlivers(_page),
      SliverPadding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        sliver: SliverList.separated(
          itemBuilder: (context, index) {
            final trip = _trips[index];
            return _TripCard(
              key: ValueKey('ticket-trip-${trip.tripId}'),
              trip: trip,
              fromLabel: query?.from.name ?? trip.pickup.name,
              toLabel: query?.to.name ?? trip.dropoff.name,
              // Danh sách sắp chạy gồm nhiều ngày: ghi ngày đi trên thẻ.
              dateLabel: _browsing ? formatVnDate(trip.pickup.plannedAt) : null,
              onOpenDetail: () => widget.onTripSelected?.call(trip, query),
            );
          },
          separatorBuilder: (context, index) => const SizedBox(height: 14),
          itemCount: _trips.length,
        ),
      ),
      SliverPadding(
        padding: const EdgeInsets.only(top: 14, bottom: 142),
        sliver: SliverToBoxAdapter(
          child: _loadingMore
              ? const Center(
                  child: SizedBox.square(
                    dimension: 26,
                    child: CircularProgressIndicator(strokeWidth: 2.6),
                  ),
                )
              : const SizedBox.shrink(),
        ),
      ),
    ];
  }

  Widget _operatorSliver() {
    return FutureBuilder<List<HomeOperator>>(
      future: _operators,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const SliverPadding(
            padding: EdgeInsets.only(top: 32, bottom: 142),
            sliver: SliverToBoxAdapter(
              child: Center(
                child: CircularProgressIndicator(
                  key: Key('explore-operators-loading'),
                ),
              ),
            ),
          );
        }
        if (snapshot.hasError) {
          return _messageSliver(
            _ResultMessage(
              icon: Icons.wifi_off_outlined,
              message: 'Không tải được danh sách nhà xe. Vui lòng thử lại.',
              actionLabel: 'Thử lại',
              onAction: () => setState(() => _operators = _loadOperators()),
            ),
          );
        }
        final area = _operatorArea;
        final route = _operatorRoute;
        final filtered = area != null || route != null;
        final operators = _rankOperators([
          for (final operator in snapshot.data ?? const <HomeOperator>[])
            if (!filtered || _servedRoute(operator, area, route) != null)
              operator,
        ]);
        if (operators.isEmpty) {
          return _messageSliver(
            _ResultMessage(
              key: const Key('explore-operators-empty'),
              icon: Icons.apartment_outlined,
              message: filtered
                  ? 'Chưa có nhà xe phục vụ khu vực, tuyến đã chọn.'
                  : 'Chưa có nhà xe đang mở bán.',
              actionLabel: filtered ? 'Bỏ lọc' : null,
              onAction: filtered ? () => _setOperatorFilters(null, null) : null,
            ),
          );
        }
        return SliverPadding(
          padding: const EdgeInsets.fromLTRB(15, 0, 15, 142),
          sliver: SliverList.separated(
            itemCount: operators.length,
            separatorBuilder: (context, index) => const SizedBox(height: 16),
            itemBuilder: (context, index) {
              final operator = operators[index];
              final served = _servedRoute(operator, area, route);
              return _OperatorCard(
                key: ValueKey('explore-operator-${operator.id}'),
                operator: operator,
                route: served,
                fare: served == null ? null : _fareFor(operator, served),
                date: searchDate,
                onViewTrips: served == null
                    ? null
                    : () => _openOperatorTrips(operator, served),
              );
            },
          ),
        );
      },
    );
  }

  bool _handleUserScroll(UserScrollNotification notification) {
    if (notification.metrics.axis != Axis.vertical) return false;
    final shouldShow = switch (notification.direction) {
      ScrollDirection.forward => true,
      ScrollDirection.reverse => false,
      ScrollDirection.idle => notification.metrics.pixels <= 0 || _dockVisible,
    };
    if (shouldShow != _dockVisible && mounted) {
      setState(() => _dockVisible = shouldShow);
    }
    return false;
  }

  /// Ngày, số khách, điểm đi – đến của chế độ Chuyến xe (lần tìm theo nhà xe
  /// thì giữ tuyến, bỏ nhà xe).
  void _applyContext(HomeSearchQuery query) {
    searchMode = HomeSearchMode.route;
    searchFrom = query.from;
    searchTo = query.to;
    searchDate = query.date;
    searchPassengers = query.passengers;
  }

  /// Điều kiện theo các chip; chưa có điểm đi hoặc điểm đến thì `null`.
  HomeSearchQuery? _contextQuery() {
    final from = searchFrom;
    final to = searchTo;
    if (from == null || to == null) return null;
    return HomeSearchQuery(
      mode: HomeSearchMode.route,
      from: from,
      to: to,
      date: searchDate,
      passengers: searchPassengers,
    );
  }

  Future<void> _loadDefaultContext() async {
    final loader = widget.loadDefaultQuery;
    if (loader == null) return;
    final request = ++_request;
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final query = await loader();
      if (!mounted || request != _request) return;
      if (query == null) {
        setState(() => _loading = false);
        return;
      }
      setState(() => _applyContext(query));
      await _search(query);
    } catch (_) {
      if (!mounted || request != _request) return;
      setState(() {
        _loading = false;
        _error = 'Không tải được danh sách chuyến. Vui lòng thử lại.';
      });
    }
  }

  /// Mở ô chọn của một chip (ngày, số khách, điểm đi / đến); điều kiện đổi thì
  /// tải lại danh sách chuyến.
  Future<void> _editContext(Future<void> Function() pick) async {
    final before = _contextQuery();
    await pick();
    if (!mounted) return;
    final query = _contextQuery();
    if (query == null || _sameContext(before, query)) return;
    if (query.from.id == query.to.id && query.from.kind == query.to.kind) {
      showSearchMessage('Điểm đi và điểm đến phải khác nhau.');
      return;
    }
    widget.onQueryChanged?.call(query);
    _search(query);
  }

  bool _sameContext(HomeSearchQuery? a, HomeSearchQuery b) =>
      a != null &&
      a.from.id == b.from.id &&
      a.to.id == b.to.id &&
      a.date == b.date &&
      a.passengers == b.passengers;

  /// Xem mọi chuyến sắp chạy (chưa có điểm đi / đến).
  Future<void> _browse() async {
    final runner = widget.browseTrips;
    if (runner == null) return;
    final request = ++_request;
    setState(() {
      _query = null;
      _browsing = true;
      _loading = true;
      _loadingMore = false;
      _error = null;
      _trips = const [];
    });
    try {
      final page = await runner(_filters, 1);
      if (!mounted || request != _request) return;
      setState(() {
        _page = page;
        _trips = page.items;
        _loading = false;
      });
    } catch (error) {
      if (!mounted || request != _request) return;
      setState(() {
        _loading = false;
        _error = _describeSearchError(error);
      });
    }
  }

  Future<void> _search(HomeSearchQuery query) async {
    final runner = widget.searchTrips;
    if (runner == null) {
      showSearchMessage('Tìm chuyến hiện chưa khả dụng.');
      return;
    }
    final request = ++_request;
    setState(() {
      _query = query;
      _browsing = false;
      _loading = true;
      _loadingMore = false;
      _error = null;
      _trips = const [];
    });
    try {
      final page = await runner(query, _filters, 1);
      if (!mounted || request != _request) return;
      setState(() {
        _page = page;
        _trips = page.items;
        _loading = false;
      });
    } catch (error) {
      if (!mounted || request != _request) return;
      setState(() {
        _loading = false;
        _error = _describeSearchError(error);
      });
    }
  }

  Future<void> _maybeLoadMore() async {
    final query = _query;
    final page = _page;
    final runner = widget.searchTrips;
    final browse = widget.browseTrips;
    if (_mode != HomeSearchMode.route ||
        (query == null && !(_browsing && browse != null)) ||
        page == null ||
        (query != null && runner == null) ||
        !page.hasMore ||
        _loading ||
        _loadingMore ||
        !_scrollController.hasClients) {
      return;
    }
    final position = _scrollController.position;
    if (position.pixels < position.maxScrollExtent - 400) return;
    final request = _request;
    setState(() => _loadingMore = true);
    try {
      final next = query != null
          ? await runner!(query, _filters, page.page + 1)
          : await browse!(_filters, page.page + 1);
      if (!mounted || request != _request) return;
      setState(() {
        _page = next;
        _trips = [..._trips, ...next.items];
        _loadingMore = false;
      });
    } catch (_) {
      if (!mounted || request != _request) return;
      setState(() => _loadingMore = false);
      showSearchMessage('Không tải thêm được chuyến. Vui lòng thử lại.');
    }
  }

  void _applyFilters(TripSearchFilters filters) {
    setState(() => _filters = filters);
    final query = _query;
    if (query != null) {
      _search(query);
    } else if (_browsing) {
      _browse();
    }
  }

  Future<void> _openFilters() async {
    final result = await showModalBottomSheet<TripSearchFilters>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      barrierColor: const Color(0x66102632),
      builder: (context) => _TripFilterSheet(
        initial: _filters,
        operators: _page?.operators ?? const [],
        priceMin: _page?.priceMin,
        priceMax: _page?.priceMax,
        loadAmenities: widget.searchCatalog?.loadAmenities,
      ),
    );
    if (result != null && mounted) _applyFilters(result);
  }

  void _selectMode(HomeSearchMode mode) {
    if (mode == _mode) return;
    setState(() {
      _mode = mode;
      if (mode == HomeSearchMode.operator) _operators ??= _loadOperators();
    });
  }

  Future<List<HomeOperator>> _loadOperators() {
    final catalog = widget.searchCatalog;
    if (catalog == null) {
      return Future.error(StateError('Danh sách nhà xe chưa khả dụng.'));
    }
    return catalog.loadOperators();
  }

  Future<List<HomeOperator>?> _operatorsOrNull() async {
    try {
      return await (_operators ??= _loadOperators());
    } catch (_) {
      showSearchMessage('Không tải được danh sách nhà xe. Vui lòng thử lại.');
      return null;
    }
  }

  Future<void> _pickOperatorArea() async {
    final operators = await _operatorsOrNull();
    if (operators == null || !mounted) return;
    final picked = await _pickArea(context, operators, _operatorArea);
    if (picked == null || !mounted) return;
    _setOperatorFilters(picked.$1, _operatorRoute);
  }

  Future<void> _pickOperatorRoute() async {
    final operators = await _operatorsOrNull();
    if (operators == null || !mounted) return;
    final picked = await _pickServedRoute(
      context,
      operators,
      _operatorArea,
      _operatorRoute,
    );
    if (picked == null || !mounted) return;
    _setOperatorFilters(_operatorArea, picked.$1);
  }

  Future<void> _openOperatorFilters() async {
    final operators = await _operatorsOrNull();
    if (operators == null || !mounted) return;
    final picked =
        await showModalBottomSheet<(HomeLocation?, HomeOperatorRoute?)>(
          context: context,
          isScrollControlled: true,
          useSafeArea: true,
          backgroundColor: Colors.transparent,
          builder: (context) => _OperatorFilterSheet(
            operators: operators,
            area: _operatorArea,
            route: _operatorRoute,
          ),
        );
    if (picked == null || !mounted) return;
    _setOperatorFilters(picked.$1, picked.$2);
  }

  /// Tuyến không đi qua khu vực mới chọn thì bỏ lọc tuyến.
  void _setOperatorFilters(HomeLocation? area, HomeOperatorRoute? route) {
    setState(() {
      _operatorArea = area;
      _operatorRoute =
          route != null && area != null && !_routeTouches(route, area)
          ? null
          : route;
    });
  }

  Future<int?>? _fareFor(HomeOperator operator, HomeOperatorRoute route) {
    final loader = widget.loadOperatorFare;
    if (loader == null) return null;
    final date = searchDate;
    final key =
        '${operator.id}|${route.from.id}|${route.to.id}|${formatSearchDate(date)}';
    return _fares.putIfAbsent(
      key,
      () => loader(
        operator.id,
        route,
        date,
      ).then<int?>((price) => price, onError: (_) => null),
    );
  }

  /// Nhánh khám phá theo nhà xe: chọn điều kiện hành trình rồi mở kết quả
  /// riêng của nhà xe; quay lại thì về đúng danh sách nhà xe đang xem.
  Future<void> _openOperatorTrips(
    HomeOperator operator,
    HomeOperatorRoute route,
  ) async {
    final query = await showModalBottomSheet<HomeSearchQuery>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _SearchConditionSheet(
        title: 'Chuyến của ${operator.name}',
        actionLabel: 'Xem chuyến ${operator.name}',
        catalog: widget.searchCatalog,
        initial: HomeSearchQuery(
          mode: HomeSearchMode.route,
          from: route.from,
          to: route.to,
          date: searchDate,
          passengers: searchPassengers,
        ),
      ),
    );
    if (query == null || !mounted) return;
    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => TripResultsScreen(
          query: query,
          searchTrips: widget.searchTrips,
          searchCatalog: widget.searchCatalog,
          onTripSelected: widget.onTripSelected,
          initialFilters: TripSearchFilters(operatorId: operator.id),
          operatorName: operator.name,
        ),
      ),
    );
  }
}

/// Nhà xe đánh giá cao trước; cùng điểm thì nhiều lượt đánh giá trước.
List<HomeOperator> _rankOperators(List<HomeOperator> operators) {
  return [...operators]..sort((a, b) {
    final byRating = (b.averageRating ?? -1).compareTo(a.averageRating ?? -1);
    return byRating != 0 ? byRating : b.reviewCount.compareTo(a.reviewCount);
  });
}

bool _routeTouches(HomeOperatorRoute route, HomeLocation area) =>
    route.from.id == area.id || route.to.id == area.id;

bool _sameRoute(HomeOperatorRoute a, HomeOperatorRoute b) =>
    a.from.id == b.from.id && a.to.id == b.to.id;

/// Tuyến đầu tiên của nhà xe khớp khu vực + tuyến đang lọc; không khớp thì
/// `null`. Không lọc gì thì là tuyến đầu tiên của nhà xe.
HomeOperatorRoute? _servedRoute(
  HomeOperator operator,
  HomeLocation? area,
  HomeOperatorRoute? route,
) {
  for (final item in operator.routes) {
    if (area != null && !_routeTouches(item, area)) continue;
    if (route != null && !_sameRoute(item, route)) continue;
    return item;
  }
  return null;
}

/// Khu vực = các tỉnh có tuyến của nhà xe đang mở bán. Trả `(null,)` khi chọn
/// "Tất cả khu vực", `null` khi đóng sheet.
Future<(HomeLocation?,)?> _pickArea(
  BuildContext context,
  List<HomeOperator> operators,
  HomeLocation? selected,
) {
  final areas = <String, HomeLocation>{};
  for (final operator in operators) {
    for (final route in operator.routes) {
      areas.putIfAbsent(route.from.id, () => route.from);
      areas.putIfAbsent(route.to.id, () => route.to);
    }
  }
  final options = areas.values.toList()
    ..sort((a, b) => a.name.compareTo(b.name));
  return showModalBottomSheet<(HomeLocation?,)>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: Colors.transparent,
    builder: (context) => _ChoiceSheet<HomeLocation>(
      title: 'Khu vực',
      allLabel: 'Tất cả khu vực',
      options: options,
      selected: selected,
      labelOf: (area) => area.name,
      isSame: (a, b) => a.id == b.id,
    ),
  );
}

/// Tuyến phục vụ = các tuyến của nhà xe đang mở bán, chỉ tuyến đi qua khu vực
/// đang chọn. Trả `(null,)` khi chọn "Tất cả tuyến", `null` khi đóng sheet.
Future<(HomeOperatorRoute?,)?> _pickServedRoute(
  BuildContext context,
  List<HomeOperator> operators,
  HomeLocation? area,
  HomeOperatorRoute? selected,
) {
  final routes = <String, HomeOperatorRoute>{};
  for (final operator in operators) {
    for (final route in operator.routes) {
      if (area != null && !_routeTouches(route, area)) continue;
      routes.putIfAbsent('${route.from.id}>${route.to.id}', () => route);
    }
  }
  final options = routes.values.toList()
    ..sort((a, b) => _routeLabel(a).compareTo(_routeLabel(b)));
  return showModalBottomSheet<(HomeOperatorRoute?,)>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: Colors.transparent,
    builder: (context) => _ChoiceSheet<HomeOperatorRoute>(
      title: 'Tuyến phục vụ',
      allLabel: 'Tất cả tuyến',
      options: options,
      selected: selected,
      labelOf: _routeLabel,
      isSame: _sameRoute,
    ),
  );
}

/// Ảnh nền, tiêu đề "Khám phá chuyến đi" và nút đổi chế độ Chuyến xe · Nhà xe.
class _ExploreHeader extends StatelessWidget {
  const _ExploreHeader({required this.mode, required this.onModeChanged});

  final HomeSearchMode mode;
  final ValueChanged<HomeSearchMode> onModeChanged;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          height: 190,
          child: Opacity(
            opacity: .78,
            child: Image.asset(
              '$_assetRoot/sky_globe_mountains.png',
              fit: BoxFit.cover,
              alignment: Alignment.centerRight,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(
            16,
            MediaQuery.paddingOf(context).top + 14,
            16,
            0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 4),
                child: Text(
                  'Khám phá chuyến đi',
                  key: Key('explore-title'),
                  style: TextStyle(
                    color: _primaryDark,
                    fontSize: 24,
                    height: 34 / 24,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 3),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 4),
                child: Text(
                  'Chuyến xe và nhà xe cho mọi hành trình',
                  style: TextStyle(
                    color: _secondary,
                    fontSize: 13,
                    height: 19 / 13,
                  ),
                ),
              ),
              const SizedBox(height: 11),
              _SearchModeControl(mode: mode, onChanged: onModeChanged),
            ],
          ),
        ),
      ],
    );
  }
}

/// Bộ lọc gọn của trang khám phá (Figma "Discovery / Filter chip").
class _ExploreChip extends StatelessWidget {
  const _ExploreChip({required this.label, required this.onTap, super.key});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44,
      child: Material(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          side: const BorderSide(color: _chipBorder),
          borderRadius: BorderRadius.circular(16),
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            // Figma để padding 12 nhưng nhãn dài như "Tuyến phục vụ" tràn vào
            // phần padding (nội dung căn giữa); 6 giữ nguyên nhãn ngắn và
            // thêm chỗ cho nhãn dài.
            padding: const EdgeInsets.symmetric(horizontal: 6),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Nhãn hơi dài (máy hẹp) thu nhỏ tối đa 15% thay vì bị cắt;
                // dài hơn nữa mới cắt "...".
                Flexible(
                  child: LayoutBuilder(
                    builder: (context, constraints) => FittedBox(
                      fit: BoxFit.scaleDown,
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          maxWidth: constraints.maxWidth / 0.85,
                        ),
                        child: Text(
                          label,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: _primaryDark,
                            fontSize: 13,
                            height: 19 / 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                SvgPicture.asset(
                  '$_resultsAssetRoot/chevron.svg',
                  width: 14,
                  height: 14,
                  excludeFromSemantics: true,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ExploreListHeading extends StatelessWidget {
  const _ExploreListHeading({required this.title, required this.trailing});

  final String title;
  final String trailing;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: _primaryDark,
              fontSize: 16,
              height: 24 / 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          trailing,
          style: const TextStyle(color: _secondary, fontSize: 12, height: 1.5),
        ),
      ],
    );
  }
}

/// Thẻ nhà xe (Figma "Discovery / Operator card").
class _OperatorCard extends StatelessWidget {
  const _OperatorCard({
    required this.operator,
    required this.route,
    required this.fare,
    required this.date,
    required this.onViewTrips,
    super.key,
  });

  final HomeOperator operator;

  /// Tuyến hiển thị (khớp bộ lọc); `null` khi nhà xe chưa có tuyến.
  final HomeOperatorRoute? route;
  final Future<int?>? fare;

  /// Ngày đi dùng để lấy giá vé từ.
  final DateTime date;
  final VoidCallback? onViewTrips;

  @override
  Widget build(BuildContext context) {
    final rating = operator.averageRating;
    final served = route;
    final otherRoutes = operator.routes.length - 1;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1421404F),
            offset: Offset(0, 7.048),
            blurRadius: 9.398,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _OperatorLogo(operator: operator),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      operator.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: _primaryDark,
                        fontSize: 17,
                        height: 25 / 17,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      rating == null
                          ? 'Chưa có đánh giá'
                          : '★ ${rating.toStringAsFixed(1)} · '
                                '${_compactCount(operator.reviewCount)} đánh giá',
                      style: const TextStyle(
                        color: _secondary,
                        fontSize: 12,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            'Tuyến đang phục vụ',
            style: TextStyle(color: _secondary, fontSize: 11, height: 16 / 11),
          ),
          const SizedBox(height: 6),
          Text.rich(
            TextSpan(
              text: served == null
                  ? 'Chưa có tuyến mở bán'
                  : _routeLabel(served),
              children: [
                if (served != null && otherRoutes > 0)
                  TextSpan(
                    text: '  +$otherRoutes tuyến',
                    style: const TextStyle(
                      color: _secondary,
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
              ],
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: _primaryDark,
              fontSize: 15,
              height: 22 / 15,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Giá vé từ',
                      style: TextStyle(
                        color: _secondary,
                        fontSize: 11,
                        height: 16 / 11,
                      ),
                    ),
                    const SizedBox(height: 4),
                    _OperatorFare(fare: fare, date: date),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Material(
                color: _primarySoft,
                borderRadius: BorderRadius.circular(16),
                child: InkWell(
                  key: ValueKey('explore-operator-${operator.id}-trips'),
                  onTap: onViewTrips,
                  borderRadius: BorderRadius.circular(16),
                  child: SizedBox(
                    width: 132,
                    height: 44,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Flexible(
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              'Xem chuyến',
                              maxLines: 1,
                              style: TextStyle(
                                color: _primary,
                                fontSize: 13,
                                height: 19 / 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        SvgPicture.asset(
                          '$_resultsAssetRoot/arrow_right.svg',
                          width: 16,
                          height: 16,
                          excludeFromSemantics: true,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// `1200` → `1.2K`, `980` → `980`.
String _compactCount(int count) {
  if (count < 1000) return '$count';
  final value = (count / 1000).toStringAsFixed(1);
  return '${value.endsWith('.0') ? value.substring(0, value.length - 2) : value}K';
}

class _OperatorLogo extends StatelessWidget {
  const _OperatorLogo({required this.operator});

  final HomeOperator operator;

  @override
  Widget build(BuildContext context) {
    final fallback = Center(
      child: OperatorInitialAvatar(name: operator.name, size: 42),
    );
    final url = operator.logoUrl;
    return ClipRRect(
      borderRadius: BorderRadius.circular(22.3),
      child: SizedBox(
        width: 52,
        height: 50.76,
        child: url == null
            ? fallback
            : Image.network(
                url,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => fallback,
              ),
      ),
    );
  }
}

class _OperatorFare extends StatelessWidget {
  const _OperatorFare({required this.fare, required this.date});

  final Future<int?>? fare;
  final DateTime date;

  @override
  Widget build(BuildContext context) {
    const priceStyle = TextStyle(
      color: _primary,
      fontSize: 17,
      height: 25 / 17,
      fontWeight: FontWeight.w600,
    );
    const noteStyle = TextStyle(color: _secondary, fontSize: 12, height: 1.5);
    return FutureBuilder<int?>(
      future: fare,
      builder: (context, snapshot) {
        if (fare == null) return const Text('—', style: priceStyle);
        if (snapshot.connectionState != ConnectionState.done) {
          return const SizedBox(
            height: 25,
            child: Align(
              alignment: Alignment.centerLeft,
              child: SizedBox.square(
                dimension: 16,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
          );
        }
        final price = snapshot.data;
        if (price == null) {
          return Text(
            'Chưa mở bán ngày ${formatSearchDate(date).substring(0, 5)}',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: noteStyle,
          );
        }
        return Text(formatVnd(price), style: priceStyle);
      },
    );
  }
}

/// "Lọc nhà xe": khu vực + tuyến phục vụ (Figma "Mua vé / Lọc nhà xe").
class _OperatorFilterSheet extends StatefulWidget {
  const _OperatorFilterSheet({
    required this.operators,
    required this.area,
    required this.route,
  });

  final List<HomeOperator> operators;
  final HomeLocation? area;
  final HomeOperatorRoute? route;

  @override
  State<_OperatorFilterSheet> createState() => _OperatorFilterSheetState();
}

class _OperatorFilterSheetState extends State<_OperatorFilterSheet> {
  late HomeLocation? _area = widget.area;
  late HomeOperatorRoute? _route = widget.route;

  @override
  Widget build(BuildContext context) {
    return _ResultsSheet(
      title: 'Lọc nhà xe',
      action: _SheetActionButton(
        key: const Key('explore-operator-filter-apply'),
        label: 'Áp dụng',
        onPressed: () => Navigator.pop(context, (_area, _route)),
      ),
      child: Column(
        children: [
          _PlannerInput(
            key: const Key('explore-operator-area-input'),
            icon: Icons.location_on_outlined,
            iconColor: _primary,
            label: 'Khu vực',
            value: _area?.name,
            placeholder: 'Tất cả khu vực',
            onTap: _pickAreaValue,
          ),
          const SizedBox(height: 16),
          _PlannerInput(
            key: const Key('explore-operator-route-input'),
            icon: Icons.location_on_outlined,
            iconColor: const Color(0xFFF39A20),
            label: 'Tuyến phục vụ',
            value: _route == null ? null : _routeLabel(_route!),
            placeholder: 'Tất cả tuyến',
            onTap: _pickRouteValue,
          ),
        ],
      ),
    );
  }

  Future<void> _pickAreaValue() async {
    final picked = await _pickArea(context, widget.operators, _area);
    if (picked == null || !mounted) return;
    setState(() {
      _area = picked.$1;
      final route = _route;
      if (route != null && _area != null && !_routeTouches(route, _area!)) {
        _route = null;
      }
    });
  }

  Future<void> _pickRouteValue() async {
    final picked = await _pickServedRoute(
      context,
      widget.operators,
      _area,
      _route,
    );
    if (picked == null || !mounted) return;
    setState(() => _route = picked.$1);
  }
}

/// Sheet chọn một giá trị, dòng đầu là "tất cả" để bỏ lọc.
class _ChoiceSheet<T> extends StatelessWidget {
  const _ChoiceSheet({
    required this.title,
    required this.allLabel,
    required this.options,
    required this.selected,
    required this.labelOf,
    required this.isSame,
  });

  final String title;
  final String allLabel;
  final List<T> options;
  final T? selected;
  final String Function(T value) labelOf;
  final bool Function(T a, T b) isSame;

  @override
  Widget build(BuildContext context) {
    final current = selected;
    return _ResultsSheet(
      title: title,
      child: Flexible(
        child: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.zero,
          children: [
            _SheetOption(
              label: allLabel,
              selected: current == null,
              onTap: () => Navigator.pop(context, (null,)),
            ),
            for (final option in options) ...[
              const SizedBox(height: 8),
              _SheetOption(
                label: labelOf(option),
                selected: current != null && isSame(option, current),
                onTap: () => Navigator.pop(context, (option,)),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

Widget _messageSliver(Widget child, {double bottom = 142}) {
  return SliverPadding(
    padding: EdgeInsets.fromLTRB(24, 12, 24, bottom),
    sliver: SliverToBoxAdapter(child: child),
  );
}

/// Nhắc khi API đã nới phía phường / xã hoặc khu vực ra cả tỉnh vì không có
/// chuyến tại nơi đã chọn (như web).
class _WidenedNotice extends StatelessWidget {
  const _WidenedNotice({required this.from, required this.to});

  final bool from;
  final bool to;

  @override
  Widget build(BuildContext context) {
    final sides = [if (from) 'đón', if (to) 'trả'].join(' / ');
    return Container(
      key: const Key('results-widened-notice'),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF4DA),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Text(
        'Không có chuyến $sides khách tại nơi đã chọn — đang hiện các chuyến '
        'trong cùng tỉnh / thành. Xem điểm $sides của từng chuyến trước khi đặt.',
        style: const TextStyle(
          color: Color(0xFF8A5A00),
          fontSize: 12,
          height: 1.4,
        ),
      ),
    );
  }
}

/// Dòng nhắc nới tỉnh (nếu có) đặt trên danh sách chuyến.
List<Widget> _widenedSlivers(TripSearchPage? page) {
  if (page == null || !(page.widenedFrom || page.widenedTo)) return const [];
  return [
    SliverPadding(
      padding: const EdgeInsets.fromLTRB(15, 0, 15, 12),
      sliver: SliverToBoxAdapter(
        child: _WidenedNotice(from: page.widenedFrom, to: page.widenedTo),
      ),
    ),
  ];
}

String _describeSearchError(Object error) {
  if (error is ApiFailure) {
    if (error.isNetworkError) {
      return 'Không thể kết nối máy chủ. Vui lòng kiểm tra mạng và thử lại.';
    }
    return error.detail;
  }
  return 'Không thể tìm chuyến. Vui lòng thử lại.';
}

class _SearchModeControl extends StatelessWidget {
  const _SearchModeControl({required this.mode, required this.onChanged});

  final HomeSearchMode mode;
  final ValueChanged<HomeSearchMode> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(0xFFEAF4FB),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: AnimatedAlign(
              duration: const Duration(milliseconds: 280),
              curve: Curves.easeOutCubic,
              alignment: mode == HomeSearchMode.route
                  ? Alignment.centerLeft
                  : Alignment.centerRight,
              child: FractionallySizedBox(
                widthFactor: .5,
                heightFactor: 1,
                child: DecoratedBox(
                  key: const Key('ticket-search-mode-indicator'),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF137FB7), Color(0xFF59ABD7)],
                    ),
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: _ModeButton(
                  key: const Key('ticket-mode-trip'),
                  selected: mode == HomeSearchMode.route,
                  label: 'Chuyến xe',
                  asset: mode == HomeSearchMode.route
                      ? '$_homeAssetRoot/icons/search_mode_route_active.svg'
                      : '$_homeAssetRoot/icons/search_mode_route_inactive.svg',
                  onTap: () => onChanged(HomeSearchMode.route),
                ),
              ),
              Expanded(
                child: _ModeButton(
                  key: const Key('ticket-mode-operator'),
                  selected: mode == HomeSearchMode.operator,
                  label: 'Nhà xe',
                  asset: mode == HomeSearchMode.operator
                      ? '$_homeAssetRoot/icons/search_mode_operator_active.svg'
                      : '$_homeAssetRoot/icons/search_mode_operator_inactive.svg',
                  onTap: () => onChanged(HomeSearchMode.operator),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ModeButton extends StatelessWidget {
  const _ModeButton({
    required this.selected,
    required this.label,
    required this.asset,
    required this.onTap,
    super.key,
  });

  final bool selected;
  final String label;
  final String asset;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(asset, width: 20, height: 20),
            const SizedBox(width: 8),
            Flexible(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: AnimatedDefaultTextStyle(
                  duration: const Duration(milliseconds: 180),
                  style: TextStyle(
                    color: selected ? Colors.white : _secondary,
                    fontSize: 14,
                    height: 18 / 14,
                    fontWeight: FontWeight.w600,
                  ),
                  child: Text(label, maxLines: 1),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RouteInputs extends StatelessWidget {
  const _RouteInputs({
    required this.fromLabel,
    required this.toLabel,
    required this.onPickFrom,
    required this.onPickTo,
    required this.onSwap,
    super.key,
  });

  final String? fromLabel;
  final String? toLabel;
  final VoidCallback onPickFrom;
  final VoidCallback onPickTo;
  final VoidCallback onSwap;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          children: [
            _PlannerInput(
              key: const Key('ticket-origin-input'),
              icon: Icons.location_on_outlined,
              iconColor: _primary,
              label: 'Điểm đi',
              value: fromLabel,
              placeholder: 'Chọn điểm đi',
              onTap: onPickFrom,
            ),
            const SizedBox(height: 10),
            _PlannerInput(
              key: const Key('ticket-destination-input'),
              icon: Icons.location_on_outlined,
              iconColor: const Color(0xFFF39A20),
              label: 'Điểm đến',
              value: toLabel,
              placeholder: 'Chọn điểm đến',
              onTap: onPickTo,
            ),
          ],
        ),
        Positioned(
          right: 0,
          top: 55,
          child: Material(
            color: Colors.white,
            shape: const CircleBorder(
              side: BorderSide(color: Color(0xFFE1EDF6)),
            ),
            elevation: 3,
            shadowColor: const Color(0x1A14527D),
            child: InkResponse(
              key: const Key('ticket-swap-locations'),
              onTap: onSwap,
              radius: 21,
              child: SizedBox.square(
                dimension: 42,
                child: Center(
                  child: SvgPicture.asset(
                    '$_homeAssetRoot/icons/swap.svg',
                    width: 23,
                    height: 23,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _PlannerInput extends StatelessWidget {
  const _PlannerInput({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.value,
    required this.placeholder,
    required this.onTap,
    super.key,
  });

  final IconData icon;
  final Color iconColor;
  final String label;

  /// `null` = chưa chọn, hiện [placeholder].
  final String? value;
  final String placeholder;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 62,
      child: Material(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          side: const BorderSide(color: Color(0xFFE1EDF6)),
          borderRadius: BorderRadius.circular(15),
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(15),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 13),
            child: Row(
              children: [
                Icon(icon, size: 23, color: iconColor),
                const SizedBox(width: 11),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        label,
                        style: const TextStyle(
                          color: _secondary,
                          fontSize: 11.5,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        value ?? placeholder,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: value == null ? _secondary : _primaryDark,
                          fontSize: 15,
                          fontWeight: value == null
                              ? FontWeight.w500
                              : FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right, size: 20, color: _primary),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _CompactInput extends StatelessWidget {
  const _CompactInput({
    required this.icon,
    required this.label,
    required this.onTap,
    super.key,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 52,
      child: Material(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          side: const BorderSide(color: Color(0xFFE1EDF6)),
          borderRadius: BorderRadius.circular(14),
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(14),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              children: [
                Icon(icon, size: 19, color: _primary),
                const SizedBox(width: 6),
                Expanded(
                  child: FittedBox(
                    alignment: Alignment.centerLeft,
                    fit: BoxFit.scaleDown,
                    child: Text(
                      label,
                      maxLines: 1,
                      style: const TextStyle(
                        color: _primaryDark,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const Icon(Icons.chevron_right, size: 17, color: _primary),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ResultMessage extends StatelessWidget {
  const _ResultMessage({
    required this.icon,
    required this.message,
    this.actionLabel,
    this.onAction,
    super.key,
  });

  final IconData icon;
  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, size: 40, color: const Color(0xFF9DB7C6)),
        const SizedBox(height: 10),
        Text(
          message,
          textAlign: TextAlign.center,
          style: const TextStyle(color: _secondary, fontSize: 13, height: 1.4),
        ),
        if (actionLabel != null && onAction != null) ...[
          const SizedBox(height: 12),
          OutlinedButton(onPressed: onAction, child: Text(actionLabel!)),
        ],
      ],
    );
  }
}

class _ToolbarChip extends StatelessWidget {
  const _ToolbarChip({
    required this.label,
    required this.onTap,
    this.trailing,
    this.selected = false,
    super.key,
  });

  final String label;
  final IconData? trailing;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? const Color(0xFFE2F1F8) : Colors.white,
      shape: StadiumBorder(
        side: BorderSide(
          color: selected ? const Color(0xFFD1E7F2) : const Color(0xFFDCE3E7),
        ),
      ),
      child: InkWell(
        onTap: onTap,
        customBorder: const StadiumBorder(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                style: const TextStyle(color: _primaryDark, fontSize: 11.5),
              ),
              if (trailing != null) ...[
                const SizedBox(width: 6),
                Icon(trailing, size: 14, color: _secondary),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _ResultSummary extends StatelessWidget {
  const _ResultSummary({
    required this.total,
    required this.sort,
    required this.onSort,
  });

  final int total;
  final TripSearchSort sort;
  final VoidCallback onSort;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: FittedBox(
            alignment: Alignment.centerLeft,
            fit: BoxFit.scaleDown,
            child: Text(
              '$total chuyến phù hợp',
              key: const Key('ticket-result-total'),
              maxLines: 1,
              style: const TextStyle(color: _primaryDark, fontSize: 12.5),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Flexible(
          child: InkWell(
            onTap: onSort,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      sort.label,
                      maxLines: 1,
                      style: const TextStyle(
                        color: _primaryDark,
                        fontSize: 11,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 3),
                const Icon(
                  Icons.keyboard_arrow_down,
                  size: 15,
                  color: _primaryDark,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _TripCard extends StatelessWidget {
  const _TripCard({
    required this.trip,
    required this.fromLabel,
    required this.toLabel,
    required this.onOpenDetail,
    this.dateLabel,
    super.key,
  });

  final TripSummary trip;
  final String fromLabel;
  final String toLabel;
  final VoidCallback onOpenDetail;

  /// Ngày đi (danh sách nhiều ngày); `null` = không ghi.
  final String? dateLabel;

  @override
  Widget build(BuildContext context) {
    // Bóng đổ nằm ngoài Material bị clip; đặt trong thì bóng phủ lên nền thẻ
    // làm thẻ xám thay vì trắng.
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1421404F),
            offset: Offset(0, 7),
            blurRadius: 19,
          ),
        ],
      ),
      child: Material(
        color: const Color(0xFFFFFEFD),
        borderRadius: BorderRadius.circular(20),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onOpenDetail,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(13, 11, 0, 0),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 13),
                  child: _TripOperatorHeader(trip: trip),
                ),
                if (dateLabel != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 6, right: 13),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        dateLabel!,
                        key: ValueKey('ticket-trip-date-${trip.tripId}'),
                        style: const TextStyle(
                          color: _primary,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                const SizedBox(height: 8),
                SizedBox(
                  height: 76,
                  child: _TripJourney(
                    trip: trip,
                    fromLabel: fromLabel,
                    toLabel: toLabel,
                  ),
                ),
                const SizedBox(height: 5),
                Padding(
                  padding: const EdgeInsets.only(right: 13),
                  child: _TripAmenities(trip: trip),
                ),
                const SizedBox(height: 8),
                _TripFooter(trip: trip, onOpenDetail: onOpenDetail),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _TripOperatorHeader extends StatelessWidget {
  const _TripOperatorHeader({required this.trip});
  final TripSummary trip;

  @override
  Widget build(BuildContext context) {
    final rated = trip.averageRating != null && trip.reviewCount > 0;
    return Row(
      children: [
        OperatorInitialAvatar(
          name: trip.operatorName,
          logoUrl: trip.operatorLogoUrl,
          size: 38,
        ),
        const SizedBox(width: 9),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                trip.operatorName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: _primaryDark,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 2),
              Row(
                children: [
                  if (rated) ...[
                    SvgPicture.asset(
                      '$_assetRoot/trip_star.svg',
                      width: 11,
                      height: 11,
                    ),
                    const SizedBox(width: 4),
                  ],
                  Flexible(
                    child: Text(
                      rated
                          ? '${trip.averageRating!.toStringAsFixed(1)} (${trip.reviewCount} đánh giá)'
                          : 'Chưa có đánh giá',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: _secondary, fontSize: 10),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _TripJourney extends StatelessWidget {
  const _TripJourney({
    required this.trip,
    required this.fromLabel,
    required this.toLabel,
  });

  final TripSummary trip;
  final String fromLabel;
  final String toLabel;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final vehicleWidth = constraints.maxWidth < 340 ? 82.0 : 98.0;
        final cover = trip.coverImageUrl;
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 67,
              child: _JourneyPoint(
                time: formatVnClock(trip.pickup.plannedAt),
                // Nơi thật của điểm đón (API ghép theo phường) thay cho chữ trên ô tìm (vd tìm "Lâm Đồng" nhưng đón ở Đà Lạt).
                city: _compactPlace(trip.segmentPart(0) ?? fromLabel),
                station: trip.pickup.name,
              ),
            ),
            Expanded(
              child: _RouteDuration(
                duration: formatTripDuration(trip.durationMinutes),
              ),
            ),
            const SizedBox(width: 4),
            SizedBox(
              width: 56,
              child: _JourneyPoint(
                time: formatVnClock(trip.dropoff.plannedAt),
                city: _compactPlace(trip.segmentPart(1) ?? toLabel),
                station: trip.dropoff.name,
              ),
            ),
            SizedBox(
              width: vehicleWidth,
              height: 76,
              child: ClipOval(
                child: cover == null
                    ? const _VehicleFallback()
                    : Image.network(
                        cover,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            const _VehicleFallback(),
                      ),
              ),
            ),
          ],
        );
      },
    );
  }
}

/// Cột thẻ chuyến hẹp: viết tắt TP. Hồ Chí Minh như Figma ("TP.HCM").
String _compactPlace(String name) =>
    name == 'TP. Hồ Chí Minh' ? 'TP.HCM' : name;

/// Tên tuyến gọn cho chip, thẻ nhà xe: "TP.HCM → Lâm Đồng".
String _routeLabel(HomeOperatorRoute route) =>
    '${_compactPlace(route.from.name)} → ${_compactPlace(route.to.name)}';

class _VehicleFallback extends StatelessWidget {
  const _VehicleFallback();

  @override
  Widget build(BuildContext context) {
    return const ColoredBox(
      color: Color(0xFFEAF4FB),
      child: Center(
        child: Icon(Icons.directions_bus, color: _primary, size: 42),
      ),
    );
  }
}

class _JourneyPoint extends StatelessWidget {
  const _JourneyPoint({
    required this.time,
    required this.city,
    required this.station,
  });
  final String time;
  final String city;
  final String station;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            time,
            style: const TextStyle(
              color: _primaryDark,
              fontSize: 17,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const SizedBox(height: 2),
        Text(
          city,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(color: _primaryDark, fontSize: 10.5),
        ),
        Text(
          station,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(color: _secondary, fontSize: 7.5, height: 1.2),
        ),
      ],
    );
  }
}

class _RouteDuration extends StatelessWidget {
  const _RouteDuration({required this.duration});
  final String duration;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 13),
        SizedBox(
          height: 20,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Positioned.fill(
                child: SvgPicture.asset(
                  '$_assetRoot/trip_route_line.svg',
                  fit: BoxFit.fill,
                ),
              ),
              Positioned(
                left: 0,
                child: SvgPicture.asset(
                  '$_assetRoot/trip_route_node.svg',
                  width: 5,
                  height: 5,
                ),
              ),
              Positioned(
                right: 0,
                child: SvgPicture.asset(
                  '$_assetRoot/trip_route_node.svg',
                  width: 5,
                  height: 5,
                ),
              ),
              SvgPicture.asset(
                '$_assetRoot/trip_bus.svg',
                width: 19,
                height: 19,
              ),
            ],
          ),
        ),
        const SizedBox(height: 3),
        Text(
          duration,
          style: const TextStyle(color: _secondary, fontSize: 9.5),
        ),
      ],
    );
  }
}

class _TripAmenities extends StatelessWidget {
  const _TripAmenities({required this.trip});
  final TripSummary trip;

  @override
  Widget build(BuildContext context) {
    final amenities = trip.amenityNames.join(' · ');
    return Row(
      children: [
        SvgPicture.asset(
          '$_assetRoot/trip_seat_type.svg',
          width: 16,
          height: 16,
        ),
        const SizedBox(width: 7),
        Flexible(
          child: Text(
            trip.vehicleTypeName,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: _primaryDark, fontSize: 9),
          ),
        ),
        if (amenities.isNotEmpty) ...[
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              amenities,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.end,
              style: const TextStyle(color: _secondary, fontSize: 9),
            ),
          ),
        ],
      ],
    );
  }
}

class _TripFooter extends StatelessWidget {
  const _TripFooter({required this.trip, required this.onOpenDetail});
  final TripSummary trip;
  final VoidCallback onOpenDetail;

  @override
  Widget build(BuildContext context) {
    final urgent = trip.availableSeats <= 5;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 17),
            child: Align(
              alignment: Alignment.centerLeft,
              child: urgent
                  ? Container(
                      height: 22,
                      padding: const EdgeInsets.symmetric(horizontal: 7),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF4DA),
                        borderRadius: BorderRadius.circular(11),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SvgPicture.asset(
                            '$_assetRoot/trip_flame.svg',
                            width: 12,
                            height: 12,
                          ),
                          const SizedBox(width: 5),
                          Flexible(
                            child: Text(
                              'Chỉ còn ${trip.availableSeats} chỗ',
                              maxLines: 1,
                              style: const TextStyle(
                                color: Color(0xFFD98112),
                                fontSize: 9.5,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  : Row(
                      children: [
                        const Icon(
                          Icons.event_seat_outlined,
                          size: 14,
                          color: Color(0xFF268140),
                        ),
                        const SizedBox(width: 7),
                        Flexible(
                          child: Text(
                            'Còn ${trip.availableSeats} chỗ',
                            maxLines: 1,
                            style: const TextStyle(
                              color: Color(0xFF268140),
                              fontSize: 10,
                            ),
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ),
        _FareStub(price: formatVnd(trip.minPrice), onOpenDetail: onOpenDetail),
      ],
    );
  }
}

class _FareStub extends StatelessWidget {
  const _FareStub({required this.price, required this.onOpenDetail});

  final String price;
  final VoidCallback onOpenDetail;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 165,
      height: 54,
      child: Stack(
        children: [
          Positioned(
            left: 0,
            top: 10,
            child: SvgPicture.asset(
              '$_assetRoot/ticket_cutout.svg',
              width: 11,
              height: 11,
            ),
          ),
          Positioned(
            left: 0,
            top: 25,
            child: SvgPicture.asset(
              '$_assetRoot/ticket_cutout.svg',
              width: 11,
              height: 11,
            ),
          ),
          Positioned(
            left: 6,
            right: 0,
            top: 0,
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.fromLTRB(20, 6, 10, 6),
              decoration: const BoxDecoration(
                color: Color(0xFFE3F0F6),
                borderRadius: BorderRadius.only(topLeft: Radius.circular(13)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Từ',
                          style: TextStyle(color: _primary, fontSize: 9.5),
                        ),
                        FittedBox(
                          fit: BoxFit.scaleDown,
                          alignment: Alignment.centerLeft,
                          child: Text(
                            price,
                            maxLines: 1,
                            style: const TextStyle(
                              color: _primary,
                              fontSize: 14.5,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  InkResponse(
                    onTap: onOpenDetail,
                    radius: 22,
                    child: SizedBox.square(
                      dimension: 36,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          SvgPicture.asset(
                            '$_assetRoot/trip_cta_circle.svg',
                            width: 32,
                            height: 32,
                          ),
                          SvgPicture.asset(
                            '$_assetRoot/trip_arrow.svg',
                            width: 15,
                            height: 15,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TripFilterSheet extends StatefulWidget {
  const _TripFilterSheet({
    required this.initial,
    required this.operators,
    required this.priceMin,
    required this.priceMax,
    required this.loadAmenities,
  });

  final TripSearchFilters initial;
  final List<TripOperatorFacet> operators;
  final int? priceMin;
  final int? priceMax;
  final Future<List<TripAmenityOption>> Function()? loadAmenities;

  @override
  State<_TripFilterSheet> createState() => _TripFilterSheetState();
}

class _TripFilterSheetState extends State<_TripFilterSheet> {
  late TripVehicleForm? _form = widget.initial.vehicleForm;
  late TripVehicleClass? _class = widget.initial.vehicleClass;
  late TripDepartureSlot? _slot = widget.initial.departureSlot;
  late final Set<String> _amenityIds = {...widget.initial.amenityIds};
  late String? _operatorId = widget.initial.operatorId;
  late RangeValues? _price = _initialPrice();

  /// Chưa kéo thanh giá (hoặc khoảng giá của ngày này không đủ để hiện thanh)
  /// thì giữ nguyên lọc giá đang có, không âm thầm bỏ / đổi.
  bool _priceChanged = false;
  late final Future<List<TripAmenityOption>>? _amenities = widget
      .loadAmenities
      ?.call();

  bool get _hasPriceRange =>
      widget.priceMin != null &&
      widget.priceMax != null &&
      widget.priceMax! > widget.priceMin!;

  RangeValues? _initialPrice() {
    if (!_hasPriceRange) return null;
    final low = widget.priceMin!.toDouble();
    final high = widget.priceMax!.toDouble();
    return RangeValues(
      (widget.initial.priceMin?.toDouble() ?? low).clamp(low, high),
      (widget.initial.priceMax?.toDouble() ?? high).clamp(low, high),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.paddingOf(context).bottom;
    return DraggableScrollableSheet(
      initialChildSize: .88,
      minChildSize: .55,
      maxChildSize: .96,
      expand: false,
      builder: (context, scrollController) {
        return Material(
          color: const Color(0xFFFFFEFD),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
          clipBehavior: Clip.antiAlias,
          child: Column(
            children: [
              const SizedBox(height: 12),
              Container(
                width: 46,
                height: 5,
                decoration: BoxDecoration(
                  color: const Color(0xFFA1B4C0),
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 10, 12, 8),
                child: Row(
                  children: [
                    const Expanded(
                      child: Text(
                        'Lọc chuyến',
                        style: TextStyle(
                          color: _primaryDark,
                          fontSize: 19,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    IconButton.outlined(
                      key: const Key('ticket-filter-close'),
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close, size: 18),
                      style: IconButton.styleFrom(
                        foregroundColor: _secondary,
                        side: const BorderSide(color: Color(0xFFDCE3E7)),
                        minimumSize: const Size(34, 34),
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1, indent: 20, endIndent: 20),
              Expanded(
                child: ListView(
                  key: const Key('ticket-filter-scroll'),
                  controller: scrollController,
                  padding: const EdgeInsets.fromLTRB(16, 14, 16, 18),
                  children: [
                    if (_price != null) ...[
                      const _FilterSectionTitle('Khoảng giá'),
                      SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                          activeTrackColor: _primary,
                          inactiveTrackColor: const Color(0xFFD8E5EB),
                          thumbColor: Colors.white,
                          overlayColor: const Color(0x1F2B7EAD),
                          thumbShape: const RoundSliderThumbShape(
                            enabledThumbRadius: 9,
                            elevation: 2,
                          ),
                          rangeTrackShape:
                              const RoundedRectRangeSliderTrackShape(),
                        ),
                        child: RangeSlider(
                          values: _price!,
                          min: widget.priceMin!.toDouble(),
                          max: widget.priceMax!.toDouble(),
                          onChanged: (value) => setState(() {
                            _price = value;
                            _priceChanged = true;
                          }),
                        ),
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              formatVnd(_price!.start.round()),
                              style: const TextStyle(
                                color: _secondary,
                                fontSize: 11,
                              ),
                            ),
                          ),
                          Text(
                            formatVnd(_price!.end.round()),
                            style: const TextStyle(
                              color: _secondary,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 22),
                    ],
                    const _FilterSectionTitle('Dạng chỗ'),
                    const SizedBox(height: 10),
                    _FourColumnOptions(
                      children: [
                        _FilterOptionCard(
                          icon: Icons.directions_bus_outlined,
                          label: 'Tất cả',
                          selected: _form == null,
                          onTap: () => setState(() => _form = null),
                        ),
                        for (final form in TripVehicleForm.values)
                          _FilterOptionCard(
                            key: ValueKey('ticket-filter-form-${form.name}'),
                            icon: switch (form) {
                              TripVehicleForm.seater =>
                                Icons.event_seat_outlined,
                              TripVehicleForm.sleeper => Icons.bed_outlined,
                              TripVehicleForm.cabin =>
                                Icons.meeting_room_outlined,
                            },
                            label: form.label,
                            selected: _form == form,
                            onTap: () => setState(
                              () => _form = _form == form ? null : form,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 22),
                    const _FilterSectionTitle('Hạng xe'),
                    const SizedBox(height: 10),
                    _FourColumnOptions(
                      children: [
                        _FilterOptionCard(
                          icon: Icons.directions_bus_outlined,
                          label: 'Tất cả',
                          selected: _class == null,
                          onTap: () => setState(() => _class = null),
                        ),
                        for (final vehicleClass in TripVehicleClass.values)
                          _FilterOptionCard(
                            key: ValueKey(
                              'ticket-filter-class-${vehicleClass.name}',
                            ),
                            icon: vehicleClass == TripVehicleClass.limousine
                                ? Icons.diamond_outlined
                                : Icons.airline_seat_recline_normal_outlined,
                            label: vehicleClass.label,
                            selected: _class == vehicleClass,
                            onTap: () => setState(
                              () => _class = _class == vehicleClass
                                  ? null
                                  : vehicleClass,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 22),
                    const _FilterSectionTitle('Giờ khởi hành'),
                    const SizedBox(height: 10),
                    _FourColumnOptions(
                      children: [
                        for (final slot in TripDepartureSlot.values)
                          _DepartureOption(
                            key: ValueKey('ticket-filter-slot-${slot.name}'),
                            icon: switch (slot) {
                              TripDepartureSlot.earlyMorning =>
                                Icons.nights_stay_outlined,
                              TripDepartureSlot.morning =>
                                Icons.wb_twilight_outlined,
                              TripDepartureSlot.afternoon =>
                                Icons.wb_sunny_outlined,
                              TripDepartureSlot.evening =>
                                Icons.dark_mode_outlined,
                            },
                            label: slot.label,
                            time: slot.range,
                            selected: _slot == slot,
                            onTap: () => setState(
                              () => _slot = _slot == slot ? null : slot,
                            ),
                          ),
                      ],
                    ),
                    if (_amenities != null)
                      FutureBuilder<List<TripAmenityOption>>(
                        future: _amenities,
                        builder: (context, snapshot) {
                          final amenities = snapshot.data;
                          if (amenities == null || amenities.isEmpty) {
                            return const SizedBox.shrink();
                          }
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 22),
                              const _FilterSectionTitle('Tiện ích'),
                              const SizedBox(height: 10),
                              Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children: [
                                  for (final amenity in amenities)
                                    _AmenityChip(
                                      label: amenity.name,
                                      selected: _amenityIds.contains(
                                        amenity.id,
                                      ),
                                      onTap: () => setState(() {
                                        if (!_amenityIds.add(amenity.id)) {
                                          _amenityIds.remove(amenity.id);
                                        }
                                      }),
                                    ),
                                ],
                              ),
                            ],
                          );
                        },
                      ),
                    if (widget.operators.isNotEmpty) ...[
                      const SizedBox(height: 24),
                      const _FilterSectionTitle('Nhà xe'),
                      const SizedBox(height: 8),
                      for (final operator in widget.operators)
                        _OperatorFilterRow(
                          key: ValueKey('ticket-filter-operator-${operator.id}'),
                          label: operator.name,
                          count: operator.count,
                          selected: _operatorId == operator.id,
                          onChanged: () => setState(
                            () => _operatorId = _operatorId == operator.id
                                ? null
                                : operator.id,
                          ),
                        ),
                    ],
                  ],
                ),
              ),
              const Divider(height: 1),
              Padding(
                padding: EdgeInsets.fromLTRB(16, 14, 16, 12 + bottomInset),
                child: Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        key: const Key('ticket-filter-reset'),
                        onPressed: _reset,
                        style: OutlinedButton.styleFrom(
                          minimumSize: const Size.fromHeight(52),
                          foregroundColor: _primaryDark,
                          side: const BorderSide(color: Color(0xFF86B1CA)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(19),
                          ),
                        ),
                        child: const Text(
                          'Đặt lại',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: FilledButton(
                        key: const Key('ticket-filter-apply'),
                        onPressed: () => Navigator.pop(context, _result()),
                        style: FilledButton.styleFrom(
                          minimumSize: const Size.fromHeight(52),
                          backgroundColor: _primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(19),
                          ),
                        ),
                        child: const Text(
                          'Áp dụng',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  TripSearchFilters _result() {
    final price = _price;
    final lowChanged =
        price != null && price.start.round() > widget.priceMin!;
    final highChanged =
        price != null && price.end.round() < widget.priceMax!;
    return TripSearchFilters(
      vehicleForm: _form,
      vehicleClass: _class,
      departureSlot: _slot,
      priceMin: _priceChanged
          ? (lowChanged ? price.start.round() : null)
          : widget.initial.priceMin,
      priceMax: _priceChanged
          ? (highChanged ? price.end.round() : null)
          : widget.initial.priceMax,
      amenityIds: {..._amenityIds},
      operatorId: _operatorId,
      sort: widget.initial.sort,
    );
  }

  void _reset() {
    setState(() {
      _form = null;
      _class = null;
      _slot = null;
      _amenityIds.clear();
      _operatorId = null;
      _priceChanged = true;
      _price = _hasPriceRange
          ? RangeValues(
              widget.priceMin!.toDouble(),
              widget.priceMax!.toDouble(),
            )
          : null;
    });
  }
}

class _FilterSectionTitle extends StatelessWidget {
  const _FilterSectionTitle(this.label);
  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: const TextStyle(
        color: _primaryDark,
        fontSize: 14,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}

class _FourColumnOptions extends StatelessWidget {
  const _FourColumnOptions({required this.children});
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var index = 0; index < children.length; index++) ...[
          Expanded(child: children[index]),
          if (index < children.length - 1) const SizedBox(width: 8),
        ],
      ],
    );
  }
}

class _FilterOptionCard extends StatelessWidget {
  const _FilterOptionCard({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
    super.key,
  });

  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 74,
      child: _SelectableFilterSurface(
        selected: selected,
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 21, color: _primaryDark),
            const SizedBox(height: 7),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                label,
                maxLines: 1,
                style: TextStyle(
                  color: _primaryDark,
                  fontSize: 10.5,
                  fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DepartureOption extends StatelessWidget {
  const _DepartureOption({
    required this.icon,
    required this.label,
    required this.time,
    required this.selected,
    required this.onTap,
    super.key,
  });

  final IconData icon;
  final String label;
  final String time;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 86,
      child: _SelectableFilterSurface(
        selected: selected,
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 22, color: _primaryDark),
            const SizedBox(height: 4),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                label,
                maxLines: 1,
                style: const TextStyle(color: _primaryDark, fontSize: 11.5),
              ),
            ),
            const SizedBox(height: 2),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                time,
                maxLines: 1,
                style: const TextStyle(color: _secondary, fontSize: 8.5),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SelectableFilterSurface extends StatelessWidget {
  const _SelectableFilterSurface({
    required this.selected,
    required this.onTap,
    required this.child,
  });

  final bool selected;
  final VoidCallback onTap;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? const Color(0xFFEDF7FC) : const Color(0xFFFEFDFB),
      shape: RoundedRectangleBorder(
        side: BorderSide(color: selected ? _primary : const Color(0xFFDCE3E7)),
        borderRadius: BorderRadius.circular(14),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: child,
      ),
    );
  }
}

class _AmenityChip extends StatelessWidget {
  const _AmenityChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? const Color(0xFFEDF7FC) : const Color(0xFFFEFDFB),
      shape: StadiumBorder(
        side: BorderSide(color: selected ? _primary : const Color(0xFFDCE3E7)),
      ),
      child: InkWell(
        onTap: onTap,
        customBorder: const StadiumBorder(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                selected ? Icons.check_circle : Icons.add_circle_outline,
                size: 16,
                color: selected ? _primary : _secondary,
              ),
              const SizedBox(width: 6),
              Text(
                label,
                style: const TextStyle(color: _primaryDark, fontSize: 9.5),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _OperatorFilterRow extends StatelessWidget {
  const _OperatorFilterRow({
    required this.label,
    required this.count,
    required this.selected,
    required this.onChanged,
    super.key,
  });

  final String label;
  final int count;
  final bool selected;
  final VoidCallback onChanged;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onChanged,
      borderRadius: BorderRadius.circular(10),
      child: SizedBox(
        height: 39,
        child: Row(
          children: [
            SizedBox(
              width: 24,
              height: 24,
              child: Checkbox(
                value: selected,
                onChanged: (_) => onChanged(),
                activeColor: _primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
                side: const BorderSide(color: Color(0xFFB9C8D0)),
              ),
            ),
            const SizedBox(width: 14),
            OperatorInitialAvatar(name: label, size: 26),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(color: _primaryDark, fontSize: 11),
              ),
            ),
            Text(
              '$count',
              style: const TextStyle(color: _secondary, fontSize: 10.5),
            ),
            const SizedBox(width: 8),
          ],
        ),
      ),
    );
  }
}
