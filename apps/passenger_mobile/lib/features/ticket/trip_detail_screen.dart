import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mobile_shared/mobile_shared.dart';
import 'package:passenger_mobile/features/search/trip_search_form.dart';
import 'package:passenger_mobile/features/ticket/seat_selection_screen.dart';
import 'package:passenger_mobile/features/ticket/stop_picker_sheet.dart';
import 'package:passenger_mobile/features/ticket/trip_booking_api.dart';
import 'package:passenger_mobile/features/ticket/trip_detail_models.dart';
import 'package:passenger_mobile/features/ticket/trip_search_models.dart';
import 'package:share_plus/share_plus.dart';

const _detailAssets = 'assets/ticket/detail';
const _ink = Color(0xFF09243D);
const _blue = Color(0xFF2B7EAD);
const _muted = Color(0xFF607A8E);
const _surface = Color(0xFFF1F8FB);

/// Chi tiết một chuyến đang mở bán (`GET /trips/{tripId}`), chọn điểm đón / trả rồi sang chọn chỗ.
class TripDetailScreen extends StatefulWidget {
  const TripDetailScreen({
    required this.api,
    required this.tripId,
    this.fromLabel,
    this.toLabel,
    this.pickupSequence,
    this.dropoffSequence,
    this.isSignedIn = false,
    this.onBookingFinished,
    super.key,
  });

  final TripBookingApi api;
  final String tripId;
  final bool isSignedIn;
  final VoidCallback? onBookingFinished;

  /// Tên điểm đi / đến khách đã tìm (vd. "TP. Hồ Chí Minh"); không có thì dùng tên điểm đón / trả.
  final String? fromLabel;
  final String? toLabel;

  /// Điểm đón / trả khớp lần tìm; không hợp lệ thì lấy điểm đầu / cuối của chuyến.
  final int? pickupSequence;
  final int? dropoffSequence;

  @override
  State<TripDetailScreen> createState() => _TripDetailScreenState();
}

class _TripDetailScreenState extends State<TripDetailScreen> {
  TripDetail? _trip;
  String? _error;
  int? _pickup;
  int? _dropoff;
  bool _sharing = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _error = null);
    try {
      // Giá chỗ + tiêu đề theo chặng đang chọn (3.3); lần đầu theo chặng của lần tìm.
      final trip = await widget.api.loadTrip(
        widget.tripId,
        pickupSequence: _pickup ?? widget.pickupSequence,
        dropoffSequence: _dropoff ?? widget.dropoffSequence,
      );
      if (!mounted) return;
      setState(() {
        _trip = trip;
        _pickup ??= _initialPickup(trip);
        _dropoff ??= _initialDropoff(trip, _pickup);
      });
    } catch (error) {
      if (!mounted) return;
      setState(() => _error = describeBookingFailure(error));
    }
  }

  int? _initialPickup(TripDetail trip) {
    final pickups = trip.pickupStops;
    final wanted = widget.pickupSequence;
    if (pickups.any((stop) => stop.sequence == wanted)) return wanted;
    return pickups.isEmpty ? null : pickups.first.sequence;
  }

  int? _initialDropoff(TripDetail trip, int? pickup) {
    if (pickup == null) return null;
    final dropoffs = trip.dropoffStopsAfter(pickup);
    final wanted = widget.dropoffSequence;
    if (dropoffs.any((stop) => stop.sequence == wanted)) return wanted;
    return dropoffs.isEmpty ? null : dropoffs.last.sequence;
  }

  Future<void> _chooseStop({required bool pickup}) async {
    final trip = _trip;
    final current = pickup ? _pickup : _dropoff;
    if (trip == null || current == null) return;
    final stops = pickup
        ? trip.pickupStops
        : trip.dropoffStopsAfter(_pickup ?? 0);
    final selected = await showTripStopPicker(
      context,
      pickup: pickup,
      stops: stops,
      selectedSequence: current,
    );
    if (selected == null || !mounted) return;
    setState(() {
      if (pickup) {
        _pickup = selected.sequence;
        final dropoffs = trip.dropoffStopsAfter(selected.sequence);
        if (!dropoffs.any((stop) => stop.sequence == _dropoff)) {
          _dropoff = dropoffs.isEmpty ? null : dropoffs.last.sequence;
        }
      } else {
        _dropoff = selected.sequence;
      }
    });
    // Đổi chặng thì giá chỗ và tiêu đề đổi theo.
    _load();
  }

  Future<void> _openSeats() async {
    final trip = _trip;
    final pickup = _pickup;
    final dropoff = _dropoff;
    if (trip == null || pickup == null || dropoff == null) return;
    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => SeatSelectionScreen(
          api: widget.api,
          trip: trip,
          pickupSequence: pickup,
          dropoffSequence: dropoff,
          isSignedIn: widget.isSignedIn,
          onBookingFinished: widget.onBookingFinished,
        ),
      ),
    );
    // Quay lại thì sơ đồ chỗ có thể đã đổi (người khác giữ / đặt).
    if (mounted) _load();
  }

  Future<void> _shareTrip(BuildContext originContext) async {
    final trip = _trip;
    final pickup = _pickup == null ? null : trip?.stopAt(_pickup!);
    final dropoff = _dropoff == null ? null : trip?.stopAt(_dropoff!);
    if (_sharing || trip == null || pickup == null || dropoff == null) return;

    final box = originContext.findRenderObject() as RenderBox?;
    setState(() => _sharing = true);
    try {
      await SharePlus.instance.share(
        ShareParams(
          title: 'Chia sẻ chuyến đi',
          subject: '${pickup.name} → ${dropoff.name}',
          text: [
            'Chuyến đi trên Vé Xe Nhanh',
            'Nhà xe: ${trip.operatorName}',
            'Đón: ${formatVnClock(pickup.plannedAt)}, ${formatVnDate(pickup.plannedAt)} - ${pickup.name}',
            'Trả: ${formatVnClock(dropoff.plannedAt)}, ${formatVnDate(dropoff.plannedAt)} - ${dropoff.name}',
            'Loại xe: ${trip.vehicleTypeName}',
          ].join('\n'),
          sharePositionOrigin: box == null
              ? null
              : box.localToGlobal(Offset.zero) & box.size,
        ),
      );
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Chưa thể chia sẻ chuyến đi. Vui lòng thử lại.'),
        ),
      );
    } finally {
      if (mounted) setState(() => _sharing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final useTallHeader = MediaQuery.textScalerOf(context).scale(19) > 28;
    final trip = _trip;
    final pickup = trip == null || _pickup == null
        ? null
        : trip.stopAt(_pickup!);
    final dropoff = trip == null || _dropoff == null
        ? null
        : trip.stopAt(_dropoff!);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: Colors.white,
      ),
      child: Scaffold(
        key: const Key('trip-detail-screen'),
        backgroundColor: _surface,
        appBar: AppBar(
          key: const Key('trip-detail-header'),
          automaticallyImplyLeading: false,
          toolbarHeight: useTallHeader ? 80 : 64,
          titleSpacing: 14,
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
          elevation: 0,
          scrolledUnderElevation: 1,
          shadowColor: const Color(0x1A21404F),
          title: _HeroToolbar(
            onBack: () => Navigator.maybePop(context),
            onShare:
                trip == null || pickup == null || dropoff == null || _sharing
                ? null
                : _shareTrip,
          ),
        ),
        bottomNavigationBar: trip == null
            ? null
            : _BookingBar(
                price: trip.minPrice,
                onPressed: pickup == null || dropoff == null || trip.minPrice == null
                    ? null
                    : _openSeats,
              ),
        body: _buildBody(trip, pickup, dropoff),
      ),
    );
  }

  Widget _buildBody(TripDetail? trip, TripStop? pickup, TripStop? dropoff) {
    final error = _error;
    if (trip == null && error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                error,
                textAlign: TextAlign.center,
                style: const TextStyle(color: _muted),
              ),
              const SizedBox(height: 12),
              OutlinedButton(onPressed: _load, child: const Text('Thử lại')),
            ],
          ),
        ),
      );
    }
    if (trip == null) {
      return const Center(
        child: CircularProgressIndicator(key: Key('trip-detail-loading')),
      );
    }
    return ListView(
      key: const Key('trip-detail-scroll'),
      padding: EdgeInsets.zero,
      children: [
        _HeroAndOperator(
          trip: trip,
          pickup: pickup,
        ),
        _VehicleSummary(trip: trip),
        _ScheduleSection(trip: trip, pickup: pickup, dropoff: dropoff),
        if (pickup != null && dropoff != null)
          _PickupDropoffSection(
            pickup: pickup,
            dropoff: dropoff,
            onPickup: () => _chooseStop(pickup: true),
            onDropoff: () => _chooseStop(pickup: false),
          ),
        if (trip.amenityNames.isNotEmpty)
          _AmenitiesSection(names: trip.amenityNames),
        _CancellationSection(tiers: trip.cancellationTiers),
        _NoticeSection(note: trip.note),
        const SizedBox(height: 14),
      ],
    );
  }
}

class _HeroAndOperator extends StatelessWidget {
  const _HeroAndOperator({
    required this.trip,
    required this.pickup,
  });

  final TripDetail trip;
  final TripStop? pickup;

  @override
  Widget build(BuildContext context) {
    final image = trip.imageUrls.isEmpty ? null : trip.imageUrls.first;
    final heroAsset = Image.asset(
      '$_detailAssets/hero_mountain_bus.png',
      fit: BoxFit.cover,
      alignment: Alignment.center,
    );

    return Column(
      children: [
        SizedBox(
          height: 218,
          child: SizedBox.expand(
            child: image == null
                ? heroAsset
                : Image.network(
                    image,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => heroAsset,
                  ),
          ),
        ),
        Transform.translate(
          offset: const Offset(0, -12),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 7),
            child: _OperatorCard(trip: trip, pickup: pickup),
          ),
        ),
      ],
    );
  }
}

class _HeroToolbar extends StatelessWidget {
  const _HeroToolbar({required this.onBack, required this.onShare});

  final VoidCallback onBack;
  final ValueChanged<BuildContext>? onShare;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _HeaderAction(
          key: const Key('trip-detail-back'),
          icon: 'back.svg',
          tooltip: 'Quay lại',
          onTap: onBack,
        ),
        const SizedBox(width: 12),
        const Expanded(
          child: Text(
            'Chi tiết chuyến',
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: Color(0xFF082A55),
              fontSize: 19,
              fontWeight: FontWeight.w600,
              height: 1.2,
            ),
          ),
        ),
        Builder(
          builder: (context) => _HeaderAction(
            key: const Key('trip-detail-share'),
            icon: 'share.svg',
            tooltip: 'Chia sẻ chuyến đi',
            onTap: onShare == null ? null : () => onShare!(context),
          ),
        ),
      ],
    );
  }
}

class _HeaderAction extends StatelessWidget {
  const _HeaderAction({
    required this.icon,
    required this.tooltip,
    this.onTap,
    super.key,
  });

  final String icon;
  final String tooltip;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: Semantics(
        button: true,
        enabled: onTap != null,
        child: InkResponse(
          onTap: onTap,
          radius: 22,
          child: SizedBox.square(
            dimension: 40,
            child: Stack(
              alignment: Alignment.center,
              children: [
                SvgPicture.asset(
                  '$_detailAssets/header_action.svg',
                  width: 40,
                  height: 40,
                ),
                SvgPicture.asset('$_detailAssets/$icon', width: 18, height: 18),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _OperatorCard extends StatelessWidget {
  const _OperatorCard({required this.trip, required this.pickup});

  final TripDetail trip;
  final TripStop? pickup;

  @override
  Widget build(BuildContext context) {
    final date = formatVnDate(pickup?.plannedAt ?? trip.departureAt);
    return _WhiteCard(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            children: [
              OperatorInitialAvatar(
                name: trip.operatorName,
                logoUrl: trip.operatorLogoUrl,
                size: 48,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      trip.operatorName,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Color(0xFF072752),
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    _RatingLine(
                      averageRating: trip.averageRating,
                      reviewCount: trip.reviewCount,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '$date · ${trip.routeName}',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: _muted, fontSize: 13),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Container(
            key: const Key('trip-detail-operator-link'),
            constraints: const BoxConstraints(minHeight: 44),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFFEFF7FD),
              borderRadius: BorderRadius.circular(17),
            ),
            child: Row(
              key: const Key('trip-detail-operator-link-content'),
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Xem nhà xe',
                  style: TextStyle(
                    color: Color(0xFF07549D),
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 4),
                RotatedBox(
                  quarterTurns: 3,
                  child: SvgPicture.asset(
                    '$_detailAssets/chevron.svg',
                    width: 11,
                    height: 11,
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

class _RatingLine extends StatelessWidget {
  const _RatingLine({required this.averageRating, required this.reviewCount});

  final double? averageRating;
  final int reviewCount;

  @override
  Widget build(BuildContext context) {
    final rating = averageRating;
    if (rating == null || reviewCount == 0) {
      return const Text(
        'Chưa có đánh giá',
        style: TextStyle(color: _muted, fontSize: 13),
      );
    }
    return Row(
      children: [
        SvgPicture.asset('$_detailAssets/star.svg', width: 14, height: 14),
        const SizedBox(width: 4),
        Text(
          rating.toStringAsFixed(1),
          style: const TextStyle(
            color: Color(0xFF072752),
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(width: 3),
        Flexible(
          child: Text(
            '($reviewCount đánh giá)',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: _muted, fontSize: 13),
          ),
        ),
      ],
    );
  }
}

class _VehicleSummary extends StatelessWidget {
  const _VehicleSummary({required this.trip});

  final TripDetail trip;

  @override
  Widget build(BuildContext context) {
    final images = trip.imageUrls;
    final shown = trip.amenityNames.take(4).toList();
    final more = trip.amenityNames.length - shown.length;
    const fallback = ColoredBox(
      color: Color(0xFFEAF4FB),
      child: Center(
        child: Icon(Icons.directions_bus, color: _blue, size: 34),
      ),
    );
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
      child: _WhiteCard(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: SizedBox(
                    width: 104,
                    height: 76,
                    child: images.isEmpty
                        ? fallback
                        : Image.network(
                            images.first,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                fallback,
                          ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    trip.vehicleTypeName,
                    style: const TextStyle(
                      color: Color(0xFF082752),
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            if (shown.isNotEmpty) ...[
              const SizedBox(height: 12),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (final name in shown)
                    _SummaryAmenity(icon: _amenityIcon(name), label: name),
                  if (more > 0)
                    _SummaryAmenity(label: 'tiện ích khác', count: '+$more'),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Icon tiện ích theo tên trong danh mục; tên lạ thì không có icon riêng.
String? _amenityIcon(String name) {
  final value = name.toLowerCase();
  if (value.contains('wi-fi') || value.contains('wifi')) return 'wifi_full.svg';
  if (value.contains('điều hòa')) return 'snow_full.svg';
  if (value.contains('nước')) return 'water_full.svg';
  if (value.contains('sạc') || value.contains('usb')) return 'usb_full.svg';
  if (value.contains('màn hình')) return 'screen.svg';
  if (value.contains('chăn') || value.contains('gối')) return 'blanket.svg';
  if (value.contains('vệ sinh') || value.contains('wc')) return 'wc.svg';
  return null;
}

class _SummaryAmenity extends StatelessWidget {
  const _SummaryAmenity({this.icon, required this.label, this.count});

  final String? icon;
  final String label;
  final String? count;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox.square(
            dimension: 38,
            child: Stack(
              alignment: Alignment.center,
              children: [
                SvgPicture.asset(
                  '$_detailAssets/amenity_bubble.svg',
                  width: 38,
                  height: 38,
                ),
                if (count != null)
                  Text(
                    count!,
                    style: const TextStyle(
                      color: Color(0xFF006BB5),
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  )
                else if (icon != null)
                  SvgPicture.asset(
                    '$_detailAssets/$icon',
                    width: 19,
                    height: 19,
                  )
                else
                  const Icon(Icons.check_rounded, color: _blue, size: 19),
              ],
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Color(0xFF123862),
              fontSize: 12,
              height: 1.2,
            ),
          ),
        ],
      ),
    );
  }
}

/// Lịch trình các điểm dừng trong chặng khách chọn, từ điểm đón tới điểm trả.
class _ScheduleSection extends StatelessWidget {
  const _ScheduleSection({
    required this.trip,
    required this.pickup,
    required this.dropoff,
  });

  final TripDetail trip;
  final TripStop? pickup;
  final TripStop? dropoff;

  @override
  Widget build(BuildContext context) {
    final from = pickup ?? trip.stops.first;
    final to = dropoff ?? trip.stops.last;
    final stops = trip.stops
        .where(
          (stop) =>
              stop.sequence >= from.sequence && stop.sequence <= to.sequence,
        )
        .toList(growable: false);
    final minutes = to.plannedAt.difference(from.plannedAt).inMinutes;
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 16, 12, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionTitle(icon: 'map.svg', title: 'Lịch trình'),
          const SizedBox(height: 10),
          _WhiteCard(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            padding: const EdgeInsets.fromLTRB(12, 10, 12, 6),
            child: Column(
              key: const Key('trip-segment-itinerary'),
              children: [
                for (final stop in stops)
                  _ScheduleRow(
                    stop: stop,
                    highlighted:
                        stop.sequence == pickup?.sequence ||
                        stop.sequence == dropoff?.sequence,
                  ),
              ],
            ),
          ),
          const SizedBox(height: 1),
          _WhiteCard(
            borderRadius: const BorderRadius.vertical(
              bottom: Radius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Row(
              children: [
                Expanded(
                  child: _Metric(
                    icon: 'clock.svg',
                    value: formatTripDuration(minutes),
                    label: 'Thời gian di chuyển',
                  ),
                ),
                const _MetricDivider(),
                Expanded(
                  child: _Metric(
                    icon: 'pin.svg',
                    value: '${stops.length} điểm dừng',
                    label: 'Trong chặng',
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

class _ScheduleRow extends StatelessWidget {
  const _ScheduleRow({required this.stop, required this.highlighted});

  final TripStop stop;
  final bool highlighted;

  @override
  Widget build(BuildContext context) {
    final role = switch ((stop.allowPickup, stop.allowDropoff)) {
      (true, true) => 'Đón / trả',
      (true, false) => 'Đón khách',
      (false, true) => 'Trả khách',
      (false, false) => stop.type == 'REST_STOP' ? 'Dừng nghỉ' : 'Đi qua',
    };
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 46,
            child: Text(
              formatVnClock(stop.plannedAt),
              style: TextStyle(
                color: highlighted ? _blue : _ink,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Icon(
            highlighted ? Icons.radio_button_checked : Icons.circle_outlined,
            size: 14,
            color: highlighted ? _blue : const Color(0xFFB9CBD5),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  stop.name,
                  style: TextStyle(
                    color: _ink,
                    fontSize: 14,
                    fontWeight: highlighted ? FontWeight.w600 : FontWeight.w500,
                  ),
                ),
                Text(
                  '$role · ${stop.address}',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: _muted, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Metric extends StatelessWidget {
  const _Metric({required this.icon, required this.value, required this.label});

  final String icon;
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
      child: Row(
        children: [
          SvgPicture.asset('$_detailAssets/$icon', width: 17, height: 17),
          const SizedBox(width: 6),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Color(0xFF092752),
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  label,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: _muted,
                    fontSize: 13,
                    height: 1.2,
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

class _MetricDivider extends StatelessWidget {
  const _MetricDivider();

  @override
  Widget build(BuildContext context) {
    return Container(width: 1, height: 52, color: const Color(0xFFE4EEF2));
  }
}

class _PickupDropoffSection extends StatelessWidget {
  const _PickupDropoffSection({
    required this.pickup,
    required this.dropoff,
    required this.onPickup,
    required this.onDropoff,
  });

  final TripStop pickup;
  final TripStop dropoff;
  final VoidCallback onPickup;
  final VoidCallback onDropoff;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 16, 12, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionTitle(icon: 'pin.svg', title: 'Điểm đón / Điểm trả'),
          const SizedBox(height: 10),
          _LocationCard(
            key: const Key('trip-detail-pickup'),
            pickup: true,
            stop: pickup,
            onTap: onPickup,
          ),
          const SizedBox(height: 8),
          _LocationCard(
            key: const Key('trip-detail-dropoff'),
            pickup: false,
            stop: dropoff,
            onTap: onDropoff,
          ),
        ],
      ),
    );
  }
}

class _LocationCard extends StatelessWidget {
  const _LocationCard({
    required this.pickup,
    required this.stop,
    required this.onTap,
    super.key,
  });

  final bool pickup;
  final TripStop stop;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(13),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(13),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          child: Row(
            children: [
              SizedBox.square(
                dimension: 36,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    SvgPicture.asset(
                      '$_detailAssets/${pickup ? 'pickup_halo' : 'dropoff_halo'}.svg',
                      width: 36,
                      height: 36,
                    ),
                    SvgPicture.asset(
                      '$_detailAssets/${pickup ? 'pickup_pin' : 'dropoff_pin'}.svg',
                      width: 18,
                      height: 23,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${pickup ? 'Điểm đón' : 'Điểm trả'} · ${formatVnClock(stop.plannedAt)}',
                      style: TextStyle(
                        color: pickup ? const Color(0xFF1B9C68) : _muted,
                        fontSize: 13,
                      ),
                    ),
                    Text(
                      stop.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Color(0xFF092752),
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      stop.address,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: _muted,
                        fontSize: 13,
                        height: 1.25,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              RotatedBox(
                quarterTurns: 3,
                child: SvgPicture.asset(
                  '$_detailAssets/chevron.svg',
                  width: 11,
                  height: 11,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AmenitiesSection extends StatelessWidget {
  const _AmenitiesSection({required this.names});

  final List<String> names;

  @override
  Widget build(BuildContext context) {
    final useTwoColumns = MediaQuery.textScalerOf(context).scale(12) > 16;

    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 16, 12, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionTitle(icon: 'document.svg', title: 'Tiện ích trên xe'),
          const SizedBox(height: 10),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.zero,
            itemCount: names.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: useTwoColumns ? 2 : 4,
              crossAxisSpacing: 5,
              mainAxisSpacing: 5,
              mainAxisExtent: useTwoColumns ? 110 : 76,
            ),
            itemBuilder: (context, index) {
              final name = names[index];
              final icon = _amenityIcon(name);
              return _WhiteCard(
                borderRadius: BorderRadius.circular(9),
                padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 5),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (icon != null)
                      SvgPicture.asset(
                        '$_detailAssets/$icon',
                        width: 22,
                        height: 22,
                      )
                    else
                      const Icon(Icons.check_rounded, color: _blue, size: 22),
                    const SizedBox(height: 6),
                    Text(
                      name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Color(0xFF123862),
                        fontSize: 12,
                        height: 1.2,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _CancellationSection extends StatelessWidget {
  const _CancellationSection({required this.tiers});

  final List<CancellationTier> tiers;

  @override
  Widget build(BuildContext context) {
    final sorted = [...tiers]
      ..sort((a, b) => b.minHoursBefore.compareTo(a.minHoursBefore));
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 16, 12, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionTitle(icon: 'shield.svg', title: 'Chính sách hủy'),
          const SizedBox(height: 10),
          _WhiteCard(
            padding: const EdgeInsets.all(12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox.square(
                  dimension: 36,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      SvgPicture.asset(
                        '$_detailAssets/policy_backing.svg',
                        width: 36,
                        height: 36,
                      ),
                      SvgPicture.asset(
                        '$_detailAssets/policy_document.svg',
                        width: 19,
                        height: 19,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: sorted.isEmpty
                      ? const Text(
                          'Nhà xe chưa công bố mốc hoàn tiền khi hủy vé.',
                          style: TextStyle(
                            color: _ink,
                            fontSize: 13,
                            height: 1.3,
                          ),
                        )
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            for (final tier in sorted)
                              Padding(
                                padding: const EdgeInsets.only(bottom: 4),
                                child: Text(
                                  tier.minHoursBefore == 0
                                      ? 'Hủy trước giờ khởi hành: hoàn ${tier.refundPercent}%'
                                      : 'Hủy trước ít nhất ${tier.minHoursBefore} giờ: hoàn ${tier.refundPercent}%',
                                  style: const TextStyle(
                                    color: _ink,
                                    fontSize: 13,
                                    height: 1.3,
                                  ),
                                ),
                              ),
                            const Text(
                              'Sau các mốc trên: không hoàn tiền.',
                              style: TextStyle(color: _muted, fontSize: 12),
                            ),
                          ],
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

class _NoticeSection extends StatelessWidget {
  const _NoticeSection({required this.note});

  final String? note;

  @override
  Widget build(BuildContext context) {
    final extra = note?.trim();
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 16, 14, 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SvgPicture.asset('$_detailAssets/warning.svg', width: 16, height: 16),
          const SizedBox(width: 12),
          const Text(
            'Lưu ý',
            style: TextStyle(
              color: Color(0xFF082752),
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              '• Vui lòng có mặt trước giờ khởi hành tối thiểu 30 phút.\n'
              '• Mang theo giấy tờ tùy thân khi lên xe.\n'
              '• Giờ đến có thể thay đổi tùy tình hình giao thông.'
              '${extra == null || extra.isEmpty ? '' : '\n• Nhà xe: $extra'}',
              style: const TextStyle(color: _muted, fontSize: 13, height: 1.45),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.icon, required this.title});

  final String icon;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SvgPicture.asset('$_detailAssets/$icon', width: 20, height: 20),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              color: Color(0xFF082752),
              fontSize: 16,
              fontWeight: FontWeight.w600,
              height: 1.25,
            ),
          ),
        ),
      ],
    );
  }
}

class _WhiteCard extends StatelessWidget {
  const _WhiteCard({
    required this.child,
    required this.padding,
    this.borderRadius = const BorderRadius.all(Radius.circular(13)),
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final BorderRadius borderRadius;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: borderRadius,
      ),
      child: child,
    );
  }
}

class _BookingBar extends StatelessWidget {
  const _BookingBar({required this.price, required this.onPressed});

  /// Giá thấp nhất trong các chỗ còn đặt được; `null` = hết chỗ.
  final int? price;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final useLargeText = MediaQuery.textScalerOf(context).scale(15) > 20;
    final useNarrowLayout = MediaQuery.sizeOf(context).width < 360;
    final amount = price;

    return SafeArea(
      top: false,
      child: Container(
        height: useLargeText ? 176 : (useNarrowLayout ? 120 : 88),
        padding: const EdgeInsets.fromLTRB(14, 10, 14, 10),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(14)),
          boxShadow: [
            BoxShadow(
              color: Color(0x1421404F),
              offset: Offset(0, -5),
              blurRadius: 12,
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: amount == null
                  ? const Text(
                      'Chuyến đã hết chỗ',
                      style: TextStyle(color: _muted, fontSize: 15),
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Từ',
                          style: TextStyle(color: _muted, fontSize: 13),
                        ),
                        Wrap(
                          crossAxisAlignment: WrapCrossAlignment.center,
                          spacing: 4,
                          children: [
                            Text(
                              formatVnd(amount),
                              key: const Key('trip-detail-price'),
                              style: const TextStyle(
                                color: Color(0xFF0064AF),
                                fontSize: 19,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const Text(
                              '/ người',
                              style: TextStyle(color: _muted, fontSize: 13),
                            ),
                          ],
                        ),
                      ],
                    ),
            ),
            SizedBox(
              width: 164,
              child: FilledButton(
                key: const Key('trip-detail-cta'),
                onPressed: onPressed,
                style: FilledButton.styleFrom(
                  backgroundColor: _blue,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(0, 48),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(11),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Flexible(
                      child: Text(
                        'Chọn chỗ',
                        maxLines: 2,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    SvgPicture.asset(
                      '$_detailAssets/forward.svg',
                      width: 17,
                      height: 17,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
