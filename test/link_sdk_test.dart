import 'package:flutter_test/flutter_test.dart';
import 'package:link_sdk/link_sdk.dart';
import 'package:link_sdk/link_sdk_platform_interface.dart';
import 'package:link_sdk/link_sdk_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockLinkSdkPlatform
    with MockPlatformInterfaceMixin
    implements LinkSdkPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final LinkSdkPlatform initialPlatform = LinkSdkPlatform.instance;

  test('$MethodChannelLinkSdk is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelLinkSdk>());
  });

  test('getPlatformVersion', () async {
    LinkSdk linkSdkPlugin = LinkSdk();
    MockLinkSdkPlatform fakePlatform = MockLinkSdkPlatform();
    LinkSdkPlatform.instance = fakePlatform;

    expect(await linkSdkPlugin.getPlatformVersion(), '42');
  });
}
