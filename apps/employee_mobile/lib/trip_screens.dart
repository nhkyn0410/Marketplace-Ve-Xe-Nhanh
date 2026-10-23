import 'package:flutter/material.dart';

import 'demo_data.dart';
import 'design_system.dart';
import 'driver_app.dart' show DriverTabs;
import 'operation_screens.dart';
import 'ticket_screens.dart';

/// Danh sách nhiệm vụ mẫu theo ngày, có trạng thái tải và ngày không có chuyến.
class TripsScreen extends StatefulWidget {
  const TripsScreen({
    super.key,
    required this.trips,
    required this.onTabSelected,
  });
  final List<DemoTrip> trips;
  final ValueChanged<int> onTabSelected;
  @override
  State<TripsScreen> createState() => _TripsScreenState();
}

class _TripsScreenState extends State<TripsScreen>
    with AutomaticKeepAliveClientMixin<TripsScreen> {
  var _date = DateTime(2026, 10, 14);
  bool _loading = false;
  int _loadRequest = 0;
  bool get _isDemoDate => _date == DateTime(2026, 10, 14);
  bool get _hasTrips => _isDemoDate && widget.trips.isNotEmpty;

  @override
  bool get wantKeepAlive => true;

  Future<void> _changeDay(int offset) async {
    final request = ++_loadRequest;
    setState(() {
      _date = _date.add(Duration(days: offset));
      _loading = true;
    });
    await Future<void>.delayed(const Duration(milliseconds: 350));
    if (mounted && request == _loadRequest) setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Column(
      children: [
        Container(
          color: Theme.of(context).colorScheme.surface,
          padding: const EdgeInsets.fromLTRB(24, 22, 24, 26),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Chào Minh,',
                          style: driverText(
                            14,
                            FontWeight.w500,
                            DriverColors.secondary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Chuyến của tôi',
                          style: driverText(30, FontWeight.w700),
                        ),
                      ],
                    ),
                  ),
                  const FigmaAsset(
                    'trips-imgIconNhanVienDiNon',
                    width: 72,
                    height: 72,
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                '${_hasTrips ? widget.trips.length : 0} chuyến được phân công',
                style: driverText(12, FontWeight.w400, DriverColors.secondary),
              ),
              const SizedBox(height: 20),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: DriverColors.navy,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: ColoredBox(
            color: DriverColors.canvas,
            child: RefreshIndicator(
              onRefresh: () => _changeDay(0),
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(24, 20, 24, 20),
                children: [
                  GestureDetector(
                    onHorizontalDragEnd: (d) {
                      if ((d.primaryVelocity ?? 0).abs() > 80) {
                        _changeDay((d.primaryVelocity ?? 0) < 0 ? 1 : -1);
                      }
                    },
                    child: SizedBox(
                      height: 48,
                      child: Row(
                        children: [
                          IconButton(
                            tooltip: 'Ngày trước',
                            onPressed: () => _changeDay(-1),
                            icon: const FigmaAsset(
                              'trips-imgGroup2',
                              width: 7,
                              height: 12,
                            ),
                          ),
                          Expanded(
                            child: Text(
                              '${_isDemoDate ? 'Ngày mẫu · ' : ''}${_date.day}/${_date.month}/${_date.year}',
                              textAlign: TextAlign.center,
                              style: driverText(
                                14,
                                FontWeight.w500,
                                DriverColors.text,
                              ),
                            ),
                          ),
                          IconButton(
                            tooltip: 'Ngày sau',
                            onPressed: () => _changeDay(1),
                            icon: const FigmaAsset(
                              'trips-imgGroup3',
                              width: 7,
                              height: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  if (_loading)
                    const Padding(
                      padding: EdgeInsets.all(48),
                      child: Center(child: CircularProgressIndicator()),
                    )
                  else if (!_hasTrips)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 70),
                      child: Column(
                        children: [
                          const FigmaAsset(
                            'detail-imgFrame',
                            width: 48,
                            height: 48,
                          ),
                          const SizedBox(height: 20),
                          Text(
                            'Chưa có chuyến được phân công',
                            style: driverText(
                              18,
                              FontWeight.w600,
                              DriverColors.navy,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            _isDemoDate
                                ? 'Nhà xe chưa phân công chuyến cho ngày này.'
                                : 'Dữ liệu minh họa nằm ở ngày 14/10/2026.',
                            style: driverText(
                              14,
                              FontWeight.w400,
                              DriverColors.secondary,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          if (!_isDemoDate)
                            TextButton(
                              onPressed: () {
                                setState(() => _date = DateTime(2026, 10, 14));
                              },
                              child: const Text('Về ngày có chuyến mẫu'),
                            ),
                        ],
                      ),
                    )
                  else
                    for (var i = 0; i < widget.trips.length; i++) ...[
                      if (i > 0) ...[
                        const SizedBox(height: 16),
                        Text(
                          'Chuyến tiếp theo',
                          style: driverText(
                            14,
                            FontWeight.w500,
                            DriverColors.secondary,
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],
                      _TripCard(
                        trip: widget.trips[i],
                        nearest: i == 0,
                        onOpen: () async {
                          await openDriverPage(
                            context,
                            TripDetailScreen(
                              trip: widget.trips[i],
                              onTabSelected: widget.onTabSelected,
                            ),
                          );
                          if (mounted) setState(() {});
                        },
                      ),
                    ],
                ],
              ),
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
    required this.nearest,
    required this.onOpen,
  });
  final DemoTrip trip;
  final bool nearest;
  final VoidCallback onOpen;
  @override
  Widget build(BuildContext context) => DriverCard(
    radius: nearest ? 24 : 16,
    border: !nearest,
    child: Column(
      children: [
        ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 24),
          child: Row(
            children: [
              if (nearest)
                Expanded(
                  child: Text(
                    'Chuyến gần nhất',
                    style: driverText(16, FontWeight.w600),
                  ),
                ),
              if (!nearest) const Spacer(),
              StatusPill(
                trip.status,
                neutral: !nearest && trip.status == 'Chưa khởi hành',
                success: trip.status == 'Hoàn thành',
              ),
            ],
          ),
        ),
        SizedBox(height: nearest ? 70 / 3 : 7),
        ConstrainedBox(
          constraints: BoxConstraints(minHeight: nearest ? 74 : 48),
          child: TripRoute(trip: trip, stations: nearest),
        ),
        SizedBox(height: nearest ? 70 / 3 : 7),
        ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 18),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  '${trip.plate} · ${trip.passengers.length} khách',
                  style: driverText(
                    12,
                    FontWeight.w400,
                    DriverColors.secondary,
                  ),
                ),
              ),
              Text(
                trip.id,
                style: driverText(12, FontWeight.w400, DriverColors.secondary),
              ),
            ],
          ),
        ),
        SizedBox(height: nearest ? 70 / 3 : 7),
        SwipeAction(
          label: 'Xem chuyến',
          onComplete: onOpen,
          arrowAsset: 'trips-imgFrame',
          chevronAsset: 'trips-imgFrame1',
        ),
      ],
    ),
  );
}

/// Tuyến xe, giờ xuất phát và điểm đón trả của chuyến được chọn.
class TripRoute extends StatelessWidget {
  const TripRoute({
    super.key,
    required this.trip,
    this.stations = true,
    this.onBrand = false,
  });
  final DemoTrip trip;
  final bool stations;
  final bool onBrand;
  @override
  Widget build(BuildContext context) {
    final color = onBrand ? Colors.white : DriverColors.navy;
    final secondary = onBrand ? Colors.white70 : DriverColors.secondary;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(trip.origin, style: driverText(22, FontWeight.w600, color)),
              Text(
                onBrand ? 'Đi' : 'Đi · ${trip.departure}',
                style: driverText(12, FontWeight.w400, secondary),
              ),
              if (stations) ...[
                const SizedBox(height: 4),
                Text(
                  trip.pickup,
                  style: driverText(11, FontWeight.w400, secondary),
                ),
              ],
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 5),
          child: Row(
            children: [
              FigmaAsset(
                onBrand ? 'detail-imgNetDtTrai' : 'trips-imgNetDtTrai',
                width: 28,
                height: 2,
              ),
              const SizedBox(width: 8),
              FigmaAsset(
                onBrand ? 'detail-imgGroup3' : 'trips-imgGroup4',
                width: 18,
                height: 21,
              ),
              const SizedBox(width: 8),
              FigmaAsset(
                onBrand ? 'detail-imgNetDtTrai' : 'trips-imgNetDtTrai',
                width: 28,
                height: 2,
              ),
            ],
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                trip.destination,
                textAlign: TextAlign.right,
                style: driverText(22, FontWeight.w600, color),
              ),
              Text(
                'Điểm trả',
                style: driverText(12, FontWeight.w400, secondary),
              ),
              if (stations) ...[
                const SizedBox(height: 4),
                Text(
                  trip.dropoff,
                  textAlign: TextAlign.right,
                  style: driverText(11, FontWeight.w400, secondary),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

/// Chi tiết hành trình và các lối vào tác nghiệp của tài xế.
class TripDetailScreen extends StatefulWidget {
  const TripDetailScreen({
    super.key,
    required this.trip,
    required this.onTabSelected,
  });
  final DemoTrip trip;
  final ValueChanged<int> onTabSelected;
  @override
  State<TripDetailScreen> createState() => _TripDetailScreenState();
}

class _TripDetailScreenState extends State<TripDetailScreen> {
  void _startBoarding() {
    if (widget.trip.status == 'Sắp khởi hành' ||
        widget.trip.status == 'Chưa khởi hành') {
      setState(() => widget.trip.status = 'Đón khách');
      showDemoNotice(
        context,
        'Bản mẫu: đã bắt đầu đón khách trong phiên, chưa gửi máy chủ.',
      );
    }
    _openOperations();
  }

  Future<void> _openOperations() async {
    await openDriverPage(context, OperationsScreen(trip: widget.trip));
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final trip = widget.trip;
    return DriverPage(
      statusBackground: DriverColors.cream,
      statusAsset: 'detail-imgTinHiuWiFiPin',
      bottom: DriverTabs(onSelected: widget.onTabSelected),
      child: Column(
        children: [
          DriverHeading(
            trip.id,
            subtitle: '14/10/2026 · ${trip.departure}',
            large: true,
            padding: const EdgeInsets.fromLTRB(24, 12, 24, 26),
            background: DriverColors.cream,
            backAsset: 'detail-imgGroup2',
            trailing: Container(
              width: 56,
              height: 56,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: const FigmaAsset('detail-imgFrame', width: 31, height: 31),
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 20),
              children: [
                DriverCard(
                  color: DriverColors.teal,
                  radius: 24,
                  child: Column(
                    children: [
                      ConstrainedBox(
                        constraints: const BoxConstraints(minHeight: 24),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                '${trip.id} · Hành trình',
                                style: driverText(
                                  14,
                                  FontWeight.w500,
                                  Colors.white,
                                ),
                              ),
                            ),
                            StatusPill(trip.status),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      ConstrainedBox(
                        constraints: const BoxConstraints(minHeight: 96),
                        child: TripRoute(trip: trip, onBrand: true),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                DriverCard(
                  color: DriverColors.canvas,
                  padding: 0,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: const Color(0xfff4f5f6),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const FigmaAsset(
                            'detail-imgGroup',
                            width: 16,
                            height: 20,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                trip.plate,
                                style: driverText(
                                  22,
                                  FontWeight.w600,
                                  DriverColors.text,
                                ).copyWith(height: 24 / 22),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Xe giường nằm',
                                style: driverText(
                                  12,
                                  FontWeight.w400,
                                  DriverColors.secondary,
                                ).copyWith(height: 1.5),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                DriverCard(
                  color: DriverColors.cream,
                  padding: 0,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 11,
                    ),
                    child: Row(
                      children: [
                        const SizedBox(
                          width: 24,
                          height: 24,
                          child: Center(
                            child: FigmaAsset(
                              'detail-imgGroup4',
                              width: 20,
                              height: 20,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Ghi chú vận hành',
                                style: driverText(
                                  12,
                                  FontWeight.w400,
                                  DriverColors.warning,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                trip.operatingNote,
                                style: driverText(
                                  14,
                                  FontWeight.w500,
                                  DriverColors.text,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                DriverCard(
                  radius: 24,
                  border: true,
                  padding: 0,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    child: Column(
                      children: [
                        ConstrainedBox(
                          constraints: const BoxConstraints(minHeight: 24),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  '${trip.passengers.length} hành khách',
                                  style: driverText(16, FontWeight.w600),
                                ),
                              ),
                              Text(
                                'Chưa lên: ${trip.passengers.length - trip.boardedCount}',
                                style: driverText(
                                  12,
                                  FontWeight.w400,
                                  DriverColors.secondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),
                        SwipeAction(
                          label: 'Danh sách khách',
                          border: false,
                          onComplete: () async {
                            await openDriverPage(
                              context,
                              PassengerScreen(
                                trip: trip,
                                onTabSelected: widget.onTabSelected,
                              ),
                            );
                            if (mounted) setState(() {});
                          },
                          arrowAsset: 'detail-imgFrame1',
                          chevronAsset: 'detail-imgFrame2',
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                TextButton(
                  style: TextButton.styleFrom(
                    minimumSize: const Size.fromHeight(44),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                  ),
                  onPressed: _openOperations,
                  child: const Row(
                    children: [
                      FigmaAsset('detail-imgGroup5', width: 17, height: 17),
                      SizedBox(width: 8),
                      Text('← Vận hành'),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                TextButton(
                  style: TextButton.styleFrom(
                    minimumSize: const Size.fromHeight(44),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                  ),
                  onPressed: () =>
                      openDriverPage(context, IncidentScreen(trip: trip)),
                  child: Row(
                    children: [
                      const FigmaAsset(
                        'detail-imgGroup6',
                        width: 17,
                        height: 17,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Báo sự cố →',
                        style: driverText(
                          14,
                          FontWeight.w500,
                          DriverColors.warning,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(40, 14, 40, 12),
            child: SwipeAction(
              label:
                  trip.status == 'Sắp khởi hành' ||
                      trip.status == 'Chưa khởi hành'
                  ? 'Bắt đầu đón khách'
                  : 'Mở Vận hành',
              onComplete: _startBoarding,
              arrowAsset: 'detail-imgFrame1',
              chevronAsset: 'detail-imgFrame2',
            ),
          ),
        ],
      ),
    );
  }
}

/// Manifest mẫu có tìm kiếm, lọc trạng thái và kéo làm mới.
class PassengerScreen extends StatefulWidget {
  const PassengerScreen({
    super.key,
    required this.trip,
    required this.onTabSelected,
  });
  final DemoTrip trip;
  final ValueChanged<int> onTabSelected;
  @override
  State<PassengerScreen> createState() => _PassengerScreenState();
}

class _PassengerScreenState extends State<PassengerScreen> {
  final _search = TextEditingController();
  String _query = '';
  int _filter = 0;
  var _updated = '09:41';

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  Future<void> _openPassenger(DemoPassenger passenger) async {
    FocusScope.of(context).unfocus();
    await openDriverPage(
      context,
      TicketScreen(trip: widget.trip, passenger: passenger),
    );
    if (mounted) setState(() {});
  }

  void _showStops() {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Điểm đón / trả · ${widget.trip.id}',
                style: driverText(22, FontWeight.w700),
              ),
              const SizedBox(height: 20),
              Text(
                'Đón · ${widget.trip.pickup}',
                style: driverText(16, FontWeight.w600),
              ),
              const SizedBox(height: 12),
              Text('Trả · ${widget.trip.dropoff}', style: driverText(16)),
              const SizedBox(height: 20),
              Text(
                'Dữ liệu chuyến mẫu · ${widget.trip.passengers.length} hành khách',
                style: driverText(12, FontWeight.w400, DriverColors.secondary),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Đóng'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _refresh() async {
    await Future<void>.delayed(const Duration(milliseconds: 350));
    if (!mounted) return;
    final now = DateTime.now();
    setState(
      () => _updated =
          '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')} · Bản mẫu',
    );
  }

  @override
  Widget build(BuildContext context) {
    final trip = widget.trip;
    final passengers = trip.passengers
        .where(
          (p) =>
              (_filter == 0 || (_filter == 1 ? !p.boarded : p.boarded)) &&
              '${p.name} ${p.ticket} ${p.maskedPhone}'.toLowerCase().contains(
                _query.trim().toLowerCase(),
              ),
        )
        .toList();
    return DriverPage(
      statusAsset: 'manifest-imgTinHiuWiFiPin',
      bottom: DriverTabs(onSelected: widget.onTabSelected),
      child: Column(
        children: [
          DriverHeading(
            'Hành khách',
            subtitle:
                '${trip.id} · ${trip.departure} · ${trip.passengers.length} khách',
            backAsset: 'manifest-imgGroup3',
            foreground: DriverColors.navy,
            padding: const EdgeInsets.fromLTRB(20, 10, 24, 26),
            subtitleSpacing: 6,
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: _refresh,
              notificationPredicate: (notification) => notification.depth <= 1,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Column(
                        children: [
                          TextField(
                            controller: _search,
                            textInputAction: TextInputAction.search,
                            onSubmitted: (_) =>
                                FocusScope.of(context).unfocus(),
                            onTapOutside: (_) =>
                                FocusScope.of(context).unfocus(),
                            onChanged: (value) =>
                                setState(() => _query = value),
                            style: driverText(14),
                            decoration: InputDecoration(
                              hintText: 'Tên, mã vé, SĐT được phép',
                              suffixIcon: _query.isEmpty
                                  ? null
                                  : IconButton(
                                      tooltip: 'Xóa tìm kiếm',
                                      onPressed: () {
                                        _search.clear();
                                        setState(() => _query = '');
                                      },
                                      icon: const Icon(Icons.close, size: 18),
                                    ),
                              hintStyle: driverText(
                                14,
                                FontWeight.w500,
                                DriverColors.secondary,
                              ),
                              fillColor: DriverColors.canvas,
                              contentPadding: const EdgeInsets.symmetric(
                                vertical: 14,
                              ),
                              prefixIcon: const Padding(
                                padding: EdgeInsets.all(16),
                                child: FigmaAsset(
                                  'manifest-imgGroup4',
                                  width: 15.1333,
                                  height: 15.1333,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(24),
                                borderSide: BorderSide.none,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(24),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          GestureDetector(
                            onHorizontalDragEnd: (d) {
                              if ((d.primaryVelocity ?? 0).abs() < 80) return;
                              setState(
                                () => _filter =
                                    (_filter +
                                            ((d.primaryVelocity ?? 0) < 0
                                                ? 1
                                                : -1))
                                        .clamp(0, 2),
                              );
                            },
                            child: Row(
                              children: [
                                for (var i = 0; i < 3; i++)
                                  Expanded(
                                    flex: const [28, 39, 24][i],
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                        right: i < 2 ? 8 : 0,
                                      ),
                                      child: SizedBox(
                                        height: 36,
                                        child: Semantics(
                                          selected: _filter == i,
                                          child: OutlinedButton(
                                            style: OutlinedButton.styleFrom(
                                              padding: EdgeInsets.zero,
                                              backgroundColor: _filter == i
                                                  ? DriverColors.teal
                                                  : Colors.white,
                                              side: BorderSide(
                                                color: _filter == i
                                                    ? DriverColors.teal
                                                    : DriverColors.border,
                                              ),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
                                            ),
                                            onPressed: () =>
                                                setState(() => _filter = i),
                                            child: Text(
                                              i == 0
                                                  ? '↔ Tất cả · ${trip.passengers.length}'
                                                  : i == 1
                                                  ? 'Chưa lên · ${trip.passengers.length - trip.boardedCount}'
                                                  : 'Đã lên · ${trip.boardedCount}',
                                              style: driverText(
                                                12,
                                                FontWeight.w400,
                                                _filter == i
                                                    ? Colors.white
                                                    : DriverColors.secondary,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  'Đón · ${trip.pickup}',
                                  style: driverText(14, FontWeight.w500),
                                ),
                              ),
                              TextButton(
                                onPressed: _showStops,
                                style: TextButton.styleFrom(
                                  padding: EdgeInsets.zero,
                                  minimumSize: const Size(44, 20),
                                  tapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                ),
                                child: Text(
                                  'Xem →',
                                  style: driverText(
                                    12,
                                    FontWeight.w400,
                                    DriverColors.secondary,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Trả · ${trip.dropoff}',
                              style: driverText(
                                12,
                                FontWeight.w400,
                                DriverColors.secondary,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 300,
                      child: ListView(
                        key: const ValueKey('manifest-passengers'),
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        physics: const AlwaysScrollableScrollPhysics(
                          parent: ClampingScrollPhysics(),
                        ),
                        children: [
                          if (passengers.isEmpty)
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 50),
                              child: Text(
                                _query.trim().isEmpty
                                    ? 'Chưa có hành khách ở trạng thái này.'
                                    : 'Không tìm thấy hành khách.',
                                textAlign: TextAlign.center,
                                style: driverText(
                                  16,
                                  FontWeight.w500,
                                  DriverColors.secondary,
                                ),
                              ),
                            ),
                          for (final passenger in passengers)
                            _PassengerRow(
                              passenger: passenger,
                              onOpen: () => _openPassenger(passenger),
                            ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Text(
                        '$_updated · ↓ Kéo để cập nhật',
                        textAlign: TextAlign.center,
                        style: driverText(
                          12,
                          FontWeight.w400,
                          DriverColors.secondary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(40, 14, 40, 12),
            child: SwipeAction(
              label: 'Quét vé',
              borderColor: const Color(0xffcacdcf),
              onComplete: () async {
                await openDriverPage(context, ScannerScreen(trip: trip));
                if (mounted) setState(() {});
              },
              arrowAsset: 'manifest-imgFrame',
              chevronAsset: 'manifest-imgFrame1',
            ),
          ),
        ],
      ),
    );
  }
}

class _PassengerRow extends StatelessWidget {
  const _PassengerRow({required this.passenger, required this.onOpen});
  final DemoPassenger passenger;
  final VoidCallback onOpen;
  @override
  Widget build(BuildContext context) => GestureDetector(
    onHorizontalDragEnd: (details) {
      if ((details.primaryVelocity ?? 0) > 150) onOpen();
    },
    child: InkWell(
      onTap: onOpen,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Container(
          constraints: const BoxConstraints(minHeight: 100),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: const BoxDecoration(
            border: Border(bottom: BorderSide(color: DriverColors.canvas)),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: DriverColors.cream,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      passenger.seat,
                      style: driverText(
                        16,
                        FontWeight.w600,
                        DriverColors.warning,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          passenger.name,
                          style: driverText(
                            16,
                            FontWeight.w600,
                          ).copyWith(height: 22 / 16),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          passenger.maskedPhone,
                          style: driverText(
                            12,
                            FontWeight.w400,
                            DriverColors.secondary,
                          ).copyWith(height: 1.5),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                    height: 20,
                    child: Center(
                      child: FigmaAsset(
                        'manifest-imgGroup2',
                        width: 6.8,
                        height: 11.8,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              ConstrainedBox(
                constraints: const BoxConstraints(minHeight: 24),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        '${passenger.ticket} · Vé hợp lệ',
                        style: driverText(
                          12,
                          FontWeight.w400,
                          DriverColors.secondary,
                        ),
                      ),
                    ),
                    StatusPill(
                      passenger.boarded ? 'Đã lên' : 'Chưa lên',
                      success: passenger.boarded,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
