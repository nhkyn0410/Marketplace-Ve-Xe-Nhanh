import 'dart:convert';
import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:passenger_mobile/features/home/home_models.dart';
import 'package:passenger_mobile/features/home/route_dock_tabbar.dart';
import 'package:passenger_mobile/features/search/trip_search_form.dart';

const _assetRoot = 'assets/home';
const _primary = Color(0xFF2B7EAD);
const _primaryDark = Color(0xFF102E58);
const _secondary = Color(0xFF607A8E);
const _pageBackground = Color(0xFFF7FCFF);
const _surfaceBorder = Color(0xFFE0EFF8);
const _plannerSurfaceLoader = _FilterlessSvgAssetLoader(
  '$_assetRoot/illustrations/planner_surface.svg',
);

/// Nhận điều kiện tìm hợp lệ từ form Trang chủ (mở danh sách chuyến ở tab Mua vé).
typedef HomeTripSearch = void Function(HomeSearchQuery query);
typedef HomePopularRoutesLoader = Future<List<HomePopularRoute>> Function(
  DateTime date,
);
typedef HomeFaqLoader = Future<List<HomeFaqItem>> Function();
typedef HomeHotlineLauncher = Future<bool> Function(String hotline);

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    required this.isLoggedIn,
    this.userName,
    this.initialMode = HomeSearchMode.route,
    this.initialDate,
    this.searchCatalog,
    this.loadPopularRoutes,
    this.loadFaqs,
    this.onSearch,
    this.onCallHotline,
    this.onFeedbackRequested,
    this.onLoginRequested,
    this.onTabSelected,
    super.key,
  });

  final bool isLoggedIn;
  final String? userName;
  final HomeSearchMode initialMode;
  final DateTime? initialDate;
  final TripSearchCatalog? searchCatalog;
  final HomePopularRoutesLoader? loadPopularRoutes;
  final HomeFaqLoader? loadFaqs;
  final HomeTripSearch? onSearch;
  final HomeHotlineLauncher? onCallHotline;
  final VoidCallback? onFeedbackRequested;
  final VoidCallback? onLoginRequested;
  final ValueChanged<int>? onTabSelected;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with TripSearchFormState<HomeScreen> {
  static const _supportHotline = '1900 636 707';

  final _scrollController = ScrollController();
  bool _dockVisible = true;
  Future<List<HomePopularRoute>>? _popularRoutesFuture;

  @override
  TripSearchCatalog? get searchCatalog => widget.searchCatalog;

  @override
  void initState() {
    super.initState();
    searchMode = widget.initialMode;
    final initialDate = widget.initialDate;
    if (initialDate != null) searchDate = initialDate;
    _popularRoutesFuture = widget.loadPopularRoutes?.call(searchDate);
  }

  @override
  void didUpdateWidget(covariant HomeScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.loadPopularRoutes != widget.loadPopularRoutes) {
      _popularRoutesFuture = widget.loadPopularRoutes?.call(searchDate);
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: const Key('home-screen'),
      backgroundColor: _pageBackground,
      extendBody: true,
      resizeToAvoidBottomInset: true,
      bottomNavigationBar: IgnorePointer(
        ignoring: !_dockVisible,
        child: AnimatedSlide(
          key: const Key('home-bottom-dock-animation'),
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOutCubic,
          offset: _dockVisible ? Offset.zero : const Offset(0, 1),
          child: RouteDockTabBar(currentIndex: 2, onTap: _handleTabTap),
        ),
      ),
      body: SafeArea(
        bottom: false,
        child: NotificationListener<UserScrollNotification>(
          onNotification: _handleUserScroll,
          child: CustomScrollView(
            key: const Key('home-content-scroll'),
            controller: _scrollController,
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            slivers: [
              SliverToBoxAdapter(
                child: _HomeTopArea(
                  isLoggedIn: widget.isLoggedIn,
                  userName: widget.userName,
                  mode: searchMode,
                  fromLabel: searchFrom?.name,
                  toLabel: searchTo?.name,
                  operatorLabel: searchOperator?.name,
                  routeLabel: searchOperatorRoute?.label,
                  date: searchDate,
                  passengers: searchPassengers,
                  onModeChanged: (mode) => setState(() => searchMode = mode),
                  onPickFrom: () => pickSearchLocation(isOrigin: true),
                  onPickTo: () => pickSearchLocation(isOrigin: false),
                  onSwap: swapSearchLocations,
                  onPickDate: _pickDate,
                  onPickPassengers: pickSearchPassengers,
                  onSearch: _search,
                  onOperatorTap: pickSearchOperator,
                  onRouteTap: pickSearchOperatorRoute,
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 9),
                sliver: SliverList.list(
                  children: [
                    if (!widget.isLoggedIn) ...[
                      _GuestInvitation(onLogin: widget.onLoginRequested),
                      const SizedBox(height: 12),
                    ],
                    const _VoucherSection(),
                    const SizedBox(height: 12),
                    _PopularRoutesSection(
                      routes: _popularRoutesFuture,
                      onSelected: _selectPopularRoute,
                    ),
                    const SizedBox(height: 12),
                    const _OperatorsSection(),
                    const SizedBox(height: 12),
                    const _ArticlesSection(),
                    const SizedBox(height: 14),
                    _SupportSection(
                      onHelpCenter: _openHelpCenter,
                      onCallHotline: _callHotline,
                      onFeedback: _requestFeedback,
                    ),
                    const SizedBox(height: 150),
                  ],
                ),
              ),
            ],
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
      ScrollDirection.idle =>
        notification.metrics.pixels <= 0 ? true : _dockVisible,
    };
    if (shouldShow != _dockVisible && mounted) {
      setState(() => _dockVisible = shouldShow);
    }
    return false;
  }

  void _showMessage(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  void _handleTabTap(int index) {
    if (index == 2) return;
    if (index == 4 && !widget.isLoggedIn && widget.onLoginRequested != null) {
      widget.onLoginRequested!();
      return;
    }
    final callback = widget.onTabSelected;
    if (callback != null) {
      callback(index);
      return;
    }
    _showMessage('${RouteDockTabBar.labels[index]} chưa được triển khai.');
  }

  void _selectPopularRoute(HomePopularRoute route) {
    setState(() {
      searchMode = HomeSearchMode.route;
      searchFrom = route.from;
      searchTo = route.to;
    });
    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOutCubic,
    );
  }

  Future<void> _openHelpCenter() async {
    final loader = widget.loadFaqs;
    if (loader == null) {
      _showMessage('Trung tâm trợ giúp hiện chưa khả dụng.');
      return;
    }
    await showModalBottomSheet<void>(
      context: context,
      useSafeArea: true,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => _FaqSheet(loader: loader),
    );
  }

  Future<void> _callHotline() async {
    final launcher = widget.onCallHotline;
    final launched = launcher != null && await launcher(_supportHotline);
    if (!launched) {
      _showMessage('Không thể mở ứng dụng gọi điện trên thiết bị này.');
    }
  }

  void _requestFeedback() {
    final callback = widget.onFeedbackRequested;
    if (callback != null) {
      callback();
      return;
    }
    _showMessage('Bạn có thể góp ý từ chuyến đi đã hoàn thành.');
  }

  Future<void> _pickDate() async {
    if (!await pickSearchDate() || !mounted) return;
    setState(() {
      _popularRoutesFuture = widget.loadPopularRoutes?.call(searchDate);
    });
  }

  void _search() {
    final query = buildSearchQuery();
    if (query == null) return;
    final search = widget.onSearch;
    if (search == null) {
      _showMessage('Tìm chuyến hiện chưa khả dụng.');
      return;
    }
    search(query);
  }
}

class _HomeTopArea extends StatelessWidget {
  const _HomeTopArea({
    required this.isLoggedIn,
    required this.userName,
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
    required this.onPickDate,
    required this.onPickPassengers,
    required this.onSearch,
    required this.onOperatorTap,
    required this.onRouteTap,
  });

  final bool isLoggedIn;
  final String? userName;
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
  final VoidCallback onPickDate;
  final VoidCallback onPickPassengers;
  final VoidCallback onSearch;
  final VoidCallback onOperatorTap;
  final VoidCallback onRouteTap;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final textScale = MediaQuery.textScalerOf(context).scale(1);
        final narrow = width < 350 || textScale > 1.25;
        final heroHeight = (width * .411).clamp(154.0, 188.0);
        final plannerHeight = narrow ? 506.0 : 426.0;
        final plannerTop = heroHeight - 26;
        final totalHeight = plannerTop + plannerHeight + 44;

        return SizedBox(
          height: totalHeight,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned(
                left: 0,
                right: 0,
                top: 0,
                height: heroHeight,
                child: _HomeHero(isLoggedIn: isLoggedIn, userName: userName),
              ),
              Positioned(
                left: width < 340 ? 6 : 8,
                right: width < 340 ? 6 : 8,
                top: plannerTop,
                height: plannerHeight,
                child: _JourneyPlanner(
                  narrow: narrow,
                  mode: mode,
                  fromLabel: fromLabel,
                  toLabel: toLabel,
                  operatorLabel: operatorLabel,
                  routeLabel: routeLabel,
                  date: date,
                  passengers: passengers,
                  onModeChanged: onModeChanged,
                  onPickFrom: onPickFrom,
                  onPickTo: onPickTo,
                  onSwap: onSwap,
                  onPickDate: onPickDate,
                  onPickPassengers: onPickPassengers,
                  onSearch: onSearch,
                  onOperatorTap: onOperatorTap,
                  onRouteTap: onRouteTap,
                ),
              ),
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                height: 62,
                child: SvgPicture.asset(
                  '$_assetRoot/illustrations/journey_wave.svg',
                  fit: BoxFit.fill,
                  excludeFromSemantics: true,
                ),
              ),
              Positioned(
                left: 0,
                right: 0,
                bottom: 16,
                height: 43,
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 280),
                  switchInCurve: Curves.easeOutCubic,
                  switchOutCurve: Curves.easeInCubic,
                  child: SvgPicture.asset(
                    mode == HomeSearchMode.route
                        ? '$_assetRoot/illustrations/journey_wave_lines_route.svg'
                        : '$_assetRoot/illustrations/journey_wave_lines_operator.svg',
                    key: ValueKey(mode),
                    fit: BoxFit.fill,
                    excludeFromSemantics: true,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _HomeHero extends StatelessWidget {
  const _HomeHero({required this.isLoggedIn, required this.userName});

  final bool isLoggedIn;
  final String? userName;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        ClipRect(
          child: FractionallySizedBox(
            alignment: Alignment.topLeft,
            widthFactor: 2,
            heightFactor: 3,
            child: Image.asset(
              '$_assetRoot/hero/landscape_bus.png',
              fit: BoxFit.cover,
              alignment: Alignment.topLeft,
              excludeFromSemantics: true,
            ),
          ),
        ),
        const DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.bottomLeft,
              end: Alignment.centerRight,
              colors: [Color(0x66033857), Color(0x00033857)],
            ),
          ),
        ),
        Positioned(
          left: 17,
          top: 8,
          child: Container(
            height: 35,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: _surfaceBorder, width: .6),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x121F6EA6),
                  offset: Offset(0, 3),
                  blurRadius: 6,
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SvgPicture.asset(
                  '$_assetRoot/hero/logo_mark.svg',
                  width: 27,
                  height: 27,
                  excludeFromSemantics: true,
                ),
                const SizedBox(width: 2),
                SvgPicture.asset(
                  '$_assetRoot/hero/logo_wordmark.svg',
                  width: 76,
                  excludeFromSemantics: true,
                ),
              ],
            ),
          ),
        ),
        Positioned(
          right: 15,
          top: 10,
          child: Row(
            children: [
              SizedBox(
                width: 29,
                height: 29,
                child: Stack(
                  children: [
                    SvgPicture.asset(
                      '$_assetRoot/hero/bell_frame.svg',
                      width: 29,
                      height: 29,
                      excludeFromSemantics: true,
                    ),
                    Center(
                      child: SvgPicture.asset(
                        '$_assetRoot/hero/bell.svg',
                        width: 15,
                        height: 15,
                        excludeFromSemantics: true,
                      ),
                    ),
                    Positioned(
                      right: 0,
                      top: 3,
                      child: SvgPicture.asset(
                        '$_assetRoot/hero/notification_unread.svg',
                        width: 6,
                        height: 6,
                        excludeFromSemantics: true,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Positioned(
          left: 19,
          right: 12,
          top: 54,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                isLoggedIn
                    ? 'Xin chào, ${userName?.trim().isNotEmpty == true ? userName!.trim() : 'bạn'}!'
                    : 'Xin chào!',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  height: 18.6 / 14,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const Text(
                'Bạn muốn đi đâu?',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 21,
                  height: 28 / 21,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 53),
                child: SvgPicture.asset(
                  '$_assetRoot/hero/accent_underline.svg',
                  width: 47,
                  height: 8,
                  excludeFromSemantics: true,
                ),
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
    required this.narrow,
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
    required this.onPickDate,
    required this.onPickPassengers,
    required this.onSearch,
    required this.onOperatorTap,
    required this.onRouteTap,
  });

  final bool narrow;
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
  final VoidCallback onPickDate;
  final VoidCallback onPickPassengers;
  final VoidCallback onSearch;
  final VoidCallback onOperatorTap;
  final VoidCallback onRouteTap;

  @override
  Widget build(BuildContext context) {
    final routeMode = mode == HomeSearchMode.route;
    return Stack(
      key: const Key('journey-planner'),
      clipBehavior: Clip.none,
      children: [
        Positioned.fill(
          child: DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(26),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x1A14527D),
                  offset: Offset(0, 6),
                  blurRadius: 18,
                ),
              ],
            ),
          ),
        ),
        Positioned(
          left: -18,
          right: -18,
          top: -12,
          bottom: -24,
          child: SvgPicture(
            _plannerSurfaceLoader,
            fit: BoxFit.fill,
            excludeFromSemantics: true,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              _SearchModeControl(mode: mode, onChanged: onModeChanged),
              const SizedBox(height: 12),
              SizedBox(
                height: 156,
                child: AnimatedSwitcher(
                  key: const Key('search-mode-content'),
                  duration: const Duration(milliseconds: 280),
                  switchInCurve: Curves.easeOutCubic,
                  switchOutCurve: Curves.easeInCubic,
                  transitionBuilder: (child, animation) => FadeTransition(
                    opacity: animation,
                    child: SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(.035, 0),
                        end: Offset.zero,
                      ).animate(animation),
                      child: child,
                    ),
                  ),
                  child: routeMode
                      ? Stack(
                          key: const ValueKey('route-search-fields'),
                          clipBehavior: Clip.none,
                          children: [
                            Column(
                              children: [
                                _PlannerInput(
                                  key: const Key('origin-input'),
                                  label: 'Điểm đi',
                                  value: fromLabel,
                                  placeholder: 'Chọn điểm đi',
                                  asset: '$_assetRoot/icons/origin_pin.svg',
                                  onTap: onPickFrom,
                                ),
                                const SizedBox(height: 12),
                                _PlannerInput(
                                  key: const Key('destination-input'),
                                  label: 'Điểm đến',
                                  value: toLabel,
                                  placeholder: 'Chọn điểm đến',
                                  asset:
                                      '$_assetRoot/icons/destination_pin.svg',
                                  onTap: onPickTo,
                                ),
                              ],
                            ),
                            Positioned(
                              left: 31,
                              top: 70,
                              width: 2,
                              height: 16,
                              child: SvgPicture.asset(
                                '$_assetRoot/illustrations/route_connecting_line.svg',
                                fit: BoxFit.fill,
                                excludeFromSemantics: true,
                              ),
                            ),
                            Positioned(
                              right: -18,
                              top: 56,
                              child: Material(
                                color: Colors.white,
                                shape: const CircleBorder(
                                  side: BorderSide(color: Color(0xFFE1EDF6)),
                                ),
                                elevation: 4,
                                shadowColor: const Color(0x1A14527D),
                                child: InkResponse(
                                  key: const Key('swap-locations'),
                                  onTap: onSwap,
                                  radius: 22,
                                  child: SizedBox(
                                    width: 44,
                                    height: 44,
                                    child: Center(
                                      child: SvgPicture.asset(
                                        '$_assetRoot/icons/swap.svg',
                                        width: 24,
                                        height: 24,
                                        excludeFromSemantics: true,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )
                      : Column(
                          key: const ValueKey('operator-search-fields'),
                          children: [
                            _PlannerInput(
                              key: const Key('operator-input'),
                              label: 'Nhà xe',
                              value: operatorLabel,
                              placeholder: 'Chọn nhà xe',
                              asset:
                                  '$_assetRoot/icons/search_mode_operator_inactive.svg',
                              onTap: onOperatorTap,
                            ),
                            const SizedBox(height: 12),
                            _PlannerInput(
                              key: const Key('operator-route-input'),
                              label: 'Tuyến',
                              value: routeLabel,
                              placeholder: operatorLabel == null
                                  ? 'Chọn nhà xe trước'
                                  : 'Chọn tuyến',
                              asset: '$_assetRoot/icons/operator_route.svg',
                              onTap: onRouteTap,
                            ),
                          ],
                        ),
                ),
              ),
              const SizedBox(height: 12),
              if (narrow)
                Column(
                  children: [
                    _CompactPlannerInput(
                      label: _formatDate(date),
                      asset: '$_assetRoot/icons/calendar.svg',
                      onTap: onPickDate,
                    ),
                    const SizedBox(height: 10),
                    _CompactPlannerInput(
                      label: '$passengers khách',
                      asset: '$_assetRoot/icons/passenger.svg',
                      onTap: onPickPassengers,
                    ),
                  ],
                )
              else
                Row(
                  children: [
                    Expanded(
                      child: _CompactPlannerInput(
                        label: _formatDate(date),
                        asset: '$_assetRoot/icons/calendar.svg',
                        onTap: onPickDate,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _CompactPlannerInput(
                        label: '$passengers khách',
                        asset: '$_assetRoot/icons/passenger.svg',
                        onTap: onPickPassengers,
                      ),
                    ),
                  ],
                ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                height: 60,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFF4B028), Color(0xFFEA831D)],
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: FilledButton(
                    key: const Key('home-search-button'),
                    onPressed: onSearch,
                    style: FilledButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SvgPicture.asset(
                            '$_assetRoot/icons/search.svg',
                            width: 20,
                            height: 20,
                            excludeFromSemantics: true,
                          ),
                          const SizedBox(width: 12),
                          const Text(
                            'Tìm chuyến',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(width: 12),
                          SvgPicture.asset(
                            '$_assetRoot/icons/arrow_right.svg',
                            width: 20,
                            height: 20,
                            excludeFromSemantics: true,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _formatDate(DateTime value) {
    String two(int value) => value.toString().padLeft(2, '0');
    return '${two(value.day)}/${two(value.month)}/${value.year}';
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
                  key: const Key('search-mode-indicator'),
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
                child: _SearchModeButton(
                  key: const Key('search-mode-route'),
                  selected: mode == HomeSearchMode.route,
                  label: 'Theo chuyến',
                  selectedAsset:
                      '$_assetRoot/icons/search_mode_route_active.svg',
                  unselectedAsset:
                      '$_assetRoot/icons/search_mode_route_inactive.svg',
                  onTap: () => onChanged(HomeSearchMode.route),
                ),
              ),
              Expanded(
                child: _SearchModeButton(
                  key: const Key('search-mode-operator'),
                  selected: mode == HomeSearchMode.operator,
                  label: 'Theo nhà xe',
                  selectedAsset:
                      '$_assetRoot/icons/search_mode_operator_active.svg',
                  unselectedAsset:
                      '$_assetRoot/icons/search_mode_operator_inactive.svg',
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

class _SearchModeButton extends StatelessWidget {
  const _SearchModeButton({
    required this.selected,
    required this.label,
    required this.selectedAsset,
    required this.unselectedAsset,
    required this.onTap,
    super.key,
  });

  final bool selected;
  final String label;
  final String selectedAsset;
  final String unselectedAsset;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 180),
                child: SvgPicture.asset(
                  selected ? selectedAsset : unselectedAsset,
                  key: ValueKey(selected),
                  width: 20,
                  height: 20,
                  excludeFromSemantics: true,
                ),
              ),
              const SizedBox(width: 8),
              Flexible(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: AnimatedDefaultTextStyle(
                    duration: const Duration(milliseconds: 180),
                    style: TextStyle(
                      fontSize: 14,
                      height: 18 / 14,
                      fontWeight: FontWeight.w600,
                      color: selected ? Colors.white : _secondary,
                    ),
                    child: Text(label, maxLines: 1),
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

class _PlannerInput extends StatelessWidget {
  const _PlannerInput({
    required this.label,
    required this.value,
    required this.placeholder,
    required this.asset,
    required this.onTap,
    super.key,
  });

  final String label;

  /// `null` = chưa chọn, hiện [placeholder].
  final String? value;
  final String placeholder;
  final String asset;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 72,
      child: Material(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          side: const BorderSide(color: Color(0xFFE1EDF6)),
          borderRadius: BorderRadius.circular(16),
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                SvgPicture.asset(
                  asset,
                  width: 24,
                  height: 24,
                  excludeFromSemantics: true,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        label,
                        style: const TextStyle(
                          color: _secondary,
                          fontSize: 13,
                          height: 18 / 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        value ?? placeholder,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: value == null ? _secondary : _primaryDark,
                          fontSize: value == null ? 16 : 18,
                          height: 24 / 18,
                          fontWeight: value == null
                              ? FontWeight.w500
                              : FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                SvgPicture.asset(
                  '$_assetRoot/icons/chevron_small.svg',
                  width: 20,
                  height: 20,
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

class _CompactPlannerInput extends StatelessWidget {
  const _CompactPlannerInput({
    required this.label,
    required this.asset,
    required this.onTap,
  });

  final String label;
  final String asset;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 58,
      child: Material(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          side: const BorderSide(color: Color(0xFFE1EDF6)),
          borderRadius: BorderRadius.circular(16),
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: [
                SvgPicture.asset(
                  asset,
                  width: 20,
                  height: 20,
                  excludeFromSemantics: true,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: _primaryDark,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                SvgPicture.asset(
                  '$_assetRoot/icons/chevron_right.svg',
                  width: 16,
                  height: 16,
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

class _GuestInvitation extends StatelessWidget {
  const _GuestInvitation({required this.onLogin});

  final VoidCallback? onLogin;

  @override
  Widget build(BuildContext context) {
    return Container(
      key: const Key('guest-login-banner'),
      constraints: const BoxConstraints(minHeight: 49),
      padding: const EdgeInsets.fromLTRB(7, 5, 8, 5),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFE5F5FF), Color(0xFFBFE3FF)],
        ),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: _surfaceBorder, width: .6),
        boxShadow: const [
          BoxShadow(
            color: Color(0x121F6EA6),
            offset: Offset(0, 3),
            blurRadius: 6,
          ),
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(
              '$_assetRoot/illustrations/member_banner.png',
              width: 78,
              height: 40,
              fit: BoxFit.cover,
              alignment: Alignment.center,
              excludeFromSemantics: true,
            ),
          ),
          const SizedBox(width: 7),
          const Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Đăng nhập để lưu hành trình,',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Color(0xFF155D9B),
                    fontSize: 10.7,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  'xem vé của bạn và nhận ưu đãi.',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: Color(0xFF155D9B), fontSize: 10),
                ),
              ],
            ),
          ),
          const SizedBox(width: 4),
          OutlinedButton(
            onPressed: onLogin,
            style: OutlinedButton.styleFrom(
              minimumSize: const Size(72, 28),
              padding: const EdgeInsets.symmetric(horizontal: 8),
              foregroundColor: _primary,
              side: const BorderSide(color: _primary, width: .7),
              textStyle: const TextStyle(
                fontSize: 9.6,
                fontWeight: FontWeight.w600,
              ),
            ),
            child: const Text('Đăng nhập  →'),
          ),
        ],
      ),
    );
  }
}

class _VoucherSection extends StatelessWidget {
  const _VoucherSection();

  @override
  Widget build(BuildContext context) {
    return _HomeSection(
      title: 'Ưu đãi nổi bật',
      iconAsset: '$_assetRoot/icons/gift_route.svg',
      child: _HorizontalStrip(
        gap: 8,
        children: const [
          _VoucherCard(
            asset: '$_assetRoot/vouchers/discount_20.png',
            title: 'Giảm 20%',
            subtitle: 'Cho mọi tuyến đường',
            code: 'Mã: VXN20',
            color: Color(0xFFA74711),
          ),
          _VoucherCard(
            asset: '$_assetRoot/vouchers/discount_50k.jpg',
            title: 'Giảm 50K',
            subtitle: 'Cho đơn từ 300K',
            code: 'Mã: DALAT50',
            color: Color(0xFF155D9B),
          ),
        ],
      ),
    );
  }
}

class _VoucherCard extends StatelessWidget {
  const _VoucherCard({
    required this.asset,
    required this.title,
    required this.subtitle,
    required this.code,
    required this.color,
  });

  final String asset;
  final String title;
  final String subtitle;
  final String code;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final viewportWidth = MediaQuery.sizeOf(context).width;
    final width = math.min(192.0, math.max(156.0, (viewportWidth - 26) / 2));
    return Container(
      width: width,
      height: 66,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: .5),
        borderRadius: BorderRadius.circular(8),
        boxShadow: const [
          BoxShadow(
            color: Color(0x121F6EA6),
            offset: Offset(0, 3),
            blurRadius: 10,
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned.fill(
            left: width * .33,
            child: Opacity(
              opacity: .6,
              child: Image.asset(asset, fit: BoxFit.cover),
            ),
          ),
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    const Color(0xFFFFFAE5).withValues(alpha: .98),
                    Colors.white.withValues(alpha: 0),
                  ],
                  stops: const [.35, .78],
                ),
              ),
            ),
          ),
          Positioned(
            left: 13,
            top: 5,
            child: Text(
              title,
              style: TextStyle(
                color: color,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Positioned(
            left: 13,
            top: 28,
            child: Text(
              subtitle,
              style: TextStyle(
                color: color,
                fontSize: 9,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Positioned(
            left: 13,
            top: 45,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                child: Text(
                  code,
                  style: TextStyle(
                    color: color,
                    fontSize: 7.3,
                    fontWeight: FontWeight.w600,
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

class _PopularRoutesSection extends StatelessWidget {
  const _PopularRoutesSection({required this.routes, required this.onSelected});

  final Future<List<HomePopularRoute>>? routes;
  final ValueChanged<HomePopularRoute> onSelected;

  @override
  Widget build(BuildContext context) {
    final future = routes;
    if (future == null) return const SizedBox.shrink();
    return FutureBuilder<List<HomePopularRoute>>(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const _PopularRoutesSkeleton();
        }
        final items = snapshot.hasError
            ? const <HomePopularRoute>[]
            : snapshot.data ?? const <HomePopularRoute>[];
        if (items.isEmpty) return const SizedBox.shrink();
        return _HomeSection(
          title: 'Tuyến phổ biến',
          iconAsset: '$_assetRoot/icons/popular_route_pin.svg',
          child: _HorizontalStrip(
            gap: 7,
            children: [
              for (var index = 0; index < items.length; index++)
                _PopularRouteCard(
                  key: Key('popular-route-card-$index'),
                  route: items[index],
                  onTap: () => onSelected(items[index]),
                ),
            ],
          ),
        );
      },
    );
  }
}

class _PopularRoutesSkeleton extends StatelessWidget {
  const _PopularRoutesSkeleton();

  @override
  Widget build(BuildContext context) {
    return _HomeSection(
      title: 'Tuyến phổ biến',
      iconAsset: '$_assetRoot/icons/popular_route_pin.svg',
      child: _HorizontalStrip(
        gap: 7,
        children: List.generate(
          4,
          (index) => Container(
            key: Key('popular-route-skeleton-$index'),
            width: 94,
            height: 74,
            decoration: BoxDecoration(
              color: const Color(0xFFEAF4FB),
              borderRadius: BorderRadius.circular(7),
            ),
          ),
        ),
      ),
    );
  }
}

class _PopularRouteCard extends StatelessWidget {
  const _PopularRouteCard({
    required this.route,
    required this.onTap,
    super.key,
  });

  final HomePopularRoute route;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final remoteImage = route.imageUrl?.trim();
    final image = remoteImage == null || remoteImage.isEmpty
        ? Image.asset(route.fallbackAsset, fit: BoxFit.cover)
        : Image.network(
            remoteImage,
            fit: BoxFit.cover,
            errorBuilder: (_, _, _) =>
                Image.asset(route.fallbackAsset, fit: BoxFit.cover),
          );
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(7),
        boxShadow: const [
          BoxShadow(
            color: Color(0x121F6EA6),
            offset: Offset(0, 3),
            blurRadius: 10,
          ),
        ],
      ),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(7),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: SizedBox(
            width: 94,
            height: 74,
            child: Stack(
              children: [
                Positioned.fill(child: image),
                const Positioned.fill(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.white,
                          Color(0xE6FFFFFF),
                          Color(0x1FFFFFFF),
                        ],
                        stops: [0, .5, 1],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: 7,
                  top: 5,
                  right: 4,
                  child: Text(
                    route.fromLabel,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: _primaryDark,
                      fontSize: 7.3,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Positioned(
                  left: 7,
                  top: 16,
                  right: 4,
                  child: Text(
                    route.toLabel,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: _primaryDark,
                      fontSize: 11.3,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const Positioned(
                  left: 7,
                  bottom: 13,
                  child: Text(
                    'Chỉ từ',
                    style: TextStyle(color: _secondary, fontSize: 6.2),
                  ),
                ),
                Positioned(
                  left: 7,
                  bottom: 2,
                  child: Text(
                    _formatVnd(route.minPriceVnd),
                    style: const TextStyle(
                      color: Color(0xFFE68114),
                      fontSize: 9,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Positioned(
                  right: 6,
                  bottom: 5,
                  child: SvgPicture.asset(
                    '$_assetRoot/icons/route_action.svg',
                    width: 15,
                    height: 15,
                    excludeFromSemantics: true,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _formatVnd(int value) {
    final digits = value.toString();
    final chunks = <String>[];
    for (var end = digits.length; end > 0; end -= 3) {
      chunks.add(digits.substring(math.max(0, end - 3), end));
    }
    return '${chunks.reversed.join('.')}đ';
  }
}

class _OperatorsSection extends StatelessWidget {
  const _OperatorsSection();

  @override
  Widget build(BuildContext context) {
    const operators = [
      ('Phương Trang', '4.8', '$_assetRoot/operators/phuong_trang.png'),
      ('Điền Linh', '4.7', '$_assetRoot/operators/dien_linh.png'),
      ('Thành Bưởi', '4.6', '$_assetRoot/operators/thanh_buoi.png'),
    ];
    return _HomeSection(
      title: 'Nhà xe nổi bật',
      iconAsset: '$_assetRoot/icons/section_bus_route.svg',
      child: _HorizontalStrip(
        gap: 7,
        children: operators
            .map(
              (item) => _OperatorCard(
                key: ValueKey('featured-operator-${item.$1}'),
                name: item.$1,
                rating: item.$2,
                asset: item.$3,
              ),
            )
            .toList(),
      ),
    );
  }
}

class _OperatorCard extends StatelessWidget {
  const _OperatorCard({
    required this.name,
    required this.rating,
    required this.asset,
    super.key,
  });

  final String name;
  final String rating;
  final String asset;

  @override
  Widget build(BuildContext context) {
    final textScale = MediaQuery.textScalerOf(context).scale(1);
    final cardHeight = textScale > 1.25 ? 98.0 : 76.0;
    return Container(
      width: 158,
      height: cardHeight,
      padding: const EdgeInsets.all(10),
      decoration: _smallCardDecoration(radius: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(
              asset,
              width: 44,
              height: 44,
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: _primaryDark,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Row(
                    children: [
                      Text(
                        '★ $rating',
                        style: const TextStyle(
                          color: Color(0xFFE89B26),
                          fontSize: 9,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Text(
                        '(12.5K đánh giá)',
                        style: TextStyle(color: _secondary, fontSize: 7.5),
                      ),
                    ],
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

class _ArticlesSection extends StatelessWidget {
  const _ArticlesSection();

  @override
  Widget build(BuildContext context) {
    const articles = [
      (
        'CẨM NANG',
        'Kinh nghiệm đi Đà Lạt\nbằng xe khách',
        '$_assetRoot/articles/da_lat_coach_guide.jpg',
      ),
      (
        'CẨM NANG',
        'Top 7 điểm check-in\nkhông thể bỏ lỡ ở Đà Lạt',
        '$_assetRoot/articles/da_lat_checkin.png',
      ),
      (
        'LIFESTYLE',
        'Những cung đường biển\nđẹp nhất Việt Nam',
        '$_assetRoot/articles/coastal_routes.jpg',
      ),
    ];
    return _HomeSection(
      title: 'Khám phá & cẩm nang',
      iconAsset: '$_assetRoot/icons/section_book_route.svg',
      child: _HorizontalStrip(
        gap: 7,
        children: articles
            .map(
              (item) => _ArticleCard(
                key: ValueKey('home-article-${item.$3}'),
                category: item.$1,
                title: item.$2,
                asset: item.$3,
              ),
            )
            .toList(),
      ),
    );
  }
}

class _ArticleCard extends StatelessWidget {
  const _ArticleCard({
    required this.category,
    required this.title,
    required this.asset,
    super.key,
  });

  final String category;
  final String title;
  final String asset;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 154,
      height: 86,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(asset, fit: BoxFit.cover),
            const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Color(0xD1001A29)],
                ),
              ),
            ),
            Positioned(
              left: 9,
              top: 7,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(7),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 5,
                    vertical: 2,
                  ),
                  child: Text(
                    category,
                    style: const TextStyle(
                      color: _primaryDark,
                      fontSize: 7,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              left: 9,
              right: 7,
              bottom: 7,
              child: Text(
                title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  height: 1.3,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FaqSheet extends StatefulWidget {
  const _FaqSheet({required this.loader});

  final HomeFaqLoader loader;

  @override
  State<_FaqSheet> createState() => _FaqSheetState();
}

class _FaqSheetState extends State<_FaqSheet> {
  late final Future<List<HomeFaqItem>> _items = widget.loader();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.sizeOf(context).height * .72,
      child: Column(
        children: [
          const SizedBox(height: 10),
          Container(
            width: 42,
            height: 4,
            decoration: BoxDecoration(
              color: const Color(0xFFD4E4ED),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const Padding(
            padding: EdgeInsets.fromLTRB(20, 16, 20, 10),
            child: Row(
              children: [
                Icon(Icons.help_outline_rounded, color: _primary),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Trung tâm trợ giúp',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: _primaryDark,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: FutureBuilder<List<HomeFaqItem>>(
              future: _items,
              builder: (context, snapshot) {
                if (snapshot.connectionState != ConnectionState.done) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(24),
                      child: Text(
                        'Không tải được câu hỏi thường gặp. Vui lòng thử lại.',
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                }
                final items = snapshot.data ?? const <HomeFaqItem>[];
                if (items.isEmpty) {
                  return const Center(
                    child: Text('Chưa có câu hỏi thường gặp.'),
                  );
                }
                return ListView.separated(
                  padding: const EdgeInsets.fromLTRB(12, 0, 12, 24),
                  itemCount: items.length,
                  separatorBuilder: (_, _) => const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final item = items[index];
                    return ExpansionTile(
                      title: Text(
                        item.title,
                        style: const TextStyle(
                          color: _primaryDark,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                      expandedCrossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SelectionArea(
                          child: Text(
                            item.body,
                            style: const TextStyle(color: _secondary),
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _SupportSection extends StatelessWidget {
  const _SupportSection({
    required this.onHelpCenter,
    required this.onCallHotline,
    required this.onFeedback,
  });

  final VoidCallback onHelpCenter;
  final VoidCallback onCallHotline;
  final VoidCallback onFeedback;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            SvgPicture.asset(
              '$_assetRoot/icons/headset.svg',
              width: 24,
              height: 24,
              excludeFromSemantics: true,
            ),
            const SizedBox(width: 11),
            const Expanded(
              child: Text(
                'Luôn sẵn sàng hỗ trợ',
                style: TextStyle(
                  color: _primaryDark,
                  fontSize: 18,
                  height: 24 / 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        LayoutBuilder(
          builder: (context, constraints) {
            final textScale = MediaQuery.textScalerOf(context).scale(1);
            final compact = constraints.maxWidth < 350 || textScale > 1.25;
            return _SupportHero(compact: compact, onContact: onHelpCenter);
          },
        ),
        const SizedBox(height: 10),
        _SupportActions(
          onHelpCenter: onHelpCenter,
          onCallHotline: onCallHotline,
          onFeedback: onFeedback,
        ),
      ],
    );
  }
}

class _SupportHero extends StatelessWidget {
  const _SupportHero({required this.compact, required this.onContact});

  final bool compact;
  final VoidCallback onContact;

  @override
  Widget build(BuildContext context) {
    final height = compact ? 326.0 : 268.0;
    return Container(
      key: const Key('support-station'),
      height: height,
      width: double.infinity,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: const Color(0xFFEEF9FF),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: Colors.white),
        boxShadow: const [
          BoxShadow(
            color: Color(0x171F80B2),
            offset: Offset(0, 7),
            blurRadius: 18,
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            right: compact ? -8 : -7,
            bottom: compact ? -18 : 63,
            width: compact ? 168 : 205,
            height: compact ? 168 : 205,
            child: Image.asset(
              '$_assetRoot/support/robot_agent.png',
              fit: BoxFit.contain,
              excludeFromSemantics: true,
            ),
          ),
          Positioned(
            left: 15,
            top: 14,
            child: Container(
              constraints: const BoxConstraints(maxWidth: 237),
              height: 25,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(
                color: const Color(0xFFDFF2FF),
                borderRadius: BorderRadius.circular(13),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SvgPicture.asset(
                    '$_assetRoot/icons/support_pin.svg',
                    width: 14,
                    height: 14,
                    excludeFromSemantics: true,
                  ),
                  const SizedBox(width: 6),
                  const Flexible(
                    child: Text(
                      'Support Station — Trạm hỗ trợ hành trình',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: _primary,
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const Positioned(
            left: 16,
            top: 55,
            child: Text(
              'Có chúng tôi',
              style: TextStyle(
                color: _primaryDark,
                fontSize: 25,
                height: 34 / 25,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const Positioned(
            left: 16,
            top: 88,
            child: Text(
              'đồng hành!',
              style: TextStyle(
                color: Color(0xFFEE9225),
                fontSize: 25,
                height: 34 / 25,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Positioned(
            left: 17,
            top: 132,
            width: compact ? 210 : 195,
            child: const Text(
              'Mọi thắc mắc, vấn đề trong chuyến đi đều được chúng tôi hỗ trợ nhanh chóng và tận tâm.',
              style: TextStyle(
                color: _secondary,
                fontSize: 11,
                height: 15 / 11,
              ),
            ),
          ),
          Positioned(
            left: 16,
            top: 205,
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFFFA82E), Color(0xFFFF7A14)],
                ),
                borderRadius: BorderRadius.circular(22),
              ),
              child: SizedBox(
                height: 44,
                child: TextButton.icon(
                  onPressed: onContact,
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                  ),
                  icon: SvgPicture.asset(
                    '$_assetRoot/icons/support_headset.svg',
                    width: 21,
                    height: 21,
                    excludeFromSemantics: true,
                  ),
                  label: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Liên hệ hỗ trợ',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 12),
                      SvgPicture.asset(
                        '$_assetRoot/icons/support_arrow.svg',
                        width: 18,
                        height: 18,
                        excludeFromSemantics: true,
                      ),
                    ],
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

class _SupportActions extends StatelessWidget {
  const _SupportActions({
    required this.onHelpCenter,
    required this.onCallHotline,
    required this.onFeedback,
  });

  final VoidCallback onHelpCenter;
  final VoidCallback onCallHotline;
  final VoidCallback onFeedback;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        const gap = 10.0;
        final width = (constraints.maxWidth - gap * 2) / 3;
        return Wrap(
          spacing: gap,
          runSpacing: gap,
          children: [
            _SupportActionCard(
              key: const Key('support-help-center'),
              width: width,
              circleAsset: '$_assetRoot/icons/support_center_circle.svg',
              iconAsset: '$_assetRoot/icons/chat.svg',
              title: 'Trung tâm trợ giúp',
              subtitle: 'Câu hỏi thường gặp',
              onTap: onHelpCenter,
            ),
            _SupportActionCard(
              key: const Key('support-call-hotline'),
              width: width,
              circleAsset: '$_assetRoot/icons/support_feedback_circle.svg',
              iconAsset: '$_assetRoot/icons/phone.svg',
              title: 'Gọi tổng đài',
              subtitle: '1900 636 707',
              subtitleColor: const Color(0xFFEB932B),
              subtitleFontSize: 12,
              onTap: onCallHotline,
            ),
            _SupportActionCard(
              key: const Key('support-feedback'),
              width: width,
              circleAsset: '$_assetRoot/icons/support_pen_circle.svg',
              iconAsset: '$_assetRoot/icons/pen.svg',
              title: 'Góp ý',
              subtitle: 'Chia sẻ trải nghiệm',
              onTap: onFeedback,
            ),
          ],
        );
      },
    );
  }
}

class _SupportActionCard extends StatelessWidget {
  const _SupportActionCard({
    required this.width,
    required this.circleAsset,
    required this.iconAsset,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.subtitleColor = _secondary,
    this.subtitleFontSize = 10,
    super.key,
  });

  final double width;
  final String circleAsset;
  final String iconAsset;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final Color subtitleColor;
  final double subtitleFontSize;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: 134,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [
          BoxShadow(
            color: Color(0x171F80B2),
            offset: Offset(0, 7),
            blurRadius: 18,
          ),
        ],
      ),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Stack(
            children: [
              Positioned(
                left: 12,
                top: 13,
                width: 35,
                height: 35,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    SvgPicture.asset(
                      circleAsset,
                      width: 35,
                      height: 35,
                      excludeFromSemantics: true,
                    ),
                    SvgPicture.asset(
                      iconAsset,
                      width: 18,
                      height: 18,
                      excludeFromSemantics: true,
                    ),
                  ],
                ),
              ),
              Positioned(
                right: 12,
                top: 17,
                width: 24,
                height: 24,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    SvgPicture.asset(
                      '$_assetRoot/icons/support_phone_circle.svg',
                      width: 24,
                      height: 24,
                      excludeFromSemantics: true,
                    ),
                    SvgPicture.asset(
                      '$_assetRoot/icons/support_chevron.svg',
                      width: 12,
                      height: 12,
                      excludeFromSemantics: true,
                    ),
                  ],
                ),
              ),
              Positioned(
                left: 12,
                right: 12,
                top: 61,
                height: 34,
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: _primaryDark,
                      fontSize: 12,
                      height: 16 / 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 12,
                right: 8,
                top: 101,
                height: 18,
                child: FittedBox(
                  alignment: Alignment.centerLeft,
                  fit: BoxFit.scaleDown,
                  child: Text(
                    subtitle,
                    maxLines: 1,
                    style: TextStyle(
                      color: subtitleColor,
                      fontSize: subtitleFontSize,
                      height: 1.4,
                    ),
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

class _HomeSection extends StatelessWidget {
  const _HomeSection({
    required this.title,
    required this.iconAsset,
    required this.child,
  });

  final String title;
  final String iconAsset;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            SvgPicture.asset(
              iconAsset,
              width: 15,
              height: 15,
              excludeFromSemantics: true,
            ),
            const SizedBox(width: 7),
            Expanded(
              child: Text(
                title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: _primaryDark,
                  fontSize: 12,
                  height: 16 / 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      '$title: danh sách đầy đủ chưa được triển khai.',
                    ),
                  ),
                );
              },
              style: TextButton.styleFrom(
                minimumSize: const Size(0, 24),
                padding: const EdgeInsets.symmetric(horizontal: 5),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: const Text(
                'Xem tất cả  ›',
                style: TextStyle(fontSize: 10, fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
        const SizedBox(height: 5),
        child,
      ],
    );
  }
}

class _HorizontalStrip extends StatelessWidget {
  const _HorizontalStrip({required this.children, this.gap = 6});

  final List<Widget> children;
  final double gap;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: [
          for (var index = 0; index < children.length; index++) ...[
            if (index > 0) SizedBox(width: gap),
            children[index],
          ],
        ],
      ),
    );
  }
}

BoxDecoration _smallCardDecoration({double radius = 8.5}) {
  return BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(radius),
    border: Border.all(color: _surfaceBorder, width: .6),
    boxShadow: const [
      BoxShadow(color: Color(0x121F6EA6), offset: Offset(0, 3), blurRadius: 6),
    ],
  );
}

@immutable
class _FilterlessSvgAssetLoader extends SvgLoader<ByteData> {
  const _FilterlessSvgAssetLoader(this.assetName);

  static final _filterAttribute = RegExp(r'\sfilter="url\(#[^"]+\)"');
  static final _filterDefinition = RegExp(
    r'<filter\b[^>]*>.*?</filter>',
    dotAll: true,
  );

  final String assetName;

  @override
  Future<ByteData?> prepareMessage(BuildContext? context) {
    final bundle = context == null
        ? rootBundle
        : DefaultAssetBundle.of(context);
    return bundle.load(assetName);
  }

  @override
  String provideSvg(ByteData? message) {
    final source = utf8.decode(
      Uint8List.sublistView(message!),
      allowMalformed: true,
    );
    return source
        .replaceFirst(_filterAttribute, '')
        .replaceFirst(_filterDefinition, '');
  }

  @override
  int get hashCode => Object.hash(runtimeType, assetName);

  @override
  bool operator ==(Object other) {
    return other is _FilterlessSvgAssetLoader && other.assetName == assetName;
  }
}
