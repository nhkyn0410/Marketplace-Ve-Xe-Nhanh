import 'package:test/test.dart';
import 'package:api_client_dart/api_client_dart.dart';


/// tests for AuthApi
void main() {
  final instance = ApiClientDart().getAuthApi();

  group(AuthApi, () {
    //Future<OAuthRedirectResponseDtoOutput> authControllerOauth(String provider, OAuthInitDto oAuthInitDto) async
    test('test authControllerOauth', () async {
      // TODO
    });

    //Future<AuthTokenResponseDtoOutput> authControllerOauthSession() async
    test('test authControllerOauthSession', () async {
      // TODO
    });

    //Future<AuthTokenResponseDtoOutput> authControllerOperatorLogin(CredentialLoginDto credentialLoginDto) async
    test('test authControllerOperatorLogin', () async {
      // TODO
    });

    //Future<AuthTokenResponseDtoOutput> authControllerPlatformLogin(CredentialLoginDto credentialLoginDto) async
    test('test authControllerPlatformLogin', () async {
      // TODO
    });

    //Future<MessageResponseDtoOutput> authControllerRegister(RegisterDto registerDto) async
    test('test authControllerRegister', () async {
      // TODO
    });

    //Future<MessageResponseDtoOutput> authControllerRequestOtp(OtpRequestDto otpRequestDto) async
    test('test authControllerRequestOtp', () async {
      // TODO
    });

    //Future<AuthTokenResponseDtoOutput> authControllerVerifyOtp(OtpVerifyDto otpVerifyDto) async
    test('test authControllerVerifyOtp', () async {
      // TODO
    });

  });
}
