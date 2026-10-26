import 'package:flutter/material.dart';

import 'demo_data.dart';
import 'design_system.dart';

/// Vận hành chuyến và nhật trình mẫu, chỉ thay đổi dữ liệu trong phiên xem thử.
class OperationsScreen extends StatefulWidget {
  const OperationsScreen({super.key, required this.trip});
  final DemoTrip trip;

  @override
  State<OperationsScreen> createState() => _OperationsScreenState();
}

class _OperationsScreenState extends State<OperationsScreen> {
  final List<({String title, DateTime occurredAt})> _history = [];
  String? _updatedAt;

  String? get _next => switch (widget.trip.status) {
    'Sắp khởi hành' || 'Chưa khởi hành' => 'Đón khách',
    'Đón khách' => 'Khởi hành',
    'Khởi hành' => 'Đang chạy',
    'Đang chạy' => 'Hoàn thành',
    _ => null,
  };

  Future<void> _writeJournal() async {
    final entry = await openDriverPage<_JournalEntry>(
      context,
      _JournalScreen(trip: widget.trip),
    );
    if (!mounted || entry == null) return;
    setState(() {
      widget.trip.journal.add((
        title: entry.category,
        time: entry.time,
        note: entry.note,
        occurredAt: entry.occurredAt,
        location: entry.location,
        vehicle: entry.vehicle,
        delay: entry.delay,
      ));
    });
    showDemoNotice(
      context,
      'Bản minh họa: đã lưu nhật trình trong phiên, chưa gửi máy chủ.',
    );
  }

  void _changeStatus() {
    final next = _next;
    if (next == null) return;
    setState(() {
      widget.trip.status = next;
      final occurredAt = DateTime.now();
      _updatedAt = _clock(occurredAt);
      _history.insert(0, (title: next, occurredAt: occurredAt));
    });
    showDemoNotice(
      context,
      'Bản minh họa: trạng thái $next chỉ lưu trong phiên, chưa gửi máy chủ.',
    );
  }

  @override
  Widget build(BuildContext context) {
    final trip = widget.trip;
    final next = _next;
    final activities =
        <({String title, DateTime occurredAt, _JournalEntry? entry})>[
          for (final event in _history)
            (title: event.title, occurredAt: event.occurredAt, entry: null),
          for (final entry in trip.journal)
            (
              title: entry.title,
              occurredAt: entry.occurredAt,
              entry: _JournalEntry(
                category: entry.title,
                occurredAt: entry.occurredAt,
                location: entry.location,
                vehicle: entry.vehicle,
                delay: entry.delay,
                note: entry.note,
              ),
            ),
        ]..sort((a, b) => b.occurredAt.compareTo(a.occurredAt));
    return DriverPage(
      background: Colors.white,
      statusAsset: 'operations-imgTinHiuWiFiPin',
      bottom: _ActionFooter(
        label: 'Ghi nhật trình',
        prefix: 'operations',
        onComplete: _writeJournal,
        links: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _BackLink('← Chi tiết chuyến'),
            TextButton(
              onPressed: () =>
                  openDriverPage<void>(context, IncidentScreen(trip: trip)),
              style: _linkStyle,
              child: Text(
                'Báo sự cố →',
                style: driverText(12, FontWeight.w400, DriverColors.teal),
              ),
            ),
          ],
        ),
      ),
      child: Column(
        children: [
          _OperationHeading(
            'Vận hành',
            prefix: 'operations',
            subtitle: '${trip.id} · ${trip.origin} → ${trip.destination}',
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
              children: [
                DriverCard(
                  color: DriverColors.canvas,
                  radius: 24,
                  child: Column(
                    children: [
                      const FigmaAsset(
                        'operations-imgMinhHaChuynDangVnHanh',
                        width: 200,
                        height: 76,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        trip.status,
                        textAlign: TextAlign.center,
                        style: driverText(
                          24,
                          FontWeight.w600,
                          DriverColors.navy,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        _updatedAt == null
                            ? 'Trạng thái chuyến minh họa'
                            : '${trip.status} từ $_updatedAt',
                        style: driverText(
                          12,
                          FontWeight.w400,
                          DriverColors.secondary,
                        ),
                      ),
                      const SizedBox(height: 12),
                      SwipeAction(
                        label: next == 'Hoàn thành'
                            ? 'Xác nhận hoàn thành'
                            : next == null
                            ? 'Đã hoàn thành'
                            : 'Xác nhận $next',
                        filled: true,
                        enabled: next != null,
                        onComplete: _changeStatus,
                        arrowAsset: 'operations-imgFrame',
                        chevronAsset: 'operations-imgFrame2',
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Hoạt động chuyến',
                      style: driverText(14, FontWeight.w500, DriverColors.navy),
                    ),
                    Text(
                      '${_history.length + trip.journal.length} mốc',
                      style: driverText(
                        12,
                        FontWeight.w400,
                        DriverColors.secondary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                if (_history.isEmpty && trip.journal.isEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Text(
                      'Chưa có hoạt động trong lần mở màn hình này.',
                      style: driverText(
                        14,
                        FontWeight.w400,
                        DriverColors.secondary,
                      ),
                    ),
                  ),
                for (final event in activities)
                  _ActivityRow(
                    title: event.title,
                    time: _clock(event.occurredAt),
                    source: event.entry == null
                        ? 'Cập nhật trạng thái'
                        : 'Nhật trình',
                    onTap: event.entry == null
                        ? null
                        : () => openDriverPage<void>(
                            context,
                            _JournalDetailScreen(
                              trip: trip,
                              entry: event.entry!,
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

class _ActivityRow extends StatelessWidget {
  const _ActivityRow({
    required this.title,
    required this.time,
    required this.source,
    this.onTap,
  });
  final String title, time, source;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) => InkWell(
    onTap: onTap,
    child: Container(
      constraints: const BoxConstraints(minHeight: 56),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: DriverColors.canvas)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: driverText(14, FontWeight.w600, DriverColors.navy),
                ),
                Text(
                  source,
                  style: driverText(
                    12,
                    FontWeight.w400,
                    DriverColors.secondary,
                  ),
                ),
              ],
            ),
          ),
          Text(time, style: driverText(12, FontWeight.w400, DriverColors.navy)),
          const SizedBox(width: 8),
          if (onTap != null)
            const FigmaAsset(
              'operations-imgVutXemChiTitNhtTrinh',
              width: 16,
              height: 16,
            )
          else
            const SizedBox(width: 16),
        ],
      ),
    ),
  );
}

class _JournalEntry {
  const _JournalEntry({
    required this.category,
    required this.occurredAt,
    required this.location,
    required this.vehicle,
    required this.delay,
    required this.note,
  });
  final String category, location, vehicle, note;
  final DateTime occurredAt;
  final int delay;
  String get time => _clock(occurredAt);
}

class _JournalScreen extends StatefulWidget {
  const _JournalScreen({required this.trip});
  final DemoTrip trip;
  @override
  State<_JournalScreen> createState() => _JournalScreenState();
}

class _JournalScreenState extends State<_JournalScreen> {
  final _note = TextEditingController();
  final _delay = TextEditingController(text: '0');
  final _form = GlobalKey<FormState>();
  String _category = 'Điểm dừng',
      _location = 'Trạm dừng nghỉ',
      _vehicle = 'Bình thường';
  DateTime _occurredAt = DateTime.now();

  @override
  void dispose() {
    _note.dispose();
    _delay.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => DriverPage(
    background: Colors.white,
    statusAsset: 'journal-imgTinHiuWiFiPin',
    bottom: _ActionFooter(
      label: 'Lưu nhật trình',
      prefix: 'journal',
      onComplete: () {
        if (!_form.currentState!.validate()) return;
        Navigator.pop(
          context,
          _JournalEntry(
            category: _category,
            occurredAt: _occurredAt,
            location: _location,
            vehicle: _vehicle,
            delay: int.parse(_delay.text),
            note: _note.text.trim(),
          ),
        );
      },
    ),
    child: Column(
      children: [
        _OperationHeading(
          'Ghi nhật trình',
          prefix: 'journal',
          subtitle: '${widget.trip.id} · ${widget.trip.plate}',
          trailing: const FigmaAsset(
            'journal-imgIconGhiChep',
            width: 32,
            height: 32,
          ),
        ),
        Expanded(
          child: Form(
            key: _form,
            child: ListView(
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
              children: [
                _ChoiceRow(
                  label: 'Loại ghi nhận',
                  choices: const ['Điểm dừng', 'Kiểm tra xe', 'Khác'],
                  selected: _category,
                  onChanged: (value) => setState(() => _category = value),
                ),
                const SizedBox(height: 20),
                _PickerField(
                  'Thời gian thực tế',
                  _dateTime(_occurredAt),
                  prefix: 'journal',
                  onTap: () async {
                    final value = await _pickDateTime(context, _occurredAt);
                    if (mounted && value != null) {
                      setState(() => _occurredAt = value);
                    }
                  },
                ),
                const SizedBox(height: 20),
                _PickerField(
                  'Địa điểm',
                  _location,
                  prefix: 'journal',
                  onTap: () async {
                    final value = await _pick(context, 'Địa điểm', [
                      'Trạm dừng nghỉ',
                      widget.trip.pickup,
                      widget.trip.dropoff,
                    ]);
                    if (mounted && value != null) {
                      setState(() => _location = value);
                    }
                  },
                ),
                const SizedBox(height: 20),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: _PickerField(
                        'Tình trạng xe',
                        _vehicle,
                        prefix: 'journal',
                        onTap: () async {
                          final value = await _pick(context, 'Tình trạng xe', [
                            'Bình thường',
                            'Cần kiểm tra',
                          ]);
                          if (mounted && value != null) {
                            setState(() => _vehicle = value);
                          }
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _Labelled(
                        'Độ trễ',
                        TextFormField(
                          controller: _delay,
                          keyboardType: TextInputType.number,
                          style: driverText(
                            14,
                            FontWeight.w500,
                            DriverColors.navy,
                          ),
                          decoration: _fieldDecoration.copyWith(
                            suffixText: 'phút',
                          ),
                          validator: (text) =>
                              int.tryParse(text ?? '') == null ||
                                  int.parse(text!) < 0
                              ? 'Nhập phút ≥ 0'
                              : null,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                _Labelled(
                  'Ghi chú',
                  TextFormField(
                    controller: _note,
                    maxLines: 4,
                    style: driverText(14, FontWeight.w500, DriverColors.navy),
                    decoration: _noteDecoration('Dừng nghỉ tại trạm.'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}

class _JournalDetailScreen extends StatelessWidget {
  const _JournalDetailScreen({required this.trip, required this.entry});
  final DemoTrip trip;
  final _JournalEntry entry;

  @override
  Widget build(BuildContext context) => DriverPage(
    background: Colors.white,
    statusAsset: 'journal-detail-imgTinHiuWiFiPin',
    bottom: _ActionFooter(
      label: 'Về Vận hành',
      prefix: 'journal-detail',
      onComplete: () => Navigator.pop(context),
    ),
    child: Column(
      children: [
        _OperationHeading(
          'Chi tiết nhật trình',
          prefix: 'journal-detail',
          subtitle: '${trip.id} · ${_date(entry.occurredAt)}',
        ),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(24),
            children: [
              DriverCard(
                color: DriverColors.cream,
                radius: 24,
                padding: 20,
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            entry.time,
                            style: driverText(
                              40,
                              FontWeight.w700,
                              DriverColors.navy,
                            ),
                          ),
                          Text(
                            'Giờ thực tế',
                            style: driverText(
                              12,
                              FontWeight.w400,
                              DriverColors.secondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(13),
                            ),
                            child: Text(
                              entry.category,
                              style: driverText(
                                12,
                                FontWeight.w400,
                                DriverColors.teal,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '${trip.origin} → ${trip.destination}',
                            style: driverText(
                              14,
                              FontWeight.w500,
                              DriverColors.navy,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              _DetailLine(
                'journal-detail-imgDaDim',
                'Địa điểm',
                entry.location,
              ),
              const Divider(height: 24, color: DriverColors.border),
              _DetailLine(
                'journal-detail-imgTinhTrngXe',
                'Tình trạng xe',
                entry.vehicle,
              ),
              const Divider(height: 24, color: DriverColors.border),
              Row(
                children: [
                  const FigmaAsset(
                    'journal-detail-imgDngH',
                    width: 24,
                    height: 24,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      entry.delay == 0
                          ? 'Không trễ so với dự kiến'
                          : 'Trễ ${entry.delay} phút so với dự kiến',
                      style: driverText(14, FontWeight.w500, DriverColors.navy),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              DriverCard(
                color: DriverColors.canvas,
                radius: 20,
                padding: 20,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Ghi chú',
                      style: driverText(16, FontWeight.w600, DriverColors.navy),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      entry.note.isEmpty ? 'Không có ghi chú.' : entry.note,
                      style: driverText(14, FontWeight.w500, DriverColors.navy),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  CircleAvatar(
                    radius: 22,
                    backgroundColor: DriverColors.canvas,
                    child: Text(
                      'NM',
                      style: driverText(14, FontWeight.w500, DriverColors.teal),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Nguyễn Minh',
                          style: driverText(
                            14,
                            FontWeight.w500,
                            DriverColors.navy,
                          ),
                        ),
                        Text(
                          'Bản minh họa · Chưa gửi máy chủ',
                          style: driverText(
                            12,
                            FontWeight.w400,
                            DriverColors.secondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

/// Biểu mẫu báo sự cố minh họa với lựa chọn mức độ và minh chứng tùy chọn.
class IncidentScreen extends StatefulWidget {
  const IncidentScreen({super.key, required this.trip});
  final DemoTrip trip;
  @override
  State<IncidentScreen> createState() => _IncidentScreenState();
}

class _IncidentScreenState extends State<IncidentScreen> {
  final _description = TextEditingController();
  final _form = GlobalKey<FormState>();
  String _type = 'Phương tiện',
      _severity = 'Trung bình',
      _location = 'Trạm dừng nghỉ';
  DateTime _occurredAt = DateTime.now();
  bool _evidence = false;

  @override
  void dispose() {
    _description.dispose();
    super.dispose();
  }

  Future<void> _chooseEvidence() async {
    final choice = await _pick(context, 'Ảnh minh chứng minh họa', [
      'Dùng ảnh mẫu (không tải ảnh thật)',
      'Bỏ ảnh minh chứng',
    ]);
    if (!mounted || choice == null) return;
    setState(() => _evidence = choice.startsWith('Dùng'));
    showDemoNotice(
      context,
      'Bản minh họa: lựa chọn ảnh chỉ lưu trong phiên, chưa gửi máy chủ.',
    );
  }

  @override
  Widget build(BuildContext context) => DriverPage(
    background: Colors.white,
    statusAsset: 'incident-imgTinHiuWiFiPin',
    bottom: _ActionFooter(
      label: 'Gửi báo cáo',
      prefix: 'incident',
      onComplete: () {
        if (!_form.currentState!.validate()) return;
        showDemoNotice(
          context,
          'Bản minh họa: báo cáo $_type ($_severity) chỉ xem thử, chưa gửi máy chủ.',
        );
      },
    ),
    child: Column(
      children: [
        _OperationHeading(
          'Báo sự cố',
          prefix: 'incident',
          subtitle: '${widget.trip.id} · ${widget.trip.plate}',
          trailing: Container(
            width: 40,
            height: 40,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: DriverColors.cream,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const FigmaAsset(
              'incident-imgIconSC',
              width: 22,
              height: 22,
            ),
          ),
        ),
        Expanded(
          child: Form(
            key: _form,
            child: ListView(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
              children: [
                _PickerField(
                  'Loại sự cố',
                  _type,
                  prefix: 'incident',
                  onTap: () async {
                    final value = await _pick(context, 'Loại sự cố', [
                      'Phương tiện',
                      'Giao thông',
                      'Khác',
                    ]);
                    if (mounted && value != null) setState(() => _type = value);
                  },
                ),
                const SizedBox(height: 16),
                _ChoiceRow(
                  label: 'Mức độ ảnh hưởng',
                  choices: const ['Nhẹ', 'Trung bình', 'Nghiêm trọng'],
                  selected: _severity,
                  warning: true,
                  onChanged: (value) => setState(() => _severity = value),
                ),
                const SizedBox(height: 16),
                _PickerField(
                  'Thời gian xảy ra',
                  _dateTime(_occurredAt),
                  prefix: 'incident',
                  onTap: () async {
                    final value = await _pickDateTime(context, _occurredAt);
                    if (mounted && value != null) {
                      setState(() => _occurredAt = value);
                    }
                  },
                ),
                const SizedBox(height: 16),
                _PickerField(
                  'Vị trí',
                  _location,
                  prefix: 'incident',
                  onTap: () async {
                    final value = await _pick(context, 'Vị trí', [
                      'Trạm dừng nghỉ',
                      widget.trip.pickup,
                      widget.trip.dropoff,
                    ]);
                    if (mounted && value != null) {
                      setState(() => _location = value);
                    }
                  },
                ),
                const SizedBox(height: 16),
                _Labelled(
                  'Mô tả',
                  TextFormField(
                    controller: _description,
                    maxLines: 3,
                    style: driverText(14, FontWeight.w500, DriverColors.navy),
                    decoration: _noteDecoration(
                      'Điều hòa ngừng hoạt động.\nXe đã dừng để kiểm tra.',
                    ),
                    validator: (value) => value == null || value.trim().isEmpty
                        ? 'Vui lòng nhập mô tả sự cố.'
                        : null,
                  ),
                ),
                const SizedBox(height: 16),
                _Labelled(
                  'Ảnh minh chứng',
                  GestureDetector(
                    onHorizontalDragEnd: (details) {
                      if ((details.primaryVelocity ?? 0) > 0) _chooseEvidence();
                    },
                    child: InkWell(
                      onTap: _chooseEvidence,
                      borderRadius: BorderRadius.circular(16),
                      child: DriverCard(
                        border: true,
                        padding: 14,
                        child: Row(
                          children: [
                            Container(
                              width: 40,
                              height: 40,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: DriverColors.canvas,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const FigmaAsset(
                                'incident-imgIconMaynh',
                                width: 24,
                                height: 24,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    _evidence
                                        ? 'Đã chọn ảnh mẫu →'
                                        : 'Thêm ảnh →',
                                    style: driverText(
                                      14,
                                      FontWeight.w500,
                                      DriverColors.navy,
                                    ),
                                  ),
                                  Text(
                                    _evidence
                                        ? 'Minh họa · Chưa tải lên'
                                        : 'Không bắt buộc',
                                    style: driverText(
                                      12,
                                      FontWeight.w400,
                                      DriverColors.secondary,
                                    ),
                                  ),
                                ],
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
          ),
        ),
      ],
    ),
  );
}

class _OperationHeading extends StatelessWidget {
  const _OperationHeading(
    this.title, {
    required this.prefix,
    required this.subtitle,
    this.trailing,
  });
  final String title, subtitle, prefix;
  final Widget? trailing;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(16, 8, 24, 14),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        IconButton(
          tooltip: 'Quay lại',
          onPressed: () => Navigator.maybePop(context),
          constraints: const BoxConstraints.tightFor(width: 36, height: 36),
          padding: EdgeInsets.zero,
          icon: FigmaAsset('$prefix-imgGroup', width: 7.8, height: 13.8),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: driverText(22, FontWeight.w700, DriverColors.navy),
              ),
              const SizedBox(height: 10),
              Text(
                subtitle,
                style: driverText(12, FontWeight.w400, DriverColors.secondary),
              ),
            ],
          ),
        ),
        ?trailing,
      ],
    ),
  );
}

class _Labelled extends StatelessWidget {
  const _Labelled(this.label, this.child);
  final String label;
  final Widget child;
  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(label, style: driverText(14, FontWeight.w500, DriverColors.navy)),
      const SizedBox(height: 8),
      child,
    ],
  );
}

class _PickerField extends StatelessWidget {
  const _PickerField(
    this.label,
    this.value, {
    required this.prefix,
    required this.onTap,
  });
  final String label, value, prefix;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => _Labelled(
    label,
    InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        constraints: const BoxConstraints(minHeight: 56),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          border: Border.all(color: DriverColors.border),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                value,
                style: driverText(14, FontWeight.w500, DriverColors.navy),
              ),
            ),
            const SizedBox(width: 12),
            FigmaAsset('$prefix-imgVutChnGiaTr', width: 20, height: 20),
          ],
        ),
      ),
    ),
  );
}

class _ChoiceRow extends StatelessWidget {
  const _ChoiceRow({
    required this.label,
    required this.choices,
    required this.selected,
    required this.onChanged,
    this.warning = false,
  });
  final String label, selected;
  final List<String> choices;
  final ValueChanged<String> onChanged;
  final bool warning;
  @override
  Widget build(BuildContext context) => Column(
    children: [
      Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: driverText(14, FontWeight.w500, DriverColors.navy),
            ),
          ),
          Text(
            '↔',
            style: driverText(12, FontWeight.w400, DriverColors.secondary),
          ),
        ],
      ),
      const SizedBox(height: 8),
      SizedBox(
        height: 40,
        child: LayoutBuilder(
          builder: (context, box) => SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                for (var i = 0; i < choices.length; i++) ...[
                  if (i > 0) const SizedBox(width: 8),
                  GestureDetector(
                    onHorizontalDragEnd: (details) {
                      final index = choices.indexOf(selected);
                      final direction = (details.primaryVelocity ?? 0) < 0
                          ? 1
                          : -1;
                      onChanged(
                        choices[(index + direction).clamp(
                          0,
                          choices.length - 1,
                        )],
                      );
                    },
                    child: InkWell(
                      onTap: () => onChanged(choices[i]),
                      borderRadius: BorderRadius.circular(16),
                      child: Container(
                        width: ((box.maxWidth - 16) / 3).clamp(
                          104.0,
                          double.infinity,
                        ),
                        height: 40,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          color: choices[i] != selected
                              ? Colors.white
                              : warning
                              ? DriverColors.cream
                              : DriverColors.teal,
                          border: Border.all(
                            color: choices[i] == selected
                                ? warning
                                      ? DriverColors.orange
                                      : DriverColors.teal
                                : DriverColors.border,
                          ),
                        ),
                        child: Text(
                          choices[i],
                          style: driverText(
                            warning ? 12 : 14,
                            FontWeight.w500,
                            choices[i] != selected
                                ? DriverColors.secondary
                                : warning
                                ? DriverColors.navy
                                : Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    ],
  );
}

class _ActionFooter extends StatelessWidget {
  const _ActionFooter({
    required this.label,
    required this.prefix,
    required this.onComplete,
    this.links,
  });
  final String label, prefix;
  final VoidCallback onComplete;
  final Widget? links;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(40, 14, 40, 4),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SwipeAction(
          label: label,
          onComplete: onComplete,
          arrowAsset: '$prefix-imgFrame',
          chevronAsset: '$prefix-imgFrame1',
        ),
        if (links != null) ...[const SizedBox(height: 4), links!],
      ],
    ),
  );
}

class _BackLink extends StatelessWidget {
  const _BackLink(this.label);
  final String label;
  @override
  Widget build(BuildContext context) => TextButton(
    onPressed: () => Navigator.maybePop(context),
    style: _linkStyle,
    child: Text(
      label,
      style: driverText(12, FontWeight.w400, DriverColors.secondary),
    ),
  );
}

class _DetailLine extends StatelessWidget {
  const _DetailLine(this.asset, this.label, this.value);
  final String asset, label, value;
  @override
  Widget build(BuildContext context) => Row(
    children: [
      FigmaAsset(asset, width: 24, height: 24),
      const SizedBox(width: 12),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: driverText(12, FontWeight.w400, DriverColors.secondary),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: driverText(14, FontWeight.w500, DriverColors.navy),
            ),
          ],
        ),
      ),
    ],
  );
}

final _linkStyle = TextButton.styleFrom(
  padding: EdgeInsets.zero,
  minimumSize: const Size(0, 32),
  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
);

final _fieldDecoration = InputDecoration(
  contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 18),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(16),
    borderSide: const BorderSide(color: DriverColors.border),
  ),
  enabledBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(16),
    borderSide: const BorderSide(color: DriverColors.border),
  ),
);

InputDecoration _noteDecoration(String hint) => InputDecoration(
  hintText: hint,
  hintStyle: driverText(14, FontWeight.w500, DriverColors.secondary),
  filled: true,
  fillColor: DriverColors.canvas,
  contentPadding: const EdgeInsets.all(16),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(16),
    borderSide: BorderSide.none,
  ),
);

Future<String?> _pick(
  BuildContext context,
  String title,
  List<String> options,
) => showModalBottomSheet<String>(
  context: context,
  showDragHandle: true,
  builder: (context) => SafeArea(
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            style: driverText(18, FontWeight.w600, DriverColors.navy),
          ),
          const SizedBox(height: 12),
          for (final option in options)
            ListTile(
              title: Text(option),
              onTap: () => Navigator.pop(context, option),
            ),
        ],
      ),
    ),
  ),
);

Future<DateTime?> _pickDateTime(BuildContext context, DateTime current) async {
  final date = await showDatePicker(
    context: context,
    initialDate: current,
    firstDate: DateTime(2020),
    lastDate: DateTime(2100),
  );
  if (!context.mounted || date == null) return null;
  final time = await showTimePicker(
    context: context,
    initialTime: TimeOfDay.fromDateTime(current),
  );
  if (time == null) return null;
  return DateTime(date.year, date.month, date.day, time.hour, time.minute);
}

String _clock(DateTime date) =>
    '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
String _date(DateTime date) =>
    '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
String _dateTime(DateTime date) => '${_date(date)} · ${_clock(date)}';
