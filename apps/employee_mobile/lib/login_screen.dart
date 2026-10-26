import 'package:flutter/material.dart';

import 'design_system.dart';
import 'profile_screens.dart';

/// Màn đăng nhập theo Figma, mở phiên minh họa sau khi vuốt xác nhận.
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key, required this.onPreview});
  final void Function(BuildContext, String) onPreview;
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _form = GlobalKey<FormState>();
  final _username = TextEditingController();
  final _password = TextEditingController();
  @override
  void dispose() {
    _username.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _preview() async {
    if (!_form.currentState!.validate()) return;
    FocusScope.of(context).unfocus();
    final accepted = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Xem thử giao diện'),
        content: const Text(
          'Ứng dụng đang dùng dữ liệu mẫu từ Figma, chưa xác thực tài khoản với máy chủ. '
          'Bạn có thể dùng tên và mật khẩu bất kỳ để thử giao diện. Không nhập mật khẩu thật.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Quay lại'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Mở bản xem thử'),
          ),
        ],
      ),
    );
    if (!mounted || accepted != true) return;
    _password.clear();
    widget.onPreview(context, _username.text.trim());
  }

  @override
  Widget build(BuildContext context) => DriverPage(
    background: DriverColors.canvas,
    statusBackground: DriverColors.header,
    lightStatus: true,
    child: LayoutBuilder(
      builder: (context, box) => SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: box.maxHeight),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  Container(
                    height: 256,
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: DriverColors.header,
                      borderRadius: BorderRadius.vertical(
                        bottom: Radius.circular(24),
                      ),
                    ),
                    child: Stack(
                      children: [
                        const Positioned(
                          left: 24,
                          top: 14,
                          child: _BrandLogo(),
                        ),
                        const Positioned(
                          top: 72,
                          left: 0,
                          right: 0,
                          child: Center(
                            child: FigmaAsset(
                              'login-imgIconNhanVienDiNon',
                              width: 96,
                              height: 96,
                            ),
                          ),
                        ),
                        Positioned(
                          left: 24,
                          right: 24,
                          top: 200,
                          child: Text(
                            'Đăng nhập nhân viên',
                            textAlign: TextAlign.center,
                            style: driverText(
                              24,
                              FontWeight.w700,
                              Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 28, 24, 0),
                    child: Form(
                      key: _form,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Tên đăng nhập',
                            style: driverText(
                              14,
                              FontWeight.w600,
                              DriverColors.text,
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: _username,
                            autocorrect: false,
                            textInputAction: TextInputAction.next,
                            style: driverText(
                              16,
                              FontWeight.w400,
                              DriverColors.text,
                            ),
                            decoration: const InputDecoration(
                              hintText: 'VD: mayexpress/nv.minh',
                              constraints: BoxConstraints(minHeight: 64),
                              prefixIcon: Padding(
                                padding: EdgeInsets.all(18),
                                child: FigmaAsset(
                                  'login-imgGroup',
                                  width: 16,
                                  height: 17,
                                ),
                              ),
                            ),
                            validator: (value) =>
                                value == null || value.trim().isEmpty
                                ? 'Nhập tên đăng nhập'
                                : null,
                          ),
                          const SizedBox(height: 24),
                          Text(
                            'Mật khẩu',
                            style: driverText(
                              14,
                              FontWeight.w600,
                              DriverColors.text,
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: _password,
                            obscureText: true,
                            enableSuggestions: false,
                            autocorrect: false,
                            style: driverText(
                              16,
                              FontWeight.w400,
                              DriverColors.text,
                            ),
                            decoration: const InputDecoration(
                              hintText: 'Nhập mật khẩu',
                              constraints: BoxConstraints(minHeight: 64),
                              prefixIcon: Padding(
                                padding: EdgeInsets.all(18),
                                child: FigmaAsset(
                                  'login-imgGroup1',
                                  width: 16,
                                  height: 19,
                                ),
                              ),
                            ),
                            validator: (value) => value == null || value.isEmpty
                                ? 'Nhập mật khẩu'
                                : null,
                          ),
                          const SizedBox(height: 24),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: SwipeAction(
                              label: 'Đăng nhập',
                              onComplete: _preview,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Center(
                            child: Text(
                              'Bản xem thử · Không nhập mật khẩu thật',
                              style: driverText(
                                12,
                                FontWeight.w400,
                                DriverColors.secondary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 36, 24, 22),
                child: GestureDetector(
                  onHorizontalDragEnd: (details) {
                    if ((details.primaryVelocity ?? 0) < -80) {
                      openDriverPage(
                        context,
                        ContactScreen(
                          username: _username.text.trim().isEmpty
                              ? 'mayexpress/nv.minh'
                              : _username.text.trim(),
                        ),
                      );
                    }
                  },
                  child: SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: const Color(0xfff7f9fa),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () => openDriverPage(
                        context,
                        ContactScreen(
                          username: _username.text.trim().isEmpty
                              ? 'mayexpress/nv.minh'
                              : _username.text.trim(),
                        ),
                      ),
                      child: const Text('← Để liên hệ nhà xe'),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

class _BrandLogo extends StatelessWidget {
  const _BrandLogo();
  @override
  Widget build(BuildContext context) => const SizedBox(
    width: 156,
    height: 40,
    child: Stack(
      children: [
        Positioned(
          left: 0,
          top: 5,
          width: 40,
          height: 31,
          child: FigmaAsset('login-imgVector', width: 40, height: 31),
        ),
        Positioned(
          left: 40,
          top: 12,
          width: 116,
          height: 16,
          child: FigmaAsset('login-imgVector1', width: 116, height: 16),
        ),
      ],
    ),
  );
}
