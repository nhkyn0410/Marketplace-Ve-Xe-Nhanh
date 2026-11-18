import 'package:file_picker/file_picker.dart';
import 'package:passenger_mobile/features/support/support_models.dart';
import 'package:url_launcher/url_launcher.dart';

/// Chọn ảnh / PDF trên máy để đính kèm khiếu nại (A24); bỏ tệp không đúng kiểu API nhận.
Future<List<SupportPickedFile>> pickSupportFiles() async {
  final files = await FilePicker.pickFiles(
    type: FileType.custom,
    allowedExtensions: const ['pdf', 'jpg', 'jpeg', 'png'],
  );
  return [
    for (final file in files)
      if (supportContentType(file.name) case final contentType?)
        SupportPickedFile(
          name: file.name,
          contentType: contentType,
          bytes: await file.xFile.readAsBytes(),
        ),
  ];
}

/// Mở tệp đính kèm bằng ứng dụng ngoài (trình duyệt / trình xem PDF).
Future<bool> openSupportUrl(Uri url) async {
  try {
    return await launchUrl(url, mode: LaunchMode.externalApplication);
  } on Exception {
    return false;
  }
}
