import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import 'demo_data.dart';
import 'design_system.dart';
import 'employee_api.dart';
import 'trip_states.dart';

String _tripDate(DemoTrip trip) {
  final date = trip.serviceDate ?? DateTime(2026, 10, 14);
  return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
}

/// Các kết quả không cho phép xác nhận vé trong phiên minh họa.
enum TicketResultKind {
  notFound,
  wrongTrip,
  cancelled,
  refunded,
  alreadyBoarded,
  unavailable,
}

/// Hiển thị kết quả vé lỗi mà không lộ thông tin hành khách của chuyến khác.
class TicketResultScreen extends StatelessWidget {
  const TicketResultScreen({
    super.key,
    required this.trip,
    required this.code,
    required this.kind,
    this.message,
  });
  final DemoTrip trip;
  final String code;
  final TicketResultKind kind;
  final String? message;

  @override
  Widget build(BuildContext context) {
    final (node, emblem, title, message, color) = switch (kind) {
      TicketResultKind.notFound => (
        '2080-1135',
        'imgEmployeeTicketEmblemKhongTimThyVe',
        'Không tìm thấy vé',
        'Kiểm tra lại vé và quét lại QR.',
        DriverColors.teal,
      ),
      TicketResultKind.wrongTrip => (
        '2080-1177',
        'imgEmployeeTicketEmblemVeThucChuynKhac',
        'Vé thuộc chuyến khác',
        'Đối chiếu lại chuyến trên vé.',
        DriverColors.warning,
      ),
      TicketResultKind.cancelled => (
        '2080-1220',
        'imgEmployeeTicketEmblemVeDaHy',
        'Vé đã hủy',
        'Vé đã hủy không còn hiệu lực.',
        const Color(0xffbc2018),
      ),
      TicketResultKind.refunded => (
        '2080-1262',
        'imgEmployeeTicketEmblemVeDaHoanTin',
        'Vé đã hoàn tiền',
        'Vé đã hoàn tiền không còn hiệu lực.',
        const Color(0xffbc2018),
      ),
      TicketResultKind.alreadyBoarded => (
        '2080-1135',
        'imgEmployeeTicketEmblemKhongTimThyVe',
        'Vé đã lên xe trước đó',
        'Không ghi nhận lên xe lần nữa.',
        DriverColors.warning,
      ),
      TicketResultKind.unavailable => (
        '2080-1220',
        'imgEmployeeTicketEmblemVeDaHy',
        'Không thể xác nhận lên xe',
        this.message ?? 'Vé hoặc chuyến không còn cho phép check-in.',
        const Color(0xffbc2018),
      ),
    };
    final prefix = 'ticket-refresh-$node';
    return DriverPage(
      background: DriverColors.cream,
      statusAsset: '$prefix-imgTinHiuWiFiPin',
      bottom: Padding(
        padding: const EdgeInsets.fromLTRB(40, 8, 40, 16),
        child: SwipeAction(
          label: kind == TicketResultKind.notFound
              ? 'Quét lại'
              : 'Quét vé khác',
          filled: true,
          arrowAsset: '$prefix-imgFrame',
          chevronAsset: '$prefix-imgFrame1',
          onComplete: () => Navigator.maybePop(context),
        ),
      ),
      child: Column(
        children: [
          DriverHeading(
            'Kiểm tra vé',
            backAsset: '$prefix-imgIconBack',
            backAssetSize: const Size(20, 20),
            background: DriverColors.cream,
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
              children: [
                Center(
                  child: FigmaAsset('$prefix-$emblem', width: 112, height: 112),
                ),
                const SizedBox(height: 12),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: driverText(26, FontWeight.w700, color),
                ),
                const SizedBox(height: 12),
                Text(
                  'Chuyến ${trip.id} · ${_tripDate(trip)}',
                  textAlign: TextAlign.center,
                  style: driverText(
                    12,
                    FontWeight.w400,
                    DriverColors.secondary,
                  ),
                ),
                const SizedBox(height: 36),
                AspectRatio(
                  aspectRatio: 364 / 284,
                  child: FittedBox(
                    child: SizedBox(
                      width: 364,
                      height: 284,
                      child: Stack(
                        children: [
                          for (final name in [
                            'imgVeGiyCoLKhuyt',
                            'imgCungMauCtKhpGocVe',
                            'imgVinGocKhoetKhpHaiNa',
                            'imgDngXeKhongChmLKhuyt',
                          ])
                            FigmaAsset(
                              '$prefix-$name',
                              width: 364,
                              height: 284,
                            ),
                          Positioned(
                            left: 24,
                            right: 24,
                            top: 24,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'KIỂM TRA VÉ',
                                  style: driverText(
                                    12,
                                    FontWeight.w400,
                                    DriverColors.secondary,
                                  ),
                                ),
                                Text(
                                  trip.id,
                                  style: driverText(
                                    12,
                                    FontWeight.w400,
                                    DriverColors.teal,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Positioned(
                            left: 24,
                            right: 24,
                            top: 64,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Mã vé vừa quét',
                                  style: driverText(
                                    12,
                                    FontWeight.w400,
                                    DriverColors.secondary,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  code,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: driverText(
                                    26,
                                    FontWeight.w700,
                                    DriverColors.navy,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Positioned(
                            left: 24,
                            right: 24,
                            top: 142,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  _tripDate(trip),
                                  style: driverText(
                                    12,
                                    FontWeight.w400,
                                    DriverColors.secondary,
                                  ),
                                ),
                                Text(
                                  'Chuyến ${trip.id}',
                                  style: driverText(
                                    12,
                                    FontWeight.w400,
                                    DriverColors.secondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Positioned(
                            left: 20,
                            right: 20,
                            top: 204,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  kind == TicketResultKind.notFound
                                      ? 'CHƯA XÁC NHẬN LÊN XE'
                                      : 'KHÔNG THỂ XÁC NHẬN LÊN XE',
                                  style: driverText(12, FontWeight.w600, color),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  message,
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
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Kết quả minh họa · Chưa kiểm tra qua máy chủ',
                  textAlign: TextAlign.center,
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
    );
  }
}

/// Màn xác nhận một khách đã lên xe, chỉ lưu trong phiên dữ liệu mẫu.
class BoardingSuccessScreen extends StatelessWidget {
  const BoardingSuccessScreen({
    super.key,
    required this.trip,
    required this.passenger,
    this.scanResults,
  });
  final DemoTrip trip;
  final DemoPassenger passenger;
  final Stream<String>? scanResults;

  @override
  Widget build(BuildContext context) => DriverPage(
    background: DriverColors.cream,
    statusAsset: 'ticket-refresh-1834-668-imgTinHiuWiFiPin',
    bottom: Padding(
      padding: const EdgeInsets.fromLTRB(40, 8, 40, 38),
      child: SwipeAction(
        label: 'Xem sơ đồ ghế',
        filled: true,
        arrowAsset: 'ticket-refresh-1834-668-imgFrame',
        chevronAsset: 'ticket-refresh-1834-668-imgFrame1',
        onComplete: () => Navigator.of(context).pushReplacement(
          MaterialPageRoute<void>(
            builder: (_) => SeatMapScreen(
              trip: trip,
              lastPassenger: passenger,
              scanResults: scanResults,
            ),
          ),
        ),
      ),
    ),
    child: Column(
      children: [
        const SizedBox(height: 32),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
            children: [
              const Center(
                child: FigmaAsset(
                  'ticket-refresh-1834-668-imgXacNhnDuTichTrenVe',
                  width: 112,
                  height: 112,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Đã lên xe',
                textAlign: TextAlign.center,
                style: driverText(
                  32,
                  FontWeight.w700,
                  const Color(0xff157a48),
                ).copyWith(height: 1.25),
              ),
              const SizedBox(height: 12),
              Text(
                'Chuyến ${trip.id} · ${_tripDate(trip)}',
                textAlign: TextAlign.center,
                style: driverText(14, FontWeight.w500, DriverColors.secondary),
              ),
              const SizedBox(height: 42),
              _PhysicalTicket(trip: trip, passenger: passenger),
              const SizedBox(height: 20),
              _BoardingProgress(trip: trip),
            ],
          ),
        ),
      ],
    ),
  );
}

class _BoardingProgress extends StatelessWidget {
  const _BoardingProgress({required this.trip, this.compact = false});
  final DemoTrip trip;
  final bool compact;

  @override
  Widget build(BuildContext context) => DriverCard(
    color: compact ? DriverColors.canvas : Colors.white,
    padding: compact ? 12 : 20,
    child: Column(
      children: [
        ConstrainedBox(
          constraints: BoxConstraints(minHeight: compact ? 24 : 28),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  '${trip.boardedCount} / ${trip.ticketCount} đã lên xe',
                  style: driverText(
                    compact ? 16 : 18,
                    FontWeight.w600,
                    DriverColors.teal,
                  ),
                ),
              ),
              Text(
                'Còn ${trip.ticketCount - trip.boardedCount} khách',
                style: driverText(12, FontWeight.w400, DriverColors.secondary),
              ),
            ],
          ),
        ),
        SizedBox(height: compact ? 8 : 14),
        LinearProgressIndicator(
          value: trip.ticketCount == 0
              ? 0
              : trip.boardedCount / trip.ticketCount,
          minHeight: compact ? 4 : 6,
          borderRadius: BorderRadius.circular(3),
          backgroundColor: compact ? Colors.white : DriverColors.border,
          color: DriverColors.teal,
        ),
      ],
    ),
  );
}

/// Chỉnh trạng thái và ghi chú của khách thuộc chuyến đang phụ trách.
class PassengerStatusScreen extends StatefulWidget {
  const PassengerStatusScreen({
    super.key,
    required this.trip,
    required this.passenger,
  });
  final DemoTrip trip;
  final DemoPassenger passenger;
  @override
  State<PassengerStatusScreen> createState() => _PassengerStatusScreenState();
}

class _PassengerStatusScreenState extends State<PassengerStatusScreen> {
  late final _note = TextEditingController(text: widget.passenger.note);
  late var _selection = widget.passenger.absent
      ? 1
      : widget.passenger.needsAttention
      ? 2
      : 0;
  bool get _canMarkAbsent =>
      ['Đón khách', 'Khởi hành', 'Đang chạy'].contains(widget.trip.status);
  @override
  void dispose() {
    _note.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final passenger = widget.passenger;
    return DriverPage(
      statusBackground: DriverColors.canvas,
      statusAsset: 'ticket-refresh-1905-767-imgTinHiuWiFiPin',
      bottom: Padding(
        padding: const EdgeInsets.fromLTRB(40, 14, 40, 16),
        child: SwipeAction(
          label: 'Lưu trạng thái',
          enabled: !passenger.boarded && widget.trip.assigned,
          arrowAsset: 'ticket-refresh-1905-767-imgFrame',
          chevronAsset: 'ticket-refresh-1905-767-imgFrame1',
          onComplete: () {
            if (widget.trip.isLive) {
              showDemoNotice(
                context,
                'Chức năng lưu trạng thái khách chưa kết nối máy chủ.',
              );
              return;
            }
            if (_selection == 1 && !_canMarkAbsent) return;
            passenger.absent = _selection == 1;
            passenger.needsAttention = _selection == 2;
            passenger.note = _note.text.trim();
            Navigator.pop(context);
            showDemoNotice(
              context,
              'Đã lưu trạng thái khách trong bản mẫu, chưa gửi máy chủ.',
            );
          },
        ),
      ),
      child: Column(
        children: [
          DriverHeading(
            'Cập nhật khách',
            subtitle: '${widget.trip.id} · Vé ${passenger.ticket}',
            background: DriverColors.canvas,
            trailing: Container(
              width: 48,
              height: 48,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
              ),
              child: const FigmaAsset(
                'ticket-refresh-1905-767-imgFrame2',
                width: 27,
                height: 27,
              ),
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(24),
              children: [
                DriverCard(
                  color: DriverColors.canvas,
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              passenger.name,
                              style: driverText(22, FontWeight.w600),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              passenger.maskedPhone,
                              style: driverText(
                                12,
                                FontWeight.w400,
                                DriverColors.secondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: 56,
                        height: 56,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: DriverColors.teal,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          passenger.seat,
                          style: driverText(22, FontWeight.w700, Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Trạng thái hiện tại',
                        style: driverText(
                          12,
                          FontWeight.w400,
                          DriverColors.secondary,
                        ),
                      ),
                    ),
                    Text(
                      passenger.boarded
                          ? 'Đã lên xe'
                          : passenger.absent
                          ? 'Vắng mặt'
                          : passenger.needsAttention
                          ? 'Cần xử lý'
                          : 'Chưa lên xe',
                      style: driverText(12, FontWeight.w400, DriverColors.teal),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Text(
                  'Trạng thái mới',
                  style: driverText(14, FontWeight.w500, DriverColors.navy),
                ),
                const SizedBox(height: 12),
                for (var i = 0; i < 3; i++)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: InkWell(
                      onTap: passenger.boarded || (i == 1 && !_canMarkAbsent)
                          ? null
                          : () => setState(() => _selection = i),
                      borderRadius: BorderRadius.circular(16),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                        decoration: BoxDecoration(
                          color: _selection == i ? DriverColors.cream : null,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          children: [
                            if (i == 1 && _selection == i) ...[
                              const FigmaAsset(
                                'ticket-refresh-1905-767-imgIconKhachVng',
                                width: 22,
                                height: 22,
                              ),
                              const SizedBox(width: 20),
                            ],
                            Expanded(
                              child: Column(
                                crossAxisAlignment: _selection == i
                                    ? CrossAxisAlignment.start
                                    : CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    const [
                                      'Chưa lên',
                                      'Vắng mặt',
                                      'Cần xử lý',
                                    ][i],
                                    style: driverText(
                                      _selection == i ? 16 : 14,
                                      _selection == i
                                          ? FontWeight.w600
                                          : FontWeight.w500,
                                      _selection == i
                                          ? DriverColors.warning
                                          : DriverColors.secondary,
                                    ),
                                  ),
                                  if (i == 1 && _selection == i)
                                    Text(
                                      'Chưa có mặt tại điểm đón.',
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
                if (!_canMarkAbsent)
                  Text(
                    'Có thể ghi vắng mặt sau khi bắt đầu đón khách.',
                    style: driverText(
                      12,
                      FontWeight.w400,
                      DriverColors.secondary,
                    ),
                  ),
                if (passenger.boarded)
                  Text(
                    'Khách đã lên xe; trạng thái được giữ trong bản mẫu.',
                    style: driverText(
                      12,
                      FontWeight.w400,
                      DriverColors.secondary,
                    ),
                  ),
                const SizedBox(height: 20),
                Text(
                  'Ghi chú (không bắt buộc)',
                  style: driverText(14, FontWeight.w500),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _note,
                  maxLines: 4,
                  readOnly: passenger.boarded,
                  decoration: InputDecoration(
                    hintText: 'Thêm thông tin cần lưu ý…',
                    fillColor: DriverColors.canvas,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
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

/// Quét QR bằng camera; xác nhận vé hiện chỉ áp dụng cho dữ liệu mẫu trong phiên.
class ScannerScreen extends StatefulWidget {
  const ScannerScreen({
    super.key,
    required this.trip,
    this.initiallyOffline = false,
    this.scanResults,
  });
  final DemoTrip trip;
  final bool initiallyOffline;

  /// Nguồn QR dành cho kiểm thử và trang đối chiếu, không tạo ô nhập mã trong app.
  final Stream<String>? scanResults;

  @override
  State<ScannerScreen> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen>
    with WidgetsBindingObserver {
  MobileScannerController? _camera;
  StreamSubscription<String>? _scanSubscription;
  bool _processing = false;
  bool _restartingCamera = false;
  late bool _offline = widget.initiallyOffline;
  late CameraFacing _facing = _desktopWeb
      ? CameraFacing.front
      : CameraFacing.back;

  bool get _desktopWeb =>
      kIsWeb &&
      defaultTargetPlatform != TargetPlatform.android &&
      defaultTargetPlatform != TargetPlatform.iOS;

  MobileScannerController _createCameraController() => MobileScannerController(
    facing: _facing,
    cameraResolution: _desktopWeb
        ? const Size(1280, 720)
        : defaultTargetPlatform == TargetPlatform.android
        ? const Size(640, 480)
        : null,
    formats: const [BarcodeFormat.qrCode],
    detectionSpeed: DetectionSpeed.normal,
  );

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    if (widget.scanResults == null && !_offline && widget.trip.assigned) {
      _camera = _createCameraController();
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _scanSubscription = widget.scanResults?.listen(_acceptCode);
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final camera = _camera;
    if (camera == null ||
        !camera.value.isInitialized ||
        camera.value.isStarting ||
        camera.value.error != null ||
        _restartingCamera) {
      return;
    }
    if (state == AppLifecycleState.resumed && !_processing && !_offline) {
      unawaited(_cameraAction(camera.start));
    } else {
      unawaited(_cameraAction(camera.stop));
    }
  }

  Future<void> _cameraAction(Future<void> Function() action) async {
    try {
      await action();
    } on MobileScannerException {
      if (mounted) {
        showDemoNotice(
          context,
          'Camera chưa sẵn sàng. Kiểm tra quyền camera rồi thử lại.',
        );
      }
    } on PlatformException {
      if (mounted) {
        showDemoNotice(context, 'Thiết bị chưa hỗ trợ thao tác camera này.');
      }
    }
  }

  Future<void> _restartCamera({bool switchDirection = false}) async {
    if (_restartingCamera ||
        _processing ||
        _offline ||
        widget.scanResults != null) {
      return;
    }
    final previous = _camera;
    if (switchDirection) {
      _facing = _facing == CameraFacing.front
          ? CameraFacing.back
          : CameraFacing.front;
    }
    setState(() {
      _restartingCamera = true;
      _camera = null;
    });
    // Tháo view và listener trước khi giải phóng controller đã lỗi.
    await WidgetsBinding.instance.endOfFrame;
    if (previous != null) await _cameraAction(previous.dispose);
    if (!mounted || !widget.trip.assigned) return;
    setState(() {
      _camera = _createCameraController();
      _restartingCamera = false;
    });
  }

  Future<void> _acceptCode(String rawCode) async {
    if (!mounted || _processing || _offline || !widget.trip.assigned) return;
    if (widget.trip.isLive) {
      await _acceptLiveCode(rawCode);
      return;
    }
    final code = rawCode.trim().toUpperCase();
    if (code.isEmpty) return;
    _processing = true;
    final camera = _camera;
    if (camera != null) await _cameraAction(camera.stop);
    if (!mounted || !widget.trip.assigned) return;

    final matches = widget.trip.passengers.where((p) => p.ticket == code);
    final result = code == 'VX102CANCEL'
        ? TicketResultKind.cancelled
        : code == 'VX102REFUND'
        ? TicketResultKind.refunded
        : createDemoTrips()
              .where((t) => t.id != widget.trip.id)
              .any((t) => t.passengers.any((p) => p.ticket == code))
        ? TicketResultKind.wrongTrip
        : matches.isEmpty
        ? TicketResultKind.notFound
        : null;
    if (result != null) {
      await openDriverPage(
        context,
        TicketResultScreen(trip: widget.trip, code: code, kind: result),
      );
      if (!mounted) return;
      _processing = false;
      if (camera != null) await _cameraAction(camera.start);
      return;
    }
    final passenger = matches.first;
    if (!passenger.boarded) {
      passenger.boarded = true;
      passenger.absent = false;
      passenger.needsAttention = false;
      passenger.checkedInAt = DateTime.now();
    }
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(
        builder: (_) => BoardingSuccessScreen(
          trip: widget.trip,
          passenger: passenger,
          scanResults: widget.scanResults,
        ),
      ),
    );
  }

  Future<void> _acceptLiveCode(String rawCode) async {
    final board = widget.trip.checkInTicket;
    if (rawCode.trim().isEmpty) return;
    setState(() => _processing = true);
    final camera = _camera;
    if (camera != null) await _cameraAction(camera.stop);
    if (!mounted) return;
    var completed = false;
    try {
      if (board == null) {
        throw const EmployeeApiException(
          'UNAVAILABLE',
          'Chưa kết nối được dịch vụ soát vé.',
        );
      }
      // Token QR phân biệt hoa/thường; chỉ server quyết định vé hợp lệ.
      final passenger = await board(rawCode.trim());
      if (!mounted) return;
      completed = true;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute<void>(
          builder: (_) => BoardingSuccessScreen(
            trip: widget.trip,
            passenger: passenger,
            scanResults: widget.scanResults,
          ),
        ),
      );
    } on EmployeeTicketException catch (error) {
      if (!mounted) return;
      final kind = switch (error.code) {
        'WRONG_TRIP' => TicketResultKind.wrongTrip,
        'CANCELLED' => TicketResultKind.cancelled,
        'REFUNDED' => TicketResultKind.refunded,
        'ALREADY_CHECKED_IN' => TicketResultKind.alreadyBoarded,
        'NOT_FOUND' ||
        'TICKET_NOT_FOUND' ||
        'INVALID_QR' => TicketResultKind.notFound,
        _ => TicketResultKind.unavailable,
      };
      await openDriverPage(
        context,
        TicketResultScreen(
          trip: widget.trip,
          code: error.ticketCode ?? 'Không xác định',
          kind: kind,
          message: error.message,
        ),
      );
    } on EmployeeApiException catch (error) {
      if (!mounted) return;
      await showDialog<void>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Chưa xác nhận lên xe'),
          content: Text(error.message),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Đóng'),
            ),
          ],
        ),
      );
    } catch (_) {
      if (!mounted) return;
      showDemoNotice(
        context,
        'Chưa xác nhận được kết quả từ máy chủ. Kiểm tra lại vé trước khi thử lại.',
      );
    } finally {
      if (mounted && !completed) {
        setState(() => _processing = false);
        if (camera != null && !_offline) await _cameraAction(camera.start);
      }
    }
  }

  void _retryOffline() {
    setState(() {
      _offline = false;
      if (widget.scanResults == null) {
        _camera = _createCameraController();
      }
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    unawaited(_scanSubscription?.cancel());
    unawaited(_camera?.dispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.trip.assigned) {
      return TripAccessScreen(onReturn: () => Navigator.maybePop(context));
    }
    return DriverPage(
      background: const Color(0xff111317),
      lightStatus: true,
      indicatorColor: Colors.white,
      statusAsset: 'scanner-imgTinHiuWiFiPin',
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 2, 24, 14),
            child: Row(
              children: [
                IconButton(
                  tooltip: 'Quay lại',
                  onPressed: () => Navigator.maybePop(context),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints.tightFor(
                    width: 24,
                    height: 44,
                  ),
                  icon: const FigmaAsset(
                    'scanner-imgGroup',
                    width: 7.8,
                    height: 13.8,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Quét vé',
                    style: driverText(22, FontWeight.w700, Colors.white),
                  ),
                ),
                _cameraButton('Đèn pin', 'scanner-imgDenPinNutSetTtIcon', () {
                  final camera = _camera;
                  if (camera == null ||
                      camera.value.torchState == TorchState.unavailable) {
                    showDemoNotice(
                      context,
                      'Đèn pin không khả dụng trên thiết bị này.',
                    );
                  } else {
                    unawaited(_cameraAction(camera.toggleTorch));
                  }
                }),
                const SizedBox(width: 8),
                _cameraButton(
                  'Cài đặt camera',
                  'scanner-imgCaiDtCameraIcon',
                  () => showModalBottomSheet<void>(
                    context: context,
                    backgroundColor: Colors.white,
                    showDragHandle: true,
                    builder: (sheetContext) => SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Camera quét vé',
                              style: driverText(
                                22,
                                FontWeight.w700,
                                DriverColors.navy,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'Cho phép camera trong cài đặt trình duyệt hoặc ứng dụng. Kết quả soát vé hiện chỉ lưu trong phiên xem thử.',
                              style: driverText(
                                14,
                                FontWeight.w400,
                                DriverColors.secondary,
                              ),
                            ),
                            const SizedBox(height: 16),
                            TextButton(
                              onPressed: () {
                                Navigator.pop(sheetContext);
                                unawaited(
                                  _restartCamera(switchDirection: true),
                                );
                              },
                              child: const Text('Đổi camera'),
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
          Expanded(
            child: LayoutBuilder(
              builder: (context, box) => Stack(
                children: [
                  if (_camera != null)
                    Positioned.fill(
                      child: MobileScanner(
                        key: ObjectKey(_camera),
                        controller: _camera,
                        onDetect: (capture) {
                          final code = capture.barcodes.firstOrNull?.rawValue;
                          if (code != null) unawaited(_acceptCode(code));
                        },
                        placeholderBuilder: (_) =>
                            const ColoredBox(color: Color(0xff111317)),
                        errorBuilder: (context, error) =>
                            const ColoredBox(color: Color(0xff111317)),
                      ),
                    ),
                  SingleChildScrollView(
                    child: SizedBox(
                      width: box.maxWidth,
                      height: 547,
                      child: Stack(
                        alignment: Alignment.topCenter,
                        children: [
                          const Positioned(
                            top: 10,
                            child: SizedBox(
                              height: 44.966,
                              child: Row(
                                children: [
                                  FigmaAsset(
                                    'scanner-imgVector',
                                    width: 44.9661,
                                    height: 34.3377,
                                  ),
                                  FigmaAsset(
                                    'scanner-imgVector1',
                                    width: 131.034,
                                    height: 17.5649,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Positioned(
                            top: 68,
                            child: Container(
                              width: 264,
                              height: 34,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: const Color(0xff26282c),
                                borderRadius: BorderRadius.circular(17),
                              ),
                              child: Text(
                                '${widget.trip.id} · ${widget.trip.origin} → ${widget.trip.destination}',
                                style: driverText(
                                  12,
                                  FontWeight.w400,
                                  Colors.white,
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            top: 174,
                            child: SizedBox(
                              width: 280,
                              height: 280,
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  Container(
                                    decoration: const BoxDecoration(
                                      gradient: RadialGradient(
                                        colors: [
                                          Color(0x8026282c),
                                          Color(0x00111317),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const FigmaAsset(
                                    'scanner-imgKhungNhnDinBnGoc',
                                    width: 280,
                                    height: 280,
                                  ),
                                  if (!_offline)
                                    Container(
                                      width: 272,
                                      height: 1,
                                      decoration: const BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [
                                            Color(0x00f5a21a),
                                            Color(0xe6f5a21a),
                                            Color(0x00f5a21a),
                                          ],
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Color(0x66f5a21a),
                                            blurRadius: 5,
                                            spreadRadius: 1,
                                          ),
                                        ],
                                      ),
                                    )
                                  else
                                    const FigmaAsset(
                                      'ticket-refresh-2082-1336-imgIconWifi',
                                      width: 52,
                                      height: 52,
                                    ),
                                ],
                              ),
                            ),
                          ),
                          Positioned(
                            top: 486,
                            child: Row(
                              children: [
                                const FigmaAsset(
                                  'scanner-imgChMa',
                                  width: 5,
                                  height: 5,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  _offline
                                      ? 'Đã tạm dừng quét'
                                      : 'Đang chờ mã vé',
                                  style: driverText(
                                    12,
                                    FontWeight.w400,
                                    Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (_camera case final camera?)
                    Positioned.fill(
                      child: ValueListenableBuilder<MobileScannerState>(
                        valueListenable: camera,
                        builder: (context, state, child) => state.error == null
                            ? const SizedBox.shrink()
                            : _cameraError(state.error!),
                      ),
                    ),
                  if (_restartingCamera || (_processing && widget.trip.isLive))
                    const Positioned.fill(
                      child: Center(
                        child: CircularProgressIndicator(
                          color: DriverColors.orange,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
          if (_offline)
            Container(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 22),
              decoration: const BoxDecoration(
                color: DriverColors.cream,
                borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
              ),
              child: Column(
                children: [
                  Text(
                    'Mất kết nối',
                    style: driverText(24, FontWeight.w600, DriverColors.navy),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Cần kết nối để xác thực vé.',
                    style: driverText(
                      14,
                      FontWeight.w500,
                      DriverColors.secondary,
                    ),
                  ),
                  const SizedBox(height: 28),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: SwipeAction(
                      label: 'Thử lại',
                      filled: true,
                      arrowAsset: 'scanner-imgFrame',
                      chevronAsset: 'scanner-imgFrame1',
                      onComplete: _retryOffline,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _cameraButton(String label, String asset, VoidCallback onPressed) =>
      SizedBox(
        width: 44,
        height: 44,
        child: IconButton(
          tooltip: label,
          style: IconButton.styleFrom(backgroundColor: const Color(0xff26282c)),
          onPressed: onPressed,
          icon: FigmaAsset(asset, width: 24, height: 24),
        ),
      );

  Widget _cameraError(MobileScannerException error) {
    final details = error.errorDetails?.message ?? '';
    final (title, message) = switch (error.errorCode) {
      MobileScannerErrorCode.permissionDenied => (
        'Chưa được cấp quyền camera',
        'Cho phép camera cho trang này trong cài đặt trình duyệt, rồi thử lại.',
      ),
      _
          when details.contains('NotReadableError') ||
              details.contains('TrackStartError') =>
        (
          'Webcam đang bận hoặc bị chặn',
          'Đóng Camera, Teams, Zoom hoặc tab khác đang dùng webcam. Kiểm tra quyền camera của Windows rồi thử lại.',
        ),
      _ when details.contains('NotFoundError') => (
        'Không tìm thấy webcam',
        'Kết nối hoặc bật webcam laptop rồi thử lại.',
      ),
      _ when details.contains('OverconstrainedError') => (
        'Camera đã chọn không khả dụng',
        'Chọn Đổi camera để thử webcam khác.',
      ),
      MobileScannerErrorCode.unsupported => (
        'Camera không khả dụng',
        'Dùng Chrome hoặc Edge tại localhost hoặc HTTPS và kiểm tra webcam đã được kết nối.',
      ),
      _ => (
        'Không mở được camera',
        'Thử mở lại hoặc đổi camera. Nếu vẫn lỗi, đóng các ứng dụng khác đang dùng webcam.',
      ),
    };
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 12, 24, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              textAlign: TextAlign.center,
              style: driverText(16, FontWeight.w600, Colors.white),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: driverText(12, FontWeight.w400, Colors.white),
            ),
            TextButton(
              onPressed: () {
                unawaited(_restartCamera());
              },
              child: const Text(
                'Thử mở camera',
                style: TextStyle(color: DriverColors.orange),
              ),
            ),
            TextButton(
              onPressed: () => unawaited(_restartCamera(switchDirection: true)),
              child: const Text(
                'Đổi camera',
                style: TextStyle(color: DriverColors.orange),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Sơ đồ ghế theo chuyến, chỉ hiển thị tình trạng lên xe và không cho bán hoặc đổi ghế.
class SeatMapScreen extends StatelessWidget {
  const SeatMapScreen({
    super.key,
    required this.trip,
    this.lastPassenger,
    this.scanResults,
  });
  final DemoTrip trip;
  final DemoPassenger? lastPassenger;
  final Stream<String>? scanResults;

  @override
  Widget build(BuildContext context) {
    if (!trip.assigned) {
      return TripAccessScreen(onReturn: () => Navigator.maybePop(context));
    }
    final passengers = {
      for (final passenger in trip.passengers) passenger.seat: passenger,
    };
    return DriverPage(
      statusAsset: 'seat-map-imgTinHiuWiFiPin',
      bottom: Padding(
        padding: const EdgeInsets.fromLTRB(40, 14, 40, 32),
        child: SwipeAction(
          label: 'Quét vé tiếp',
          arrowAsset: 'seat-map-imgFrame',
          chevronAsset: 'seat-map-imgFrame1',
          onComplete: () => Navigator.of(context).pushReplacement(
            MaterialPageRoute<void>(
              builder: (_) =>
                  ScannerScreen(trip: trip, scanResults: scanResults),
            ),
          ),
        ),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 8, 24, 8),
            child: Column(
              children: [
                Row(
                  children: [
                    IconButton(
                      tooltip: 'Về chi tiết chuyến',
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints.tightFor(
                        width: 32,
                        height: 40,
                      ),
                      onPressed: () => Navigator.popUntil(
                        context,
                        (route) =>
                            route.settings.name == 'TripDetailScreen' ||
                            route.isFirst,
                      ),
                      icon: const FigmaAsset(
                        'seat-map-imgQuayLi',
                        width: 20,
                        height: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Sơ đồ ghế',
                      style: driverText(22, FontWeight.w700, DriverColors.navy),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Padding(
                  padding: const EdgeInsets.only(left: 44),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      '${trip.id} · ${trip.origin} → ${trip.destination}',
                      style: driverText(
                        12,
                        FontWeight.w400,
                        DriverColors.secondary,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
              children: [
                _BoardingProgress(trip: trip, compact: true),
                const SizedBox(height: 12),
                Row(
                  children: [
                    _seatLegend('Đã lên', const Color(0xff157a48)),
                    _seatLegend('Đã đặt\nChưa lên', DriverColors.warning),
                    if (!trip.isLive)
                      _seatLegend('Trống', DriverColors.secondary),
                  ],
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xfff4f5f6),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '↑ Đầu xe',
                            style: driverText(
                              12,
                              FontWeight.w400,
                              DriverColors.secondary,
                            ),
                          ),
                          Text(
                            '${trip.seats.length} ${trip.isLive ? 'ghế có vé' : 'ghế'}',
                            style: driverText(
                              12,
                              FontWeight.w400,
                              DriverColors.secondary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      for (
                        var row = 0;
                        row < (trip.seats.length / 4).ceil();
                        row++
                      )
                        Padding(
                          padding: EdgeInsets.only(
                            bottom: row < (trip.seats.length / 4).ceil() - 1
                                ? 6
                                : 0,
                          ),
                          child: Row(
                            children: [
                              for (var column = 0; column < 4; column++) ...[
                                if (column == 2)
                                  const SizedBox(width: 52)
                                else if (column > 0)
                                  const SizedBox(width: 8),
                                Expanded(
                                  child: row * 4 + column < trip.seats.length
                                      ? _seat(
                                          trip.seats[row * 4 + column],
                                          passengers[trip.seats[row * 4 +
                                              column]],
                                        )
                                      : const SizedBox(),
                                ),
                              ],
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
                if (lastPassenger case final passenger?
                    when passenger.boarded &&
                        passengers[passenger.seat] == passenger) ...[
                  const SizedBox(height: 12),
                  Container(
                    constraints: const BoxConstraints(minHeight: 48),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xffedfbf3),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        const FigmaAsset(
                          'seat-map-imgXacNhn',
                          width: 20,
                          height: 20,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            '${passenger.seat} · ${passenger.name}',
                            style: driverText(
                              14,
                              FontWeight.w500,
                              const Color(0xff157a48),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _seatLegend(String label, Color color) => Expanded(
    child: ConstrainedBox(
      constraints: const BoxConstraints(minHeight: 36),
      child: Row(
        children: [
          Container(
            width: 16,
            height: 16,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(5),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              label,
              style: driverText(12, FontWeight.w400, DriverColors.secondary),
            ),
          ),
        ],
      ),
    ),
  );

  Widget _seat(String code, DemoPassenger? passenger) {
    final boarded = passenger?.boarded ?? false;
    final empty = passenger == null;
    final highlighted = boarded && identical(lastPassenger, passenger);
    final color = empty
        ? DriverColors.secondary
        : boarded
        ? const Color(0xff157a48)
        : DriverColors.warning;
    final label = empty
        ? 'Trống'
        : boarded
        ? 'Đã lên'
        : 'Chưa lên';
    return Semantics(
      label: 'Ghế $code, $label',
      child: Container(
        key: ValueKey('seat-$code'),
        constraints: const BoxConstraints(minHeight: 40),
        padding: EdgeInsets.symmetric(vertical: highlighted ? 1 : 2),
        decoration: BoxDecoration(
          color: empty
              ? Colors.white
              : boarded
              ? const Color(0xffedfbf3)
              : DriverColors.cream,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            width: highlighted ? 2 : 1,
            color: empty
                ? DriverColors.border
                : highlighted
                ? const Color(0xff157a48)
                : boarded
                ? const Color(0xff8de5b6)
                : const Color(0xfff9d994),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  child: Text(
                    code,
                    style: driverText(14, FontWeight.w500, color),
                  ),
                ),
                if (boarded) ...[
                  const SizedBox(width: 4),
                  const FigmaAsset(
                    'seat-map-imgDuTichDaLen',
                    width: 12,
                    height: 12,
                  ),
                ],
              ],
            ),
            Text(label, style: driverText(10, FontWeight.w400, color)),
          ],
        ),
      ),
    );
  }
}

class _PhysicalTicket extends StatelessWidget {
  const _PhysicalTicket({required this.trip, required this.passenger});
  final DemoTrip trip;
  final DemoPassenger passenger;
  @override
  Widget build(BuildContext context) => AspectRatio(
    aspectRatio: 364 / 344,
    child: FittedBox(
      fit: BoxFit.contain,
      child: SizedBox(
        width: 364,
        height: 344,
        child: Stack(
          children: [
            const FigmaAsset(
              'ticket-refresh-1834-668-imgPapierLKhuytTht',
              width: 364,
              height: 344,
            ),
            const FigmaAsset(
              'ticket-refresh-1834-668-imgCungVeMauHThng',
              width: 364,
              height: 344,
            ),
            const FigmaAsset(
              'ticket-refresh-1834-668-imgVinVeLKhuyt',
              width: 364,
              height: 344,
            ),
            const Positioned(
              left: 24,
              top: 231,
              child: FigmaAsset(
                'ticket-refresh-1834-668-imgLine',
                width: 316,
                height: 1,
              ),
            ),
            Positioned(
              left: 24,
              right: 24,
              top: 20,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'VÉ HÀNH KHÁCH',
                          style: driverText(
                            12,
                            FontWeight.w400,
                            DriverColors.secondary,
                          ),
                        ),
                      ),
                      Text(
                        trip.id,
                        style: driverText(
                          12,
                          FontWeight.w400,
                          DriverColors.teal,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    passenger.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: driverText(22, FontWeight.w600, DriverColors.navy),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    passenger.maskedPhone,
                    style: driverText(
                      12,
                      FontWeight.w400,
                      DriverColors.secondary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              trip.origin,
                              style: driverText(
                                20,
                                FontWeight.w600,
                                DriverColors.navy,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Đi · ${trip.departure}',
                              style: driverText(
                                12,
                                FontWeight.w400,
                                DriverColors.secondary,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              trip.pickup,
                              style: driverText(
                                12,
                                FontWeight.w400,
                                DriverColors.secondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const FigmaAsset(
                        'ticket-refresh-1834-668-imgTuynHaiNetCan',
                        width: 84,
                        height: 24,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              trip.destination,
                              style: driverText(
                                20,
                                FontWeight.w600,
                                DriverColors.navy,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Điểm trả',
                              style: driverText(
                                12,
                                FontWeight.w400,
                                DriverColors.secondary,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              trip.dropoff,
                              textAlign: TextAlign.right,
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
            Positioned(
              left: 24,
              right: 24,
              top: 256,
              child: Row(
                children: [
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      color: DriverColors.teal,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Ghế',
                          style: driverText(
                            12,
                            FontWeight.w400,
                            Colors.white70,
                          ),
                        ),
                        Text(
                          passenger.seat,
                          style: driverText(22, FontWeight.w600, Colors.white),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Mã vé',
                          style: driverText(
                            12,
                            FontWeight.w400,
                            DriverColors.secondary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          passenger.ticket,
                          style: driverText(
                            16,
                            FontWeight.w600,
                            DriverColors.navy,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        passenger.boarded ? 'Soát vé' : 'Trạng thái',
                        style: driverText(
                          12,
                          FontWeight.w400,
                          DriverColors.secondary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        passenger.boarded
                            ? '${(passenger.checkedInAt?.hour ?? 9).toString().padLeft(2, '0')}:${(passenger.checkedInAt?.minute ?? 41).toString().padLeft(2, '0')}'
                            : passenger.absent
                            ? 'Vắng mặt'
                            : passenger.needsAttention
                            ? 'Cần xử lý'
                            : 'Chưa lên',
                        style: driverText(
                          16,
                          FontWeight.w600,
                          DriverColors.navy,
                        ),
                      ),
                    ],
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
