import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'multi_imei_platform_interface.dart';

/// An implementation of [MultiImeiPlatform] that uses method channels.
class MethodChannelMultiImei extends MultiImeiPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('multi_imei');

  @override
  Future<List<String>?> getImeiList() async {
    final version = await methodChannel.invokeListMethod<String>('getImeiList');
    return version;
  }
}
