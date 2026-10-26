import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'booking_confirmation_screen.dart';

const _detailAssets = 'assets/ticket/detail';
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
          child: CustomScrollView(
            key: const Key('passenger-information-scroll'),
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            slivers: [
              SliverToBoxAdapter(
                child: _Header(onBack: () => Navigator.maybePop(context)),
              ),
              const SliverToBoxAdapter(child: _StepProgress()),
              SliverToBoxAdapter(
                child: _TripSeatSummary(seatCount: _seats.length),
              ),
              SliverToBoxAdapter(
                child: _HoldBanner(
                  timerLabel: _timerLabel,
                  seatCount: _seats.length,
                  expired: expired,
                ),
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
              SliverToBoxAdapter(child: _PromotionCard(controller: _voucher)),
              const SliverToBoxAdapter(child: SizedBox(height: 16)),
            ],
          ),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.onBack});

  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Colors.white,
      child: SizedBox(
        height: 58,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned(
              left: 8,
              child: IconButton(
                key: const Key('passenger-information-back'),
                onPressed: onBack,
                icon: SvgPicture.asset(
                  '$_detailAssets/back.svg',
                  width: 20,
                  height: 20,
                ),
              ),
            ),
            const Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Thông tin hành khách',
                  style: TextStyle(
                    color: _ink,
                    fontSize: 15.5,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 1),
                Text(
                  'TP.HCM → Đà Lạt',
                  style: TextStyle(color: _muted, fontSize: 9),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _StepProgress extends StatelessWidget {
  const _StepProgress();

  static const _steps = [
    'Chọn ghế',
    'Thông tin\nhành khách',
    'Thanh toán',
    'Hoàn tất',
  ];

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(18, 0, 18, 11),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: List.generate(_steps.length, (index) {
            final active = index == 1;
            final completed = index == 0;
            final color = active || completed ? _blue : const Color(0xFFEAF1F5);
            return Expanded(
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Divider(
                          color: index == 0
                              ? Colors.transparent
                              : completed || active
                              ? _blue
                              : const Color(0xFFDCE8EE),
                          height: 12,
                        ),
                      ),
                      Container(
                        width: 20,
                        height: 20,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: color,
                        ),
                        child: completed
                            ? const Icon(
                                Icons.check_rounded,
                                color: Colors.white,
                                size: 13,
                              )
                            : Text(
                                '${index + 1}',
                                style: TextStyle(
                                  color: active ? Colors.white : _muted,
                                  fontSize: 9,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                      ),
                      Expanded(
                        child: Divider(
                          color: index == _steps.length - 1
                              ? Colors.transparent
                              : completed
                              ? _blue
                              : const Color(0xFFDCE8EE),
                          height: 12,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 3),
                  Text(
                    _steps[index],
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    style: TextStyle(
                      color: active ? _ink : _muted,
                      fontSize: 8,
                      height: 1.1,
                      fontWeight: active ? FontWeight.w600 : FontWeight.w400,
                    ),
                  ),
                ],
              ),
            );
          }),
        ),
      ),
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
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(13),
      ),
      child: Row(
        children: [
          const _RoutePoint(
            time: '07:00',
            city: 'TP.HCM',
            station: 'Bến xe Miền Đông',
          ),
          const Expanded(child: _DurationRoute()),
          const _RoutePoint(
            time: '13:30',
            city: 'Đà Lạt',
            station: 'Bến xe Đà Lạt',
            end: true,
          ),
          Container(
            width: 1,
            height: 46,
            margin: const EdgeInsets.symmetric(horizontal: 6),
            color: const Color(0xFFE1EAF0),
          ),
          SizedBox(
            width: 70,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.event_seat_rounded, color: _muted, size: 16),
                const SizedBox(width: 4),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Số ghế\nđã chọn',
                        style: TextStyle(
                          color: _muted,
                          fontSize: 8.5,
                          height: 1.2,
                        ),
                      ),
                      Text(
                        '$seatCount',
                        key: const Key('selected-seat-count'),
                        style: const TextStyle(
                          color: _blue,
                          fontSize: 14,
                          height: 1.1,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
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
      width: 64,
      child: Column(
        crossAxisAlignment: end
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start,
        children: [
          Text(
            time,
            style: const TextStyle(
              color: _ink,
              fontSize: 13.5,
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(city, style: const TextStyle(color: _muted, fontSize: 7.5)),
          Text(
            station,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: _muted, fontSize: 6.5),
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
          const Text('6h30', style: TextStyle(color: _muted, fontSize: 8)),
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

class _HoldBanner extends StatelessWidget {
  const _HoldBanner({
    required this.timerLabel,
    required this.seatCount,
    required this.expired,
  });

  final String timerLabel;
  final int seatCount;
  final bool expired;

  @override
  Widget build(BuildContext context) {
    return Container(
      key: const Key('passenger-hold-banner'),
      margin: const EdgeInsets.fromLTRB(10, 7, 10, 0),
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 7),
      decoration: BoxDecoration(
        color: expired ? const Color(0xFFFFEDED) : const Color(0xFFFFF1DD),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Icon(
            expired ? Icons.error_outline_rounded : Icons.access_time_rounded,
            color: expired ? const Color(0xFFE44F4F) : _orange,
            size: 17,
          ),
          const SizedBox(width: 7),
          Expanded(
            child: Text(
              expired
                  ? 'Đã hết thời gian giữ ghế'
                  : 'Đang giữ $seatCount ghế cho bạn',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: expired ? const Color(0xFFE44F4F) : _orange,
                fontSize: 9.5,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Text(
            timerLabel,
            key: const Key('passenger-hold-countdown'),
            style: TextStyle(
              color: expired ? const Color(0xFFE44F4F) : _orange,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
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
          Text(
            title,
            style: const TextStyle(
              color: _ink,
              fontSize: 14,
              fontWeight: FontWeight.w600,
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
        Text(
          title,
          style: const TextStyle(
            color: _ink,
            fontSize: 14,
            fontWeight: FontWeight.w600,
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
        Text(label, style: const TextStyle(color: _muted, fontSize: 9)),
        const SizedBox(height: 3),
        SizedBox(
          height: 36,
          child: TextField(
            key: fieldKey,
            controller: controller,
            keyboardType: keyboardType,
            textInputAction: textInputAction,
            onChanged: (_) => onChanged(),
            style: const TextStyle(color: _ink, fontSize: 10.5),
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: const TextStyle(
                color: Color(0xFF9BB0BE),
                fontSize: 10,
              ),
              filled: true,
              fillColor: _field,
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(vertical: 8),
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
                width: 43,
                height: 34,
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
                    fontSize: 10.5,
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
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Text(
                      'Thông tin bắt buộc',
                      style: TextStyle(color: _muted, fontSize: 7.5),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 5),
              Flexible(
                child: Material(
                  color: const Color(0xFFEFF7FB),
                  borderRadius: BorderRadius.circular(16),
                  child: InkWell(
                    key: Key('saved-passenger-$seat'),
                    onTap: onChooseSaved,
                    borderRadius: BorderRadius.circular(16),
                    child: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 7),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.person_rounded, color: _blue, size: 13),
                          SizedBox(width: 4),
                          Flexible(
                            child: Text(
                              'Chọn hành khách đã lưu',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: Color(0xFF397393),
                                fontSize: 7.5,
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
          Padding(
            padding: const EdgeInsets.fromLTRB(57, 7, 0, 0),
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
                child: SizedBox(
                  height: 38,
                  child: TextField(
                    key: const Key('voucher-field'),
                    controller: controller,
                    style: const TextStyle(color: _ink, fontSize: 10),
                    decoration: InputDecoration(
                      hintText: 'Nhập mã khuyến mãi',
                      hintStyle: const TextStyle(
                        color: Color(0xFFA5B5C0),
                        fontSize: 9,
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
              SizedBox(
                height: 38,
                child: FilledButton(
                  onPressed: () {},
                  style: FilledButton.styleFrom(
                    backgroundColor: _blue,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('Áp dụng', style: TextStyle(fontSize: 9.5)),
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
                  style: TextStyle(color: _ink, fontSize: 10),
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
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        'Giảm 50.000 đ cho đơn hàng',
                        style: TextStyle(color: _muted, fontSize: 7.5),
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
                  style: TextStyle(color: Color(0xFF258A54), fontSize: 8),
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
          padding: const EdgeInsets.fromLTRB(10, 8, 10, 9),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final compact = constraints.maxWidth < 360;
              return Row(
                children: [
                  Expanded(
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerLeft,
                      child: Text(
                        '${seats.length} khách hàng',
                        key: const Key('passenger-count'),
                        maxLines: 1,
                        style: const TextStyle(
                          color: _ink,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: 1,
                    height: 38,
                    margin: EdgeInsets.symmetric(horizontal: compact ? 6 : 10),
                    color: const Color(0xFFE0E9EE),
                  ),
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        FittedBox(
                          fit: BoxFit.scaleDown,
                          alignment: Alignment.centerLeft,
                          child: Text(
                            '${_formatAmount(amount)} đ',
                            key: const Key('passenger-total-amount'),
                            maxLines: 1,
                            style: const TextStyle(
                              color: _blue,
                              fontSize: 16.5,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        const Text(
                          'Tổng tiền',
                          style: TextStyle(color: _muted, fontSize: 8),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 6),
                  SizedBox(
                    width: compact ? 106 : 132,
                    height: 46,
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
                                fontSize: 11,
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
              );
            },
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
                  fontSize: 15,
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
                    style: const TextStyle(color: _ink, fontSize: 12),
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
