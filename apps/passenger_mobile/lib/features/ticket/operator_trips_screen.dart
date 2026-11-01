part of 'ticket_screen.dart';

/// Chuyến sắp chạy của một nhà xe, mở từ trang nhà xe; cùng nguồn "chuyến sắp
/// chạy" với tab Mua vé nên chưa cần chọn điểm đi / đến hay ngày.
class OperatorTripsScreen extends StatefulWidget {
  const OperatorTripsScreen({
    required this.operatorId,
    required this.operatorName,
    required this.browseTrips,
    this.onTripSelected,
    super.key,
  });

  final String operatorId;
  final String operatorName;
  final TripBrowseRunner browseTrips;
  final void Function(TripSummary trip, HomeSearchQuery? query)? onTripSelected;

  @override
  State<OperatorTripsScreen> createState() => _OperatorTripsScreenState();
}

class _OperatorTripsScreenState extends State<OperatorTripsScreen> {
  final _scrollController = ScrollController();
  late final _filters = TripSearchFilters(operatorId: widget.operatorId);
  TripSearchPage? _page;
  List<TripSummary> _trips = const [];
  bool _loading = true;
  bool _loadingMore = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_maybeLoadMore);
    _load();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    // Kéo làm mới giữ nguyên danh sách đang xem cho tới khi có dữ liệu mới.
    setState(() {
      _loading = _trips.isEmpty;
      _error = null;
    });
    try {
      final page = await widget.browseTrips(_filters, 1);
      if (!mounted) return;
      setState(() {
        _page = page;
        _trips = page.items;
        _loading = false;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _error = _describeSearchError(error);
      });
    }
  }

  Future<void> _maybeLoadMore() async {
    final page = _page;
    if (page == null ||
        !page.hasMore ||
        _loading ||
        _loadingMore ||
        !_scrollController.hasClients) {
      return;
    }
    final position = _scrollController.position;
    if (position.pixels < position.maxScrollExtent - 400) return;
    setState(() => _loadingMore = true);
    try {
      final next = await widget.browseTrips(_filters, page.page + 1);
      if (!mounted) return;
      setState(() {
        _page = next;
        _trips = [..._trips, ...next.items];
        _loadingMore = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _loadingMore = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: const Key('operator-trips-screen'),
      backgroundColor: _pageBackground,
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.dark.copyWith(
          statusBarColor: Colors.transparent,
        ),
        child: SafeArea(
          bottom: false,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(6, 8, 16, 10),
                child: Row(
                  children: [
                    IconButton(
                      key: const Key('operator-trips-back'),
                      tooltip: 'Quay lại',
                      onPressed: () => Navigator.of(context).maybePop(),
                      icon: const Icon(
                        Icons.arrow_back_rounded,
                        color: _primaryDark,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Chuyến của ${widget.operatorName}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: _primaryDark,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const Text(
                            'Chuyến sắp chạy trong 14 ngày tới',
                            style: TextStyle(color: _secondary, fontSize: 12.5),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(child: _body()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _body() {
    if (_loading) {
      return const Center(
        child: CircularProgressIndicator(key: Key('operator-trips-loading')),
      );
    }
    final error = _error;
    if (error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: _ResultMessage(
            icon: Icons.wifi_off_outlined,
            message: error,
            actionLabel: 'Thử lại',
            onAction: _load,
          ),
        ),
      );
    }
    if (_trips.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: _ResultMessage(
            key: Key('operator-trips-empty'),
            icon: Icons.directions_bus_outlined,
            message: 'Nhà xe chưa có chuyến sắp chạy trong 14 ngày tới.',
          ),
        ),
      );
    }
    final bottom = MediaQuery.paddingOf(context).bottom;
    return RefreshIndicator(
      onRefresh: _load,
      child: ListView.separated(
        key: const Key('operator-trips-list'),
        controller: _scrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.fromLTRB(15, 4, 15, 24 + bottom),
        itemCount: _trips.length + (_loadingMore ? 1 : 0),
        separatorBuilder: (context, index) => const SizedBox(height: 14),
        itemBuilder: (context, index) {
          if (index == _trips.length) {
            return const Center(
              child: SizedBox.square(
                dimension: 26,
                child: CircularProgressIndicator(strokeWidth: 2.6),
              ),
            );
          }
          final trip = _trips[index];
          return _TripCard(
            key: ValueKey('operator-trip-${trip.tripId}'),
            trip: trip,
            fromLabel: trip.pickup.name,
            toLabel: trip.dropoff.name,
            dateLabel: formatVnDate(trip.pickup.plannedAt),
            onOpenDetail: () => widget.onTripSelected?.call(trip, null),
          );
        },
      ),
    );
  }
}
