import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:passenger_mobile/features/support/support_api.dart';
import 'package:passenger_mobile/features/support/support_models.dart';

const _primary = Color(0xFF2088C9);
const _ink = Color(0xFF0C173D);
const _muted = Color(0xFF506D95);
const _background = Color(0xFFF7FBFF);
const _border = Color(0xFFEAF1F8);

/// Khiếu nại và hỗ trợ (SCR-PSG-30): tab Đang xử lý / Đã đóng, gửi khiếu nại mới, mở chi tiết để trao đổi.
///
/// Mở từ chi tiết vé thì có [booking]: chỉ hiện khiếu nại của đơn đó và gửi mới cho đúng đơn. Mở từ
/// Tài khoản thì hiện mọi khiếu nại; gửi mới chọn đơn qua [loadBookings].
class SupportTicketsScreen extends StatefulWidget {
  const SupportTicketsScreen({
    required this.service,
    required this.onBack,
    this.booking,
    this.loadBookings,
    super.key,
  });

  final SupportTicketService service;
  final VoidCallback onBack;
  final SupportBookingRef? booking;
  final Future<List<SupportBookingRef>> Function()? loadBookings;

  @override
  State<SupportTicketsScreen> createState() => _SupportTicketsScreenState();
}

class _SupportTicketsScreenState extends State<SupportTicketsScreen> {
  late Future<List<SupportTicketSummary>> _tickets = _load();
  bool _showClosed = false;

  Future<List<SupportTicketSummary>> _load() async {
    final items = await widget.service.listMine();
    final booking = widget.booking;
    if (booking == null) return items;
    return [
      for (final item in items)
        if (item.bookingId == booking.bookingId) item,
    ];
  }

  Future<void> _reload() async {
    final next = _load();
    setState(() {
      _tickets = next;
    });
    await next.catchError((_) => const <SupportTicketSummary>[]);
  }

  Future<void> _openDetail(
    String bookingId,
    String ticketId, {
    SupportTicketDetail? initial,
  }) async {
    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (routeContext) => SupportTicketDetailScreen(
          service: widget.service,
          bookingId: bookingId,
          ticketId: ticketId,
          initial: initial,
          onBack: () => Navigator.of(routeContext).pop(),
        ),
      ),
    );
    if (mounted) await _reload();
  }

  Future<void> _startNew() async {
    final booking = widget.booking ?? await _pickBooking();
    if (booking == null || !mounted) return;
    final created = await Navigator.of(context).push<SupportTicketDetail>(
      MaterialPageRoute<SupportTicketDetail>(
        builder: (routeContext) => SupportTicketFormScreen(
          booking: booking,
          submit: (draft) => widget.service.create(booking.bookingId, draft),
          onCreated: (detail) => Navigator.of(routeContext).pop(detail),
          onBack: () => Navigator.of(routeContext).pop(),
        ),
      ),
    );
    if (created == null || !mounted) return;
    setState(() => _showClosed = false);
    await _openDetail(created.bookingId, created.ticketId, initial: created);
  }

  Future<SupportBookingRef?> _pickBooking() async {
    final load = widget.loadBookings;
    if (load == null) return null;
    return showModalBottomSheet<SupportBookingRef>(
      context: context,
      useSafeArea: true,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => _BookingPickerSheet(load: load),
    );
  }

  @override
  Widget build(BuildContext context) {
    final booking = widget.booking;
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        key: const Key('support-tickets-screen'),
        backgroundColor: _background,
        body: SafeArea(
          child: Column(
            children: [
              _SupportHeader(
                title: 'Khiếu nại và hỗ trợ',
                backKey: const Key('support-back'),
                onBack: widget.onBack,
              ),
              if (booking != null)
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
                  child: Text(
                    'Đơn ${booking.bookingCode} · ${booking.routeName}',
                    key: const Key('support-booking-scope'),
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: _muted, fontSize: 13),
                  ),
                ),
              Expanded(
                child: FutureBuilder<List<SupportTicketSummary>>(
                  future: _tickets,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState != ConnectionState.done) {
                      return const Center(
                        key: Key('support-loading'),
                        child: CircularProgressIndicator(color: _primary),
                      );
                    }
                    if (snapshot.hasError) {
                      return _LoadError(
                        message: describeSupportFailure(snapshot.error!),
                        onRetry: _reload,
                      );
                    }
                    final all = snapshot.requireData;
                    final active = [
                      for (final ticket in all)
                        if (isSupportTicketActive(ticket.status)) ticket,
                    ];
                    final closed = [
                      for (final ticket in all)
                        if (!isSupportTicketActive(ticket.status)) ticket,
                    ];
                    final visible = _showClosed ? closed : active;
                    return RefreshIndicator(
                      color: _primary,
                      onRefresh: _reload,
                      child: ListView(
                        key: const Key('support-ticket-list'),
                        physics: const AlwaysScrollableScrollPhysics(),
                        padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
                        children: [
                          if (all.isEmpty)
                            _SupportEmpty(forBooking: booking != null)
                          else ...[
                            _SupportTabs(
                              showClosed: _showClosed,
                              activeCount: active.length,
                              closedCount: closed.length,
                              onChanged: (value) =>
                                  setState(() => _showClosed = value),
                            ),
                            const SizedBox(height: 12),
                            if (visible.isEmpty)
                              const Padding(
                                key: Key('support-tab-empty'),
                                padding: EdgeInsets.symmetric(vertical: 28),
                                child: Text(
                                  'Không có khiếu nại nào trong mục này.',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: _muted),
                                ),
                              )
                            else
                              for (final ticket in visible)
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 10),
                                  child: _TicketCard(
                                    ticket: ticket,
                                    onTap: () => _openDetail(
                                      ticket.bookingId,
                                      ticket.ticketId,
                                    ),
                                  ),
                                ),
                          ],
                        ],
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                child: SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: FilledButton.icon(
                    key: const Key('support-new'),
                    onPressed: _startNew,
                    style: FilledButton.styleFrom(
                      backgroundColor: _primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    icon: const Icon(Icons.add_comment_outlined, size: 20),
                    label: const Text(
                      'Gửi khiếu nại',
                      style: TextStyle(fontWeight: FontWeight.w600),
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

/// Gửi khiếu nại (SCR-PSG-31): danh mục, mức độ gợi ý, tiêu đề ≤200, nội dung ≤2000. Đính kèm làm đợt sau.
class SupportTicketFormScreen extends StatefulWidget {
  const SupportTicketFormScreen({
    required this.booking,
    required this.submit,
    required this.onCreated,
    required this.onBack,
    super.key,
  });

  final SupportBookingRef booking;
  final Future<SupportTicketDetail> Function(SupportTicketDraft draft) submit;
  final ValueChanged<SupportTicketDetail> onCreated;
  final VoidCallback onBack;

  @override
  State<SupportTicketFormScreen> createState() =>
      _SupportTicketFormScreenState();
}

class _SupportTicketFormScreenState extends State<SupportTicketFormScreen> {
  // Mặc định như web.
  SupportCategory _category = SupportCategory.paymentRefund;
  SupportPriority _priority = SupportPriority.medium;
  final _subject = TextEditingController();
  final _body = TextEditingController();
  bool _busy = false;
  String? _error;

  @override
  void dispose() {
    _subject.dispose();
    _body.dispose();
    super.dispose();
  }

  Future<void> _send() async {
    final subject = _subject.text.trim();
    final body = _body.text.trim();
    if (subject.length < 3) {
      setState(() => _error = 'Tiêu đề cần từ 3 đến 200 ký tự.');
      return;
    }
    if (body.isEmpty) {
      setState(() => _error = 'Vui lòng mô tả vấn đề bạn gặp.');
      return;
    }
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      final created = await widget.submit(
        SupportTicketDraft(
          category: _category,
          priority: _priority,
          subject: subject,
          body: body,
        ),
      );
      if (!mounted) return;
      widget.onCreated(created);
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _busy = false;
        _error = describeSupportFailure(error);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final booking = widget.booking;
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        key: const Key('support-form-screen'),
        backgroundColor: _background,
        body: SafeArea(
          child: Column(
            children: [
              _SupportHeader(
                title: 'Gửi khiếu nại',
                backKey: const Key('support-form-back'),
                onBack: widget.onBack,
              ),
              Expanded(
                child: ListView(
                  key: const Key('support-form-scroll'),
                  padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
                  children: [
                    _Card(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Đơn vé',
                            style: TextStyle(color: _muted, fontSize: 12.5),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${booking.bookingCode} · ${booking.routeName}',
                            key: const Key('support-form-booking'),
                            style: const TextStyle(
                              color: _ink,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    const _FieldLabel('Danh mục'),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        for (final category in SupportCategory.values)
                          _Choice(
                            key: Key('support-category-${category.name}'),
                            label: category.label,
                            selected: _category == category,
                            onSelected: _busy
                                ? null
                                : () => setState(() => _category = category),
                          ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const _FieldLabel('Mức độ (gợi ý)'),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        for (final priority in SupportPriority.values)
                          _Choice(
                            key: Key('support-priority-${priority.name}'),
                            label: priority.label,
                            selected: _priority == priority,
                            onSelected: _busy
                                ? null
                                : () => setState(() => _priority = priority),
                          ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Mức độ bạn chọn chỉ là gợi ý, CSKH sẽ phân loại lại.',
                      style: TextStyle(color: _muted, fontSize: 12),
                    ),
                    const SizedBox(height: 16),
                    const _FieldLabel('Tiêu đề'),
                    TextField(
                      key: const Key('support-subject'),
                      controller: _subject,
                      enabled: !_busy,
                      maxLength: 200,
                      textInputAction: TextInputAction.next,
                      decoration: _inputDecoration(
                        'Ví dụ: Chưa nhận được tiền hoàn',
                      ),
                    ),
                    const SizedBox(height: 8),
                    const _FieldLabel('Nội dung'),
                    TextField(
                      key: const Key('support-body'),
                      controller: _body,
                      enabled: !_busy,
                      maxLength: 2000,
                      minLines: 5,
                      maxLines: 8,
                      decoration: _inputDecoration(
                        'Mô tả vấn đề, thời gian, người liên quan…',
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Ngay trên nút gửi để luôn thấy, kể cả khi bàn phím che phần dưới form.
                    if (_error != null) ...[
                      _ErrorBox(
                        key: const Key('support-form-error'),
                        message: _error!,
                      ),
                      const SizedBox(height: 8),
                    ],
                    SizedBox(
                      height: 48,
                      child: FilledButton(
                        key: const Key('support-submit'),
                        onPressed: _busy ? null : _send,
                        style: FilledButton.styleFrom(
                          backgroundColor: _primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: Text(
                          _busy ? 'Đang gửi…' : 'Gửi khiếu nại',
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ),
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

/// Chi tiết khiếu nại (SCR-PSG-30): thông tin, nhắc bổ sung khi chờ khách, trao đổi và ô phản hồi.
class SupportTicketDetailScreen extends StatefulWidget {
  const SupportTicketDetailScreen({
    required this.service,
    required this.bookingId,
    required this.ticketId,
    required this.onBack,
    this.initial,
    super.key,
  });

  final SupportTicketService service;
  final String bookingId;
  final String ticketId;
  final VoidCallback onBack;

  /// Chi tiết đã có (vừa gửi khiếu nại) thì không tải lại.
  final SupportTicketDetail? initial;

  @override
  State<SupportTicketDetailScreen> createState() =>
      _SupportTicketDetailScreenState();
}

class _SupportTicketDetailScreenState extends State<SupportTicketDetailScreen> {
  late SupportTicketDetail? _detail = widget.initial;
  late bool _loading = widget.initial == null;
  Object? _loadError;
  final _reply = TextEditingController();
  bool _sending = false;
  String? _replyError;

  @override
  void initState() {
    super.initState();
    if (_loading) _load();
  }

  @override
  void dispose() {
    _reply.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    try {
      final detail = await widget.service.load(
        widget.bookingId,
        widget.ticketId,
      );
      if (!mounted) return;
      setState(() {
        _detail = detail;
        _loadError = null;
        _loading = false;
      });
    } catch (error) {
      if (!mounted) return;
      // Kéo làm mới lỗi khi đã có chi tiết: giữ nội dung cũ, báo ngắn.
      if (_detail != null) {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            SnackBar(content: Text(describeSupportFailure(error))),
          );
      }
      setState(() {
        _loadError = error;
        _loading = false;
      });
    }
  }

  void _retry() {
    setState(() {
      _loading = true;
      _loadError = null;
    });
    _load();
  }

  Future<void> _send() async {
    final body = _reply.text.trim();
    if (body.isEmpty) {
      setState(() => _replyError = 'Vui lòng nhập nội dung phản hồi.');
      return;
    }
    setState(() {
      _sending = true;
      _replyError = null;
    });
    try {
      final updated = await widget.service.reply(
        widget.bookingId,
        widget.ticketId,
        body,
      );
      if (!mounted) return;
      _reply.clear();
      setState(() {
        _detail = updated;
        _sending = false;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _sending = false;
        _replyError = describeSupportFailure(error);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final detail = _detail;
    final Widget body;
    if (_loading) {
      body = const Center(
        key: Key('support-detail-loading'),
        child: CircularProgressIndicator(color: _primary),
      );
    } else if (detail == null) {
      body = _LoadError(
        message: describeSupportFailure(_loadError ?? StateError('empty')),
        onRetry: _retry,
      );
    } else {
      body = Column(
        children: [
          Expanded(
            child: RefreshIndicator(
              color: _primary,
              onRefresh: _load,
              child: ListView(
                key: const Key('support-detail-scroll'),
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
                children: [
                  _DetailSummary(detail: detail),
                  if (detail.status == 'WAITING_CUSTOMER') ...[
                    const SizedBox(height: 10),
                    Container(
                      key: const Key('support-waiting-notice'),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF4E0),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFFFDDA6)),
                      ),
                      child: const Text(
                        'Yêu cầu đang chờ bạn bổ sung thông tin.',
                        style: TextStyle(
                          color: Color(0xFF8A4B00),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                  const SizedBox(height: 18),
                  const Text(
                    'Trao đổi',
                    style: TextStyle(
                      color: _ink,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 10),
                  for (final message in detail.messages)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: _MessageBubble(message: message),
                    ),
                ],
              ),
            ),
          ),
          _ReplyBar(
            closed: detail.closed,
            controller: _reply,
            sending: _sending,
            error: _replyError,
            onSend: _send,
          ),
        ],
      );
    }
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        key: const Key('support-detail-screen'),
        backgroundColor: _background,
        body: SafeArea(
          child: Column(
            children: [
              _SupportHeader(
                title: 'Chi tiết khiếu nại',
                backKey: const Key('support-detail-back'),
                onBack: widget.onBack,
              ),
              Expanded(child: body),
            ],
          ),
        ),
      ),
    );
  }
}

class _SupportHeader extends StatelessWidget {
  const _SupportHeader({
    required this.title,
    required this.backKey,
    required this.onBack,
  });

  final String title;
  final Key backKey;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 67,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            left: 14,
            top: 6,
            child: Material(
              color: _background,
              shape: const CircleBorder(
                side: BorderSide(color: Color(0xFFDEEBF8)),
              ),
              child: InkWell(
                key: backKey,
                onTap: onBack,
                customBorder: const CircleBorder(),
                child: const SizedBox.square(
                  dimension: 42,
                  child: Center(
                    child: Text(
                      '‹',
                      style: TextStyle(color: _ink, fontSize: 30, height: 1),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: 15,
            left: 56,
            right: 56,
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: _ink,
                fontSize: 19,
                height: 1.45,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SupportTabs extends StatelessWidget {
  const _SupportTabs({
    required this.showClosed,
    required this.activeCount,
    required this.closedCount,
    required this.onChanged,
  });

  final bool showClosed;
  final int activeCount;
  final int closedCount;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _Choice(
          key: const Key('support-tab-active'),
          label: 'Đang xử lý ($activeCount)',
          selected: !showClosed,
          onSelected: () => onChanged(false),
        ),
        const SizedBox(width: 8),
        _Choice(
          key: const Key('support-tab-closed'),
          label: 'Đã đóng ($closedCount)',
          selected: showClosed,
          onSelected: () => onChanged(true),
        ),
      ],
    );
  }
}

class _Choice extends StatelessWidget {
  const _Choice({
    required this.label,
    required this.selected,
    required this.onSelected,
    super.key,
  });

  final String label;
  final bool selected;
  final VoidCallback? onSelected;

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      label: Text(label),
      selected: selected,
      showCheckmark: false,
      visualDensity: VisualDensity.compact,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      onSelected: onSelected == null ? null : (_) => onSelected!(),
      labelStyle: TextStyle(
        color: selected ? Colors.white : _ink,
        fontSize: 12.5,
        fontWeight: FontWeight.w600,
      ),
      selectedColor: _primary,
      backgroundColor: Colors.white,
      side: BorderSide(color: selected ? _primary : const Color(0xFFDCE6F2)),
    );
  }
}

class _TicketCard extends StatelessWidget {
  const _TicketCard({required this.ticket, required this.onTap});

  final SupportTicketSummary ticket;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: _border),
      ),
      child: InkWell(
        key: Key('support-ticket-${ticket.ticketId}'),
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      ticket.ticketCode,
                      style: const TextStyle(color: _muted, fontSize: 12.5),
                    ),
                  ),
                  _StatusBadge(status: ticket.status),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                ticket.subject,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: _ink,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Đơn ${ticket.bookingCode} · Cập nhật '
                '${formatSupportMoment(ticket.updatedAt)}',
                style: const TextStyle(color: _muted, fontSize: 12.5),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.status});

  final String status;

  @override
  Widget build(BuildContext context) {
    final (foreground, background) = switch (status) {
      'RESOLVED' => (const Color(0xFF007C50), const Color(0xFFE0FAEB)),
      'WAITING_CUSTOMER' => (const Color(0xFFB54708), const Color(0xFFFFF4E0)),
      'CLOSED' => (_muted, const Color(0xFFEFF2F6)),
      _ => (const Color(0xFF1C6FA8), const Color(0xFFE6F3FB)),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        supportStatusLabel(status),
        style: TextStyle(
          color: foreground,
          fontSize: 11.5,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _SupportEmpty extends StatelessWidget {
  const _SupportEmpty({required this.forBooking});

  final bool forBooking;

  @override
  Widget build(BuildContext context) {
    return Padding(
      key: const Key('support-empty'),
      padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 12),
      child: Column(
        children: [
          const Icon(
            Icons.support_agent_rounded,
            size: 56,
            color: Color(0xFF9CC5E4),
          ),
          const SizedBox(height: 12),
          const Text(
            'Chưa có khiếu nại',
            style: TextStyle(
              color: _ink,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            forBooking
                ? 'Đơn này chưa có khiếu nại. Bấm “Gửi khiếu nại” nếu bạn cần hỗ trợ về chuyến đi.'
                : 'Bạn chưa có yêu cầu hỗ trợ. Bấm “Gửi khiếu nại” để tạo yêu cầu gắn với đơn vé.',
            textAlign: TextAlign.center,
            style: const TextStyle(color: _muted, height: 1.4),
          ),
        ],
      ),
    );
  }
}

class _DetailSummary extends StatelessWidget {
  const _DetailSummary({required this.detail});

  final SupportTicketDetail detail;

  @override
  Widget build(BuildContext context) {
    return _Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  detail.ticketCode,
                  style: const TextStyle(color: _muted, fontSize: 12.5),
                ),
              ),
              _StatusBadge(status: detail.status),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            detail.subject,
            key: const Key('support-detail-subject'),
            style: const TextStyle(
              color: _ink,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 10),
          _InfoLine(label: 'Danh mục', value: detail.category.label),
          _InfoLine(label: 'Mức độ', value: detail.priority.label),
          _InfoLine(
            label: 'Đơn vé',
            value: '${detail.bookingCode} · ${detail.routeName}',
          ),
          _InfoLine(label: 'Nhà xe', value: detail.operatorName),
          _InfoLine(
            label: 'Gửi lúc',
            value: formatSupportMoment(detail.createdAt),
          ),
        ],
      ),
    );
  }
}

class _InfoLine extends StatelessWidget {
  const _InfoLine({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 76,
            child: Text(
              label,
              style: const TextStyle(color: _muted, fontSize: 13),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(color: _ink, fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }
}

class _MessageBubble extends StatelessWidget {
  const _MessageBubble({required this.message});

  final SupportMessage message;

  @override
  Widget build(BuildContext context) {
    final mine = message.fromPassenger;
    final role = message.roleLabel;
    return Align(
      alignment: mine ? Alignment.centerRight : Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.sizeOf(context).width * 0.82,
        ),
        child: Container(
          key: Key('support-message-${message.id}'),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: mine ? const Color(0xFFE6F3FB) : Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: mine ? const Color(0xFFC7E3F5) : _border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                role == null
                    ? message.authorName
                    : '${message.authorName} · $role',
                style: const TextStyle(
                  color: _ink,
                  fontSize: 12.5,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                message.body,
                style: const TextStyle(color: _ink, height: 1.4),
              ),
              for (final name in message.attachmentNames)
                Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.attach_file, size: 15, color: _muted),
                      const SizedBox(width: 4),
                      Flexible(
                        child: Text(
                          name,
                          style: const TextStyle(color: _muted, fontSize: 12.5),
                        ),
                      ),
                    ],
                  ),
                ),
              const SizedBox(height: 6),
              Text(
                formatSupportMoment(message.createdAt),
                style: const TextStyle(color: _muted, fontSize: 11.5),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ReplyBar extends StatelessWidget {
  const _ReplyBar({
    required this.closed,
    required this.controller,
    required this.sending,
    required this.error,
    required this.onSend,
  });

  final bool closed;
  final TextEditingController controller;
  final bool sending;
  final String? error;
  final VoidCallback onSend;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: _border)),
      ),
      child: closed
          ? const Text(
              'Khiếu nại đã đóng, không thể phản hồi thêm.',
              key: Key('support-reply-locked'),
              textAlign: TextAlign.center,
              style: TextStyle(color: _muted),
            )
          : Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (error != null) ...[
                  _ErrorBox(
                    key: const Key('support-reply-error'),
                    message: error!,
                  ),
                  const SizedBox(height: 8),
                ],
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: TextField(
                        key: const Key('support-reply-input'),
                        controller: controller,
                        enabled: !sending,
                        minLines: 1,
                        maxLines: 4,
                        maxLength: 2000,
                        decoration: _inputDecoration('Nhập phản hồi của bạn...')
                            .copyWith(counterText: ''),
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton.filled(
                      key: const Key('support-reply-send'),
                      onPressed: sending ? null : onSend,
                      style: IconButton.styleFrom(backgroundColor: _primary),
                      icon: sending
                          ? const SizedBox.square(
                              dimension: 18,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Icon(Icons.send_rounded, size: 20),
                    ),
                  ],
                ),
              ],
            ),
    );
  }
}

class _BookingPickerSheet extends StatefulWidget {
  const _BookingPickerSheet({required this.load});

  final Future<List<SupportBookingRef>> Function() load;

  @override
  State<_BookingPickerSheet> createState() => _BookingPickerSheetState();
}

class _BookingPickerSheetState extends State<_BookingPickerSheet> {
  late Future<List<SupportBookingRef>> _bookings = widget.load();

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.sizeOf(context).height * 0.7,
      ),
      child: Column(
        key: const Key('support-booking-picker'),
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(20, 20, 20, 4),
            child: Text(
              'Chọn đơn vé cần hỗ trợ',
              style: TextStyle(
                color: _ink,
                fontSize: 17,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Flexible(
            child: FutureBuilder<List<SupportBookingRef>>(
              future: _bookings,
              builder: (context, snapshot) {
                if (snapshot.connectionState != ConnectionState.done) {
                  return const Padding(
                    padding: EdgeInsets.all(32),
                    child: Center(
                      child: CircularProgressIndicator(color: _primary),
                    ),
                  );
                }
                if (snapshot.hasError) {
                  return _LoadError(
                    message: describeSupportFailure(snapshot.error!),
                    onRetry: () => setState(() {
                      _bookings = widget.load();
                    }),
                  );
                }
                final bookings = snapshot.requireData;
                if (bookings.isEmpty) {
                  return const Padding(
                    key: Key('support-booking-picker-empty'),
                    padding: EdgeInsets.fromLTRB(20, 12, 20, 32),
                    child: Text(
                      'Bạn chưa có đơn vé nào để gửi khiếu nại.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: _muted),
                    ),
                  );
                }
                return ListView.separated(
                  shrinkWrap: true,
                  padding: const EdgeInsets.fromLTRB(8, 4, 8, 16),
                  itemCount: bookings.length,
                  separatorBuilder: (_, _) => const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final booking = bookings[index];
                    final departure = booking.departureAt;
                    return ListTile(
                      key: Key('support-booking-${booking.bookingId}'),
                      title: Text(
                        booking.bookingCode,
                        style: const TextStyle(
                          color: _ink,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      subtitle: Text(
                        departure == null
                            ? booking.routeName
                            : '${booking.routeName} · '
                                  '${formatSupportMoment(departure)}',
                      ),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () => Navigator.of(context).pop(booking),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _LoadError extends StatelessWidget {
  const _LoadError({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      key: const Key('support-load-error'),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(color: _muted),
            ),
            const SizedBox(height: 10),
            TextButton(
              key: const Key('support-retry'),
              onPressed: onRetry,
              child: const Text('Thử lại'),
            ),
          ],
        ),
      ),
    );
  }
}

class _Card extends StatelessWidget {
  const _Card({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _border),
      ),
      child: child,
    );
  }
}

class _FieldLabel extends StatelessWidget {
  const _FieldLabel(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: const TextStyle(
          color: _ink,
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _ErrorBox extends StatelessWidget {
  const _ErrorBox({required this.message, super.key});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xFFFFEEEE),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        message,
        style: const TextStyle(color: Color(0xFFB42318), fontSize: 13),
      ),
    );
  }
}

InputDecoration _inputDecoration(String hint) => InputDecoration(
  hintText: hint,
  isDense: true,
  filled: true,
  fillColor: Colors.white,
  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
  enabledBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(12),
    borderSide: const BorderSide(color: Color(0xFFDCE6F2)),
  ),
  focusedBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(12),
    borderSide: const BorderSide(color: _primary),
  ),
  disabledBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(12),
    borderSide: const BorderSide(color: Color(0xFFE6EDF5)),
  ),
);
