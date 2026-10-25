import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:passenger_mobile/features/home/route_dock_tabbar.dart';
import 'package:passenger_mobile/features/ticket/trip_detail_screen.dart';

const _assetRoot = 'assets/ticket';
const _homeAssetRoot = 'assets/home';
const _primary = Color(0xFF2B7EAD);
const _primaryDark = Color(0xFF09243D);
const _secondary = Color(0xFF607A8E);
const _pageBackground = Color(0xFFF4F8F9);

enum _TicketSearchMode { trip, operator }

class _TicketTrip {
  const _TicketTrip({
    required this.operatorName,
    required this.logoAsset,
    required this.vehicleAsset,
    required this.rating,
    required this.reviewCount,
    required this.departureTime,
    required this.arrivalTime,
    required this.vehicleType,
    required this.availableSeats,
    required this.price,
    this.urgent = false,
  });

  final String operatorName;
  final String logoAsset;
  final String vehicleAsset;
  final String rating;
  final String reviewCount;
  final String departureTime;
  final String arrivalTime;
  final String vehicleType;
  final int availableSeats;
  final String price;
  final bool urgent;
}

const _figmaTrips = <_TicketTrip>[
  _TicketTrip(
    operatorName: 'Phương Trang',
    logoAsset: '$_homeAssetRoot/operators/phuong_trang.png',
    vehicleAsset: '$_assetRoot/phuong_trang_bus.png',
    rating: '4.8',
    reviewCount: '1.2K đánh giá',
    departureTime: '07:00',
    arrivalTime: '13:30',
    vehicleType: 'Limousine 34 phòng',
    availableSeats: 4,
    price: '280.000 ₫',
    urgent: true,
  ),
  _TicketTrip(
    operatorName: 'Thành Bưởi',
    logoAsset: '$_homeAssetRoot/operators/thanh_buoi.png',
    vehicleAsset: '$_assetRoot/thanh_buoi_bus.png',
    rating: '4.6',
    reviewCount: '980 đánh giá',
    departureTime: '08:00',
    arrivalTime: '14:30',
    vehicleType: 'Limousine 24 phòng',
    availableSeats: 12,
    price: '320.000 ₫',
  ),
  _TicketTrip(
    operatorName: 'Điền Linh',
    logoAsset: '$_homeAssetRoot/operators/dien_linh.png',
    vehicleAsset: '$_assetRoot/dien_linh_bus.png',
    rating: '4.5',
    reviewCount: '420 đánh giá',
    departureTime: '09:00',
    arrivalTime: '15:30',
    vehicleType: 'Giường nằm cao cấp',
    availableSeats: 8,
    price: '250.000 ₫',
  ),
];

class TicketScreen extends StatefulWidget {
  const TicketScreen({required this.onTabSelected, super.key});

  final ValueChanged<int> onTabSelected;

  @override
  State<TicketScreen> createState() => _TicketScreenState();
}

class _TicketScreenState extends State<TicketScreen> {
  final _scrollController = ScrollController();
  _TicketSearchMode _mode = _TicketSearchMode.trip;
  bool _dockVisible = true;
  int _activeFilterCount = 3;

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
          child: SafeArea(
            bottom: false,
            child: NotificationListener<UserScrollNotification>(
              onNotification: _handleUserScroll,
              child: CustomScrollView(
                key: const Key('ticket-content-scroll'),
                controller: _scrollController,
                slivers: [
                  SliverToBoxAdapter(
                    child: _TicketHeader(
                      mode: _mode,
                      onModeChanged: (mode) => setState(() => _mode = mode),
                      onSearch: _showSearchFeedback,
                    ),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
                    sliver: SliverToBoxAdapter(
                      child: _ResultToolbar(
                        activeFilterCount: _activeFilterCount,
                        onFilter: _openFilters,
                        onSort: _showSortSheet,
                      ),
                    ),
                  ),
                  const SliverPadding(
                    padding: EdgeInsets.fromLTRB(16, 14, 16, 10),
                    sliver: SliverToBoxAdapter(child: _ResultSummary()),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(8, 0, 8, 142),
                    sliver: SliverList.separated(
                      itemBuilder: (context, index) => _TripCard(
                        key: ValueKey(
                          'ticket-trip-${_figmaTrips[index].operatorName}',
                        ),
                        trip: _figmaTrips[index],
                        onOpenDetail: index == 0
                            ? () => Navigator.of(context).push(
                                MaterialPageRoute<void>(
                                  builder: (_) => const TripDetailScreen(),
                                ),
                              )
                            : null,
                      ),
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 14),
                      itemCount: _figmaTrips.length,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
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

  void _showSearchFeedback() {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(
            _mode == _TicketSearchMode.trip
                ? 'Đang tìm chuyến TP.HCM → Đà Lạt.'
                : 'Đang tìm chuyến của Phương Trang.',
          ),
        ),
      );
  }

  Future<void> _openFilters() async {
    final result = await showModalBottomSheet<int>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      barrierColor: const Color(0x66102632),
      builder: (context) => const _TripFilterSheet(),
    );
    if (result != null && mounted) setState(() => _activeFilterCount = result);
  }

  void _showSortSheet() {
    showModalBottomSheet<void>(
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
              for (final label in const [
                'Giá từ thấp đến cao',
                'Giờ khởi hành sớm nhất',
                'Đánh giá cao nhất',
                'Thời gian di chuyển ngắn nhất',
              ])
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(label),
                  trailing: label == 'Giá từ thấp đến cao'
                      ? const Icon(Icons.check_circle, color: _primary)
                      : null,
                  onTap: () => Navigator.pop(context),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TicketHeader extends StatelessWidget {
  const _TicketHeader({
    required this.mode,
    required this.onModeChanged,
    required this.onSearch,
  });

  final _TicketSearchMode mode;
  final ValueChanged<_TicketSearchMode> onModeChanged;
  final VoidCallback onSearch;

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
          padding: const EdgeInsets.only(top: 22),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  'MUA VÉ',
                  style: TextStyle(
                    color: _primaryDark,
                    fontSize: 24,
                    height: 1.1,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 28),
              _JourneyPlanner(
                mode: mode,
                onModeChanged: onModeChanged,
                onSearch: onSearch,
              ),
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
    required this.onModeChanged,
    required this.onSearch,
  });

  final _TicketSearchMode mode;
  final ValueChanged<_TicketSearchMode> onModeChanged;
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
            child: mode == _TicketSearchMode.trip
                ? const _RouteInputs(key: ValueKey('ticket-route-inputs'))
                : const _OperatorInput(key: ValueKey('ticket-operator-input')),
          ),
          const SizedBox(height: 12),
          const Row(
            children: [
              Expanded(
                child: _CompactInput(
                  icon: Icons.calendar_month_outlined,
                  label: '10/10/2026',
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: _CompactInput(
                  icon: Icons.person_outline,
                  label: '1 khách',
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

  final _TicketSearchMode mode;
  final ValueChanged<_TicketSearchMode> onChanged;

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
              alignment: mode == _TicketSearchMode.trip
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
                  selected: mode == _TicketSearchMode.trip,
                  label: 'Theo chuyến',
                  asset: mode == _TicketSearchMode.trip
                      ? '$_homeAssetRoot/icons/search_mode_route_active.svg'
                      : '$_homeAssetRoot/icons/search_mode_route_inactive.svg',
                  onTap: () => onChanged(_TicketSearchMode.trip),
                ),
              ),
              Expanded(
                child: _ModeButton(
                  key: const Key('ticket-mode-operator'),
                  selected: mode == _TicketSearchMode.operator,
                  label: 'Theo nhà xe',
                  asset: mode == _TicketSearchMode.operator
                      ? '$_homeAssetRoot/icons/search_mode_operator_active.svg'
                      : '$_homeAssetRoot/icons/search_mode_operator_inactive.svg',
                  onTap: () => onChanged(_TicketSearchMode.operator),
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
  const _RouteInputs({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const Column(
          children: [
            _PlannerInput(
              key: Key('ticket-origin-input'),
              icon: Icons.location_on_outlined,
              iconColor: _primary,
              label: 'Điểm đi',
              value: 'TP. Hồ Chí Minh',
            ),
            SizedBox(height: 10),
            _PlannerInput(
              key: Key('ticket-destination-input'),
              icon: Icons.location_on_outlined,
              iconColor: Color(0xFFF39A20),
              label: 'Điểm đến',
              value: 'Đà Lạt',
            ),
          ],
        ),
        Positioned(
          right: 0,
          top: 55,
          child: Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFFE1EDF6)),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x1A14527D),
                  offset: Offset(0, 5),
                  blurRadius: 12,
                ),
              ],
            ),
            child: Center(
              child: SvgPicture.asset(
                '$_homeAssetRoot/icons/swap.svg',
                width: 23,
                height: 23,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _OperatorInput extends StatelessWidget {
  const _OperatorInput({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        _PlannerInput(
          icon: Icons.apartment_outlined,
          iconColor: _primary,
          label: 'Nhà xe',
          value: 'Phương Trang',
        ),
        SizedBox(height: 10),
        _PlannerInput(
          icon: Icons.route_outlined,
          iconColor: Color(0xFFF39A20),
          label: 'Tuyến đường',
          value: 'TP. Hồ Chí Minh → Đà Lạt',
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
    super.key,
  });

  final IconData icon;
  final Color iconColor;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 62,
      padding: const EdgeInsets.symmetric(horizontal: 13),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFFE1EDF6)),
        borderRadius: BorderRadius.circular(15),
      ),
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
                  style: const TextStyle(color: _secondary, fontSize: 11.5),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: _primaryDark,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, size: 20, color: _primary),
        ],
      ),
    );
  }
}

class _CompactInput extends StatelessWidget {
  const _CompactInput({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 52,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFFE1EDF6)),
        borderRadius: BorderRadius.circular(14),
      ),
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
    );
  }
}

class _ResultToolbar extends StatelessWidget {
  const _ResultToolbar({
    required this.activeFilterCount,
    required this.onFilter,
    required this.onSort,
  });

  final int activeFilterCount;
  final VoidCallback onFilter;
  final VoidCallback onSort;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _ToolbarChip(
            key: const Key('ticket-filter-chip'),
            icon: Icons.filter_alt_outlined,
            label: 'Lọc',
            count: activeFilterCount,
            selected: true,
            onTap: onFilter,
          ),
          const SizedBox(width: 9),
          _ToolbarChip(icon: Icons.tune, label: 'Sắp xếp', onTap: onSort),
          const SizedBox(width: 9),
          _ToolbarChip(
            label: 'Limousine',
            selected: true,
            trailing: Icons.close,
            onTap: onFilter,
          ),
        ],
      ),
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
  const _ResultSummary();

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Expanded(
          child: FittedBox(
            alignment: Alignment.centerLeft,
            fit: BoxFit.scaleDown,
            child: Text(
              '24 chuyến phù hợp',
              maxLines: 1,
              style: TextStyle(color: _primaryDark, fontSize: 12.5),
            ),
          ),
        ),
        SizedBox(width: 12),
        Flexible(
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              'Giá từ thấp đến cao',
              maxLines: 1,
              style: TextStyle(color: _primaryDark, fontSize: 11),
            ),
          ),
        ),
        SizedBox(width: 3),
        Icon(Icons.keyboard_arrow_down, size: 15, color: _primaryDark),
      ],
    );
  }
}

class _TripCard extends StatelessWidget {
  const _TripCard({required this.trip, this.onOpenDetail, super.key});

  final _TicketTrip trip;
  final VoidCallback? onOpenDetail;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(13, 11, 0, 0),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFEFD),
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1421404F),
            offset: Offset(0, 7),
            blurRadius: 19,
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 13),
            child: _TripOperatorHeader(trip: trip),
          ),
          const SizedBox(height: 8),
          SizedBox(height: 76, child: _TripJourney(trip: trip)),
          const SizedBox(height: 5),
          Padding(
            padding: const EdgeInsets.only(right: 13),
            child: _TripAmenities(trip: trip),
          ),
          const SizedBox(height: 8),
          _TripFooter(trip: trip, onOpenDetail: onOpenDetail),
        ],
      ),
    );
  }
}

class _TripOperatorHeader extends StatelessWidget {
  const _TripOperatorHeader({required this.trip});
  final _TicketTrip trip;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 42,
          height: 38,
          child: Image.asset(trip.logoAsset, fit: BoxFit.contain),
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
                  SvgPicture.asset(
                    '$_assetRoot/trip_star.svg',
                    width: 11,
                    height: 11,
                  ),
                  const SizedBox(width: 4),
                  Flexible(
                    child: Text(
                      '${trip.rating} (${trip.reviewCount})',
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
        SvgPicture.asset('$_assetRoot/trip_heart.svg', width: 17, height: 17),
      ],
    );
  }
}

class _TripJourney extends StatelessWidget {
  const _TripJourney({required this.trip});
  final _TicketTrip trip;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final vehicleWidth = constraints.maxWidth < 340 ? 82.0 : 98.0;
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 67,
              child: _JourneyPoint(
                time: trip.departureTime,
                city: 'TP.HCM',
                station: 'Bến xe Miền Đông',
              ),
            ),
            Expanded(child: _RouteDuration(duration: '6h30')),
            const SizedBox(width: 4),
            SizedBox(
              width: 56,
              child: _JourneyPoint(
                time: trip.arrivalTime,
                city: 'Đà Lạt',
                station: 'Bến xe Đà Lạt',
              ),
            ),
            SizedBox(
              width: vehicleWidth,
              height: 76,
              child: ClipOval(
                child: Image.asset(
                  trip.vehicleAsset,
                  fit: BoxFit.cover,
                  alignment: Alignment.center,
                  errorBuilder: (context, error, stackTrace) =>
                      const ColoredBox(
                        color: Color(0xFFEAF4FB),
                        child: Icon(
                          Icons.directions_bus,
                          color: _primary,
                          size: 42,
                        ),
                      ),
                ),
              ),
            ),
          ],
        );
      },
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
  final _TicketTrip trip;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SvgPicture.asset(
          '$_assetRoot/trip_seat_type.svg',
          width: 16,
          height: 16,
        ),
        const SizedBox(width: 7),
        Expanded(
          child: Text(
            trip.vehicleType,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: _primaryDark, fontSize: 9),
          ),
        ),
        SvgPicture.asset('$_assetRoot/trip_wifi.svg', width: 15, height: 15),
        const SizedBox(width: 13),
        SvgPicture.asset('$_assetRoot/trip_snow.svg', width: 15, height: 15),
        const SizedBox(width: 13),
        SvgPicture.asset(
          '$_assetRoot/trip_seat_amenity.svg',
          width: 15,
          height: 15,
        ),
        const SizedBox(width: 8),
        const Text('+2', style: TextStyle(color: _secondary, fontSize: 9)),
      ],
    );
  }
}

class _TripFooter extends StatelessWidget {
  const _TripFooter({required this.trip, this.onOpenDetail});
  final _TicketTrip trip;
  final VoidCallback? onOpenDetail;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 17),
            child: trip.urgent
                ? Container(
                    width: 105,
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
        _FareStub(price: trip.price, onOpenDetail: onOpenDetail),
      ],
    );
  }
}

class _FareStub extends StatelessWidget {
  const _FareStub({required this.price, this.onOpenDetail});

  final String price;
  final VoidCallback? onOpenDetail;

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
                    key: onOpenDetail == null
                        ? null
                        : const Key('phuong-trang-detail-arrow'),
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
  const _TripFilterSheet();

  @override
  State<_TripFilterSheet> createState() => _TripFilterSheetState();
}

class _TripFilterSheetState extends State<_TripFilterSheet> {
  RangeValues _price = const RangeValues(.3, .68);
  final Set<String> _vehicleOptions = {'Limousine'};
  String _departure = 'Trưa';
  final Set<String> _amenities = {'Wi-Fi'};
  final Set<String> _operators = {'Phương Trang', 'Thành Bưởi'};

  int get _selectionCount =>
      _vehicleOptions.length +
      (_departure.isEmpty ? 0 : 1) +
      _amenities.length +
      _operators.length;

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
                        values: _price,
                        onChanged: (value) => setState(() => _price = value),
                      ),
                    ),
                    const Row(
                      children: [
                        Expanded(
                          child: Text(
                            '100.000 ₫',
                            style: TextStyle(color: _secondary, fontSize: 11),
                          ),
                        ),
                        Text(
                          '800.000 ₫+',
                          style: TextStyle(color: _secondary, fontSize: 11),
                        ),
                      ],
                    ),
                    const SizedBox(height: 22),
                    const _FilterSectionTitle('Loại xe'),
                    const SizedBox(height: 10),
                    _FourColumnOptions(
                      children: [
                        _FilterOptionCard(
                          icon: Icons.directions_bus_outlined,
                          label: 'Tất cả',
                          selected: _vehicleOptions.isEmpty,
                          onTap: () => setState(_vehicleOptions.clear),
                        ),
                        _FilterOptionCard(
                          icon: Icons.diamond_outlined,
                          label: 'Limousine',
                          selected: _vehicleOptions.contains('Limousine'),
                          onTap: () => _toggleSet(_vehicleOptions, 'Limousine'),
                        ),
                        _FilterOptionCard(
                          icon: Icons.bed_outlined,
                          label: 'Giường nằm',
                          selected: _vehicleOptions.contains('Giường nằm'),
                          onTap: () =>
                              _toggleSet(_vehicleOptions, 'Giường nằm'),
                        ),
                        _FilterOptionCard(
                          icon: Icons.event_seat_outlined,
                          label: 'Ghế ngồi',
                          selected: _vehicleOptions.contains('Ghế ngồi'),
                          onTap: () => _toggleSet(_vehicleOptions, 'Ghế ngồi'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 22),
                    const _FilterSectionTitle('Giờ khởi hành'),
                    const SizedBox(height: 10),
                    _FourColumnOptions(
                      children: [
                        _DepartureOption(
                          icon: Icons.wb_twilight_outlined,
                          label: 'Sáng',
                          time: '00:00 – 06:00',
                          selected: _departure == 'Sáng',
                          onTap: () => setState(() => _departure = 'Sáng'),
                        ),
                        _DepartureOption(
                          icon: Icons.wb_sunny_outlined,
                          label: 'Trưa',
                          time: '06:00 – 12:00',
                          selected: _departure == 'Trưa',
                          onTap: () => setState(() => _departure = 'Trưa'),
                        ),
                        _DepartureOption(
                          icon: Icons.wb_twilight_outlined,
                          label: 'Chiều',
                          time: '12:00 – 18:00',
                          selected: _departure == 'Chiều',
                          onTap: () => setState(() => _departure = 'Chiều'),
                        ),
                        _DepartureOption(
                          icon: Icons.dark_mode_outlined,
                          label: 'Tối',
                          time: '18:00 – 24:00',
                          selected: _departure == 'Tối',
                          onTap: () => setState(() => _departure = 'Tối'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 22),
                    const _FilterSectionTitle('Tiện ích'),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        for (final option in const <(IconData, String)>[
                          (Icons.wifi, 'Wi-Fi'),
                          (Icons.ac_unit, 'Điều hòa'),
                          (Icons.water_drop_outlined, 'Nước uống'),
                          (Icons.usb, 'USB'),
                          (Icons.wc, 'WC'),
                          (Icons.tv_outlined, 'Màn hình'),
                          (Icons.bedroom_child_outlined, 'Chăn gối'),
                          (Icons.add, 'Khác'),
                        ])
                          _AmenityChip(
                            icon: option.$1,
                            label: option.$2,
                            selected: _amenities.contains(option.$2),
                            onTap: () => _toggleSet(_amenities, option.$2),
                          ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    const _FilterSectionTitle('Nhà xe'),
                    const SizedBox(height: 8),
                    for (final operator in const <(String, String, String)>[
                      (
                        'Phương Trang',
                        '$_homeAssetRoot/operators/phuong_trang.png',
                        '12',
                      ),
                      (
                        'Thành Bưởi',
                        '$_homeAssetRoot/operators/thanh_buoi.png',
                        '8',
                      ),
                      (
                        'Điền Linh',
                        '$_homeAssetRoot/operators/dien_linh.png',
                        '6',
                      ),
                      (
                        'Futa Limousine',
                        '$_homeAssetRoot/operators/phuong_trang.png',
                        '5',
                      ),
                      (
                        'Tân Niên',
                        '$_homeAssetRoot/operators/dien_linh.png',
                        '4',
                      ),
                    ])
                      _OperatorFilterRow(
                        label: operator.$1,
                        logoAsset: operator.$2,
                        count: operator.$3,
                        selected: _operators.contains(operator.$1),
                        onChanged: () => _toggleSet(_operators, operator.$1),
                      ),
                    TextButton.icon(
                      onPressed: () {},
                      iconAlignment: IconAlignment.end,
                      icon: const Icon(Icons.keyboard_arrow_down, size: 16),
                      label: const Text('Xem thêm'),
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        alignment: Alignment.centerLeft,
                        foregroundColor: _primary,
                        textStyle: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
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
                        onPressed: () =>
                            Navigator.pop(context, _selectionCount),
                        style: FilledButton.styleFrom(
                          minimumSize: const Size.fromHeight(52),
                          backgroundColor: _primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(19),
                          ),
                        ),
                        child: const FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            'Áp dụng (24)',
                            style: TextStyle(fontWeight: FontWeight.w600),
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
      },
    );
  }

  void _toggleSet(Set<String> values, String value) {
    setState(() {
      if (!values.add(value)) values.remove(value);
    });
  }

  void _reset() {
    setState(() {
      _price = const RangeValues(0, 1);
      _vehicleOptions.clear();
      _departure = '';
      _amenities.clear();
      _operators.clear();
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
            Text(
              label,
              style: const TextStyle(color: _primaryDark, fontSize: 11.5),
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
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
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
              Icon(icon, size: 16, color: _secondary),
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
    required this.logoAsset,
    required this.count,
    required this.selected,
    required this.onChanged,
  });

  final String label;
  final String logoAsset;
  final String count;
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
            SizedBox(
              width: 32,
              height: 28,
              child: Image.asset(logoAsset, fit: BoxFit.contain),
            ),
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
              count,
              style: const TextStyle(color: _secondary, fontSize: 10.5),
            ),
            const SizedBox(width: 8),
          ],
        ),
      ),
    );
  }
}
