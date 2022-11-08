import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:multi_imei/multi_imei_method_channel.dart';

void main() {
  MethodChannelMultiImei platform = MethodChannelMultiImei();
  const MethodChannel channel = MethodChannel('multi_imei');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return ['23424242424', '4242424242424'];
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getImeiList', () async {
    expect(await platform.getImeiList(), ['23424242424', '4242424242424']);
  });
}
