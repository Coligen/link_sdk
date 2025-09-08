
import 'link_sdk_platform_interface.dart';

class LinkSdk {
  Future<String?> getPlatformVersion() {
    return LinkSdkPlatform.instance.getPlatformVersion();
  }
}
