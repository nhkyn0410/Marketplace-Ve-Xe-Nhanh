import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

const _primary = Color(0xFF1265F5);
const _ink = Color(0xFF0D173B);
const _muted = Color(0xFF607A98);
const _background = Color(0xFFF7FBFF);
const _assetRoot = 'assets/account/vouchers';

typedef VoucherWalletLoader = Future<List<VoucherWalletItem>> Function();
typedef VoucherCodeSaver = Future<bool> Function(String promotionCode);

enum VoucherDiscountType { percent, amount }

enum VoucherSource { loyaltyRedemption, savedPromotion }

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
}

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
              _SubpageHeader(title: 'Ví voucher', onBack: widget.onBack),
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
                    return RefreshIndicator(
                      color: _primary,
                      onRefresh: _reload,
                      child: ListView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        padding: const EdgeInsets.fromLTRB(16, 12, 16, 28),
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
                          const SizedBox(height: 22),
                          if (snapshot.requireData.isEmpty)
                            const _VoucherEmpty()
                          else ...[
                            Text(
                              'Đang có ${snapshot.requireData.length} voucher khả dụng',
                              key: const Key('voucher-wallet-count'),
                              style: const TextStyle(
                                color: _ink,
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 12),
                            for (final voucher in snapshot.requireData) ...[
                              VoucherCard(voucher: voucher),
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
    final isLoyalty = voucher.source == VoucherSource.loyaltyRedemption;
    return Container(
      key: Key('voucher-card-${voucher.id}'),
      height: 166,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE4EDF6)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0D12395B),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          SizedBox(
            width: 112,
            height: double.infinity,
            child: isLoyalty
                ? Container(
                    color: const Color(0xFFEAF3FF),
                    alignment: Alignment.center,
                    child: SvgPicture.asset(
                      '$_assetRoot/voucher_gift.svg',
                      width: 92,
                      height: 100,
                    ),
                  )
                : Image.asset('$_assetRoot/route.png', fit: BoxFit.cover),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(14, 13, 12, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          _discountLabel(voucher),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: _primary,
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      SvgPicture.asset(
                        '$_assetRoot/voucher_star.svg',
                        width: 14,
                        height: 14,
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Text(
                    voucher.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: _ink,
                      fontSize: 13,
                      height: 1.35,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _conditionLabel(voucher),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: _muted, fontSize: 11),
                  ),
                  const Spacer(),
                  const Divider(height: 1, color: Color(0xFFE8EFF6)),
                  const SizedBox(height: 9),
                  Row(
                    children: [
                      const Icon(
                        Icons.calendar_today_outlined,
                        size: 14,
                        color: _muted,
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          'HSD: ${_formatDate(voucher.expiresAt)}',
                          style: const TextStyle(color: _muted, fontSize: 10.5),
                        ),
                      ),
                      if (voucher.promotionCode != null)
                        Text(
                          voucher.promotionCode!,
                          style: const TextStyle(
                            color: _primary,
                            fontSize: 10.5,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                    ],
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
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFEAF5FF),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SvgPicture.asset('$_assetRoot/ticket.svg', width: 24, height: 24),
              const SizedBox(width: 8),
              const Text(
                'Lưu mã voucher',
                style: TextStyle(
                  color: _ink,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 11),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: TextField(
                  key: const Key('voucher-code-input'),
                  controller: controller,
                  enabled: !saving,
                  textCapitalization: TextCapitalization.characters,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp('[A-Za-z0-9]')),
                    LengthLimitingTextInputFormatter(20),
                  ],
                  onChanged: onChanged,
                  onSubmitted: (_) => onSave(),
                  decoration: InputDecoration(
                    hintText: 'Nhập mã khuyến mãi',
                    hintStyle: const TextStyle(color: Color(0xFF8DA2B8)),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 13,
                      vertical: 12,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Color(0xFFD8E7F4)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: _primary),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 9),
              SizedBox(
                height: 48,
                child: FilledButton(
                  key: const Key('voucher-code-save'),
                  onPressed: saving ? null : onSave,
                  style: FilledButton.styleFrom(
                    backgroundColor: _primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
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
                      : const Text('Lưu mã'),
                ),
              ),
            ],
          ),
          if (message != null) ...[
            const SizedBox(height: 7),
            Text(
              message,
              key: const Key('voucher-code-error'),
              style: const TextStyle(color: Color(0xFFB42318), fontSize: 11),
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

class _SubpageHeader extends StatelessWidget {
  const _SubpageHeader({required this.title, required this.onBack});

  final String title;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 64,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            left: 16,
            child: IconButton(
              key: const Key('voucher-wallet-back'),
              onPressed: onBack,
              icon: const Icon(Icons.arrow_back_rounded, color: _ink),
            ),
          ),
          Text(
            title,
            style: const TextStyle(
              color: _ink,
              fontSize: 22,
              fontWeight: FontWeight.w600,
            ),
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
