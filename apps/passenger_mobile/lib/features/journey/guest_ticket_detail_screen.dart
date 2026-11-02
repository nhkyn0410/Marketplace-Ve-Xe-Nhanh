import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:passenger_mobile/features/home/route_dock_tabbar.dart';
import 'package:passenger_mobile/features/journey/guest_journey_shared.dart';
import 'package:passenger_mobile/features/journey/journey_api.dart';
import 'package:passenger_mobile/features/journey/journey_models.dart';
import 'package:qr_flutter/qr_flutter.dart';

/// Báo giá hủy các vé đã chọn.
typedef JourneyCancellationQuoter = Future<JourneyCancellationQuote> Function(
  List<String> ticketIds,
);

/// Hủy vé rồi trả kết quả hoàn tiền + đơn đã cập nhật.
typedef JourneyTicketCanceller =
    Future<(JourneyCancellation, JourneyBooking)> Function(
      List<String> ticketIds,
      int expectedRefund,
      String? reason,
    );

/// Đơn + vé đang xem — dùng chung cho các thẻ và sheet.
class _TicketView {
  const _TicketView(this.booking, this.ticket);

  final JourneyBooking booking;
  final JourneyTicket ticket;

  /// "TP. Hồ Chí Minh" / "Đà Lạt" từ tên tuyến; tên không tách được thì dùng điểm đón / trả.
  (String, String) get places {
    final parts = booking.routeName.split(RegExp(r'\s*(?:→|->|–|—| - )\s*'));
    if (parts.length >= 2) return (parts.first, parts.last);
    return (booking.pickup.name, booking.dropoff.name);
  }
}

/// Chi tiết một đơn ở tab Hành trình (khách vãng lai đã xác minh hoặc hành khách đăng nhập).
class GuestTicketDetailScreen extends StatefulWidget {
  const GuestTicketDetailScreen({
    required this.booking,
    required this.onBack,
    required this.onTabSelected,
    required this.quoteCancellation,
    required this.cancelTickets,
    this.onSupportRequested,
    this.journeyDemoPanel,
    super.key,
  });

  final JourneyBooking booking;
  final VoidCallback onBack;
  final ValueChanged<int> onTabSelected;
  final JourneyCancellationQuoter quoteCancellation;
  final JourneyTicketCanceller cancelTickets;

  /// Gọi tổng đài hỗ trợ.
  final VoidCallback? onSupportRequested;
  final Widget? journeyDemoPanel;

  @override
  State<GuestTicketDetailScreen> createState() =>
      _GuestTicketDetailScreenState();
}

class _GuestTicketDetailScreenState extends State<GuestTicketDetailScreen> {
  late JourneyBooking _booking = widget.booking;
  int _selectedPassenger = 0;
  bool _busy = false;

  List<JourneyTicket> get _tickets => _booking.tickets;

  _TicketView? get _view => _tickets.isEmpty
      ? null
      : _TicketView(_booking, _tickets[_selectedPassenger]);

  bool get _cancelled => _view?.ticket.isCancelled ?? false;

  /// Vé đã lên xe / đã đi / đã hủy hoặc chuyến đã qua giờ chạy thì không còn nút hủy.
  bool get _canCancel =>
      (_view?.ticket.isCancellable ?? false) &&
      _booking.departureAt.isAfter(DateTime.now());

  void _movePassenger(int delta) {
    if (_tickets.isEmpty) return;
    setState(() {
      _selectedPassenger =
          (_selectedPassenger + delta + _tickets.length) % _tickets.length;
    });
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _openPassengerPicker() async {
    final selected = await showModalBottomSheet<int>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      barrierColor: const Color(0x9908172B),
      builder: (context) => _PassengerPickerSheet(
        tickets: _tickets,
        selectedIndex: _selectedPassenger,
      ),
    );
    if (selected != null && mounted) {
      setState(() => _selectedPassenger = selected);
    }
  }

  Future<void> _startCancellation() async {
    final view = _view;
    if (view == null || _busy) return;
    final ticketIds = [view.ticket.ticketId];
    setState(() => _busy = true);
    final JourneyCancellationQuote quote;
    try {
      quote = await widget.quoteCancellation(ticketIds);
    } catch (error) {
      if (!mounted) return;
      setState(() => _busy = false);
      _showMessage(describeJourneyFailure(error));
      return;
    }
    if (!mounted) return;
    setState(() => _busy = false);
    final blocked = quote.blockedReason;
    if (blocked != null) {
      _showMessage(blocked);
      return;
    }

    // `null` = giữ vé; chuỗi rỗng = không nêu lý do.
    final reason = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: const Color(0xA608172B),
      builder: (context) => _CancelTicketSheet(view: view, quote: quote),
    );
    if (reason == null || !mounted) return;

    final confirmed = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: const Color(0xA608172B),
      builder: (context) => _ConfirmCancellationSheet(view: view, quote: quote),
    );
    if (confirmed != true || !mounted) return;

    setState(() => _busy = true);
    final JourneyCancellation result;
    try {
      final (cancellation, updated) = await widget.cancelTickets(
        ticketIds,
        quote.refundAmount,
        reason.isEmpty ? null : reason,
      );
      result = cancellation;
      if (!mounted) return;
      setState(() {
        _booking = updated;
        _busy = false;
        _selectedPassenger = _selectedPassenger.clamp(
          0,
          updated.tickets.isEmpty ? 0 : updated.tickets.length - 1,
        );
      });
    } catch (error) {
      if (!mounted) return;
      setState(() => _busy = false);
      _showMessage(describeJourneyFailure(error));
      return;
    }
    if (!mounted) return;
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: const Color(0xA608172B),
      builder: (context) =>
          _CancellationSuccessSheet(view: view, result: result),
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
        child: ScrolledStatusBarScrim(
          color: journeyPage,
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: JourneyDetailHeader(
                  subtitle: _tickets.isEmpty
                      ? 'Đơn ${_booking.bookingCode}'
                      : 'Đơn ${_booking.bookingCode} · ${_tickets.length} vé',
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
                          if (_view case final view?) ...[
                            _PassengerNavigator(
                              ticket: view.ticket,
                              selectedIndex: _selectedPassenger,
                              total: _tickets.length,
                              onPrevious: () => _movePassenger(-1),
                              onNext: () => _movePassenger(1),
                              onShowAll: _openPassengerPicker,
                            ),
                            const SizedBox(height: 9),
                            _BoardingPass(view: view),
                            if (_cancelled) ...[
                              const SizedBox(height: 7),
                              const _CancelledQrNotice(),
                            ],
                          ] else
                            JourneySurface(
                              key: const Key('journey-detail-no-tickets'),
                              padding: const EdgeInsets.all(14),
                              child: Text(
                                _booking.status == 'PENDING_PAYMENT'
                                    ? 'Đơn đang chờ thanh toán. Vé điện tử sẽ có sau khi thanh toán thành công.'
                                    : 'Đơn chưa có vé điện tử (${journeyBookingStatusLabel(_booking.status)}).',
                                style: const TextStyle(
                                  color: journeyBody,
                                  fontSize: 12.5,
                                  height: 1.5,
                                ),
                              ),
                            ),
                          const SizedBox(height: 9),
                          _JourneyInformationCard(booking: _booking),
                          if (widget.journeyDemoPanel case final panel?) ...[
                            const SizedBox(height: 9),
                            panel,
                          ],
                          const SizedBox(height: 9),
                          _booking.refunds.isNotEmpty || _cancelled
                              ? _RefundPaymentCard(booking: _booking)
                              : _PaymentCard(booking: _booking),
                          const SizedBox(height: 9),
                          _CancellationPolicyCard(
                            booking: _booking,
                            canCancel: _canCancel,
                          ),
                          const SizedBox(height: 9),
                          if (!_canCancel)
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
                                    onPressed: _showSupport,
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
                                    key: const Key(
                                      'guest-ticket-cancel-button',
                                    ),
                                    label: _busy ? 'Đang xử lý...' : 'Hủy vé',
                                    color: const Color(0xFFF04438),
                                    onPressed: _busy
                                        ? null
                                        : _startCancellation,
                                  ),
                                ),
                              ],
                            ),
                          const SizedBox(height: 12),
                          InkWell(
                            borderRadius: BorderRadius.circular(9),
                            onTap: _showSupport,
                            child: Container(
                              width: double.infinity,
                              height: 36,
                              alignment: Alignment.centerLeft,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 5,
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
      ),
    );
  }

  void _showSupport() {
    final support = widget.onSupportRequested;
    if (support != null) {
      support();
      return;
    }
    _showMessage('Gọi tổng đài 1900 636 707 để được hỗ trợ về chuyến đi.');
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
  final VoidCallback? onPressed;

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
    required this.ticket,
    required this.selectedIndex,
    required this.total,
    required this.onPrevious,
    required this.onNext,
    required this.onShowAll,
  });

  final JourneyTicket ticket;
  final int selectedIndex;
  final int total;
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
                      'Vé ${selectedIndex + 1}/$total',
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
                      'Chỗ ${ticket.seatCode}',
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
                      ticket.passengerName,
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
                child: Center(
                  child: Text(
                    'Tất cả vé ($total) ›',
                    maxLines: 1,
                    style: const TextStyle(
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

/// Bề rộng phần cuống vé chứa mã QR.
const _ticketStubWidth = 106.0;

/// Thẻ vé: thông tin bên trái, cuống mã QR bên phải. Chạm mã QR của vé còn hiệu lực để phóng to.
class _BoardingPass extends StatelessWidget {
  const _BoardingPass({required this.view, this.enlarged = false, super.key});

  final _TicketView view;

  /// Thẻ đang nằm trong màn phóng to thì chạm mã QR không mở tiếp.
  final bool enlarged;

  Future<void> _enlarge(BuildContext context) {
    final box = context.findRenderObject()! as RenderBox;
    final origin = box.localToGlobal(Offset.zero) & box.size;
    return showGeneralDialog<void>(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Đóng vé phóng to',
      barrierColor: const Color(0xF208172B),
      transitionDuration: const Duration(milliseconds: 420),
      // Thẻ tự bay từ vị trí cũ; không để route làm mờ dần.
      transitionBuilder: (_, _, _, child) => child,
      pageBuilder: (_, animation, _) => _EnlargedBoardingPass(
        view: view,
        origin: origin,
        animation: animation,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ticket = view.ticket;
    final cancelled = ticket.isCancelled;
    final palette = cancelled ? _TicketPalette.cancelled : _TicketPalette.gold;
    return ClipRRect(
      borderRadius: BorderRadius.circular(9),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: palette.gradient,
            stops: const [0, .55, 1],
          ),
          borderRadius: BorderRadius.circular(9),
          border: Border.all(color: palette.border, width: .7),
        ),
        child: Stack(
          clipBehavior: Clip.hardEdge,
          children: [
            Row(
              children: [
                Expanded(
                  child: _BoardingDetails(view: view, palette: palette),
                ),
                SizedBox(
                  width: _ticketStubWidth,
                  child: _BoardingStub(
                    ticket: ticket,
                    palette: palette,
                    onEnlarge: !enlarged && ticket.isCancellable
                        ? () => _enlarge(context)
                        : null,
                  ),
                ),
              ],
            ),
            Positioned(
              right: _ticketStubWidth,
              top: 0,
              bottom: 0,
              width: 1,
              child: RotatedBox(
                quarterTurns: 1,
                child: SvgPicture.asset(
                  '$journeyAssetRoot/perforation.svg',
                  fit: BoxFit.fill,
                ),
              ),
            ),
            Positioned(
              right: _ticketStubWidth - 5,
              top: -5.7,
              child: SvgPicture.asset('$journeyAssetRoot/ticket_notch.svg'),
            ),
            Positioned(
              right: _ticketStubWidth - 5,
              bottom: -5.7,
              child: SvgPicture.asset('$journeyAssetRoot/ticket_notch.svg'),
            ),
          ],
        ),
      ),
    );
  }
}

/// Màu của thẻ vé theo trạng thái.
class _TicketPalette {
  const _TicketPalette({
    required this.gradient,
    required this.border,
    required this.muted,
    required this.accent,
    required this.statusFill,
  });

  /// Chữ phụ và điểm nhấn đậm hơn màu chung của app để đủ tương phản trên nền vàng.
  static const gold = _TicketPalette(
    gradient: [Color(0xFFFFF2BF), Color(0xFFFFDA6B), Color(0xFFFFC233)],
    border: Color(0xFFEFAA1F),
    muted: Color(0xFF6A5310),
    accent: Color(0xFF8A4B00),
    statusFill: Color(0xFF009669),
  );

  static const cancelled = _TicketPalette(
    gradient: [Color(0xFFFFF7F6), Color(0xFFFFE8E5), Color(0xFFFFE8E5)],
    border: Color(0xFFF97066),
    muted: journeyBody,
    accent: Color(0xFFE97800),
    statusFill: Color(0xFFD92D20),
  );

  final List<Color> gradient;
  final Color border;
  final Color muted;
  final Color accent;
  final Color statusFill;
}

/// Phần thông tin của thẻ vé: nhà xe, tuyến, ngày, giờ đón / trả, hành khách.
class _BoardingDetails extends StatelessWidget {
  const _BoardingDetails({required this.view, required this.palette});

  final _TicketView view;
  final _TicketPalette palette;

  @override
  Widget build(BuildContext context) {
    final ticket = view.ticket;
    final booking = view.booking;
    final (origin, destination) = view.places;
    final companion = ticket.companionName;
    final days = _dayOffset(
      booking.pickup.plannedAt,
      booking.dropoff.plannedAt,
    );
    final arrow = SvgPicture.asset(
      '$journeyAssetRoot/direction_orange.svg',
      colorFilter: ColorFilter.mode(palette.accent, BlendMode.srcIn),
    );
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 9, 11, 11),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 30,
                height: 30,
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: SvgPicture.asset('$journeyAssetRoot/ticket_blue.svg'),
              ),
              const SizedBox(width: 7),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'VÉ XE NHANH',
                      style: TextStyle(
                        color: palette.accent,
                        fontSize: 10.5,
                        height: 14 / 10.5,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      'Vé chuyến - ${booking.operatorName}',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: palette.muted,
                        fontSize: 10,
                        height: 13 / 10,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text.rich(
            TextSpan(
              children: [
                TextSpan(text: origin),
                WidgetSpan(
                  alignment: PlaceholderAlignment.middle,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: arrow,
                  ),
                ),
                TextSpan(text: destination),
              ],
            ),
            style: const TextStyle(
              color: journeyInk,
              fontSize: 15,
              height: 20 / 15,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            journeyLongDate(booking.pickup.plannedAt),
            style: const TextStyle(
              color: journeyInk,
              fontSize: 11.5,
              height: 16 / 11.5,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 7),
          Row(
            children: [
              Expanded(
                child: _BoardingTime(
                  time: journeyTime(booking.pickup.plannedAt),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: arrow,
              ),
              Expanded(
                child: _BoardingTime(
                  time: journeyTime(booking.dropoff.plannedAt),
                  note: days > 0 ? '+$days ngày' : null,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 5,
                child: _BoardingValue(
                  label: 'Hành khách',
                  value: companion == null
                      ? ticket.passengerName
                      : '${ticket.passengerName} + $companion',
                  color: palette.muted,
                ),
              ),
              const SizedBox(width: 6),
              Expanded(
                flex: 2,
                child: _BoardingValue(
                  label: 'Chỗ',
                  value: ticket.seatCode,
                  color: palette.muted,
                ),
              ),
              const SizedBox(width: 6),
              Expanded(
                flex: 4,
                child: _BoardingValue(
                  label: 'Loại chỗ',
                  value: journeySeatTypeLabel(ticket.seatType),
                  color: palette.muted,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Cuống vé: mã QR, trạng thái ngay dưới mã, mã vé và lời nhắc.
class _BoardingStub extends StatelessWidget {
  const _BoardingStub({
    required this.ticket,
    required this.palette,
    this.onEnlarge,
  });

  final JourneyTicket ticket;
  final _TicketPalette palette;

  /// `null` = không phóng to được (vé hết hiệu lực hoặc đang ở màn phóng to).
  final VoidCallback? onEnlarge;

  @override
  Widget build(BuildContext context) {
    final cancelled = ticket.isCancelled;
    final status = _ticketStatusLabel(ticket.status);
    final caption = _qrCaption(ticket);
    final qr = Container(
      width: 91,
      height: 91,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(7),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Opacity(
            opacity: ticket.isCancellable ? 1 : .34,
            child: QrImageView(
              key: const Key('journey-ticket-qr'),
              data: ticket.qrToken,
              size: 84,
              padding: EdgeInsets.zero,
              semanticsLabel: 'Mã QR vé ${ticket.ticketCode}',
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
    );
    return Padding(
      padding: const EdgeInsets.fromLTRB(5, 11, 4, 11),
      child: Column(
        children: [
          if (onEnlarge case final enlarge?)
            Semantics(
              button: true,
              label: 'Phóng to vé',
              child: GestureDetector(
                key: const Key('journey-ticket-qr-zoom'),
                onTap: enlarge,
                child: qr,
              ),
            )
          else
            qr,
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 2.5),
            decoration: BoxDecoration(
              color: palette.statusFill,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              status,
              maxLines: 1,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 10.5,
                height: 15 / 10.5,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: 5),
          Text(
            ticket.ticketCode,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: journeyInk,
              fontSize: 10,
              height: 14 / 10,
              fontWeight: FontWeight.w700,
            ),
          ),
          if (caption != status) ...[
            const SizedBox(height: 2),
            Text(
              caption,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: cancelled ? const Color(0xFFD92D20) : palette.accent,
                fontSize: 9.5,
                height: 13 / 9.5,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Màn nổi: thẻ vé bay từ vị trí cũ ra giữa màn hình, phóng to và xoay ngang để dễ quét mã.
class _EnlargedBoardingPass extends StatelessWidget {
  const _EnlargedBoardingPass({
    required this.view,
    required this.origin,
    required this.animation,
  });

  final _TicketView view;

  /// Vị trí thẻ trên màn chi tiết, cũng là kích thước dựng thẻ phóng to.
  final Rect origin;
  final Animation<double> animation;

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final close = Navigator.of(context).maybePop;
    final area = Rect.fromLTRB(
      media.padding.left + 6,
      media.padding.top + 6,
      media.size.width - media.padding.right - 6,
      media.size.height - media.padding.bottom - 60,
    );
    // Máy đang dọc thì xoay thẻ, cạnh dài nằm theo chiều cao màn hình; khách xoay máy ngang thì thẻ đã đúng chiều.
    final portrait = media.size.height >= media.size.width;
    final scale = portrait
        ? math.min(area.height / origin.width, area.width / origin.height)
        : math.min(area.width / origin.width, area.height / origin.height);
    final turn = portrait ? math.pi / 2 : 0.0;
    final progress = CurvedAnimation(
      parent: animation,
      curve: Curves.easeInOutCubic,
    );
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Material(
        type: MaterialType.transparency,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: close,
          child: Stack(
            children: [
              AnimatedBuilder(
                animation: progress,
                builder: (context, child) {
                  final center = Offset.lerp(
                    origin.center,
                    area.center,
                    progress.value,
                  )!;
                  return Positioned(
                    left: center.dx - origin.width / 2,
                    top: center.dy - origin.height / 2,
                    width: origin.width,
                    height: origin.height,
                    child: Transform.rotate(
                      angle: turn * progress.value,
                      child: Transform.scale(
                        scale: 1 + (scale - 1) * progress.value,
                        child: child,
                      ),
                    ),
                  );
                },
                child: _BoardingPass(
                  key: const Key('journey-ticket-enlarged'),
                  view: view,
                  enlarged: true,
                ),
              ),
              Positioned(
                left: 0,
                right: 0,
                bottom: media.padding.bottom + 8,
                child: FadeTransition(
                  opacity: progress,
                  child: Center(
                    child: IconButton(
                      key: const Key('journey-ticket-enlarged-close'),
                      tooltip: 'Đóng',
                      onPressed: close,
                      style: IconButton.styleFrom(
                        backgroundColor: const Color(0x33FFFFFF),
                        foregroundColor: Colors.white,
                      ),
                      icon: const Icon(Icons.close),
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

/// Ô giờ đón / trả trên thẻ vé.
class _BoardingTime extends StatelessWidget {
  const _BoardingTime({required this.time, this.note});

  final String time;
  final String? note;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 32,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      alignment: Alignment.centerLeft,
      // Máy hẹp thì thu nhỏ để vẫn đọc được "+1 ngày".
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Text.rich(
          TextSpan(
            text: time,
            children: [
              if (note case final note?)
                TextSpan(
                  text: ' $note',
                  style: const TextStyle(
                    color: Color(0xFFC26A00),
                    fontSize: 9.5,
                    fontWeight: FontWeight.w500,
                  ),
                ),
            ],
          ),
          maxLines: 1,
          style: const TextStyle(
            color: journeyInk,
            fontSize: 16,
            height: 22 / 16,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

/// Một cột nhãn + giá trị ở chân thẻ vé.
class _BoardingValue extends StatelessWidget {
  const _BoardingValue({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          maxLines: 1,
          style: TextStyle(color: color, fontSize: 10, height: 14 / 10),
        ),
        const SizedBox(height: 1),
        Text(
          value,
          style: const TextStyle(
            color: journeyInk,
            fontSize: 11,
            height: 15 / 11,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
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

/// Số ngày lịch giữa giờ đón và giờ trả (giờ máy).
int _dayOffset(DateTime from, DateTime to) {
  final a = from.toLocal();
  final b = to.toLocal();
  return DateTime(
    b.year,
    b.month,
    b.day,
  ).difference(DateTime(a.year, a.month, a.day)).inDays;
}

/// Dòng dưới mã QR: vé đã dùng thì không còn "Lên xe quét mã".
String _qrCaption(JourneyTicket ticket) => switch (ticket.status) {
  'VALID' => 'Lên xe quét mã',
  'CHECKED_IN' => 'Đã lên xe',
  'USED' => 'Đã sử dụng',
  'NO_SHOW' => 'Vắng mặt',
  _ => 'QR không còn hiệu lực',
};

/// Nhãn trạng thái vé trên thẻ lên xe.
String _ticketStatusLabel(String status) => switch (status) {
  'VALID' => 'Hợp lệ',
  'CHECKED_IN' => 'Đã lên xe',
  'USED' => 'Đã đi',
  'NO_SHOW' => 'Vắng mặt',
  'CANCELLED' || 'REFUNDED' => 'Đã hủy',
  _ => status,
};

class _JourneyInformationCard extends StatelessWidget {
  const _JourneyInformationCard({required this.booking});

  final JourneyBooking booking;

  @override
  Widget build(BuildContext context) {
    final days = _dayOffset(
      booking.pickup.plannedAt,
      booking.dropoff.plannedAt,
    );
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(11, 10, 12, 13),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(9),
        border: Border.all(color: const Color(0xFFDFF3FC)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SizedBox.square(
                dimension: 19,
                child: Center(
                  child: SvgPicture.asset('$journeyAssetRoot/bus_blue.svg'),
                ),
              ),
              const SizedBox(width: 10),
              const Text(
                'Hành trình',
                style: TextStyle(
                  color: journeyInk,
                  fontSize: 14,
                  height: 20 / 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 11),
          _JourneyStopPanel(
            label: 'ĐIỂM ĐÓN',
            stop: booking.pickup,
            color: const Color(0xFFF18800),
            connected: true,
          ),
          _JourneyStopPanel(
            label: 'ĐIỂM TRẢ',
            stop: booking.dropoff,
            color: journeyButton,
            note: days > 0 ? '+$days ngày' : null,
          ),
        ],
      ),
    );
  }
}

/// Một điểm trên đường hành trình: giờ, tên điểm và địa chỉ hiện đầy đủ, không cắt chữ.
class _JourneyStopPanel extends StatelessWidget {
  const _JourneyStopPanel({
    required this.label,
    required this.stop,
    required this.color,
    this.note,
    this.connected = false,
  });

  final String label;
  final JourneyStop stop;
  final Color color;

  /// Ghi chú cạnh giờ, vd "+1 ngày" khi trả khách sang ngày sau.
  final String? note;

  /// Còn điểm tiếp theo thì vẽ đường nối xuống dưới.
  final bool connected;

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            width: 19,
            child: Column(
              children: [
                const SizedBox(height: 3),
                Container(
                  width: 13,
                  height: 13,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    border: Border.all(color: color, width: 3.5),
                  ),
                ),
                if (connected)
                  Expanded(
                    child: Container(
                      width: 2,
                      margin: const EdgeInsets.symmetric(vertical: 3),
                      color: journeyBorder,
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: connected ? 15 : 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          label,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: journeyBody,
                            fontSize: 11,
                            height: 18 / 11,
                            fontWeight: FontWeight.w600,
                            letterSpacing: .3,
                          ),
                        ),
                      ),
                      if (note case final note?) ...[
                        Text(
                          note,
                          style: const TextStyle(
                            color: Color(0xFFC26A00),
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(width: 6),
                      ],
                      Text(
                        journeyTime(stop.plannedAt),
                        style: const TextStyle(
                          color: journeyInk,
                          fontSize: 15,
                          height: 18 / 15,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 3),
                  Text(
                    stop.name,
                    style: const TextStyle(
                      color: journeyInk,
                      fontSize: 13.5,
                      height: 19 / 13.5,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (stop.address.trim().isNotEmpty) ...[
                    const SizedBox(height: 2),
                    Text(
                      stop.address,
                      style: const TextStyle(
                        color: journeyBody,
                        fontSize: 12,
                        height: 17 / 12,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PaymentCard extends StatelessWidget {
  const _PaymentCard({required this.booking});

  final JourneyBooking booking;

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
            _PaymentLine(
              top: 31,
              label:
                  'Giá vé (${booking.tickets.isEmpty ? '' : '${booking.tickets.length} '}chỗ)',
              value: journeyVnd(booking.subtotal),
            ),
            _PaymentLine(
              top: 47,
              label: 'Phí dịch vụ',
              value: journeyVnd(booking.serviceFee),
            ),
            _PaymentLine(
              top: 63,
              label: 'Giảm giá',
              value: journeyVnd(-booking.discount),
              valueColor: const Color(0xFF009F4C),
            ),
            Positioned(
              left: 13,
              top: 86,
              width: 114,
              child: Text(
                booking.paymentStatus == 'SUCCESS'
                    ? 'Đã thanh toán'
                    : 'Cần thanh toán',
                style: const TextStyle(
                  color: journeyInk,
                  fontSize: 10,
                  height: 14 / 10,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            Positioned(
              left: 90,
              top: 83,
              width: 100,
              child: Text(
                journeyVnd(booking.total),
                textAlign: TextAlign.right,
                style: const TextStyle(
                  color: journeyPrimary,
                  fontSize: 14,
                  height: 20 / 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            Positioned(
              left: 207,
              top: 26,
              child: _PaymentMetadataPanel(booking: booking),
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
  const _PaymentMetadataPanel({required this.booking});

  final JourneyBooking booking;

  @override
  Widget build(BuildContext context) {
    final paid = booking.paymentStatus == 'SUCCESS';
    return Container(
      width: 161,
      height: 75,
      decoration: BoxDecoration(
        color: const Color(0xFFF5F7FE),
        borderRadius: BorderRadius.circular(7),
      ),
      child: Stack(
        children: [
          _MetadataLine(
            top: 8,
            label: 'Phương thức',
            value: journeyProviderLabel(booking.paymentProvider),
          ),
          _MetadataLine(
            top: 29,
            label: 'Mã giao dịch',
            value: booking.paymentCode ?? '—',
          ),
          _MetadataLine(
            top: 50,
            label: 'Trạng thái',
            value: paid ? 'Thành công' : 'Chưa thanh toán',
            valueColor: paid
                ? const Color(0xFF009B61)
                : const Color(0xFFF79009),
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
  const _RefundPaymentCard({required this.booking});

  final JourneyBooking booking;

  @override
  Widget build(BuildContext context) {
    final refunded = booking.refunds.fold<int>(
      0,
      (sum, refund) => sum + refund.amount,
    );
    final last = booking.refunds.lastOrNull;
    return _DetailCard(
      icon: 'wallet.svg',
      title: 'Thanh toán / hoàn tiền',
      child: Column(
        children: [
          _ValueRow(label: 'Đã thanh toán', value: journeyVnd(booking.total)),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 5),
            child: Divider(height: 1, color: Color(0xFFE8EEF4)),
          ),
          _ValueRow(
            label: 'Tiền hoàn',
            value: journeyVnd(refunded),
            emphasized: true,
            valueColor: const Color(0xFF067647),
          ),
          const SizedBox(height: 4),
          _ValueRow(
            label: 'Phương thức hoàn',
            value: journeyProviderLabel(booking.paymentProvider),
          ),
          if (last != null) ...[
            _ValueRow(label: 'Mã hoàn tiền', value: last.refundCode),
            _ValueRow(
              label: 'Trạng thái',
              value: journeyRefundStatusLabel(last.status),
              valueColor: const Color(0xFFF79009),
            ),
          ] else
            const _ValueRow(
              label: 'Trạng thái',
              value: 'Không hoàn (đã qua mốc hoàn)',
              valueColor: Color(0xFFD92D20),
            ),
        ],
      ),
    );
  }
}

class _CancellationPolicyCard extends StatelessWidget {
  const _CancellationPolicyCard({
    required this.booking,
    required this.canCancel,
  });

  final JourneyBooking booking;
  final bool canCancel;

  @override
  Widget build(BuildContext context) {
    final departure = booking.departureAt;
    final tiers = [...booking.tiers]
      ..sort((a, b) => b.minHoursBefore.compareTo(a.minHoursBefore));
    String cutoff(int hours) {
      final at = departure.subtract(Duration(hours: hours)).toLocal();
      return '${journeyTime(at)} · ${at.day.toString().padLeft(2, '0')}/'
          '${at.month.toString().padLeft(2, '0')}';
    }

    final lines = <(String, String, Color)>[
      for (final tier in tiers)
        (
          'Trước ${cutoff(tier.minHoursBefore)}',
          tier.refundPercent > 0 ? 'Hoàn ${tier.refundPercent}%' : 'Không hoàn',
          tier.refundPercent >= 80
              ? const Color(0xFF009F4C)
              : tier.refundPercent > 0
              ? const Color(0xFFF18800)
              : const Color(0xFFF04438),
        ),
      if (tiers.isEmpty || tiers.last.minHoursBefore > 0)
        (
          tiers.isEmpty
              ? 'Mọi thời điểm'
              : 'Sau ${cutoff(tiers.last.minHoursBefore)}',
          'Không hoàn',
          const Color(0xFFF04438),
        ),
    ].take(4).toList();
    final hoursLeft = departure.difference(DateTime.now()).inMinutes / 60;
    final current = tiers
        .where((tier) => hoursLeft >= tier.minHoursBefore)
        .firstOrNull;
    final currentPercent = current?.refundPercent ?? 0;
    return _ScaledDesignBox(
      height: 87 + math.max(0, lines.length - 3) * 16,
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
            for (var index = 0; index < lines.length; index++)
              _PolicyLine(
                top: 33 + index * 16,
                label: lines[index].$1,
                value: lines[index].$2,
                valueColor: lines[index].$3,
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
                    Positioned(
                      left: 32,
                      top: 8,
                      width: 112,
                      child: Text(
                        !canCancel
                            ? 'Vé này không còn hủy được.'
                            : currentPercent > 0
                            ? 'Hiện tại: vé này được hoàn $currentPercent% số tiền đã trả khi hủy, nếu đáp ứng điều kiện.'
                            : 'Hiện tại: hủy vé sẽ không được hoàn tiền.',
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
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
  const _PassengerPickerSheet({
    required this.tickets,
    required this.selectedIndex,
  });

  final List<JourneyTicket> tickets;
  final int selectedIndex;

  @override
  State<_PassengerPickerSheet> createState() => _PassengerPickerSheetState();
}

class _PassengerPickerSheetState extends State<_PassengerPickerSheet> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final height = math.min(543.0, MediaQuery.sizeOf(context).height * .82);
    final tickets = widget.tickets;
    final indexes = List.generate(tickets.length, (index) => index)
        .where((index) {
          final query = _query.toLowerCase().trim();
          return query.isEmpty ||
              tickets[index].passengerName.toLowerCase().contains(query) ||
              tickets[index].seatCode.toLowerCase().contains(query);
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
              padding: EdgeInsets.fromLTRB(
                20,
                0,
                20,
                18 + MediaQuery.paddingOf(context).bottom,
              ),
              itemCount: indexes.length,
              separatorBuilder: (_, _) => const SizedBox(height: 8),
              itemBuilder: (context, itemIndex) {
                final index = indexes[itemIndex];
                final passenger = tickets[index];
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
                                passenger.passengerName,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: journeyInk,
                                  fontSize: 12.5,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                'Chỗ ${passenger.seatCode} · ${journeySeatTypeLabel(passenger.seatType)}'
                                '${passenger.isCancelled ? ' · Đã hủy' : ''}',
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

const _cancelReasons = {
  'plan': 'Thay đổi kế hoạch',
  'time': 'Không phù hợp giờ đi',
  'other': 'Lý do khác',
};

class _CancelTicketSheet extends StatefulWidget {
  const _CancelTicketSheet({required this.view, required this.quote});

  final _TicketView view;
  final JourneyCancellationQuote quote;

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
      onClose: () => Navigator.pop(context),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _CancellationTicketSummary(view: widget.view),
          const SizedBox(height: 10),
          _RefundEstimateCard(view: widget.view, quote: widget.quote),
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
            items: [
              for (final entry in _cancelReasons.entries)
                DropdownMenuItem(value: entry.key, child: Text(entry.value)),
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
              onPressed: () => Navigator.pop(context),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: JourneyPrimaryButton(
              key: const Key('continue-ticket-cancellation'),
              label: 'Tiếp tục',
              backgroundColor: const Color(0xFFF04438),
              height: 40,
              onPressed: () =>
                  Navigator.pop(context, _cancelReasons[_reason] ?? ''),
            ),
          ),
        ],
      ),
    );
  }
}

/// Bước xác nhận cuối: xem lại số tiền hoàn rồi hủy (API hủy vé không yêu cầu OTP).
class _ConfirmCancellationSheet extends StatelessWidget {
  const _ConfirmCancellationSheet({required this.view, required this.quote});

  final _TicketView view;
  final JourneyCancellationQuote quote;

  @override
  Widget build(BuildContext context) {
    return _SheetFrame(
      desiredHeight: 420,
      title: 'Xác nhận hủy vé',
      onClose: () => Navigator.pop(context, false),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _CancellationTicketSummary(view: view),
          const SizedBox(height: 14),
          const Text(
            'Vé đã hủy không khôi phục được và chỗ sẽ được mở bán lại.',
            style: TextStyle(color: journeyBody, fontSize: 11.5, height: 1.5),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Divider(height: 1, color: Color(0xFFE5EAF0)),
          ),
          _ValueRow(
            label: 'Số tiền hoàn dự kiến',
            value: journeyVnd(quote.refundAmount),
            emphasized: true,
            valueColor: const Color(0xFF067647),
          ),
          _ValueRow(
            label: 'Phương thức hoàn',
            value: journeyProviderLabel(view.booking.paymentProvider),
          ),
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
              onPressed: () => Navigator.pop(context, true),
            ),
          ),
        ],
      ),
    );
  }
}

class _CancellationSuccessSheet extends StatelessWidget {
  const _CancellationSuccessSheet({required this.view, required this.result});

  final _TicketView view;
  final JourneyCancellation result;

  @override
  Widget build(BuildContext context) {
    return _SheetFrame(
      desiredHeight: 536,
      title: 'Hủy vé thành công',
      onClose: () => Navigator.pop(context),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _CancellationTicketSummary(view: view),
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
                        'Vé đã được hủy và chỗ ngồi không còn hiệu lực.',
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
                _ValueRow(
                  label: 'Số tiền hoàn dự kiến',
                  value: journeyVnd(result.refundAmount),
                  emphasized: true,
                  valueColor: const Color(0xFF067647),
                ),
                _ValueRow(
                  label: 'Phương thức hoàn',
                  value: journeyProviderLabel(view.booking.paymentProvider),
                ),
                if (result.refundCode case final code?)
                  _ValueRow(label: 'Mã hoàn tiền', value: code),
                _ValueRow(
                  label: 'Trạng thái',
                  value: result.refundAmount > 0
                      ? 'Đang xử lý'
                      : 'Không hoàn (đã qua mốc hoàn)',
                  valueColor: const Color(0xFFF79009),
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
  const _CancellationTicketSummary({required this.view});

  final _TicketView view;

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
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Chỗ ${view.ticket.seatCode} · ${view.ticket.passengerName}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: journeyInk,
                    fontSize: 12.5,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  view.booking.routeName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: journeyInk,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Khởi hành ${journeyTime(view.booking.pickup.plannedAt)} · '
                  '${journeyLongDate(view.booking.pickup.plannedAt)} · '
                  '${view.booking.operatorName}',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
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
  const _RefundEstimateCard({required this.view, required this.quote});

  final _TicketView view;
  final JourneyCancellationQuote quote;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFCDDAF0), width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Tiền hoàn dự kiến (theo chính sách lưu lúc đặt)',
            style: TextStyle(
              color: journeyInk,
              fontSize: 10.5,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          _ValueRow(
            label: 'Số tiền đã trả cho vé hủy',
            value: journeyVnd(quote.selectedTotal),
          ),
          _ValueRow(
            label: 'Không hoàn (${100 - quote.refundPercent}%)',
            value: journeyVnd(-quote.nonRefundable),
            valueColor: const Color(0xFFD92D20),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 6),
            child: Divider(height: 1, color: Color(0xFFE5EAF0)),
          ),
          _ValueRow(
            label:
                'Hoàn về ${journeyProviderLabel(view.booking.paymentProvider)}',
            value: journeyVnd(quote.refundAmount),
            emphasized: true,
            valueColor: const Color(0xFF067647),
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
