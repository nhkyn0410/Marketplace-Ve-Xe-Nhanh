import 'dart:async';

import 'package:employee_mobile/demo_data.dart';
import 'package:employee_mobile/design_system.dart';
import 'package:employee_mobile/ticket_screens.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class _CameraPlatform extends MobileScannerPlatform {
  _CameraPlatform({this.firstError});
  final MobileScannerException? firstError;
  final captures = StreamController<BarcodeCapture?>.broadcast();
  final options = <StartOptions>[];
  var disposals = 0;
  var stops = 0;

  @override
  Stream<BarcodeCapture?> get barcodesStream => captures.stream;
  @override
  Stream<TorchState> get torchStateStream => const Stream.empty();
  @override
  Stream<double> get zoomScaleStateStream => const Stream.empty();
  @override
  Future<MobileScannerViewAttributes> start(StartOptions startOptions) async {
    options.add(startOptions);
    if (firstError != null && disposals == 0) throw firstError!;
    return MobileScannerViewAttributes(
      cameraDirection: startOptions.cameraDirection,
      currentTorchMode: TorchState.unavailable,
      size: const Size(1280, 720),
      numberOfCameras: 1,
    );
  }

  @override
  Widget buildCameraView() => const ColoredBox(
    key: ValueKey('camera-live-preview'),
    color: Colors.blue,
  );
  @override
  Future<void> stop() async {
    stops++;
  }

  @override
  Future<void> dispose() async {
    disposals++;
  }
}

Future<void> _open(
  WidgetTester tester,
  _CameraPlatform platform,
  DemoTrip trip,
) async {
  final previous = MobileScannerPlatform.instance;
  MobileScannerPlatform.instance = platform;
  tester.view.physicalSize = const Size(412, 915);
  tester.view.devicePixelRatio = 1;
  addTearDown(() async {
    await tester.pumpWidget(const SizedBox());
    await tester.pumpAndSettle();
    MobileScannerPlatform.instance = previous;
    await platform.captures.close();
    tester.view.resetPhysicalSize();
    tester.view.resetDevicePixelRatio();
  });
  await tester.pumpWidget(
    MaterialApp(
      theme: employeeTheme(Brightness.light),
      home: ScannerScreen(trip: trip),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    await (FontLoader(
      'Inter',
    )..addFont(rootBundle.load('assets/fonts/Inter.ttf'))).load();
  });
  testWidgets(
    'Retry disposes a failed camera session before opening a live preview',
    (tester) async {
      final platform = _CameraPlatform(
        firstError: const MobileScannerException(
          errorCode: MobileScannerErrorCode.genericError,
          errorDetails: MobileScannerErrorDetails(
            message: 'NotReadableError: Could not start video source',
          ),
        ),
      );
      await _open(tester, platform, createDemoTrips().first);
      expect(find.text('Webcam đang bận hoặc bị chặn'), findsOneWidget);
      expect(find.byKey(const ValueKey('camera-live-preview')), findsNothing);
      await tester.tap(find.text('Thử mở camera'));
      await tester.pumpAndSettle();
      expect(platform.disposals, 1);
      expect(platform.options.length, 2);
      expect(find.byKey(const ValueKey('camera-live-preview')), findsOneWidget);
      expect(find.text('Webcam đang bận hoặc bị chặn'), findsNothing);
      if (kIsWeb &&
          defaultTargetPlatform != TargetPlatform.android &&
          defaultTargetPlatform != TargetPlatform.iOS) {
        expect(platform.options.first.cameraDirection, CameraFacing.front);
        expect(platform.options.first.cameraResolution, const Size(1280, 720));
      }
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'Changing camera after failure rebuilds the preview with the other facing',
    (tester) async {
      final platform = _CameraPlatform(
        firstError: const MobileScannerException(
          errorCode: MobileScannerErrorCode.unsupported,
          errorDetails: MobileScannerErrorDetails(
            message: 'NotFoundError: Requested device not found',
          ),
        ),
      );
      await _open(tester, platform, createDemoTrips().first);
      expect(find.text('Không tìm thấy webcam'), findsOneWidget);
      await tester.tap(find.text('Đổi camera'));
      await tester.pumpAndSettle();
      expect(
        platform.options.last.cameraDirection,
        isNot(platform.options.first.cameraDirection),
      );
      expect(find.byKey(const ValueKey('camera-live-preview')), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('Permission error is distinguished from webcam busy errors', (
    tester,
  ) async {
    final platform = _CameraPlatform(
      firstError: const MobileScannerException(
        errorCode: MobileScannerErrorCode.permissionDenied,
      ),
    );
    await _open(tester, platform, createDemoTrips().first);
    expect(find.text('Chưa được cấp quyền camera'), findsOneWidget);
    expect(find.text('Webcam đang bận hoặc bị chặn'), findsNothing);
    expect(find.text('Thử mở camera'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'Live scanner QR capture releases the camera and opens the boarding result',
    (tester) async {
      final platform = _CameraPlatform();
      final trip = createDemoTrips().first;
      await _open(tester, platform, trip);
      expect(find.byKey(const ValueKey('camera-live-preview')), findsOneWidget);
      platform.captures.add(
        BarcodeCapture(barcodes: [Barcode(rawValue: 'VX102001')]),
      );
      await tester.pumpAndSettle();
      expect(trip.boardedCount, 1);
      expect(platform.stops, 1);
      expect(platform.disposals, 1);
      expect(find.byType(BoardingSuccessScreen), findsOneWidget);
      expect(find.byKey(const ValueKey('camera-live-preview')), findsNothing);
      expect(tester.takeException(), isNull);
    },
  );
}
