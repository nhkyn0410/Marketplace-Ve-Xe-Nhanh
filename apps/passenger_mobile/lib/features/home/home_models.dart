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
