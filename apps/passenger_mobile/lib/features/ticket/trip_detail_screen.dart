import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'seat_selection_screen.dart';

const _detailAssets = 'assets/ticket/detail';
const _ink = Color(0xFF09243D);
const _blue = Color(0xFF2B7EAD);
const _muted = Color(0xFF607A8E);
const _surface = Color(0xFFF1F8FB);

class TripDetailScreen extends StatelessWidget {
  const TripDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: Colors.white,
      ),
      child: Scaffold(
        key: const Key('trip-detail-screen'),
        extendBodyBehindAppBar: true,
        backgroundColor: _surface,
        bottomNavigationBar: const _BookingBar(),
        body: ListView(
          key: const Key('trip-detail-scroll'),
          padding: EdgeInsets.zero,
          children: const [
            _HeroAndOperator(),
            _VehicleSummary(),
            _RouteMapSection(),
            _PickupDropoffSection(),
            _AmenitiesSection(),
            _CancellationSection(),
            _NoticeSection(),
            SizedBox(height: 14),
          ],
        ),
      ),
    );
  }
}

class _HeroAndOperator extends StatelessWidget {
  const _HeroAndOperator();

  @override
  Widget build(BuildContext context) {
    final topInset = MediaQuery.paddingOf(context).top;
    return SizedBox(
      height: 274,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned.fill(
            bottom: 42,
            child: Image.asset(
              '$_detailAssets/hero_mountain_bus.png',
              fit: BoxFit.cover,
              alignment: Alignment.center,
            ),
          ),
          const Positioned.fill(
            bottom: 42,
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0x00081C24),
                    Color(0x17081C24),
                    Color(0xB0081C24),
                  ],
                  stops: [0.32, 0.56, 1],
                ),
              ),
            ),
          ),
          const Positioned(
            left: 0,
            top: 102,
            width: 253,
            height: 104,
            child: DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(30)),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0x00081C24),
                    Color(0x45081C24),
                    Color(0x94081C24),
                  ],
                  stops: [0.04, 0.55, 0.97],
                ),
              ),
            ),
          ),
          Positioned(
            left: 14,
            right: 14,
            top: topInset + 8,
            child: _HeroToolbar(onBack: () => Navigator.maybePop(context)),
          ),
          const Positioned(
            left: 16,
            right: 16,
            bottom: 59,
            child: _HeroRoute(),
          ),
          const Positioned(
            left: 7,
            right: 7,
            bottom: 0,
            child: _OperatorCard(),
          ),
        ],
      ),
    );
  }
}

class _HeroToolbar extends StatelessWidget {
  const _HeroToolbar({required this.onBack});

  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _HeaderAction(
          key: const Key('trip-detail-back'),
          icon: 'back.svg',
          onTap: onBack,
        ),
        const SizedBox(width: 12),
        const Expanded(
          child: Text(
            'Chi tiết chuyến',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: Color(0xFF082A55),
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const _HeaderAction(icon: 'heart.svg'),
        const SizedBox(width: 8),
        const _HeaderAction(icon: 'share.svg'),
      ],
    );
  }
}

class _HeaderAction extends StatelessWidget {
  const _HeaderAction({required this.icon, this.onTap, super.key});

  final String icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      child: InkResponse(
        onTap: onTap,
        radius: 22,
        child: SizedBox.square(
          dimension: 30,
          child: Stack(
            alignment: Alignment.center,
            children: [
              SvgPicture.asset(
                '$_detailAssets/header_action.svg',
                width: 30,
                height: 30,
              ),
              SvgPicture.asset('$_detailAssets/$icon', width: 15, height: 15),
            ],
          ),
        ),
      ),
    );
  }
}

class _HeroRoute extends StatelessWidget {
  const _HeroRoute();

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: SizedBox(
        width: 226,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const _HeroCity('TP.HCM'),
                  const SizedBox(width: 13),
                  SvgPicture.asset(
                    '$_detailAssets/route_arrow.svg',
                    width: 17,
                    height: 17,
                  ),
                  const SizedBox(width: 18),
                  const _HeroCity('Đà Lạt'),
                ],
              ),
            ),
            const SizedBox(height: 2),
            SizedBox(
              width: 197,
              height: 18,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SvgPicture.asset(
                    '$_detailAssets/hero_route_line.svg',
                    width: 188,
                    height: 2,
                  ),
                  Positioned(
                    left: 0,
                    child: SvgPicture.asset(
                      '$_detailAssets/route_node.svg',
                      width: 6,
                      height: 6,
                    ),
                  ),
                  Positioned(
                    right: 0,
                    child: SvgPicture.asset(
                      '$_detailAssets/route_node.svg',
                      width: 6,
                      height: 6,
                    ),
                  ),
                  SvgPicture.asset(
                    '$_detailAssets/route_bus.svg',
                    width: 23,
                    height: 17,
                  ),
                ],
              ),
            ),
            Row(
              children: [
                const SizedBox(
                  width: 83,
                  child: _HeroTime(time: '07:00', station: 'Bến xe Miền Đông'),
                ),
                const SizedBox(
                  width: 76,
                  child: Center(
                    child: Text(
                      '6h30',
                      style: TextStyle(color: Colors.white, fontSize: 10),
                    ),
                  ),
                ),
                const Expanded(
                  child: _HeroTime(time: '13:30', station: 'Bến xe Đà Lạt'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _HeroCity extends StatelessWidget {
  const _HeroCity(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 19,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}

class _HeroTime extends StatelessWidget {
  const _HeroTime({required this.time, required this.station});

  final String time;
  final String station;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          time,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(
          station,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(color: Colors.white, fontSize: 9),
        ),
      ],
    );
  }
}

class _OperatorCard extends StatelessWidget {
  const _OperatorCard();

  @override
  Widget build(BuildContext context) {
    return _WhiteCard(
      height: 68,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(18),
            child: Image.asset(
              '$_detailAssets/phuong_trang_logo.png',
              width: 44,
              height: 44,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                LayoutBuilder(
                  builder: (context, constraints) => Row(
                    children: [
                      Flexible(
                        child: Text(
                          'Phương Trang',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Color(0xFF072752),
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      if (constraints.maxWidth >= 125) ...[
                        SizedBox(width: 8),
                        _PopularBadge(),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 2),
                const _RatingLine(),
                const SizedBox(height: 2),
                const Text(
                  'An toàn · Đúng giờ · Chất lượng cao',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: _muted, fontSize: 8.5),
                ),
              ],
            ),
          ),
          const SizedBox(width: 6),
          Container(
            height: 32,
            padding: const EdgeInsets.symmetric(horizontal: 11),
            decoration: BoxDecoration(
              color: const Color(0xFFEFF7FD),
              borderRadius: BorderRadius.circular(17),
            ),
            child: Row(
              children: [
                const Text(
                  'Xem nhà xe',
                  style: TextStyle(
                    color: Color(0xFF07549D),
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 4),
                RotatedBox(
                  quarterTurns: 3,
                  child: SvgPicture.asset(
                    '$_detailAssets/chevron.svg',
                    width: 11,
                    height: 11,
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

class _PopularBadge extends StatelessWidget {
  const _PopularBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: const Color(0xFFFFE9CD),
        borderRadius: BorderRadius.circular(9),
      ),
      child: const Text(
        'Phổ biến',
        style: TextStyle(
          color: Color(0xFFE88422),
          fontSize: 9,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _RatingLine extends StatelessWidget {
  const _RatingLine();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SvgPicture.asset('$_detailAssets/star.svg', width: 11, height: 11),
        const SizedBox(width: 4),
        const Text(
          '4.8',
          style: TextStyle(
            color: Color(0xFF072752),
            fontSize: 10.5,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(width: 3),
        const Flexible(
          child: Text(
            '(1.2K đánh giá)',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(color: _muted, fontSize: 8),
          ),
        ),
      ],
    );
  }
}

class _VehicleSummary extends StatelessWidget {
  const _VehicleSummary();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(7, 6, 7, 0),
      child: _WhiteCard(
        height: 94,
        padding: const EdgeInsets.all(8),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                '$_detailAssets/limousine_interior.png',
                width: 93,
                height: 78,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Limousine 34 phòng',
                    style: TextStyle(
                      color: Color(0xFF082752),
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      _SummaryAmenity(icon: 'wifi.svg', label: 'Wi-Fi'),
                      _SummaryAmenity(icon: 'snow.svg', label: 'Điều hòa'),
                      _SummaryAmenity(icon: 'water.svg', label: 'Nước uống'),
                      _SummaryAmenity(icon: 'usb.svg', label: 'USB'),
                      _SummaryAmenity(label: 'tiện ích khác', count: '+3'),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SummaryAmenity extends StatelessWidget {
  const _SummaryAmenity({this.icon, required this.label, this.count});

  final String? icon;
  final String label;
  final String? count;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          SizedBox.square(
            dimension: 34,
            child: Stack(
              alignment: Alignment.center,
              children: [
                SvgPicture.asset(
                  '$_detailAssets/amenity_bubble.svg',
                  width: 34,
                  height: 34,
                ),
                if (icon != null)
                  SvgPicture.asset(
                    '$_detailAssets/$icon',
                    width: 17,
                    height: 17,
                  )
                else
                  Text(
                    count!,
                    style: const TextStyle(
                      color: Color(0xFF006BB5),
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
              ],
            ),
          ),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: Color(0xFF123862), fontSize: 7.5),
          ),
        ],
      ),
    );
  }
}

class _RouteMapSection extends StatelessWidget {
  const _RouteMapSection();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(7, 10, 7, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionTitle(icon: 'map.svg', title: 'Bản đồ tuyến đường'),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: SizedBox(
              height: 130,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(
                    '$_detailAssets/route_map.png',
                    fit: BoxFit.cover,
                  ),
                  Positioned(
                    left: 84,
                    right: 78,
                    top: 16,
                    bottom: 18,
                    child: SvgPicture.asset(
                      '$_detailAssets/map_route.svg',
                      fit: BoxFit.fill,
                    ),
                  ),
                  const Positioned(
                    left: 87,
                    bottom: 15,
                    child: _MapLabel(marker: 'map_hcm.svg', label: 'TP.HCM'),
                  ),
                  const Positioned(
                    right: 82,
                    top: 4,
                    child: _MapLabel(marker: 'map_dalat.svg', label: 'Đà Lạt'),
                  ),
                  const Positioned(
                    left: 194,
                    top: 48,
                    child: _PlainMapLabel('Bảo Lộc'),
                  ),
                  Positioned(
                    right: 7,
                    top: 8,
                    child: SvgPicture.asset(
                      '$_detailAssets/expand.svg',
                      width: 28,
                      height: 28,
                    ),
                  ),
                  Positioned(
                    right: 7,
                    bottom: 8,
                    child: SvgPicture.asset(
                      '$_detailAssets/locate.svg',
                      width: 30,
                      height: 30,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const _RouteMetrics(),
        ],
      ),
    );
  }
}

class _MapLabel extends StatelessWidget {
  const _MapLabel({required this.marker, required this.label});

  final String marker;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SvgPicture.asset('$_detailAssets/$marker', width: 21, height: 28),
        _PlainMapLabel(label),
      ],
    );
  }
}

class _PlainMapLabel extends StatelessWidget {
  const _PlainMapLabel(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
      decoration: BoxDecoration(
        color: const Color(0xE6F5F7EB),
        borderRadius: BorderRadius.circular(3),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: _ink,
          fontSize: 9,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _RouteMetrics extends StatelessWidget {
  const _RouteMetrics();

  @override
  Widget build(BuildContext context) {
    return _WhiteCard(
      height: 48,
      borderRadius: const BorderRadius.vertical(bottom: Radius.circular(12)),
      padding: EdgeInsets.zero,
      child: const Row(
        children: [
          Expanded(
            child: _Metric(
              icon: 'clock.svg',
              value: '190 km',
              label: 'Tổng quãng đường',
            ),
          ),
          _MetricDivider(),
          Expanded(
            child: _Metric(
              icon: 'clock.svg',
              value: '6h30',
              label: 'Thời gian di chuyển',
            ),
          ),
          _MetricDivider(),
          Expanded(
            child: _Metric(
              icon: 'pin.svg',
              value: '2 điểm dừng',
              label: 'Trên tuyến',
            ),
          ),
        ],
      ),
    );
  }
}

class _Metric extends StatelessWidget {
  const _Metric({required this.icon, required this.value, required this.label});

  final String icon;
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        children: [
          SvgPicture.asset('$_detailAssets/$icon', width: 17, height: 17),
          const SizedBox(width: 9),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Color(0xFF092752),
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: _muted, fontSize: 7),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MetricDivider extends StatelessWidget {
  const _MetricDivider();

  @override
  Widget build(BuildContext context) {
    return Container(width: 1, height: 28, color: const Color(0xFFE4EEF2));
  }
}

class _PickupDropoffSection extends StatelessWidget {
  const _PickupDropoffSection();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.fromLTRB(7, 10, 7, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionTitle(icon: 'pin.svg', title: 'Điểm đón / Điểm trả'),
          SizedBox(height: 6),
          _LocationCard(
            pickup: true,
            title: 'Bến xe Miền Đông',
            address: '292 Đinh Bộ Lĩnh, Bình Thạnh, TP.HCM',
            photo: 'mien_dong_station.png',
          ),
          SizedBox(height: 4),
          _LocationCard(
            pickup: false,
            title: 'Bến xe Đà Lạt',
            address: '01 Tô Hiến Thành, Phường 3, Đà Lạt',
            photo: 'da_lat_station.png',
          ),
        ],
      ),
    );
  }
}

class _LocationCard extends StatelessWidget {
  const _LocationCard({
    required this.pickup,
    required this.title,
    required this.address,
    required this.photo,
  });

  final bool pickup;
  final String title;
  final String address;
  final String photo;

  @override
  Widget build(BuildContext context) {
    return _WhiteCard(
      height: 61,
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 6),
      child: Row(
        children: [
          SizedBox.square(
            dimension: 36,
            child: Stack(
              alignment: Alignment.center,
              children: [
                SvgPicture.asset(
                  '$_detailAssets/${pickup ? 'pickup_halo' : 'dropoff_halo'}.svg',
                  width: 36,
                  height: 36,
                ),
                SvgPicture.asset(
                  '$_detailAssets/${pickup ? 'pickup_pin' : 'dropoff_pin'}.svg',
                  width: 18,
                  height: 23,
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  pickup ? 'Điểm đón' : 'Điểm trả',
                  style: TextStyle(
                    color: pickup ? const Color(0xFF1B9C68) : _muted,
                    fontSize: 8.5,
                  ),
                ),
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Color(0xFF092752),
                    fontSize: 10.5,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  address,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: _muted, fontSize: 7.5),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(7),
            child: Image.asset(
              '$_detailAssets/$photo',
              width: 83,
              height: 48,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 8),
          RotatedBox(
            quarterTurns: 3,
            child: SvgPicture.asset(
              '$_detailAssets/chevron.svg',
              width: 11,
              height: 11,
            ),
          ),
        ],
      ),
    );
  }
}

class _AmenitiesSection extends StatelessWidget {
  const _AmenitiesSection();

  static const _items = <(String?, String)>[
    ('wifi_full.svg', 'Wi-Fi miễn phí'),
    ('snow_full.svg', 'Điều hòa 2 chiều'),
    ('water_full.svg', 'Nước uống'),
    ('usb_full.svg', 'Cổng sạc USB'),
    ('screen.svg', 'Màn hình giải trí'),
    ('blanket.svg', 'Chăn gối'),
    ('wc.svg', 'Nhà vệ sinh'),
    (null, 'tiện ích khác'),
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(7, 10, 7, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionTitle(icon: 'document.svg', title: 'Tiện ích trên xe'),
          const SizedBox(height: 6),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.zero,
            itemCount: _items.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              crossAxisSpacing: 5,
              mainAxisSpacing: 5,
              mainAxisExtent: 50,
            ),
            itemBuilder: (context, index) {
              final item = _items[index];
              return _WhiteCard(
                borderRadius: BorderRadius.circular(9),
                padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 5),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (item.$1 != null)
                      SvgPicture.asset(
                        '$_detailAssets/${item.$1}',
                        width: 18,
                        height: 18,
                      )
                    else
                      const Text(
                        '+3',
                        style: TextStyle(
                          color: Color(0xFF0078C9),
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    const SizedBox(height: 4),
                    Text(
                      item.$2,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Color(0xFF123862),
                        fontSize: 7.5,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _CancellationSection extends StatelessWidget {
  const _CancellationSection();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(7, 10, 7, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionTitle(icon: 'shield.svg', title: 'Chính sách hủy'),
          const SizedBox(height: 6),
          _WhiteCard(
            height: 38,
            padding: const EdgeInsets.symmetric(horizontal: 11),
            child: Row(
              children: [
                SizedBox.square(
                  dimension: 29,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      SvgPicture.asset(
                        '$_detailAssets/policy_backing.svg',
                        width: 29,
                        height: 29,
                      ),
                      SvgPicture.asset(
                        '$_detailAssets/policy_document.svg',
                        width: 16,
                        height: 16,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 11),
                const Expanded(
                  child: Text(
                    'Hoàn tiền tùy theo thời điểm hủy và điều kiện của chuyến.',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: _ink, fontSize: 8),
                  ),
                ),
                const SizedBox(width: 7),
                const Text(
                  'Xem chi tiết',
                  style: TextStyle(
                    color: Color(0xFF0072BD),
                    fontSize: 8.5,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 4),
                RotatedBox(
                  quarterTurns: 3,
                  child: SvgPicture.asset(
                    '$_detailAssets/chevron.svg',
                    width: 10,
                    height: 10,
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

class _NoticeSection extends StatelessWidget {
  const _NoticeSection();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 9, 14, 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SvgPicture.asset('$_detailAssets/warning.svg', width: 16, height: 16),
          const SizedBox(width: 12),
          const Text(
            'Lưu ý',
            style: TextStyle(
              color: Color(0xFF082752),
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(width: 18),
          const Expanded(
            child: Text(
              '• Vui lòng có mặt trước giờ khởi hành tối thiểu 30 phút.\n'
              '• Mang theo giấy tờ tùy thân khi lên xe.\n'
              '• Giờ đến có thể thay đổi tùy tình hình giao thông.',
              style: TextStyle(color: _muted, fontSize: 7.5, height: 1.35),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.icon, required this.title});

  final String icon;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SvgPicture.asset('$_detailAssets/$icon', width: 17, height: 17),
        const SizedBox(width: 11),
        Text(
          title,
          style: const TextStyle(
            color: Color(0xFF082752),
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class _WhiteCard extends StatelessWidget {
  const _WhiteCard({
    required this.child,
    required this.padding,
    this.height,
    this.borderRadius = const BorderRadius.all(Radius.circular(13)),
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final double? height;
  final BorderRadius borderRadius;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      padding: padding,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: borderRadius,
      ),
      child: child,
    );
  }
}

class _BookingBar extends StatelessWidget {
  const _BookingBar();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        height: 58,
        padding: const EdgeInsets.fromLTRB(14, 6, 14, 7),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(14)),
          boxShadow: [
            BoxShadow(
              color: Color(0x1421404F),
              offset: Offset(0, -5),
              blurRadius: 12,
            ),
          ],
        ),
        child: Row(
          children: [
            const Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Từ', style: TextStyle(color: _muted, fontSize: 8)),
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          '280.000 ₫',
                          maxLines: 1,
                          style: TextStyle(
                            color: Color(0xFF0064AF),
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      SizedBox(width: 3),
                      Text(
                        '/ người',
                        style: TextStyle(color: _muted, fontSize: 8),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(
              width: 148,
              height: 36,
              child: FilledButton(
                key: Key('trip-detail-cta'),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => const SeatSelectionScreen(),
                    ),
                  );
                },
                style: FilledButton.styleFrom(
                  backgroundColor: _blue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(11),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Chọn chỗ',
                      style: TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 12),
                    SvgPicture.asset(
                      '$_detailAssets/forward.svg',
                      width: 17,
                      height: 17,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
