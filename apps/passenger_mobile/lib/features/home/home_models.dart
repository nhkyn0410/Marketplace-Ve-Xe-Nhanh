enum HomeSearchMode { route, operator }

enum HomeLocationKind { province, stopPoint }

class HomeLocation {
  const HomeLocation({
    required this.id,
    required this.name,
    this.kind = HomeLocationKind.province,
    this.detail,
  });

  final String id;
  final String name;
  final HomeLocationKind kind;

  /// Dòng phụ khi gợi ý (địa chỉ của bến / địa danh); tỉnh thì không có.
  final String? detail;
}

/// Một tuyến (tỉnh đi → tỉnh đến) nhà xe đang mở bán.
class HomeOperatorRoute {
  const HomeOperatorRoute({required this.from, required this.to});

  final HomeLocation from;
  final HomeLocation to;

  String get label => '${from.name} → ${to.name}';
}

/// Nhà xe đang mở bán, dùng cho chế độ tìm "Theo nhà xe".
class HomeOperator {
  const HomeOperator({
    required this.id,
    required this.name,
    required this.reviewCount,
    required this.routes,
    this.averageRating,
    this.logoUrl,
  });

  final String id;
  final String name;

  /// Trung bình các đánh giá đang hiển thị; `null` khi chưa có đánh giá.
  final double? averageRating;

  /// `null` khi nhà xe chưa tải logo — hiện chữ cái đầu thay thế.
  final String? logoUrl;
  final int reviewCount;
  final List<HomeOperatorRoute> routes;
}

class HomeSearchQuery {
  const HomeSearchQuery({
    required this.mode,
    required this.from,
    required this.to,
    required this.date,
    required this.passengers,
    this.operator,
  });

  final HomeSearchMode mode;
  final HomeLocation from;
  final HomeLocation to;
  final DateTime date;
  final int passengers;

  /// Chỉ có ở chế độ "Theo nhà xe".
  final HomeOperator? operator;

  String? get operatorId => operator?.id;
}

class HomePopularRoute {
  const HomePopularRoute({
    required this.tripId,
    required this.from,
    required this.to,
    required this.fromLabel,
    required this.toLabel,
    required this.minPriceVnd,
    required this.fallbackAsset,
    this.imageUrl,
  });

  final String tripId;
  final HomeLocation from;
  final HomeLocation to;
  final String fromLabel;
  final String toLabel;
  final int minPriceVnd;
  final String fallbackAsset;
  final String? imageUrl;
}

class HomeFaqItem {
  const HomeFaqItem({required this.title, required this.body});

  final String title;
  final String body;
}
