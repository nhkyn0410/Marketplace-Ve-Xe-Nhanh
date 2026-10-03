import 'package:api_client_dart/api_client_dart.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  // Chép đúng response thật của POST /v1/auth/otp/verify.
  const wire = <String, dynamic>{
    'accessToken': 'eyJhbGciOiJSUzI1NiJ9.payload.sig',
    'tokenType': 'Bearer',
    'expiresIn': 900,
    'scope': 'passenger',
    'role': 'PASSENGER',
    // IAM-002: login trả kèm refresh token.
    'refreshToken': 'opaque-refresh-token',
    'refreshExpiresIn': 2592000,
  };

  AuthTokenResponseDtoOutput decode(Map<String, dynamic> json) =>
      standardSerializers.deserializeWith(
        AuthTokenResponseDtoOutput.serializer,
        json,
      )!;

  Map<Object?, Object?> encode(AuthTokenResponseDtoOutput dto) =>
      standardSerializers.serializeWith(
            AuthTokenResponseDtoOutput.serializer,
            dto,
          )!
          as Map<Object?, Object?>;

  test('"Bearer" trên dây → enum member `bearer`', () {
    final dto = decode(wire);

    expect(dto.tokenType, AuthTokenResponseDtoOutputTokenTypeEnum.bearer);
    expect(dto.scope, AuthTokenResponseDtoOutputScopeEnum.passenger);
    expect(dto.expiresIn, 900);
    expect(dto.role, 'PASSENGER');
  });

  test('round-trip không mất mát: decode rồi encode ra đúng JSON ban đầu', () {
    expect(encode(decode(wire)), equals(wire));
  });

  test('so sánh chuỗi thẳng với tên member là SAI', () {
    // Tên member Dart là `bearer` (thường), giá trị trên dây là `Bearer` (hoa).
    // Ghi lại bằng test để không ai viết `dto.tokenType.name == 'Bearer'`.
    expect(decode(wire).tokenType.name, 'bearer');
    expect(decode(wire).tokenType.name == 'Bearer', isFalse);
  });

  test('scope `operator` giữ đúng giá trị dù member phải là `operator_`', () {
    // `operator` là từ khoá của Dart nên generator phải thêm gạch dưới.
    final dto = decode({...wire, 'scope': 'operator', 'role': 'DRIVER'});

    expect(dto.scope, AuthTokenResponseDtoOutputScopeEnum.operator_);
    expect(encode(dto)['scope'], 'operator');
  });
}
