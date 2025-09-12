import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:link_sdk/link_sdk_method_channel.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  MethodChannelLinkSdk platform = MethodChannelLinkSdk();
  const MethodChannel channel = MethodChannel('mobile.open.sdk/linksdk');

  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
      channel,
      (MethodCall methodCall) async {
        if (methodCall.method == 'sdkVersion') {
          return 'LinkSDK Version Mock';
        } else {
          throw UnimplementedError();
        }
      },
    );
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(channel, null);
  });

  test('sdkVersion', () async {
    expect(await platform.sdkVersion(), 'LinkSDK Version Mock');
  });
}
