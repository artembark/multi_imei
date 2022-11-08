import 'package:flutter_test/flutter_test.dart';
import 'package:multi_imei/multi_imei.dart';
import 'package:multi_imei/multi_imei_method_channel.dart';
import 'package:multi_imei/multi_imei_platform_interface.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockMultiImeiPlatform
    with MockPlatformInterfaceMixin
    implements MultiImeiPlatform {
  @override
  Future<List<String>?> getImeiList() =>
      Future.value(['23424242424', '4242424242424']);
}

void main() {
  final MultiImeiPlatform initialPlatform = MultiImeiPlatform.instance;

  test('$MethodChannelMultiImei is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelMultiImei>());
  });

  test('getImeiList', () async {
    MultiImei multiImeiPlugin = MultiImei();
    MockMultiImeiPlatform fakePlatform = MockMultiImeiPlatform();
    MultiImeiPlatform.instance = fakePlatform;

    expect(
        await multiImeiPlugin.getImeiList(), ['23424242424', '4242424242424']);
  });
}
