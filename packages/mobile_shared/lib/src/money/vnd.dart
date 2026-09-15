/// Tiện ích tiền tệ VND.
///
/// API trả số tiền dạng **BIGINT, đơn vị đồng** (CLAUDE.md §4.3 cấm `float` cho
/// tiền). Dart `int` trên Android/iOS là 64-bit nên ánh xạ thẳng được — tuyệt
/// đối KHÔNG đổi sang `double` ở bất cứ đâu, kể cả chỉ để hiển thị.
library;

const _groupSeparator = '.';
const _symbol = '₫';

/// `1234567` → `1.234.567 ₫`
String formatVnd(int amount, {bool withSymbol = true}) {
  // Thao tác trên chuỗi thay vì `amount.abs()`: abs() của giá trị nhỏ nhất
  // int64 tràn về chính nó (vẫn âm).
  final digits = amount.toString().replaceFirst('-', '');
  final sign = amount < 0 ? '-' : '';
  final grouped = _group(digits);
  return withSymbol ? '$sign$grouped $_symbol' : '$sign$grouped';
}

/// Chèn dấu ngăn nghìn: `'1234567'` → `'1.234.567'`.
String _group(String digits) {
  final buffer = StringBuffer();
  for (var i = 0; i < digits.length; i++) {
    // Chỉ chèn khi số chữ số CÒN LẠI chia hết cho 3, và không chèn ở đầu chuỗi.
    if (i > 0 && (digits.length - i) % 3 == 0) {
      buffer.write(_groupSeparator);
    }
    buffer.write(digits[i]);
  }
  return buffer.toString();
}

/// Dạng chuỗi tiền VND hợp lệ: tuỳ chọn dấu âm, rồi **hoặc** dãy chữ số trần
/// (`1234567`), **hoặc** dãy đã nhóm đúng ba (`1.234.567`). Không gì khác.
final _vndPattern = RegExp(r'^-?(?:\d{1,3}(?:\.\d{3})+|\d+)$');

/// Chiều ngược của [formatVnd]: `'1.234.567 ₫'` → `1234567`.
///
/// Ném [FormatException] nếu chuỗi không phải số tiền hợp lệ.
int parseVnd(String input) {
  final trimmed = input.replaceAll(_symbol, '').replaceAll(RegExp(r'\s'), '');

  // Xác thực TRƯỚC khi bỏ dấu nhóm. Làm ngược lại thì `'1.5'` bị biến thành
  // `'15'` rồi parse trót lọt — nhận một chuỗi sai thành số tiền khác hẳn,
  // im lặng, đúng loại lỗi tệ nhất với dữ liệu tiền.
  if (!_vndPattern.hasMatch(trimmed)) {
    throw FormatException('Không phải số tiền VND hợp lệ.', input);
  }

  // `radix: 10` bắt buộc: thiếu nó thì `int.parse` nhận tiền tố `0x`, và
  // `'0xffffffffffffffff'` cuộn vòng im lặng thành `-1`.
  return int.parse(trimmed.replaceAll(_groupSeparator, ''), radix: 10);
}
