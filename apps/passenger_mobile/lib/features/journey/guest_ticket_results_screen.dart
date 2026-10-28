import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:passenger_mobile/features/home/route_dock_tabbar.dart';
import 'package:passenger_mobile/features/journey/guest_journey_shared.dart';

class GuestTicketResultsScreen extends StatelessWidget {
  const GuestTicketResultsScreen({
    required this.bookingCode,
    required this.maskedEmail,
    required this.onOpenTicket,
    required this.onChangeLookup,
    required this.onTabSelected,
    super.key,
  });

  final String bookingCode;
  final String maskedEmail;
  final VoidCallback onOpenTicket;
  final VoidCallback onChangeLookup;
  final ValueChanged<int> onTabSelected;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: const Key('guest-ticket-results-screen'),
      extendBody: true,
      backgroundColor: journeyPage,
      bottomNavigationBar: RouteDockTabBar(
        currentIndex: 3,
        onTap: onTabSelected,
      ),
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: journeyOverlayStyle,
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: JourneyHeroHeader(
                title: 'Kết quả tra cứu vé',
                subtitle: 'Đã xác minh email $maskedEmail',
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 9, 20, 145),
              sliver: SliverToBoxAdapter(
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 372),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _LookupSummary(
                          bookingCode: bookingCode,
                          maskedEmail: maskedEmail,
                          onChange: onChangeLookup,
                        ),
                        const SizedBox(height: 14),
                        const Text(
                          'Kết quả tìm thấy (2)',
                          style: TextStyle(
                            color: journeyInk,
                            fontSize: 18,
                            height: 25 / 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 10),
                        _TicketResultCard(
                          weekday: 'Thứ 6',
                          day: '16',
                          month: 'Tháng 10',
                          route: 'TP. Hồ Chí Minh → Đà Lạt',
                          status: 'Hợp lệ',
                          statusColor: const Color(0xFF067647),
                          statusBackground: const Color(0xFFECFDF3),
                          time: '22:30 – 05:30 (+1 ngày)',
                          operator: 'Phương Nam Travel · Giường nằm Limousine',
                          bookingCode: 'VXN-8F3K2Q',
                          seatCount: '2 vé',
                          station: 'Bến xe Miền Đông mới',
                          actionLabel: 'Xem vé',
                          actionIcon: '$journeyAssetRoot/qr_small.svg',
                          onPressed: onOpenTicket,
                        ),
                        const SizedBox(height: 12),
                        const _PendingTicketCard(),
                        const SizedBox(height: 14),
                        JourneySurface(
                          padding: const EdgeInsets.all(14),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              const Text(
                                'Không đúng kết quả?',
                                style: TextStyle(
                                  color: journeyInk,
                                  fontSize: 14,
                                  height: 21 / 14,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 2),
                              const Text(
                                'Thử tra cứu lại bằng mã đặt vé và email khác.',
                                style: TextStyle(
                                  color: journeyBody,
                                  fontSize: 11.5,
                                  height: 17 / 11.5,
                                ),
                              ),
                              const SizedBox(height: 11),
                              JourneyOutlineButton(
                                label: 'Tra cứu lại',
                                onPressed: onChangeLookup,
                              ),
                            ],
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
}

class _LookupSummary extends StatelessWidget {
  const _LookupSummary({
    required this.bookingCode,
    required this.maskedEmail,
    required this.onChange,
  });

  final String bookingCode;
  final String maskedEmail;
  final VoidCallback onChange;

  @override
  Widget build(BuildContext context) {
    return JourneySurface(
      padding: const EdgeInsets.all(14),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0xFFEAF7FE),
              borderRadius: BorderRadius.circular(11),
            ),
            child: Center(
              child: SvgPicture.asset(
                '$journeyAssetRoot/ticket_summary.svg',
                width: 21,
                height: 21,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  bookingCode.isEmpty ? 'VXN-8F3K2Q' : bookingCode,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: journeyInk,
                    fontSize: 13.5,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Email: $maskedEmail',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: journeyBody, fontSize: 11),
                ),
              ],
            ),
          ),
          TextButton.icon(
            onPressed: onChange,
            style: TextButton.styleFrom(
              foregroundColor: journeyPrimary,
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 4),
              minimumSize: const Size(0, 32),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            icon: SvgPicture.asset(
              '$journeyAssetRoot/edit.svg',
              width: 15,
              height: 15,
            ),
            label: const Text(
              'Thay đổi',
              style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}

class _TicketResultCard extends StatelessWidget {
  const _TicketResultCard({
    required this.weekday,
    required this.day,
    required this.month,
    required this.route,
    required this.status,
    required this.statusColor,
    required this.statusBackground,
    required this.time,
    required this.operator,
    required this.bookingCode,
    required this.seatCount,
    required this.station,
    required this.actionLabel,
    required this.onPressed,
    this.actionIcon,
  });

  final String weekday;
  final String day;
  final String month;
  final String route;
  final String status;
  final Color statusColor;
  final Color statusBackground;
  final String time;
  final String operator;
  final String bookingCode;
  final String seatCount;
  final String station;
  final String actionLabel;
  final String? actionIcon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return JourneySurface(
      radius: 16,
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 57,
                padding: const EdgeInsets.symmetric(vertical: 7),
                decoration: BoxDecoration(
                  color: const Color(0xFFEAF7FE),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [
                    Text(
                      weekday,
                      style: const TextStyle(
                        color: journeyBody,
                        fontSize: 9.5,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      day,
                      style: const TextStyle(
                        color: journeyInk,
                        fontSize: 22,
                        height: 25 / 22,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      month,
                      style: const TextStyle(color: journeyBody, fontSize: 9.5),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      route,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: journeyInk,
                        fontSize: 13.5,
                        height: 19 / 13.5,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      time,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: journeyInk,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      operator,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: journeyBody,
                        fontSize: 10.5,
                        height: 15 / 10.5,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 5),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4),
                decoration: BoxDecoration(
                  color: statusBackground,
                  borderRadius: BorderRadius.circular(99),
                ),
                child: Text(
                  status,
                  style: TextStyle(
                    color: statusColor,
                    fontSize: 9.5,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Divider(height: 1, color: Color(0xFFE7EEF5)),
          ),
          Wrap(
            spacing: 12,
            runSpacing: 7,
            children: [
              _Meta(icon: 'ticket_meta.svg', label: bookingCode),
              _Meta(icon: 'seat.svg', label: seatCount),
              _Meta(icon: 'bus.svg', label: station),
            ],
          ),
          const SizedBox(height: 11),
          JourneyPrimaryButton(
            key: Key('ticket-result-${actionLabel.hashCode}'),
            label: actionLabel,
            iconAsset: actionIcon,
            height: 40,
            onPressed: onPressed,
          ),
        ],
      ),
    );
  }
}

class _Meta extends StatelessWidget {
  const _Meta({required this.icon, required this.label});

  final String icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SvgPicture.asset('$journeyAssetRoot/$icon', width: 14, height: 14),
        const SizedBox(width: 4),
        Text(label, style: const TextStyle(color: journeyBody, fontSize: 9.5)),
      ],
    );
  }
}

class _PendingTicketCard extends StatelessWidget {
  const _PendingTicketCard();

  @override
  Widget build(BuildContext context) {
    return _TicketResultCard(
      weekday: 'CN',
      day: '25',
      month: 'Tháng 10',
      route: 'TP. Hồ Chí Minh → Vũng Tàu',
      status: 'Chờ thanh toán',
      statusColor: const Color(0xFFB54708),
      statusBackground: const Color(0xFFFFFAEB),
      time: '07:00 – 09:15',
      operator: 'Hoàng Long Coach · Ghế ngồi',
      bookingCode: 'VXN-2M7T9A',
      seatCount: '1 vé',
      station: 'Bến xe Miền Tây',
      actionLabel: 'Tiếp tục thanh toán',
      actionIcon: '$journeyAssetRoot/payment_card.svg',
      onPressed: () {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            const SnackBar(content: Text('Đây là luồng thanh toán mô phỏng.')),
          );
      },
    );
  }
}
