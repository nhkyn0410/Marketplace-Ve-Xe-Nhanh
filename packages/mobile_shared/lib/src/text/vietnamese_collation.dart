/// Sắp xếp chuỗi theo bảng chữ cái tiếng Việt (danh sách tỉnh / thành, tuyến…).
///
/// `String.compareTo` so theo mã ký tự nên "Đắk Lắk" đứng sau "Tuyên Quang" và
/// "Tây Ninh" đứng sau "Tuyên Quang". Ở đây:
///
/// * chữ cái theo thứ tự `a ă â b c d đ e ê … o ô ơ … u ư …`, không phân biệt
///   hoa / thường;
/// * ký tự không phải chữ cái (dấu cách, dấu chấm, chữ số) đứng trước chữ cái;
/// * dấu thanh (không dấu, huyền, hỏi, ngã, sắc, nặng) chỉ dùng để phân định khi
///   phần chữ giống hệt nhau.
library;

const _alphabet = 'aăâbcdđeêfghijklmnoôơpqrstuưvwxyz';

/// Mỗi nhóm: chữ gốc rồi tới 5 thanh theo thứ tự huyền, hỏi, ngã, sắc, nặng.
const _toneGroups = [
  'aàảãáạ',
  'ăằẳẵắặ',
  'âầẩẫấậ',
  'eèẻẽéẹ',
  'êềểễếệ',
  'iìỉĩíị',
  'oòỏõóọ',
  'ôồổỗốộ',
  'ơờởỡớợ',
  'uùủũúụ',
  'ưừửữứự',
  'yỳỷỹýỵ',
];

/// Chữ cái luôn đứng sau mọi ký tự khác (mã Unicode lớn nhất là 0x10FFFF).
const _letterBase = 0x200000;

final Map<int, (int, int)> _letterWeights = _buildLetterWeights();

Map<int, (int, int)> _buildLetterWeights() {
  final weights = <int, (int, int)>{};
  final letters = _alphabet.runes.toList();
  for (var index = 0; index < letters.length; index++) {
    weights[letters[index]] = (_letterBase + index, 0);
  }
  for (final group in _toneGroups) {
    final runes = group.runes.toList();
    final primary = weights[runes.first]!.$1;
    for (var tone = 1; tone < runes.length; tone++) {
      weights[runes[tone]] = (primary, tone);
    }
  }
  return weights;
}

/// (trọng số chữ, thanh) của từng ký tự; bỏ qua dấu tổ hợp rời (U+0300–U+036F).
List<(int, int)> _weights(String value) => [
  for (final rune in value.toLowerCase().runes)
    if (rune < 0x300 || rune > 0x36F) _letterWeights[rune] ?? (rune, 0),
];

/// So sánh hai chuỗi theo thứ tự bảng chữ cái tiếng Việt; dùng làm `compare`
/// cho `List.sort`.
int compareVietnamese(String a, String b) {
  final left = _weights(a);
  final right = _weights(b);
  final shared = left.length < right.length ? left.length : right.length;
  for (var index = 0; index < shared; index++) {
    final byLetter = left[index].$1 - right[index].$1;
    if (byLetter != 0) return byLetter;
  }
  if (left.length != right.length) return left.length - right.length;
  for (var index = 0; index < shared; index++) {
    final byTone = left[index].$2 - right[index].$2;
    if (byTone != 0) return byTone;
  }
  return a.compareTo(b);
}
