/// Dữ liệu minh họa chuyến xe; không thay thế dữ liệu nhiệm vụ từ máy chủ.
class DemoTrip {
  DemoTrip({
    required this.id,
    required this.origin,
    required this.destination,
    required this.departure,
    required this.operatingNote,
    required this.passengers,
    this.status = 'Sắp khởi hành',
  });
  final String id;
  final String origin;
  final String destination;
  final String departure;
  final String operatingNote;
  final List<DemoPassenger> passengers;
  String status;
  final List<
    ({
      String title,
      String time,
      String note,
      DateTime occurredAt,
      String location,
      String vehicle,
      int delay,
    })
  >
  journal = [];
  String get pickup =>
      origin == 'TP.HCM' ? 'Bến xe Miền Đông' : 'Bến xe Đà Lạt';
  String get dropoff =>
      destination == 'Đà Lạt' ? 'Bến xe Đà Lạt' : 'Bến xe Miền Đông';
  String get plate => '51B-123.45';
  int get boardedCount => passengers.where((p) => p.boarded).length;
}

/// Hành khách mẫu chỉ chứa số liên hệ đã che.
class DemoPassenger {
  DemoPassenger(this.name, this.seat, this.ticket, this.maskedPhone);
  final String name;
  final String seat;
  final String ticket;
  final String maskedPhone;
  bool boarded = false;
}

/// Tạo mới bộ dữ liệu Figma mỗi lần vào bản xem thử.
List<DemoTrip> createDemoTrips() => [
  DemoTrip(
    id: 'MX102',
    origin: 'TP.HCM',
    destination: 'Đà Lạt',
    departure: '10:30',
    operatingNote: 'Có mặt tại bến trước 10:00.',
    passengers: [
      DemoPassenger('Nguyễn Văn An', 'A01', 'VX102001', '0*** *** 789'),
      DemoPassenger('Trần Thị Mai', 'A02', 'VX102002', '0*** *** 456'),
      DemoPassenger('Lê Minh Hùng', 'A03', 'VX102003', '0*** *** 123'),
      for (var i = 4; i <= 32; i++)
        DemoPassenger(
          'Khách mẫu ${i.toString().padLeft(2, '0')}',
          '${i <= 16 ? 'A' : 'B'}${(i <= 16 ? i : i - 16).toString().padLeft(2, '0')}',
          'VX102${i.toString().padLeft(3, '0')}',
          '0*** *** ***',
        ),
    ],
  ),
  DemoTrip(
    id: 'MX103',
    origin: 'Đà Lạt',
    destination: 'TP.HCM',
    departure: '17:30',
    operatingNote: 'Có mặt tại bến trước 17:00.',
    status: 'Chưa khởi hành',
    passengers: [
      for (var i = 1; i <= 28; i++)
        DemoPassenger(
          'Khách mẫu ${i.toString().padLeft(2, '0')}',
          '${i <= 16 ? 'A' : 'B'}${(i <= 16 ? i : i - 16).toString().padLeft(2, '0')}',
          'VX103${i.toString().padLeft(3, '0')}',
          '0*** *** ***',
        ),
    ],
  ),
];
