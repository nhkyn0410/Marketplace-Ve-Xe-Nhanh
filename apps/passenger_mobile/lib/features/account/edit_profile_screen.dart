import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:passenger_mobile/features/account/passenger_avatar.dart';

const _primary = Color(0xFF248DBD);
const _ink = Color(0xFF0A193F);
const _muted = Color(0xFF607A8E);
const _pageBackground = Color(0xFFEDF9FE);
const _fieldBackground = Color(0xFFFBFDFF);
const _fieldBorder = Color(0xFFD8E3EF);

typedef PassengerProfileLoader = Future<PassengerProfileFormData> Function();
typedef PassengerProfileSaver = Future<bool> Function(
  PassengerProfileFormUpdate update,
);

class PassengerProfileFormData {
  const PassengerProfileFormData({
    required this.name,
    required this.email,
    required this.emailVerified,
    required this.phone,
    required this.dateOfBirth,
    required this.imageUrl,
  });

  final String name;
  final String email;
  final bool emailVerified;
  final String? phone;
  final DateTime? dateOfBirth;
  final String? imageUrl;
}

class PassengerProfileFormUpdate {
  const PassengerProfileFormUpdate({
    required this.name,
    required this.phone,
    required this.dateOfBirth,
  });

  final String name;
  final String? phone;
  final DateTime? dateOfBirth;
}

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({
    required this.loadProfile,
    required this.saveProfile,
    required this.onBack,
    required this.onSaved,
    this.errorMessage,
    this.onFieldChanged,
    super.key,
  });

  final PassengerProfileLoader loadProfile;
  final PassengerProfileSaver saveProfile;
  final VoidCallback onBack;
  final VoidCallback onSaved;
  final String? errorMessage;
  final VoidCallback? onFieldChanged;

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late Future<PassengerProfileFormData> _profile = widget.loadProfile();

  Future<void> _reload() async {
    final next = widget.loadProfile();
    setState(() {
      _profile = next;
    });
    await next;
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: Colors.white,
      ),
      child: Scaffold(
        key: const Key('edit-profile-screen'),
        backgroundColor: _pageBackground,
        body: FutureBuilder<PassengerProfileFormData>(
          future: _profile,
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return const _EditProfileLoading();
            }
            if (snapshot.hasError || !snapshot.hasData) {
              return _EditProfileError(onRetry: _reload, onBack: widget.onBack);
            }
            return _EditProfileForm(
              profile: snapshot.requireData,
              saveProfile: widget.saveProfile,
              onBack: widget.onBack,
              onSaved: widget.onSaved,
              errorMessage: widget.errorMessage,
              onFieldChanged: widget.onFieldChanged,
            );
          },
        ),
      ),
    );
  }
}

class _EditProfileForm extends StatefulWidget {
  const _EditProfileForm({
    required this.profile,
    required this.saveProfile,
    required this.onBack,
    required this.onSaved,
    required this.errorMessage,
    required this.onFieldChanged,
  });

  final PassengerProfileFormData profile;
  final PassengerProfileSaver saveProfile;
  final VoidCallback onBack;
  final VoidCallback onSaved;
  final String? errorMessage;
  final VoidCallback? onFieldChanged;

  @override
  State<_EditProfileForm> createState() => _EditProfileFormState();
}

class _EditProfileFormState extends State<_EditProfileForm> {
  final _formKey = GlobalKey<FormState>();
  late final _nameController = TextEditingController(text: widget.profile.name);
  late final _phoneController = TextEditingController(
    text: widget.profile.phone ?? '',
  );
  late DateTime? _dateOfBirth = widget.profile.dateOfBirth;
  late final _dateController = TextEditingController(
    text: _formatDate(_dateOfBirth),
  );
  bool _saving = false;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  bool get _hasChanges {
    return _nameController.text.trim() != widget.profile.name.trim() ||
        _phoneController.text.trim() != (widget.profile.phone ?? '').trim() ||
        _dateOnly(_dateOfBirth) != _dateOnly(widget.profile.dateOfBirth);
  }

  void _fieldChanged() {
    widget.onFieldChanged?.call();
    setState(() {});
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final selected = await showDatePicker(
      context: context,
      initialDate: _dateOfBirth ?? DateTime(now.year - 18, now.month, now.day),
      firstDate: DateTime(1900),
      lastDate: now,
      helpText: 'Chọn ngày sinh',
      cancelText: 'Hủy',
      confirmText: 'Chọn',
    );
    if (selected == null || !mounted) return;
    setState(() {
      _dateOfBirth = selected;
      _dateController.text = _formatDate(selected);
    });
    widget.onFieldChanged?.call();
  }

  Future<void> _save() async {
    if (_saving || !_hasChanges || !_formKey.currentState!.validate()) return;
    setState(() => _saving = true);
    final succeeded = await widget.saveProfile(
      PassengerProfileFormUpdate(
        name: _nameController.text.trim(),
        phone: _phoneController.text.trim().isEmpty
            ? null
            : _phoneController.text.trim(),
        dateOfBirth: _dateOfBirth,
      ),
    );
    if (!mounted) return;
    setState(() => _saving = false);
    if (succeeded) widget.onSaved();
  }

  @override
  Widget build(BuildContext context) {
    final topInset = MediaQuery.paddingOf(context).top;
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          key: const Key('edit-profile-scroll'),
          padding: EdgeInsets.only(
            bottom: MediaQuery.paddingOf(context).bottom + 18,
          ),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 412),
              child: Column(
                children: [
                  // Thanh tiêu đề trên cùng: nút back + tiêu đề
                  Padding(
                    padding: EdgeInsets.fromLTRB(16, topInset + 8, 16, 16),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Material(
                            color: Colors.white,
                            shape: const CircleBorder(),
                            elevation: 1,
                            shadowColor: const Color(0x1421404F),
                            child: IconButton(
                              key: const Key('edit-profile-back'),
                              onPressed: widget.onBack,
                              icon: const Icon(Icons.chevron_left_rounded),
                              color: _ink,
                              iconSize: 26,
                              visualDensity: VisualDensity.compact,
                            ),
                          ),
                        ),
                        const Text(
                          'Chỉnh sửa thông tin',
                          style: TextStyle(
                            color: _ink,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 6),
                  // Avatar người dùng
                  Center(
                    child: PassengerAvatar(
                      size: 96,
                      imageUrl: widget.profile.imageUrl,
                      showCameraBadge: true,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    key: const Key('edit-profile-form-card'),
                    margin: const EdgeInsets.symmetric(horizontal: 13),
                    padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Thông tin cá nhân',
                            style: TextStyle(
                              color: _ink,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 12),
                          _FormFieldLabel(label: 'Họ và tên', required: true),
                          _ProfileTextField(
                            key: const Key('edit-profile-name'),
                            controller: _nameController,
                            icon: Icons.person_outline_rounded,
                            textInputAction: TextInputAction.next,
                            onChanged: (_) => _fieldChanged(),
                            validator: (value) {
                              final name = value?.trim() ?? '';
                              if (name.isEmpty) {
                                return 'Vui lòng nhập họ và tên.';
                              }
                              if (name.length > 100) {
                                return 'Họ và tên tối đa 100 ký tự.';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 10),
                          const _FormFieldLabel(label: 'Ngày sinh'),
                          _ProfileTextField(
                            key: const Key('edit-profile-birth-date'),
                            controller: _dateController,
                            icon: Icons.calendar_month_outlined,
                            readOnly: true,
                            suffixIcon: Icons.keyboard_arrow_down_rounded,
                            onTap: _pickDate,
                          ),
                          const SizedBox(height: 10),
                          const _FormFieldLabel(label: 'Số điện thoại'),
                          _ProfileTextField(
                            key: const Key('edit-profile-phone'),
                            controller: _phoneController,
                            icon: Icons.phone_outlined,
                            keyboardType: TextInputType.phone,
                            textInputAction: TextInputAction.done,
                            onChanged: (_) => _fieldChanged(),
                            validator: (value) {
                              final phone = value?.trim() ?? '';
                              if (phone.isEmpty &&
                                  widget.profile.phone != null) {
                                return 'API hiện chưa hỗ trợ xóa số điện thoại.';
                              }
                              if (phone.isNotEmpty &&
                                  !RegExp(r'^(0|\+84)\d{9}$').hasMatch(phone)) {
                                return 'Số điện thoại phải bắt đầu bằng 0 hoặc +84.';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 10),
                          const _FormFieldLabel(label: 'Email', required: true),
                          _ReadOnlyEmail(
                            email: widget.profile.email,
                            verified: widget.profile.emailVerified,
                          ),
                          if (widget.errorMessage != null) ...[
                            const SizedBox(height: 10),
                            Text(
                              widget.errorMessage!,
                              key: const Key('edit-profile-error'),
                              style: const TextStyle(
                                color: Color(0xFFB42318),
                                fontSize: 11.5,
                                height: 1.4,
                              ),
                            ),
                          ],
                          const SizedBox(height: 16),
                          SizedBox(
                            width: double.infinity,
                            height: 44,
                            child: FilledButton(
                              key: const Key('edit-profile-save'),
                              onPressed: _saving || !_hasChanges ? null : _save,
                              style: FilledButton.styleFrom(
                                backgroundColor: _primary,
                                disabledBackgroundColor: const Color(
                                  0xFFB9CEDA,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: _saving
                                  ? const SizedBox.square(
                                      dimension: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: Colors.white,
                                      ),
                                    )
                                  : const Text(
                                      'Lưu thay đổi',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
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
          ),
        );
      },
    );
  }
}

class _FormFieldLabel extends StatelessWidget {
  const _FormFieldLabel({required this.label, this.required = false});

  final String label;
  final bool required;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Text.rich(
        TextSpan(
          text: label,
          children: required
              ? const [
                  TextSpan(
                    text: ' *',
                    style: TextStyle(color: Color(0xFFFF2B25)),
                  ),
                ]
              : null,
        ),
        style: const TextStyle(color: _ink, fontSize: 10.5, height: 1.4),
      ),
    );
  }
}

class _ProfileTextField extends StatelessWidget {
  const _ProfileTextField({
    required this.controller,
    required this.icon,
    this.readOnly = false,
    this.suffixIcon,
    this.onTap,
    this.onChanged,
    this.validator,
    this.keyboardType,
    this.textInputAction,
    super.key,
  });

  final TextEditingController controller;
  final IconData icon;
  final bool readOnly;
  final IconData? suffixIcon;
  final VoidCallback? onTap;
  final ValueChanged<String>? onChanged;
  final FormFieldValidator<String>? validator;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      readOnly: readOnly,
      onTap: onTap,
      onChanged: onChanged,
      validator: validator,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      style: const TextStyle(color: _ink, fontSize: 11.5),
      decoration: _fieldDecoration(prefixIcon: icon, suffixIcon: suffixIcon),
    );
  }
}

class _ReadOnlyEmail extends StatelessWidget {
  const _ReadOnlyEmail({required this.email, required this.verified});

  final String email;
  final bool verified;

  @override
  Widget build(BuildContext context) {
    return Container(
      key: const Key('edit-profile-email'),
      height: 42,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFEDF2F7),
        borderRadius: BorderRadius.circular(7),
      ),
      child: Row(
        children: [
          const Icon(Icons.mail_outline_rounded, size: 18, color: _muted),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              email,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: _muted, fontSize: 10.5),
            ),
          ),
          if (verified) ...[
            const SizedBox(width: 6),
            const Icon(Icons.verified_rounded, size: 15, color: _primary),
          ],
        ],
      ),
    );
  }
}

InputDecoration _fieldDecoration({
  required IconData prefixIcon,
  IconData? suffixIcon,
}) {
  final border = OutlineInputBorder(
    borderRadius: BorderRadius.circular(7),
    borderSide: const BorderSide(color: _fieldBorder, width: .8),
  );
  return InputDecoration(
    filled: true,
    fillColor: _fieldBackground,
    isDense: true,
    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
    prefixIcon: Icon(prefixIcon, size: 18, color: _muted),
    prefixIconConstraints: const BoxConstraints(minWidth: 40),
    suffixIcon: suffixIcon == null
        ? null
        : Icon(suffixIcon, size: 18, color: _muted),
    border: border,
    enabledBorder: border,
    focusedBorder: border.copyWith(
      borderSide: const BorderSide(color: _primary, width: 1.1),
    ),
    errorBorder: border.copyWith(
      borderSide: const BorderSide(color: Color(0xFFB42318)),
    ),
    focusedErrorBorder: border.copyWith(
      borderSide: const BorderSide(color: Color(0xFFB42318), width: 1.1),
    ),
    errorStyle: const TextStyle(fontSize: 10),
  );
}

class _EditProfileLoading extends StatelessWidget {
  const _EditProfileLoading();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(
        key: Key('edit-profile-loading'),
        color: _primary,
      ),
    );
  }
}

class _EditProfileError extends StatelessWidget {
  const _EditProfileError({required this.onRetry, required this.onBack});

  final Future<void> Function() onRetry;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.cloud_off_rounded, size: 44, color: _muted),
              const SizedBox(height: 12),
              const Text(
                'Chưa thể tải thông tin cá nhân',
                style: TextStyle(
                  color: _ink,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 14),
              FilledButton(
                key: const Key('edit-profile-retry'),
                onPressed: onRetry,
                child: const Text('Thử lại'),
              ),
              TextButton(onPressed: onBack, child: const Text('Quay lại')),
            ],
          ),
        ),
      ),
    );
  }
}

String _formatDate(DateTime? value) {
  if (value == null) return 'Chọn ngày sinh';
  return '${value.day.toString().padLeft(2, '0')}/'
      '${value.month.toString().padLeft(2, '0')}/${value.year}';
}

String _dateOnly(DateTime? value) => value == null
    ? ''
    : '${value.year}-${value.month.toString().padLeft(2, '0')}-'
          '${value.day.toString().padLeft(2, '0')}';
