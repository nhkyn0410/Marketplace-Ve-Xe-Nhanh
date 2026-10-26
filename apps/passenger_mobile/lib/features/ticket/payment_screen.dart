import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'payment_completion_screen.dart';

const _detailAssets = 'assets/ticket/detail';
const _paymentAssets = 'assets/ticket/payment';
const _ink = Color(0xFF0B2942);
const _blue = Color(0xFF1E8ABE);
const _muted = Color(0xFF71899B);
const _page = Color(0xFFF2F8FB);
const _orange = Color(0xFFF4A11F);
const _seatPrice = 280000;
const _serviceFee = 20000;
const _discount = 50000;

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({
    super.key,
    required this.selectedSeats,
    required this.passengerNames,
    required this.holdExpiresAt,
    this.now,
  }) : assert(selectedSeats.length > 0),
       assert(selectedSeats.length == passengerNames.length);

  final List<String> selectedSeats;
  final List<String> passengerNames;
  final DateTime holdExpiresAt;
  final DateTime Function()? now;

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  Timer? _timer;
  Duration _remaining = Duration.zero;
  String _selectedMethod = 'vnpay';
  String _selectedBankCode = 'VCB';
  bool _termsAccepted = true;

  int get _ticketAmount => widget.selectedSeats.length * _seatPrice;
  int get _totalAmount => _ticketAmount + _serviceFee - _discount;
  DateTime _now() => widget.now?.call() ?? DateTime.now();

  @override
  void initState() {
    super.initState();
    _refreshRemaining();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      setState(_refreshRemaining);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _refreshRemaining() {
    final remaining = widget.holdExpiresAt.difference(_now());
    _remaining = remaining.isNegative ? Duration.zero : remaining;
  }

  String get _timerLabel {
    final seconds = (_remaining.inMilliseconds / 1000).ceil();
    final minutes = (seconds ~/ 60).toString().padLeft(2, '0');
    final remainingSeconds = (seconds % 60).toString().padLeft(2, '0');
    return '$minutes:$remainingSeconds';
  }

  String get _selectedBankName =>
      _banks.firstWhere((bank) => bank.code == _selectedBankCode).shortName;

  Future<void> _chooseBank() async {
    final selected = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      barrierColor: const Color(0x990B1F2E),
      builder: (context) => FractionallySizedBox(
        heightFactor: 0.9,
        child: _BankPickerSheet(initialBankCode: _selectedBankCode),
      ),
    );
    if (selected == null || !mounted) return;
    setState(() => _selectedBankCode = selected);
  }

  void _openDemoCompletion() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(
        builder: (_) => PaymentCompletionScreen(
          selectedSeats: widget.selectedSeats,
          passengerNames: widget.passengerNames,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final expired = _remaining == Duration.zero;
    final canPay = !expired && _termsAccepted;
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: _page,
        systemNavigationBarColor: Colors.white,
      ),
      child: Scaffold(
        key: const Key('payment-screen'),
        backgroundColor: _page,
        bottomNavigationBar: _PaymentBottomBar(
          totalAmount: _totalAmount,
          method: _selectedMethod,
          onPay: canPay ? _openDemoCompletion : null,
        ),
        body: SafeArea(
          bottom: false,
          child: CustomScrollView(
            key: const Key('payment-scroll'),
            slivers: [
              SliverToBoxAdapter(
                child: _PaymentHeader(
                  timerLabel: _timerLabel,
                  expired: expired,
                  urgent: _remaining <= const Duration(minutes: 1),
                  onBack: () => Navigator.maybePop(context),
                ),
              ),
              const SliverToBoxAdapter(child: _PaymentProgress()),
              SliverToBoxAdapter(
                child: _OrderCard(
                  seatCount: widget.selectedSeats.length,
                  passengerNames: widget.passengerNames,
                  ticketAmount: _ticketAmount,
                  totalAmount: _totalAmount,
                  onEdit: () => Navigator.maybePop(context),
                ),
              ),
              SliverToBoxAdapter(
                child: _PaymentMethodCard(
                  selectedMethod: _selectedMethod,
                  onChanged: (method) {
                    setState(() => _selectedMethod = method);
                  },
                ),
              ),
              if (_selectedMethod == 'vnpay')
                SliverToBoxAdapter(
                  child: _BankSelector(
                    bankName: _selectedBankName,
                    onTap: _chooseBank,
                  ),
                ),
              const SliverToBoxAdapter(child: _SafePaymentNotice()),
              SliverToBoxAdapter(
                child: _PaymentTerms(
                  accepted: _termsAccepted,
                  onChanged: (value) {
                    setState(() => _termsAccepted = value ?? false);
                  },
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 14)),
            ],
          ),
        ),
      ),
    );
  }
}

class _PaymentHeader extends StatelessWidget {
  const _PaymentHeader({
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
    final warning = expired || urgent;
    return Padding(
      padding: const EdgeInsets.fromLTRB(6, 5, 10, 4),
      child: Row(
        children: [
          IconButton(
            key: const Key('payment-back'),
            onPressed: onBack,
            icon: SvgPicture.asset(
              '$_detailAssets/back.svg',
              width: 20,
              height: 20,
            ),
          ),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Thanh toán',
                  style: TextStyle(
                    color: _ink,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  'TP.HCM → Đà Lạt',
                  style: TextStyle(color: _muted, fontSize: 9.5),
                ),
              ],
            ),
          ),
          Container(
            key: const Key('payment-hold-timer'),
            padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 7),
            decoration: BoxDecoration(
              color: warning
                  ? const Color(0xFFFFE4E4)
                  : const Color(0xFFFFF1D8),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.access_time_filled_rounded,
                  color: warning ? const Color(0xFFD84A4A) : _orange,
                  size: 15,
                ),
                const SizedBox(width: 4),
                Text(
                  expired ? 'Đã hết hạn' : 'Giữ ghế trong $timerLabel',
                  style: TextStyle(
                    color: warning ? const Color(0xFFD84A4A) : _orange,
                    fontSize: 9.5,
                    fontWeight: FontWeight.w600,
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

class _PaymentProgress extends StatelessWidget {
  const _PaymentProgress();

  static const _steps = [
    'Chọn ghế',
    'Thông tin\nhành khách',
    'Thanh toán',
    'Hoàn tất',
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 2, 18, 11),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(_steps.length, (index) {
          final active = index == 2;
          final completed = index < 2;
          final color = active || completed ? _blue : const Color(0xFFE3ECF1);
          return Expanded(
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Divider(
                        color: index == 0
                            ? Colors.transparent
                            : index <= 2
                            ? _blue
                            : const Color(0xFFD7E4EA),
                        height: 12,
                      ),
                    ),
                    Container(
                      width: 21,
                      height: 21,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: color,
                      ),
                      child: completed
                          ? const Icon(
                              Icons.check_rounded,
                              color: Colors.white,
                              size: 14,
                            )
                          : Text(
                              '${index + 1}',
                              style: TextStyle(
                                color: active ? Colors.white : _muted,
                                fontSize: 9,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                    ),
                    Expanded(
                      child: Divider(
                        color: index == _steps.length - 1
                            ? Colors.transparent
                            : index < 2
                            ? _blue
                            : const Color(0xFFD7E4EA),
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
                    fontSize: 8.5,
                    height: 1.1,
                    fontWeight: active ? FontWeight.w700 : FontWeight.w400,
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

class _OrderCard extends StatelessWidget {
  const _OrderCard({
    required this.seatCount,
    required this.passengerNames,
    required this.ticketAmount,
    required this.totalAmount,
    required this.onEdit,
  });

  final int seatCount;
  final List<String> passengerNames;
  final int ticketAmount;
  final int totalAmount;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    final passengerLabel = passengerNames.length == 1
        ? passengerNames.first
        : '${passengerNames.first} + ${passengerNames.length - 1} khách';
    return _PaymentCard(
      child: Column(
        children: [
          _SectionHeader(
            icon: Icons.receipt_long_rounded,
            title: 'Đơn của bạn',
            trailing: 'Chỉnh sửa',
            onTap: onEdit,
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Image.asset(
                '$_detailAssets/phuong_trang_logo.png',
                width: 32,
                height: 32,
                fit: BoxFit.contain,
              ),
              const SizedBox(width: 9),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Phương Trang',
                      style: TextStyle(
                        color: _ink,
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      '10/10/2026',
                      style: TextStyle(color: _muted, fontSize: 9),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Row(
            children: [
              _OrderRoutePoint(time: '07:00', city: 'TP.HCM'),
              Expanded(child: _OrderRouteDuration()),
              _OrderRoutePoint(time: '13:30', city: 'Đà Lạt', end: true),
            ],
          ),
          const SizedBox(height: 9),
          _OrderInfoRow(
            icon: Icons.person_rounded,
            label: 'Hành khách',
            value: passengerLabel,
          ),
          const _OrderInfoRow(
            icon: Icons.location_on_outlined,
            label: 'Bến đi',
            value: 'Bến xe Miền Đông',
          ),
          const _OrderInfoRow(
            icon: Icons.location_on_rounded,
            label: 'Bến đến',
            value: 'Bến xe Đà Lạt',
            iconColor: Color(0xFFE0A82E),
          ),
          const _OrderInfoRow(
            icon: Icons.calendar_month_rounded,
            label: 'Thời gian',
            value: '13:30 · 10/10/2026 (dự kiến)',
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 9),
            child: Divider(height: 1, color: Color(0xFFE2EBF0)),
          ),
          _PriceRow(
            label: '$seatCount vé × 280.000 đ',
            value: '${_formatAmount(ticketAmount)} đ',
          ),
          const SizedBox(height: 6),
          const _PriceRow(label: 'Phí dịch vụ', value: '20.000 đ'),
          const SizedBox(height: 6),
          const _PriceRow(
            label: 'Giảm giá (VXN50K)',
            value: '-50.000 đ',
            discount: true,
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 9),
            child: Divider(height: 1, color: Color(0xFFE2EBF0)),
          ),
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Tổng cộng',
                  style: TextStyle(
                    color: _ink,
                    fontSize: 12.5,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Text(
                '${_formatAmount(totalAmount)} đ',
                key: const Key('payment-order-total'),
                style: const TextStyle(
                  color: _orange,
                  fontSize: 18,
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

class _OrderRoutePoint extends StatelessWidget {
  const _OrderRoutePoint({
    required this.time,
    required this.city,
    this.end = false,
  });

  final String time;
  final String city;
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
              fontSize: 15,
              fontWeight: FontWeight.w700,
            ),
          ),
          Text(city, style: const TextStyle(color: _muted, fontSize: 8.5)),
        ],
      ),
    );
  }
}

class _OrderRouteDuration extends StatelessWidget {
  const _OrderRouteDuration();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 5,
                height: 5,
                decoration: const BoxDecoration(
                  color: Color(0xFFB6C9D4),
                  shape: BoxShape.circle,
                ),
              ),
              const Expanded(
                child: Divider(color: Color(0xFFC7D6DE), height: 1),
              ),
              Container(
                width: 5,
                height: 5,
                decoration: const BoxDecoration(
                  color: Color(0xFFB6C9D4),
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ),
          const Text('6h30', style: TextStyle(color: _muted, fontSize: 8)),
          const Text('Trực tiếp', style: TextStyle(color: _muted, fontSize: 7)),
        ],
      ),
    );
  }
}

class _OrderInfoRow extends StatelessWidget {
  const _OrderInfoRow({
    required this.icon,
    required this.label,
    required this.value,
    this.iconColor = _blue,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: Row(
        children: [
          Icon(icon, color: iconColor, size: 15),
          const SizedBox(width: 7),
          SizedBox(
            width: 67,
            child: Text(
              label,
              style: const TextStyle(color: _muted, fontSize: 9),
            ),
          ),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.end,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: _ink,
                fontSize: 9,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PriceRow extends StatelessWidget {
  const _PriceRow({
    required this.label,
    required this.value,
    this.discount = false,
  });

  final String label;
  final String value;
  final bool discount;

  @override
  Widget build(BuildContext context) {
    final color = discount ? const Color(0xFF258A54) : _muted;
    return Row(
      children: [
        Expanded(
          child: Text(label, style: TextStyle(color: color, fontSize: 9.5)),
        ),
        Text(
          value,
          style: TextStyle(
            color: discount ? const Color(0xFF258A54) : _ink,
            fontSize: 10,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class _PaymentMethodCard extends StatelessWidget {
  const _PaymentMethodCard({
    required this.selectedMethod,
    required this.onChanged,
  });

  final String selectedMethod;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final momo = _PaymentOption(
      title: 'Ví MoMo',
      subtitle: 'Thanh toán qua app MoMo',
      logo: Image.asset(
        '$_paymentAssets/payment_momo_figma.png',
        width: 31.2,
        height: 31.2,
        fit: BoxFit.contain,
      ),
      badge: 'Sắp hỗ trợ',
      selected: false,
      enabled: false,
    );
    final vnPay = _PaymentOption(
      optionKey: const Key('payment-method-vnpay'),
      title: 'VNPAY',
      subtitle: 'QR / Thẻ ATM nội địa',
      logo: Image.asset(
        '$_paymentAssets/payment_vnpay_figma.png',
        width: 31.2,
        height: 24.4,
        fit: BoxFit.cover,
      ),
      selected: selectedMethod == 'vnpay',
      onTap: () => onChanged('vnpay'),
    );
    final visa = _PaymentOption(
      optionKey: const Key('payment-method-visa'),
      title: 'Thẻ Visa/Master',
      subtitle: 'Quốc tế',
      logo: Image.asset(
        '$_paymentAssets/payment_visa_master_figma.png',
        width: 31.2,
        height: 31.2,
        fit: BoxFit.contain,
      ),
      selected: selectedMethod == 'visa',
      onTap: () => onChanged('visa'),
    );
    final atm = _PaymentOption(
      optionKey: const Key('payment-method-atm'),
      title: 'Thẻ ATM',
      subtitle: 'Internet Banking 30+ ngân hàng',
      logo: Image.asset(
        '$_paymentAssets/payment_atm_figma.png',
        width: 31.2,
        height: 31.2,
        fit: BoxFit.cover,
      ),
      selected: selectedMethod == 'atm',
      onTap: () => onChanged('atm'),
    );

    return _PaymentCard(
      child: Column(
        children: [
          const _SectionHeader(
            icon: Icons.account_balance_wallet_outlined,
            title: 'Chọn phương thức thanh toán',
            subtitle: 'Chọn một phương thức để hoàn tất đơn đặt vé.',
          ),
          const SizedBox(height: 10),
          LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth < 300) {
                return Column(
                  children: [
                    momo,
                    const SizedBox(height: 8),
                    vnPay,
                    const SizedBox(height: 8),
                    visa,
                    const SizedBox(height: 8),
                    atm,
                  ],
                );
              }
              return Column(
                children: [
                  Row(
                    children: [
                      Expanded(child: momo),
                      const SizedBox(width: 8),
                      Expanded(child: vnPay),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(child: visa),
                      const SizedBox(width: 8),
                      Expanded(child: atm),
                    ],
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 8),
          _PaymentOption(
            title: 'Tiền mặt',
            subtitle: 'Không hỗ trợ trong phiên bản này',
            logo: Image.asset(
              '$_paymentAssets/payment_cash_figma.png',
              width: 35,
              height: 22.8,
              fit: BoxFit.contain,
            ),
            selected: false,
            enabled: false,
            fullWidth: true,
          ),
        ],
      ),
    );
  }
}

class _PaymentOption extends StatelessWidget {
  const _PaymentOption({
    this.optionKey,
    required this.title,
    required this.subtitle,
    required this.logo,
    required this.selected,
    this.enabled = true,
    this.onTap,
    this.badge,
    this.fullWidth = false,
  });

  final Key? optionKey;
  final String title;
  final String subtitle;
  final Widget logo;
  final bool selected;
  final bool enabled;
  final VoidCallback? onTap;
  final String? badge;
  final bool fullWidth;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: enabled ? 1 : 0.72,
      child: Material(
        key: optionKey,
        color: selected ? const Color(0xFFEAF5FA) : Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(9),
          side: BorderSide(
            color: selected ? _blue : const Color(0xFFE2E9ED),
            width: selected ? 1.2 : 1,
          ),
        ),
        child: InkWell(
          onTap: enabled ? onTap : null,
          borderRadius: BorderRadius.circular(9),
          child: SizedBox(
            height: fullWidth ? 48 : 60,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 7),
              child: Row(
                children: [
                  SizedBox(width: 35, height: 35, child: Center(child: logo)),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                title,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: _ink,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            if (badge != null) ...[
                              const SizedBox(width: 4),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 4,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFFF0DA),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  badge!,
                                  style: const TextStyle(
                                    color: _orange,
                                    fontSize: 6.5,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                        const SizedBox(height: 2),
                        Text(
                          subtitle,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: _muted,
                            fontSize: 7.5,
                            height: 1.15,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (selected) ...[
                    const SizedBox(width: 4),
                    const Icon(
                      Icons.check_circle_rounded,
                      color: _blue,
                      size: 16,
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _BankSelector extends StatelessWidget {
  const _BankSelector({required this.bankName, required this.onTap});

  final String bankName;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      key: const Key('payment-bank-selector'),
      color: Colors.white,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          margin: const EdgeInsets.fromLTRB(10, 0, 10, 9),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: const Color(0xFFE1E9ED)),
          ),
          child: Row(
            children: [
              const Icon(Icons.account_balance_rounded, color: _blue, size: 20),
              const SizedBox(width: 10),
              const Expanded(
                child: Text(
                  'Chọn ngân hàng',
                  style: TextStyle(
                    color: _ink,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Text(
                bankName,
                key: const Key('selected-bank-name'),
                style: const TextStyle(
                  color: _blue,
                  fontSize: 8.5,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 4),
              const Icon(Icons.chevron_right_rounded, color: _muted, size: 18),
            ],
          ),
        ),
      ),
    );
  }
}

class _SafePaymentNotice extends StatelessWidget {
  const _SafePaymentNotice();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(10, 0, 10, 9),
      padding: const EdgeInsets.all(11),
      decoration: BoxDecoration(
        color: const Color(0xFFE7F5FC),
        borderRadius: BorderRadius.circular(10),
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.verified_user_rounded, color: _blue, size: 21),
          SizedBox(width: 9),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Thanh toán an toàn qua VNPAY',
                  style: TextStyle(
                    color: _blue,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 3),
                Text(
                  'Dữ liệu thẻ được mã hóa PCI-DSS, không lưu trên hệ thống của VXN. Sau khi nhấn thanh toán, bạn sẽ được chuyển tiếp tới cổng xác nhận phù hợp.',
                  style: TextStyle(color: _muted, fontSize: 8.5, height: 1.35),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PaymentTerms extends StatelessWidget {
  const _PaymentTerms({required this.accepted, required this.onChanged});

  final bool accepted;
  final ValueChanged<bool?> onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 28,
            height: 28,
            child: Checkbox(
              key: const Key('payment-terms-checkbox'),
              value: accepted,
              onChanged: onChanged,
              activeColor: _blue,
              checkColor: Colors.white,
              side: const BorderSide(color: _blue, width: 1.4),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
            ),
          ),
          const SizedBox(width: 6),
          const Expanded(
            child: Padding(
              padding: EdgeInsets.only(top: 5),
              child: Text.rich(
                TextSpan(
                  style: TextStyle(color: _muted, fontSize: 8.5, height: 1.3),
                  children: [
                    TextSpan(text: 'Tôi đồng ý với '),
                    TextSpan(
                      text: 'Điều khoản dịch vụ',
                      style: TextStyle(
                        color: _blue,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                    TextSpan(text: ' và '),
                    TextSpan(
                      text: 'Chính sách đổi/hủy',
                      style: TextStyle(
                        color: _blue,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                    TextSpan(text: ' của Vé Xe Nhanh.'),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PaymentBottomBar extends StatelessWidget {
  const _PaymentBottomBar({
    required this.totalAmount,
    required this.method,
    required this.onPay,
  });

  final int totalAmount;
  final String method;
  final VoidCallback? onPay;

  @override
  Widget build(BuildContext context) {
    final isVnPay = method == 'vnpay';
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
          padding: const EdgeInsets.fromLTRB(12, 8, 10, 9),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final compact = constraints.maxWidth < 360;
              return Row(
                children: [
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Tổng cộng',
                          style: TextStyle(color: _muted, fontSize: 8.5),
                        ),
                        FittedBox(
                          fit: BoxFit.scaleDown,
                          alignment: Alignment.centerLeft,
                          child: Text(
                            '${_formatAmount(totalAmount)} đ',
                            key: const Key('payment-bottom-total'),
                            style: const TextStyle(
                              color: _orange,
                              fontSize: 19,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  SizedBox(
                    width: compact ? 177 : 214,
                    height: 47,
                    child: FilledButton(
                      key: const Key('payment-submit'),
                      onPressed: onPay,
                      style: FilledButton.styleFrom(
                        backgroundColor: _orange,
                        disabledBackgroundColor: const Color(0xFFD9C8A6),
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (isVnPay) ...[
                            SizedBox(
                              width: 31,
                              height: 31,
                              child: Image.asset(
                                '$_paymentAssets/payment_vnpay_figma.png',
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(width: 7),
                          ],
                          Flexible(
                            child: Text(
                              isVnPay
                                  ? 'Thanh toán với VNPAY'
                                  : 'Thanh toán ngay',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
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

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
    required this.icon,
    required this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
  });

  final IconData icon;
  final String title;
  final String? subtitle;
  final String? trailing;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: _blue, size: 21),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: _ink,
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
              if (subtitle != null)
                Text(
                  subtitle!,
                  style: const TextStyle(color: _muted, fontSize: 8),
                ),
            ],
          ),
        ),
        if (trailing != null)
          InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(6),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 3),
              child: Row(
                children: [
                  const Icon(Icons.edit_outlined, color: _blue, size: 14),
                  const SizedBox(width: 4),
                  Text(
                    trailing!,
                    style: const TextStyle(
                      color: _blue,
                      fontSize: 8.5,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}

class _PaymentCard extends StatelessWidget {
  const _PaymentCard({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(10, 0, 10, 9),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: child,
    );
  }
}

class _BankPickerSheet extends StatefulWidget {
  const _BankPickerSheet({required this.initialBankCode});

  final String initialBankCode;

  @override
  State<_BankPickerSheet> createState() => _BankPickerSheetState();
}

class _BankPickerSheetState extends State<_BankPickerSheet> {
  late String _selectedCode = widget.initialBankCode;
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final query = _query.trim().toLowerCase();
    final filtered = _banks.where((bank) {
      return query.isEmpty ||
          bank.shortName.toLowerCase().contains(query) ||
          bank.fullName.toLowerCase().contains(query);
    }).toList();

    return Material(
      key: const Key('bank-picker-sheet'),
      color: Colors.white,
      borderRadius: const BorderRadius.vertical(top: Radius.circular(22)),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          const SizedBox(height: 8),
          Container(
            width: 42,
            height: 4,
            decoration: BoxDecoration(
              color: const Color(0xFFD7E1E6),
              borderRadius: BorderRadius.circular(3),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 8, 8, 8),
            child: Row(
              children: [
                const Icon(
                  Icons.account_balance_rounded,
                  color: _blue,
                  size: 22,
                ),
                const SizedBox(width: 8),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Chọn ngân hàng',
                        style: TextStyle(
                          color: _ink,
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        'Chọn ngân hàng để thanh toán qua VNPAY.',
                        style: TextStyle(color: _muted, fontSize: 8.5),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  key: const Key('bank-picker-close'),
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close_rounded, color: _ink, size: 18),
                  style: IconButton.styleFrom(
                    backgroundColor: const Color(0xFFF3F7F9),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: SizedBox(
              height: 38,
              child: TextField(
                key: const Key('bank-search'),
                onChanged: (value) => setState(() => _query = value),
                style: const TextStyle(color: _ink, fontSize: 10),
                decoration: InputDecoration(
                  hintText: 'Tìm ngân hàng',
                  hintStyle: const TextStyle(
                    color: Color(0xFF9AAEBB),
                    fontSize: 10,
                  ),
                  prefixIcon: const Icon(
                    Icons.search_rounded,
                    color: _muted,
                    size: 18,
                  ),
                  filled: true,
                  fillColor: const Color(0xFFF5F7FA),
                  contentPadding: EdgeInsets.zero,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(9),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: GridView.builder(
              key: const Key('bank-grid'),
              padding: const EdgeInsets.symmetric(horizontal: 14),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 7,
                mainAxisSpacing: 7,
                mainAxisExtent: 56,
              ),
              itemCount: filtered.length,
              itemBuilder: (context, index) {
                final bank = filtered[index];
                final selected = bank.code == _selectedCode;
                return _BankTile(
                  bank: bank,
                  selected: selected,
                  onTap: () => setState(() => _selectedCode = bank.code),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 9, 14, 10),
            child: SizedBox(
              width: double.infinity,
              height: 44,
              child: FilledButton(
                key: const Key('bank-confirm'),
                onPressed: () => Navigator.pop(context, _selectedCode),
                style: FilledButton.styleFrom(
                  backgroundColor: _blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(9),
                  ),
                ),
                child: const Text(
                  'Xác nhận',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BankTile extends StatelessWidget {
  const _BankTile({
    required this.bank,
    required this.selected,
    required this.onTap,
  });

  final _Bank bank;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      key: Key('bank-${bank.code}'),
      color: selected ? const Color(0xFFEAF5FA) : Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(
          color: selected ? _blue : const Color(0xFFE0E8EC),
          width: selected ? 1.2 : 1,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 6),
          child: Row(
            children: [
              SizedBox(
                width: 53,
                height: 28,
                child: Image.asset(bank.assetPath, fit: BoxFit.contain),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      bank.shortName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: _ink,
                        fontSize: 8.5,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      bank.fullName,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: _muted,
                        fontSize: 5.7,
                        height: 1.1,
                      ),
                    ),
                  ],
                ),
              ),
              if (selected)
                const Icon(Icons.check_circle_rounded, color: _blue, size: 14),
            ],
          ),
        ),
      ),
    );
  }
}

class _Bank {
  const _Bank({
    required this.code,
    required this.shortName,
    required this.fullName,
    required this.assetPath,
  });

  final String code;
  final String shortName;
  final String fullName;
  final String assetPath;
}

const _banks = [
  _Bank(
    code: 'VCB',
    shortName: 'Vietcombank',
    fullName: 'Ngân hàng TMCP Ngoại thương Việt Nam',
    assetPath: '$_paymentAssets/vietcombank.png',
  ),
  _Bank(
    code: 'TCB',
    shortName: 'Techcombank',
    fullName: 'Ngân hàng TMCP Kỹ thương Việt Nam',
    assetPath: '$_paymentAssets/techcombank.png',
  ),
  _Bank(
    code: 'BIDV',
    shortName: 'BIDV',
    fullName: 'Ngân hàng TMCP Đầu tư và Phát triển Việt Nam',
    assetPath: '$_paymentAssets/bidv.png',
  ),
  _Bank(
    code: 'MB',
    shortName: 'MB',
    fullName: 'Ngân hàng TMCP Quân đội',
    assetPath: '$_paymentAssets/mb.png',
  ),
  _Bank(
    code: 'VIB',
    shortName: 'VIB',
    fullName: 'Ngân hàng TMCP Quốc tế Việt Nam',
    assetPath: '$_paymentAssets/vib.png',
  ),
  _Bank(
    code: 'ACB',
    shortName: 'ACB',
    fullName: 'Ngân hàng TMCP Á Châu',
    assetPath: '$_paymentAssets/acb.png',
  ),
  _Bank(
    code: 'TPB',
    shortName: 'TPBank',
    fullName: 'Ngân hàng TMCP Tiên Phong',
    assetPath: '$_paymentAssets/tpbank.png',
  ),
  _Bank(
    code: 'VPB',
    shortName: 'VPBank',
    fullName: 'Ngân hàng TMCP Việt Nam Thịnh Vượng',
    assetPath: '$_paymentAssets/vpbank.png',
  ),
  _Bank(
    code: 'OCB',
    shortName: 'OCB',
    fullName: 'Ngân hàng TMCP Phương Đông',
    assetPath: '$_paymentAssets/ocb.png',
  ),
  _Bank(
    code: 'HDB',
    shortName: 'HDBank',
    fullName: 'Ngân hàng TMCP Phát triển TP. HCM',
    assetPath: '$_paymentAssets/hdbank.png',
  ),
  _Bank(
    code: 'MSB',
    shortName: 'MSB',
    fullName: 'Ngân hàng TMCP Hàng Hải Việt Nam',
    assetPath: '$_paymentAssets/msb.png',
  ),
  _Bank(
    code: 'STB',
    shortName: 'Sacombank',
    fullName: 'Ngân hàng TMCP Sài Gòn Thương Tín',
    assetPath: '$_paymentAssets/sacombank.png',
  ),
];

String _formatAmount(int amount) {
  final digits = amount.toString();
  final result = StringBuffer();
  for (var index = 0; index < digits.length; index++) {
    if (index > 0 && (digits.length - index) % 3 == 0) result.write('.');
    result.write(digits[index]);
  }
  return result.toString();
}
