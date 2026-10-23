import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'demo_data.dart';
import 'design_system.dart';
import 'login_screen.dart';
import 'profile_screens.dart';
import 'trip_screens.dart';

/// App nhân viên với luồng giao diện minh họa độc lập với hệ thống đăng nhập thật.
class EmployeeApp extends StatefulWidget {
  const EmployeeApp({super.key});
  @override
  State<EmployeeApp> createState() => _EmployeeAppState();
}

class _EmployeeAppState extends State<EmployeeApp> {
  bool _dark = false;
  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'Vé Xe Nhanh · Nhân viên',
    debugShowCheckedModeBanner: false,
    themeMode: _dark ? ThemeMode.dark : ThemeMode.light,
    theme: employeeTheme(Brightness.light),
    darkTheme: employeeTheme(Brightness.dark),
    builder: (context, child) => kIsWeb
        ? ColoredBox(
            color: const Color(0xffe7e3dd),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 412),
                child: child,
              ),
            ),
          )
        : child!,
    home: LoginScreen(
      onPreview: (context, username) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => EmployeeHome(
              username: username,
              onThemeChanged: (dark) => setState(() => _dark = dark),
            ),
          ),
        );
      },
    ),
  );
}

/// Hai mục Chuyến và Cá nhân của phiên xem thử giao diện.
class EmployeeHome extends StatefulWidget {
  const EmployeeHome({
    super.key,
    required this.username,
    required this.onThemeChanged,
  });
  final String username;
  final ValueChanged<bool> onThemeChanged;
  @override
  State<EmployeeHome> createState() => _EmployeeHomeState();
}

class _EmployeeHomeState extends State<EmployeeHome> {
  final _pages = PageController();
  final _trips = createDemoTrips();
  int _tab = 0;

  @override
  void dispose() {
    _pages.dispose();
    super.dispose();
  }

  void _selectTab(int value) => _pages.animateToPage(
    value,
    duration: const Duration(milliseconds: 200),
    curve: Curves.easeOut,
  );

  void _logout() => Navigator.of(context).pushAndRemoveUntil(
    MaterialPageRoute(
      builder: (_) => LoginScreen(
        onPreview: (context, username) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (_) => EmployeeHome(
                username: username,
                onThemeChanged: widget.onThemeChanged,
              ),
            ),
          );
        },
      ),
    ),
    (_) => false,
  );

  @override
  Widget build(BuildContext context) => Theme(
    data: _tab == 1 ? Theme.of(context) : employeeTheme(Brightness.light),
    child: DriverPage(
      keepTheme: true,
      statusAsset: _tab == 1 && Theme.of(context).brightness == Brightness.dark
          ? 'darkprofile-imgTinHiuWiFiPin'
          : 'trips-imgTinHiuWiFiPin',
      bottom: DriverTabs(selected: _tab, onSelected: _selectTab),
      child: PageView(
        controller: _pages,
        onPageChanged: (value) => setState(() => _tab = value),
        children: [
          TripsScreen(
            trips: _trips,
            onTabSelected: (index) {
              Navigator.of(context).popUntil((route) => route.isFirst);
              _selectTab(index);
            },
          ),
          ProfileScreen(
            username: widget.username,
            dark: Theme.of(context).brightness == Brightness.dark,
            onThemeChanged: widget.onThemeChanged,
            onLogout: _logout,
          ),
        ],
      ),
    ),
  );
}

/// Thanh chuyển mục hỗ trợ nhấn và vuốt ngang theo thiết kế.
class DriverTabs extends StatelessWidget {
  const DriverTabs({super.key, this.selected = 0, required this.onSelected});
  final int selected;
  final ValueChanged<int> onSelected;
  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onHorizontalDragEnd: (d) {
        if ((d.primaryVelocity ?? 0).abs() > 80) {
          onSelected((d.primaryVelocity ?? 0) < 0 ? 1 : 0);
        }
      },
      child: Container(
        padding: const EdgeInsets.fromLTRB(24, 8, 24, 0),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          border: const Border(top: BorderSide(color: DriverColors.border)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: List.generate(
                2,
                (i) => Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(
                      right: i == 0 ? 8 : 0,
                      left: i == 1 ? 8 : 0,
                    ),
                    child: Material(
                      color: i == selected
                          ? (dark
                                ? const Color(0xff26282c)
                                : DriverColors.canvas)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(12),
                      child: InkWell(
                        onTap: () => onSelected(i),
                        borderRadius: BorderRadius.circular(12),
                        child: SizedBox(
                          height: 44,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              FigmaAsset(
                                i == 0
                                    ? (selected == 0
                                          ? 'trips-imgGroup'
                                          : (dark
                                                ? 'darkprofile-imgGroup3'
                                                : 'profile-imgGroup3'))
                                    : (selected == 1
                                          ? (dark
                                                ? 'darkprofile-imgGroup4'
                                                : 'profile-imgGroup4')
                                          : 'trips-imgGroup1'),
                                width: 16,
                                height: 20,
                              ),
                              const SizedBox(width: 12),
                              Text(
                                i == 0 ? 'Chuyến' : 'Cá nhân',
                                style: driverText(
                                  14,
                                  FontWeight.w500,
                                  i == selected
                                      ? Theme.of(context).colorScheme.primary
                                      : (dark
                                            ? const Color(0xffaeafb3)
                                            : DriverColors.secondary),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 2),
          ],
        ),
      ),
    );
  }
}
