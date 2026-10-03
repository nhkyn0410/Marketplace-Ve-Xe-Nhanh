import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:passenger_mobile/main.dart';

void main() {
  testWidgets('màn đăng nhập mở ở bước nhập email', (tester) async {
    await tester.pumpWidget(const PassengerApp());

    expect(find.text('Đăng nhập'), findsOneWidget);
    expect(find.text('Email'), findsOneWidget);
    expect(find.widgetWithText(FilledButton, 'Gửi mã OTP'), findsOneWidget);

    // Chưa yêu cầu mã thì chưa được hiện ô nhập OTP.
    expect(find.text('Mã OTP (6 chữ số)'), findsNothing);
  });
}
