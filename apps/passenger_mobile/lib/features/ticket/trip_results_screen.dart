part of 'ticket_screen.dart';

/// Màn Kết quả "Chọn chuyến": chọn chuyến theo điều kiện đã nhập (Figma
/// "Kết quả tìm kiếm · Thanh lọc nổi"). Không có thanh điều hướng 5 mục; lọc,
/// sắp xếp, đổi ngày nằm ở thanh công cụ nổi cố định phía dưới.
class TripResultsScreen extends StatefulWidget {
  const TripResultsScreen({
    required this.query,
    this.searchTrips,
    this.searchCatalog,
    this.onTripSelected,
    this.initialFilters = const TripSearchFilters(),
    this.operatorName,
    super.key,
  });

  final HomeSearchQuery query;
  final TripSearchRunner? searchTrips;
  final TripSearchCatalog? searchCatalog;
  final void Function(TripSummary trip, HomeSearchQuery? query)? onTripSelected;

  /// Bộ lọc mở sẵn, vd. nhánh khám phá theo nhà xe lọc sẵn một nhà xe.
  final TripSearchFilters initialFilters;

  /// Tên nhà xe đang lọc sẵn — vẫn hiện trên chip khi kết quả không còn chuyến
  /// nào của nhà xe để lấy tên.
  final String? operatorName;

  @override
  State<TripResultsScreen> createState() => _TripResultsScreenState();
}

class _TripResultsScreenState extends State<TripResultsScreen> {
  final _scrollController = ScrollController();
  late HomeSearchQuery _query;
  late TripSearchFilters _filters;
  String? _operatorName;
  TripSearchPage? _page;
  List<TripSummary> _trips = const [];
  bool _loading = true;
  bool _loadingMore = false;
  String? _error;
  int _request = 0;

  @override
  void initState() {
    super.initState();
    _query = widget.query;
    _filters = widget.initialFilters;
    _operatorName = widget.operatorName;
    // Tìm "Theo nhà xe" ở Trang chủ: chuyển nhà xe thành bộ lọc để gỡ được
    // bằng chip như nhánh khám phá nhà xe.
    final operator = _query.operator;
    if (_query.mode == HomeSearchMode.operator && operator != null) {
      _query = HomeSearchQuery(
        mode: HomeSearchMode.route,
        from: _query.from,
        to: _query.to,
        date: _query.date,
        passengers: _query.passengers,
      );
      _filters = TripSearchFilters(
        vehicleForm: _filters.vehicleForm,
        vehicleClass: _filters.vehicleClass,
        departureSlot: _filters.departureSlot,
        priceMin: _filters.priceMin,
        priceMax: _filters.priceMax,
        amenityIds: _filters.amenityIds,
        operatorId: operator.id,
        sort: _filters.sort,
      );
      _operatorName ??= operator.name;
    }
    _scrollController.addListener(_maybeLoadMore);
    _search();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final insets = MediaQuery.paddingOf(context);
    final loaded = !_loading && _error == null;
    return Scaffold(
      key: const Key('trip-results-screen'),
      backgroundColor: _pageBackground,
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.light,
          systemNavigationBarColor: Colors.transparent,
          systemNavigationBarIconBrightness: Brightness.dark,
          systemNavigationBarContrastEnforced: false,
        ),
        child: DecoratedBox(
          decoration: const BoxDecoration(gradient: _pageGradient),
          child: Stack(
            children: [
              CustomScrollView(
                key: const Key('trip-results-scroll'),
                controller: _scrollController,
                slivers: [
                  SliverToBoxAdapter(
                    child: _ResultsHeader(
                      query: _query,
                      durationMinutes: _trips.firstOrNull?.durationMinutes,
                      onBack: () => Navigator.of(context).maybePop(),
                      onEdit: _openEditSheet,
                    ),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(15, 17, 15, 0),
                    sliver: SliverToBoxAdapter(
                      child: _DateStrip(
                        key: const Key('results-date-strip'),
                        selected: _query.date,
                        onSelected: _changeDate,
                      ),
                    ),
                  ),
                  if (_filters.activeCount > 0)
                    SliverPadding(
                      padding: const EdgeInsets.fromLTRB(16, 18, 16, 0),
                      sliver: SliverToBoxAdapter(
                        child: _ActiveFilterChips(
                          filters: _filters,
                          operators: _page?.operators ?? const [],
                          operatorName: _operatorName,
                          onChanged: _applyFilters,
                        ),
                      ),
                    ),
                  if (loaded)
                    SliverPadding(
                      padding: const EdgeInsets.fromLTRB(17, 18, 17, 12),
                      sliver: SliverToBoxAdapter(
                        child: _ResultSummary(
                          total: _page?.total ?? _trips.length,
                          sort: _filters.sort,
                          onSort: _openSortSheet,
                        ),
                      ),
                    ),
                  ..._resultSlivers(),
                  SliverToBoxAdapter(
                    child: SizedBox(height: 100 + insets.bottom),
                  ),
                ],
              ),
              Positioned(
                left: 16,
                right: 16,
                bottom: insets.bottom + 12,
                child: _FloatingTools(
                  filterCount: _filters.activeCount,
                  onFilter: _openFilters,
                  onSort: _openSortSheet,
                  onChangeDate: _openDateSheet,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _resultSlivers() {
    if (_loading) {
      return const [
        SliverPadding(
          padding: EdgeInsets.only(top: 40),
          sliver: SliverToBoxAdapter(
            child: Center(
              child: CircularProgressIndicator(key: Key('results-loading')),
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
            onAction: _search,
          ),
          bottom: 0,
        ),
      ];
    }
    if (_trips.isEmpty) {
      final filtered = _filters.activeCount > 0;
      return [
        _messageSliver(
          _ResultMessage(
            key: const Key('results-empty'),
            icon: Icons.directions_bus_outlined,
            message: filtered
                ? 'Không có chuyến khớp bộ lọc. Hãy bỏ bớt bộ lọc.'
                : 'Chưa có chuyến phù hợp. Hãy thử ngày khác hoặc địa điểm khác.',
            actionLabel: filtered ? 'Bỏ lọc' : null,
            onAction: filtered ? () => _applyFilters(_filters.cleared()) : null,
          ),
          bottom: 0,
        ),
      ];
    }
    final query = _query;
    final hasMore = _page?.hasMore ?? false;
    return [
      ..._widenedSlivers(_page),
      SliverPadding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        sliver: SliverList.separated(
          itemBuilder: (context, index) {
            final trip = _trips[index];
            return _TripCard(
              key: ValueKey('results-trip-${trip.tripId}'),
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
        padding: const EdgeInsets.only(top: 18),
        sliver: SliverToBoxAdapter(
          child: Center(
            child: _loadingMore
                ? const SizedBox.square(
                    dimension: 26,
                    child: CircularProgressIndicator(strokeWidth: 2.6),
                  )
                : hasMore
                ? const SizedBox.shrink()
                : const Text(
                    'Đã hiển thị tất cả chuyến phù hợp',
                    key: Key('results-end'),
                    style: TextStyle(
                      color: _secondary,
                      fontSize: 12,
                      height: 1.5,
                    ),
                  ),
          ),
        ),
      ),
    ];
  }

  Future<void> _search() async {
    final runner = widget.searchTrips;
    final request = ++_request;
    setState(() {
      _loading = true;
      _loadingMore = false;
      _error = null;
      _trips = const [];
    });
    if (runner == null) {
      setState(() {
        _loading = false;
        _error = 'Tìm chuyến hiện chưa khả dụng.';
      });
      return;
    }
    try {
      final page = await runner(_query, _filters, 1);
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
    final page = _page;
    final runner = widget.searchTrips;
    if (page == null ||
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
      final next = await runner(_query, _filters, page.page + 1);
      if (!mounted || request != _request) return;
      setState(() {
        _page = next;
        _trips = [..._trips, ...next.items];
        _loadingMore = false;
      });
    } catch (_) {
      if (!mounted || request != _request) return;
      setState(() => _loadingMore = false);
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          const SnackBar(
            content: Text('Không tải thêm được chuyến. Vui lòng thử lại.'),
          ),
        );
    }
  }

  void _applyFilters(TripSearchFilters filters) {
    _filters = filters;
    _search();
  }

  void _changeDate(DateTime date) {
    if (_sameDay(date, _query.date)) return;
    _query = HomeSearchQuery(
      mode: _query.mode,
      from: _query.from,
      to: _query.to,
      date: date,
      passengers: _query.passengers,
      operator: _query.operator,
    );
    _search();
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
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _SortSheet(initial: _filters.sort),
    );
    if (selected != null && selected != _filters.sort && mounted) {
      _applyFilters(_filters.withSort(selected));
    }
  }

  Future<void> _openDateSheet() async {
    final selected = await showModalBottomSheet<DateTime>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _DateSheet(initial: _query.date),
    );
    if (selected != null && mounted) _changeDate(selected);
  }

  Future<void> _openEditSheet() async {
    final query = await showModalBottomSheet<HomeSearchQuery>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _SearchConditionSheet(
        title: 'Sửa tìm kiếm',
        actionLabel: 'Cập nhật kết quả',
        catalog: widget.searchCatalog,
        initial: _query,
      ),
    );
    if (query == null || !mounted) return;
    _query = query;
    _search();
  }
}

bool _sameDay(DateTime a, DateTime b) =>
    a.year == b.year && a.month == b.month && a.day == b.day;

/// 5 ngày quanh ngày đang chọn (lùi 2 ngày), không lùi về trước hôm nay.
List<DateTime> _stripDays(DateTime selected) {
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  var start = DateTime(selected.year, selected.month, selected.day - 2);
  if (start.isBefore(today)) start = today;
  return [
    for (var i = 0; i < 5; i++)
      DateTime(start.year, start.month, start.day + i),
  ];
}

/// Ảnh nền, nút quay lại, tiêu đề "Chọn chuyến" và thẻ tóm tắt hành trình.
class _ResultsHeader extends StatelessWidget {
  const _ResultsHeader({
    required this.query,
    required this.durationMinutes,
    required this.onBack,
    required this.onEdit,
  });

  final HomeSearchQuery query;
  final int? durationMinutes;
  final VoidCallback onBack;
  final VoidCallback onEdit;

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
            14,
            MediaQuery.paddingOf(context).top + 2,
            15,
            0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  SizedBox.square(
                    dimension: 44,
                    child: IconButton(
                      key: const Key('results-back'),
                      tooltip: 'Quay lại',
                      onPressed: onBack,
                      icon: SvgPicture.asset(
                        '$_resultsAssetRoot/back.svg',
                        width: 19.58,
                        height: 19.58,
                        excludeFromSemantics: true,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Chọn chuyến',
                    style: TextStyle(
                      color: _primaryDark,
                      fontSize: 15.66,
                      height: 21.93 / 15.66,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 33),
              Padding(
                padding: const EdgeInsets.only(left: 1),
                child: _SearchSummaryCard(
                  query: query,
                  durationMinutes: durationMinutes,
                  onEdit: onEdit,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// Tóm tắt hành trình (Figma "Search summary / journey").
class _SearchSummaryCard extends StatelessWidget {
  const _SearchSummaryCard({
    required this.query,
    required this.durationMinutes,
    required this.onEdit,
  });

  final HomeSearchQuery query;
  final int? durationMinutes;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    const metaStyle = TextStyle(
      color: _primaryDark,
      fontSize: 11.75,
      height: 16.45 / 11.75,
    );
    return Container(
      key: const Key('results-summary'),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.36),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1421404F),
            offset: Offset(0, 7.048),
            blurRadius: 9.398,
          ),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 16, 14, 13),
            child: Row(
              children: [
                Container(
                  width: 34.46,
                  height: 34.46,
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                    color: Color(0xFFE2F1F8),
                    shape: BoxShape.circle,
                  ),
                  child: SvgPicture.asset(
                    '$_resultsAssetRoot/station.svg',
                    width: 16.45,
                    height: 16.45,
                    excludeFromSemantics: true,
                  ),
                ),
                const SizedBox(width: 9.6),
                Expanded(child: _SummaryPlace(location: query.from)),
                const SizedBox(width: 8),
                _SummaryRoute(durationMinutes: durationMinutes),
                const SizedBox(width: 12),
                SvgPicture.asset(
                  '$_resultsAssetRoot/pin.svg',
                  width: 17.23,
                  height: 17.23,
                  excludeFromSemantics: true,
                ),
                const SizedBox(width: 11),
                Expanded(child: _SummaryPlace(location: query.to)),
              ],
            ),
          ),
          const Divider(
            height: 1.17,
            thickness: 1.17,
            color: Color(0xFFEDF0F2),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(22, 0, 4, 0),
            child: Row(
              children: [
                // Ngày chỉ co lại khi thật sự thiếu chỗ (không chia đều với khoảng trống).
                Expanded(
                  child: Row(
                    children: [
                      SvgPicture.asset(
                        '$_resultsAssetRoot/calendar.svg',
                        width: 14.1,
                        height: 14.1,
                        excludeFromSemantics: true,
                      ),
                      const SizedBox(width: 7),
                      Flexible(
                        child: Text(
                          '${formatVnWeekday(query.date)}, '
                          '${formatSearchDate(query.date)}',
                          key: const Key('results-summary-date'),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: metaStyle,
                        ),
                      ),
                      Container(
                        width: 0.83,
                        height: 14.88,
                        margin: const EdgeInsets.symmetric(horizontal: 18),
                        color: const Color(0xFFA4B3BD),
                      ),
                      SvgPicture.asset(
                        '$_resultsAssetRoot/user.svg',
                        width: 14.1,
                        height: 14.1,
                        excludeFromSemantics: true,
                      ),
                      const SizedBox(width: 7),
                      Text('${query.passengers} khách', style: metaStyle),
                    ],
                  ),
                ),
                Material(
                  type: MaterialType.transparency,
                  child: InkWell(
                    key: const Key('results-edit-search'),
                    onTap: onEdit,
                    customBorder: const CircleBorder(),
                    child: SizedBox.square(
                      dimension: 44,
                      child: Center(
                        child: Container(
                          width: 28.19,
                          height: 28.19,
                          alignment: Alignment.center,
                          decoration: const BoxDecoration(
                            color: Color(0xFFE2F1F8),
                            shape: BoxShape.circle,
                          ),
                          child: SvgPicture.asset(
                            '$_resultsAssetRoot/pencil.svg',
                            width: 15,
                            height: 15,
                            semanticsLabel: 'Sửa tìm kiếm',
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryPlace extends StatelessWidget {
  const _SummaryPlace({required this.location});

  final HomeLocation location;

  @override
  Widget build(BuildContext context) {
    final detail = location.detail;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          _compactPlace(location.name),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: _primaryDark,
            fontSize: 14.1,
            height: 19.74 / 14.1,
            fontWeight: FontWeight.w600,
          ),
        ),
        if (detail != null && detail.isNotEmpty)
          Text(
            detail,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: _secondary,
              fontSize: 10.18,
              height: 14.25 / 10.18,
            ),
          ),
      ],
    );
  }
}

/// Đường chấm nối điểm đi – điểm đến, xe khách ở giữa và thời gian đi.
class _SummaryRoute extends StatelessWidget {
  const _SummaryRoute({required this.durationMinutes});

  final int? durationMinutes;

  @override
  Widget build(BuildContext context) {
    final duration = durationMinutes;
    return SizedBox(
      width: 104,
      height: 40,
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          Positioned(
            left: 2.35,
            right: 2.35,
            top: 11.17,
            child: SvgPicture.asset(
              '$_resultsAssetRoot/route_line.svg',
              height: 1.17,
              fit: BoxFit.fill,
              excludeFromSemantics: true,
            ),
          ),
          for (final left in const [true, false])
            Positioned(
              left: left ? 0 : null,
              right: left ? null : 0,
              top: 9.4,
              child: SvgPicture.asset(
                '$_resultsAssetRoot/route_node.svg',
                width: 4.7,
                height: 4.7,
                excludeFromSemantics: true,
              ),
            ),
          Positioned(
            top: 0,
            child: Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 2.2),
              child: SvgPicture.asset(
                '$_resultsAssetRoot/bus.svg',
                width: 19.58,
                height: 19.58,
                excludeFromSemantics: true,
              ),
            ),
          ),
          if (duration != null)
            Positioned(
              top: 22.7,
              child: Text(
                formatTripDuration(duration),
                style: const TextStyle(
                  color: _secondary,
                  fontSize: 10.96,
                  height: 15.35 / 10.96,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// Dải 5 ngày để đổi nhanh ngày đi (Figma "Date selector").
class _DateStrip extends StatelessWidget {
  const _DateStrip({
    required this.selected,
    required this.onSelected,
    super.key,
  });

  final DateTime selected;
  final ValueChanged<DateTime> onSelected;

  @override
  Widget build(BuildContext context) {
    final days = _stripDays(selected);
    return Row(
      children: [
        for (var index = 0; index < days.length; index++) ...[
          if (index > 0) const SizedBox(width: 9.93),
          Expanded(
            child: _DateCell(
              day: days[index],
              selected: _sameDay(days[index], selected),
              onTap: () => onSelected(days[index]),
            ),
          ),
        ],
      ],
    );
  }
}

class _DateCell extends StatelessWidget {
  const _DateCell({
    required this.day,
    required this.selected,
    required this.onTap,
  });

  final DateTime day;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final style = TextStyle(
      color: selected ? Colors.white : _secondary,
      fontSize: 11.75,
      height: 16.45 / 11.75,
    );
    final label = formatSearchDate(day).substring(0, 5);
    return Material(
      color: selected ? _primary : Colors.white,
      borderRadius: BorderRadius.circular(16.45),
      child: InkWell(
        key: ValueKey('results-date-$label'),
        onTap: onTap,
        borderRadius: BorderRadius.circular(16.45),
        child: SizedBox(
          height: 55.6,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(formatVnWeekday(day), style: style),
                  const SizedBox(height: 1.57),
                  Text(label, style: style),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Thanh công cụ nổi cố định phía dưới: Lọc · Sắp xếp · Đổi ngày.
class _FloatingTools extends StatelessWidget {
  const _FloatingTools({
    required this.filterCount,
    required this.onFilter,
    required this.onSort,
    required this.onChangeDate,
  });

  final int filterCount;
  final VoidCallback onFilter;
  final VoidCallback onSort;
  final VoidCallback onChangeDate;

  @override
  Widget build(BuildContext context) {
    return Container(
      key: const Key('results-floating-tools'),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: const [
          BoxShadow(
            color: Color(0x292B7EAD),
            offset: Offset(0, 5.783),
            blurRadius: 7.711,
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: _ToolButton(
              key: const Key('results-filter'),
              asset: 'filter.svg',
              iconSize: 14.88,
              label: filterCount == 0 ? 'Lọc' : 'Lọc · $filterCount',
              active: filterCount > 0,
              onTap: onFilter,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _ToolButton(
              key: const Key('results-sort'),
              asset: 'sort.svg',
              iconSize: 14.88,
              label: 'Sắp xếp',
              onTap: onSort,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _ToolButton(
              key: const Key('results-change-date'),
              asset: 'calendar.svg',
              iconSize: 14.1,
              label: 'Đổi ngày',
              onTap: onChangeDate,
            ),
          ),
        ],
      ),
    );
  }
}

class _ToolButton extends StatelessWidget {
  const _ToolButton({
    required this.asset,
    required this.iconSize,
    required this.label,
    required this.onTap,
    this.active = false,
    super.key,
  });

  final String asset;
  final double iconSize;
  final String label;
  final VoidCallback onTap;
  final bool active;

  @override
  Widget build(BuildContext context) {
    final color = active ? _primary : _primaryDark;
    return Material(
      color: active ? _primarySoft : Colors.white,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: SizedBox(
          height: 48,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                '$_resultsAssetRoot/$asset',
                width: iconSize,
                height: iconSize,
                colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
                excludeFromSemantics: true,
              ),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: color,
                    fontSize: 13,
                    height: 20 / 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Chip điều kiện đang áp dụng; bấm để gỡ điều kiện đó.
class _ActiveFilterChips extends StatelessWidget {
  const _ActiveFilterChips({
    required this.filters,
    required this.operators,
    required this.onChanged,
    this.operatorName,
  });

  final TripSearchFilters filters;
  final List<TripOperatorFacet> operators;
  final ValueChanged<TripSearchFilters> onChanged;

  /// Tên nhà xe khi kết quả không có facet của nhà xe đang lọc.
  final String? operatorName;

  @override
  Widget build(BuildContext context) {
    final operatorId = filters.operatorId;
    final operatorLabel = operatorId == null
        ? null
        : operators
                  .where((operator) => operator.id == operatorId)
                  .map((operator) => operator.name)
                  .firstOrNull ??
              operatorName ??
              'Nhà xe đã chọn';
    final priceMin = filters.priceMin;
    final priceMax = filters.priceMax;
    final chips = <(String, TripSearchFilters)>[
      if (operatorLabel != null)
        (operatorLabel, _copy(filters, clearOperator: true)),
      if (filters.vehicleForm != null)
        (filters.vehicleForm!.label, _copy(filters, clearVehicleForm: true)),
      if (filters.vehicleClass != null)
        (filters.vehicleClass!.label, _copy(filters, clearVehicleClass: true)),
      if (filters.departureSlot != null)
        (
          filters.departureSlot!.label,
          _copy(filters, clearDepartureSlot: true),
        ),
      if (priceMin != null || priceMax != null)
        (
          '${formatVnd(priceMin ?? 0)} – '
              '${priceMax == null ? '…' : formatVnd(priceMax)}',
          _copy(filters, clearPrice: true),
        ),
      if (filters.amenityIds.isNotEmpty)
        (
          '${filters.amenityIds.length} tiện ích',
          _copy(filters, clearAmenities: true),
        ),
    ];
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (var index = 0; index < chips.length; index++) ...[
            if (index > 0) const SizedBox(width: 9),
            _ToolbarChip(
              key: ValueKey('results-chip-$index'),
              label: chips[index].$1,
              selected: true,
              trailing: Icons.close,
              onTap: () => onChanged(chips[index].$2),
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
    bool clearPrice = false,
    bool clearAmenities = false,
    bool clearOperator = false,
  }) {
    return TripSearchFilters(
      vehicleForm: clearVehicleForm ? null : source.vehicleForm,
      vehicleClass: clearVehicleClass ? null : source.vehicleClass,
      departureSlot: clearDepartureSlot ? null : source.departureSlot,
      priceMin: clearPrice ? null : source.priceMin,
      priceMax: clearPrice ? null : source.priceMax,
      amenityIds: clearAmenities ? const {} : source.amenityIds,
      operatorId: clearOperator ? null : source.operatorId,
      sort: source.sort,
    );
  }
}

/// Khung bottom sheet của trang Mua vé / Kết quả (Figma "Sheet / header").
class _ResultsSheet extends StatelessWidget {
  const _ResultsSheet({required this.title, required this.child, this.action});

  final String title;
  final Widget child;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.fromLTRB(
        24,
        20,
        24,
        24 + MediaQuery.paddingOf(context).bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Tên nhà xe dài thì tiêu đề xuống dòng thay vì bị cắt.
          ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 48),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: _primaryDark,
                      fontSize: 20,
                      height: 28 / 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                TextButton(
                  key: const Key('results-sheet-close'),
                  onPressed: () => Navigator.pop(context),
                  style: TextButton.styleFrom(
                    foregroundColor: _primary,
                    minimumSize: const Size(52, 44),
                  ),
                  child: const Text(
                    'Đóng',
                    style: TextStyle(
                      fontSize: 13,
                      height: 20 / 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          child,
          if (action != null) ...[const SizedBox(height: 16), action!],
        ],
      ),
    );
  }
}

/// Một lựa chọn có nút tròn (Figma "Results / Sheet option").
class _SheetOption extends StatelessWidget {
  const _SheetOption({
    required this.label,
    required this.selected,
    required this.onTap,
    super.key,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? _primarySoft : Colors.white,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: SizedBox(
          height: 48,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: [
                SvgPicture.asset(
                  '$_resultsAssetRoot/${selected ? 'radio_on' : 'radio_off'}.svg',
                  width: 20,
                  height: 20,
                  excludeFromSemantics: true,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: _primaryDark,
                      fontSize: 14,
                      height: 20 / 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SheetActionButton extends StatelessWidget {
  const _SheetActionButton({
    required this.label,
    required this.onPressed,
    super.key,
  });

  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: FilledButton(
        onPressed: onPressed,
        style: FilledButton.styleFrom(
          backgroundColor: _primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 15,
            height: 20 / 15,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

/// Thứ tự cách sắp xếp trong sheet (API chỉ hỗ trợ ba cách này).
const _sortOptions = [
  TripSearchSort.price,
  TripSearchSort.departure,
  TripSearchSort.duration,
];

class _SortSheet extends StatefulWidget {
  const _SortSheet({required this.initial});

  final TripSearchSort initial;

  @override
  State<_SortSheet> createState() => _SortSheetState();
}

class _SortSheetState extends State<_SortSheet> {
  late TripSearchSort _selected = widget.initial;

  @override
  Widget build(BuildContext context) {
    return _ResultsSheet(
      title: 'Sắp xếp chuyến',
      action: _SheetActionButton(
        key: const Key('results-sort-apply'),
        label: 'Áp dụng sắp xếp',
        onPressed: () => Navigator.pop(context, _selected),
      ),
      child: Column(
        children: [
          for (var index = 0; index < _sortOptions.length; index++) ...[
            if (index > 0) const SizedBox(height: 16),
            _SheetOption(
              key: ValueKey('results-sort-${_sortOptions[index].name}'),
              label: _sortOptions[index].label,
              selected: _sortOptions[index] == _selected,
              onTap: () => setState(() => _selected = _sortOptions[index]),
            ),
          ],
        ],
      ),
    );
  }
}

class _DateSheet extends StatefulWidget {
  const _DateSheet({required this.initial});

  final DateTime initial;

  @override
  State<_DateSheet> createState() => _DateSheetState();
}

class _DateSheetState extends State<_DateSheet> {
  late DateTime _selected = widget.initial;

  @override
  Widget build(BuildContext context) {
    return _ResultsSheet(
      title: 'Chọn ngày đi',
      action: _SheetActionButton(
        key: const Key('results-date-apply'),
        label: 'Áp dụng ngày đi',
        onPressed: () => Navigator.pop(context, _selected),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Tháng ${_selected.month}, ${_selected.year}',
            style: const TextStyle(
              color: _primaryDark,
              fontSize: 14,
              height: 20 / 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          _DateStrip(
            key: const Key('results-date-sheet-strip'),
            selected: _selected,
            onSelected: (day) => setState(() => _selected = day),
          ),
          const SizedBox(height: 16),
          Text(
            '${formatVnWeekday(_selected)}, ${formatSearchDate(_selected)}',
            style: const TextStyle(
              color: _secondary,
              fontSize: 13,
              height: 20 / 13,
            ),
          ),
        ],
      ),
    );
  }
}

/// Sửa điều kiện hành trình (điểm đi – đến, ngày, số khách): "Sửa tìm kiếm" ở
/// màn Kết quả và "Chuyến của …" (một nhà xe) ở nhánh khám phá nhà xe.
class _SearchConditionSheet extends StatefulWidget {
  const _SearchConditionSheet({
    required this.title,
    required this.actionLabel,
    required this.initial,
    this.catalog,
  });

  final String title;
  final String actionLabel;
  final HomeSearchQuery initial;
  final TripSearchCatalog? catalog;

  @override
  State<_SearchConditionSheet> createState() => _SearchConditionSheetState();
}

class _SearchConditionSheetState extends State<_SearchConditionSheet>
    with TripSearchFormState<_SearchConditionSheet> {
  @override
  TripSearchCatalog? get searchCatalog => widget.catalog;

  @override
  void initState() {
    super.initState();
    final initial = widget.initial;
    searchFrom = initial.from;
    searchTo = initial.to;
    searchDate = initial.date;
    searchPassengers = initial.passengers;
  }

  @override
  Widget build(BuildContext context) {
    return _ResultsSheet(
      title: widget.title,
      action: _SheetActionButton(
        key: const Key('results-condition-apply'),
        label: widget.actionLabel,
        onPressed: () {
          final query = buildSearchQuery();
          if (query != null) Navigator.pop(context, query);
        },
      ),
      child: Column(
        children: [
          _RouteInputs(
            key: const Key('results-route-inputs'),
            fromLabel: searchFrom?.name,
            toLabel: searchTo?.name,
            onPickFrom: () => pickSearchLocation(isOrigin: true),
            onPickTo: () => pickSearchLocation(isOrigin: false),
            onSwap: swapSearchLocations,
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _CompactInput(
                  key: const Key('ticket-date-input'),
                  icon: Icons.calendar_month_outlined,
                  label: formatSearchDate(searchDate),
                  onTap: pickSearchDate,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _CompactInput(
                  key: const Key('ticket-passenger-input'),
                  icon: Icons.person_outline,
                  label: '$searchPassengers khách',
                  onTap: pickSearchPassengers,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
