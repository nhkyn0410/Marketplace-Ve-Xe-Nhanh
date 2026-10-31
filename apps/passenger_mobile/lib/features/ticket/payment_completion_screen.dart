import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:qr_flutter/qr_flutter.dart';

import 'booking_models.dart';
import 'payment_models.dart';
import 'trip_search_models.dart';

const _completionAssets = 'assets/ticket/completion';
const _page = Color(0xFFF4FAFD);
const _ink = Color(0xFF0B2942);
const _blue = Color(0xFF2B7EAD);
const _muted = Color(0xFF71899B);
const _line = Color(0xFFD7E7EF);

/// Hiển thị vé máy chủ đã phát hành; thiếu booking chỉ dùng dữ liệu xem trước.
class PaymentCompletionScreen extends StatefulWidget {
  const PaymentCompletionScreen({
    super.key,
    required this.selectedSeats,
    required this.passengerNames,
    this.isSignedIn = false,
    this.onBookingFinished,
    this.booking,
    this.issuedTickets,
  }) : assert(selectedSeats.length > 0),
       assert(selectedSeats.length == passengerNames.length),
       assert((booking == null) == (issuedTickets == null)),
       assert(
         issuedTickets == null || issuedTickets.length == selectedSeats.length,
       );

  final List<String> selectedSeats;
  final List<String> passengerNames;
  final bool isSignedIn;
  final VoidCallback? onBookingFinished;
  final CreatedBooking? booking;
  final List<IssuedBookingTicket>? issuedTickets;

  @override
  State<PaymentCompletionScreen> createState() =>
      _PaymentCompletionScreenState();
}

class _PaymentCompletionScreenState extends State<PaymentCompletionScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _printController;
  late final Animation<double> _printProgress;
  var _selectedIndex = 0;
  var _initialPrintScheduled = false;

  @override
  void initState() {
    super.initState();
    _printController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 780),
    );
    _printProgress = CurvedAnimation(
      parent: _printController,
      curve: Curves.easeOutCubic,
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (MediaQuery.disableAnimationsOf(context)) {
      _initialPrintScheduled = true;
      _printController.value = 1;
      return;
    }
    if (_initialPrintScheduled) return;
    _initialPrintScheduled = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _printController.forward(from: 0);
    });
  }

  @override
  void dispose() {
    _printController.dispose();
    super.dispose();
  }

  String get _passengerName {
    final name = widget.passengerNames[_selectedIndex].trim();
    return name.isEmpty ? 'Hành khách ${_selectedIndex + 1}' : name;
  }

  String get _seat => widget.selectedSeats[_selectedIndex];

  String _ticketCode(int index) {
    if (widget.issuedTickets != null) {
      return widget.issuedTickets![index].ticketCode;
    }
    final serial = (3865 + index).toString().padLeft(4, '0');
    return 'VXN726810$serial';
  }

  void _selectTicket(int index) {
    if (index < 0 || index >= widget.selectedSeats.length) return;
    setState(() => _selectedIndex = index);
    if (MediaQuery.disableAnimationsOf(context)) {
      _printController.value = 1;
    } else {
      _printController.forward(from: 0);
    }
  }

  Future<void> _openTicketPicker() async {
    final selected = await showModalBottomSheet<int>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      barrierColor: const Color(0x6B071D2B),
      builder: (context) {
        final height = MediaQuery.sizeOf(context).height;
        return FractionallySizedBox(
          key: const Key('ticket-picker-sheet'),
          heightFactor: height < 720 ? 0.9 : 0.66,
          child: _PassengerTicketSheet(
            seats: widget.selectedSeats,
            passengerNames: widget.passengerNames,
            selectedIndex: _selectedIndex,
          ),
        );
      },
    );
    if (!mounted || selected == null) return;
    _selectTicket(selected);
  }

  void _showDownloadNotice() {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        const SnackBar(
          content: Text(
            'Chưa hỗ trợ tải PDF. Bạn có thể xuất trình mã QR trên màn hình.',
          ),
        ),
      );
  }

  void _finishBooking() {
    final onFinished = widget.onBookingFinished;
    if (onFinished != null) {
      onFinished();
    } else {
      Navigator.of(context).popUntil((route) => route.isFirst);
    }
  }

  @override
  Widget build(BuildContext context) {
    final content = AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: _page,
        systemNavigationBarColor: _page,
      ),
      child: Scaffold(
        key: const Key('payment-completion-screen'),
        backgroundColor: _page,
        bottomNavigationBar: SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
            child: FilledButton.icon(
              key: const Key('payment-completion-return'),
              onPressed: _finishBooking,
              style: FilledButton.styleFrom(
                minimumSize: const Size.fromHeight(52),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                backgroundColor: _blue,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(13),
                ),
              ),
              icon: Icon(
                widget.isSignedIn
                    ? Icons.route_outlined
                    : Icons.explore_outlined,
                size: 22,
              ),
              label: Text(
                widget.isSignedIn ? 'Xem chuyến hành trình' : 'Khám phá thêm',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ),
        body: SafeArea(
          bottom: false,
          child: CustomScrollView(
            key: const Key('payment-completion-scroll'),
            slivers: [
              const SliverToBoxAdapter(child: _CompletionHeader()),
              const SliverToBoxAdapter(child: _CompletionProgress()),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 4, 16, 0),
                sliver: SliverList.list(
                  children: [
                    _PassengerOverview(
                      selectedIndex: _selectedIndex,
                      passengerCount: widget.passengerNames.length,
                      passengerName: _passengerName,
                      seat: _seat,
                      onPrevious: _selectedIndex > 0
                          ? () => _selectTicket(_selectedIndex - 1)
                          : null,
                      onNext: _selectedIndex < widget.passengerNames.length - 1
                          ? () => _selectTicket(_selectedIndex + 1)
                          : null,
                      onShowAll: _openTicketPicker,
                    ),
                    const SizedBox(height: 16),
                    _TicketPrinter(
                      progress: _printProgress,
                      passengerName: _passengerName,
                      seat: _seat,
                      ticketCode: _ticketCode(_selectedIndex),
                      booking: widget.booking,
                      qrToken: widget.issuedTickets?[_selectedIndex].qrToken,
                    ),
                    const SizedBox(height: 4),
                    _TicketPagination(
                      selectedIndex: _selectedIndex,
                      ticketCount: widget.selectedSeats.length,
                      onPrevious: _selectedIndex > 0
                          ? () => _selectTicket(_selectedIndex - 1)
                          : null,
                      onNext: _selectedIndex < widget.selectedSeats.length - 1
                          ? () => _selectTicket(_selectedIndex + 1)
                          : null,
                    ),
                    const SizedBox(height: 17),
                    SizedBox(
                      height: 52,
                      child: FilledButton.icon(
                        key: const Key('download-ticket'),
                        onPressed: _showDownloadNotice,
                        style: FilledButton.styleFrom(
                          backgroundColor: _blue,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(13),
                          ),
                        ),
                        icon: SvgPicture.asset(
                          '$_completionAssets/download.svg',
                          width: 20,
                          height: 20,
                        ),
                        label: const Text(
                          'Tải vé này (PDF)',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
    return PopScope<void>(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _finishBooking();
      },
      child: content,
    );
  }
}

class _CompletionHeader extends StatelessWidget {
  const _CompletionHeader();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.fromLTRB(18, 16, 16, 12),
      child: Text(
        'Vé của bạn',
        style: TextStyle(
          color: _ink,
          fontSize: 19,
          height: 1.2,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _CompletionProgress extends StatelessWidget {
  const _CompletionProgress();

  static const _steps = ['Chọn ghế', 'Thông tin', 'Thanh toán', 'Hoàn tất'];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 5, 18, 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(_steps.length, (index) {
          final active = index == _steps.length - 1;
          return Expanded(
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Divider(
                        color: index == 0 ? Colors.transparent : _blue,
                        height: 24,
                        thickness: 1.4,
                      ),
                    ),
                    if (active)
                      Container(
                        width: 24,
                        height: 24,
                        alignment: Alignment.center,
                        decoration: const BoxDecoration(
                          color: _blue,
                          shape: BoxShape.circle,
                        ),
                        child: const Text(
                          '4',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10.5,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      )
                    else
                      const _CompletedCircle(size: 24),
                    Expanded(
                      child: Divider(
                        color: index == _steps.length - 1
                            ? Colors.transparent
                            : _blue,
                        height: 24,
                        thickness: 1.4,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  _steps[index],
                  maxLines: 2,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: active ? _ink : _blue,
                    fontSize: 9.5,
                    height: 1.15,
                    fontWeight: active ? FontWeight.w700 : FontWeight.w500,
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}

class _PassengerOverview extends StatelessWidget {
  const _PassengerOverview({
    required this.selectedIndex,
    required this.passengerCount,
    required this.passengerName,
    required this.seat,
    required this.onPrevious,
    required this.onNext,
    required this.onShowAll,
  });

  final int selectedIndex;
  final int passengerCount;
  final String passengerName;
  final String seat;
  final VoidCallback? onPrevious;
  final VoidCallback? onNext;
  final VoidCallback onShowAll;

  @override
  Widget build(BuildContext context) {
    final selectedCard = Container(
      height: 58,
      padding: const EdgeInsets.fromLTRB(7, 7, 6, 7),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A143952),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            padding: const EdgeInsets.all(9),
            decoration: const BoxDecoration(
              color: _blue,
              shape: BoxShape.circle,
            ),
            child: SvgPicture.asset('$_completionAssets/user_selected.svg'),
          ),
          const SizedBox(width: 9),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Vé ${selectedIndex + 1}/$passengerCount',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: _muted,
                    fontSize: 9.5,
                    height: 1,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  'Chỗ $seat',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: _ink,
                    fontSize: 15.5,
                    height: 1,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  passengerName,
                  key: const Key('selected-passenger-name'),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: _muted,
                    fontSize: 9.5,
                    height: 1,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 4),
          _TicketArrowButton(
            key: const Key('ticket-previous'),
            asset: '$_completionAssets/arrow_left.svg',
            semanticsLabel: 'Vé trước',
            onTap: onPrevious,
          ),
          const SizedBox(width: 4),
          _TicketArrowButton(
            key: const Key('ticket-next'),
            asset: '$_completionAssets/arrow_right.svg',
            semanticsLabel: 'Vé sau',
            onTap: onNext,
          ),
        ],
      ),
    );

    final allTicketsButton = SizedBox(
      height: 42,
      child: OutlinedButton(
        key: const Key('all-tickets'),
        onPressed: onShowAll,
        style: OutlinedButton.styleFrom(
          foregroundColor: _blue,
          padding: const EdgeInsets.symmetric(horizontal: 6),
          side: const BorderSide(color: Color(0xFF9ED5EE)),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(9)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Text(
                'Tất cả vé ($passengerCount)',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const SizedBox(width: 4),
            SvgPicture.asset(
              '$_completionAssets/arrow_right.svg',
              width: 13,
              height: 13,
            ),
          ],
        ),
      ),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            SvgPicture.asset(
              '$_completionAssets/passenger.svg',
              width: 20,
              height: 20,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                '$passengerCount vé trong đơn đặt chỗ',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: _muted,
                  fontSize: 13.5,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 9),
        LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth < 350) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  selectedCard,
                  const SizedBox(height: 8),
                  SizedBox(width: 116, child: allTicketsButton),
                ],
              );
            }
            return Row(
              children: [
                Expanded(child: selectedCard),
                const SizedBox(width: 18),
                SizedBox(width: 110, child: allTicketsButton),
              ],
            );
          },
        ),
      ],
    );
  }
}

class _TicketArrowButton extends StatelessWidget {
  const _TicketArrowButton({
    super.key,
    required this.asset,
    required this.semanticsLabel,
    required this.onTap,
  });

  final String asset;
  final String semanticsLabel;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      enabled: onTap != null,
      label: semanticsLabel,
      child: Opacity(
        opacity: onTap == null ? 0.35 : 1,
        child: Material(
          color: const Color(0xFFF2F8FB),
          shape: const CircleBorder(),
          child: InkWell(
            customBorder: const CircleBorder(),
            onTap: onTap,
            child: SizedBox(
              width: 30,
              height: 30,
              child: Center(
                child: SvgPicture.asset(asset, width: 13, height: 13),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _TicketPrinter extends StatelessWidget {
  const _TicketPrinter({
    required this.progress,
    required this.passengerName,
    required this.seat,
    required this.ticketCode,
    this.booking,
    this.qrToken,
  });

  static const _printerWidth = 336.0;
  static const _billWidth = 322.0;
  static const _billHeight = 618.0;
  static const _billVisibleHeight = 584.0;

  final Animation<double> progress;
  final String passengerName;
  final String seat;
  final String ticketCode;
  final CreatedBooking? booking;
  final String? qrToken;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final billScale = math.min(1.0, constraints.maxWidth / _billWidth);
        final billWidth = _billWidth * billScale;
        final billHeight = _billHeight * billScale;
        final billVisibleHeight = _billVisibleHeight * billScale;
        final printerWidth = math.min(_printerWidth, constraints.maxWidth);
        final billTop = 31 * (printerWidth / _printerWidth);

        return SizedBox(
          height: billTop + billVisibleHeight + 2,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned(
                top: billTop,
                left: 0,
                right: 0,
                child: Center(
                  child: AnimatedBuilder(
                    animation: progress,
                    builder: (context, child) {
                      final value = progress.value.clamp(0.0, 1.0);
                      return ClipRect(
                        child: Align(
                          key: const Key('printed-ticket-reveal'),
                          alignment: Alignment.topCenter,
                          heightFactor: value,
                          child: Transform.translate(
                            offset: Offset(0, -7 * (1 - value)),
                            child: child,
                          ),
                        ),
                      );
                    },
                    child: SizedBox(
                      width: billWidth,
                      height: billHeight,
                      child: FittedBox(
                        fit: BoxFit.fill,
                        child: _TicketBill(
                          passengerName: passengerName,
                          seat: seat,
                          ticketCode: ticketCode,
                          booking: booking,
                          qrToken: qrToken,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Center(
                  child: Semantics(
                    label: 'Máy in vé',
                    image: true,
                    child: Image.asset(
                      '$_completionAssets/printer.png',
                      key: const Key('ticket-printer'),
                      width: printerWidth,
                      fit: BoxFit.contain,
                    ),
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

class _TicketBill extends StatelessWidget {
  const _TicketBill({
    required this.passengerName,
    required this.seat,
    required this.ticketCode,
    this.booking,
    this.qrToken,
  });

  final String passengerName;
  final String seat;
  final String ticketCode;
  final CreatedBooking? booking;
  final String? qrToken;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      key: const Key('printed-ticket'),
      width: _TicketPrinter._billWidth,
      height: _TicketPrinter._billHeight,
      child: Stack(
        children: [
          Positioned.fill(
            child: SvgPicture.asset(
              '$_completionAssets/bill_paper.svg',
              fit: BoxFit.fill,
            ),
          ),
          Positioned(
            top: 236,
            left: 63,
            right: 63,
            child: Opacity(
              opacity: 0.12,
              child: Image.asset(
                '$_completionAssets/bus_watermark.png',
                height: 108,
                fit: BoxFit.contain,
              ),
            ),
          ),
          Positioned.fill(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(41, 28, 41, 26),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        '$_completionAssets/app_logo_mark.svg',
                        width: 29,
                        height: 25,
                      ),
                      const SizedBox(width: 6),
                      SvgPicture.asset(
                        '$_completionAssets/app_logo_wordmark.svg',
                        width: 103,
                        height: 23,
                        fit: BoxFit.contain,
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  const _TicketSeparator(),
                  const SizedBox(height: 10),
                  const Text(
                    'VÉ ĐIỆN TỬ',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: _ink,
                      fontSize: 17,
                      height: 1,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    booking?.routeName ?? 'TP.HCM → ĐÀ LẠT',
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: _ink,
                      fontSize: 19,
                      height: 1,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const _TicketSeparator(),
                  const SizedBox(height: 7),
                  _BillDataRow(
                    label: 'Nhà xe',
                    value: booking?.operatorName ?? 'Phương Trang',
                  ),
                  _BillDataRow(
                    label: 'Ngày đi',
                    value: booking == null
                        ? '10/10/2026'
                        : formatVnDate(booking!.pickupAt),
                  ),
                  _BillDataRow(
                    label: 'Giờ khởi hành',
                    value: booking == null
                        ? '07:00'
                        : formatVnClock(booking!.pickupAt),
                  ),
                  _BillDataRow(
                    label: 'Tuyến',
                    value: booking?.routeName ?? 'TP.HCM → Đà Lạt',
                  ),
                  const SizedBox(height: 6),
                  const _TicketSeparator(),
                  const SizedBox(height: 6),
                  _BillDataRow(
                    label: 'Hành khách',
                    value: passengerName,
                    valueKey: const Key('ticket-passenger-name'),
                  ),
                  _BillDataRow(
                    label: 'Số ghế',
                    value: seat,
                    valueKey: const Key('ticket-seat'),
                    valueColor: _blue,
                  ),
                  _BillDataRow(
                    label: 'Loại xe',
                    value: booking?.vehicleTypeName ?? 'Limousine 34 phòng',
                  ),
                  const SizedBox(height: 6),
                  const _TicketSeparator(),
                  const SizedBox(height: 7),
                  _BillStop(
                    label: 'ĐIỂM ĐÓN',
                    title: booking?.pickupName ?? 'Bến xe Miền Đông',
                    detail: booking == null
                        ? '292 Đinh Bộ Lĩnh, Bình Thạnh, TP.HCM · 07:00'
                        : formatVnClock(booking!.pickupAt),
                  ),
                  const SizedBox(height: 6),
                  _BillStop(
                    label: 'ĐIỂM TRẢ',
                    title: booking?.dropoffName ?? 'Bến xe Đà Lạt',
                    detail: booking == null
                        ? '01 Tô Hiến Thành, Phường 3, Đà Lạt · 13:30'
                        : '${formatVnClock(booking!.dropoffAt)} (dự kiến)',
                  ),
                  const SizedBox(height: 6),
                  const _TicketSeparator(),
                  const SizedBox(height: 7),
                  Semantics(
                    label: qrToken == null
                        ? 'Mã QR minh họa, chưa có giá trị soát vé'
                        : 'Mã QR vé do máy chủ phát hành',
                    image: true,
                    child: Center(
                      child: qrToken == null
                          ? SvgPicture.asset(
                              '$_completionAssets/ticket_qr_demo.svg',
                              width: 88,
                              height: 88,
                            )
                          : QrImageView(
                              key: const Key('ticket-issued-qr'),
                              data: qrToken!,
                              semanticsLabel: 'Mã QR vé do máy chủ phát hành',
                              size: 88,
                              padding: const EdgeInsets.all(2),
                              backgroundColor: Colors.white,
                            ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    'Mã vé: $ticketCode',
                    key: const Key('ticket-code'),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: _ink,
                      fontSize: 10.5,
                      height: 1.2,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const _TicketSeparator(),
                  const SizedBox(height: 10),
                  const Text(
                    'ⓘ  Vui lòng xuất trình mã QR khi lên xe',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: _muted,
                      fontSize: 9.2,
                      height: 1.1,
                      fontWeight: FontWeight.w500,
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

class _TicketSeparator extends StatelessWidget {
  const _TicketSeparator();

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      '$_completionAssets/bill_separator.svg',
      width: double.infinity,
      height: 2,
      fit: BoxFit.fill,
    );
  }
}

class _BillDataRow extends StatelessWidget {
  const _BillDataRow({
    required this.label,
    required this.value,
    this.valueKey,
    this.valueColor,
  });

  final String label;
  final String value;
  final Key? valueKey;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 107,
            child: Text(
              label,
              style: const TextStyle(
                color: _muted,
                fontSize: 9.8,
                height: 1.2,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              key: valueKey,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: valueColor ?? _ink,
                fontSize: 10.7,
                height: 1.2,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BillStop extends StatelessWidget {
  const _BillStop({
    required this.label,
    required this.title,
    required this.detail,
  });

  final String label;
  final String title;
  final String detail;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: _ink,
            fontSize: 10.5,
            height: 1.1,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 7),
        Text(
          title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: _ink,
            fontSize: 10.4,
            height: 1.2,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          detail,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: _muted,
            fontSize: 9.2,
            height: 1.25,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

class _TicketPagination extends StatelessWidget {
  const _TicketPagination({
    required this.selectedIndex,
    required this.ticketCount,
    required this.onPrevious,
    required this.onNext,
  });

  final int selectedIndex;
  final int ticketCount;
  final VoidCallback? onPrevious;
  final VoidCallback? onNext;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _PaginationButton(
            label: 'Vé trước',
            leading: true,
            onTap: onPrevious,
          ),
        ),
        Container(
          constraints: const BoxConstraints(minWidth: 58),
          alignment: Alignment.center,
          child: Text(
            '${selectedIndex + 1} / $ticketCount',
            style: const TextStyle(
              color: _ink,
              fontSize: 13,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        Expanded(
          child: _PaginationButton(
            label: 'Vé sau',
            leading: false,
            onTap: onNext,
          ),
        ),
      ],
    );
  }
}

class _PaginationButton extends StatelessWidget {
  const _PaginationButton({
    required this.label,
    required this.leading,
    required this.onTap,
  });

  final String label;
  final bool leading;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final arrow = SvgPicture.asset(
      leading
          ? '$_completionAssets/arrow_left.svg'
          : '$_completionAssets/arrow_right.svg',
      width: 14,
      height: 14,
    );
    return Opacity(
      opacity: onTap == null ? 0.35 : 1,
      child: TextButton(
        onPressed: onTap,
        style: TextButton.styleFrom(
          foregroundColor: _blue,
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
        ),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (leading) arrow,
              if (leading) const SizedBox(width: 6),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w700,
                ),
              ),
              if (!leading) const SizedBox(width: 6),
              if (!leading) arrow,
            ],
          ),
        ),
      ),
    );
  }
}

class _PassengerTicketSheet extends StatefulWidget {
  const _PassengerTicketSheet({
    required this.seats,
    required this.passengerNames,
    required this.selectedIndex,
  });

  final List<String> seats;
  final List<String> passengerNames;
  final int selectedIndex;

  @override
  State<_PassengerTicketSheet> createState() => _PassengerTicketSheetState();
}

class _PassengerTicketSheetState extends State<_PassengerTicketSheet> {
  var _query = '';

  List<int> get _visibleIndexes {
    final query = _query.trim().toLowerCase();
    if (query.isEmpty) {
      return List.generate(widget.seats.length, (index) => index);
    }
    return List.generate(widget.seats.length, (index) => index).where((index) {
      final name = widget.passengerNames[index].toLowerCase();
      final seat = widget.seats[index].toLowerCase();
      return name.contains(query) || seat.contains(query);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final visibleIndexes = _visibleIndexes;
    return Material(
      key: const Key('passenger-ticket-sheet'),
      color: Colors.white,
      clipBehavior: Clip.antiAlias,
      borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.viewInsetsOf(context).bottom,
        ),
        child: Column(
          children: [
            const SizedBox(height: 14),
            Container(
              width: 42,
              height: 4,
              decoration: BoxDecoration(
                color: const Color(0xFFD9E4E9),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 31, 20, 9),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Chọn vé hành khách',
                          style: TextStyle(
                            color: _ink,
                            fontSize: 24,
                            height: 1.2,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          '${widget.seats.length} vé trong đơn đặt chỗ',
                          style: const TextStyle(
                            color: _muted,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox.square(
                    dimension: 48,
                    child: IconButton(
                      tooltip: 'Đóng',
                      style: IconButton.styleFrom(
                        backgroundColor: const Color(0xFFF2F7FA),
                      ),
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(
                        Icons.close_rounded,
                        color: _ink,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 7, 20, 20),
              child: TextField(
                key: const Key('ticket-search'),
                onChanged: (value) => setState(() => _query = value),
                textInputAction: TextInputAction.search,
                style: const TextStyle(
                  color: _ink,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
                decoration: InputDecoration(
                  hintText: 'Tìm tên hoặc mã ghế...',
                  hintStyle: const TextStyle(color: _muted, fontSize: 12.5),
                  prefixIcon: Padding(
                    padding: const EdgeInsets.all(13),
                    child: SvgPicture.asset(
                      '$_completionAssets/search.svg',
                      width: 18,
                      height: 18,
                    ),
                  ),
                  filled: true,
                  fillColor: const Color(0xFFF7FAFC),
                  contentPadding: const EdgeInsets.symmetric(vertical: 14),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(13),
                    borderSide: const BorderSide(color: Color(0xFFD1E1EA)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(13),
                    borderSide: const BorderSide(color: Color(0xFFD1E1EA)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(13),
                    borderSide: const BorderSide(color: _blue, width: 1.4),
                  ),
                ),
              ),
            ),
            Expanded(
              child: visibleIndexes.isEmpty
                  ? const Center(
                      child: Text(
                        'Không tìm thấy vé phù hợp',
                        style: TextStyle(
                          color: _muted,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    )
                  : ListView.separated(
                      keyboardDismissBehavior:
                          ScrollViewKeyboardDismissBehavior.onDrag,
                      padding: EdgeInsets.fromLTRB(
                        20,
                        0,
                        20,
                        24 + MediaQuery.paddingOf(context).bottom,
                      ),
                      itemCount: visibleIndexes.length,
                      separatorBuilder: (_, _) => const SizedBox(height: 12),
                      itemBuilder: (context, listIndex) {
                        final index = visibleIndexes[listIndex];
                        final selected = index == widget.selectedIndex;
                        final name = widget.passengerNames[index].trim().isEmpty
                            ? 'Hành khách ${index + 1}'
                            : widget.passengerNames[index].trim();
                        return _TicketOption(
                          key: Key('ticket-option-$index'),
                          seat: widget.seats[index],
                          passengerName: name,
                          passengerIndex: index,
                          selected: selected,
                          onTap: () => Navigator.pop(context, index),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TicketOption extends StatelessWidget {
  const _TicketOption({
    super.key,
    required this.seat,
    required this.passengerName,
    required this.passengerIndex,
    required this.selected,
    required this.onTap,
  });

  final String seat;
  final String passengerName;
  final int passengerIndex;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? const Color(0xFFF0F9FD) : Colors.white,
      shape: RoundedRectangleBorder(
        side: BorderSide(
          color: selected ? _blue : const Color(0xFFDCE8EE),
          width: selected ? 1.4 : 1,
        ),
        borderRadius: BorderRadius.circular(14),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: SizedBox(
          height: 76,
          child: Row(
            children: [
              SizedBox(
                width: 70,
                child: Center(
                  child: Text(
                    seat,
                    style: const TextStyle(
                      color: _ink,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 44,
                child: VerticalDivider(color: _line, width: 1),
              ),
              const SizedBox(width: 14),
              SvgPicture.asset(
                selected
                    ? '$_completionAssets/sheet_passenger_selected.svg'
                    : '$_completionAssets/sheet_passenger_unselected.svg',
                width: 29,
                height: 29,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      passengerName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: _ink,
                        fontSize: 13.5,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      'Hành khách ${passengerIndex + 1}',
                      style: const TextStyle(
                        color: _muted,
                        fontSize: 10.5,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              if (selected)
                const _CompletedCircle(size: 29)
              else
                Container(
                  width: 29,
                  height: 29,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: const Color(0xFFC8D9E2)),
                  ),
                ),
              const SizedBox(width: 13),
            ],
          ),
        ),
      ),
    );
  }
}

class _CompletedCircle extends StatelessWidget {
  const _CompletedCircle({required this.size});

  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          SvgPicture.asset(
            '$_completionAssets/step_complete.svg',
            width: size,
            height: size,
          ),
          SvgPicture.asset(
            '$_completionAssets/check.svg',
            width: size * 0.5,
            height: size * 0.5,
          ),
        ],
      ),
    );
  }
}
