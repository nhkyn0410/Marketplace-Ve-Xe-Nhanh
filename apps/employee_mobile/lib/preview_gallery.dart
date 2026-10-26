import 'package:flutter/material.dart';

import 'demo_data.dart';
import 'design_system.dart';
import 'driver_app.dart';
import 'operation_screens.dart';
import 'profile_screens.dart';
import 'ticket_screens.dart';
import 'trip_screens.dart';
import 'trip_states.dart';

/// Chạy trang đối chiếu thiết kế riêng, không thêm công cụ thử lỗi vào luồng app.
void main() => runApp(const DriverPreviewGallery());

DemoTrip _trip([String status = 'Đang chạy']) {
  final trip = createDemoTrips().first..status = status;
  final now = DateTime(2026, 10, 14, 9, 55);
  trip.journal.add((
    title: 'Kiểm tra xe',
    time: '09:55',
    note: 'Phanh, đèn và điều hòa hoạt động bình thường.',
    occurredAt: now,
    location: trip.pickup,
    vehicle: 'Bình thường',
    delay: 0,
  ));
  for (final (title, minute) in [
    ('Đón khách', 0),
    ('Khởi hành', 32),
    ('Đang chạy', 35),
  ]) {
    if (status == 'Đón khách' && title != 'Đón khách') break;
    if (status == 'Khởi hành' && title == 'Đang chạy') break;
    trip.operationHistory.insert(0, (
      title: title,
      occurredAt: DateTime(2026, 10, 14, 10, minute),
    ));
  }
  if (status == 'Hoàn thành') {
    trip.operationHistory.insert(0, (
      title: 'Hoàn thành',
      occurredAt: DateTime(2026, 10, 14, 14),
    ));
  }
  return trip;
}

/// Danh mục màn hình Figma để xem và thử riêng từng trạng thái giao diện.
class DriverPreviewGallery extends StatelessWidget {
  const DriverPreviewGallery({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'Vé Xe Nhanh · Đối chiếu thiết kế',
    theme: employeeTheme(Brightness.light),
    builder: (context, child) => ColoredBox(
      color: const Color(0xffe7e3dd),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 412),
          child: child,
        ),
      ),
    ),
    home: const _GalleryHome(),
  );
}

class _GalleryHome extends StatelessWidget {
  const _GalleryHome();
  @override
  Widget build(BuildContext context) {
    final cases = <(String, Widget Function())>[
      (
        'Chuyến · Chưa được phân công',
        () => DriverPage(
          bottom: DriverTabs(onSelected: (_) {}),
          child: TripsScreen(trips: const [], onTabSelected: (_) {}),
        ),
      ),
      (
        'Chuyến · Đang tải',
        () => DriverPage(
          bottom: DriverTabs(onSelected: (_) {}),
          child: TripsScreen(
            trips: createDemoTrips(),
            onTabSelected: (_) {},
            initialState: AssignmentViewState.loading,
          ),
        ),
      ),
      (
        'Chuyến · Tải thất bại',
        () => DriverPage(
          bottom: DriverTabs(onSelected: (_) {}),
          child: TripsScreen(
            trips: createDemoTrips(),
            onTabSelected: (_) {},
            initialState: AssignmentViewState.failed,
          ),
        ),
      ),
      (
        'Chuyến · Ngoài phạm vi phân công',
        () => TripDetailScreen(
          trip: _trip()..assigned = false,
          onTabSelected: (_) {},
        ),
      ),
      (
        'Hành khách · Danh sách trống',
        () => PassengerScreen(
          trip: _trip()..passengers.clear(),
          onTabSelected: (_) {},
        ),
      ),
      (
        'Hành khách · Tìm kiếm và cập nhật',
        () => PassengerScreen(trip: _trip('Đón khách'), onTabSelected: (_) {}),
      ),
      (
        'Hành khách · Vắng mặt / Ghi chú',
        () {
          final trip = _trip('Đón khách');
          return PassengerStatusScreen(
            trip: trip,
            passenger: trip.passengers.first,
          );
        },
      ),
      for (final kind in TicketResultKind.values)
        (
          'Vé · ${switch (kind) {
            TicketResultKind.notFound => 'Không tìm thấy',
            TicketResultKind.wrongTrip => 'Sai chuyến',
            TicketResultKind.cancelled => 'Đã hủy',
            TicketResultKind.refunded => 'Đã hoàn tiền',
          }}',
          () => TicketResultScreen(
            trip: _trip(),
            code: kind == TicketResultKind.notFound ? 'VX10200X' : 'VX102001',
            kind: kind,
          ),
        ),
      (
        'Vé · Lên xe thành công',
        () {
          final trip = _trip();
          final passenger = trip.passengers.first
            ..boarded = true
            ..checkedInAt = DateTime(2026, 10, 14, 9, 41);
          return BoardingSuccessScreen(trip: trip, passenger: passenger);
        },
      ),
      (
        'Quét vé · Mất kết nối',
        () => ScannerScreen(trip: _trip(), initiallyOffline: true),
      ),
      (
        'Vận hành · Đón khách',
        () => OperationsScreen(trip: _trip('Đón khách')),
      ),
      (
        'Vận hành · Đã khởi hành',
        () => OperationsScreen(trip: _trip('Khởi hành')),
      ),
      (
        'Vận hành · Đang cập nhật',
        () =>
            OperationsScreen(trip: _trip('Khởi hành'), initiallyUpdating: true),
      ),
      (
        'Vận hành · Cập nhật thất bại',
        () => OperationsScreen(trip: _trip('Khởi hành'), initiallyFailed: true),
      ),
      ('Vận hành · Đang chạy', () => OperationsScreen(trip: _trip())),
      (
        'Vận hành · Hoàn thành',
        () => OperationsScreen(trip: _trip('Hoàn thành')),
      ),
      (
        'Nhật trình · Điểm dừng',
        () => JournalScreen(trip: _trip(), initialNote: 'Dừng nghỉ tại trạm.'),
      ),
      (
        'Nhật trình · Kiểm tra xe',
        () => JournalScreen(
          trip: _trip(),
          initialCategory: 'Kiểm tra xe',
          initialNote: 'Phanh, đèn và điều hòa hoạt động bình thường.',
        ),
      ),
      (
        'Nhật trình · Chi tiết kiểm tra xe',
        () => JournalDetailScreen(trip: _trip()),
      ),
      (
        'Nhật trình · Chưa tải được chi tiết',
        () => JournalDetailScreen(trip: _trip(), initiallyFailed: true),
      ),
      (
        'Nhật trình · Lưu thất bại',
        () => JournalScreen(
          trip: _trip(),
          initialCategory: 'Kiểm tra xe',
          initiallyFailed: true,
          initialNote: 'Phanh, đèn và điều hòa hoạt động bình thường.',
        ),
      ),
      ('Nhật trình · Chưa đồng bộ', () => PendingJournalScreen(trip: _trip())),
      (
        'Báo sự cố · Gửi thất bại',
        () => IncidentScreen(trip: _trip(), initiallyFailed: true),
      ),
      (
        'Thiết bị · Xác nhận thu hồi phiên',
        () =>
            const DevicesScreen(initialConfirmation: DeviceConfirmation.other),
      ),
      (
        'Thiết bị · Chỉ còn phiên hiện tại',
        () => DevicesScreen(sessions: DemoDeviceSessions(hasOther: false)),
      ),
      (
        'Thiết bị · Xác nhận đăng xuất',
        () => const DevicesScreen(
          initialConfirmation: DeviceConfirmation.current,
        ),
      ),
      (
        'Liên hệ · Chưa có email',
        () => const ContactScreen(supportEmail: null),
      ),
      ('Liên hệ · Không mở được email', () => const ContactScreen()),
    ];
    return Scaffold(
      appBar: AppBar(title: const Text('Tài xế · Thiết kế mới')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(
            'Bản xem mẫu các màn hình và trạng thái mới. Dữ liệu chỉ lưu trong phiên, chưa kết nối API.',
            style: driverText(14, FontWeight.w500, DriverColors.secondary),
          ),
          const SizedBox(height: 20),
          for (final (title, build) in cases)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.all(16),
                  alignment: Alignment.centerLeft,
                ),
                onPressed: () => openDriverPage(context, build()),
                child: Text(title),
              ),
            ),
        ],
      ),
    );
  }
}
