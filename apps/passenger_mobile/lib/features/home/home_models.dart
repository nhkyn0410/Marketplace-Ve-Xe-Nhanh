enum HomeSearchMode { route, operator }

enum HomeLocationKind { province, stopPoint }

class HomeLocation {
  const HomeLocation({
    required this.id,
    required this.name,
    this.kind = HomeLocationKind.province,
  });

  final String id;
  final String name;
  final HomeLocationKind kind;
}

class HomeSearchQuery {
  const HomeSearchQuery({
    required this.mode,
    required this.from,
    required this.to,
    required this.date,
    required this.passengers,
    this.operatorId,
  });

  final HomeSearchMode mode;
  final HomeLocation from;
  final HomeLocation to;
  final DateTime date;
  final int passengers;
  final String? operatorId;
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
