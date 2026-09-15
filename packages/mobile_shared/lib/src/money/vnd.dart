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

/// Chiều ngược của [formatVnd]: `'1.234.567 ₫'` → `1234567`.
///
/// Ném [FormatException] nếu chuỗi không phải số tiền hợp lệ.
int parseVnd(String input) {
  final cleaned = input
      .replaceAll(_symbol, '')
      .replaceAll(_groupSeparator, '')
      .replaceAll(RegExp(r'\s'), '');
  return int.parse(cleaned);
}
