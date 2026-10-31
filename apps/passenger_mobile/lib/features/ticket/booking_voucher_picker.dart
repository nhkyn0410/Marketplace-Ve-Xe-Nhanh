import 'package:flutter/material.dart';
import 'package:mobile_shared/mobile_shared.dart';

import 'booking_models.dart';
import 'trip_booking_api.dart';

/// Chọn một voucher trong ví và chỉ trả về ưu đãi đã được máy chủ kiểm tra.
class BookingVoucherPicker extends StatefulWidget {
  const BookingVoucherPicker({
    super.key,
    required this.api,
    required this.tripId,
    required this.subtotal,
    required this.holdExpiresAt,
    this.selectedVoucherId,
    this.now,
  });

  final TripBookingApi api;
  final String tripId;
  final int subtotal;
  final DateTime holdExpiresAt;
  final String? selectedVoucherId;
  final DateTime Function()? now;

  @override
  State<BookingVoucherPicker> createState() => _BookingVoucherPickerState();
}

class _BookingVoucherPickerState extends State<BookingVoucherPicker> {
  late Future<List<BookingVoucher>> _vouchers = widget.api
      .loadBookingVouchers();
  String? _checkingId;
  final _errors = <String, String>{};

  DateTime _now() => widget.now?.call() ?? DateTime.now();

  Future<void> _select(BookingVoucher voucher) async {
    if (_checkingId != null) return;
    if (!widget.holdExpiresAt.isAfter(_now())) {
      setState(
        () =>
            _errors[voucher.id] = 'Thời gian giữ chỗ đã hết. Vui lòng đặt lại.',
      );
      return;
    }
    setState(() {
      _checkingId = voucher.id;
      _errors.remove(voucher.id);
    });
    try {
      final quote = await widget.api.checkVoucher(
        tripId: widget.tripId,
        userVoucherId: voucher.id,
        subtotal: widget.subtotal,
      );
      if (mounted) Navigator.of(context).pop(quote);
    } catch (error) {
      if (mounted) {
        setState(
          () =>
              _errors[voucher.id] = error is ApiFailure && !error.isNetworkError
              ? error.detail
              : 'Không thể kiểm tra voucher. Vui lòng thử lại.',
        );
      }
    } finally {
      if (mounted) setState(() => _checkingId = null);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      key: const Key('booking-voucher-picker'),
      color: const Color(0xFFF2F8FB),
      borderRadius: const BorderRadius.vertical(top: Radius.circular(22)),
      clipBehavior: Clip.antiAlias,
      child: SafeArea(
        top: false,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 14, 8, 4),
              child: Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Chọn từ ví voucher',
                      style: TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF0B2942),
                      ),
                    ),
                  ),
                  IconButton(
                    key: const Key('booking-voucher-close'),
                    tooltip: 'Đóng',
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close_rounded),
                  ),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.fromLTRB(20, 0, 20, 14),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Mỗi đơn dùng một ưu đãi. Điều kiện được kiểm tra cho chuyến bạn chọn.',
                ),
              ),
            ),
            Expanded(
              child: FutureBuilder<List<BookingVoucher>>(
                future: _vouchers,
                builder: (context, snapshot) {
                  if (snapshot.connectionState != ConnectionState.done) {
                    return const Center(
                      child: CircularProgressIndicator(
                        key: Key('booking-voucher-loading'),
                      ),
                    );
                  }
                  if (snapshot.hasError) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text(
                              'Không tải được ví voucher. Vui lòng thử lại.',
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 12),
                            OutlinedButton(
                              key: const Key('booking-voucher-retry'),
                              onPressed: () => setState(() {
                                _vouchers = widget.api.loadBookingVouchers();
                              }),
                              child: const Text('Thử lại'),
                            ),
                          ],
                        ),
                      ),
                    );
                  }
                  final vouchers = snapshot.requireData;
                  if (vouchers.isEmpty) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(24),
                        child: Text(
                          'Ví chưa có voucher có thể sử dụng.',
                          key: Key('booking-voucher-empty'),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    );
                  }
                  return ListView.separated(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
                    itemCount: vouchers.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      final voucher = vouchers[index];
                      final expired = !voucher.expiresAt.isAfter(_now());
                      final available =
                          voucher.status == 'AVAILABLE' && !expired;
                      final discount = voucher.discountType == 'PERCENT'
                          ? 'Giảm ${voucher.discountValue}%'
                          : 'Giảm ${_money(voucher.discountValue)}';
                      final date = voucher.expiresAt.toLocal();
                      return Card(
                        margin: EdgeInsets.zero,
                        color: Colors.white,
                        child: InkWell(
                          key: Key('booking-voucher-${voucher.id}'),
                          borderRadius: BorderRadius.circular(12),
                          onTap: available && _checkingId == null
                              ? () => _select(voucher)
                              : null,
                          child: Padding(
                            padding: const EdgeInsets.all(14),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(
                                  Icons.confirmation_number_rounded,
                                  color: available
                                      ? const Color(0xFF1E8ABE)
                                      : Colors.grey,
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        voucher.name,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 15,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        discount,
                                        style: const TextStyle(
                                          color: Color(0xFF1E8ABE),
                                        ),
                                      ),
                                      if (voucher.maxDiscount != null &&
                                          voucher.discountType == 'PERCENT')
                                        Text(
                                          'Tối đa ${_money(voucher.maxDiscount!)}',
                                        ),
                                      if (voucher.minOrder != '0')
                                        Text(
                                          'Đơn từ ${_money(voucher.minOrder)}',
                                        ),
                                      Text(
                                        'Hạn dùng: ${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}',
                                      ),
                                      if (!available)
                                        Text(
                                          expired
                                              ? 'Voucher đã hết hạn'
                                              : 'Voucher không còn khả dụng',
                                          style: const TextStyle(
                                            color: Color(0xFFB54708),
                                          ),
                                        ),
                                      if (_errors[voucher.id]
                                          case final message?)
                                        Padding(
                                          padding: const EdgeInsets.only(
                                            top: 6,
                                          ),
                                          child: Text(
                                            message,
                                            key: Key(
                                              'booking-voucher-error-${voucher.id}',
                                            ),
                                            style: const TextStyle(
                                              color: Color(0xFFD84A4A),
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 8),
                                if (_checkingId == voucher.id)
                                  const SizedBox.square(
                                    dimension: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  )
                                else
                                  Icon(
                                    voucher.id == widget.selectedVoucherId
                                        ? Icons.check_circle_rounded
                                        : Icons.chevron_right_rounded,
                                    color: available
                                        ? const Color(0xFF1E8ABE)
                                        : Colors.grey,
                                  ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

String _money(String value) {
  final digits = BigInt.tryParse(value)?.toString() ?? value;
  return '${digits.replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (match) => '${match[1]}.')} ₫';
}
