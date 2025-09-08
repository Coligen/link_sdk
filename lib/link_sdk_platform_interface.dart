import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'link_sdk_method_channel.dart';

abstract class LinkSdkPlatform extends PlatformInterface {
  /// Constructs a LinkSdkPlatform.
  LinkSdkPlatform() : super(token: _token);

  static final Object _token = Object();

  static LinkSdkPlatform _instance = MethodChannelLinkSdk();

  /// The default instance of [LinkSdkPlatform] to use.
  ///
  /// Defaults to [MethodChannelLinkSdk].
  static LinkSdkPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [LinkSdkPlatform] when
  /// they register themselves.
  static set instance(LinkSdkPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
