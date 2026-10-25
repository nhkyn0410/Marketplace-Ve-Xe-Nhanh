import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:passenger_mobile/features/account/account_settings_header.dart';

const _primary = Color(0xFF005EF3);
const _ink = Color(0xFF0B102A);
const _muted = Color(0xFF737D96);
const _background = Color(0xFFF7FBFF);
const _assetRoot = 'assets/account/vouchers';

typedef VoucherWalletLoader = Future<List<VoucherWalletItem>> Function();
typedef VoucherCodeSaver = Future<bool> Function(String promotionCode);

enum VoucherDiscountType { percent, amount }

enum VoucherSource { loyaltyRedemption, savedPromotion }

enum VoucherArtwork { star, route, gift }

class VoucherWalletItem {
  const VoucherWalletItem({
    required this.id,
    required this.name,
    required this.discountType,
    required this.discountValue,
    required this.minOrder,
    required this.expiresAt,
    required this.source,
    this.maxDiscount,
    this.promotionCode,
    this.displayValue,
    this.conditionLabel,
    this.artwork,
  });

  final String id;
  final String name;
  final VoucherDiscountType discountType;
  final String discountValue;
  final String minOrder;
  final String? maxDiscount;
  final DateTime expiresAt;
  final VoucherSource source;
  final String? promotionCode;
  final String? displayValue;
  final String? conditionLabel;
  final VoucherArtwork? artwork;
}

final figmaVoucherSamples = <VoucherWalletItem>[
  VoucherWalletItem(
    id: 'figma-voucher-50k',
    name: 'Voucher đổi từ điểm VXN Plus',
    discountType: VoucherDiscountType.amount,
    discountValue: '50000',
    minOrder: '300000',
    expiresAt: DateTime(2026, 11, 30),
    source: VoucherSource.loyaltyRedemption,
    artwork: VoucherArtwork.star,
  ),
  VoucherWalletItem(
    id: 'figma-voucher-15-percent',
    name: 'Ưu đãi tuyến TP.HCM → Đà Lạt',
    discountType: VoucherDiscountType.percent,
    discountValue: '15',
    minOrder: '0',
    maxDiscount: '45000',
    expiresAt: DateTime(2026, 12, 12),
    source: VoucherSource.savedPromotion,
    artwork: VoucherArtwork.route,
  ),
  VoucherWalletItem(
    id: 'figma-voucher-service-fee',
    name: 'Áp dụng cho 1 đơn bất kỳ',
    discountType: VoucherDiscountType.amount,
    discountValue: '0',
    minOrder: '0',
    expiresAt: DateTime(2027, 1, 5),
    source: VoucherSource.loyaltyRedemption,
    displayValue: 'Miễn phí dịch vụ',
    conditionLabel: '',
    artwork: VoucherArtwork.gift,
  ),
];

class VoucherWalletScreen extends StatefulWidget {
  const VoucherWalletScreen({
    required this.loadVouchers,
    required this.saveVoucherCode,
    required this.onBack,
    this.errorMessage,
    this.onCodeChanged,
    super.key,
  });

  final VoucherWalletLoader loadVouchers;
  final VoucherCodeSaver saveVoucherCode;
  final VoidCallback onBack;
  final String? errorMessage;
  final VoidCallback? onCodeChanged;

  @override
  State<VoucherWalletScreen> createState() => _VoucherWalletScreenState();
}

class _VoucherWalletScreenState extends State<VoucherWalletScreen> {
  final _codeController = TextEditingController();
  late Future<List<VoucherWalletItem>> _vouchers = widget.loadVouchers();
  bool _saving = false;
  String? _validationMessage;

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  Future<void> _reload() async {
    final next = widget.loadVouchers();
    setState(() {
      _vouchers = next;
    });
    await next;
  }

  Future<void> _saveCode() async {
    if (_saving) return;
    final code = _codeController.text.trim().toUpperCase();
    if (!RegExp(r'^[A-Z0-9]{3,20}$').hasMatch(code)) {
      setState(() {
        _validationMessage = 'Mã gồm 3–20 chữ cái in hoa hoặc chữ số.';
      });
      return;
    }
    setState(() {
      _saving = true;
      _validationMessage = null;
    });
    final saved = await widget.saveVoucherCode(code);
    if (!mounted) return;
    setState(() => _saving = false);
    if (!saved) return;
    _codeController.clear();
    await _reload();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        key: const Key('voucher-wallet-screen'),
        backgroundColor: _background,
        body: SafeArea(
          child: Column(
            children: [
              AccountSettingsHeader(
                title: 'Ví voucher',
                onBack: widget.onBack,
                backKey: const Key('voucher-wallet-back'),
              ),
              Expanded(
                child: FutureBuilder<List<VoucherWalletItem>>(
                  future: _vouchers,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState != ConnectionState.done) {
                      return const Center(
                        key: Key('voucher-wallet-loading'),
                        child: CircularProgressIndicator(color: _primary),
                      );
                    }
                    if (snapshot.hasError || !snapshot.hasData) {
                      return _LoadError(onRetry: _reload);
                    }
                    final vouchers = snapshot.requireData;
                    return RefreshIndicator(
                      color: _primary,
                      onRefresh: _reload,
                      child: ListView(
                        key: const Key('voucher-wallet-scroll'),
                        physics: const AlwaysScrollableScrollPhysics(),
                        padding: const EdgeInsets.fromLTRB(14, 12, 14, 24),
                        children: [
                          _VoucherCodeBox(
                            controller: _codeController,
                            saving: _saving,
                            validationMessage: _validationMessage,
                            apiMessage: widget.errorMessage,
                            onChanged: (_) {
                              if (_validationMessage != null) {
                                setState(() => _validationMessage = null);
                              }
                              widget.onCodeChanged?.call();
                            },
                            onSave: _saveCode,
                          ),
                          const SizedBox(height: 18),
                          if (vouchers.isEmpty)
                            const _VoucherEmpty()
                          else ...[
                            Padding(
                              padding: const EdgeInsets.only(left: 3),
                              child: Text.rich(
                                key: const Key('voucher-wallet-count'),
                                TextSpan(
                                  style: const TextStyle(
                                    color: _ink,
                                    fontSize: 15,
                                    height: 1.4,
                                  ),
                                  children: [
                                    const TextSpan(text: 'Đang có '),
                                    TextSpan(
                                      text: '${vouchers.length} voucher',
                                      style: const TextStyle(
                                        color: _primary,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    const TextSpan(text: ' khả dụng'),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
                            for (
                              var index = 0;
                              index < vouchers.length;
                              index++
                            ) ...[
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 2,
                                ),
                                child: VoucherCard(voucher: vouchers[index]),
                              ),
                              if (index != vouchers.length - 1)
                                const SizedBox(height: 12),
                            ],
                          ],
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class VoucherCard extends StatelessWidget {
  const VoucherCard({required this.voucher, super.key});

  final VoucherWalletItem voucher;

  @override
  Widget build(BuildContext context) {
    final artwork =
        voucher.artwork ??
        (voucher.source == VoucherSource.loyaltyRedemption
            ? VoucherArtwork.star
            : VoucherArtwork.route);
    return SizedBox(
      key: Key('voucher-card-${voucher.id}'),
      height: 166,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x0D425B7B),
                    blurRadius: 7,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            right: 0,
            top: 0,
            width: 132,
            height: 148,
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(14),
                bottomLeft: Radius.circular(24),
              ),
              child: _VoucherArtwork(artwork: artwork),
            ),
          ),
          Positioned.fill(
            child: SvgPicture.asset(
              '$_assetRoot/voucher_surface.svg',
              fit: BoxFit.fill,
            ),
          ),
          Positioned(
            left: 16,
            top: 12,
            child: Container(
              height: 23,
              padding: const EdgeInsets.symmetric(horizontal: 7),
              decoration: BoxDecoration(
                color: const Color(0xFFE0FAEB),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SvgPicture.asset(
                    '$_assetRoot/check.svg',
                    width: 14,
                    height: 14,
                  ),
                  const SizedBox(width: 5),
                  const Text(
                    'Khả dụng',
                    style: TextStyle(
                      color: Color(0xFF007C50),
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            left: 17,
            right: 130,
            top: 43,
            child: Text(
              voucher.displayValue ?? _discountLabel(voucher),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: _primary,
                fontSize: voucher.displayValue == null ? 29 : 26,
                height: 1.35,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Positioned(
            left: 17,
            right: 130,
            top: 82,
            child: Text(
              voucher.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: _ink,
                fontSize: 14,
                height: 1.4,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          if (_conditionLabel(voucher).isNotEmpty)
            Positioned(
              left: 17,
              right: 150,
              top: 105,
              child: Text(
                _conditionLabel(voucher),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: _muted,
                  fontSize: 12,
                  height: 1.4,
                ),
              ),
            ),
          Positioned(
            left: 17,
            right: 19,
            top: 129,
            child: SvgPicture.asset(
              '$_assetRoot/divider.svg',
              fit: BoxFit.fill,
            ),
          ),
          Positioned(
            left: 17,
            right: 17,
            top: 136,
            height: 24,
            child: Row(
              children: [
                SvgPicture.asset(
                  '$_assetRoot/calendar.svg',
                  width: 16,
                  height: 18,
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    'Hạn dùng: ${_formatDate(voucher.expiresAt)}',
                    style: const TextStyle(color: _muted, fontSize: 11.5),
                  ),
                ),
                const Text(
                  'Xem điều kiện ›',
                  style: TextStyle(
                    color: _primary,
                    fontSize: 11.5,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            left: -10,
            top: 61,
            child: SvgPicture.asset('$_assetRoot/notch.svg'),
          ),
          Positioned(
            right: -10,
            top: 61,
            child: SvgPicture.asset('$_assetRoot/notch.svg'),
          ),
        ],
      ),
    );
  }
}

class _VoucherArtwork extends StatelessWidget {
  const _VoucherArtwork({required this.artwork});
  final VoucherArtwork artwork;

  @override
  Widget build(BuildContext context) {
    if (artwork == VoucherArtwork.route) {
      return Image.asset('$_assetRoot/route.png', fit: BoxFit.cover);
    }
    return ColoredBox(
      color: const Color(0xFFEAF3FF),
      child: Align(
        alignment: Alignment.topRight,
        child: SvgPicture.asset(
          artwork == VoucherArtwork.star
              ? '$_assetRoot/voucher_star.svg'
              : '$_assetRoot/voucher_gift.svg',
          width: 108,
          height: 113,
        ),
      ),
    );
  }
}

class _VoucherCodeBox extends StatelessWidget {
  const _VoucherCodeBox({
    required this.controller,
    required this.saving,
    required this.validationMessage,
    required this.apiMessage,
    required this.onChanged,
    required this.onSave,
  });

  final TextEditingController controller;
  final bool saving;
  final String? validationMessage;
  final String? apiMessage;
  final ValueChanged<String> onChanged;
  final VoidCallback onSave;

  @override
  Widget build(BuildContext context) {
    final message = validationMessage ?? apiMessage;
    return Container(
      key: const Key('voucher-code-box'),
      padding: EdgeInsets.fromLTRB(9, 15, 9, message == null ? 15 : 8),
      decoration: BoxDecoration(
        color: const Color(0xFFEAF4FF),
        border: Border.all(color: const Color(0xFFD6E9FF)),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 52,
            padding: const EdgeInsets.only(left: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                SvgPicture.asset(
                  '$_assetRoot/ticket.svg',
                  width: 24,
                  height: 24,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: SizedBox(
                    height: 38,
                    child: TextField(
                      key: const Key('voucher-code-input'),
                      controller: controller,
                      enabled: !saving,
                      textCapitalization: TextCapitalization.characters,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                          RegExp('[A-Za-z0-9]'),
                        ),
                        LengthLimitingTextInputFormatter(20),
                      ],
                      onChanged: onChanged,
                      onSubmitted: (_) => onSave(),
                      style: const TextStyle(fontSize: 13),
                      decoration: InputDecoration(
                        hintText: 'Nhập mã khuyến mãi',
                        hintStyle: const TextStyle(
                          color: Color(0xFF9AA1B2),
                          fontSize: 13,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 9,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(
                            color: Color(0xFFE0E4ED),
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(
                            color: Color(0xFFE0E4ED),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(color: _primary),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                SizedBox(
                  width: 98,
                  height: 50,
                  child: FilledButton(
                    key: const Key('voucher-code-save'),
                    onPressed: saving ? null : onSave,
                    style: FilledButton.styleFrom(
                      padding: EdgeInsets.zero,
                      backgroundColor: const Color(0xFF58B3E9),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(11),
                      ),
                    ),
                    child: saving
                        ? const SizedBox.square(
                            dimension: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Text(
                            'Lưu mã',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ),
          if (message != null) ...[
            const SizedBox(height: 6),
            Padding(
              padding: const EdgeInsets.only(left: 12),
              child: Text(
                message,
                key: const Key('voucher-code-error'),
                style: const TextStyle(
                  color: Color(0xFFB42318),
                  fontSize: 10.5,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _VoucherEmpty extends StatelessWidget {
  const _VoucherEmpty();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      key: Key('voucher-wallet-empty'),
      padding: EdgeInsets.only(top: 72),
      child: Column(
        children: [
          CircleAvatar(
            radius: 46,
            backgroundColor: Color(0xFFEAF5FF),
            child: Icon(
              Icons.confirmation_number_outlined,
              color: _primary,
              size: 46,
            ),
          ),
          SizedBox(height: 18),
          Text(
            'Chưa có voucher',
            style: TextStyle(
              color: _ink,
              fontSize: 17,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 7),
          Text(
            'Voucher đã lưu hoặc đổi từ điểm VXN Plus\nsẽ xuất hiện tại đây.',
            textAlign: TextAlign.center,
            style: TextStyle(color: _muted, fontSize: 12, height: 1.55),
          ),
        ],
      ),
    );
  }
}

class _LoadError extends StatelessWidget {
  const _LoadError({required this.onRetry});
  final Future<void> Function() onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('Chưa thể tải ví voucher.'),
          const SizedBox(height: 10),
          OutlinedButton(onPressed: onRetry, child: const Text('Thử lại')),
        ],
      ),
    );
  }
}

String _discountLabel(VoucherWalletItem voucher) {
  if (voucher.discountType == VoucherDiscountType.percent) {
    return 'Giảm ${voucher.discountValue}%';
  }
  return '${_formatVnd(voucher.discountValue)}đ';
}

String _conditionLabel(VoucherWalletItem voucher) {
  final explicit = voucher.conditionLabel;
  if (explicit != null) return explicit;
  final minimum = BigInt.tryParse(voucher.minOrder) ?? BigInt.zero;
  if (minimum > BigInt.zero) {
    return 'Đơn tối thiểu ${_formatVnd(voucher.minOrder)}đ';
  }
  final maximum = voucher.maxDiscount;
  if (maximum != null && BigInt.tryParse(maximum) != BigInt.zero) {
    return 'Tối đa ${_formatVnd(maximum)}đ';
  }
  return 'Áp dụng cho 1 đơn bất kỳ';
}

String _formatVnd(String value) {
  final digits = value.replaceAll(RegExp(r'[^0-9-]'), '');
  if (digits.isEmpty) return value;
  final negative = digits.startsWith('-');
  final absolute = negative ? digits.substring(1) : digits;
  final parts = <String>[];
  for (var end = absolute.length; end > 0; end -= 3) {
    final start = end - 3 < 0 ? 0 : end - 3;
    parts.add(absolute.substring(start, end));
  }
  final formatted = parts.reversed.join('.');
  return negative ? '-$formatted' : formatted;
}

String _formatDate(DateTime value) {
  final local = value.toLocal();
  String two(int number) => number.toString().padLeft(2, '0');
  return '${two(local.day)}/${two(local.month)}/${local.year}';
}
