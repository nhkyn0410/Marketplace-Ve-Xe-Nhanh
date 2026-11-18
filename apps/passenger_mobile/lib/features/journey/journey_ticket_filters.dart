import 'package:flutter/material.dart';
import 'package:passenger_mobile/features/journey/guest_journey_shared.dart';
import 'package:passenger_mobile/features/journey/journey_models.dart';

/// Tab của "Vé của tôi" (SCR-PSG-24, PASSENGER-PARITY Q6), chia đơn như web.
enum JourneyTicketTab {
  upcoming('Sắp tới'),
  completed('Đã đi'),
  cancelled('Đã hủy'),
  all('Tất cả');

  const JourneyTicketTab(this.label);

  final String label;
}

const _closedStatuses = {
  'CANCELLED',
  'EXPIRED',
  'REFUND_PENDING',
  'REFUNDED',
  'REFUND_FAILED',
};

/// Đơn đã đóng (hủy / hết hạn / hoàn tiền) → Đã hủy; mọi vé còn hiệu lực đã đi hoặc vắng mặt
/// → Đã đi; còn lại (chờ thanh toán, vé hợp lệ, đang trên xe) → Sắp tới.
JourneyTicketTab journeyTicketTabOf(JourneyBookingSummary booking) {
  if (_closedStatuses.contains(booking.status)) {
    return JourneyTicketTab.cancelled;
  }
  final live = booking.ticketStatuses.where(
    (status) => status != 'CANCELLED' && status != 'REFUNDED',
  );
  if (live.isNotEmpty &&
      live.every((status) => status == 'USED' || status == 'NO_SHOW')) {
    return JourneyTicketTab.completed;
  }
  return JourneyTicketTab.upcoming;
}

/// Số đơn của từng tab ("Tất cả" = mọi đơn).
Map<JourneyTicketTab, int> journeyTicketCounts(
  List<JourneyBookingSummary> bookings,
) => {
  for (final tab in JourneyTicketTab.values)
    tab: tab == JourneyTicketTab.all
        ? bookings.length
        : bookings
              .where((booking) => journeyTicketTabOf(booking) == tab)
              .length,
};

/// Đơn thuộc [tab] và khớp [query] theo mã đặt vé, tuyến hoặc nhà xe (không phân biệt hoa
/// thường, như web).
List<JourneyBookingSummary> filterJourneyBookings(
  List<JourneyBookingSummary> bookings,
  JourneyTicketTab tab,
  String query,
) {
  final needle = query.trim().toLowerCase();
  return [
    for (final booking in bookings)
      if ((tab == JourneyTicketTab.all || journeyTicketTabOf(booking) == tab) &&
          (needle.isEmpty ||
              booking.bookingCode.toLowerCase().contains(needle) ||
              booking.routeName.toLowerCase().contains(needle) ||
              booking.operatorName.toLowerCase().contains(needle)))
        booking,
  ];
}

/// Ô tìm + các tab có đếm của "Vé của tôi".
class JourneyTicketFilterBar extends StatefulWidget {
  const JourneyTicketFilterBar({
    required this.tab,
    required this.counts,
    required this.initialQuery,
    required this.onTabChanged,
    required this.onQueryChanged,
    super.key,
  });

  final JourneyTicketTab tab;
  final Map<JourneyTicketTab, int> counts;

  /// Từ khóa đang lọc (giữ lại khi danh sách tải lại).
  final String initialQuery;
  final ValueChanged<JourneyTicketTab> onTabChanged;
  final ValueChanged<String> onQueryChanged;

  @override
  State<JourneyTicketFilterBar> createState() => _JourneyTicketFilterBarState();
}

class _JourneyTicketFilterBarState extends State<JourneyTicketFilterBar> {
  late final _query = TextEditingController(text: widget.initialQuery);

  @override
  void dispose() {
    _query.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: journeyBorder),
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          key: const Key('journey-ticket-search'),
          controller: _query,
          onChanged: widget.onQueryChanged,
          textInputAction: TextInputAction.search,
          style: const TextStyle(color: journeyInk, fontSize: 13),
          decoration: InputDecoration(
            hintText: 'Tìm mã đặt vé, tuyến hoặc nhà xe',
            hintStyle: const TextStyle(color: journeyBody, fontSize: 12.5),
            prefixIcon: const Icon(Icons.search, color: journeyBody, size: 20),
            filled: true,
            fillColor: Colors.white,
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(vertical: 12),
            enabledBorder: border,
            focusedBorder: border.copyWith(
              borderSide: const BorderSide(color: journeyButton),
            ),
          ),
        ),
        const SizedBox(height: 10),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              for (final tab in JourneyTicketTab.values)
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    key: Key('journey-tab-${tab.name}'),
                    label: Text('${tab.label} (${widget.counts[tab] ?? 0})'),
                    selected: widget.tab == tab,
                    showCheckmark: false,
                    // Gọn để đủ 4 tab trên máy 360dp; máy hẹp / chữ lớn thì vuốt ngang.
                    visualDensity: VisualDensity.compact,
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    labelPadding: const EdgeInsets.symmetric(horizontal: 4),
                    onSelected: (_) => widget.onTabChanged(tab),
                    labelStyle: TextStyle(
                      color: widget.tab == tab ? Colors.white : journeyInk,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                    selectedColor: journeyButton,
                    backgroundColor: Colors.white,
                    side: BorderSide(
                      color: widget.tab == tab ? journeyButton : journeyBorder,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
