import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'multi_imei_method_channel.dart';

abstract class MultiImeiPlatform extends PlatformInterface {
  /// Constructs a MultiImeiPlatform.
  MultiImeiPlatform() : super(token: _token);

  static final Object _token = Object();

  static MultiImeiPlatform _instance = MethodChannelMultiImei();

  /// The default instance of [MultiImeiPlatform] to use.
  ///
  /// Defaults to [MethodChannelMultiImei].
  static MultiImeiPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [MultiImeiPlatform] when
  /// they register themselves.
  static set instance(MultiImeiPlatform instance) {
    print('instance---------------$instance');
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<List<String>?> getImeiList();
}
