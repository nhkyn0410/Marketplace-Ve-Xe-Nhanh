import 'package:flutter/material.dart';

import 'demo_data.dart';
import 'design_system.dart';

/// Khung quét vé minh họa, chưa truy cập camera hay xác minh với máy chủ.
class ScannerScreen extends StatelessWidget {
  const ScannerScreen({super.key, required this.trip});
  final DemoTrip trip;
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
                          const FigmaAsset(
                            'scanner-imgKhungNhnDinBnGoc',
                            width: 280,
                            height: 280,
                          ),
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
                'Sẵn sàng kiểm tra vé',
                style: driverText(24, FontWeight.w600, DriverColors.navy),
              ),
              const SizedBox(height: 8),
              Text(
                'Đặt mã QR trên vé vào khung quét.',
                style: driverText(14, FontWeight.w500, DriverColors.secondary),
              ),
              const SizedBox(height: 28),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: SwipeAction(
                  label: 'Nhập mã vé',
                  filled: true,
                  arrowAsset: 'scanner-imgFrame',
                  chevronAsset: 'scanner-imgFrame1',
                  onComplete: () =>
                      openDriverPage(context, ManualTicketScreen(trip: trip)),
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
    final matches = widget.trip.passengers.where((p) => p.ticket == code);
    if (matches.isEmpty) {
      setState(
        () => _error = code.isEmpty
            ? 'Nhập mã vé cần kiểm tra.'
            : 'Không tìm thấy vé trong chuyến mẫu này.',
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
                    setState(() => passenger.boarded = true);
                    showDemoNotice(
                      context,
                      'Bản mẫu: đã đổi trạng thái trong phiên, chưa gửi máy chủ.',
                    );
                  },
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    '← Quay lại để quét vé khác',
                    style: driverText(
                      12,
                      FontWeight.w400,
                      DriverColors.secondary,
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
                        'Trạng thái',
                        style: driverText(
                          12,
                          FontWeight.w400,
                          DriverColors.secondary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        passenger.boarded ? 'Đã lên' : 'Chưa lên',
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
