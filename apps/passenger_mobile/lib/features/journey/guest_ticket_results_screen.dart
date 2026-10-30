import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:passenger_mobile/features/home/route_dock_tabbar.dart';
import 'package:passenger_mobile/features/journey/guest_journey_shared.dart';
import 'package:passenger_mobile/features/journey/journey_models.dart';

/// Danh sách đơn của tab Hành trình: kết quả tra cứu của khách vãng lai ([lookupEmail] khác `null`)
/// hoặc "Vé của tôi" của hành khách đăng nhập.
class GuestTicketResultsScreen extends StatelessWidget {
  const GuestTicketResultsScreen({
    required this.title,
    required this.subtitle,
    required this.bookings,
    required this.onOpenBooking,
    required this.onTabSelected,
    this.lookupEmail,
    this.onChangeLookup,
    this.onRefresh,
    super.key,
  });

  final String title;
  final String subtitle;
  final List<JourneyBookingSummary> bookings;
  final ValueChanged<JourneyBookingSummary> onOpenBooking;
  final ValueChanged<int> onTabSelected;

  /// Email đã xác minh (che bớt) của phiên tra cứu; `null` = danh sách của tài khoản.
  final String? lookupEmail;
  final VoidCallback? onChangeLookup;

  /// Kéo xuống để tải lại.
  final Future<void> Function()? onRefresh;

  @override
  Widget build(BuildContext context) {
    final email = lookupEmail;
    final content = CustomScrollView(
      key: const Key('journey-results-scroll'),
      physics: const AlwaysScrollableScrollPhysics(),
      slivers: [
        SliverToBoxAdapter(
          child: JourneyHeroHeader(title: title, subtitle: subtitle),
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
                    if (email != null && onChangeLookup != null) ...[
                      _LookupSummary(
                        maskedEmail: email,
                        onChange: onChangeLookup!,
                      ),
                      const SizedBox(height: 14),
                    ],
                    Text(
                      bookings.isEmpty
                          ? 'Chưa có đơn nào'
                          : 'Đơn của bạn (${bookings.length})',
                      style: const TextStyle(
                        color: journeyInk,
                        fontSize: 18,
                        height: 25 / 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 10),
                    if (bookings.isEmpty)
                      JourneySurface(
                        key: const Key('journey-results-empty'),
                        padding: const EdgeInsets.all(16),
                        child: Text(
                          email != null
                              ? 'Email này chưa có đơn nào trong 12 tháng gần đây.'
                              : 'Bạn chưa đặt vé nào. Tìm chuyến ở tab Mua vé để bắt đầu hành trình.',
                          style: const TextStyle(
                            color: journeyBody,
                            fontSize: 12.5,
                            height: 1.5,
                          ),
                        ),
                      ),
                    for (final booking in bookings) ...[
                      _TicketResultCard(
                        booking: booking,
                        onPressed: () => onOpenBooking(booking),
                      ),
                      const SizedBox(height: 12),
                    ],
                    if (email != null && onChangeLookup != null) ...[
                      const SizedBox(height: 2),
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
                              'Thử tra cứu lại bằng email khác.',
                              style: TextStyle(
                                color: journeyBody,
                                fontSize: 11.5,
                                height: 17 / 11.5,
                              ),
                            ),
                            const SizedBox(height: 11),
                            JourneyOutlineButton(
                              label: 'Tra cứu lại',
                              onPressed: onChangeLookup!,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
    final refresh = onRefresh;
    return Scaffold(
      key: const Key('guest-ticket-results-screen'),
      extendBody: true,
      backgroundColor: journeyPage,
      bottomNavigationBar: RouteDockTabBar(
        currentIndex: 3,
        onTap: onTabSelected,
      ),
      body: TabEntrance(
        child: AnnotatedRegion<SystemUiOverlayStyle>(
          value: journeyOverlayStyle,
          child: refresh == null
              ? content
              : RefreshIndicator(onRefresh: refresh, child: content),
        ),
      ),
    );
  }
}

class _LookupSummary extends StatelessWidget {
  const _LookupSummary({required this.maskedEmail, required this.onChange});

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
                const Text(
                  'Email đã xác minh',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: journeyInk,
                    fontSize: 13.5,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  maskedEmail,
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

/// Màu nhãn trạng thái: chữ + nền.
(Color, Color) _statusColors(String status) => switch (status) {
  'CONFIRMED' || 'PAID' => (const Color(0xFF067647), const Color(0xFFECFDF3)),
  'PENDING_PAYMENT' ||
  'PENDING_CONFIRMATION' ||
  'REFUND_PENDING' => (const Color(0xFFB54708), const Color(0xFFFFFAEB)),
  _ => (const Color(0xFF475467), const Color(0xFFF2F4F7)),
};

const _weekdays = ['Thứ 2', 'Thứ 3', 'Thứ 4', 'Thứ 5', 'Thứ 6', 'Thứ 7', 'CN'];

class _TicketResultCard extends StatelessWidget {
  const _TicketResultCard({required this.booking, required this.onPressed});

  final JourneyBookingSummary booking;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final departure = booking.departureAt.toLocal();
    final (statusColor, statusBackground) = _statusColors(booking.status);
    final count = booking.ticketCount;
    return JourneySurface(
      key: ValueKey('journey-booking-${booking.bookingCode}'),
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
                      _weekdays[departure.weekday - 1],
                      style: const TextStyle(
                        color: journeyBody,
                        fontSize: 9.5,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      '${departure.day}',
                      style: const TextStyle(
                        color: journeyInk,
                        fontSize: 22,
                        height: 25 / 22,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      'Tháng ${departure.month}',
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
                      booking.routeName,
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
                      'Khởi hành ${journeyTime(departure)}',
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
                      booking.operatorName,
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
                  journeyBookingStatusLabel(booking.status),
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
              _Meta(icon: 'ticket_meta.svg', label: booking.bookingCode),
              if (count != null) _Meta(icon: 'seat.svg', label: '$count vé'),
              _Meta(icon: 'payment_card.svg', label: journeyVnd(booking.total)),
            ],
          ),
          const SizedBox(height: 11),
          JourneyPrimaryButton(
            key: Key('journey-open-${booking.bookingCode}'),
            label: booking.status == 'PENDING_PAYMENT' ? 'Xem đơn' : 'Xem vé',
            iconAsset: '$journeyAssetRoot/qr_small.svg',
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
