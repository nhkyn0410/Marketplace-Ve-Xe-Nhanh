import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mobile_shared/mobile_shared.dart';
import 'package:passenger_mobile/features/account/account_settings_header.dart';

const _primary = Color(0xFF1E91C9);
const _primaryDark = Color(0xFF126993);
const _ink = Color(0xFF0D183C);
const _muted = Color(0xFF657E9E);
const _background = Color(0xFFF7FBFF);
const _border = Color(0xFFE2ECF7);
const _amber = Color(0xFFFFC53D);
const _amberInk = Color(0xFF714D00);
const _danger = Color(0xFFB42318);

/// Trần số điểm của một lần đổi theo API (`LoyaltyRedemptionInputSchema`).
const loyaltyRedeemLimit = 1000000;

/// Tải thẻ thành viên VXN Plus của hành khách đang đăng nhập.
typedef LoyaltyProgressLoader = Future<LoyaltyProgress> Function();

/// Đổi điểm lấy voucher; lỗi API ném ra dạng `ApiFailure`.
typedef LoyaltyPointsRedeemer =
    Future<RedeemedLoyaltyVoucher> Function(int points, String idempotencyKey);

/// Mốc điểm và hệ số tích điểm của một hạng.
class LoyaltyTierRule {
  const LoyaltyTierRule({
    required this.tier,
    required this.minPoints,
    required this.multiplierPercent,
  });

  /// `BRONZE`, `SILVER`, `GOLD`, `PLATINUM`.
  final String tier;
  final int minPoints;
  final int multiplierPercent;
}

/// Tham số chương trình VXN Plus đang áp dụng (Admin cấu hình, FR-LOY-10).
class LoyaltyProgramRules {
  const LoyaltyProgramRules({
    required this.earnUnit,
    required this.pointValue,
    required this.minRedeemPoints,
    required this.pointExpiryMonths,
    required this.voucherValidityDays,
    required this.tiers,
  });

  /// Số tiền (VND) để tính một đơn vị điểm.
  final int earnUnit;

  /// Giá trị (VND) của một điểm khi đổi.
  final int pointValue;
  final int minRedeemPoints;
  final int pointExpiryMonths;
  final int voucherValidityDays;
  final List<LoyaltyTierRule> tiers;
}

/// Hạng kế tiếp và số điểm còn thiếu để lên hạng.
class LoyaltyNextTier {
  const LoyaltyNextTier({
    required this.tier,
    required this.minPoints,
    required this.remaining,
  });

  final String tier;
  final int minPoints;
  final int remaining;
}

/// Thẻ thành viên VXN Plus (`GET /me/loyalty`); [rules] `null` = chương trình chưa áp dụng.
class LoyaltyProgress {
  const LoyaltyProgress({
    required this.accountActive,
    required this.availablePoints,
    required this.earned12m,
    required this.tier,
    this.nextTier,
    this.rules,
  });

  final bool accountActive;
  final int availablePoints;
  final int earned12m;
  final String tier;
  final LoyaltyNextTier? nextTier;
  final LoyaltyProgramRules? rules;
}

/// Voucher vừa nhận sau khi đổi điểm.
class RedeemedLoyaltyVoucher {
  const RedeemedLoyaltyVoucher({
    required this.discountAmount,
    required this.expiresAt,
  });

  /// VND.
  final int discountAmount;
  final DateTime expiresAt;
}

/// Quản lý điểm thưởng VXN Plus: hạng, điểm khả dụng, đổi điểm lấy voucher và
/// bảng hạng (SCR-PSG-33/35, FR-LOY-04, FR-LOY-06).
class LoyaltyScreen extends StatefulWidget {
  const LoyaltyScreen({
    required this.loadProgress,
    required this.redeemPoints,
    required this.onBack,
    required this.onPointHistory,
    required this.onVoucherWallet,
    this.onFindTrips,
    this.now,
    super.key,
  });

  final LoyaltyProgressLoader loadProgress;
  final LoyaltyPointsRedeemer redeemPoints;
  final VoidCallback onBack;
  final VoidCallback onPointHistory;
  final VoidCallback onVoucherWallet;
  final VoidCallback? onFindTrips;
  final DateTime Function()? now;

  @override
  State<LoyaltyScreen> createState() => _LoyaltyScreenState();
}

class _LoyaltyScreenState extends State<LoyaltyScreen> {
  late Future<LoyaltyProgress> _progress = widget.loadProgress();

  Future<void> _reload() async {
    final next = widget.loadProgress();
    setState(() {
      _progress = next;
    });
    await next;
  }

  Future<void> _openRedeem(LoyaltyProgress progress) async {
    final openWallet = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      enableDrag: false,
      backgroundColor: Colors.transparent,
      barrierColor: const Color(0x7A131C24),
      builder: (_) => _RedeemSheet(
        availablePoints: progress.availablePoints,
        rules: progress.rules!,
        redeem: widget.redeemPoints,
        onRedeemed: () {
          if (mounted) _reload().ignore();
        },
        now: widget.now ?? DateTime.now,
      ),
    );
    if (openWallet == true && mounted) widget.onVoucherWallet();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        key: const Key('loyalty-screen'),
        backgroundColor: _background,
        body: SafeArea(
          child: Column(
            children: [
              AccountSettingsHeader(
                title: 'VXN Plus',
                onBack: widget.onBack,
                backKey: const Key('loyalty-back'),
              ),
              Expanded(
                child: FutureBuilder<LoyaltyProgress>(
                  future: _progress,
                  builder: (context, snapshot) {
                    final data = snapshot.data;
                    if (data == null) {
                      if (snapshot.connectionState != ConnectionState.done) {
                        return const Center(
                          child: CircularProgressIndicator(
                            key: Key('loyalty-loading'),
                            color: _primary,
                          ),
                        );
                      }
                      return _LoadError(onRetry: _reload);
                    }
                    return RefreshIndicator(
                      color: _primary,
                      onRefresh: _reload,
                      child: ListView(
                        key: const Key('loyalty-scroll'),
                        physics: const AlwaysScrollableScrollPhysics(),
                        padding: const EdgeInsets.fromLTRB(14, 0, 14, 28),
                        children: [
                          _TierCard(progress: data),
                          const SizedBox(height: 12),
                          _PointsCard(
                            progress: data,
                            onRedeem: () => _openRedeem(data),
                            onPointHistory: widget.onPointHistory,
                            onVoucherWallet: widget.onVoucherWallet,
                          ),
                          if (data.availablePoints == 0 &&
                              data.earned12m == 0 &&
                              widget.onFindTrips != null) ...[
                            const SizedBox(height: 12),
                            _NewMemberCard(onFindTrips: widget.onFindTrips!),
                          ],
                          const SizedBox(height: 12),
                          _TierTable(progress: data),
                          const SizedBox(height: 12),
                          _ProgramRules(rules: data.rules),
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

String _tierName(String tier) => switch (tier) {
  'SILVER' => 'Bạc',
  'GOLD' => 'Vàng',
  'PLATINUM' => 'Bạch kim',
  _ => 'Đồng',
};

Color _tierColor(String tier) => switch (tier) {
  'SILVER' => const Color(0xFF64748B),
  'GOLD' => const Color(0xFFE89B26),
  'PLATINUM' => _ink,
  _ => const Color(0xFFB45309),
};

/// `120` → `×1,2`; `125` → `×1,25`; `200` → `×2,0`.
String _multiplier(int percent) {
  final fraction = percent % 100;
  final digits = fraction % 10 == 0
      ? '${fraction ~/ 10}'
      : fraction.toString().padLeft(2, '0');
  return '×${percent ~/ 100},$digits';
}

String _formatPoints(int value) => formatVnd(value, withSymbol: false);

/// Ngày theo giờ Việt Nam: `07/11/2026`.
String _vnDay(DateTime value) {
  final vn = value.toUtc().add(const Duration(hours: 7));
  String two(int part) => part.toString().padLeft(2, '0');
  return '${two(vn.day)}/${two(vn.month)}/${vn.year}';
}

LoyaltyTierRule? _ruleFor(LoyaltyProgramRules? rules, String? tier) {
  if (rules == null || tier == null) return null;
  for (final rule in rules.tiers) {
    if (rule.tier == tier) return rule;
  }
  return null;
}

class _TierCard extends StatelessWidget {
  const _TierCard({required this.progress});

  final LoyaltyProgress progress;

  @override
  Widget build(BuildContext context) {
    final current = _ruleFor(progress.rules, progress.tier);
    final next = progress.nextTier;
    final nextRule = _ruleFor(progress.rules, next?.tier);
    final ratio = next == null || next.minPoints <= 0
        ? 0.0
        : (progress.earned12m / next.minPoints).clamp(0.0, 1.0);
    final earned = _formatPoints(progress.earned12m);
    return Container(
      key: const Key('loyalty-tier-card'),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF248DB8), _primaryDark],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'VXN PLUS · THÀNH VIÊN',
            style: TextStyle(
              color: Colors.white.withValues(alpha: .78),
              fontSize: 11,
              letterSpacing: .3,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.workspace_premium_rounded,
                  color: _primaryDark,
                  size: 26,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Hạng ${_tierName(progress.tier)}',
                  key: const Key('loyalty-tier-name'),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              if (current != null)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 9,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: .22),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'Hệ số ${_multiplier(current.multiplierPercent)}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11.5,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            next == null
                ? 'Đã tích $earned điểm trong 12 tháng gần nhất'
                : 'Đã tích $earned / ${_formatPoints(next.minPoints)} điểm trong 12 tháng gần nhất',
            style: TextStyle(
              color: Colors.white.withValues(alpha: .92),
              fontSize: 12.5,
              height: 1.4,
            ),
          ),
          if (next != null) ...[
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                key: const Key('loyalty-tier-progress'),
                value: ratio,
                minHeight: 8,
                color: _amber,
                backgroundColor: Colors.white.withValues(alpha: .25),
              ),
            ),
          ],
          const SizedBox(height: 8),
          Text(
            next != null
                ? 'Cần thêm ${_formatPoints(next.remaining)} điểm để lên hạng ${_tierName(next.tier)}'
                      '${nextRule == null ? '' : ' (${_multiplier(nextRule.multiplierPercent)})'}'
                : progress.rules != null
                ? 'Bạn đang ở hạng thành viên cao nhất.'
                : 'Chính sách xét hạng đang được cập nhật.',
            key: const Key('loyalty-next-tier'),
            style: TextStyle(
              color: Colors.white.withValues(alpha: .88),
              fontSize: 12,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}

class _PointsCard extends StatelessWidget {
  const _PointsCard({
    required this.progress,
    required this.onRedeem,
    required this.onPointHistory,
    required this.onVoucherWallet,
  });

  final LoyaltyProgress progress;
  final VoidCallback onRedeem;
  final VoidCallback onPointHistory;
  final VoidCallback onVoucherWallet;

  @override
  Widget build(BuildContext context) {
    final rules = progress.rules;
    final canRedeem =
        progress.accountActive &&
        rules != null &&
        progress.availablePoints >= rules.minRedeemPoints;
    final hint = canRedeem
        ? null
        : !progress.accountActive
        ? 'Tài khoản hiện chưa thể đổi điểm.'
        : rules == null
        ? 'Chưa có chính sách đổi điểm đang áp dụng. Số dư điểm của bạn vẫn được giữ nguyên.'
        : 'Bạn cần ít nhất ${_formatPoints(rules.minRedeemPoints)} điểm để đổi voucher, '
              'còn thiếu ${_formatPoints(rules.minRedeemPoints - progress.availablePoints)} điểm.';
    return Container(
      key: const Key('loyalty-points-card'),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Điểm khả dụng',
                      style: TextStyle(color: _muted, fontSize: 13),
                    ),
                    const SizedBox(height: 2),
                    Text.rich(
                      TextSpan(
                        text: _formatPoints(progress.availablePoints),
                        style: const TextStyle(
                          color: _ink,
                          fontSize: 30,
                          height: 1.25,
                          fontWeight: FontWeight.w700,
                        ),
                        children: const [
                          TextSpan(
                            text: '  điểm',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      key: const Key('loyalty-available-points'),
                    ),
                    if (rules != null) ...[
                      const SizedBox(height: 3),
                      Text(
                        'Ước tính quy đổi ≈ ${formatVnd(progress.availablePoints * rules.pointValue)} voucher',
                        key: const Key('loyalty-estimated-value'),
                        style: const TextStyle(color: _muted, fontSize: 12.5),
                      ),
                    ],
                  ],
                ),
              ),
              ExcludeSemantics(
                child: SvgPicture.asset(
                  'assets/account/points/points_summary.svg',
                  width: 92,
                  height: 56,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 50,
            child: FilledButton(
              key: const Key('loyalty-redeem'),
              onPressed: canRedeem ? onRedeem : null,
              style: FilledButton.styleFrom(
                backgroundColor: _amber,
                foregroundColor: _amberInk,
                disabledBackgroundColor: const Color(0xFFF2E7C7),
                disabledForegroundColor: const Color(0xFFA08A55),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(13),
                ),
              ),
              child: const Text(
                'Đổi điểm lấy voucher',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
              ),
            ),
          ),
          if (hint != null) ...[
            const SizedBox(height: 8),
            Text(
              hint,
              key: const Key('loyalty-redeem-hint'),
              style: const TextStyle(
                color: _muted,
                fontSize: 12.5,
                height: 1.45,
              ),
            ),
          ],
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: _SecondaryButton(
                  key: const Key('loyalty-history'),
                  icon: Icons.history_rounded,
                  label: 'Lịch sử điểm',
                  onPressed: onPointHistory,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _SecondaryButton(
                  key: const Key('loyalty-vouchers'),
                  icon: Icons.confirmation_number_outlined,
                  label: 'Ví voucher',
                  onPressed: onVoucherWallet,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SecondaryButton extends StatelessWidget {
  const _SecondaryButton({
    required this.icon,
    required this.label,
    required this.onPressed,
    super.key,
  });

  final IconData icon;
  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: _primaryDark,
          side: const BorderSide(color: Color(0xFFD7E6F7)),
          padding: const EdgeInsets.symmetric(horizontal: 6),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 17),
              const SizedBox(width: 6),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Thành viên mới, chưa có điểm: giải thích cách tích điểm và mời tìm chuyến.
class _NewMemberCard extends StatelessWidget {
  const _NewMemberCard({required this.onFindTrips});

  final VoidCallback onFindTrips;

  @override
  Widget build(BuildContext context) {
    return Container(
      key: const Key('loyalty-new-member'),
      padding: const EdgeInsets.fromLTRB(14, 12, 8, 12),
      decoration: BoxDecoration(
        color: const Color(0xFFEAF6FC),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          const Expanded(
            child: Text(
              'Bạn sẽ được tích điểm sau mỗi chuyến đi hoàn thành.',
              style: TextStyle(color: _ink, fontSize: 13, height: 1.45),
            ),
          ),
          TextButton(
            key: const Key('loyalty-find-trips'),
            onPressed: onFindTrips,
            child: const Text('Tìm chuyến'),
          ),
        ],
      ),
    );
  }
}

class _TierTable extends StatelessWidget {
  const _TierTable({required this.progress});

  final LoyaltyProgress progress;

  @override
  Widget build(BuildContext context) {
    final tiers = progress.rules?.tiers ?? const <LoyaltyTierRule>[];
    return Container(
      key: const Key('loyalty-tier-table'),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(14, 14, 14, 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Bảng hạng thành viên',
                  style: TextStyle(
                    color: _ink,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 3),
                Text(
                  'Hạng xét theo tổng điểm tích trong 12 tháng gần nhất '
                  '(không trừ điểm đã đổi hoặc hết hạn).',
                  style: TextStyle(color: _muted, fontSize: 12.5, height: 1.45),
                ),
              ],
            ),
          ),
          if (tiers.isEmpty)
            const Padding(
              padding: EdgeInsets.fromLTRB(14, 0, 14, 14),
              child: Text(
                'Bảng hạng sẽ hiển thị khi chính sách thành viên được công bố.',
                style: TextStyle(color: _muted, fontSize: 13),
              ),
            )
          else ...[
            for (final tier in tiers)
              _TierRow(rule: tier, current: tier.tier == progress.tier),
            const Padding(
              padding: EdgeInsets.fromLTRB(14, 10, 14, 12),
              child: Text(
                'Ở phiên bản hiện tại, hạng chỉ quyết định hệ số tích điểm.',
                style: TextStyle(color: _muted, fontSize: 12, height: 1.45),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _TierRow extends StatelessWidget {
  const _TierRow({required this.rule, required this.current});

  final LoyaltyTierRule rule;
  final bool current;

  @override
  Widget build(BuildContext context) {
    return Container(
      key: Key('loyalty-tier-${rule.tier}'),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: current ? const Color(0xFFEAF6FC) : Colors.white,
        border: const Border(top: BorderSide(color: Color(0xFFEDF3F9))),
      ),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: _tierColor(rule.tier),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.workspace_premium_rounded,
              color: Colors.white,
              size: 17,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: 6,
                  runSpacing: 2,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Text(
                      _tierName(rule.tier),
                      style: const TextStyle(
                        color: _ink,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (current)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 1,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE0FAEB),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Text(
                          'Hạng của bạn',
                          style: TextStyle(
                            color: Color(0xFF007C50),
                            fontSize: 10.5,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 1),
                Text(
                  'Từ ${_formatPoints(rule.minPoints)} điểm',
                  style: const TextStyle(color: _muted, fontSize: 12),
                ),
              ],
            ),
          ),
          Text(
            _multiplier(rule.multiplierPercent),
            style: const TextStyle(
              color: _ink,
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _ProgramRules extends StatelessWidget {
  const _ProgramRules({required this.rules});

  final LoyaltyProgramRules? rules;

  @override
  Widget build(BuildContext context) {
    final value = rules;
    return Column(
      key: const Key('loyalty-program-rules'),
      children: [
        _RuleCard(
          icon: Icons.auto_awesome_rounded,
          color: _primaryDark,
          background: const Color(0xFFE4F6FE),
          title: 'Tích điểm sau mỗi chuyến',
          body: value == null
              ? 'Quy tắc tích điểm sẽ hiển thị khi có chính sách đang áp dụng.'
              : 'Mỗi ${formatVnd(value.earnUnit)} tiền vé đủ điều kiện được tính theo hệ số của hạng, sau khi chuyến hoàn thành.',
        ),
        const SizedBox(height: 10),
        _RuleCard(
          icon: Icons.card_giftcard_rounded,
          color: const Color(0xFF0E7490),
          background: const Color(0xFFE0F7FA),
          title: 'Đổi điểm lấy voucher',
          body: value == null
              ? 'Chưa có chính sách quy đổi đang áp dụng.'
              : 'Đổi từ ${_formatPoints(value.minRedeemPoints)} điểm, 1 điểm = ${formatVnd(value.pointValue)}. Voucher dùng được cho mọi tuyến, mọi nhà xe và có hạn ${value.voucherValidityDays} ngày.',
        ),
        const SizedBox(height: 10),
        _RuleCard(
          icon: Icons.schedule_rounded,
          color: const Color(0xFFB45309),
          background: const Color(0xFFFFF3DE),
          title: 'Điểm có hạn dùng',
          body: value == null
              ? 'Thời hạn điểm sẽ hiển thị cùng chính sách thành viên.'
              : 'Điểm có hạn ${value.pointExpiryMonths} tháng; điểm tích trước được dùng và hết hạn trước.',
        ),
      ],
    );
  }
}

class _RuleCard extends StatelessWidget {
  const _RuleCard({
    required this.icon,
    required this.color,
    required this.background,
    required this.title,
    required this.body,
  });

  final IconData icon;
  final Color color;
  final Color background;
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: background,
              borderRadius: BorderRadius.circular(11),
            ),
            child: Icon(icon, color: color, size: 19),
          ),
          const SizedBox(width: 11),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: _ink,
                    fontSize: 13.5,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  body,
                  style: const TextStyle(
                    color: _muted,
                    fontSize: 12.5,
                    height: 1.45,
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

/// Khóa `Idempotency-Key` theo định dạng API: 32 ký tự hex ngẫu nhiên.
String _newRedemptionKey() {
  final random = math.Random.secure();
  return List.generate(
    32,
    (_) => random.nextInt(16).toRadixString(16),
  ).join();
}

class _RedeemSheet extends StatefulWidget {
  const _RedeemSheet({
    required this.availablePoints,
    required this.rules,
    required this.redeem,
    required this.onRedeemed,
    required this.now,
  });

  final int availablePoints;
  final LoyaltyProgramRules rules;
  final LoyaltyPointsRedeemer redeem;
  final VoidCallback onRedeemed;
  final DateTime Function() now;

  @override
  State<_RedeemSheet> createState() => _RedeemSheetState();
}

class _RedeemSheetState extends State<_RedeemSheet> {
  late final TextEditingController _input = TextEditingController(
    text: '$_min',
  );

  /// Thử lại cùng số điểm phải dùng lại khóa cũ để API không đổi điểm lần hai
  /// (BR-71): lần trước có thể đã thành công nhưng mất phản hồi.
  ({int points, String key})? _request;
  ({RedeemedLoyaltyVoucher voucher, int points})? _result;
  bool _submitting = false;
  String? _error;

  int get _min => widget.rules.minRedeemPoints;
  int get _max => math.min(widget.availablePoints, loyaltyRedeemLimit);
  int? get _points => int.tryParse(_input.text);

  String? get _fieldError {
    final points = _points;
    if (points == null || points < _min) {
      return 'Số điểm đổi tối thiểu là ${_formatPoints(_min)} điểm.';
    }
    if (points > _max) {
      return 'Bạn chỉ có thể đổi tối đa ${_formatPoints(_max)} điểm.';
    }
    return null;
  }

  @override
  void dispose() {
    _input.dispose();
    super.dispose();
  }

  void _setPoints(int points) {
    _input.value = TextEditingValue(
      text: '$points',
      selection: TextSelection.collapsed(offset: '$points'.length),
    );
    setState(() => _error = null);
  }

  Future<void> _submit() async {
    final points = _points;
    if (_submitting || points == null || _fieldError != null) return;
    FocusScope.of(context).unfocus();
    final previous = _request;
    final request = previous != null && previous.points == points
        ? previous
        : (points: points, key: _newRedemptionKey());
    _request = request;
    setState(() {
      _submitting = true;
      _error = null;
    });
    try {
      final voucher = await widget.redeem(request.points, request.key);
      if (!mounted) return;
      setState(() {
        _submitting = false;
        _result = (voucher: voucher, points: request.points);
      });
      widget.onRedeemed();
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _submitting = false;
        _error = error is ApiFailure && !error.isNetworkError
            ? error.detail
            : 'Không thể kết nối máy chủ. Vui lòng kiểm tra mạng và thử lại.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final result = _result;
    return PopScope(
      canPop: !_submitting,
      child: AnimatedPadding(
        duration: const Duration(milliseconds: 180),
        padding: EdgeInsets.only(
          bottom: MediaQuery.viewInsetsOf(context).bottom,
        ),
        child: Container(
          key: const Key('loyalty-redeem-sheet'),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: SafeArea(
            top: false,
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(18, 12, 18, 16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(
                    child: Container(
                      width: 44,
                      height: 5,
                      decoration: BoxDecoration(
                        color: const Color(0xFFC4CDD7),
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          result == null
                              ? 'Đổi điểm lấy voucher'
                              : 'Đổi điểm thành công',
                          style: const TextStyle(
                            color: _ink,
                            fontSize: 19,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      IconButton(
                        key: const Key('loyalty-redeem-close'),
                        tooltip: 'Đóng',
                        onPressed: _submitting
                            ? null
                            : () => Navigator.of(context).pop(),
                        icon: const Icon(Icons.close_rounded, color: _muted),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  if (result == null) ..._form() else ..._success(result),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _form() {
    final points = _points;
    final fieldError = _fieldError;
    final valid = points != null && fieldError == null;
    final rules = widget.rules;
    final expiry = widget.now().add(Duration(days: rules.voucherValidityDays));
    final quick = <int>{
      _min,
      _min * 2,
      _min * 5,
    }.where((value) => value < _max).toList(growable: false);
    return [
      _SummaryBox(
        rows: [
          (
            'Điểm hiện có',
            '${_formatPoints(widget.availablePoints)} điểm',
            false,
          ),
          ('Giá trị quy đổi', '1 điểm = ${formatVnd(rules.pointValue)}', false),
          ('Số điểm đổi tối thiểu', '${_formatPoints(_min)} điểm', false),
        ],
      ),
      const SizedBox(height: 14),
      const Text(
        'Số điểm muốn đổi',
        style: TextStyle(
          color: _ink,
          fontSize: 13.5,
          fontWeight: FontWeight.w600,
        ),
      ),
      const SizedBox(height: 6),
      TextField(
        key: const Key('loyalty-redeem-input'),
        controller: _input,
        enabled: !_submitting,
        keyboardType: TextInputType.number,
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
          LengthLimitingTextInputFormatter(7),
        ],
        onChanged: (_) => setState(() => _error = null),
        style: const TextStyle(
          color: _ink,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
        decoration: InputDecoration(
          suffixText: 'điểm',
          suffixStyle: const TextStyle(color: _muted, fontSize: 13),
          errorText: fieldError,
          errorMaxLines: 2,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 12,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFFD9E2EE)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: _primary, width: 1.4),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: _danger),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: _danger, width: 1.4),
          ),
        ),
      ),
      const SizedBox(height: 10),
      Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          for (final value in quick)
            _QuickChip(
              key: Key('loyalty-quick-$value'),
              label: _formatPoints(value),
              selected: points == value,
              onTap: _submitting ? null : () => _setPoints(value),
            ),
          _QuickChip(
            key: const Key('loyalty-quick-all'),
            label: 'Tất cả',
            selected: points == _max,
            onTap: _submitting ? null : () => _setPoints(_max),
          ),
        ],
      ),
      if (_max > _min) ...[
        const SizedBox(height: 4),
        Slider(
          key: const Key('loyalty-redeem-slider'),
          value: (points ?? _min).clamp(_min, _max).toDouble(),
          min: _min.toDouble(),
          max: _max.toDouble(),
          activeColor: _primary,
          onChanged: _submitting
              ? null
              : (value) => _setPoints(value.round()),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _formatPoints(_min),
                style: const TextStyle(color: _muted, fontSize: 12),
              ),
              Text(
                _formatPoints(_max),
                style: const TextStyle(color: _muted, fontSize: 12),
              ),
            ],
          ),
        ),
      ],
      const SizedBox(height: 12),
      _SummaryBox(
        background: const Color(0xFFEAF6FC),
        rows: [
          (
            'Voucher nhận được',
            valid ? 'Giảm ${formatVnd(points * rules.pointValue)}' : '—',
            true,
          ),
          (
            'Điểm còn lại sau khi đổi',
            valid ? '${_formatPoints(widget.availablePoints - points)} điểm' : '—',
            false,
          ),
          (
            'Hạn dùng voucher',
            '${rules.voucherValidityDays} ngày · đến ${_vnDay(expiry)}',
            false,
          ),
        ],
      ),
      const SizedBox(height: 10),
      Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: const Color(0xFFFFF8E8),
          borderRadius: BorderRadius.circular(10),
        ),
        child: const Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              Icons.warning_amber_rounded,
              color: Color(0xFFB7791F),
              size: 18,
            ),
            SizedBox(width: 8),
            Expanded(
              child: Text(
                'Điểm đã đổi không hoàn lại. Voucher dùng cho mọi tuyến, mọi nhà xe; '
                'mỗi đơn áp dụng tối đa một voucher hoặc một mã.',
                style: TextStyle(color: _ink, fontSize: 12, height: 1.45),
              ),
            ),
          ],
        ),
      ),
      if (_error != null) ...[
        const SizedBox(height: 10),
        Text(
          _error!,
          key: const Key('loyalty-redeem-error'),
          style: const TextStyle(color: _danger, fontSize: 13, height: 1.45),
        ),
      ],
      const SizedBox(height: 14),
      Row(
        children: [
          Expanded(
            flex: 2,
            child: SizedBox(
              height: 52,
              child: OutlinedButton(
                key: const Key('loyalty-redeem-cancel'),
                onPressed: _submitting
                    ? null
                    : () => Navigator.of(context).pop(),
                style: OutlinedButton.styleFrom(
                  foregroundColor: _ink,
                  side: const BorderSide(color: Color(0xFFD9E2EE)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(13),
                  ),
                ),
                child: const Text(
                  'Hủy',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            flex: 5,
            child: SizedBox(
              height: 52,
              child: FilledButton(
                key: const Key('loyalty-redeem-confirm'),
                onPressed: valid && !_submitting ? _submit : null,
                style: FilledButton.styleFrom(
                  backgroundColor: _primaryDark,
                  disabledBackgroundColor: const Color(0xFFB9CED9),
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(13),
                  ),
                ),
                child: _submitting
                    ? const SizedBox.square(
                        dimension: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          valid
                              ? 'Xác nhận đổi ${_formatPoints(points)} điểm'
                              : 'Xác nhận đổi điểm',
                          maxLines: 1,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
              ),
            ),
          ),
        ],
      ),
    ];
  }

  List<Widget> _success(({RedeemedLoyaltyVoucher voucher, int points}) result) {
    return [
      const Center(
        child: CircleAvatar(
          radius: 34,
          backgroundColor: Color(0xFFE0FAEB),
          child: Icon(
            Icons.check_rounded,
            color: Color(0xFF007C50),
            size: 38,
          ),
        ),
      ),
      const SizedBox(height: 12),
      Text(
        'Voucher giảm ${formatVnd(result.voucher.discountAmount)} đã được lưu vào ví của bạn.',
        key: const Key('loyalty-redeem-success'),
        textAlign: TextAlign.center,
        style: const TextStyle(color: _ink, fontSize: 14, height: 1.5),
      ),
      const SizedBox(height: 12),
      _SummaryBox(
        background: const Color(0xFFEAF6FC),
        rows: [
          (
            'Voucher nhận được',
            'Giảm ${formatVnd(result.voucher.discountAmount)}',
            true,
          ),
          (
            'Điểm còn lại',
            '${_formatPoints(math.max(0, widget.availablePoints - result.points))} điểm',
            false,
          ),
          ('Hạn dùng voucher', 'Đến ${_vnDay(result.voucher.expiresAt)}', false),
        ],
      ),
      const SizedBox(height: 14),
      Row(
        children: [
          Expanded(
            flex: 2,
            child: SizedBox(
              height: 52,
              child: OutlinedButton(
                key: const Key('loyalty-redeem-done'),
                onPressed: () => Navigator.of(context).pop(),
                style: OutlinedButton.styleFrom(
                  foregroundColor: _ink,
                  side: const BorderSide(color: Color(0xFFD9E2EE)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(13),
                  ),
                ),
                child: const Text(
                  'Đóng',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            flex: 3,
            child: SizedBox(
              height: 52,
              child: FilledButton(
                key: const Key('loyalty-redeem-open-wallet'),
                onPressed: () => Navigator.of(context).pop(true),
                style: FilledButton.styleFrom(
                  backgroundColor: _primaryDark,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(13),
                  ),
                ),
                child: const Text(
                  'Xem ví voucher',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ),
        ],
      ),
    ];
  }
}

class _SummaryBox extends StatelessWidget {
  const _SummaryBox({
    required this.rows,
    this.background = const Color(0xFFF4F8FC),
  });

  /// Nhãn, giá trị, có nhấn mạnh giá trị không.
  final List<(String, String, bool)> rows;
  final Color background;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          for (var index = 0; index < rows.length; index++)
            Padding(
              padding: EdgeInsets.only(top: index == 0 ? 0 : 7),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      rows[index].$1,
                      style: const TextStyle(color: _muted, fontSize: 12.5),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      rows[index].$2,
                      textAlign: TextAlign.end,
                      style: TextStyle(
                        color: rows[index].$3 ? _primaryDark : _ink,
                        fontSize: rows[index].$3 ? 16 : 13,
                        fontWeight: FontWeight.w600,
                      ),
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

class _QuickChip extends StatelessWidget {
  const _QuickChip({
    required this.label,
    required this.selected,
    required this.onTap,
    super.key,
  });

  final String label;
  final bool selected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? const Color(0xFFEAF6FC) : Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(
          color: selected ? _primaryDark : const Color(0xFFD9E2EE),
          width: selected ? 1.4 : 1,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
          child: Text(
            label,
            style: TextStyle(
              color: selected ? _primaryDark : _ink,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
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
      child: Padding(
        key: const Key('loyalty-error'),
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.cloud_off_rounded, color: _primary, size: 48),
            const SizedBox(height: 14),
            const Text(
              'Chưa thể tải thông tin VXN Plus',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: _ink,
                fontSize: 17,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Vui lòng kiểm tra kết nối và thử lại.',
              textAlign: TextAlign.center,
              style: TextStyle(color: _muted, fontSize: 13),
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              key: const Key('loyalty-retry'),
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Thử lại'),
            ),
          ],
        ),
      ),
    );
  }
}
