import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';

const _googleServerClientId = String.fromEnvironment('GOOGLE_SERVER_CLIENT_ID');
const _googleIosClientId = String.fromEnvironment('GOOGLE_IOS_CLIENT_ID');

final class GoogleAuthConfigurationException implements Exception {
  const GoogleAuthConfigurationException(this.message);

  final String message;

  @override
  String toString() => message;
}

final class GoogleAuthCancelledException implements Exception {
  const GoogleAuthCancelledException();
}

final class GoogleAuthUnavailableException implements Exception {
  const GoogleAuthUnavailableException();
}

/// Lấy Google ID token bằng SDK native. App không xin access token Google vì
/// backend chỉ cần xác minh danh tính/email và tự cấp session Vé Xe Nhanh.
final class GoogleAuthService {
  GoogleAuthService._();

  static final GoogleAuthService instance = GoogleAuthService._();

  final GoogleSignIn _google = GoogleSignIn.instance;
  Future<void>? _initialization;

  Future<String> authenticate() async {
    final serverClientId = _googleServerClientId.trim();
    if (serverClientId.isEmpty) {
      throw const GoogleAuthConfigurationException(
        'Thiếu GOOGLE_SERVER_CLIENT_ID khi build ứng dụng.',
      );
    }

    final isIos = !kIsWeb && defaultTargetPlatform == TargetPlatform.iOS;
    final iosClientId = _googleIosClientId.trim();
    if (isIos && iosClientId.isEmpty) {
      throw const GoogleAuthConfigurationException(
        'Thiếu GOOGLE_IOS_CLIENT_ID khi build ứng dụng iOS.',
      );
    }

    await (_initialization ??= _google.initialize(
      clientId: isIos ? iosClientId : null,
      serverClientId: serverClientId,
    ));

    if (!_google.supportsAuthenticate()) {
      throw const GoogleAuthConfigurationException(
        'Nền tảng này không hỗ trợ nút đăng nhập Google native.',
      );
    }

    late final GoogleSignInAccount account;
    try {
      account = await _google.authenticate();
    } on GoogleSignInException catch (error) {
      switch (error.code) {
        case GoogleSignInExceptionCode.canceled:
          throw const GoogleAuthCancelledException();
        case GoogleSignInExceptionCode.clientConfigurationError:
        case GoogleSignInExceptionCode.providerConfigurationError:
          throw const GoogleAuthConfigurationException(
            'Cấu hình OAuth Google không khớp package hoặc chữ ký ứng dụng.',
          );
        default:
          throw const GoogleAuthUnavailableException();
      }
    }
    final idToken = account.authentication.idToken;
    if (idToken == null || idToken.isEmpty) {
      throw const GoogleAuthConfigurationException(
        'Google không trả về ID token để xác minh.',
      );
    }
    return idToken;
  }
}
