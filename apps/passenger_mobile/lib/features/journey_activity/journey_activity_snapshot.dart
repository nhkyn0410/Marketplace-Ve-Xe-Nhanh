/// Dữ liệu trình bày của demo; không phải trạng thái chuyến/vé nghiệp vụ.
class JourneyActivitySnapshot {
  JourneyActivitySnapshot.fromJson(Map<String, dynamic> json)
    : sessionId = _text(json, 'sessionId'),
      bookingId = _text(json, 'bookingId'),
      revision = _integer(json, 'revision', 0, 7),
      stage = _text(json, 'stage'),
      routeLabel = _text(json, 'routeLabel'),
      provinceName = _text(json, 'provinceName'),
      etaAt = _date(json, 'etaAt'),
      progress = _integer(json, 'progress', 0, 1000),
      updatedAt = _date(json, 'updatedAt'),
      expiresAt = _date(json, 'expiresAt'),
      ended = json['ended'] == true {
    if (json['type'] != 'journey_demo' ||
        json['schemaVersion'] != 1 ||
        json['ended'] is! bool ||
        !const {
          'approaching',
          'travelling',
          'arrived',
          'stopped',
        }.contains(stage) ||
        ended != (stage == 'stopped') ||
        !expiresAt.isAfter(updatedAt)) {
      throw const FormatException('Invalid journey demo snapshot');
    }
  }

  final String sessionId;
  final String bookingId;
  final int revision;
  final String stage;
  final String routeLabel;
  final String provinceName;
  final DateTime etaAt;
  final int progress;
  final DateTime updatedAt;
  final DateTime expiresAt;
  final bool ended;

  bool isExpired(DateTime now) => !expiresAt.isAfter(now);

  Map<String, dynamic> toJson() => {
    'type': 'journey_demo',
    'schemaVersion': 1,
    'sessionId': sessionId,
    'bookingId': bookingId,
    'revision': revision,
    'stage': stage,
    'routeLabel': routeLabel,
    'provinceName': provinceName,
    'etaAt': etaAt.toUtc().toIso8601String(),
    'progress': progress,
    'updatedAt': updatedAt.toUtc().toIso8601String(),
    'expiresAt': expiresAt.toUtc().toIso8601String(),
    'ended': ended,
  };

  static String _text(Map<String, dynamic> json, String key) {
    final value = json[key];
    if (value is! String || value.trim().isEmpty || value.length > 300) {
      throw FormatException('Invalid $key');
    }
    return value;
  }

  static int _integer(Map<String, dynamic> json, String key, int min, int max) {
    final value = json[key];
    if (value is! int || value < min || value > max) {
      throw FormatException('Invalid $key');
    }
    return value;
  }

  static DateTime _date(Map<String, dynamic> json, String key) {
    final value = DateTime.tryParse(_text(json, key));
    if (value == null) throw FormatException('Invalid $key');
    return value.toUtc();
  }
}
