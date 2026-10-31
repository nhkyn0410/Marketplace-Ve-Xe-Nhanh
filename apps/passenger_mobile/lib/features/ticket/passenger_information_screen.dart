import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_shared/mobile_shared.dart';

import 'booking_confirmation_screen.dart';
import 'booking_flow_chrome.dart';
import 'booking_models.dart';
import 'trip_booking_api.dart';
import 'trip_detail_models.dart';
import 'trip_search_models.dart';

const _ink = Color(0xFF0B2942);
const _blue = Color(0xFF1E8ABE);
const _muted = Color(0xFF71899B);
const _page = Color(0xFFF2F8FB);
const _orange = Color(0xFFF59B31);
const _field = Color(0xFFF7FAFC);
const _danger = Color(0xFFD84A4A);

/// Số điện thoại VN như API chấp nhận: `0xxxxxxxxx` hoặc `+84xxxxxxxxx` (bỏ khoảng trắng, chấm, gạch).
final _phonePattern = RegExp(r'^(0|\+84)\d{9}$');
final _emailPattern = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');

String _normalizePhone(String value) => value.replaceAll(RegExp(r'[\s.-]'), '');

/// Bước 2 đặt vé: người liên hệ, hành khách bổ sung tùy chọn, mã khuyến mãi; đếm theo hạn giữ chỗ.
class PassengerInformationScreen extends StatefulWidget {
  const PassengerInformationScreen({
    super.key,
    required this.api,
    required this.trip,
    required this.hold,
    this.now,
    this.isSignedIn = false,
    this.onBookingFinished,
  });

  final TripBookingApi api;
  final TripDetail trip;
  final SeatHold hold;
  final DateTime Function()? now;
  final bool isSignedIn;
  final VoidCallback? onBookingFinished;

  @override
  State<PassengerInformationScreen> createState() =>
      _PassengerInformationScreenState();
}

class _PassengerInformationScreenState
    extends State<PassengerInformationScreen> {
  final _contactName = TextEditingController();
  final _email = TextEditingController();
  final _phone = TextEditingController();
  final _promoCode = TextEditingController();

  late final List<HeldSeat> _seats = [...widget.hold.seats]
    ..sort((a, b) => a.code.compareTo(b.code));
  late final List<TextEditingController> _passengerNames = [
    for (final _ in _seats) TextEditingController(),
  ];
  late final List<TextEditingController> _passengerPhones = [
    for (final _ in _seats) TextEditingController(),
  ];

  /// Người đi cùng trên chỗ đôi (BR-78 bổ sung 28/10/2026, chờ duyệt) — chỉ dùng ở chỗ đôi, không bắt buộc.
  late final List<TextEditingController> _companionNames = [
    for (final _ in _seats) TextEditingController(),
  ];
  List<SavedTraveller> _travellers = const [];
  PromotionQuote? _promotion;
  String? _promoError;
  bool _checkingPromo = false;
  Timer? _timer;
  Duration _remaining = Duration.zero;

  @override
  void initState() {
    super.initState();
    _refreshRemaining();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      setState(_refreshRemaining);
    });
    _loadPrefill();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _contactName.dispose();
    _email.dispose();
    _phone.dispose();
    _promoCode.dispose();
    for (final controller in [
      ..._passengerNames,
      ..._passengerPhones,
      ..._companionNames,
    ]) {
      controller.dispose();
    }
    super.dispose();
  }

  Future<void> _loadPrefill() async {
    BookingPrefill? prefill;
    try {
      prefill = await widget.api.loadPrefill();
    } catch (_) {
      // Không điền sẵn được thì khách tự nhập.
      return;
    }
    if (prefill == null || !mounted) return;
    final contact = prefill.contact;
    setState(() {
      if (_contactName.text.isEmpty) _contactName.text = contact.fullName;
      if (_email.text.isEmpty) _email.text = contact.email;
      if (_phone.text.isEmpty) _phone.text = contact.phone;
      _travellers = prefill!.travellers;
    });
  }

  DateTime _now() => widget.now?.call() ?? DateTime.now();

  void _refreshRemaining() {
    final remaining = widget.hold.expiresAt.difference(_now());
    _remaining = remaining.isNegative ? Duration.zero : remaining;
  }

  String get _timerLabel {
    final seconds = (_remaining.inMilliseconds / 1000).ceil();
    final minutesPart = (seconds ~/ 60).toString().padLeft(2, '0');
    final secondsPart = (seconds % 60).toString().padLeft(2, '0');
    return '$minutesPart:$secondsPart';
  }

  bool get _phoneValid => _phonePattern.hasMatch(_normalizePhone(_phone.text));

  bool get _emailValid => _emailPattern.hasMatch(_email.text.trim());

  bool get _formValid =>
      _contactName.text.trim().isNotEmpty &&
      _emailValid &&
      _phoneValid &&
      _passengerPhones
          .skip(1)
          .every(
            (controller) =>
                controller.text.trim().isEmpty ||
                _phonePattern.hasMatch(_normalizePhone(controller.text)),
          );

  int get _total => _promotion?.total ?? widget.hold.subtotal;

  Future<void> _chooseSavedPassenger(int index) async {
    final selected = await showModalBottomSheet<SavedTraveller>(
      context: context,
      backgroundColor: Colors.transparent,
      useSafeArea: true,
      builder: (context) => _SavedPassengerSheet(travellers: _travellers),
    );
    if (selected == null || !mounted) return;
    setState(() {
      _passengerNames[index].text = selected.fullName;
      _passengerPhones[index].text = selected.phone ?? '';
    });
  }

  Future<void> _applyPromotion() async {
    final code = _promoCode.text.trim().toUpperCase();
    if (code.isEmpty || _checkingPromo) return;
    FocusScope.of(context).unfocus();
    setState(() {
      _checkingPromo = true;
      _promoError = null;
    });
    try {
      final quote = await widget.api.checkPromotion(
        tripId: widget.trip.tripId,
        code: code,
        subtotal: widget.hold.subtotal,
      );
      if (!mounted) return;
      setState(() {
        _promotion = quote;
        _promoCode.clear();
      });
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _promoError = error is ApiFailure && !error.isNetworkError
            ? error.detail
            : describeBookingFailure(error);
      });
    } finally {
      if (mounted) setState(() => _checkingPromo = false);
    }
  }

  void _continueToConfirmation() {
    final draft = BookingDraft(
      contact: BookingContact(
        fullName: _contactName.text.trim(),
        phone: _normalizePhone(_phone.text),
        email: _email.text.trim(),
      ),
      passengers: [
        for (var index = 0; index < _seats.length; index++)
          BookingPassenger(
            seatCode: _seats[index].code,
            fullName: index == 0 || _passengerNames[index].text.trim().isEmpty
                ? _contactName.text.trim()
                : _passengerNames[index].text.trim(),
            phone: index == 0
                ? _normalizePhone(_phone.text)
                : _passengerPhones[index].text.trim().isEmpty
                ? null
                : _normalizePhone(_passengerPhones[index].text),
            companionName:
                isDoubleSeat(_seats[index].type) &&
                    _companionNames[index].text.trim().isNotEmpty
                ? _companionNames[index].text.trim()
                : null,
          ),
      ],
      promotion: _promotion,
    );
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => BookingConfirmationScreen(
          api: widget.api,
          trip: widget.trip,
          hold: widget.hold,
          draft: draft,
          now: widget.now,
          isSignedIn: widget.isSignedIn,
          onBookingFinished: widget.onBookingFinished,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final expired = _remaining == Duration.zero;
    final phoneTouched = _phone.text.trim().isNotEmpty;
    final emailTouched = _email.text.trim().isNotEmpty;
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.white,
        systemNavigationBarColor: Colors.white,
      ),
      child: Scaffold(
        key: const Key('passenger-information-screen'),
        resizeToAvoidBottomInset: true,
        backgroundColor: _page,
        bottomNavigationBar: _PassengerBottomBar(
          passengerCount: _seats.length,
          total: _total,
          onContinue: expired || !_formValid ? null : _continueToConfirmation,
        ),
        body: SafeArea(
          bottom: false,
          child: Column(
            children: [
              BookingFlowHeader(
                key: const Key('passenger-information-header'),
                title: 'Thông tin',
                timerLabel: _timerLabel,
                expired: expired,
                urgent: _remaining <= const Duration(minutes: 1),
                onBack: () => Navigator.maybePop(context),
                backKey: const Key('passenger-information-back'),
                timerKey: const Key('passenger-hold-countdown'),
              ),
              const BookingStepProgress(
                key: Key('passenger-information-progress'),
                activeStep: 1,
              ),
              Expanded(
                child: CustomScrollView(
                  key: const Key('passenger-information-scroll'),
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,
                  slivers: [
                    SliverToBoxAdapter(
                      child: _TripSeatSummary(hold: widget.hold),
                    ),
                    SliverToBoxAdapter(
                      child: _ContactCard(
                        name: _contactName,
                        email: _email,
                        phone: _phone,
                        emailError: emailTouched && !_emailValid
                            ? 'Email chưa đúng định dạng.'
                            : null,
                        phoneError: phoneTouched && !_phoneValid
                            ? 'Số điện thoại gồm 10 số, bắt đầu bằng 0 hoặc +84.'
                            : null,
                        onChanged: () => setState(() {}),
                      ),
                    ),
                    if (_seats.length > 1)
                      const SliverToBoxAdapter(
                        child: _SectionTitle(
                          icon: Icons.group_rounded,
                          title: 'Hành khách bổ sung (tùy chọn)',
                        ),
                      ),
                    SliverList.builder(
                      itemCount: _seats.length - 1,
                      itemBuilder: (context, offset) {
                        final index = offset + 1;
                        final phone = _passengerPhones[index];
                        return _PassengerCard(
                          index: index,
                          seat: _seats[index].code,
                          controller: _passengerNames[index],
                          phoneController: phone,
                          phoneError:
                              phone.text.trim().isNotEmpty &&
                                  !_phonePattern.hasMatch(
                                    _normalizePhone(phone.text),
                                  )
                              ? 'Số điện thoại gồm 10 số, bắt đầu bằng 0 hoặc +84.'
                              : null,
                          companionController: isDoubleSeat(_seats[index].type)
                              ? _companionNames[index]
                              : null,
                          onChanged: () => setState(() {}),
                          onChooseSaved: _travellers.isEmpty
                              ? null
                              : () => _chooseSavedPassenger(index),
                        );
                      },
                    ),
                    SliverToBoxAdapter(
                      child: _PromotionCard(
                        controller: _promoCode,
                        promotion: _promotion,
                        error: _promoError,
                        checking: _checkingPromo,
                        onApply: _applyPromotion,
                        onRemove: () => setState(() => _promotion = null),
                      ),
                    ),
                    const SliverToBoxAdapter(child: SizedBox(height: 16)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TripSeatSummary extends StatelessWidget {
  const _TripSeatSummary({required this.hold});

  final SeatHold hold;

  @override
  Widget build(BuildContext context) {
    final minutes = hold.dropoff.plannedAt
        .difference(hold.pickup.plannedAt)
        .inMinutes;
    return Container(
      margin: const EdgeInsets.fromLTRB(10, 8, 10, 0),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(13),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _RoutePoint(
                time: formatVnClock(hold.pickup.plannedAt),
                station: hold.pickup.name,
              ),
              Expanded(
                child: _DurationRoute(duration: formatTripDuration(minutes)),
              ),
              _RoutePoint(
                time: formatVnClock(hold.dropoff.plannedAt),
                station: hold.dropoff.name,
                end: true,
              ),
            ],
          ),
          const Divider(height: 22, color: Color(0xFFE1EAF0)),
          Row(
            children: [
              const Icon(Icons.event_seat_rounded, color: _muted, size: 20),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  'Chỗ đã chọn · ${formatVnDate(hold.pickup.plannedAt)}',
                  style: const TextStyle(color: _muted, fontSize: 13),
                ),
              ),
              Text(
                hold.seatCodes.join(', '),
                key: const Key('selected-seat-codes'),
                style: const TextStyle(
                  color: _blue,
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _RoutePoint extends StatelessWidget {
  const _RoutePoint({
    required this.time,
    required this.station,
    this.end = false,
  });

  final String time;
  final String station;
  final bool end;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 110,
      child: Column(
        crossAxisAlignment: end
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start,
        children: [
          Text(
            time,
            style: const TextStyle(
              color: _ink,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            station,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: end ? TextAlign.end : TextAlign.start,
            style: const TextStyle(color: _muted, fontSize: 13),
          ),
        ],
      ),
    );
  }
}

class _DurationRoute extends StatelessWidget {
  const _DurationRoute({required this.duration});

  final String duration;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(5, 6, 5, 0),
      child: Column(
        children: [
          Row(
            children: [
              const Expanded(child: _DashedRouteLine()),
              Container(
                width: 22,
                height: 18,
                margin: const EdgeInsets.symmetric(horizontal: 3),
                decoration: BoxDecoration(
                  color: const Color(0xFFE9F5FB),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: const Icon(
                  Icons.directions_bus_rounded,
                  color: _blue,
                  size: 13,
                ),
              ),
              const Expanded(child: _DashedRouteLine()),
            ],
          ),
          const SizedBox(height: 2),
          Text(duration, style: const TextStyle(color: _muted, fontSize: 13)),
        ],
      ),
    );
  }
}

class _DashedRouteLine extends StatelessWidget {
  const _DashedRouteLine();

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 2,
      child: CustomPaint(painter: _DashedRouteLinePainter()),
    );
  }
}

class _DashedRouteLinePainter extends CustomPainter {
  const _DashedRouteLinePainter();

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFBDD0DB)
      ..strokeWidth = 1
      ..strokeCap = StrokeCap.round;
    const dashWidth = 4.0;
    const dashGap = 3.0;
    final y = size.height / 2;

    for (var x = 0.0; x < size.width; x += dashWidth + dashGap) {
      canvas.drawLine(
        Offset(x, y),
        Offset((x + dashWidth).clamp(0, size.width), y),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _DashedRouteLinePainter oldDelegate) => false;
}

class _ContactCard extends StatelessWidget {
  const _ContactCard({
    required this.name,
    required this.email,
    required this.phone,
    required this.emailError,
    required this.phoneError,
    required this.onChanged,
  });

  final TextEditingController name;
  final TextEditingController email;
  final TextEditingController phone;
  final String? emailError;
  final String? phoneError;
  final VoidCallback onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(10, 7, 10, 0),
      padding: const EdgeInsets.fromLTRB(12, 11, 12, 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(13),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _CardTitle(
            icon: Icons.person_rounded,
            title: 'Thông tin liên hệ',
          ),
          const SizedBox(height: 8),
          _InputField(
            fieldKey: const Key('contact-name-field'),
            label: 'Họ và tên',
            icon: Icons.person_rounded,
            controller: name,
            hintText: 'Nhập họ và tên người liên hệ',
            textInputAction: TextInputAction.next,
            onChanged: onChanged,
          ),
          const SizedBox(height: 7),
          _InputField(
            fieldKey: const Key('contact-email-field'),
            label: 'Email (nhận vé điện tử)',
            icon: Icons.email_rounded,
            controller: email,
            hintText: 'email@vidu.com',
            errorText: emailError,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            onChanged: onChanged,
          ),
          const SizedBox(height: 7),
          _InputField(
            fieldKey: const Key('contact-phone-field'),
            label: 'Số điện thoại',
            icon: Icons.phone_rounded,
            controller: phone,
            hintText: '0901 234 567',
            errorText: phoneError,
            keyboardType: TextInputType.phone,
            textInputAction: TextInputAction.done,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.icon, required this.title});

  final IconData icon;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 13, 14, 7),
      child: Row(
        children: [
          Icon(icon, color: _blue, size: 20),
          const SizedBox(width: 7),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                color: _ink,
                fontSize: 17,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CardTitle extends StatelessWidget {
  const _CardTitle({required this.icon, required this.title});

  final IconData icon;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: _blue, size: 20),
        const SizedBox(width: 7),
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              color: _ink,
              fontSize: 17,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}

class _InputField extends StatelessWidget {
  const _InputField({
    required this.fieldKey,
    required this.label,
    required this.icon,
    required this.controller,
    required this.onChanged,
    this.keyboardType,
    this.textInputAction,
    this.hintText,
    this.errorText,
  });

  final Key fieldKey;
  final String label;
  final IconData icon;
  final TextEditingController controller;
  final VoidCallback onChanged;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final String? hintText;
  final String? errorText;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: _muted, fontSize: 13)),
        const SizedBox(height: 3),
        ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 48),
          child: TextField(
            key: fieldKey,
            controller: controller,
            keyboardType: keyboardType,
            textInputAction: textInputAction,
            onChanged: (_) => onChanged(),
            style: const TextStyle(color: _ink, fontSize: 14),
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: const TextStyle(
                color: Color(0xFF9BB0BE),
                fontSize: 13,
              ),
              errorText: errorText,
              errorMaxLines: 2,
              filled: true,
              fillColor: _field,
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(vertical: 12),
              prefixIcon: Icon(icon, color: _muted, size: 16),
              prefixIconConstraints: const BoxConstraints(minWidth: 38),
              suffixIcon: controller.text.isEmpty
                  ? null
                  : IconButton(
                      onPressed: () {
                        controller.clear();
                        onChanged();
                      },
                      padding: EdgeInsets.zero,
                      visualDensity: VisualDensity.compact,
                      icon: const Icon(
                        Icons.close_rounded,
                        color: Color(0xFFA9BAC5),
                        size: 14,
                      ),
                    ),
              suffixIconConstraints: const BoxConstraints(minWidth: 34),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(7),
                borderSide: const BorderSide(color: Color(0xFFE0E9EE)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(7),
                borderSide: const BorderSide(color: _blue),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(7),
                borderSide: const BorderSide(color: _danger),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(7),
                borderSide: const BorderSide(color: _danger),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _PassengerCard extends StatelessWidget {
  const _PassengerCard({
    required this.index,
    required this.seat,
    required this.controller,
    required this.phoneController,
    required this.phoneError,
    required this.onChanged,
    required this.onChooseSaved,
    this.companionController,
  });

  final int index;
  final String seat;
  final TextEditingController controller;
  final TextEditingController phoneController;
  final String? phoneError;
  final VoidCallback onChanged;

  /// Ô người đi cùng — chỉ có ở chỗ đôi.
  final TextEditingController? companionController;

  /// `null` = không có hành khách đã lưu (khách vãng lai) — ẩn nút chọn.
  final VoidCallback? onChooseSaved;

  @override
  Widget build(BuildContext context) {
    return Container(
      key: Key('passenger-card-$seat'),
      margin: const EdgeInsets.fromLTRB(10, 0, 10, 7),
      padding: const EdgeInsets.fromLTRB(0, 10, 11, 11),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(13),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                constraints: const BoxConstraints(minWidth: 48, minHeight: 40),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  color: _blue,
                  borderRadius: BorderRadius.horizontal(
                    right: Radius.circular(9),
                  ),
                ),
                child: Text(
                  seat,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                width: 33,
                height: 33,
                decoration: const BoxDecoration(
                  color: Color(0xFFE8F4FA),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.person_rounded, color: _blue, size: 19),
              ),
              const SizedBox(width: 7),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Hành khách ${index + 1}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: _ink,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Text(
                      'Không bắt buộc',
                      style: TextStyle(color: _muted, fontSize: 13),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (onChooseSaved != null)
            Align(
              alignment: Alignment.centerRight,
              child: Material(
                color: const Color(0xFFEFF7FB),
                borderRadius: BorderRadius.circular(18),
                child: InkWell(
                  key: Key('saved-passenger-$seat'),
                  onTap: onChooseSaved,
                  borderRadius: BorderRadius.circular(18),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.person_rounded, color: _blue, size: 18),
                        SizedBox(width: 5),
                        Flexible(
                          child: Text(
                            'Chọn hành khách đã lưu',
                            style: TextStyle(
                              color: Color(0xFF397393),
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          Padding(
            padding: const EdgeInsets.fromLTRB(57, 8, 0, 0),
            child: _InputField(
              fieldKey: Key('passenger-name-$seat'),
              label: 'Họ và tên (tùy chọn)',
              icon: Icons.person_rounded,
              controller: controller,
              hintText: 'Nhập họ và tên',
              textInputAction: TextInputAction.next,
              onChanged: onChanged,
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(57, 8, 0, 0),
            child: _InputField(
              fieldKey: Key('passenger-phone-$seat'),
              label: 'Số điện thoại (tùy chọn)',
              icon: Icons.phone_rounded,
              controller: phoneController,
              keyboardType: TextInputType.phone,
              textInputAction: TextInputAction.done,
              hintText: 'Nhập số điện thoại',
              errorText: phoneError,
              onChanged: onChanged,
            ),
          ),
          if (companionController != null)
            Padding(
              padding: const EdgeInsets.fromLTRB(57, 8, 0, 0),
              child: _InputField(
                fieldKey: Key('companion-name-$seat'),
                label: 'Người đi cùng (không bắt buộc)',
                icon: Icons.people_alt_rounded,
                controller: companionController!,
                hintText: 'Chỗ đôi chở tối đa 2 người, chung một vé',
                textInputAction: TextInputAction.next,
                onChanged: onChanged,
              ),
            ),
        ],
      ),
    );
  }
}

class _PromotionCard extends StatelessWidget {
  const _PromotionCard({
    required this.controller,
    required this.promotion,
    required this.error,
    required this.checking,
    required this.onApply,
    required this.onRemove,
  });

  final TextEditingController controller;
  final PromotionQuote? promotion;
  final String? error;
  final bool checking;
  final VoidCallback onApply;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final applied = promotion;
    return Container(
      margin: const EdgeInsets.fromLTRB(10, 5, 10, 0),
      padding: const EdgeInsets.fromLTRB(12, 11, 12, 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(13),
      ),
      child: Column(
        children: [
          const Align(
            alignment: Alignment.centerLeft,
            child: _CardTitle(
              icon: Icons.card_giftcard_rounded,
              title: 'Ưu đãi',
            ),
          ),
          const SizedBox(height: 9),
          if (applied == null)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: TextField(
                    key: const Key('voucher-field'),
                    controller: controller,
                    textCapitalization: TextCapitalization.characters,
                    onSubmitted: (_) => onApply(),
                    style: const TextStyle(color: _ink, fontSize: 14),
                    decoration: InputDecoration(
                      hintText: 'Nhập mã khuyến mãi',
                      hintStyle: const TextStyle(
                        color: Color(0xFFA5B5C0),
                        fontSize: 13,
                      ),
                      errorText: error,
                      errorMaxLines: 2,
                      prefixIcon: const Icon(
                        Icons.confirmation_number_rounded,
                        color: _muted,
                        size: 15,
                      ),
                      prefixIconConstraints: const BoxConstraints(minWidth: 38),
                      contentPadding: const EdgeInsets.symmetric(vertical: 14),
                      isDense: true,
                      filled: true,
                      fillColor: _field,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(7),
                        borderSide: const BorderSide(color: Color(0xFFE0E9EE)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(7),
                        borderSide: const BorderSide(color: _blue),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(7),
                        borderSide: const BorderSide(color: _danger),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(7),
                        borderSide: const BorderSide(color: _danger),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 7),
                SizedBox(
                  height: 48,
                  child: FilledButton(
                    key: const Key('voucher-apply'),
                    onPressed: checking ? null : onApply,
                    style: FilledButton.styleFrom(
                      backgroundColor: _blue,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: checking
                        ? const SizedBox.square(
                            dimension: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.2,
                              color: Colors.white,
                            ),
                          )
                        : const Text(
                            'Áp dụng',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  ),
                ),
              ],
            )
          else
            Container(
              key: const Key('voucher-applied'),
              padding: const EdgeInsets.fromLTRB(10, 8, 4, 8),
              decoration: BoxDecoration(
                color: const Color(0xFFECF9F1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.confirmation_number_rounded,
                    color: _orange,
                    size: 21,
                  ),
                  const SizedBox(width: 7),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${applied.code} đã áp dụng',
                          style: const TextStyle(
                            color: Color(0xFF258A54),
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          '${applied.name} · −${formatVnd(applied.discount)}',
                          style: const TextStyle(color: _muted, fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    key: const Key('voucher-remove'),
                    tooltip: 'Bỏ mã',
                    onPressed: onRemove,
                    icon: const Icon(Icons.close_rounded, color: _muted),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _PassengerBottomBar extends StatelessWidget {
  const _PassengerBottomBar({
    required this.passengerCount,
    required this.total,
    required this.onContinue,
  });

  final int passengerCount;
  final int total;
  final VoidCallback? onContinue;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Color(0x16092137),
            blurRadius: 13,
            offset: Offset(0, -3),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 9, 12, 10),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Wrap(
                      spacing: 6,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Text(
                          '$passengerCount hành khách',
                          key: const Key('passenger-count'),
                          style: const TextStyle(
                            color: _ink,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const Text(
                          'Tạm tính',
                          style: TextStyle(color: _muted, fontSize: 13),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      formatVnd(total),
                      key: const Key('passenger-total-amount'),
                      style: const TextStyle(
                        color: _blue,
                        fontSize: 19,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              ConstrainedBox(
                constraints: const BoxConstraints(
                  minWidth: 132,
                  maxWidth: 170,
                  minHeight: 50,
                ),
                child: FilledButton(
                  key: const Key('passenger-information-continue'),
                  onPressed: onContinue,
                  style: FilledButton.styleFrom(
                    backgroundColor: _blue,
                    disabledBackgroundColor: const Color(0xFFB9CED9),
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Flexible(
                        child: Text(
                          'Tiếp tục',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      SizedBox(width: 6),
                      Icon(Icons.arrow_forward_rounded, size: 17),
                    ],
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

class _SavedPassengerSheet extends StatelessWidget {
  const _SavedPassengerSheet({required this.travellers});

  final List<SavedTraveller> travellers;

  @override
  Widget build(BuildContext context) {
    return Material(
      key: const Key('saved-passenger-sheet'),
      color: Colors.white,
      borderRadius: const BorderRadius.vertical(top: Radius.circular(22)),
      clipBehavior: Clip.antiAlias,
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(14, 14, 14, 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Chọn hành khách đã lưu',
                style: TextStyle(
                  color: _ink,
                  fontSize: 19,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 9),
              Flexible(
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    for (final traveller in travellers)
                      ListTile(
                        key: Key('saved-passenger-${traveller.fullName}'),
                        contentPadding: EdgeInsets.zero,
                        leading: const CircleAvatar(
                          backgroundColor: Color(0xFFE8F4FA),
                          child: Icon(Icons.person_rounded, color: _blue),
                        ),
                        title: Text(
                          traveller.fullName,
                          style: const TextStyle(color: _ink, fontSize: 14),
                        ),
                        subtitle: traveller.phone == null
                            ? null
                            : Text(traveller.phone!),
                        trailing: const Icon(
                          Icons.chevron_right_rounded,
                          color: _muted,
                        ),
                        onTap: () => Navigator.pop(context, traveller),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
