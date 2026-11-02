import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

const _primary = Color(0xFF168AC0);
const _ink = Color(0xFF0D173B);
const _muted = Color(0xFF607A98);
const _pageBackground = Color(0xFFFDFEFF);
const _assetRoot = 'assets/account/saved_passengers';
const savedPassengerLimit = 5;

typedef SavedPassengerLoader = Future<List<SavedPassengerData>> Function();
typedef SavedPassengerCreator = Future<bool> Function(
  SavedPassengerFormInput input,
);
typedef SavedPassengerUpdater = Future<bool> Function(
  String passengerId,
  SavedPassengerFormInput input,
);
typedef SavedPassengerDeleter = Future<bool> Function(String passengerId);

class SavedPassengerData {
  const SavedPassengerData({
    required this.passengerId,
    required this.fullName,
    this.phone,
  });

  final String passengerId;
  final String fullName;
  final String? phone;
}

class SavedPassengerFormInput {
  const SavedPassengerFormInput({required this.fullName, this.phone});

  final String fullName;
  final String? phone;
}

class SavedPassengersScreen extends StatefulWidget {
  const SavedPassengersScreen({
    required this.loadPassengers,
    required this.createPassenger,
    required this.updatePassenger,
    required this.deletePassenger,
    required this.onBack,
    super.key,
  });

  final SavedPassengerLoader loadPassengers;
  final SavedPassengerCreator createPassenger;
  final SavedPassengerUpdater updatePassenger;
  final SavedPassengerDeleter deletePassenger;
  final VoidCallback onBack;

  @override
  State<SavedPassengersScreen> createState() => _SavedPassengersScreenState();
}

class _SavedPassengersScreenState extends State<SavedPassengersScreen> {
  late Future<List<SavedPassengerData>> _passengers = widget.loadPassengers();

  Future<void> _reload() async {
    final next = widget.loadPassengers();
    setState(() {
      _passengers = next;
    });
    await next;
  }

  Future<void> _openAdd() async {
    final saved = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      barrierColor: const Color(0x7A131C24),
      builder: (_) => _PassengerFormSheet(
        title: 'Thêm hành khách',
        submitLabel: 'Lưu hành khách',
        onSubmit: widget.createPassenger,
      ),
    );
    if (saved == true && mounted) await _reload();
  }

  Future<void> _openEdit(SavedPassengerData passenger) async {
    final saved = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      barrierColor: const Color(0x7A131C24),
      builder: (_) => _PassengerFormSheet(
        title: 'Chỉnh sửa thông tin',
        submitLabel: 'Lưu thay đổi',
        initialValue: passenger,
        onSubmit: (input) =>
            widget.updatePassenger(passenger.passengerId, input),
      ),
    );
    if (saved == true && mounted) await _reload();
  }

  Future<void> _openDelete(SavedPassengerData passenger) async {
    final deleted = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      barrierColor: const Color(0x7A131C24),
      builder: (_) => _DeletePassengerSheet(
        passengerName: passenger.fullName,
        onDelete: () => widget.deletePassenger(passenger.passengerId),
      ),
    );
    if (deleted == true && mounted) await _reload();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: const Key('saved-passengers-screen'),
      backgroundColor: _pageBackground,
      body: SafeArea(
        child: FutureBuilder<List<SavedPassengerData>>(
          future: _passengers,
          builder: (context, snapshot) {
            final passengers = snapshot.data ?? const <SavedPassengerData>[];
            final loaded =
                snapshot.connectionState == ConnectionState.done &&
                !snapshot.hasError;
            return Column(
              children: [
                _SavedPassengersHeader(
                  count: loaded ? passengers.length : null,
                  onBack: widget.onBack,
                ),
                Expanded(
                  child: Stack(
                    children: [
                      Positioned.fill(child: _bodyFor(snapshot, passengers)),
                      if (loaded && passengers.length < savedPassengerLimit)
                        Positioned(
                          right: 18,
                          bottom: 18,
                          child: _AddPassengerButton(onPressed: _openAdd),
                        ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _bodyFor(
    AsyncSnapshot<List<SavedPassengerData>> snapshot,
    List<SavedPassengerData> passengers,
  ) {
    if (snapshot.connectionState != ConnectionState.done) {
      return const Center(
        child: CircularProgressIndicator(
          key: Key('saved-passengers-loading'),
          color: _primary,
        ),
      );
    }
    if (snapshot.hasError) return _LoadError(onRetry: _reload);
    if (passengers.isEmpty) return const _EmptyPassengers();
    return RefreshIndicator(
      color: _primary,
      onRefresh: _reload,
      child: ListView.separated(
        key: const Key('saved-passengers-list'),
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(14, 8, 14, 98),
        itemCount: passengers.length,
        separatorBuilder: (_, _) => const SizedBox(height: 14),
        itemBuilder: (_, index) {
          final passenger = passengers[index];
          return _PassengerCard(
            passenger: passenger,
            onEdit: () => _openEdit(passenger),
            onDelete: () => _openDelete(passenger),
          );
        },
      ),
    );
  }
}

class _SavedPassengersHeader extends StatelessWidget {
  const _SavedPassengersHeader({required this.count, required this.onBack});

  final int? count;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 104,
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          Positioned(
            left: 16,
            top: 12,
            child: Material(
              color: const Color(0xFFF2F8FC),
              shape: const CircleBorder(),
              child: InkWell(
                key: const Key('saved-passengers-back'),
                onTap: onBack,
                customBorder: const CircleBorder(),
                child: SizedBox.square(
                  dimension: 40,
                  child: Center(
                    child: SvgPicture.asset('$_assetRoot/back.svg'),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: 14,
            left: 70,
            right: 70,
            child: Column(
              children: [
                const Text(
                  'Hành khách đã lưu',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: _ink,
                    fontSize: 18,
                    height: 1.45,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 1),
                Text(
                  count == null
                      ? '—/$savedPassengerLimit hành khách'
                      : '$count/$savedPassengerLimit hành khách',
                  key: const Key('saved-passengers-count'),
                  style: const TextStyle(
                    color: Color(0xFF7488A8),
                    fontSize: 14,
                    height: 1.45,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyPassengers extends StatelessWidget {
  const _EmptyPassengers();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(32, 0, 32, 96),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 92,
              height: 92,
              decoration: const BoxDecoration(
                color: Color(0xFFEAF7FF),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.group_outlined,
                size: 46,
                color: _primary,
              ),
            ),
            const SizedBox(height: 22),
            const Text(
              'Chưa có hành khách đã lưu',
              key: Key('saved-passengers-empty'),
              textAlign: TextAlign.center,
              style: TextStyle(
                color: _ink,
                fontSize: 18,
                height: 1.4,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Nhấn nút + để thêm hành khách thường dùng và đặt vé nhanh hơn.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFF788EAC),
                fontSize: 13,
                height: 1.55,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PassengerCard extends StatelessWidget {
  const _PassengerCard({
    required this.passenger,
    required this.onEdit,
    required this.onDelete,
  });

  final SavedPassengerData passenger;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFF2F5F8), width: .5),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0D334D67),
            blurRadius: 18,
            offset: Offset(0, 7),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 62,
            height: 62,
            decoration: BoxDecoration(
              color: const Color(0xFFF6FBFE),
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFFDEF0FA), width: 4),
            ),
            child: const Icon(
              Icons.person_outline_rounded,
              color: _primary,
              size: 30,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  passenger.fullName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: _ink,
                    fontSize: 14,
                    height: 1.45,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    SizedBox.square(
                      dimension: 15,
                      child: FittedBox(
                        child: SvgPicture.asset('$_assetRoot/phone.svg'),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        _displayPhone(passenger.phone),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: _muted,
                          fontSize: 12,
                          height: 1.45,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          _RoundAction(
            key: Key('saved-passenger-edit-${passenger.passengerId}'),
            asset: '$_assetRoot/edit.svg',
            background: const Color(0xFFEEF8FD),
            onTap: onEdit,
          ),
          const SizedBox(width: 8),
          _RoundAction(
            key: Key('saved-passenger-delete-${passenger.passengerId}'),
            asset: '$_assetRoot/delete.svg',
            background: const Color(0xFFFFF0F2),
            onTap: onDelete,
          ),
        ],
      ),
    );
  }

  static String _displayPhone(String? value) {
    final phone = value?.trim();
    if (phone == null || phone.isEmpty) return 'Chưa có số điện thoại';
    if (phone.length == 10 && phone.startsWith('0')) {
      return '${phone.substring(0, 4)} ${phone.substring(4, 7)} ${phone.substring(7)}';
    }
    return phone;
  }
}

class _RoundAction extends StatelessWidget {
  const _RoundAction({
    required this.asset,
    required this.background,
    required this.onTap,
    super.key,
  });

  final String asset;
  final Color background;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: background,
      shape: const CircleBorder(),
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: SizedBox.square(
          dimension: 32,
          child: Center(child: SvgPicture.asset(asset)),
        ),
      ),
    );
  }
}

class _AddPassengerButton extends StatelessWidget {
  const _AddPassengerButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xFF158BC1),
      elevation: 7,
      shadowColor: const Color(0x38168BC1),
      shape: const CircleBorder(),
      child: InkWell(
        key: const Key('saved-passengers-add'),
        onTap: onPressed,
        customBorder: const CircleBorder(),
        child: SizedBox.square(
          dimension: 60,
          child: Center(child: SvgPicture.asset('$_assetRoot/plus.svg')),
        ),
      ),
    );
  }
}

class _PassengerFormSheet extends StatefulWidget {
  const _PassengerFormSheet({
    required this.title,
    required this.submitLabel,
    required this.onSubmit,
    this.initialValue,
  });

  final String title;
  final String submitLabel;
  final SavedPassengerData? initialValue;
  final Future<bool> Function(SavedPassengerFormInput input) onSubmit;

  @override
  State<_PassengerFormSheet> createState() => _PassengerFormSheetState();
}

class _PassengerFormSheetState extends State<_PassengerFormSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController = TextEditingController(
    text: widget.initialValue?.fullName,
  );
  late final TextEditingController _phoneController = TextEditingController(
    text: widget.initialValue?.phone,
  );
  bool _saving = false;
  String? _error;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_saving || !_formKey.currentState!.validate()) return;
    setState(() {
      _saving = true;
      _error = null;
    });
    final phone = _phoneController.text.trim();
    final succeeded = await widget.onSubmit(
      SavedPassengerFormInput(
        fullName: _nameController.text.trim(),
        phone: phone.isEmpty ? null : phone,
      ),
    );
    if (!mounted) return;
    if (succeeded) {
      Navigator.of(context).pop(true);
      return;
    }
    setState(() {
      _saving = false;
      _error = 'Chưa thể lưu thông tin. Vui lòng thử lại.';
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedPadding(
      duration: const Duration(milliseconds: 180),
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: SafeArea(
          top: false,
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 14, 24, 24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Align(child: _SheetHandle()),
                  const SizedBox(height: 19),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          widget.title,
                          style: const TextStyle(
                            color: _ink,
                            fontSize: 20,
                            height: 1.5,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      IconButton(
                        key: const Key('saved-passenger-form-close'),
                        onPressed: _saving
                            ? null
                            : () => Navigator.of(context).pop(),
                        icon: SvgPicture.asset('$_assetRoot/close.svg'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  _FieldLabel(text: 'Họ và tên', required: true),
                  const SizedBox(height: 6),
                  TextFormField(
                    key: const Key('saved-passenger-name'),
                    controller: _nameController,
                    enabled: !_saving,
                    textCapitalization: TextCapitalization.words,
                    maxLength: 100,
                    decoration: _inputDecoration(
                      hint: 'Nhập họ và tên',
                      asset: '$_assetRoot/person.svg',
                    ),
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
                  const SizedBox(height: 16),
                  const _FieldLabel(text: 'Số điện thoại'),
                  const SizedBox(height: 6),
                  TextFormField(
                    key: const Key('saved-passenger-phone'),
                    controller: _phoneController,
                    enabled: !_saving,
                    keyboardType: TextInputType.phone,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9+]')),
                    ],
                    decoration: _inputDecoration(
                      hint: 'Nhập số điện thoại',
                      asset: '$_assetRoot/phone.svg',
                    ),
                    validator: (value) {
                      final phone = value?.trim() ?? '';
                      if (phone.isEmpty) return null;
                      if (!RegExp(r'^(0|\+84)\d{9}$').hasMatch(phone)) {
                        return 'Số điện thoại gồm 10 số, bắt đầu bằng 0 hoặc +84.';
                      }
                      return null;
                    },
                  ),
                  if (_error != null) ...[
                    const SizedBox(height: 10),
                    Text(
                      _error!,
                      key: const Key('saved-passenger-form-error'),
                      style: const TextStyle(
                        color: Color(0xFFB42318),
                        fontSize: 12,
                        height: 1.45,
                      ),
                    ),
                  ],
                  const SizedBox(height: 20),
                  SizedBox(
                    height: 54,
                    child: FilledButton(
                      key: const Key('saved-passenger-submit'),
                      onPressed: _saving ? null : _submit,
                      style: FilledButton.styleFrom(
                        backgroundColor: _primary,
                        disabledBackgroundColor: const Color(0xFF9BC8DC),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      child: _saving
                          ? const SizedBox.square(
                              dimension: 22,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : Text(
                              widget.submitLabel,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _DeletePassengerSheet extends StatefulWidget {
  const _DeletePassengerSheet({
    required this.passengerName,
    required this.onDelete,
  });

  final String passengerName;
  final Future<bool> Function() onDelete;

  @override
  State<_DeletePassengerSheet> createState() => _DeletePassengerSheetState();
}

class _DeletePassengerSheetState extends State<_DeletePassengerSheet> {
  bool _deleting = false;
  String? _error;

  Future<void> _delete() async {
    if (_deleting) return;
    setState(() {
      _deleting = true;
      _error = null;
    });
    final succeeded = await widget.onDelete();
    if (!mounted) return;
    if (succeeded) {
      Navigator.of(context).pop(true);
      return;
    }
    setState(() {
      _deleting = false;
      _error = 'Chưa thể xóa hành khách. Vui lòng thử lại.';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 14, 24, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const _SheetHandle(),
              const SizedBox(height: 19),
              const Text(
                'Xóa hành khách',
                style: TextStyle(
                  color: _ink,
                  fontSize: 20,
                  height: 1.5,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 20),
              Container(
                width: 76,
                height: 76,
                decoration: const BoxDecoration(
                  color: Color(0xFFFFE8EC),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: SvgPicture.asset(
                    '$_assetRoot/delete_illustration.svg',
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Bạn có chắc chắn muốn xóa ${widget.passengerName}?',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: _ink,
                  fontSize: 18,
                  height: 1.5,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 14),
              const Text(
                'Thông tin hành khách sẽ bị xóa khỏi danh sách đã lưu.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFF788EAC),
                  fontSize: 14,
                  height: 1.5,
                ),
              ),
              if (_error != null) ...[
                const SizedBox(height: 10),
                Text(
                  _error!,
                  style: const TextStyle(
                    color: Color(0xFFB42318),
                    fontSize: 12,
                  ),
                ),
              ],
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 54,
                child: FilledButton(
                  key: const Key('saved-passenger-confirm-delete'),
                  onPressed: _deleting ? null : _delete,
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFFFF4B5B),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: _deleting
                      ? const SizedBox.square(
                          dimension: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text(
                          'Xóa',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 14),
              SizedBox(
                width: double.infinity,
                height: 54,
                child: FilledButton(
                  key: const Key('saved-passenger-cancel-delete'),
                  onPressed: _deleting
                      ? null
                      : () => Navigator.of(context).pop(),
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFFEFF3F8),
                    foregroundColor: const Color(0xFF4A6385),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: const Text(
                    'Hủy',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
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

class _SheetHandle extends StatelessWidget {
  const _SheetHandle();

  @override
  Widget build(BuildContext context) => Container(
    width: 44,
    height: 5,
    decoration: BoxDecoration(
      color: const Color(0xFFC4CDD7),
      borderRadius: BorderRadius.circular(3),
    ),
  );
}

class _FieldLabel extends StatelessWidget {
  const _FieldLabel({required this.text, this.required = false});

  final String text;
  final bool required;

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        text: text,
        children: required
            ? const [
                TextSpan(
                  text: ' *',
                  style: TextStyle(color: Color(0xFFFF3649)),
                ),
              ]
            : null,
      ),
      style: const TextStyle(
        color: Color(0xFF4A6385),
        fontSize: 14,
        height: 1.5,
      ),
    );
  }
}

InputDecoration _inputDecoration({
  required String hint,
  required String asset,
}) {
  const border = OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(12)),
    borderSide: BorderSide(color: Color(0xFFD9E2EE)),
  );
  return InputDecoration(
    hintText: hint,
    hintStyle: const TextStyle(color: Color(0xFF8193B0), fontSize: 14),
    prefixIcon: SizedBox(
      width: 54,
      height: 52,
      child: Center(
        child: SvgPicture.asset(asset, width: 22, height: 22),
      ),
    ),
    prefixIconConstraints: const BoxConstraints.tightFor(
      width: 54,
      height: 52,
    ),
    counterText: '',
    filled: true,
    fillColor: const Color(0xFFFCFDFF),
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
    border: border,
    enabledBorder: border,
    focusedBorder: const OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(12)),
      borderSide: BorderSide(color: Color(0xFF9CD9FB)),
    ),
    errorBorder: const OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(12)),
      borderSide: BorderSide(color: Color(0xFFFF4B5B)),
    ),
  );
}

class _LoadError extends StatelessWidget {
  const _LoadError({required this.onRetry});

  final Future<void> Function() onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.cloud_off_rounded, color: _primary, size: 48),
            const SizedBox(height: 14),
            const Text(
              'Chưa thể tải hành khách đã lưu',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: _ink,
                fontSize: 17,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Vui lòng kiểm tra kết nối và thử lại.',
              textAlign: TextAlign.center,
              style: TextStyle(color: _muted, fontSize: 13),
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              key: const Key('saved-passengers-retry'),
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Thử lại'),
            ),
          ],
        ),
      ),
    );
  }
}
