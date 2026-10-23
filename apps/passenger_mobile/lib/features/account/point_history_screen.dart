import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

const _primary = Color(0xFF168AC0);
const _ink = Color(0xFF0D173B);
const _muted = Color(0xFF7188A3);
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
  });

  final String id;
  final PointTransactionKind kind;
  final int points;
  final String title;
  final String? detail;
  final DateTime createdAt;
}

class PointHistoryScreen extends StatefulWidget {
  const PointHistoryScreen({
    required this.loadHistory,
    required this.onBack,
    this.onLearnMore,
    super.key,
  });

  final PointHistoryLoader loadHistory;
  final VoidCallback onBack;
  final VoidCallback? onLearnMore;

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

  void _selectType(PointTypeFilter type) {
    if (_query.type == type) return;
    _query = PointHistoryQuery(type: type, date: _query.date);
    _reload();
  }

  Future<void> _selectDate() async {
    final selected = await showModalBottomSheet<PointDateFilter>(
      context: context,
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
              _HistoryHeader(onBack: widget.onBack),
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
                        physics: const AlwaysScrollableScrollPhysics(),
                        padding: const EdgeInsets.fromLTRB(16, 10, 16, 28),
                        children: [
                          _PointOverview(data: data),
                          const SizedBox(height: 22),
                          Row(
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
                                icon: const Icon(
                                  Icons.calendar_month_outlined,
                                  size: 16,
                                ),
                                label: Text(_dateLabel(_query.date)),
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: _ink,
                                  side: const BorderSide(
                                    color: Color(0xFFDCE8F3),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 11,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: PointTypeFilter.values
                                  .map(
                                    (filter) => Padding(
                                      padding: const EdgeInsets.only(right: 8),
                                      child: ChoiceChip(
                                        key: Key('point-filter-${filter.name}'),
                                        label: Text(_typeFilterLabel(filter)),
                                        selected: _query.type == filter,
                                        showCheckmark: false,
                                        selectedColor: const Color(0xFFDFF3FC),
                                        backgroundColor: Colors.white,
                                        side: BorderSide(
                                          color: _query.type == filter
                                              ? _primary
                                              : const Color(0xFFDCE8F3),
                                        ),
                                        labelStyle: TextStyle(
                                          color: _query.type == filter
                                              ? _primary
                                              : _muted,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                        ),
                                        onSelected: (_) => _selectType(filter),
                                      ),
                                    ),
                                  )
                                  .toList(growable: false),
                            ),
                          ),
                          const SizedBox(height: 15),
                          if (data.transactions.isEmpty)
                            const _FilteredEmpty()
                          else
                            ..._transactionWidgets(data.transactions),
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

List<Widget> _transactionWidgets(List<PointTransactionItem> items) {
  final widgets = <Widget>[];
  String? currentMonth;
  for (var index = 0; index < items.length; index++) {
    final item = items[index];
    final month = _monthLabel(item.createdAt);
    if (month != currentMonth) {
      if (widgets.isNotEmpty) widgets.add(const SizedBox(height: 14));
      widgets.add(
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Text(
            month,
            style: const TextStyle(
              color: _muted,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      );
      currentMonth = month;
    }
    widgets.add(_TransactionCard(item: item, imageIndex: index % 3));
    widgets.add(const SizedBox(height: 8));
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
      padding: const EdgeInsets.fromLTRB(16, 16, 10, 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE3EDF6)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Điểm khả dụng',
                      style: TextStyle(color: _muted, fontSize: 12),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _formatPoints(data.availablePoints),
                      style: const TextStyle(
                        color: _ink,
                        fontSize: 29,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              SvgPicture.asset(
                '$_assetRoot/points_summary.svg',
                width: 130,
                height: 79,
              ),
            ],
          ),
          const Divider(height: 22, color: Color(0xFFE8EFF6)),
          Row(
            children: [
              _Stat(label: 'Đã tích', value: data.earnedPoints),
              _Stat(label: 'Đã đổi', value: data.redeemedPoints),
              _Stat(label: 'Đã hết hạn', value: data.expiredPoints),
            ],
          ),
        ],
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat({required this.label, required this.value});

  final String label;
  final int value;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(label, style: const TextStyle(color: _muted, fontSize: 10.5)),
          const SizedBox(height: 3),
          Text(
            _formatPoints(value),
            style: const TextStyle(
              color: _ink,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _TransactionCard extends StatelessWidget {
  const _TransactionCard({required this.item, required this.imageIndex});

  final PointTransactionItem item;
  final int imageIndex;

  @override
  Widget build(BuildContext context) {
    final positive = item.points >= 0;
    return Container(
      key: Key('point-transaction-${item.id}'),
      height: 72,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE4EDF6)),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(9),
            child: item.kind == PointTransactionKind.earn
                ? Image.asset(
                    '$_assetRoot/bus_${imageIndex + 1}.png',
                    width: 54,
                    height: 54,
                    fit: BoxFit.cover,
                  )
                : Container(
                    width: 54,
                    height: 54,
                    color: _kindBackground(item.kind),
                    child: Icon(
                      _kindIcon(item.kind),
                      color: _kindColor(item.kind),
                    ),
                  ),
          ),
          const SizedBox(width: 10),
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
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  item.detail?.trim().isNotEmpty == true
                      ? item.detail!
                      : _kindLabel(item.kind),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: _muted, fontSize: 10.5),
                ),
                const SizedBox(height: 2),
                Text(
                  _formatDateTime(item.createdAt),
                  style: const TextStyle(
                    color: Color(0xFF90A3B7),
                    fontSize: 9.5,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Text(
            '${positive ? '+' : ''}${_formatPoints(item.points)}',
            style: TextStyle(
              color: positive
                  ? const Color(0xFF008657)
                  : const Color(0xFFE5484D),
              fontSize: 13,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(width: 2),
          const Icon(Icons.chevron_right_rounded, size: 18, color: _muted),
        ],
      ),
    );
  }
}

class _PointHistoryEmpty extends StatelessWidget {
  const _PointHistoryEmpty({this.onLearnMore});

  final VoidCallback? onLearnMore;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: SizedBox(
        key: const Key('point-history-empty'),
        height: MediaQuery.sizeOf(context).height - 100,
        child: Column(
          children: [
            const SizedBox(height: 124),
            SvgPicture.asset(
              '$_assetRoot/empty_history.svg',
              width: 180,
              height: 180,
            ),
            const SizedBox(height: 18),
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
              padding: EdgeInsets.symmetric(horizontal: 40),
              child: Text(
                'Bạn sẽ thấy lịch sử tích, đổi và hết hạn điểm tại đây.',
                textAlign: TextAlign.center,
                style: TextStyle(color: _muted, fontSize: 12, height: 1.55),
              ),
            ),
            const SizedBox(height: 18),
            TextButton(
              key: const Key('point-history-learn-more'),
              onPressed: onLearnMore,
              style: TextButton.styleFrom(
                foregroundColor: _primary,
                backgroundColor: const Color(0xFFE6F5FC),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text('Tìm hiểu VXN Plus'),
            ),
          ],
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
  const _HistoryHeader({required this.onBack});

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
            child: Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFFDDE9F5)),
              ),
              child: IconButton(
                key: const Key('point-history-back'),
                padding: EdgeInsets.zero,
                onPressed: onBack,
                icon: const Icon(
                  Icons.arrow_back_rounded,
                  size: 20,
                  color: _ink,
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
        ],
      ),
    );
  }
}

class _DateFilterSheet extends StatelessWidget {
  const _DateFilterSheet({required this.selected});

  final PointDateFilter selected;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 42,
            height: 4,
            decoration: BoxDecoration(
              color: const Color(0xFFD5E0EB),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 16),
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Lọc theo thời gian',
              style: TextStyle(
                color: _ink,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: 8),
          RadioGroup<PointDateFilter>(
            groupValue: selected,
            onChanged: (value) {
              if (value != null) Navigator.pop(context, value);
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                for (final option in PointDateFilter.values)
                  RadioListTile<PointDateFilter>(
                    value: option,
                    activeColor: _primary,
                    contentPadding: EdgeInsets.zero,
                    title: Text(_dateLabel(option)),
                  ),
              ],
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
          const Text('Chưa thể tải lịch sử điểm.'),
          const SizedBox(height: 10),
          OutlinedButton(onPressed: onRetry, child: const Text('Thử lại')),
        ],
      ),
    );
  }
}

String _typeFilterLabel(PointTypeFilter filter) => switch (filter) {
  PointTypeFilter.all => 'Tất cả',
  PointTypeFilter.earn => 'Tích điểm',
  PointTypeFilter.redeem => 'Đổi điểm',
  PointTypeFilter.expire => 'Hết hạn',
};

String _dateLabel(PointDateFilter filter) => switch (filter) {
  PointDateFilter.all => 'Tất cả thời gian',
  PointDateFilter.currentMonth => 'Tháng này',
  PointDateFilter.previousMonth => 'Tháng trước',
  PointDateFilter.threeMonths => '3 tháng gần đây',
  PointDateFilter.sixMonths => '6 tháng gần đây',
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
  PointTransactionKind.redeem => Icons.card_giftcard_rounded,
  PointTransactionKind.expire => Icons.schedule_rounded,
  PointTransactionKind.adjust => Icons.tune_rounded,
  PointTransactionKind.reversal => Icons.undo_rounded,
};

Color _kindColor(PointTransactionKind kind) => switch (kind) {
  PointTransactionKind.redeem => const Color(0xFF1265F5),
  PointTransactionKind.expire => const Color(0xFFE5484D),
  PointTransactionKind.adjust => const Color(0xFFFF9F1C),
  PointTransactionKind.reversal => const Color(0xFF7A5AF8),
  PointTransactionKind.earn => _primary,
};

Color _kindBackground(PointTransactionKind kind) =>
    _kindColor(kind).withValues(alpha: 0.1);

String _formatPoints(int value) {
  final negative = value < 0;
  final digits = value.abs().toString();
  final parts = <String>[];
  for (var end = digits.length; end > 0; end -= 3) {
    final start = end - 3 < 0 ? 0 : end - 3;
    parts.add(digits.substring(start, end));
  }
  return '${negative ? '-' : ''}${parts.reversed.join('.')}';
}

String _formatDateTime(DateTime value) {
  final local = value.toLocal();
  String two(int number) => number.toString().padLeft(2, '0');
  return '${two(local.day)}/${two(local.month)}/${local.year} · ${two(local.hour)}:${two(local.minute)}';
}

String _monthLabel(DateTime value) {
  final local = value.toLocal();
  return 'Tháng ${local.month}/${local.year}';
}
