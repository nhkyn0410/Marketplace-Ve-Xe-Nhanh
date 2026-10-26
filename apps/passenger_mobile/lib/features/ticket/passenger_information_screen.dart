import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'booking_flow_chrome.dart';
import 'booking_confirmation_screen.dart';

const _ink = Color(0xFF0B2942);
const _blue = Color(0xFF1E8ABE);
const _muted = Color(0xFF71899B);
const _page = Color(0xFFF2F8FB);
const _orange = Color(0xFFF59B31);
const _field = Color(0xFFF7FAFC);

class PassengerInformationScreen extends StatefulWidget {
  const PassengerInformationScreen({
    super.key,
    required this.selectedSeats,
    required this.holdExpiresAt,
    this.now,
  }) : assert(selectedSeats.length > 0);

  final List<String> selectedSeats;
  final DateTime holdExpiresAt;
  final DateTime Function()? now;

  @override
  State<PassengerInformationScreen> createState() =>
      _PassengerInformationScreenState();
}

class _PassengerInformationScreenState
    extends State<PassengerInformationScreen> {
  final _contactName = TextEditingController(text: 'Nguyễn Văn Minh');
  final _email = TextEditingController(text: 'minhnguyen.1990@gmail.com');
  final _phone = TextEditingController(text: '0908 123 456');
  final _voucher = TextEditingController();

  late final List<String> _seats;
  late final List<TextEditingController> _passengerNames;
  Timer? _timer;
  Duration _remaining = Duration.zero;

  @override
  void initState() {
    super.initState();
    _seats = [...widget.selectedSeats]..sort();
    _passengerNames = List.generate(
      _seats.length,
      (index) => TextEditingController(
        text: switch (index) {
          0 => 'Nguyễn Văn Minh',
          1 => 'Trần Thị Lan',
          _ => '',
        },
      ),
    );
    _refreshRemaining();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      setState(_refreshRemaining);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _contactName.dispose();
    _email.dispose();
    _phone.dispose();
    _voucher.dispose();
    for (final controller in _passengerNames) {
      controller.dispose();
    }
    super.dispose();
  }

  DateTime _now() => widget.now?.call() ?? DateTime.now();

  void _refreshRemaining() {
    final remaining = widget.holdExpiresAt.difference(_now());
    _remaining = remaining.isNegative ? Duration.zero : remaining;
  }

  String get _timerLabel {
    final seconds = (_remaining.inMilliseconds / 1000).ceil();
    final minutesPart = (seconds ~/ 60).toString().padLeft(2, '0');
    final secondsPart = (seconds % 60).toString().padLeft(2, '0');
    return '$minutesPart:$secondsPart';
  }

  bool get _formValid {
    final phoneDigits = _phone.text.replaceAll(RegExp(r'\D'), '');
    return _contactName.text.trim().isNotEmpty &&
        _email.text.contains('@') &&
        phoneDigits.length >= 9 &&
        _passengerNames.every(
          (controller) => controller.text.trim().isNotEmpty,
        );
  }

  Future<void> _chooseSavedPassenger(int index) async {
    final selected = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: Colors.transparent,
      useSafeArea: true,
      builder: (context) => const _SavedPassengerSheet(),
    );
    if (selected == null || !mounted) return;
    setState(() => _passengerNames[index].text = selected);
  }

  void _continueToConfirmation() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => BookingConfirmationScreen(
          selectedSeats: _seats,
          passengerNames: [
            for (final controller in _passengerNames) controller.text.trim(),
          ],
          holdExpiresAt: widget.holdExpiresAt,
          now: widget.now,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final expired = _remaining == Duration.zero;
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
          seats: _seats,
          onContinue: expired || !_formValid ? null : _continueToConfirmation,
        ),
        body: SafeArea(
          bottom: false,
          child: Column(
            children: [
              _Header(
                timerLabel: _timerLabel,
                expired: expired,
                urgent: _remaining <= const Duration(minutes: 1),
                onBack: () => Navigator.maybePop(context),
              ),
              const _StepProgress(),
              Expanded(
                child: CustomScrollView(
                  key: const Key('passenger-information-scroll'),
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,
                  slivers: [
                    SliverToBoxAdapter(
                      child: _TripSeatSummary(seatCount: _seats.length),
                    ),
                    SliverToBoxAdapter(
                      child: _ContactCard(
                        name: _contactName,
                        email: _email,
                        phone: _phone,
                        onChanged: () => setState(() {}),
                      ),
                    ),
                    const SliverToBoxAdapter(
                      child: _SectionTitle(
                        icon: Icons.group_rounded,
                        title: 'Hành khách',
                      ),
                    ),
                    SliverList.builder(
                      itemCount: _seats.length,
                      itemBuilder: (context, index) => _PassengerCard(
                        index: index,
                        seat: _seats[index],
                        controller: _passengerNames[index],
                        onChanged: () => setState(() {}),
                        onChooseSaved: () => _chooseSavedPassenger(index),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: _PromotionCard(controller: _voucher),
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

class _Header extends StatelessWidget {
  const _Header({
    required this.timerLabel,
    required this.expired,
    required this.urgent,
    required this.onBack,
  });

  final String timerLabel;
  final bool expired;
  final bool urgent;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return BookingFlowHeader(
      key: const Key('passenger-information-header'),
      title: 'Thông tin hành khách',
      timerLabel: timerLabel,
      expired: expired,
      urgent: urgent,
      onBack: onBack,
      backKey: const Key('passenger-information-back'),
      timerKey: const Key('passenger-hold-countdown'),
    );
  }
}

class _StepProgress extends StatelessWidget {
  const _StepProgress();

  @override
  Widget build(BuildContext context) {
    return const BookingStepProgress(
      key: Key('passenger-information-progress'),
      activeStep: 1,
    );
  }
}

class _TripSeatSummary extends StatelessWidget {
  const _TripSeatSummary({required this.seatCount});

  final int seatCount;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(10, 8, 10, 0),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(13),
      ),
      child: Column(
        children: [
          const Row(
            children: [
              _RoutePoint(
                time: '07:00',
                city: 'TP.HCM',
                station: 'Bến xe Miền Đông',
              ),
              Expanded(child: _DurationRoute()),
              _RoutePoint(
                time: '13:30',
                city: 'Đà Lạt',
                station: 'Bến xe Đà Lạt',
                end: true,
              ),
            ],
          ),
          const Divider(height: 22, color: Color(0xFFE1EAF0)),
          Row(
            children: [
              const Icon(Icons.event_seat_rounded, color: _muted, size: 20),
              const SizedBox(width: 6),
              const Expanded(
                child: Text(
                  'Số ghế\nđã chọn',
                  style: TextStyle(color: _muted, fontSize: 13, height: 1.2),
                ),
              ),
              Text(
                '$seatCount',
                key: const Key('selected-seat-count'),
                style: const TextStyle(
                  color: _blue,
                  fontSize: 16,
                  height: 1.2,
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
    required this.city,
    required this.station,
    this.end = false,
  });

  final String time;
  final String city;
  final String station;
  final bool end;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 92,
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
          Text(city, style: const TextStyle(color: _muted, fontSize: 13)),
          Text(
            station,
            textAlign: end ? TextAlign.end : TextAlign.start,
            style: const TextStyle(color: _muted, fontSize: 13),
          ),
        ],
      ),
    );
  }
}

class _DurationRoute extends StatelessWidget {
  const _DurationRoute();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
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
          const Text('6h30', style: TextStyle(color: _muted, fontSize: 13)),
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
    required this.onChanged,
  });

  final TextEditingController name;
  final TextEditingController email;
  final TextEditingController phone;
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
            textInputAction: TextInputAction.next,
            onChanged: onChanged,
          ),
          const SizedBox(height: 7),
          _InputField(
            fieldKey: const Key('contact-email-field'),
            label: 'Email',
            icon: Icons.email_rounded,
            controller: email,
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
  });

  final Key fieldKey;
  final String label;
  final IconData icon;
  final TextEditingController controller;
  final VoidCallback onChanged;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final String? hintText;

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
    required this.onChanged,
    required this.onChooseSaved,
  });

  final int index;
  final String seat;
  final TextEditingController controller;
  final VoidCallback onChanged;
  final VoidCallback onChooseSaved;

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
                      'Thông tin bắt buộc',
                      style: TextStyle(color: _muted, fontSize: 13),
                    ),
                  ],
                ),
              ),
            ],
          ),
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
              label: 'Họ và tên',
              icon: Icons.person_rounded,
              controller: controller,
              hintText: 'Nhập họ và tên',
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
  const _PromotionCard({required this.controller});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
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
          Row(
            children: [
              Expanded(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(minHeight: 48),
                  child: TextField(
                    key: const Key('voucher-field'),
                    controller: controller,
                    style: const TextStyle(color: _ink, fontSize: 14),
                    decoration: InputDecoration(
                      hintText: 'Nhập mã khuyến mãi',
                      hintStyle: const TextStyle(
                        color: Color(0xFFA5B5C0),
                        fontSize: 13,
                      ),
                      prefixIcon: const Icon(
                        Icons.confirmation_number_rounded,
                        color: _muted,
                        size: 15,
                      ),
                      prefixIconConstraints: const BoxConstraints(minWidth: 38),
                      contentPadding: const EdgeInsets.symmetric(vertical: 8),
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
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 7),
              ConstrainedBox(
                constraints: const BoxConstraints(minHeight: 48),
                child: FilledButton(
                  onPressed: () {},
                  style: FilledButton.styleFrom(
                    backgroundColor: _blue,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Áp dụng',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 7),
          const Row(
            children: [
              Icon(Icons.local_activity_rounded, color: _orange, size: 17),
              SizedBox(width: 6),
              Expanded(
                child: Text(
                  'Voucher của tôi',
                  style: TextStyle(color: _ink, fontSize: 14),
                ),
              ),
              Icon(Icons.chevron_right_rounded, color: _muted, size: 17),
            ],
          ),
          const SizedBox(height: 7),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFFECF9F1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Row(
              children: [
                Icon(
                  Icons.confirmation_number_rounded,
                  color: _orange,
                  size: 21,
                ),
                SizedBox(width: 7),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'VXN50K',
                        style: TextStyle(
                          color: Color(0xFF258A54),
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        'Giảm 50.000 đ cho đơn hàng',
                        style: TextStyle(color: _muted, fontSize: 13),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.check_circle_rounded,
                  color: Color(0xFF2FB471),
                  size: 15,
                ),
                SizedBox(width: 3),
                Text(
                  'Đã áp dụng',
                  style: TextStyle(color: Color(0xFF258A54), fontSize: 13),
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
  const _PassengerBottomBar({required this.seats, required this.onContinue});

  final List<String> seats;
  final VoidCallback? onContinue;

  @override
  Widget build(BuildContext context) {
    final amount = seats.length * 280000;
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
                    Text(
                      '${seats.length} khách hàng',
                      key: const Key('passenger-count'),
                      style: const TextStyle(
                        color: _ink,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${_formatAmount(amount)} đ',
                      key: const Key('passenger-total-amount'),
                      style: const TextStyle(
                        color: _blue,
                        fontSize: 19,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const Text(
                      'Tổng tiền',
                      style: TextStyle(color: _muted, fontSize: 13),
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
  const _SavedPassengerSheet();

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
              for (final name in const ['Nguyễn Văn Minh', 'Trần Thị Lan'])
                ListTile(
                  key: Key('saved-passenger-$name'),
                  contentPadding: EdgeInsets.zero,
                  leading: const CircleAvatar(
                    backgroundColor: Color(0xFFE8F4FA),
                    child: Icon(Icons.person_rounded, color: _blue),
                  ),
                  title: Text(
                    name,
                    style: const TextStyle(color: _ink, fontSize: 14),
                  ),
                  trailing: const Icon(
                    Icons.chevron_right_rounded,
                    color: _muted,
                  ),
                  onTap: () => Navigator.pop(context, name),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

String _formatAmount(int amount) {
  final digits = amount.toString();
  final buffer = StringBuffer();
  for (var index = 0; index < digits.length; index++) {
    if (index > 0 && (digits.length - index) % 3 == 0) buffer.write('.');
    buffer.write(digits[index]);
  }
  return buffer.toString();
}
