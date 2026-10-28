import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mobile_shared/mobile_shared.dart';
import 'package:passenger_mobile/features/home/home_models.dart';
import 'package:passenger_mobile/features/home/route_dock_tabbar.dart';
import 'package:passenger_mobile/features/search/trip_search_form.dart';
import 'package:passenger_mobile/features/ticket/trip_search_models.dart';

const _assetRoot = 'assets/ticket';
const _homeAssetRoot = 'assets/home';
const _primary = Color(0xFF2B7EAD);
const _primaryDark = Color(0xFF09243D);
const _secondary = Color(0xFF607A8E);
const _pageBackground = Color(0xFFF4F8F9);

/// Tab Mua vé: form tìm chuyến và danh sách chuyến ngay bên dưới (Figma 05).
class TicketScreen extends StatefulWidget {
  const TicketScreen({
    required this.onTabSelected,
    this.searchCatalog,
    this.searchTrips,
    this.initialQuery,
    this.onQueryChanged,
    this.onTripSelected,
    super.key,
  });

  final ValueChanged<int> onTabSelected;
  final TripSearchCatalog? searchCatalog;
  final TripSearchRunner? searchTrips;

  /// Bấm một chuyến trong danh sách (mở chi tiết chuyến).
  final void Function(TripSummary trip, HomeSearchQuery query)? onTripSelected;

  /// Điều kiện tìm mang sang từ Trang chủ / lần tìm trước; có thì tìm ngay khi mở.
  final HomeSearchQuery? initialQuery;

  /// Báo điều kiện vừa tìm để giữ lại khi rời tab.
  final ValueChanged<HomeSearchQuery>? onQueryChanged;

  @override
  State<TicketScreen> createState() => _TicketScreenState();
}

class _TicketScreenState extends State<TicketScreen>
    with TripSearchFormState<TicketScreen> {
  final _scrollController = ScrollController();
  bool _dockVisible = true;

  HomeSearchQuery? _query;
  TripSearchFilters _filters = const TripSearchFilters();
  TripSearchPage? _page;
  List<TripSummary> _trips = const [];
  bool _loading = false;
  bool _loadingMore = false;
  String? _error;
  int _request = 0;

  @override
  TripSearchCatalog? get searchCatalog => widget.searchCatalog;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_maybeLoadMore);
    final query = widget.initialQuery;
    if (query != null) {
      applySearchQuery(query);
      _search(query);
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final query = _query;
    return Scaffold(
      key: const Key('ticket-screen'),
      extendBody: true,
      backgroundColor: _pageBackground,
      bottomNavigationBar: IgnorePointer(
        ignoring: !_dockVisible,
        child: AnimatedSlide(
          key: const Key('ticket-bottom-dock-animation'),
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOutCubic,
          offset: _dockVisible ? Offset.zero : const Offset(0, 1),
          child: RouteDockTabBar(currentIndex: 1, onTap: widget.onTabSelected),
        ),
      ),
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.dark.copyWith(
          statusBarColor: Colors.transparent,
          systemNavigationBarColor: _pageBackground,
        ),
        child: DecoratedBox(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFFE6F4FA), Color(0xFFF3F5F5), Color(0xFFEEEAE4)],
              stops: [0, .52, 1],
            ),
          ),
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
                    child: _TicketHeader(
                      planner: _JourneyPlanner(
                        mode: searchMode,
                        fromLabel: searchFrom?.name,
                        toLabel: searchTo?.name,
                        operatorLabel: searchOperator?.name,
                        routeLabel: searchOperatorRoute?.label,
                        date: searchDate,
                        passengers: searchPassengers,
                        onModeChanged: (mode) =>
                            setState(() => searchMode = mode),
                        onPickFrom: () => pickSearchLocation(isOrigin: true),
                        onPickTo: () => pickSearchLocation(isOrigin: false),
                        onSwap: swapSearchLocations,
                        onOperatorTap: pickSearchOperator,
                        onRouteTap: pickSearchOperatorRoute,
                        onPickDate: pickSearchDate,
                        onPickPassengers: pickSearchPassengers,
                        onSearch: _onSearchPressed,
                      ),
                    ),
                  ),
                  if (query == null)
                    const SliverPadding(
                      padding: EdgeInsets.fromLTRB(24, 28, 24, 142),
                      sliver: SliverToBoxAdapter(
                        child: _ResultMessage(
                          icon: Icons.travel_explore,
                          message:
                              'Chọn điểm đi, điểm đến và ngày đi rồi bấm "Tìm chuyến".',
                        ),
                      ),
                    )
                  else ...[
                    SliverPadding(
                      padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
                      sliver: SliverToBoxAdapter(
                        child: _ResultToolbar(
                          filters: _filters,
                          operators: _page?.operators ?? const [],
                          onFilter: _openFilters,
                          onSort: _openSortSheet,
                          onChanged: _applyFilters,
                        ),
                      ),
                    ),
                    if (!_loading && _error == null)
                      SliverPadding(
                        padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
                        sliver: SliverToBoxAdapter(
                          child: _ResultSummary(
                            total: _page?.total ?? 0,
                            sort: _filters.sort,
                            onSort: _openSortSheet,
                          ),
                        ),
                      ),
                    ..._resultSlivers(query),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _resultSlivers(HomeSearchQuery query) {
    if (_loading) {
      return const [
        SliverPadding(
          padding: EdgeInsets.only(top: 48, bottom: 142),
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
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(24, 28, 24, 142),
          sliver: SliverToBoxAdapter(
            child: _ResultMessage(
              icon: Icons.wifi_off_outlined,
              message: error,
              actionLabel: 'Thử lại',
              onAction: () => _search(query),
            ),
          ),
        ),
      ];
    }
    if (_trips.isEmpty) {
      final filtered = _filters.activeCount > 0;
      return [
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(24, 20, 24, 142),
          sliver: SliverToBoxAdapter(
            child: _ResultMessage(
              key: const Key('ticket-empty'),
              icon: Icons.directions_bus_outlined,
              message: filtered
                  ? 'Không có chuyến khớp bộ lọc. Hãy bỏ bớt bộ lọc.'
                  : 'Chưa có chuyến phù hợp. Hãy thử ngày khác hoặc địa điểm khác.',
              actionLabel: filtered ? 'Bỏ lọc' : null,
              onAction: filtered
                  ? () => _applyFilters(_filters.cleared())
                  : null,
            ),
          ),
        ),
      ];
    }
    return [
      SliverPadding(
        padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
        sliver: SliverList.separated(
          itemBuilder: (context, index) {
            final trip = _trips[index];
            return _TripCard(
              key: ValueKey('ticket-trip-${trip.tripId}'),
              trip: trip,
              fromLabel: query.from.name,
              toLabel: query.to.name,
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

  void _onSearchPressed() {
    final query = buildSearchQuery();
    if (query == null) return;
    // Đổi điều kiện tìm thì nhà xe và khoảng giá cũ không còn đúng với kết quả mới.
    _filters = TripSearchFilters(
      vehicleForm: _filters.vehicleForm,
      vehicleClass: _filters.vehicleClass,
      departureSlot: _filters.departureSlot,
      amenityIds: _filters.amenityIds,
      sort: _filters.sort,
    );
    widget.onQueryChanged?.call(query);
    _search(query);
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
    if (query == null ||
        page == null ||
        runner == null ||
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
      final next = await runner(query, _filters, page.page + 1);
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
    _filters = filters;
    final query = _query;
    if (query != null) _search(query);
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

  Future<void> _openSortSheet() async {
    final selected = await showModalBottomSheet<TripSearchSort>(
      context: context,
      showDragHandle: true,
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Sắp xếp',
                style: TextStyle(fontSize: 19, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 10),
              for (final sort in TripSearchSort.values)
                ListTile(
                  key: ValueKey('ticket-sort-${sort.name}'),
                  contentPadding: EdgeInsets.zero,
                  title: Text(sort.label),
                  trailing: sort == _filters.sort
                      ? const Icon(Icons.check_circle, color: _primary)
                      : null,
                  onTap: () => Navigator.pop(context, sort),
                ),
            ],
          ),
        ),
      ),
    );
    if (selected != null && selected != _filters.sort && mounted) {
      _applyFilters(_filters.withSort(selected));
    }
  }
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

class _TicketHeader extends StatelessWidget {
  const _TicketHeader({required this.planner});

  final Widget planner;

  @override
  Widget build(BuildContext context) {
    // Tiêu đề cùng kiểu, cùng vị trí với tiêu đề Khám phá: thiết kế rộng 412,
    // thu nhỏ theo bề rộng màn như canvas trang Khám phá.
    final scale = math.min(1.0, MediaQuery.sizeOf(context).width / 412);
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
          padding: EdgeInsets.only(
            top: MediaQuery.paddingOf(context).top + 36 * scale,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 29 * scale),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Mua vé',
                      style: TextStyle(
                        color: const Color(0xFF0B1739),
                        fontFamily: 'Be Vietnam Pro',
                        fontSize: 28 * scale,
                        height: 1.4,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      'cho hành trình của bạn',
                      style: TextStyle(
                        color: const Color(0xFF3B91C5),
                        fontFamily: 'Be Vietnam Pro',
                        fontSize: 24 * scale,
                        height: 1.4,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              planner,
            ],
          ),
        ),
      ],
    );
  }
}

class _JourneyPlanner extends StatelessWidget {
  const _JourneyPlanner({
    required this.mode,
    required this.fromLabel,
    required this.toLabel,
    required this.operatorLabel,
    required this.routeLabel,
    required this.date,
    required this.passengers,
    required this.onModeChanged,
    required this.onPickFrom,
    required this.onPickTo,
    required this.onSwap,
    required this.onOperatorTap,
    required this.onRouteTap,
    required this.onPickDate,
    required this.onPickPassengers,
    required this.onSearch,
  });

  final HomeSearchMode mode;
  final String? fromLabel;
  final String? toLabel;
  final String? operatorLabel;
  final String? routeLabel;
  final DateTime date;
  final int passengers;
  final ValueChanged<HomeSearchMode> onModeChanged;
  final VoidCallback onPickFrom;
  final VoidCallback onPickTo;
  final VoidCallback onSwap;
  final VoidCallback onOperatorTap;
  final VoidCallback onRouteTap;
  final VoidCallback onPickDate;
  final VoidCallback onPickPassengers;
  final VoidCallback onSearch;

  @override
  Widget build(BuildContext context) {
    return Container(
      key: const Key('ticket-journey-planner'),
      margin: const EdgeInsets.symmetric(horizontal: 6),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFFFEFEFD),
        borderRadius: BorderRadius.circular(26),
        border: Border.all(color: const Color(0xFFE0EFF8)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1F21404F),
            offset: Offset(0, 8),
            blurRadius: 20,
          ),
        ],
      ),
      child: Column(
        children: [
          _SearchModeControl(mode: mode, onChanged: onModeChanged),
          const SizedBox(height: 12),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 250),
            switchInCurve: Curves.easeOutCubic,
            switchOutCurve: Curves.easeInCubic,
            transitionBuilder: (child, animation) => FadeTransition(
              opacity: animation,
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(.03, 0),
                  end: Offset.zero,
                ).animate(animation),
                child: child,
              ),
            ),
            child: mode == HomeSearchMode.route
                ? _RouteInputs(
                    key: const ValueKey('ticket-route-inputs'),
                    fromLabel: fromLabel,
                    toLabel: toLabel,
                    onPickFrom: onPickFrom,
                    onPickTo: onPickTo,
                    onSwap: onSwap,
                  )
                : _OperatorInput(
                    key: const ValueKey('ticket-operator-input'),
                    operatorLabel: operatorLabel,
                    routeLabel: routeLabel,
                    onOperatorTap: onOperatorTap,
                    onRouteTap: onRouteTap,
                  ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _CompactInput(
                  key: const Key('ticket-date-input'),
                  icon: Icons.calendar_month_outlined,
                  label: formatSearchDate(date),
                  onTap: onPickDate,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _CompactInput(
                  key: const Key('ticket-passenger-input'),
                  icon: Icons.person_outline,
                  label: '$passengers khách',
                  onTap: onPickPassengers,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            height: 54,
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFF4B028), Color(0xFFEA831D)],
                ),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  key: const Key('ticket-search-button'),
                  borderRadius: BorderRadius.circular(18),
                  onTap: onSearch,
                  child: const Center(
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.search, size: 20, color: Colors.white),
                          SizedBox(width: 9),
                          Text(
                            'Tìm chuyến',
                            maxLines: 1,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(width: 9),
                          Icon(
                            Icons.arrow_forward,
                            size: 18,
                            color: Colors.white,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
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
                  label: 'Theo chuyến',
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
                  label: 'Theo nhà xe',
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
            SvgPicture.asset(asset, width: 19, height: 19),
            const SizedBox(width: 7),
            Flexible(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: AnimatedDefaultTextStyle(
                  duration: const Duration(milliseconds: 180),
                  style: TextStyle(
                    color: selected ? Colors.white : _secondary,
                    fontSize: 13,
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

class _OperatorInput extends StatelessWidget {
  const _OperatorInput({
    required this.operatorLabel,
    required this.routeLabel,
    required this.onOperatorTap,
    required this.onRouteTap,
    super.key,
  });

  final String? operatorLabel;
  final String? routeLabel;
  final VoidCallback onOperatorTap;
  final VoidCallback onRouteTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _PlannerInput(
          key: const Key('ticket-operator-field'),
          icon: Icons.apartment_outlined,
          iconColor: _primary,
          label: 'Nhà xe',
          value: operatorLabel,
          placeholder: 'Chọn nhà xe',
          onTap: onOperatorTap,
        ),
        const SizedBox(height: 10),
        _PlannerInput(
          key: const Key('ticket-operator-route-field'),
          icon: Icons.route_outlined,
          iconColor: const Color(0xFFF39A20),
          label: 'Tuyến đường',
          value: routeLabel,
          placeholder: operatorLabel == null
              ? 'Chọn nhà xe trước'
              : 'Chọn tuyến',
          onTap: onRouteTap,
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

class _ResultToolbar extends StatelessWidget {
  const _ResultToolbar({
    required this.filters,
    required this.operators,
    required this.onFilter,
    required this.onSort,
    required this.onChanged,
  });

  final TripSearchFilters filters;
  final List<TripOperatorFacet> operators;
  final VoidCallback onFilter;
  final VoidCallback onSort;
  final ValueChanged<TripSearchFilters> onChanged;

  @override
  Widget build(BuildContext context) {
    final operatorName = operators
        .where((operator) => operator.id == filters.operatorId)
        .map((operator) => operator.name)
        .firstOrNull;
    final chips = <(String, TripSearchFilters)>[
      if (filters.vehicleForm != null)
        (
          filters.vehicleForm!.label,
          _copy(filters, clearVehicleForm: true),
        ),
      if (filters.vehicleClass != null)
        (
          filters.vehicleClass!.label,
          _copy(filters, clearVehicleClass: true),
        ),
      if (filters.departureSlot != null)
        (
          filters.departureSlot!.label,
          _copy(filters, clearDepartureSlot: true),
        ),
      if (operatorName != null)
        (operatorName, _copy(filters, clearOperator: true)),
    ];
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _ToolbarChip(
            key: const Key('ticket-filter-chip'),
            icon: Icons.filter_alt_outlined,
            label: 'Lọc',
            count: filters.activeCount == 0 ? null : filters.activeCount,
            selected: filters.activeCount > 0,
            onTap: onFilter,
          ),
          const SizedBox(width: 9),
          _ToolbarChip(
            key: const Key('ticket-sort-chip'),
            icon: Icons.tune,
            label: 'Sắp xếp',
            onTap: onSort,
          ),
          for (final chip in chips) ...[
            const SizedBox(width: 9),
            _ToolbarChip(
              label: chip.$1,
              selected: true,
              trailing: Icons.close,
              onTap: () => onChanged(chip.$2),
            ),
          ],
        ],
      ),
    );
  }

  TripSearchFilters _copy(
    TripSearchFilters source, {
    bool clearVehicleForm = false,
    bool clearVehicleClass = false,
    bool clearDepartureSlot = false,
    bool clearOperator = false,
  }) {
    return TripSearchFilters(
      vehicleForm: clearVehicleForm ? null : source.vehicleForm,
      vehicleClass: clearVehicleClass ? null : source.vehicleClass,
      departureSlot: clearDepartureSlot ? null : source.departureSlot,
      priceMin: source.priceMin,
      priceMax: source.priceMax,
      amenityIds: source.amenityIds,
      operatorId: clearOperator ? null : source.operatorId,
      sort: source.sort,
    );
  }
}

class _ToolbarChip extends StatelessWidget {
  const _ToolbarChip({
    required this.label,
    required this.onTap,
    this.icon,
    this.trailing,
    this.count,
    this.selected = false,
    super.key,
  });

  final String label;
  final IconData? icon;
  final IconData? trailing;
  final int? count;
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
              if (icon != null) ...[
                Icon(icon, size: 16, color: _primaryDark),
                const SizedBox(width: 6),
              ],
              Text(
                label,
                style: const TextStyle(color: _primaryDark, fontSize: 11.5),
              ),
              if (count != null) ...[
                const SizedBox(width: 7),
                Container(
                  width: 19,
                  height: 19,
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                    color: _primary,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    '$count',
                    style: const TextStyle(color: Colors.white, fontSize: 10),
                  ),
                ),
              ],
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
    super.key,
  });

  final TripSummary trip;
  final String fromLabel;
  final String toLabel;
  final VoidCallback onOpenDetail;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xFFFFFEFD),
      borderRadius: BorderRadius.circular(20),
      clipBehavior: Clip.antiAlias,
      elevation: 0,
      child: InkWell(
        onTap: onOpenDetail,
        child: Ink(
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
          padding: const EdgeInsets.fromLTRB(13, 11, 0, 0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 13),
                child: _TripOperatorHeader(trip: trip),
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
        OperatorInitialAvatar(name: trip.operatorName, size: 38),
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
                city: _compactPlace(fromLabel),
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
                city: _compactPlace(toLabel),
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
                          onChanged: (value) => setState(() => _price = value),
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
      priceMin: lowChanged ? price.start.round() : null,
      priceMax: highChanged ? price.end.round() : null,
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
