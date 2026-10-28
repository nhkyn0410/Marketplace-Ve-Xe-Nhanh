import 'package:flutter/material.dart';
import 'package:passenger_mobile/features/journey/guest_journey_otp_screen.dart';
import 'package:passenger_mobile/features/journey/guest_ticket_detail_screen.dart';
import 'package:passenger_mobile/features/journey/guest_ticket_lookup_screen.dart';
import 'package:passenger_mobile/features/journey/guest_ticket_results_screen.dart';

enum _GuestJourneyStep { lookup, otp, results, detail }

class GuestJourneyFlow extends StatefulWidget {
  const GuestJourneyFlow({
    required this.onLoginRequested,
    required this.onTabSelected,
    this.onFaqRequested,
    this.onSupportRequested,
    super.key,
  });

  final VoidCallback onLoginRequested;
  final ValueChanged<int> onTabSelected;
  final VoidCallback? onFaqRequested;
  final VoidCallback? onSupportRequested;

  @override
  State<GuestJourneyFlow> createState() => _GuestJourneyFlowState();
}

class _GuestJourneyFlowState extends State<GuestJourneyFlow> {
  _GuestJourneyStep _step = _GuestJourneyStep.lookup;
  // Kết quả tra cứu vẫn là dữ liệu mẫu — chưa nối API `/guest/ticket-lookup/*`.
  final String _bookingCode = 'VXN-8F3K2Q';
  String _email = 'minh.nguyen@gmail.com';

  String get _maskedEmail {
    final parts = _email.split('@');
    if (parts.length != 2 || parts.first.isEmpty) return 'minh***@gmail.com';
    final visibleLength = parts.first.length < 4 ? parts.first.length : 4;
    final visible = parts.first.substring(0, visibleLength);
    return '$visible***@${parts.last}';
  }

  void _show(_GuestJourneyStep step) {
    FocusManager.instance.primaryFocus?.unfocus();
    setState(() => _step = step);
  }

  @override
  Widget build(BuildContext context) {
    // Đổi bước tức thì, không trượt (như màn Tài khoản khi chưa đăng nhập).
    return KeyedSubtree(
      key: ValueKey(_step),
      child: switch (_step) {
        _GuestJourneyStep.lookup => GuestTicketLookupScreen(
          onLoginRequested: widget.onLoginRequested,
          onTabSelected: widget.onTabSelected,
          onFaqRequested: widget.onFaqRequested,
          onSupportRequested: widget.onSupportRequested,
          onRequestOtp: (email) async {
            _email = email;
            _show(_GuestJourneyStep.otp);
          },
        ),
        _GuestJourneyStep.otp => GuestJourneyOtpScreen(
          maskedEmail: _maskedEmail,
          onVerified: () => _show(_GuestJourneyStep.results),
          onChangeLookup: () => _show(_GuestJourneyStep.lookup),
          onTabSelected: widget.onTabSelected,
        ),
        _GuestJourneyStep.results => GuestTicketResultsScreen(
          bookingCode: _bookingCode,
          maskedEmail: _maskedEmail,
          onOpenTicket: () => _show(_GuestJourneyStep.detail),
          onChangeLookup: () => _show(_GuestJourneyStep.lookup),
          onTabSelected: widget.onTabSelected,
        ),
        _GuestJourneyStep.detail => GuestTicketDetailScreen(
          onBack: () => _show(_GuestJourneyStep.results),
          onTabSelected: widget.onTabSelected,
        ),
      },
    );
  }
}
