import 'package:flutter/material.dart';

import 'demo_data.dart';
import 'design_system.dart';

/// Các kết quả không cho phép xác nhận vé trong phiên minh họa.
enum TicketResultKind { notFound, wrongTrip, cancelled, refunded }

/// Hiển thị kết quả vé lỗi mà không lộ thông tin hành khách của chuyến khác.
class TicketResultScreen extends StatelessWidget {
  const TicketResultScreen({
    super.key,
    required this.trip,
    required this.code,
    required this.kind,
  });
  final DemoTrip trip;
  final String code;
  final TicketResultKind kind;

  @override
  Widget build(BuildContext context) {
    final (node, emblem, title, message, color) = switch (kind) {
      TicketResultKind.notFound => (
        '2080-1135',
        'imgEmployeeTicketEmblemKhongTimThyVe',
        'Không tìm thấy vé',
        'Nhập lại mã hoặc quét lại QR.',
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
                  'Chuyến ${trip.id} · 14/10/2026',
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
                                  '14/10/2026',
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
  });
  final DemoTrip trip;
  final DemoPassenger passenger;
  @override
  Widget build(BuildContext context) => DriverPage(
    background: DriverColors.cream,
    statusAsset: 'ticket-refresh-1834-668-imgTinHiuWiFiPin',
    bottom: Padding(
      padding: const EdgeInsets.fromLTRB(40, 8, 40, 16),
      child: SwipeAction(
        label: 'Quét vé tiếp',
        filled: true,
        arrowAsset: 'ticket-refresh-1834-668-imgFrame',
        chevronAsset: 'ticket-refresh-1834-668-imgFrame1',
        onComplete: () => Navigator.of(context).pushReplacement(
          MaterialPageRoute<void>(builder: (_) => ScannerScreen(trip: trip)),
        ),
      ),
    ),
    child: Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: SizedBox(
            height: 28,
            child: IconButton(
              padding: EdgeInsets.zero,
              tooltip: 'Quay lại',
              onPressed: () => Navigator.maybePop(context),
              icon: const Icon(Icons.chevron_left),
            ),
          ),
        ),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(24, 4, 24, 16),
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
                'Đã lên xe · Bản mẫu',
                textAlign: TextAlign.center,
                style: driverText(28, FontWeight.w700, const Color(0xff157a48)),
              ),
              const SizedBox(height: 12),
              Text(
                'Chuyến ${trip.id} · 14/10/2026',
                textAlign: TextAlign.center,
                style: driverText(14, FontWeight.w500, DriverColors.secondary),
              ),
              const SizedBox(height: 28),
              _PhysicalTicket(trip: trip, passenger: passenger),
              const SizedBox(height: 20),
              DriverCard(
                padding: 20,
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            '${trip.boardedCount} / ${trip.passengers.length} đã lên xe',
                            style: driverText(
                              18,
                              FontWeight.w600,
                              DriverColors.teal,
                            ),
                          ),
                        ),
                        Text(
                          'Còn ${trip.passengers.length - trip.boardedCount} khách',
                          style: driverText(
                            12,
                            FontWeight.w400,
                            DriverColors.secondary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    LinearProgressIndicator(
                      value: trip.passengers.isEmpty
                          ? 0
                          : trip.boardedCount / trip.passengers.length,
                      minHeight: 6,
                      borderRadius: BorderRadius.circular(3),
                      backgroundColor: DriverColors.border,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Chỉ lưu trong phiên xem thử, chưa gửi máy chủ.',
                textAlign: TextAlign.center,
                style: driverText(12, FontWeight.w400, DriverColors.secondary),
              ),
            ],
          ),
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

/// Khung quét vé minh họa, chưa truy cập camera hay xác minh với máy chủ.
class ScannerScreen extends StatelessWidget {
  const ScannerScreen({
    super.key,
    required this.trip,
    this.initiallyOffline = false,
  });
  final DemoTrip trip;
  final bool initiallyOffline;
  @override
  Widget build(BuildContext context) => DriverPage(
    background: const Color(0xff111317),
    lightStatus: true,
    indicatorBackground: DriverColors.cream,
    statusAsset: 'scanner-imgTinHiuWiFiPin',
    child: Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 2, 24, 0),
          child: Row(
            children: [
              IconButton(
                tooltip: 'Quay lại',
                onPressed: () => Navigator.pop(context),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints.tightFor(
                  width: 24,
                  height: 44,
                ),
                icon: const FigmaAsset(
                  'scanner-imgGroup',
                  width: 8,
                  height: 14,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Quét vé',
                  style: driverText(22, FontWeight.w700, Colors.white),
                ),
              ),
              IconButton(
                tooltip: 'Đèn pin',
                onPressed: () => showDemoNotice(
                  context,
                  'Camera và đèn pin chưa bật trong bản xem thử.',
                ),
                icon: const FigmaAsset(
                  'scanner-imgDenPinNutSetTtIcon',
                  width: 24,
                  height: 24,
                ),
              ),
              IconButton(
                tooltip: 'Cài đặt camera',
                onPressed: () => showDemoNotice(
                  context,
                  'Bản xem thử chưa yêu cầu quyền camera.',
                ),
                icon: const FigmaAsset(
                  'scanner-imgCaiDtCameraIcon',
                  width: 24,
                  height: 24,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: LayoutBuilder(
            builder: (context, box) => SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: box.maxHeight),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const SizedBox(height: 18),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        FigmaAsset('scanner-imgVector', width: 45, height: 35),
                        FigmaAsset(
                          'scanner-imgVector1',
                          width: 131,
                          height: 18,
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xff26282c),
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Text(
                        '${trip.id} · ${trip.origin} → ${trip.destination}',
                        style: driverText(12, FontWeight.w400, Colors.white),
                      ),
                    ),
                    const SizedBox(height: 50),
                    SizedBox(
                      width: 280,
                      height: 280,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          if (!initiallyOffline)
                            const FigmaAsset(
                              'scanner-imgKhungNhnDinBnGoc',
                              width: 280,
                              height: 280,
                            ),
                          if (initiallyOffline)
                            for (var corner = 0; corner < 4; corner++)
                              Positioned(
                                left: corner.isEven ? 0 : null,
                                right: corner.isOdd ? 0 : null,
                                top: corner < 2 ? 0 : null,
                                bottom: corner >= 2 ? 0 : null,
                                child: Container(
                                  width: 25,
                                  height: 25,
                                  decoration: BoxDecoration(
                                    border: Border(
                                      top: corner < 2
                                          ? const BorderSide(
                                              color: Color(0xffaeafb3),
                                              width: 2,
                                            )
                                          : BorderSide.none,
                                      bottom: corner >= 2
                                          ? const BorderSide(
                                              color: Color(0xffaeafb3),
                                              width: 2,
                                            )
                                          : BorderSide.none,
                                      left: corner.isEven
                                          ? const BorderSide(
                                              color: Color(0xffaeafb3),
                                              width: 2,
                                            )
                                          : BorderSide.none,
                                      right: corner.isOdd
                                          ? const BorderSide(
                                              color: Color(0xffaeafb3),
                                              width: 2,
                                            )
                                          : BorderSide.none,
                                    ),
                                  ),
                                ),
                              ),
                          if (initiallyOffline)
                            const FigmaAsset(
                              'ticket-refresh-2082-1336-imgIconWifi',
                              width: 52,
                              height: 52,
                            )
                          else
                            Container(
                              height: 2,
                              margin: const EdgeInsets.symmetric(horizontal: 2),
                              decoration: const BoxDecoration(
                                color: DriverColors.orange,
                                boxShadow: [
                                  BoxShadow(
                                    color: DriverColors.orange,
                                    blurRadius: 5,
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const FigmaAsset(
                          'scanner-imgChMa',
                          width: 5,
                          height: 5,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Bản xem thử · Camera chưa bật',
                          style: driverText(12, FontWeight.w400, Colors.white),
                        ),
                      ],
                    ),
                    const SizedBox(height: 36),
                  ],
                ),
              ),
            ),
          ),
        ),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 22),
          decoration: const BoxDecoration(
            color: DriverColors.cream,
            borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
          ),
          child: Column(
            children: [
              Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: DriverColors.border,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                initiallyOffline ? 'Mất kết nối' : 'Sẵn sàng kiểm tra vé',
                style: driverText(24, FontWeight.w600, DriverColors.navy),
              ),
              const SizedBox(height: 8),
              Text(
                initiallyOffline
                    ? 'Cần kết nối để xác thực vé.'
                    : 'Đặt mã QR trên vé vào khung quét.',
                style: driverText(14, FontWeight.w500, DriverColors.secondary),
              ),
              const SizedBox(height: 28),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: SwipeAction(
                  label: initiallyOffline ? 'Thử lại' : 'Nhập mã vé',
                  filled: true,
                  arrowAsset: 'scanner-imgFrame',
                  chevronAsset: 'scanner-imgFrame1',
                  onComplete: () => initiallyOffline
                      ? Navigator.of(context).pushReplacement(
                          MaterialPageRoute<void>(
                            builder: (_) => ScannerScreen(trip: trip),
                          ),
                        )
                      : openDriverPage(context, ManualTicketScreen(trip: trip)),
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

/// Nhập mã và đối chiếu chỉ trong danh sách hành khách của chuyến mẫu đang chọn.
class ManualTicketScreen extends StatefulWidget {
  const ManualTicketScreen({super.key, required this.trip});
  final DemoTrip trip;
  @override
  State<ManualTicketScreen> createState() => _ManualTicketScreenState();
}

class _ManualTicketScreenState extends State<ManualTicketScreen> {
  final _code = TextEditingController();
  String? _error;
  @override
  void dispose() {
    _code.dispose();
    super.dispose();
  }

  void _verify() {
    final code = _code.text.trim().toUpperCase();
    if (code.isEmpty) {
      setState(() => _error = 'Nhập mã vé cần kiểm tra.');
      return;
    }
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
      FocusScope.of(context).unfocus();
      openDriverPage(
        context,
        TicketResultScreen(trip: widget.trip, code: code, kind: result),
      );
      return;
    }
    setState(() => _error = null);
    FocusScope.of(context).unfocus();
    openDriverPage(
      context,
      TicketScreen(trip: widget.trip, passenger: matches.first),
    );
  }

  @override
  Widget build(BuildContext context) => DriverPage(
    statusAsset: 'manual-imgTinHiuWiFiPin',
    child: Column(
      children: [
        const DriverHeading('Nhập mã vé', backAsset: 'manual-imgGroup'),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(24, 10, 24, 24),
            children: [
              Center(
                child: Container(
                  width: 80,
                  height: 80,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: DriverColors.cream,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: const FigmaAsset(
                    'manual-imgIconVe',
                    width: 40,
                    height: 40,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Nhập mã trên vé',
                textAlign: TextAlign.center,
                style: driverText(26, FontWeight.w700),
              ),
              const SizedBox(height: 12),
              Text(
                'Đối chiếu với chuyến đang soát',
                textAlign: TextAlign.center,
                style: driverText(14, FontWeight.w500, DriverColors.secondary),
              ),
              const SizedBox(height: 42),
              DriverCard(
                color: DriverColors.canvas,
                child: Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const FigmaAsset(
                        'manual-imgGroup1',
                        width: 18,
                        height: 21,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${widget.trip.origin} → ${widget.trip.destination}',
                            style: driverText(
                              16,
                              FontWeight.w600,
                              DriverColors.navy,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            '${widget.trip.id} · Khởi hành ${widget.trip.departure}',
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
              const SizedBox(height: 24),
              Text('Mã vé', style: driverText(16, FontWeight.w600)),
              const SizedBox(height: 12),
              TextField(
                controller: _code,
                textCapitalization: TextCapitalization.characters,
                autocorrect: false,
                style: driverText(22, FontWeight.w600),
                onChanged: (_) {
                  if (_error != null) setState(() => _error = null);
                },
                decoration: InputDecoration(
                  hintText:
                      widget.trip.passengers.firstOrNull?.ticket ?? 'Mã vé',
                  errorText: _error,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 22,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(
                      color: DriverColors.teal,
                      width: 1.5,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Mã được in trên vé hoặc vé điện tử.',
                style: driverText(12, FontWeight.w400, DriverColors.secondary),
              ),
              const SizedBox(height: 24),
              InkWell(
                onTap: () => Navigator.pop(context),
                borderRadius: BorderRadius.circular(16),
                child: DriverCard(
                  border: true,
                  child: Row(
                    children: [
                      const FigmaAsset(
                        'manual-imgIconQr',
                        width: 24,
                        height: 24,
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Hoặc quét mã QR',
                              style: driverText(
                                16,
                                FontWeight.w600,
                                DriverColors.teal,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(40, 14, 40, 12),
          child: Column(
            children: [
              SwipeAction(
                label: 'Kiểm tra vé',
                filled: true,
                onComplete: _verify,
                arrowAsset: 'manual-imgFrame',
                chevronAsset: 'manual-imgFrame1',
              ),
              const SizedBox(height: 8),
              Text(
                'Bản mẫu · Chưa kiểm tra vé qua máy chủ',
                style: driverText(12, FontWeight.w400, DriverColors.secondary),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

/// Vé minh họa và trạng thái lên xe trong phiên xem thử.
class TicketScreen extends StatefulWidget {
  const TicketScreen({super.key, required this.trip, required this.passenger});
  final DemoTrip trip;
  final DemoPassenger passenger;
  @override
  State<TicketScreen> createState() => _TicketScreenState();
}

class _TicketScreenState extends State<TicketScreen> {
  @override
  Widget build(BuildContext context) {
    final trip = widget.trip;
    final passenger = widget.passenger;
    if (passenger.boarded) {
      return BoardingSuccessScreen(trip: trip, passenger: passenger);
    }
    return DriverPage(
      background: DriverColors.cream,
      statusAsset: 'ticket-imgTinHiuWiFiPin',
      child: Column(
        children: [
          DriverHeading(
            'Quét vé  ›  Đối chiếu',
            back: false,
            subtitle: '${trip.id} · ${trip.departure}',
            background: DriverColors.cream,
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: DriverCard(
                    color: const Color(0xffedfbf3),
                    padding: 12,
                    child: Row(
                      children: [
                        const FigmaAsset(
                          'ticket-imgGroup',
                          width: 29,
                          height: 29,
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                passenger.boarded
                                    ? 'Đã lên xe · Bản mẫu'
                                    : 'Vé hợp lệ · Bản mẫu',
                                style: driverText(
                                  16,
                                  FontWeight.w600,
                                  const Color(0xff157a48),
                                ),
                              ),
                              Text(
                                'Đúng chuyến ${trip.id}',
                                style: driverText(
                                  12,
                                  FontWeight.w400,
                                  const Color(0xff157a48),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                _PhysicalTicket(trip: trip, passenger: passenger),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () async {
                      await openDriverPage(
                        context,
                        PassengerStatusScreen(trip: trip, passenger: passenger),
                      );
                      if (mounted) setState(() {});
                    },
                    child: const Text('Cập nhật khách'),
                  ),
                ),
                const SizedBox(height: 16),
                DriverCard(
                  child: Row(
                    children: [
                      const FigmaAsset(
                        'ticket-imgIconBus',
                        width: 20,
                        height: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${trip.plate} · 14/10/2026',
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
          Padding(
            padding: const EdgeInsets.fromLTRB(40, 8, 40, 8),
            child: Column(
              children: [
                SwipeAction(
                  label: passenger.boarded
                      ? 'Đã xác nhận trong bản mẫu'
                      : 'Xác nhận lên xe',
                  enabled: !passenger.boarded,
                  background: Colors.white,
                  arrowAsset: 'ticket-imgFrame',
                  chevronAsset: 'ticket-imgFrame1',
                  onComplete: () {
                    if (passenger.boarded) return;
                    setState(() {
                      passenger.boarded = true;
                      passenger.absent = false;
                      passenger.needsAttention = false;
                      passenger.checkedInAt = DateTime.now();
                    });
                  },
                ),
                IconButton(
                  tooltip: 'Quay lại',
                  onPressed: () => Navigator.maybePop(context),
                  icon: const Icon(Icons.arrow_back, size: 20),
                ),
              ],
            ),
          ),
        ],
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
              'ticket-imgPapierLKhuytTht',
              width: 364,
              height: 344,
            ),
            const FigmaAsset(
              'ticket-imgCungVeMauHThng',
              width: 364,
              height: 344,
            ),
            const FigmaAsset('ticket-imgVinVeLKhuyt', width: 364, height: 344),
            const Positioned(
              left: 24,
              top: 231,
              child: FigmaAsset('ticket-imgLine', width: 316, height: 1),
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
                        'ticket-imgTuynHaiNetCan',
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
