import 'multi_imei_platform_interface.dart';

class MultiImei {
  Future<List<String>?> getImeiList() {
    return MultiImeiPlatform.instance.getImeiList();
  }
}
