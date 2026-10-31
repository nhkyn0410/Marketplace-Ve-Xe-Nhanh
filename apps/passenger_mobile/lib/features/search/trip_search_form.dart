import 'dart:async';

import 'package:flutter/material.dart';
import 'package:passenger_mobile/features/home/home_models.dart';
import 'package:passenger_mobile/features/ticket/trip_search_models.dart';

const _primary = Color(0xFF2B7EAD);
const _primaryDark = Color(0xFF102E58);
const _secondary = Color(0xFF607A8E);
const _divider = Color(0xFFE6EEF3);

/// Dữ liệu danh mục cho form tìm chuyến: tỉnh/thành, gợi ý địa điểm theo từ khóa, nhà xe đang mở bán, tiện ích.
class TripSearchCatalog {
  const TripSearchCatalog({
    required this.loadProvinces,
    required this.searchPlaces,
    required this.loadOperators,
    required this.loadAmenities,
  });

  final Future<List<HomeLocation>> Function() loadProvinces;

  /// Gợi ý cùng nguồn với web: tỉnh, khu vực, phường / xã, bến – địa danh, tên cũ.
  final Future<List<HomeLocation>> Function(String keyword) searchPlaces;
  final Future<List<HomeOperator>> Function() loadOperators;
  final Future<List<TripAmenityOption>> Function() loadAmenities;
}

/// Ngày đi mặc định của form tìm chuyến: ngày mai.
DateTime defaultSearchDate() {
  final now = DateTime.now();
  return DateTime(now.year, now.month, now.day + 1);
}

/// `22/10/2026`.
String formatSearchDate(DateTime value) {
  String two(int part) => part.toString().padLeft(2, '0');
  return '${two(value.day)}/${two(value.month)}/${value.year}';
}

/// Trạng thái + thao tác chung của form tìm chuyến; Trang chủ và Mua vé cùng dùng.
mixin TripSearchFormState<T extends StatefulWidget> on State<T> {
  TripSearchCatalog? get searchCatalog;

  HomeSearchMode searchMode = HomeSearchMode.route;
  HomeLocation? searchFrom;
  HomeLocation? searchTo;
  HomeOperator? searchOperator;
  HomeOperatorRoute? searchOperatorRoute;
  DateTime searchDate = defaultSearchDate();
  int searchPassengers = 1;

  /// Điền lại form theo một lần tìm trước (vd. từ Trang chủ sang Mua vé).
  void applySearchQuery(HomeSearchQuery query) {
    searchMode = query.mode;
    searchDate = query.date;
    searchPassengers = query.passengers;
    if (query.mode == HomeSearchMode.operator) {
      searchOperator = query.operator;
      searchOperatorRoute = HomeOperatorRoute(from: query.from, to: query.to);
    } else {
      searchFrom = query.from;
      searchTo = query.to;
    }
  }

  /// Hiện thông báo ngắn ở cuối màn hình.
  void showSearchMessage(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  /// Mở ô chọn điểm đi / điểm đến (gõ để gợi ý tỉnh và bến, địa danh).
  Future<void> pickSearchLocation({required bool isOrigin}) async {
    final catalog = searchCatalog;
    if (catalog == null) {
      showSearchMessage('Danh mục địa điểm hiện chưa khả dụng.');
      return;
    }
    final selected = await showModalBottomSheet<HomeLocation>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => _LocationPickerSheet(
        title: isOrigin ? 'Chọn điểm đi' : 'Chọn điểm đến',
        catalog: catalog,
      ),
    );
    if (selected == null || !mounted) return;
    setState(() {
      if (isOrigin) {
        searchFrom = selected;
      } else {
        searchTo = selected;
      }
    });
  }

  /// Đổi chỗ điểm đi và điểm đến.
  void swapSearchLocations() {
    setState(() {
      final previous = searchFrom;
      searchFrom = searchTo;
      searchTo = previous;
    });
  }

  /// Chọn nhà xe; chưa có tuyến hợp lệ thì mở luôn bước chọn tuyến.
  Future<void> pickSearchOperator() async {
    final catalog = searchCatalog;
    if (catalog == null) {
      showSearchMessage('Danh sách nhà xe hiện chưa khả dụng.');
      return;
    }
    final selected = await showModalBottomSheet<HomeOperator>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => _OperatorPickerSheet(
        loader: catalog.loadOperators,
        selectedId: searchOperator?.id,
      ),
    );
    if (selected == null || !mounted) return;
    final current = searchOperatorRoute;
    final keepRoute =
        current != null &&
        selected.routes.any(
          (route) =>
              route.from.id == current.from.id && route.to.id == current.to.id,
        );
    setState(() {
      searchOperator = selected;
      searchOperatorRoute = keepRoute
          ? current
          : (selected.routes.length == 1 ? selected.routes.single : null);
    });
    if (searchOperatorRoute == null && selected.routes.isNotEmpty) {
      await pickSearchOperatorRoute();
    }
  }

  /// Chọn một tuyến (điểm đi → điểm đến) của nhà xe đã chọn.
  Future<void> pickSearchOperatorRoute() async {
    final operator = searchOperator;
    if (operator == null) {
      await pickSearchOperator();
      return;
    }
    final selected = await showModalBottomSheet<HomeOperatorRoute>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => _OperatorRoutePickerSheet(operator: operator),
    );
    if (selected == null || !mounted) return;
    setState(() => searchOperatorRoute = selected);
  }

  /// Chọn ngày đi; trả `true` khi ngày đổi.
  Future<bool> pickSearchDate() async {
    final now = DateTime.now();
    final firstDate = DateTime(now.year, now.month, now.day);
    final selected = await showDatePicker(
      context: context,
      initialDate: searchDate.isBefore(firstDate) ? firstDate : searchDate,
      firstDate: firstDate,
      lastDate: firstDate.add(const Duration(days: 365)),
      helpText: 'Chọn ngày đi',
    );
    if (selected == null || !mounted) return false;
    setState(() => searchDate = selected);
    return true;
  }

  /// Chọn số hành khách (1–10).
  Future<void> pickSearchPassengers() async {
    var value = searchPassengers;
    final selected = await showModalBottomSheet<int>(
      context: context,
      useSafeArea: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => StatefulBuilder(
        builder: (context, setSheetState) => Padding(
          padding: EdgeInsets.fromLTRB(
            24,
            20,
            24,
            24 + MediaQuery.paddingOf(context).bottom,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Số hành khách',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: _primaryDark,
                ),
              ),
              const SizedBox(height: 18),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton.outlined(
                    onPressed: value > 1
                        ? () => setSheetState(() => value--)
                        : null,
                    icon: const Icon(Icons.remove),
                  ),
                  SizedBox(
                    width: 90,
                    child: Text(
                      '$value khách',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  IconButton.outlined(
                    onPressed: value < 10
                        ? () => setSheetState(() => value++)
                        : null,
                    icon: const Icon(Icons.add),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () => Navigator.pop(context, value),
                  child: const Text('Xác nhận'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
    if (selected != null && mounted) {
      setState(() => searchPassengers = selected);
    }
  }

  /// Điều kiện tìm từ form; thiếu / sai thì báo cho người dùng và trả `null`.
  HomeSearchQuery? buildSearchQuery() {
    if (searchMode == HomeSearchMode.operator) {
      final operator = searchOperator;
      final route = searchOperatorRoute;
      if (operator == null) {
        showSearchMessage('Vui lòng chọn nhà xe.');
        return null;
      }
      if (route == null) {
        showSearchMessage('Vui lòng chọn tuyến của nhà xe.');
        return null;
      }
      return HomeSearchQuery(
        mode: searchMode,
        from: route.from,
        to: route.to,
        date: searchDate,
        passengers: searchPassengers,
        operator: operator,
      );
    }
    final from = searchFrom;
    final to = searchTo;
    if (from == null || to == null) {
      showSearchMessage('Vui lòng chọn điểm đi và điểm đến từ danh mục.');
      return null;
    }
    if (from.id == to.id && from.kind == to.kind) {
      showSearchMessage('Điểm đi và điểm đến phải khác nhau.');
      return null;
    }
    return HomeSearchQuery(
      mode: searchMode,
      from: from,
      to: to,
      date: searchDate,
      passengers: searchPassengers,
    );
  }
}

class _SheetFrame extends StatelessWidget {
  const _SheetFrame({
    required this.title,
    required this.child,
    this.heightFactor = .7,
    this.header,
  });

  final String title;
  final Widget child;
  final double heightFactor;
  final Widget? header;

  @override
  Widget build(BuildContext context) {
    final keyboard = MediaQuery.viewInsetsOf(context).bottom;
    return SizedBox(
      height: MediaQuery.sizeOf(context).height * heightFactor,
      child: Padding(
        padding: EdgeInsets.only(bottom: keyboard),
        child: Column(
          children: [
            const SizedBox(height: 10),
            Container(
              width: 42,
              height: 4,
              decoration: BoxDecoration(
                color: const Color(0xFFD5E2EA),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 16, 18, 10),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: _primaryDark,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            ?header,
            Expanded(child: child),
          ],
        ),
      ),
    );
  }
}

class _SheetMessage extends StatelessWidget {
  const _SheetMessage(this.message, {this.onRetry});

  final String message;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(color: _secondary),
            ),
            if (onRetry != null) ...[
              const SizedBox(height: 12),
              OutlinedButton(onPressed: onRetry, child: const Text('Thử lại')),
            ],
          ],
        ),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 14, 18, 6),
      child: Text(
        label,
        style: const TextStyle(
          color: _secondary,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _LocationPickerSheet extends StatefulWidget {
  const _LocationPickerSheet({required this.title, required this.catalog});

  final String title;
  final TripSearchCatalog catalog;

  @override
  State<_LocationPickerSheet> createState() => _LocationPickerSheetState();
}

class _LocationPickerSheetState extends State<_LocationPickerSheet> {
  static const _minPlaceKeyword = 2;

  late Future<List<HomeLocation>> _provinces = widget.catalog.loadProvinces();
  String _keyword = '';
  Timer? _debounce;
  int _placeRequest = 0;
  bool _searchingPlaces = false;
  bool _placeSearchFailed = false;
  List<HomeLocation> _places = const [];

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  /// Dưới 2 ký tự: lọc danh sách tỉnh tại chỗ. Từ 2 ký tự: gợi ý từ API (tỉnh,
  /// khu vực, phường / xã, bến – địa danh, tên cũ), như ô tìm của web.
  void _onKeywordChanged(String value) {
    final keyword = value.trim();
    setState(() => _keyword = keyword);
    _debounce?.cancel();
    final request = ++_placeRequest;
    if (keyword.length < _minPlaceKeyword) {
      setState(() {
        _places = const [];
        _searchingPlaces = false;
        _placeSearchFailed = false;
      });
      return;
    }
    setState(() => _searchingPlaces = true);
    _debounce = Timer(const Duration(milliseconds: 300), () async {
      try {
        final items = await widget.catalog.searchPlaces(keyword);
        if (!mounted || request != _placeRequest) return;
        setState(() {
          _places = items;
          _searchingPlaces = false;
          _placeSearchFailed = false;
        });
      } catch (_) {
        if (!mounted || request != _placeRequest) return;
        setState(() {
          _places = const [];
          _searchingPlaces = false;
          _placeSearchFailed = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return _SheetFrame(
      title: widget.title,
      heightFactor: .85,
      header: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 4),
        child: TextField(
          key: const Key('location-search-field'),
          autofocus: true,
          onChanged: _onKeywordChanged,
          textInputAction: TextInputAction.search,
          decoration: InputDecoration(
            hintText: 'Tỉnh, phường/xã, bến xe, tên cũ (Đà Lạt, Vũng Tàu…)',
            prefixIcon: const Icon(Icons.search, color: _secondary),
            filled: true,
            fillColor: const Color(0xFFF3F8FB),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ),
      child: _keyword.length >= _minPlaceKeyword
          ? _buildPlaces(context)
          : _buildProvinces(context),
    );
  }

  Widget _buildPlaces(BuildContext context) {
    if (_searchingPlaces) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_placeSearchFailed) {
      return _SheetMessage(
        'Không tải được gợi ý địa điểm. Vui lòng thử lại.',
        onRetry: () => _onKeywordChanged(_keyword),
      );
    }
    if (_places.isEmpty) {
      return const _SheetMessage('Không tìm thấy địa điểm phù hợp.');
    }
    return ListView(
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      children: [
        for (final place in _places)
          _LocationTile(
            location: place,
            onTap: () => Navigator.pop(context, place),
          ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildProvinces(BuildContext context) {
    return FutureBuilder<List<HomeLocation>>(
      future: _provinces,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return _SheetMessage(
            'Không tải được danh mục địa điểm. Vui lòng thử lại.',
            onRetry: () => setState(
              () => _provinces = widget.catalog.loadProvinces(),
            ),
          );
        }
        final folded = _fold(_keyword);
        final provinces = [
          for (final province in snapshot.data ?? const <HomeLocation>[])
            if (_fold(province.name).contains(folded)) province,
        ];
        if (provinces.isEmpty) {
          return const _SheetMessage('Không tìm thấy địa điểm phù hợp.');
        }
        return ListView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          children: [
            const _SectionLabel('Tỉnh / thành phố'),
            for (final province in provinces)
              _LocationTile(
                location: province,
                onTap: () => Navigator.pop(context, province),
              ),
            const SizedBox(height: 16),
          ],
        );
      },
    );
  }
}

class _LocationTile extends StatelessWidget {
  const _LocationTile({required this.location, required this.onTap});

  final HomeLocation location;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        switch (location.kind) {
          HomeLocationKind.province => Icons.location_city_outlined,
          HomeLocationKind.area => Icons.map_outlined,
          HomeLocationKind.ward => Icons.holiday_village_outlined,
          HomeLocationKind.stopPoint => Icons.place_outlined,
        },
        color: _primary,
      ),
      title: Text(location.name),
      // Dòng phụ của khu vực / tên cũ khá dài ("… cũ · nay thuộc …"): cho 2 dòng.
      subtitle: location.detail == null
          ? null
          : Text(
              location.detail!,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
      onTap: onTap,
    );
  }
}

class _OperatorPickerSheet extends StatefulWidget {
  const _OperatorPickerSheet({required this.loader, this.selectedId});

  final Future<List<HomeOperator>> Function() loader;
  final String? selectedId;

  @override
  State<_OperatorPickerSheet> createState() => _OperatorPickerSheetState();
}

class _OperatorPickerSheetState extends State<_OperatorPickerSheet> {
  late Future<List<HomeOperator>> _operators = widget.loader();

  @override
  Widget build(BuildContext context) {
    return _SheetFrame(
      title: 'Chọn nhà xe',
      child: FutureBuilder<List<HomeOperator>>(
        future: _operators,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return _SheetMessage(
              'Không tải được danh sách nhà xe. Vui lòng thử lại.',
              onRetry: () => setState(() => _operators = widget.loader()),
            );
          }
          final operators = snapshot.data ?? const <HomeOperator>[];
          if (operators.isEmpty) {
            return const _SheetMessage('Chưa có nhà xe nào đang mở bán.');
          }
          return ListView.separated(
            itemCount: operators.length,
            separatorBuilder: (_, _) => const Divider(height: 1, color: _divider),
            itemBuilder: (context, index) {
              final operator = operators[index];
              return ListTile(
                key: ValueKey('operator-option-${operator.id}'),
                leading: OperatorInitialAvatar(
                  name: operator.name,
                  logoUrl: operator.logoUrl,
                ),
                title: Text(operator.name),
                subtitle: Text(
                  '${describeOperatorRating(operator.averageRating, operator.reviewCount)} · ${operator.routes.length} tuyến',
                ),
                trailing: operator.id == widget.selectedId
                    ? const Icon(Icons.check_circle, color: _primary)
                    : null,
                onTap: () => Navigator.pop(context, operator),
              );
            },
          );
        },
      ),
    );
  }
}

class _OperatorRoutePickerSheet extends StatelessWidget {
  const _OperatorRoutePickerSheet({required this.operator});

  final HomeOperator operator;

  @override
  Widget build(BuildContext context) {
    return _SheetFrame(
      title: 'Chọn tuyến · ${operator.name}',
      heightFactor: .6,
      child: operator.routes.isEmpty
          ? const _SheetMessage('Nhà xe chưa có tuyến đang mở bán.')
          : ListView.separated(
              itemCount: operator.routes.length,
              separatorBuilder: (_, _) =>
                  const Divider(height: 1, color: _divider),
              itemBuilder: (context, index) {
                final route = operator.routes[index];
                return ListTile(
                  key: ValueKey('operator-route-option-$index'),
                  leading: const Icon(Icons.route_outlined, color: _primary),
                  title: Text(route.label),
                  onTap: () => Navigator.pop(context, route),
                );
              },
            ),
    );
  }
}

/// Logo nhà xe trong ô tròn; chưa có ảnh hoặc tải lỗi thì dùng chữ cái đầu (FR-OPR-02).
class OperatorInitialAvatar extends StatelessWidget {
  const OperatorInitialAvatar({
    required this.name,
    this.logoUrl,
    this.size = 36,
    super.key,
  });

  final String name;
  final String? logoUrl;
  final double size;

  @override
  Widget build(BuildContext context) {
    final trimmed = name.trim();
    final initials = Text(
      trimmed.isEmpty ? '?' : trimmed.characters.first.toUpperCase(),
      style: TextStyle(
        color: _primary,
        fontSize: size * .44,
        fontWeight: FontWeight.w700,
      ),
    );
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        color: Color(0xFFE2F1F8),
        shape: BoxShape.circle,
      ),
      child: logoUrl == null || logoUrl!.isEmpty
          ? initials
          : ClipOval(
              child: Image.network(
                logoUrl!,
                width: size,
                height: size,
                fit: BoxFit.contain,
                errorBuilder: (_, _, _) => Center(child: initials),
              ),
            ),
    );
  }
}

/// `★ 4.7 (12 đánh giá)` hoặc `Chưa có đánh giá`.
String describeOperatorRating(double? averageRating, int reviewCount) {
  if (averageRating == null || reviewCount == 0) return 'Chưa có đánh giá';
  return '★ ${averageRating.toStringAsFixed(1)} ($reviewCount đánh giá)';
}

const _foldGroups = <String, String>{
  'a': 'àáạảãâầấậẩẫăằắặẳẵ',
  'e': 'èéẹẻẽêềếệểễ',
  'i': 'ìíịỉĩ',
  'o': 'òóọỏõôồốộổỗơờớợởỡ',
  'u': 'ùúụủũưừứựửữ',
  'y': 'ỳýỵỷỹ',
  'd': 'đ',
};

final _foldMap = <int, String>{
  for (final group in _foldGroups.entries)
    for (final rune in group.value.runes) rune: group.key,
};

/// Chữ thường, bỏ dấu tiếng Việt (cả dấu tổ hợp) để so khớp khi gõ không dấu.
String _fold(String value) {
  final buffer = StringBuffer();
  for (final rune in value.toLowerCase().runes) {
    if (rune >= 0x300 && rune <= 0x36F) continue;
    buffer.write(_foldMap[rune] ?? String.fromCharCode(rune));
  }
  return buffer.toString();
}
