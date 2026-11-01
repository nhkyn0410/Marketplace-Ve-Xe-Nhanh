import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

const _primary = Color(0xFF1E91C9);
const _ink = Color(0xFF0D183C);
const _muted = Color(0xFF657E9E);
const _background = Color(0xFFF7FBFF);
const _assetRoot = 'assets/account/points';

typedef PointHistoryLoader = Future<PointHistoryData> Function(
  PointHistoryQuery query,
);

enum PointTransactionKind { earn, redeem, expire, adjust, reversal }

enum PointTypeFilter { all, earn, redeem, expire }

enum PointDateFilter {
  all,
  currentMonth,
  previousMonth,
  threeMonths,
  sixMonths,
  custom,
}

class PointHistoryQuery {
  const PointHistoryQuery({
    this.type = PointTypeFilter.all,
    this.date = PointDateFilter.all,
  });

  final PointTypeFilter type;
  final PointDateFilter date;
}

class PointHistoryData {
  const PointHistoryData({
    required this.availablePoints,
    required this.earnedPoints,
    required this.redeemedPoints,
    required this.expiredPoints,
    required this.transactions,
  });

  final int availablePoints;
  final int earnedPoints;
  final int redeemedPoints;
  final int expiredPoints;
  final List<PointTransactionItem> transactions;
}

class PointTransactionItem {
  const PointTransactionItem({
    required this.id,
    required this.kind,
    required this.points,
    required this.title,
    required this.createdAt,
    this.detail,
    this.secondaryDetail,
    this.imageAsset,
    this.iconAsset,
  });

  final String id;
  final PointTransactionKind kind;
  final int points;
  final String title;
  final String? detail;
  final String? secondaryDetail;
  final DateTime createdAt;
  final String? imageAsset;
  final String? iconAsset;
}

final _figmaPointTransactions = <PointTransactionItem>[
  PointTransactionItem(
    id: 'figma-earn-october-1',
    kind: PointTransactionKind.earn,
    points: 250,
    title: 'Tích điểm chuyến đi',
    detail: 'TP.HCM → Đà Lạt',
    secondaryDetail: 'Đơn VXN-8F3K2Q • 16/10/2026',
    createdAt: DateTime(2026, 10, 16),
    imageAsset: '$_assetRoot/bus_1.png',
  ),
  PointTransactionItem(
    id: 'figma-redeem-october',
    kind: PointTransactionKind.redeem,
    points: -500,
    title: 'Đổi điểm lấy voucher',
    detail: 'Voucher giảm 50.000đ',
    secondaryDetail: '12/10/2026',
    createdAt: DateTime(2026, 10, 12),
    iconAsset: '$_assetRoot/redeem_october.svg',
  ),
  PointTransactionItem(
    id: 'figma-earn-october-2',
    kind: PointTransactionKind.earn,
    points: 150,
    title: 'Tích điểm chuyến đi',
    detail: 'Hà Nội → Thanh Hóa',
    secondaryDetail: 'Đơn VXN-2M7T9A • 05/10/2026',
    createdAt: DateTime(2026, 10, 5),
    imageAsset: '$_assetRoot/bus_2.png',
  ),
  PointTransactionItem(
    id: 'figma-expire-october',
    kind: PointTransactionKind.expire,
    points: -100,
    title: 'Điểm sắp hết hạn',
    detail: 'Điểm tích từ 03/2025',
    secondaryDetail: '30/10/2026',
    createdAt: DateTime(2026, 10, 1),
    iconAsset: '$_assetRoot/expire.svg',
  ),
  PointTransactionItem(
    id: 'figma-earn-september',
    kind: PointTransactionKind.earn,
    points: 200,
    title: 'Tích điểm chuyến đi',
    detail: 'Đà Nẵng → Huế',
    secondaryDetail: 'Đơn VXN-9K4L3P • 20/09/2026',
    createdAt: DateTime(2026, 9, 20),
    imageAsset: '$_assetRoot/bus_3.png',
  ),
  PointTransactionItem(
    id: 'figma-adjust-september',
    kind: PointTransactionKind.adjust,
    points: -50,
    title: 'Điều chỉnh điểm',
    detail: 'Điều chỉnh theo CSKH',
    secondaryDetail: '18/09/2026',
    createdAt: DateTime(2026, 9, 18),
    iconAsset: '$_assetRoot/adjust.svg',
  ),
  PointTransactionItem(
    id: 'figma-redeem-september',
    kind: PointTransactionKind.redeem,
    points: -300,
    title: 'Đổi điểm lấy voucher',
    detail: 'Voucher giảm 30.000đ',
    secondaryDetail: '12/09/2026',
    createdAt: DateTime(2026, 9, 12),
    iconAsset: '$_assetRoot/redeem_september.svg',
  ),
];

PointHistoryData figmaPointHistorySample([PointHistoryQuery? query]) {
  final selected = query ?? const PointHistoryQuery();
  final transactions = _figmaPointTransactions
      .where((item) {
        final typeMatches = switch (selected.type) {
          PointTypeFilter.all => true,
          PointTypeFilter.earn => item.kind == PointTransactionKind.earn,
          PointTypeFilter.redeem => item.kind == PointTransactionKind.redeem,
          PointTypeFilter.expire => item.kind == PointTransactionKind.expire,
        };
        return typeMatches && _matchesDate(item.createdAt, selected.date);
      })
      .toList(growable: false);
  return PointHistoryData(
    availablePoints: 1250,
    earnedPoints: 2000,
    redeemedPoints: 500,
    expiredPoints: 250,
    transactions: transactions,
  );
}

class PointHistoryScreen extends StatefulWidget {
  const PointHistoryScreen({
    required this.loadHistory,
    required this.onBack,
    this.onLearnMore,
    this.onRedeem,
    super.key,
  });

  final PointHistoryLoader loadHistory;
  final VoidCallback onBack;
  final VoidCallback? onLearnMore;

  /// Nút "Đổi điểm" ở đầu màn; `null` thì ẩn.
  final VoidCallback? onRedeem;

  @override
  State<PointHistoryScreen> createState() => _PointHistoryScreenState();
}

class _PointHistoryScreenState extends State<PointHistoryScreen> {
  PointHistoryQuery _query = const PointHistoryQuery();
  late Future<PointHistoryData> _history = widget.loadHistory(_query);

  Future<void> _reload() async {
    final next = widget.loadHistory(_query);
    setState(() {
      _history = next;
    });
    await next;
  }

  Future<void> _selectDate() async {
    final selected = await showModalBottomSheet<PointDateFilter>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _DateFilterSheet(selected: _query.date),
    );
    if (selected == null || selected == _query.date || !mounted) return;
    _query = PointHistoryQuery(type: _query.type, date: selected);
    await _reload();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        key: const Key('point-history-screen'),
        backgroundColor: _background,
        body: SafeArea(
          child: Column(
            children: [
              _HistoryHeader(onBack: widget.onBack, onRedeem: widget.onRedeem),
              Expanded(
                child: FutureBuilder<PointHistoryData>(
                  future: _history,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState != ConnectionState.done) {
                      return const Center(
                        key: Key('point-history-loading'),
                        child: CircularProgressIndicator(color: _primary),
                      );
                    }
                    if (snapshot.hasError || !snapshot.hasData) {
                      return _LoadError(onRetry: _reload);
                    }
                    final data = snapshot.requireData;
                    if (data.transactions.isEmpty &&
                        _query.type == PointTypeFilter.all &&
                        _query.date == PointDateFilter.all) {
                      return _PointHistoryEmpty(
                        onLearnMore: widget.onLearnMore,
                      );
                    }
                    return RefreshIndicator(
                      color: _primary,
                      onRefresh: _reload,
                      child: ListView(
                        key: const Key('point-history-scroll'),
                        physics: const AlwaysScrollableScrollPhysics(),
                        padding: const EdgeInsets.fromLTRB(16, 11, 16, 28),
                        children: [
                          _PointOverview(data: data),
                          const SizedBox(height: 13),
                          SizedBox(
                            height: 32,
                            child: Row(
                              children: [
                                const Expanded(
                                  child: Text(
                                    'Giao dịch điểm',
                                    style: TextStyle(
                                      color: _ink,
                                      fontSize: 17,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                OutlinedButton.icon(
                                  key: const Key('point-date-filter'),
                                  onPressed: _selectDate,
                                  icon: SvgPicture.asset(
                                    '$_assetRoot/calendar.svg',
                                    width: 16,
                                    height: 16,
                                  ),
                                  label: const Text('Lọc ngày ›'),
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: const Color(0xFF126BB1),
                                    side: const BorderSide(
                                      color: Color(0xFFD7E6F7),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 9,
                                    ),
                                    textStyle: const TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 25),
                          if (data.transactions.isEmpty)
                            const _FilteredEmpty()
                          else
                            ..._transactionGroups(data.transactions),
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

List<Widget> _transactionGroups(List<PointTransactionItem> items) {
  final groups = <String, List<PointTransactionItem>>{};
  for (final item in items) {
    groups.putIfAbsent(_monthLabel(item.createdAt), () => []).add(item);
  }
  final widgets = <Widget>[];
  var globalIndex = 0;
  for (final entry in groups.entries) {
    if (widgets.isNotEmpty) widgets.add(const SizedBox(height: 16));
    widgets.add(
      Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Text(
          entry.key,
          style: const TextStyle(
            color: Color(0xFF6C83A2),
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
    widgets.add(
      Container(
        key: Key('point-month-${entry.key}'),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: const Color(0xFFE4EDF7)),
        ),
        child: Column(
          children: [
            for (var index = 0; index < entry.value.length; index++) ...[
              _TransactionRow(
                item: entry.value[index],
                imageIndex: globalIndex++ % 3,
              ),
              if (index != entry.value.length - 1)
                const Divider(height: .5, color: Color(0xFFE2EAF4)),
            ],
          ],
        ),
      ),
    );
  }
  return widgets;
}

class _PointOverview extends StatelessWidget {
  const _PointOverview({required this.data});
  final PointHistoryData data;

  @override
  Widget build(BuildContext context) {
    return Container(
      key: const Key('point-history-overview'),
      height: 145,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2ECF7)),
      ),
      child: Stack(
        children: [
          const Positioned(
            left: 15,
            top: 11,
            child: Text(
              'Điểm khả dụng',
              style: TextStyle(
                color: Color(0xFF6B7E9B),
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Positioned(
            left: 15,
            top: 27,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  _formatPoints(data.availablePoints),
                  style: const TextStyle(
                    color: _ink,
                    fontSize: 33,
                    height: 1.45,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 12, bottom: 8),
                  child: Text(
                    'điểm',
                    style: TextStyle(
                      color: _ink,
                      fontSize: 17,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            right: 16,
            top: 0,
            child: SvgPicture.asset(
              '$_assetRoot/points_summary.svg',
              width: 140,
              height: 85,
            ),
          ),
          const Positioned(
            left: 15,
            right: 15,
            top: 74,
            child: Divider(height: 1, color: Color(0xFFE7EDF5)),
          ),
          Positioned(
            left: 15,
            right: 15,
            top: 87,
            child: Row(
              children: [
                _PointStat(
                  label: 'Đã tích',
                  value: data.earnedPoints,
                  asset: '$_assetRoot/stat_earn.svg',
                  background: Color(0xFFECFAF4),
                ),
                _PointStat(
                  label: 'Đã đổi',
                  value: data.redeemedPoints,
                  asset: '$_assetRoot/stat_redeem.svg',
                  background: Color(0xFFEEF7FF),
                ),
                _PointStat(
                  label: 'Hết hạn',
                  value: data.expiredPoints,
                  asset: '$_assetRoot/stat_expire.svg',
                  background: Color(0xFFFFF5EC),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PointStat extends StatelessWidget {
  const _PointStat({
    required this.label,
    required this.value,
    required this.asset,
    required this.background,
  });

  final String label;
  final int value;
  final String asset;
  final Color background;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Row(
        children: [
          Container(
            width: 30,
            height: 30,
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: background,
              borderRadius: BorderRadius.circular(15),
            ),
            child: SvgPicture.asset(asset),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  maxLines: 1,
                  style: const TextStyle(
                    color: Color(0xFF647C9C),
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  _formatPoints(value),
                  style: const TextStyle(
                    color: _ink,
                    fontSize: 16,
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

class _TransactionRow extends StatelessWidget {
  const _TransactionRow({required this.item, required this.imageIndex});
  final PointTransactionItem item;
  final int imageIndex;

  @override
  Widget build(BuildContext context) {
    final positive = item.points >= 0;
    return SizedBox(
      key: Key('point-transaction-${item.id}'),
      height: 66,
      child: Row(
        children: [
          _TransactionArtwork(item: item, imageIndex: imageIndex),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: _ink,
                    fontSize: 12,
                    height: 1.45,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  item.detail?.trim().isNotEmpty == true
                      ? item.detail!
                      : _kindLabel(item.kind),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: _muted, fontSize: 10),
                ),
                Text(
                  item.secondaryDetail ?? _formatDate(item.createdAt),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: _muted, fontSize: 10),
                ),
              ],
            ),
          ),
          SizedBox(
            width: 52,
            child: Text(
              '${positive ? '+' : '−'}${_formatPoints(item.points.abs())}',
              textAlign: TextAlign.right,
              style: TextStyle(
                color: positive ? const Color(0xFF008949) : _ink,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(width: 12),
          SizedBox(
            width: 12,
            height: 12,
            child: Center(
              child: SvgPicture.asset(
                '$_assetRoot/chevron.svg',
                key: Key('point-chevron-${item.id}'),
                width: 5.2,
                height: 8.7,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TransactionArtwork extends StatelessWidget {
  const _TransactionArtwork({required this.item, required this.imageIndex});
  final PointTransactionItem item;
  final int imageIndex;

  @override
  Widget build(BuildContext context) {
    final image = item.imageAsset;
    if (item.kind == PointTransactionKind.earn) {
      return ClipRRect(
        key: Key('point-artwork-${item.id}'),
        borderRadius: BorderRadius.circular(11),
        child: Image.asset(
          image ?? '$_assetRoot/bus_${imageIndex + 1}.png',
          key: Key('point-artwork-image-${item.id}'),
          width: 58,
          height: 47,
          fit: BoxFit.cover,
        ),
      );
    }
    final iconSize = _transactionIconSize(item.kind);
    return Container(
      key: Key('point-artwork-${item.id}'),
      width: 58,
      height: 47,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: _kindBackground(item.kind),
        borderRadius: BorderRadius.circular(11),
      ),
      child: item.iconAsset == null
          ? Icon(_kindIcon(item.kind), color: _kindColor(item.kind), size: 25)
          : SvgPicture.asset(
              item.iconAsset!,
              key: Key('point-artwork-icon-${item.id}'),
              width: iconSize.width,
              height: iconSize.height,
            ),
    );
  }
}

Size _transactionIconSize(PointTransactionKind kind) => switch (kind) {
  PointTransactionKind.redeem => const Size(20.45, 18.3667),
  PointTransactionKind.expire => const Size(20.45, 20.45),
  PointTransactionKind.adjust => const Size(24, 24),
  _ => const Size(25, 25),
};

class _PointHistoryEmpty extends StatelessWidget {
  const _PointHistoryEmpty({this.onLearnMore});
  final VoidCallback? onLearnMore;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: SizedBox(
          key: const Key('point-history-empty'),
          height: constraints.maxHeight,
          child: Column(
            children: [
              const SizedBox(height: 124),
              SvgPicture.asset(
                '$_assetRoot/empty_history.svg',
                width: 180,
                height: 180,
              ),
              const SizedBox(height: 7),
              const Text(
                'Chưa có giao dịch điểm',
                style: TextStyle(
                  color: _ink,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: Text(
                  'Bạn sẽ thấy lịch sử tích, đổi và hết hạn\nđiểm tại đây.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: _muted, fontSize: 14, height: 1.45),
                ),
              ),
              const SizedBox(height: 38),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: TextButton(
                    key: const Key('point-history-learn-more'),
                    onPressed: onLearnMore,
                    style: TextButton.styleFrom(
                      foregroundColor: const Color(0xFF006EBE),
                      backgroundColor: const Color(0xFFEDF7FF),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: const Text(
                      'Tìm hiểu VXN Plus',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
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
}

class _FilteredEmpty extends StatelessWidget {
  const _FilteredEmpty();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.only(top: 54),
      child: Column(
        children: [
          Icon(Icons.receipt_long_outlined, size: 52, color: Color(0xFFB7CADB)),
          SizedBox(height: 12),
          Text('Không có giao dịch phù hợp', style: TextStyle(color: _ink)),
        ],
      ),
    );
  }
}

class _HistoryHeader extends StatelessWidget {
  const _HistoryHeader({required this.onBack, this.onRedeem});
  final VoidCallback onBack;
  final VoidCallback? onRedeem;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 64,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            left: 16,
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: _background,
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFFDDE9F5)),
              ),
              child: IconButton(
                key: const Key('point-history-back'),
                padding: const EdgeInsets.all(7),
                onPressed: onBack,
                icon: SvgPicture.asset(
                  '$_assetRoot/back.svg',
                  width: 20,
                  height: 20,
                ),
              ),
            ),
          ),
          const Text(
            'Lịch sử điểm',
            style: TextStyle(
              color: _ink,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          if (onRedeem != null)
            Positioned(
              right: 8,
              child: TextButton(
                key: const Key('point-history-redeem'),
                onPressed: onRedeem,
                style: TextButton.styleFrom(
                  foregroundColor: const Color(0xFF126BB1),
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  textStyle: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                child: const Text('Đổi điểm'),
              ),
            ),
        ],
      ),
    );
  }
}

class _DateFilterSheet extends StatefulWidget {
  const _DateFilterSheet({required this.selected});
  final PointDateFilter selected;

  @override
  State<_DateFilterSheet> createState() => _DateFilterSheetState();
}

class _DateFilterSheetState extends State<_DateFilterSheet> {
  late PointDateFilter _selected = widget.selected;

  @override
  Widget build(BuildContext context) {
    return Container(
      key: const Key('point-date-filter-sheet'),
      height: 588 + MediaQuery.paddingOf(context).bottom,
      padding: EdgeInsets.fromLTRB(
        24,
        12,
        24,
        42 + MediaQuery.paddingOf(context).bottom,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      child: Column(
        children: [
          Container(
            width: 44,
            height: 5,
            decoration: BoxDecoration(
              color: const Color(0xFFAAB9CC),
              borderRadius: BorderRadius.circular(3),
            ),
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Lọc theo thời gian',
                  style: TextStyle(
                    color: _ink,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              IconButton(
                key: const Key('point-date-filter-close'),
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.close_rounded, color: Color(0xFF6B7E9B)),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: Align(
              alignment: Alignment.topCenter,
              child: Container(
                height: 360,
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xFFE4EDF7)),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: SingleChildScrollView(
                  child: SizedBox(
                    height: 360,
                    child: Column(
                      children: [
                        for (
                          var index = 0;
                          index < PointDateFilter.values.length;
                          index++
                        ) ...[
                          _DateOption(
                            option: PointDateFilter.values[index],
                            selected:
                                _selected == PointDateFilter.values[index],
                            onTap: () => setState(
                              () => _selected = PointDateFilter.values[index],
                            ),
                          ),
                          if (index != PointDateFilter.values.length - 1)
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16),
                              child: Divider(
                                height: .5,
                                color: Color(0xFFE7EDF5),
                              ),
                            ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            width: double.infinity,
            height: 56,
            child: FilledButton(
              key: const Key('point-date-filter-apply'),
              onPressed: () => Navigator.pop(context, _selected),
              style: FilledButton.styleFrom(
                backgroundColor: _primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(17),
                ),
              ),
              child: const Text(
                'Áp dụng',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DateOption extends StatelessWidget {
  const _DateOption({
    required this.option,
    required this.selected,
    required this.onTap,
  });
  final PointDateFilter option;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        key: Key('point-date-${option.name}'),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  _dateLabel(option),
                  style: const TextStyle(color: _ink, fontSize: 14),
                ),
              ),
              Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  color: selected ? _primary : Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: selected ? _primary : const Color(0xFF7E9CB9),
                  ),
                ),
                child: selected
                    ? const Icon(
                        Icons.check_rounded,
                        color: Colors.white,
                        size: 15,
                      )
                    : null,
              ),
            ],
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
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('Chưa thể tải lịch sử điểm.'),
          const SizedBox(height: 10),
          OutlinedButton(onPressed: onRetry, child: const Text('Thử lại')),
        ],
      ),
    );
  }
}

String _dateLabel(PointDateFilter filter) => switch (filter) {
  PointDateFilter.all => 'Tất cả',
  PointDateFilter.currentMonth => 'Tháng này',
  PointDateFilter.previousMonth => 'Tháng trước',
  PointDateFilter.threeMonths => '3 tháng gần đây',
  PointDateFilter.sixMonths => '6 tháng gần đây',
  PointDateFilter.custom => 'Tùy chọn khác',
};

String _kindLabel(PointTransactionKind kind) => switch (kind) {
  PointTransactionKind.earn => 'Tích điểm',
  PointTransactionKind.redeem => 'Đổi điểm',
  PointTransactionKind.expire => 'Điểm hết hạn',
  PointTransactionKind.adjust => 'Điều chỉnh điểm',
  PointTransactionKind.reversal => 'Thu hồi điểm',
};

IconData _kindIcon(PointTransactionKind kind) => switch (kind) {
  PointTransactionKind.earn => Icons.directions_bus_filled_rounded,
  PointTransactionKind.redeem => Icons.confirmation_number_outlined,
  PointTransactionKind.expire => Icons.schedule_rounded,
  PointTransactionKind.adjust => Icons.settings_outlined,
  PointTransactionKind.reversal => Icons.undo_rounded,
};

Color _kindColor(PointTransactionKind kind) => switch (kind) {
  PointTransactionKind.redeem => const Color(0xFF1265F5),
  PointTransactionKind.expire => const Color(0xFFFF4B60),
  PointTransactionKind.adjust => const Color(0xFF66717D),
  PointTransactionKind.reversal => const Color(0xFF7A5AF8),
  PointTransactionKind.earn => _primary,
};

Color _kindBackground(PointTransactionKind kind) => switch (kind) {
  PointTransactionKind.redeem => const Color(0xFFEBF5FF),
  PointTransactionKind.expire => const Color(0xFFFFF0F2),
  PointTransactionKind.adjust => const Color(0xFFF4F4F4),
  _ => _kindColor(kind).withValues(alpha: .1),
};

String _formatPoints(int value) {
  final digits = value.abs().toString();
  final parts = <String>[];
  for (var end = digits.length; end > 0; end -= 3) {
    final start = end - 3 < 0 ? 0 : end - 3;
    parts.add(digits.substring(start, end));
  }
  return parts.reversed.join('.');
}

String _formatDate(DateTime value) {
  final local = value.toLocal();
  String two(int number) => number.toString().padLeft(2, '0');
  return '${two(local.day)}/${two(local.month)}/${local.year}';
}

String _monthLabel(DateTime value) {
  final local = value.toLocal();
  return 'Tháng ${local.month.toString().padLeft(2, '0')}/${local.year}';
}

bool _matchesDate(DateTime value, PointDateFilter filter) {
  if (filter == PointDateFilter.all || filter == PointDateFilter.custom) {
    return true;
  }
  final now = DateTime.now();
  final monthDifference =
      (now.year - value.year) * 12 + now.month - value.month;
  return switch (filter) {
    PointDateFilter.currentMonth => monthDifference == 0,
    PointDateFilter.previousMonth => monthDifference == 1,
    PointDateFilter.threeMonths => monthDifference >= 0 && monthDifference < 3,
    PointDateFilter.sixMonths => monthDifference >= 0 && monthDifference < 6,
    PointDateFilter.all || PointDateFilter.custom => true,
  };
}
