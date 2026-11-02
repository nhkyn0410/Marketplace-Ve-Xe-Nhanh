import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_flutter/qr_flutter.dart';

import 'payment_models.dart';

// Nguồn: vietqr.io/deeplink và api.vietqr.io/v2/{banks,android-app-deeplinks}, 31/10/2026.
const _bankCodes = {
  '970415': 'icb',
  '970418': 'bidv',
  '970448': 'ocb',
  '970416': 'acb',
  '970422': 'mb',
  '970436': 'vcb',
  '970407': 'tcb',
  '970432': 'vpb',
  '970441': 'vib',
  '970423': 'tpb',
  '970405': 'vba',
  '970437': 'hdb',
  '970426': 'msb',
  '970452': 'klb',
};
const _bankApps = {
  'mb': 'MB Bank',
  'icb': 'VietinBank iPay',
  'bidv': 'BIDV SmartBanking',
  'acb': 'ACB ONE',
  'ocb': 'OCB OMNI',
  'vcb': 'VCB Digibank',
  'tcb': 'Techcombank Mobile',
  'vpb': 'VPBank NEO',
  'tpb': 'TPBank Mobile',
  'vib-2': 'MyVIB',
};

/// Hiển thị QR và thông tin chuyển khoản, mở ứng dụng ngân hàng hoặc trang cổng.
class PaymentCheckoutCard extends StatefulWidget {
  const PaymentCheckoutCard({
    super.key,
    required this.session,
    required this.onOpenUrl,
    this.method = PassengerPaymentMethod.payos,
  });

  final BookingPaymentSession session;
  final PassengerPaymentMethod method;
  final Future<void> Function(Uri) onOpenUrl;

  @override
  State<PaymentCheckoutCard> createState() => _PaymentCheckoutCardState();
}

class _PaymentCheckoutCardState extends State<PaymentCheckoutCard> {
  String _bankApp = 'mb';

  @override
  Widget build(BuildContext context) {
    final transfer = widget.session.transfer;
    return Container(
      key: const Key('payment-checkout-card'),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            transfer == null
                ? 'Thanh toán qua ${widget.method.label}'
                : 'Quét mã VietQR',
            style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 17),
          ),
          const SizedBox(height: 12),
          if (transfer != null) ...[
            Center(
              child: SizedBox(
                width: 236,
                child: QrImageView(
                  key: const Key('payment-transfer-qr'),
                  data: transfer.qrCode,
                  semanticsLabel: 'Mã VietQR thanh toán payOS',
                  version: QrVersions.auto,
                  backgroundColor: Colors.white,
                ),
              ),
            ),
            _CopyField(
              label: 'Ngân hàng',
              value:
                  _bankApps[_bankCodes[transfer.bin]] ??
                  switch (_bankCodes[transfer.bin]) {
                    'vib' => 'VIB',
                    'vba' => 'Agribank',
                    'hdb' => 'HDBank',
                    'msb' => 'MSB',
                    'klb' => 'KienlongBank',
                    _ => 'BIN ${transfer.bin}',
                  },
            ),
            _CopyField(
              label: 'Số tài khoản',
              value: transfer.accountNumber,
              fieldKey: 'payment-copy-account',
            ),
            _CopyField(label: 'Chủ tài khoản', value: transfer.accountName),
            _CopyField(
              label: 'Số tiền (VND)',
              value: transfer.amount,
              fieldKey: 'payment-copy-amount',
            ),
            _CopyField(
              label: 'Nội dung',
              value: transfer.description,
              fieldKey: 'payment-copy-description',
            ),
            const SizedBox(height: 10),
            const Text(
              'Chuyển đúng số tiền và nội dung ở trên. Không chuyển thêm nếu đã thanh toán.',
              style: TextStyle(color: Color(0xFFB54708)),
            ),
            if (_bankCodes.containsKey(transfer.bin)) ...[
              const SizedBox(height: 14),
              DropdownButtonFormField<String>(
                key: const Key('payment-bank-app'),
                initialValue: _bankApp,
                isExpanded: true,
                decoration: const InputDecoration(
                  labelText: 'Ứng dụng ngân hàng của bạn',
                  border: OutlineInputBorder(),
                ),
                items: [
                  for (final app in _bankApps.entries)
                    DropdownMenuItem(value: app.key, child: Text(app.value)),
                ],
                onChanged: (value) {
                  if (value != null) setState(() => _bankApp = value);
                },
              ),
              const SizedBox(height: 8),
              OutlinedButton.icon(
                key: const Key('payment-open-bank'),
                onPressed: () => widget.onOpenUrl(
                  Uri.https('dl.vietqr.io', '/pay', {
                    'app': _bankApp,
                    'ba':
                        '${transfer.accountNumber}@${_bankCodes[transfer.bin]}',
                    'am': transfer.amount,
                    'tn': transfer.description,
                    'bn': transfer.accountName,
                    'url': widget.session.paymentUrl.toString(),
                  }),
                ),
                icon: const Icon(Icons.account_balance_outlined),
                label: const Text('Mở ứng dụng ngân hàng'),
              ),
              const Text(
                'Khả năng tự điền tùy ứng dụng ngân hàng. Kiểm tra lại thông tin trước khi xác nhận.',
                style: TextStyle(fontSize: 12, color: Color(0xFF71899B)),
              ),
            ],
          ],
          const SizedBox(height: 10),
          const Text(
            'Sau khi hoàn tất, quay lại ứng dụng để nhận kết quả và vé.',
          ),
        ],
      ),
    );
  }
}

class _CopyField extends StatelessWidget {
  const _CopyField({required this.label, required this.value, this.fieldKey});

  final String label;
  final String value;
  final String? fieldKey;

  @override
  Widget build(BuildContext context) => Row(
    children: [
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(fontSize: 12, color: Color(0xFF71899B)),
            ),
            Text(value, style: const TextStyle(fontWeight: FontWeight.w600)),
          ],
        ),
      ),
      IconButton(
        key: fieldKey == null ? null : Key(fieldKey!),
        tooltip: 'Sao chép $label',
        onPressed: () async {
          await Clipboard.setData(ClipboardData(text: value));
          if (context.mounted) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(SnackBar(content: Text('Đã sao chép $label.')));
          }
        },
        icon: const Icon(Icons.copy_outlined, size: 19),
      ),
    ],
  );
}
