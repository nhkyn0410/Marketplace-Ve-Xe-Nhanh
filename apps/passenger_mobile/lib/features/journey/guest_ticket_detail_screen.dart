import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:passenger_mobile/features/home/route_dock_tabbar.dart';
import 'package:passenger_mobile/features/journey/guest_journey_shared.dart';

class _PassengerTicket {
  const _PassengerTicket(this.name, this.seat);

  final String name;
  final String seat;
}

const _passengers = [
  _PassengerTicket('Nguyễn Văn Minh', 'A3'),
  _PassengerTicket('Trần Thị Mai', 'A02'),
  _PassengerTicket('Nguyễn Văn Khách', 'A03'),
  _PassengerTicket('Lê Minh Anh', 'A04'),
  _PassengerTicket('Phạm Quốc Bảo', 'A05'),
  _PassengerTicket('Võ Thanh Hà', 'A06'),
];

class GuestTicketDetailScreen extends StatefulWidget {
  const GuestTicketDetailScreen({
    required this.onBack,
    required this.onTabSelected,
    super.key,
  });

  final VoidCallback onBack;
  final ValueChanged<int> onTabSelected;

  @override
  State<GuestTicketDetailScreen> createState() =>
      _GuestTicketDetailScreenState();
}

class _GuestTicketDetailScreenState extends State<GuestTicketDetailScreen> {
  int _selectedPassenger = 0;
  bool _cancelled = false;

  _PassengerTicket get _passenger => _passengers[_selectedPassenger];

  void _movePassenger(int delta) {
    setState(() {
      _selectedPassenger =
          (_selectedPassenger + delta + _passengers.length) %
          _passengers.length;
    });
  }

  Future<void> _openPassengerPicker() async {
    final selected = await showModalBottomSheet<int>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      barrierColor: const Color(0x9908172B),
      builder: (context) =>
          _PassengerPickerSheet(selectedIndex: _selectedPassenger),
    );
    if (selected != null && mounted) {
      setState(() => _selectedPassenger = selected);
    }
  }

  Future<void> _startCancellation() async {
    final continueCancellation = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: const Color(0xA608172B),
      builder: (context) => const _CancelTicketSheet(),
    );
    if (continueCancellation != true || !mounted) return;

    final confirmed = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: const Color(0xA608172B),
      builder: (context) => const _ConfirmCancellationSheet(),
    );
    if (confirmed != true || !mounted) return;

    setState(() => _cancelled = true);
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: const Color(0xA608172B),
      builder: (context) => const _CancellationSuccessSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: const Key('guest-ticket-detail-screen'),
      extendBody: true,
      backgroundColor: journeyPage,
      bottomNavigationBar: RouteDockTabBar(
        currentIndex: 3,
        onTap: widget.onTabSelected,
      ),
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: journeyOverlayStyle,
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: JourneyDetailHeader(
                subtitle: _cancelled
                    ? 'Đơn VXN-8F3K2Q · 2 vé'
                    : 'Đơn VXN-8F3K2Q',
                onBack: widget.onBack,
                showLogo: _cancelled,
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(17, 0, 17, 142),
              sliver: SliverToBoxAdapter(
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 378),
                    child: Column(
                      children: [
                        _PassengerNavigator(
                          passenger: _passenger,
                          selectedIndex: _selectedPassenger,
                          onPrevious: () => _movePassenger(-1),
                          onNext: () => _movePassenger(1),
                          onShowAll: _openPassengerPicker,
                        ),
                        const SizedBox(height: 9),
                        _BoardingPass(
                          passenger: _passenger,
                          cancelled: _cancelled,
                        ),
                        if (_cancelled) ...[
                          const SizedBox(height: 7),
                          const _CancelledQrNotice(),
                        ],
                        const SizedBox(height: 9),
                        const _JourneyInformationCard(),
                        const SizedBox(height: 9),
                        _cancelled
                            ? const _RefundPaymentCard()
                            : const _PaymentCard(),
                        const SizedBox(height: 9),
                        const _CancellationPolicyCard(),
                        const SizedBox(height: 9),
                        if (_cancelled)
                          Row(
                            children: [
                              Expanded(
                                child: _DetailOutlineAction(
                                  label: 'Quay lại kết quả',
                                  onPressed: widget.onBack,
                                ),
                              ),
                              const SizedBox(width: 5),
                              Expanded(
                                child: _DetailFilledAction(
                                  label: 'Liên hệ hỗ trợ',
                                  color: journeyButton,
                                  onPressed: () => _showSupport(context),
                                ),
                              ),
                            ],
                          )
                        else
                          Row(
                            children: [
                              Expanded(
                                child: _DetailOutlineAction(
                                  label: 'Quay lại kết quả',
                                  onPressed: widget.onBack,
                                ),
                              ),
                              const SizedBox(width: 5),
                              Expanded(
                                child: _DetailFilledAction(
                                  key: const Key('guest-ticket-cancel-button'),
                                  label: 'Hủy vé',
                                  color: const Color(0xFFF04438),
                                  onPressed: _startCancellation,
                                ),
                              ),
                            ],
                          ),
                        const SizedBox(height: 12),
                        InkWell(
                          borderRadius: BorderRadius.circular(9),
                          onTap: () => _showSupport(context),
                          child: Container(
                            width: double.infinity,
                            height: 36,
                            alignment: Alignment.centerLeft,
                            padding: const EdgeInsets.symmetric(horizontal: 5),
                            decoration: BoxDecoration(
                              color: const Color(0xFFE4F5FC),
                              borderRadius: BorderRadius.circular(9),
                              border: Border.all(
                                color: const Color(0xFFC7EAF8),
                              ),
                            ),
                            child: const Text(
                              'Cần hỗ trợ về chuyến đi?  Gửi yêu cầu →',
                              style: TextStyle(
                                color: Color(0xFF087DCE),
                                fontSize: 11.5,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
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
    );
  }

  void _showSupport(BuildContext context) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        const SnackBar(content: Text('Đã mở yêu cầu hỗ trợ mô phỏng.')),
      );
  }
}

class _DetailOutlineAction extends StatelessWidget {
  const _DetailOutlineAction({required this.label, required this.onPressed});

  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 31,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: journeyPrimary,
          side: const BorderSide(color: journeyPrimary),
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
        ),
        child: Text(
          label,
          maxLines: 1,
          style: const TextStyle(
            fontSize: 11,
            height: 15 / 11,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

class _DetailFilledAction extends StatelessWidget {
  const _DetailFilledAction({
    required this.label,
    required this.color,
    required this.onPressed,
    super.key,
  });

  final String label;
  final Color color;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 31,
      child: FilledButton(
        onPressed: onPressed,
        style: FilledButton.styleFrom(
          backgroundColor: color,
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
        ),
        child: Text(
          label,
          maxLines: 1,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 11,
            height: 15 / 11,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

class _PassengerNavigator extends StatelessWidget {
  const _PassengerNavigator({
    required this.passenger,
    required this.selectedIndex,
    required this.onPrevious,
    required this.onNext,
    required this.onShowAll,
  });

  final _PassengerTicket passenger;
  final int selectedIndex;
  final VoidCallback onPrevious;
  final VoidCallback onNext;
  final VoidCallback onShowAll;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 59,
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 59,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Stack(
                children: [
                  Positioned(
                    left: 7,
                    top: 9,
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: const BoxDecoration(
                        color: Color(0xFF247EAB),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: SizedBox.square(
                          dimension: 24,
                          child: Center(
                            child: SvgPicture.asset(
                              '$journeyAssetRoot/passenger.svg',
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 55,
                    right: 76,
                    top: 5,
                    child: Text(
                      'Vé ${selectedIndex + 1}/6',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: journeyBody,
                        fontSize: 10,
                        height: 14 / 10,
                      ),
                    ),
                  ),
                  Positioned(
                    left: 55,
                    right: 76,
                    top: 19,
                    child: Text(
                      'Chỗ ${passenger.seat}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: journeyInk,
                        fontSize: 13,
                        height: 18 / 13,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  Positioned(
                    left: 55,
                    right: 60,
                    top: 37,
                    child: Text(
                      passenger.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: journeyBody,
                        fontSize: 11,
                        height: 15 / 11,
                      ),
                    ),
                  ),
                  Positioned(
                    right: 41,
                    top: 15,
                    child: _SmallIconButton(
                      asset: 'previous.svg',
                      backgroundColor: const Color(0xFFECFAFF),
                      onTap: onPrevious,
                    ),
                  ),
                  Positioned(
                    right: 7,
                    top: 15,
                    child: _SmallIconButton(
                      asset: 'next.svg',
                      backgroundColor: const Color(0xFFABE0FF),
                      onTap: onNext,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 6),
          Container(
            width: 118,
            height: 59,
            padding: const EdgeInsets.fromLTRB(5, 12, 5, 11),
            decoration: BoxDecoration(
              color: const Color(0xFFF5FCFF),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Material(
              color: const Color(0xFFF0FBFF),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(7),
                side: const BorderSide(color: Color(0xFFB9E8FF)),
              ),
              child: InkWell(
                borderRadius: BorderRadius.circular(7),
                onTap: onShowAll,
                child: const Center(
                  child: Text(
                    'Tất cả vé (6) ›',
                    maxLines: 1,
                    style: TextStyle(
                      color: journeyPrimary,
                      fontSize: 11,
                      height: 15 / 11,
                      fontWeight: FontWeight.w600,
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

class _SmallIconButton extends StatelessWidget {
  const _SmallIconButton({
    required this.asset,
    required this.backgroundColor,
    required this.onTap,
  });

  final String asset;
  final Color backgroundColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: backgroundColor,
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: SizedBox.square(
          dimension: 29,
          child: Center(
            child: SizedBox.square(
              dimension: 20,
              child: Center(
                child: SvgPicture.asset('$journeyAssetRoot/$asset'),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _BoardingPass extends StatelessWidget {
  const _BoardingPass({required this.passenger, required this.cancelled});

  final _PassengerTicket passenger;
  final bool cancelled;

  @override
  Widget build(BuildContext context) {
    final displayPassenger = passenger.name == 'Nguyễn Văn Minh'
        ? 'Nguyễn Văn Khách'
        : passenger.name;
    return _ScaledDesignBox(
      height: 186,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(9),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: cancelled
                  ? const [
                      Color(0xFFFFF7F6),
                      Color(0xFFFFE8E5),
                      Color(0xFFFFE8E5),
                    ]
                  : const [
                      Color(0xFFFFFAED),
                      Color(0xFFFFF4D9),
                      Color(0xFFFFF9EF),
                    ],
              stops: const [0, .65, 1],
            ),
            borderRadius: BorderRadius.circular(9),
            border: Border.all(
              color: cancelled
                  ? const Color(0xFFF97066)
                  : const Color(0xFFFFC458),
              width: .7,
            ),
          ),
          child: Stack(
            clipBehavior: Clip.hardEdge,
            children: [
              Positioned(
                left: 7.3,
                top: 7.3,
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: SizedBox.square(
                      dimension: 20,
                      child: Center(
                        child: SvgPicture.asset(
                          '$journeyAssetRoot/ticket_blue.svg',
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const Positioned(
                left: 46.3,
                top: 9.3,
                width: 140,
                child: Text(
                  'VÉ XE NHANH',
                  maxLines: 1,
                  style: TextStyle(
                    color: Color(0xFFE97800),
                    fontSize: 10,
                    height: 14 / 10,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const Positioned(
                left: 46.3,
                top: 23.3,
                width: 195,
                child: Text(
                  'Vé chuyến - Phương Nam Travel',
                  maxLines: 1,
                  style: TextStyle(
                    color: journeyBody,
                    fontSize: 9,
                    height: 13 / 9,
                  ),
                ),
              ),
              Positioned(
                left: 212.3,
                top: 12.3,
                width: 47,
                height: 20,
                child: Container(
                  decoration: BoxDecoration(
                    color: cancelled
                        ? const Color(0xFFD92D20)
                        : const Color(0xFF009669),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    cancelled ? 'Đã hủy' : 'Hợp lệ',
                    maxLines: 1,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 9.5,
                      height: 13 / 9.5,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              const Positioned(
                left: 13.3,
                top: 47.3,
                width: 146,
                child: Text(
                  'TP. Hồ Chí Minh',
                  maxLines: 1,
                  style: TextStyle(
                    color: journeyInk,
                    fontSize: 16,
                    height: 22 / 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Positioned(
                left: 145.3,
                top: 52.3,
                child: SizedBox.square(
                  dimension: 19,
                  child: Center(
                    child: SvgPicture.asset(
                      '$journeyAssetRoot/direction_orange.svg',
                    ),
                  ),
                ),
              ),
              const Positioned(
                left: 170.3,
                top: 47.3,
                width: 88,
                child: Text(
                  'Đà Lạt',
                  maxLines: 1,
                  style: TextStyle(
                    color: journeyInk,
                    fontSize: 16,
                    height: 22 / 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const Positioned(
                left: 13.3,
                top: 70.3,
                width: 245,
                child: Text(
                  'Thứ Sáu · 16/10/2026',
                  maxLines: 1,
                  style: TextStyle(
                    color: journeyInk,
                    fontSize: 11,
                    height: 15 / 11,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const Positioned(
                left: 13.3,
                top: 91.3,
                child: _BoardingStation(
                  width: 113,
                  time: '22:30',
                  station: 'Bến xe Miền Đông mới',
                ),
              ),
              Positioned(
                left: 133.3,
                top: 103.3,
                child: SizedBox.square(
                  dimension: 19,
                  child: Center(
                    child: SvgPicture.asset(
                      '$journeyAssetRoot/direction_orange.svg',
                    ),
                  ),
                ),
              ),
              const Positioned(
                left: 156.3,
                top: 91.3,
                child: _BoardingStation(
                  width: 109,
                  time: '05:30',
                  note: '+1 ngày',
                  station: 'Bến xe liên tỉnh Đà Lạt',
                ),
              ),
              const Positioned(
                left: 13.3,
                top: 142.3,
                width: 110,
                child: Text(
                  'Hành khách',
                  style: TextStyle(
                    color: journeyBody,
                    fontSize: 9,
                    height: 13 / 9,
                  ),
                ),
              ),
              Positioned(
                left: 13.3,
                top: 159.3,
                width: 110,
                child: Text(
                  displayPassenger,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: journeyInk,
                    fontSize: 9,
                    height: 13 / 9,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const Positioned(
                left: 125.3,
                top: 142.3,
                width: 29,
                child: Text(
                  'Chỗ',
                  style: TextStyle(
                    color: journeyBody,
                    fontSize: 9,
                    height: 13 / 9,
                  ),
                ),
              ),
              Positioned(
                left: 125.3,
                top: 159.3,
                width: 29,
                child: Text(
                  passenger.seat,
                  maxLines: 1,
                  style: const TextStyle(
                    color: journeyInk,
                    fontSize: 9,
                    height: 13 / 9,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const Positioned(
                left: 161.3,
                top: 142.3,
                width: 107,
                child: Text(
                  'Loại chỗ',
                  style: TextStyle(
                    color: journeyBody,
                    fontSize: 9,
                    height: 13 / 9,
                  ),
                ),
              ),
              const Positioned(
                left: 161.3,
                top: 159.3,
                width: 107,
                child: Text(
                  'Giường đơn - Tầng dưới',
                  maxLines: 1,
                  style: TextStyle(
                    color: journeyInk,
                    fontSize: 9,
                    height: 13 / 9,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Positioned(
                left: 272.3,
                top: 0,
                child: RotatedBox(
                  quarterTurns: 1,
                  child: SvgPicture.asset('$journeyAssetRoot/perforation.svg'),
                ),
              ),
              Positioned(
                left: 266.8,
                top: -5.7,
                child: SvgPicture.asset('$journeyAssetRoot/ticket_notch.svg'),
              ),
              Positioned(
                left: 266.8,
                top: 180.3,
                child: SvgPicture.asset('$journeyAssetRoot/ticket_notch.svg'),
              ),
              Positioned(
                left: 279.3,
                top: 22.3,
                width: 91,
                height: 91,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(7),
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Opacity(
                        opacity: cancelled ? .34 : 1,
                        child: SvgPicture.asset(
                          '$journeyAssetRoot/ticket_qr.svg',
                        ),
                      ),
                      if (cancelled)
                        Transform.rotate(
                          angle: -math.pi / 4,
                          child: Container(
                            width: 82,
                            height: 4,
                            decoration: BoxDecoration(
                              color: const Color(0xFFD92D20),
                              borderRadius: BorderRadius.circular(99),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              Positioned(
                left: 278,
                top: 119.3,
                width: 98,
                child: Text(
                  'VXN-8F3K2Q-0${_passengers.indexOf(passenger) + 1}',
                  maxLines: 1,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: journeyInk,
                    fontSize: 9.5,
                    height: 13 / 9.5,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Positioned(
                left: 278,
                top: 137.3,
                width: 98,
                child: Text(
                  cancelled ? 'QR không còn hiệu lực' : 'Lên xe quét mã',
                  maxLines: 1,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: cancelled
                        ? const Color(0xFFD92D20)
                        : const Color(0xFFC67000),
                    fontSize: 9,
                    height: 13 / 9,
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

class _BoardingStation extends StatelessWidget {
  const _BoardingStation({
    required this.width,
    required this.time,
    required this.station,
    this.note,
  });

  final double width;
  final String time;
  final String station;
  final String? note;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: 43,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Stack(
        children: [
          Positioned(
            left: 8,
            top: 3,
            child: Text(
              time,
              style: const TextStyle(
                color: journeyInk,
                fontSize: 16,
                height: 22 / 16,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          if (note != null)
            Positioned(
              left: 72,
              top: 11,
              child: Text(
                note!,
                style: const TextStyle(
                  color: Color(0xFFF18800),
                  fontSize: 7.5,
                  height: 11 / 7.5,
                ),
              ),
            ),
          Positioned(
            left: 8,
            top: 26,
            width: width - 13,
            child: Text(
              station,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: journeyBody,
                fontSize: 8.5,
                height: 12 / 8.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ScaledDesignBox extends StatelessWidget {
  const _ScaledDesignBox({required this.height, required this.child});

  final double height;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth.isFinite
            ? constraints.maxWidth
            : 378.0;
        final scale = width / 378;
        return SizedBox(
          width: width,
          height: height * scale,
          child: FittedBox(
            alignment: Alignment.topLeft,
            fit: BoxFit.fill,
            child: SizedBox(width: 378, height: height, child: child),
          ),
        );
      },
    );
  }
}

class _CancelledQrNotice extends StatelessWidget {
  const _CancelledQrNotice();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF3F2),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFFECACA)),
      ),
      child: const Text(
        'Vé đã hủy · Mã QR không còn hiệu lực và chỗ ngồi đã được giải phóng.',
        style: TextStyle(
          color: Color(0xFFB42318),
          fontSize: 9.5,
          height: 14 / 9.5,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

class _JourneyInformationCard extends StatelessWidget {
  const _JourneyInformationCard();

  @override
  Widget build(BuildContext context) {
    return _ScaledDesignBox(
      height: 113,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(9),
          border: Border.all(color: const Color(0xFFDFF3FC)),
        ),
        child: Stack(
          children: [
            Positioned(
              left: 11,
              top: 8,
              child: SizedBox.square(
                dimension: 19,
                child: Center(
                  child: SvgPicture.asset('$journeyAssetRoot/bus_blue.svg'),
                ),
              ),
            ),
            const Positioned(
              left: 40,
              top: 8,
              width: 280,
              child: Text(
                'Hành trình',
                style: TextStyle(
                  color: journeyInk,
                  fontSize: 13,
                  height: 18 / 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const Positioned(
              left: 7,
              top: 31,
              child: _JourneyStopPanel(
                title: 'ĐIỂM ĐÓN · 22:30',
                station: 'Bến xe Miền Đông mới',
                address: '501 Hoàng Hữu Nam, TP. Thủ Đức,\nTP. Hồ Chí Minh',
              ),
            ),
            const Positioned(
              left: 204,
              top: 31,
              child: _JourneyStopPanel(
                title: 'ĐIỂM TRẢ · 05:30 (+1 NGÀY)',
                station: 'Bến xe liên tỉnh Đà Lạt',
                address: '1 Tô Hiến Thành, Phường 3,\nĐà Lạt',
              ),
            ),
            Positioned(
              left: 180,
              top: 59,
              child: SizedBox.square(
                dimension: 20,
                child: Center(
                  child: SvgPicture.asset(
                    '$journeyAssetRoot/direction_orange.svg',
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _JourneyStopPanel extends StatelessWidget {
  const _JourneyStopPanel({
    required this.title,
    required this.station,
    required this.address,
  });

  final String title;
  final String station;
  final String address;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 165,
      height: 73,
      decoration: BoxDecoration(
        color: const Color(0xFFF5F7FE),
        borderRadius: BorderRadius.circular(7),
      ),
      child: Stack(
        children: [
          Positioned(
            left: 10,
            top: 8,
            width: 151,
            child: Text(
              title,
              maxLines: 1,
              style: const TextStyle(
                color: journeyBody,
                fontSize: 8.8,
                height: 12 / 8.8,
              ),
            ),
          ),
          Positioned(
            left: 10,
            top: 24,
            width: 151,
            child: Text(
              station,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: journeyInk,
                fontSize: 10,
                height: 14 / 10,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Positioned(
            left: 10,
            top: 42,
            width: 151,
            child: Text(
              address,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: journeyBody,
                fontSize: 9,
                height: 13 / 9,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PaymentCard extends StatelessWidget {
  const _PaymentCard();

  @override
  Widget build(BuildContext context) {
    return _ScaledDesignBox(
      height: 111,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(9),
          border: Border.all(color: const Color(0xFFDFF3FC)),
        ),
        child: Stack(
          children: [
            Positioned(
              left: 11,
              top: 8,
              child: SizedBox.square(
                dimension: 19,
                child: Center(
                  child: SvgPicture.asset('$journeyAssetRoot/card_blue.svg'),
                ),
              ),
            ),
            const Positioned(
              left: 40,
              top: 8,
              width: 280,
              child: Text(
                'Thanh toán',
                style: TextStyle(
                  color: journeyInk,
                  fontSize: 13,
                  height: 18 / 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const _PaymentLine(
              top: 31,
              label: 'Giá vé (2 chỗ)',
              value: '560.000đ',
            ),
            const _PaymentLine(top: 47, label: 'Phí dịch vụ', value: '0đ'),
            const _PaymentLine(
              top: 63,
              label: 'Voucher đổi điểm',
              value: '-100.000đ',
              valueColor: Color(0xFF009F4C),
            ),
            const Positioned(
              left: 13,
              top: 86,
              width: 114,
              child: Text(
                'Đã thanh toán',
                style: TextStyle(
                  color: journeyInk,
                  fontSize: 10,
                  height: 14 / 10,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const Positioned(
              left: 90,
              top: 83,
              width: 100,
              child: Text(
                '460.000đ',
                textAlign: TextAlign.right,
                style: TextStyle(
                  color: journeyPrimary,
                  fontSize: 14,
                  height: 20 / 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const Positioned(
              left: 207,
              top: 26,
              child: _PaymentMetadataPanel(),
            ),
          ],
        ),
      ),
    );
  }
}

class _PaymentLine extends StatelessWidget {
  const _PaymentLine({
    required this.top,
    required this.label,
    required this.value,
    this.valueColor = journeyInk,
  });

  final double top;
  final String label;
  final String value;
  final Color valueColor;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          left: 13,
          top: top,
          width: 124,
          child: Text(
            label,
            style: const TextStyle(
              color: journeyBody,
              fontSize: 9.5,
              height: 13 / 9.5,
            ),
          ),
        ),
        Positioned(
          left: 118,
          top: top,
          width: 72,
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: TextStyle(
              color: valueColor,
              fontSize: 9.5,
              height: 13 / 9.5,
            ),
          ),
        ),
      ],
    );
  }
}

class _PaymentMetadataPanel extends StatelessWidget {
  const _PaymentMetadataPanel();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 161,
      height: 75,
      decoration: BoxDecoration(
        color: const Color(0xFFF5F7FE),
        borderRadius: BorderRadius.circular(7),
      ),
      child: const Stack(
        children: [
          _MetadataLine(top: 8, label: 'Phương thức', value: 'VNPay'),
          _MetadataLine(top: 29, label: 'Mã giao dịch', value: 'VNP14982231'),
          _MetadataLine(
            top: 50,
            label: 'Trạng thái',
            value: 'Thành công',
            valueColor: Color(0xFF009B61),
          ),
        ],
      ),
    );
  }
}

class _MetadataLine extends StatelessWidget {
  const _MetadataLine({
    required this.top,
    required this.label,
    required this.value,
    this.valueColor = journeyInk,
  });

  final double top;
  final String label;
  final String value;
  final Color valueColor;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          left: 9,
          top: top,
          width: 76,
          child: Text(
            label,
            style: const TextStyle(
              color: journeyBody,
              fontSize: 9,
              height: 13 / 9,
            ),
          ),
        ),
        Positioned(
          left: 75,
          top: top,
          width: 78,
          child: Text(
            value,
            maxLines: 1,
            textAlign: TextAlign.right,
            style: TextStyle(color: valueColor, fontSize: 9, height: 13 / 9),
          ),
        ),
      ],
    );
  }
}

class _RefundPaymentCard extends StatelessWidget {
  const _RefundPaymentCard();

  @override
  Widget build(BuildContext context) {
    return const _DetailCard(
      icon: 'wallet.svg',
      title: 'Thanh toán / hoàn tiền',
      child: Column(
        children: [
          _ValueRow(label: 'Giá vé đã thanh toán', value: '230.000đ'),
          _ValueRow(
            label: 'Phí hủy vé',
            value: '-23.000đ',
            valueColor: Color(0xFFD92D20),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 5),
            child: Divider(height: 1, color: Color(0xFFE8EEF4)),
          ),
          _ValueRow(
            label: 'Hoàn dự kiến',
            value: '207.000đ',
            emphasized: true,
            valueColor: Color(0xFF067647),
          ),
          SizedBox(height: 4),
          _ValueRow(label: 'Phương thức hoàn', value: 'VNPay'),
          _ValueRow(label: 'Mã giao dịch', value: 'VNP14982231'),
          _ValueRow(
            label: 'Trạng thái',
            value: 'Đang xử lý',
            valueColor: Color(0xFFF79009),
          ),
        ],
      ),
    );
  }
}

class _CancellationPolicyCard extends StatelessWidget {
  const _CancellationPolicyCard();

  @override
  Widget build(BuildContext context) {
    return _ScaledDesignBox(
      height: 87,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(9),
          border: Border.all(color: const Color(0xFFDFF3FC)),
        ),
        child: Stack(
          children: [
            Positioned(
              left: 11,
              top: 8,
              child: SizedBox.square(
                dimension: 19,
                child: Center(
                  child: SvgPicture.asset('$journeyAssetRoot/policy.svg'),
                ),
              ),
            ),
            const Positioned(
              left: 40,
              top: 8,
              width: 280,
              child: Text(
                'Chính sách hủy / hoàn tiền',
                style: TextStyle(
                  color: journeyInk,
                  fontSize: 13,
                  height: 18 / 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const _PolicyLine(
              top: 33,
              label: 'Trước 22:30 · 15/10',
              value: 'Hoàn 90%',
              valueColor: Color(0xFF009F4C),
            ),
            const _PolicyLine(
              top: 49,
              label: 'Đến 18:30 · 16/10',
              value: 'Hoàn 50%',
              valueColor: Color(0xFFF18800),
            ),
            const _PolicyLine(
              top: 65,
              label: 'Sau 18:30 · 16/10',
              value: 'Không hoàn',
              valueColor: Color(0xFFF04438),
            ),
            Positioned(
              left: 222,
              top: 17,
              child: Container(
                width: 147,
                height: 58,
                decoration: BoxDecoration(
                  color: const Color(0xFFEAF8FF),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Stack(
                  children: [
                    Positioned(
                      left: 8,
                      top: 19,
                      child: SizedBox.square(
                        dimension: 16,
                        child: Center(
                          child: SvgPicture.asset('$journeyAssetRoot/info.svg'),
                        ),
                      ),
                    ),
                    const Positioned(
                      left: 32,
                      top: 8,
                      width: 112,
                      child: Text(
                        'Hiện tại: vé này được hoàn 90%\nsố tiền đã trả khi hủy, nếu đáp\nứng điều kiện.',
                        maxLines: 3,
                        style: TextStyle(
                          color: journeyBody,
                          fontSize: 7.5,
                          height: 11 / 7.5,
                        ),
                      ),
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

class _PolicyLine extends StatelessWidget {
  const _PolicyLine({
    required this.top,
    required this.label,
    required this.value,
    required this.valueColor,
  });

  final double top;
  final String label;
  final String value;
  final Color valueColor;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          left: 13,
          top: top,
          width: 137,
          child: Text(
            label,
            style: const TextStyle(
              color: journeyBody,
              fontSize: 9.5,
              height: 13 / 9.5,
            ),
          ),
        ),
        Positioned(
          left: 138,
          top: top,
          width: 71,
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: TextStyle(
              color: valueColor,
              fontSize: 9.5,
              height: 13 / 9.5,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}

class _DetailCard extends StatelessWidget {
  const _DetailCard({
    required this.icon,
    required this.title,
    required this.child,
  });

  final String icon;
  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return JourneySurface(
      radius: 9,
      borderColor: const Color(0xFFDFF0F8),
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              SvgPicture.asset(
                '$journeyAssetRoot/$icon',
                width: 16,
                height: 16,
              ),
              const SizedBox(width: 6),
              Text(
                title,
                style: const TextStyle(
                  color: journeyInk,
                  fontSize: 11.5,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 7),
          child,
        ],
      ),
    );
  }
}

class _ValueRow extends StatelessWidget {
  const _ValueRow({
    required this.label,
    required this.value,
    this.emphasized = false,
    this.valueColor,
  });

  final String label;
  final String value;
  final bool emphasized;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 1.5),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                color: emphasized ? journeyInk : journeyBody,
                fontSize: emphasized ? 9.5 : 8.5,
                fontWeight: emphasized ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: valueColor ?? journeyInk,
              fontSize: emphasized ? 11 : 9,
              fontWeight: emphasized ? FontWeight.w700 : FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _PassengerPickerSheet extends StatefulWidget {
  const _PassengerPickerSheet({required this.selectedIndex});

  final int selectedIndex;

  @override
  State<_PassengerPickerSheet> createState() => _PassengerPickerSheetState();
}

class _PassengerPickerSheetState extends State<_PassengerPickerSheet> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final height = math.min(543.0, MediaQuery.sizeOf(context).height * .82);
    final indexes = List.generate(_passengers.length, (index) => index)
        .where((index) {
          final query = _query.toLowerCase().trim();
          return query.isEmpty ||
              _passengers[index].name.toLowerCase().contains(query) ||
              _passengers[index].seat.toLowerCase().contains(query);
        })
        .toList(growable: false);

    return Container(
      height: height,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          const SizedBox(height: 10),
          const JourneySheetHandle(),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 13, 13, 9),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Chọn vé từng hành khách',
                        style: TextStyle(
                          color: journeyInk,
                          fontSize: 21,
                          height: 29 / 21,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'Chọn hành khách để xem đúng thông tin vé và mã QR.',
                        style: TextStyle(
                          color: journeyBody,
                          fontSize: 11,
                          height: 16 / 11,
                        ),
                      ),
                    ],
                  ),
                ),
                JourneyIconButton(
                  asset: '$journeyAssetRoot/close.svg',
                  onTap: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: SizedBox(
              height: 44,
              child: TextField(
                onChanged: (value) => setState(() => _query = value),
                style: const TextStyle(fontSize: 12.5, color: journeyInk),
                decoration: InputDecoration(
                  hintText: 'Tìm theo tên hành khách hoặc số ghế',
                  hintStyle: const TextStyle(
                    color: Color(0xFF92A3B6),
                    fontSize: 11.5,
                  ),
                  prefixIcon: Padding(
                    padding: const EdgeInsets.all(12),
                    child: SvgPicture.asset(
                      '$journeyAssetRoot/picker_search.svg',
                    ),
                  ),
                  filled: true,
                  fillColor: const Color(0xFFF8FAFC),
                  contentPadding: EdgeInsets.zero,
                  border: _searchBorder(),
                  enabledBorder: _searchBorder(),
                  focusedBorder: _searchBorder(journeyPrimary),
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 18),
              itemCount: indexes.length,
              separatorBuilder: (_, _) => const SizedBox(height: 8),
              itemBuilder: (context, itemIndex) {
                final index = indexes[itemIndex];
                final passenger = _passengers[index];
                final selected = index == widget.selectedIndex;
                return InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: () => Navigator.pop(context, index),
                  child: Container(
                    height: 51,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: selected
                          ? const Color(0xFFEAF7FE)
                          : const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: selected
                            ? const Color(0xFF82CFF2)
                            : const Color(0xFFE4EAF0),
                      ),
                    ),
                    child: Row(
                      children: [
                        SvgPicture.asset(
                          '$journeyAssetRoot/${selected ? 'passenger_selected.svg' : 'passenger_unselected.svg'}',
                          width: 28,
                          height: 28,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                passenger.name,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: journeyInk,
                                  fontSize: 12.5,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                'Chỗ ${passenger.seat} · Giường đơn - Tầng dưới',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: journeyBody,
                                  fontSize: 9.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (selected)
                          SvgPicture.asset(
                            '$journeyAssetRoot/check.svg',
                            width: 20,
                            height: 20,
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  OutlineInputBorder _searchBorder([Color color = const Color(0xFFD8E2EC)]) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(11),
      borderSide: BorderSide(color: color),
    );
  }
}

class _CancelTicketSheet extends StatefulWidget {
  const _CancelTicketSheet();

  @override
  State<_CancelTicketSheet> createState() => _CancelTicketSheetState();
}

class _CancelTicketSheetState extends State<_CancelTicketSheet> {
  String? _reason;

  @override
  Widget build(BuildContext context) {
    return _SheetFrame(
      desiredHeight: 536,
      title: 'Hủy vé',
      onClose: () => Navigator.pop(context, false),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const _CancellationTicketSummary(),
          const SizedBox(height: 10),
          const _RefundEstimateCard(),
          const SizedBox(height: 10),
          const Text(
            'Lý do hủy (không bắt buộc)',
            style: TextStyle(
              color: journeyInk,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 5),
          DropdownButtonFormField<String>(
            initialValue: _reason,
            isExpanded: true,
            icon: SvgPicture.asset(
              '$journeyAssetRoot/cancel_chevron.svg',
              width: 18,
              height: 18,
            ),
            hint: const Text(
              'Chọn lý do',
              style: TextStyle(color: journeyBody, fontSize: 11.5),
            ),
            items: const [
              DropdownMenuItem(value: 'plan', child: Text('Thay đổi kế hoạch')),
              DropdownMenuItem(
                value: 'time',
                child: Text('Không phù hợp giờ đi'),
              ),
              DropdownMenuItem(value: 'other', child: Text('Lý do khác')),
            ],
            onChanged: (value) => setState(() => _reason = value),
            style: const TextStyle(color: journeyInk, fontSize: 11.5),
            decoration: InputDecoration(
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 12,
              ),
              border: _sheetInputBorder(),
              enabledBorder: _sheetInputBorder(),
              focusedBorder: _sheetInputBorder(journeyPrimary),
            ),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(9),
            decoration: BoxDecoration(
              color: const Color(0xFFFFFAEB),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0xFFFEDFA5)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SvgPicture.asset(
                  '$journeyAssetRoot/warning.svg',
                  width: 17,
                  height: 17,
                ),
                const SizedBox(width: 7),
                const Expanded(
                  child: Text(
                    'Voucher đã dùng cho đơn này không được trả lại khi bạn tự hủy vé. Vé đã hủy không khôi phục được.',
                    style: TextStyle(
                      color: Color(0xFF8A4B08),
                      fontSize: 9.5,
                      height: 14 / 9.5,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      actions: Row(
        children: [
          Expanded(
            child: JourneyOutlineButton(
              label: 'Giữ vé',
              onPressed: () => Navigator.pop(context, false),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: JourneyPrimaryButton(
              label: 'Tiếp tục',
              backgroundColor: const Color(0xFFF04438),
              height: 40,
              onPressed: () => Navigator.pop(context, true),
            ),
          ),
        ],
      ),
    );
  }
}

class _ConfirmCancellationSheet extends StatefulWidget {
  const _ConfirmCancellationSheet();

  @override
  State<_ConfirmCancellationSheet> createState() =>
      _ConfirmCancellationSheetState();
}

class _ConfirmCancellationSheetState extends State<_ConfirmCancellationSheet> {
  String _otp = '';

  @override
  Widget build(BuildContext context) {
    return _SheetFrame(
      desiredHeight: 516,
      title: 'Xác nhận hủy vé',
      onClose: () => Navigator.pop(context, false),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const _CancellationTicketSummary(),
          const SizedBox(height: 16),
          const Text(
            'Nhập mã OTP đã gửi đến email',
            style: TextStyle(color: journeyBody, fontSize: 11.5),
          ),
          const Text(
            'nguy***@gmail.com',
            style: TextStyle(
              color: journeyInk,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 11),
          JourneyOtpFields(
            boxHeight: 54,
            onChanged: (value) => setState(() => _otp = value),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              SvgPicture.asset(
                '$journeyAssetRoot/clock.svg',
                width: 15,
                height: 15,
              ),
              const SizedBox(width: 5),
              const Text(
                'Mã có hiệu lực ',
                style: TextStyle(color: journeyBody, fontSize: 10.5),
              ),
              const Text(
                '04:32',
                style: TextStyle(
                  color: Color(0xFFF79009),
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              TextButton(
                onPressed: () {},
                style: TextButton.styleFrom(
                  minimumSize: const Size(0, 28),
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: const Text(
                  'Gửi lại mã',
                  style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Divider(height: 1, color: Color(0xFFE5EAF0)),
          ),
          const _ValueRow(
            label: 'Số tiền hoàn dự kiến',
            value: '207.000đ',
            emphasized: true,
            valueColor: Color(0xFF067647),
          ),
          const _ValueRow(label: 'Phương thức hoàn', value: 'VNPay'),
        ],
      ),
      actions: Row(
        children: [
          Expanded(
            child: JourneyOutlineButton(
              label: 'Quay lại',
              onPressed: () => Navigator.pop(context, false),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: JourneyPrimaryButton(
              key: const Key('confirm-ticket-cancellation'),
              label: 'Xác nhận hủy vé',
              backgroundColor: const Color(0xFFF04438),
              height: 40,
              onPressed: () {
                if (_otp.length != 6) {
                  ScaffoldMessenger.of(context)
                    ..hideCurrentSnackBar()
                    ..showSnackBar(
                      const SnackBar(
                        content: Text('Vui lòng nhập đủ 6 số OTP.'),
                      ),
                    );
                  return;
                }
                Navigator.pop(context, true);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _CancellationSuccessSheet extends StatelessWidget {
  const _CancellationSuccessSheet();

  @override
  Widget build(BuildContext context) {
    return _SheetFrame(
      desiredHeight: 536,
      title: 'Hủy vé thành công',
      onClose: () => Navigator.pop(context),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const _CancellationTicketSummary(),
          const SizedBox(height: 11),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFECFDF3),
              borderRadius: BorderRadius.circular(13),
              border: Border.all(color: const Color(0xFFA6F4C5)),
            ),
            child: const Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.check_circle, color: Color(0xFF12B76A), size: 25),
                SizedBox(width: 9),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Bạn đã hủy vé thành công',
                        style: TextStyle(
                          color: Color(0xFF067647),
                          fontSize: 12.5,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'Yêu cầu hủy vé đã được tạo thành công và vé đã được hủy. Chỗ ngồi của bạn không còn hiệu lực.',
                        style: TextStyle(
                          color: Color(0xFF16794E),
                          fontSize: 9.5,
                          height: 14 / 9.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 11),
          JourneySurface(
            padding: const EdgeInsets.all(12),
            borderColor: const Color(0xFFD8E6F0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    SvgPicture.asset(
                      '$journeyAssetRoot/wallet.svg',
                      width: 17,
                      height: 17,
                    ),
                    const SizedBox(width: 6),
                    const Text(
                      'Thông tin hoàn tiền',
                      style: TextStyle(
                        color: journeyInk,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                const _ValueRow(
                  label: 'Số tiền hoàn dự kiến',
                  value: '207.000đ',
                  emphasized: true,
                  valueColor: Color(0xFF067647),
                ),
                const _ValueRow(label: 'Phương thức hoàn', value: 'VNPay'),
                const _ValueRow(
                  label: 'Trạng thái',
                  value: 'Đang xử lý',
                  valueColor: Color(0xFFF79009),
                ),
              ],
            ),
          ),
        ],
      ),
      actions: Row(
        children: [
          Expanded(
            child: JourneyOutlineButton(
              label: 'Đóng',
              onPressed: () => Navigator.pop(context),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: JourneyPrimaryButton(
              label: 'Xem chi tiết vé',
              height: 40,
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ],
      ),
    );
  }
}

class _CancellationTicketSummary extends StatelessWidget {
  const _CancellationTicketSummary();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F7FC),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(11),
            ),
            child: Center(
              child: SvgPicture.asset(
                '$journeyAssetRoot/cancel_ticket.svg',
                width: 20,
                height: 20,
              ),
            ),
          ),
          const SizedBox(width: 9),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Chỗ A3 · Nguyễn Văn Khách',
                  style: TextStyle(
                    color: journeyInk,
                    fontSize: 12.5,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'TP. Hồ Chí Minh → Đà Lạt',
                  style: TextStyle(
                    color: journeyInk,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'Khởi hành 22:30 · Thứ Sáu, 16/10/2026 · Phương Nam Travel',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: journeyBody,
                    fontSize: 9,
                    height: 13 / 9,
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

class _RefundEstimateCard extends StatelessWidget {
  const _RefundEstimateCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFCDDAF0), width: 1.5),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Tiền hoàn dự kiến (theo chính sách lưu lúc đặt)',
            style: TextStyle(
              color: journeyInk,
              fontSize: 10.5,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 8),
          _ValueRow(label: 'Số tiền đã trả cho vé hủy', value: '230.000đ'),
          _ValueRow(
            label: 'Phí hủy 10% (hủy trước 24 giờ)',
            value: '−23.000đ',
            valueColor: Color(0xFFD92D20),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 6),
            child: Divider(height: 1, color: Color(0xFFE5EAF0)),
          ),
          _ValueRow(
            label: 'Hoàn về VNPay',
            value: '207.000đ',
            emphasized: true,
            valueColor: Color(0xFF067647),
          ),
        ],
      ),
    );
  }
}

class _SheetFrame extends StatelessWidget {
  const _SheetFrame({
    required this.desiredHeight,
    required this.title,
    required this.onClose,
    required this.body,
    required this.actions,
  });

  final double desiredHeight;
  final String title;
  final VoidCallback onClose;
  final Widget body;
  final Widget actions;

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final available = media.size.height - media.viewInsets.bottom - 12;
    final height = math.min(desiredHeight, available);
    return AnimatedPadding(
      duration: const Duration(milliseconds: 180),
      curve: Curves.easeOut,
      padding: EdgeInsets.only(bottom: media.viewInsets.bottom),
      child: Container(
        height: height,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
        ),
        child: Column(
          children: [
            const SizedBox(height: 9),
            const JourneySheetHandle(),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 7, 10, 2),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      title,
                      style: const TextStyle(
                        color: journeyInk,
                        fontSize: 21,
                        height: 29 / 21,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  JourneyIconButton(
                    asset: '$journeyAssetRoot/close.svg',
                    onTap: onClose,
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                padding: const EdgeInsets.fromLTRB(16, 4, 16, 10),
                child: body,
              ),
            ),
            SafeArea(
              top: false,
              minimum: const EdgeInsets.fromLTRB(16, 8, 16, 12),
              child: actions,
            ),
          ],
        ),
      ),
    );
  }
}

OutlineInputBorder _sheetInputBorder([Color color = const Color(0xFFD8E2EC)]) {
  return OutlineInputBorder(
    borderRadius: BorderRadius.circular(10),
    borderSide: BorderSide(color: color),
  );
}
