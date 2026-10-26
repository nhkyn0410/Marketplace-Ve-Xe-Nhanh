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
                        const SizedBox(height: 8),
                        _BoardingPass(
                          passenger: _passenger,
                          cancelled: _cancelled,
                        ),
                        if (_cancelled) ...[
                          const SizedBox(height: 7),
                          const _CancelledQrNotice(),
                        ],
                        const SizedBox(height: 8),
                        const _JourneyInformationCard(),
                        const SizedBox(height: 8),
                        _cancelled
                            ? const _RefundPaymentCard()
                            : const _PaymentCard(),
                        const SizedBox(height: 8),
                        const _CancellationPolicyCard(),
                        const SizedBox(height: 10),
                        if (_cancelled)
                          Row(
                            children: [
                              Expanded(
                                child: JourneyOutlineButton(
                                  label: 'Quay lại kết quả',
                                  height: 34,
                                  onPressed: widget.onBack,
                                ),
                              ),
                              const SizedBox(width: 9),
                              Expanded(
                                child: JourneyPrimaryButton(
                                  label: 'Liên hệ hỗ trợ',
                                  height: 34,
                                  onPressed: () => _showSupport(context),
                                ),
                              ),
                            ],
                          )
                        else
                          Row(
                            children: [
                              Expanded(
                                child: JourneyOutlineButton(
                                  label: 'Quay lại kết quả',
                                  height: 34,
                                  onPressed: widget.onBack,
                                ),
                              ),
                              const SizedBox(width: 9),
                              Expanded(
                                child: JourneyOutlineButton(
                                  key: const Key('guest-ticket-cancel-button'),
                                  label: 'Hủy vé',
                                  color: const Color(0xFFF04438),
                                  height: 34,
                                  onPressed: _startCancellation,
                                ),
                              ),
                            ],
                          ),
                        const SizedBox(height: 9),
                        InkWell(
                          borderRadius: BorderRadius.circular(9),
                          onTap: () => _showSupport(context),
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 7,
                            ),
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
    return JourneySurface(
      padding: const EdgeInsets.fromLTRB(10, 8, 8, 8),
      radius: 10,
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: const Color(0xFFEAF7FE),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: SvgPicture.asset(
                '$journeyAssetRoot/passenger.svg',
                width: 19,
                height: 19,
              ),
            ),
          ),
          const SizedBox(width: 9),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Vé ${selectedIndex + 1}/6  ·  Chỗ ${passenger.seat}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: journeyBody,
                    fontSize: 9.5,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  passenger.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: journeyInk,
                    fontSize: 12.5,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          _SmallIconButton(asset: 'previous.svg', onTap: onPrevious),
          _SmallIconButton(asset: 'next.svg', onTap: onNext),
          TextButton(
            onPressed: onShowAll,
            style: TextButton.styleFrom(
              foregroundColor: journeyPrimary,
              padding: const EdgeInsets.symmetric(horizontal: 5),
              minimumSize: const Size(0, 32),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: const Text(
              'Tất cả vé (6) ›',
              style: TextStyle(fontSize: 9.5, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}

class _SmallIconButton extends StatelessWidget {
  const _SmallIconButton({required this.asset, required this.onTap});

  final String asset;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      customBorder: const CircleBorder(),
      onTap: onTap,
      child: SizedBox.square(
        dimension: 28,
        child: Center(
          child: SvgPicture.asset(
            '$journeyAssetRoot/$asset',
            width: 18,
            height: 18,
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
    final accent = cancelled
        ? const Color(0xFFF97066)
        : const Color(0xFFFFA629);
    return Container(
      height: 186,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: cancelled
              ? const [Color(0xFFFFF7F6), Color(0xFFFFE8E5)]
              : const [Color(0xFFFFFCF3), Color(0xFFFFF4D8)],
        ),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: accent.withValues(alpha: .72), width: .8),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          const qrWidth = 92.0;
          return Stack(
            children: [
              Positioned(
                left: 13,
                right: qrWidth + 8,
                top: 10,
                bottom: 9,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        SvgPicture.asset(
                          '$journeyAssetRoot/ticket_blue.svg',
                          width: 15,
                          height: 15,
                        ),
                        const SizedBox(width: 5),
                        const Expanded(
                          child: Text(
                            'VÉ XE NHANH',
                            style: TextStyle(
                              color: Color(0xFF087DCE),
                              fontSize: 9.5,
                              fontWeight: FontWeight.w700,
                              letterSpacing: .3,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: cancelled
                                ? const Color(0xFFFFE4E1)
                                : const Color(0xFFECFDF3),
                            borderRadius: BorderRadius.circular(99),
                          ),
                          child: Text(
                            cancelled ? 'Đã hủy' : 'Hợp lệ',
                            style: TextStyle(
                              color: cancelled
                                  ? const Color(0xFFD92D20)
                                  : const Color(0xFF067647),
                              fontSize: 8.5,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    const Text(
                      'Vé chuyến - Phương Nam Travel',
                      style: TextStyle(color: journeyBody, fontSize: 8.5),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Expanded(
                          child: Text(
                            'TP. Hồ Chí Minh',
                            style: TextStyle(
                              color: journeyInk,
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          child: SvgPicture.asset(
                            '$journeyAssetRoot/direction_orange.svg',
                            width: 15,
                            height: 12,
                          ),
                        ),
                        const Expanded(
                          child: Text(
                            'Đà Lạt',
                            textAlign: TextAlign.right,
                            style: TextStyle(
                              color: journeyInk,
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    const Text(
                      'Thứ Sáu · 16/10/2026',
                      style: TextStyle(color: journeyBody, fontSize: 8.5),
                    ),
                    const SizedBox(height: 6),
                    const Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: _TimePlace(
                            time: '22:30',
                            place: 'Bến xe Miền Đông mới',
                          ),
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: _TimePlace(
                            time: '05:30',
                            note: '+1 ngày',
                            place: 'Bến xe liên tỉnh Đà Lạt',
                            alignEnd: true,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        Expanded(
                          child: _TinyValue(
                            label: 'Hành khách',
                            value: passenger.name,
                          ),
                        ),
                        const SizedBox(width: 5),
                        _TinyValue(label: 'Chỗ', value: passenger.seat),
                        const SizedBox(width: 8),
                        const Expanded(
                          child: _TinyValue(
                            label: 'Loại chỗ',
                            value: 'Giường đơn - Tầng dưới',
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Positioned(
                right: qrWidth,
                top: 8,
                bottom: 8,
                child: SvgPicture.asset(
                  '$journeyAssetRoot/perforation.svg',
                  width: 8,
                  fit: BoxFit.fill,
                ),
              ),
              Positioned(
                right: 7,
                top: 40,
                width: 76,
                child: Column(
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        Opacity(
                          opacity: cancelled ? .34 : 1,
                          child: SvgPicture.asset(
                            '$journeyAssetRoot/ticket_qr.svg',
                            width: 69,
                            height: 69,
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
                    const SizedBox(height: 5),
                    Text(
                      cancelled ? 'QR không còn hiệu lực' : 'Lên xe quét mã',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: cancelled
                            ? const Color(0xFFD92D20)
                            : journeyBody,
                        fontSize: 8,
                        height: 11 / 8,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                left: 13,
                bottom: 3,
                child: Text(
                  'VXN-8F3K2Q-0${_passengers.indexOf(passenger) + 1}',
                  style: const TextStyle(color: journeyBody, fontSize: 7.5),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _TimePlace extends StatelessWidget {
  const _TimePlace({
    required this.time,
    required this.place,
    this.note,
    this.alignEnd = false,
  });

  final String time;
  final String place;
  final String? note;
  final bool alignEnd;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: alignEnd
          ? CrossAxisAlignment.end
          : CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: alignEnd
              ? MainAxisAlignment.end
              : MainAxisAlignment.start,
          children: [
            Text(
              time,
              style: const TextStyle(
                color: journeyInk,
                fontSize: 15,
                fontWeight: FontWeight.w700,
              ),
            ),
            if (note != null) ...[
              const SizedBox(width: 3),
              Text(
                note!,
                style: const TextStyle(
                  color: Color(0xFFF79009),
                  fontSize: 7.5,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ],
        ),
        Text(
          place,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: alignEnd ? TextAlign.right : TextAlign.left,
          style: const TextStyle(color: journeyBody, fontSize: 7.5),
        ),
      ],
    );
  }
}

class _TinyValue extends StatelessWidget {
  const _TinyValue({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: journeyBody, fontSize: 7)),
        Text(
          value,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: journeyInk,
            fontSize: 8,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
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
    return _DetailCard(
      icon: 'bus_blue.svg',
      title: 'Hành trình',
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Expanded(
            child: _StopInfo(
              title: 'ĐIỂM ĐÓN · 22:30',
              body: '501 Hoàng Hữu Nam, TP. Thủ Đức,\nTP. Hồ Chí Minh',
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 10, 8, 0),
            child: SvgPicture.asset(
              '$journeyAssetRoot/direction_orange.svg',
              width: 17,
              height: 13,
            ),
          ),
          const Expanded(
            child: _StopInfo(
              title: 'ĐIỂM TRẢ · 05:30 (+1 NGÀY)',
              body: '1 Tô Hiến Thành, Phường 3,\nTP. Đà Lạt',
              alignEnd: true,
            ),
          ),
        ],
      ),
    );
  }
}

class _StopInfo extends StatelessWidget {
  const _StopInfo({
    required this.title,
    required this.body,
    this.alignEnd = false,
  });

  final String title;
  final String body;
  final bool alignEnd;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: alignEnd
          ? CrossAxisAlignment.end
          : CrossAxisAlignment.start,
      children: [
        Text(
          title,
          textAlign: alignEnd ? TextAlign.right : TextAlign.left,
          style: const TextStyle(
            color: journeyBody,
            fontSize: 8.5,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 3),
        Text(
          body,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          textAlign: alignEnd ? TextAlign.right : TextAlign.left,
          style: const TextStyle(
            color: journeyInk,
            fontSize: 9.5,
            height: 14 / 9.5,
          ),
        ),
      ],
    );
  }
}

class _PaymentCard extends StatelessWidget {
  const _PaymentCard();

  @override
  Widget build(BuildContext context) {
    return const _DetailCard(
      icon: 'card_blue.svg',
      title: 'Thanh toán',
      child: Column(
        children: [
          _ValueRow(label: 'Giá vé (2 chỗ)', value: '560.000đ'),
          _ValueRow(label: 'Phí dịch vụ', value: '0đ'),
          _ValueRow(label: 'Voucher đổi điểm', value: '-100.000đ'),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 5),
            child: Divider(height: 1, color: Color(0xFFE8EEF4)),
          ),
          _ValueRow(
            label: 'Đã thanh toán',
            value: '460.000đ',
            emphasized: true,
          ),
          SizedBox(height: 4),
          _ValueRow(label: 'Phương thức', value: 'VNPay'),
          _ValueRow(label: 'Mã giao dịch', value: 'VNP14982231'),
          _ValueRow(
            label: 'Trạng thái',
            value: 'Thành công',
            valueColor: Color(0xFF067647),
          ),
        ],
      ),
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
    return _DetailCard(
      icon: 'policy.svg',
      title: 'Chính sách hủy / hoàn tiền',
      child: Column(
        children: [
          const Row(
            children: [
              Expanded(
                child: _PolicyColumn(
                  title: 'Trước 22:30 · 15/10',
                  value: 'Hoàn 90%',
                  color: Color(0xFF067647),
                ),
              ),
              Expanded(
                child: _PolicyColumn(
                  title: 'Đến 18:30 · 16/10',
                  value: 'Hoàn 50%',
                  color: Color(0xFFF79009),
                ),
              ),
              Expanded(
                child: _PolicyColumn(
                  title: 'Sau 18:30 · 16/10',
                  value: 'Không hoàn',
                  color: Color(0xFFD92D20),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFFEAF7FE),
              borderRadius: BorderRadius.circular(7),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SvgPicture.asset(
                  '$journeyAssetRoot/info.svg',
                  width: 13,
                  height: 13,
                ),
                const SizedBox(width: 5),
                const Expanded(
                  child: Text(
                    'Hiện tại: vé này được hoàn 90% số tiền đã trả khi hủy, nếu đáp ứng điều kiện.',
                    style: TextStyle(
                      color: Color(0xFF087DCE),
                      fontSize: 8.5,
                      height: 12 / 8.5,
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

class _PolicyColumn extends StatelessWidget {
  const _PolicyColumn({
    required this.title,
    required this.value,
    required this.color,
  });

  final String title;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          title,
          maxLines: 2,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: journeyBody,
            fontSize: 7.5,
            height: 11 / 7.5,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: TextStyle(
            color: color,
            fontSize: 9.5,
            fontWeight: FontWeight.w700,
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
