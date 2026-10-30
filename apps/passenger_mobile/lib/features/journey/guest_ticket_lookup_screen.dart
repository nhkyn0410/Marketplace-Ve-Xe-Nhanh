import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:passenger_mobile/features/home/route_dock_tabbar.dart';
import 'package:passenger_mobile/features/journey/guest_journey_shared.dart';

const _assetRoot = 'assets/journey/guest_lookup';
const _primary = Color(0xFF2B7EAD);
const _ink = Color(0xFF08213B);
const _body = Color(0xFF607A8E);
const _label = Color(0xFF486983);
const _pageBackground = Color(0xFFE3F6FE);

/// Tra cứu chỉ bằng email liên hệ (như bản web): API trả các đơn của email sau khi xác minh OTP.
typedef GuestTicketLookupCallback = Future<void> Function(String email);

class GuestTicketLookupScreen extends StatefulWidget {
  const GuestTicketLookupScreen({
    required this.onLoginRequested,
    required this.onTabSelected,
    this.onRequestOtp,
    this.onFaqRequested,
    this.onSupportRequested,
    super.key,
  });

  final VoidCallback onLoginRequested;
  final ValueChanged<int> onTabSelected;
  final GuestTicketLookupCallback? onRequestOtp;
  final VoidCallback? onFaqRequested;
  final VoidCallback? onSupportRequested;

  @override
  State<GuestTicketLookupScreen> createState() =>
      _GuestTicketLookupScreenState();
}

class _GuestTicketLookupScreenState extends State<GuestTicketLookupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  bool _submitting = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: const Key('guest-ticket-lookup-screen'),
      extendBody: true,
      backgroundColor: _pageBackground,
      bottomNavigationBar: RouteDockTabBar(
        currentIndex: 3,
        onTap: widget.onTabSelected,
      ),
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.dark.copyWith(
          statusBarColor: Colors.transparent,
          systemNavigationBarColor: _pageBackground,
        ),
        child: JourneyFixedPage(
          scrollKey: const Key('guest-ticket-lookup-scroll'),
          header: _JourneyHeader(onLoginRequested: widget.onLoginRequested),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildLookupCard(),
              const SizedBox(height: 14),
              _SupportCard(
                onFaqRequested: widget.onFaqRequested ?? _showFaqPlaceholder,
                onSupportRequested:
                    widget.onSupportRequested ?? _showSupportPlaceholder,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLookupCard() {
    return _SurfaceCard(
      key: const Key('guest-ticket-lookup-form-card'),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const _LookupIntroduction(),
            const SizedBox(height: 14),
            _LookupField(
              fieldKey: const Key('guest-email-field'),
              controller: _emailController,
              label: 'Email liên hệ',
              hintText: 'Nhập email dùng khi đặt vé',
              iconAsset: '$_assetRoot/email_input.svg',
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.done,
              autofillHints: const [AutofillHints.email],
              validator: _validateEmail,
              onFieldSubmitted: (_) => _requestOtp(),
            ),
            const SizedBox(height: 14),
            const _OtpHelper(),
            const SizedBox(height: 14),
            SizedBox(
              height: 44,
              child: FilledButton(
                key: const Key('guest-request-otp-button'),
                onPressed: _submitting ? null : _requestOtp,
                style: FilledButton.styleFrom(
                  backgroundColor: _primary,
                  disabledBackgroundColor: const Color(0xFF91B9D0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(13),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                ),
                child: _submitting
                    ? const SizedBox.square(
                        dimension: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.2,
                          color: Colors.white,
                        ),
                      )
                    : Stack(
                        alignment: Alignment.center,
                        children: [
                          const Center(
                            child: Text(
                              'Nhận mã OTP',
                              maxLines: 1,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                height: 22 / 15,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: SizedBox.square(
                              dimension: 20,
                              child: Center(
                                child: SvgPicture.asset(
                                  '$_assetRoot/arrow_right.svg',
                                  width: 15.58,
                                  height: 11.42,
                                  excludeFromSemantics: true,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String? _validateEmail(String? value) {
    final email = value?.trim() ?? '';
    if (email.isEmpty) return 'Vui lòng nhập email liên hệ.';
    if (!RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(email)) {
      return 'Email liên hệ chưa đúng định dạng.';
    }
    return null;
  }

  Future<void> _requestOtp() async {
    FocusManager.instance.primaryFocus?.unfocus();
    if (_formKey.currentState?.validate() != true) return;

    final callback = widget.onRequestOtp;
    if (callback == null) {
      _showMessage('Màn xác minh OTP sẽ được nối ở bước tiếp theo.');
      return;
    }

    setState(() => _submitting = true);
    try {
      await callback(_emailController.text.trim());
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  void _showFaqPlaceholder() {
    _showMessage('Câu hỏi thường gặp sẽ được mở ở bước tiếp theo.');
  }

  void _showSupportPlaceholder() {
    _showMessage('Kênh hỗ trợ sẽ được nối ở bước tiếp theo.');
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }
}

class _JourneyHeader extends StatelessWidget {
  const _JourneyHeader({required this.onLoginRequested});

  final VoidCallback onLoginRequested;

  @override
  Widget build(BuildContext context) {
    final logoTop = brandLogoTop(MediaQuery.paddingOf(context).top);
    return SizedBox(
      height: 250,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            '$journeyAssetRoot/hero_250.png',
            fit: BoxFit.cover,
            alignment: Alignment.topCenter,
            filterQuality: FilterQuality.high,
          ),
          Positioned(
            left: brandLogoLeft,
            top: logoTop,
            width: brandLogoSize.width,
            height: brandLogoSize.height,
            child: const JourneyBrandLogo(),
          ),
          Positioned(
            left: 18,
            right: 18,
            top: logoTop + 40,
            child: const Text(
              'Tra cứu hành trình',
              maxLines: 1,
              overflow: TextOverflow.fade,
              softWrap: false,
              style: TextStyle(
                color: Color(0xFF041725),
                fontSize: 24,
                height: 1.5,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Positioned(
            left: 22,
            top: logoTop + 119,
            width: 128,
            height: 40,
            child: FilledButton(
              key: const Key('guest-journey-login-button'),
              onPressed: onLoginRequested,
              style: FilledButton.styleFrom(
                backgroundColor: _primary,
                padding: const EdgeInsets.fromLTRB(12, 0, 10, 0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(13),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Flexible(
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        'Đăng nhập',
                        maxLines: 1,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          height: 22 / 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 6),
                  SizedBox.square(
                    dimension: 20,
                    child: Center(
                      child: SvgPicture.asset(
                        '$_assetRoot/arrow_right.svg',
                        width: 15.58,
                        height: 11.42,
                        excludeFromSemantics: true,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LookupIntroduction extends StatelessWidget {
  const _LookupIntroduction();

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 52,
          height: 52,
          decoration: BoxDecoration(
            color: const Color(0xFFE8F6FD),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Center(
            child: SvgPicture.asset(
              '$_assetRoot/ticket_intro.svg',
              width: 24.63,
              height: 19.63,
              excludeFromSemantics: true,
            ),
          ),
        ),
        const SizedBox(width: 12),
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Tra cứu vé khách vãng lai',
                style: TextStyle(
                  color: _ink,
                  fontSize: 17,
                  height: 25 / 17,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 3),
              Text(
                'Nhập email liên hệ đã dùng khi đặt vé để tra cứu thông tin hành trình của bạn.',
                style: TextStyle(
                  color: _body,
                  fontSize: 12.5,
                  height: 19 / 12.5,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _LookupField extends StatelessWidget {
  const _LookupField({
    required this.fieldKey,
    required this.controller,
    required this.label,
    required this.hintText,
    required this.iconAsset,
    required this.validator,
    this.keyboardType,
    this.textInputAction,
    this.autofillHints,
    this.onFieldSubmitted,
  });

  final Key fieldKey;
  final TextEditingController controller;
  final String label;
  final String hintText;
  final String iconAsset;
  final FormFieldValidator<String> validator;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final Iterable<String>? autofillHints;
  final ValueChanged<String>? onFieldSubmitted;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: _label,
            fontSize: 13,
            height: 19 / 13,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 6),
        TextFormField(
          key: fieldKey,
          controller: controller,
          keyboardType: keyboardType,
          textInputAction: textInputAction,
          autofillHints: autofillHints,
          autocorrect: false,
          enableSuggestions: keyboardType != TextInputType.emailAddress,
          validator: validator,
          onFieldSubmitted: onFieldSubmitted,
          style: const TextStyle(
            color: _ink,
            fontSize: 13,
            height: 19 / 13,
            fontWeight: FontWeight.w400,
          ),
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: const TextStyle(
              color: Color(0xFF889AB2),
              fontSize: 13,
              height: 19 / 13,
              fontWeight: FontWeight.w400,
            ),
            filled: true,
            fillColor: Colors.white,
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(vertical: 15),
            prefixIconConstraints: const BoxConstraints.tightFor(
              width: 48,
              height: 50,
            ),
            prefixIcon: SizedBox(
              width: 48,
              height: 50,
              child: Center(
                child: SvgPicture.asset(
                  iconAsset,
                  width: 18.06,
                  height: 14.4,
                  excludeFromSemantics: true,
                ),
              ),
            ),
            border: _inputBorder(const Color(0xFFD1DEEA)),
            enabledBorder: _inputBorder(const Color(0xFFD1DEEA)),
            focusedBorder: _inputBorder(_primary, width: 1.4),
            errorBorder: _inputBorder(const Color(0xFFB42318)),
            focusedErrorBorder: _inputBorder(
              const Color(0xFFB42318),
              width: 1.4,
            ),
            errorStyle: const TextStyle(
              color: Color(0xFFB42318),
              fontSize: 11.5,
              height: 1.35,
            ),
          ),
        ),
      ],
    );
  }

  static OutlineInputBorder _inputBorder(Color color, {double width = 1}) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: color, width: width),
    );
  }
}

class _OtpHelper extends StatelessWidget {
  const _OtpHelper();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFEAF7FE),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          SizedBox.square(
            dimension: 23,
            child: Center(
              child: SvgPicture.asset(
                '$_assetRoot/email_helper.svg',
                width: 18.88,
                height: 15.05,
                excludeFromSemantics: true,
              ),
            ),
          ),
          const SizedBox(width: 10),
          const Expanded(
            child: Text(
              'Mã OTP được gửi đến email liên hệ để xác minh',
              maxLines: 1,
              softWrap: false,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: _label,
                fontSize: 11.5,
                height: 17 / 11.5,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SupportCard extends StatelessWidget {
  const _SupportCard({
    required this.onFaqRequested,
    required this.onSupportRequested,
  });

  final VoidCallback onFaqRequested;
  final VoidCallback onSupportRequested;

  @override
  Widget build(BuildContext context) {
    return _SurfaceCard(
      key: const Key('guest-ticket-support-card'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: const Color(0xFFEAF7FE),
                  borderRadius: BorderRadius.circular(13),
                ),
                child: Center(
                  child: SvgPicture.asset(
                    '$_assetRoot/headset.svg',
                    width: 24,
                    height: 24,
                    excludeFromSemantics: true,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Cần hỗ trợ?',
                      style: TextStyle(
                        color: _ink,
                        fontSize: 16,
                        height: 1.5,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      'Chúng tôi luôn sẵn sàng giúp bạn.',
                      style: TextStyle(
                        color: _body,
                        fontSize: 12,
                        height: 1.5,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: _SupportAction(
                  key: const Key('guest-ticket-faq-button'),
                  iconAsset: '$_assetRoot/help.svg',
                  label: 'Câu hỏi thường gặp',
                  onTap: onFaqRequested,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _SupportAction(
                  key: const Key('guest-ticket-support-button'),
                  iconAsset: '$_assetRoot/phone.svg',
                  label: 'Liên hệ hỗ trợ',
                  onTap: onSupportRequested,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SupportAction extends StatelessWidget {
  const _SupportAction({
    required this.iconAsset,
    required this.label,
    required this.onTap,
    super.key,
  });

  final String iconAsset;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xFFEAF7FE),
      borderRadius: BorderRadius.circular(12),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            children: [
              SizedBox.square(
                dimension: 20,
                child: Center(
                  child: SvgPicture.asset(
                    iconAsset,
                    width: 16.45,
                    height: 16.45,
                    excludeFromSemantics: true,
                  ),
                ),
              ),
              const SizedBox(width: 7),
              Expanded(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    label,
                    maxLines: 1,
                    style: const TextStyle(
                      color: Color(0xFF14649B),
                      fontSize: 10.5,
                      height: 16 / 10.5,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SurfaceCard extends StatelessWidget {
  const _SurfaceCard({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFCCE8F7)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x12488AAD),
            offset: Offset(0, 3),
            blurRadius: 12,
          ),
        ],
      ),
      child: child,
    );
  }
}
