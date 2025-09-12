import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'link_sdk_method_channel.dart';
import 'link_file.dart';
import 'link_menu.dart';
import 'link_software_version.dart';
import 'link_space.dart';
import 'link_result.dart';
import 'link_stream_url.dart';

typedef LinkConnectionStateListener = void Function(int state);
typedef LinkNotifyListener = void Function(int code, String? data);
typedef LinkProgressListener = void Function(double dlTotal, double dlNow, double ulTotal, double ulNow);

abstract class LinkSdkPlatform extends PlatformInterface {
  LinkSdkPlatform() : super(token: _token);

  static final Object _token = Object();

  static LinkSdkPlatform _instance = MethodChannelLinkSdk();

  static LinkSdkPlatform get instance => _instance;

  static set instance(LinkSdkPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  set onConnectionStateChanged(LinkConnectionStateListener? listener) => {};
  set onNotify(LinkNotifyListener? listener) => {};
  set onProgress(LinkProgressListener? listener) => {};

  Future<void> init() async {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<bool?> configNetChannel() async {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<bool?> clearNetChannelConfig() async {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<LinkResult<void>?> connect() async {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<void> heartbeatOn() async {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<void> setHeartbeatInterval(int second) async {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<void> heartbeatOff() async {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<LinkResult<List<LinkStreamUrl>>?> getStreamUrl() async {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<LinkResult<int>?> isPhotoModeSupported() async {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<LinkResult<int>?> shouldShowRTMapTracks() async {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<LinkResult<int>?> getWorkMode() async {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<LinkResult<int>?> setWorkMode(int workMode) async {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<LinkResult<int>?> getVideoRecState() async {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<LinkResult<int>?> setVideoRecState(int flag) async {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<LinkResult<int>?> getVideoRecTime() async {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<LinkResult<int>?> takePhoto() async {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<LinkResult<int>?> snapshot() async {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<LinkResult<List<LinkMenu>>?> getMenu(bool clearCache) async {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<LinkResult<String>?> getMenuState(int cmd) async {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<LinkResult<int>?> setMenuState(int cmd, String option) async {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<LinkResult<int>?> setMenuMultipleState(int cmd, List<String> options) async {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<LinkResult<int>?> isMultipleStorageSupported() async {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<LinkResult<int>?> isStorageSelectSupported() async {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<LinkResult<int>?> storageSelect(int type) async {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<LinkResult<List<int>>?> getFileDir() async {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<LinkResult<List<LinkFile>>?> getFileList(int type, int from, int count) async {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<LinkResult<int>?> deleteFile(String fileExtra) async {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<LinkResult<int>?> getFileCopyState() async {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<LinkResult<int>?> copyFile(String fileExtra) async {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<LinkResult<int>?> getFileCopyProgress() async {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<LinkResult<int>?> stopFileCopy() async {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<LinkResult<int>?> getExternalStorageState() async {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<LinkResult<int>?> shouldShowExternalStorageSpace() async {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<LinkResult<LinkSpace>?> getStorageSpace(int type) async {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<LinkResult<int>?> isInternalStorageFormatSupported() async {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<LinkResult<int>?> storageFormat(int type) async {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<LinkResult<int>?> isFileGPSInfoSupported() async {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<LinkResult<String>?> getFileGPSInfo(String fileExtra) async {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<LinkResult<int>?> timeSync() async {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<LinkResult<String>?> getWiFiSSID() async {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<LinkResult<String>?> getWiFiSSIDFromDevice() async {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<LinkResult<int>?> setWiFiSSID(String ssid) async {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<LinkResult<String>?> getWiFiPassword() async {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<LinkResult<int>?> setWiFiPassword(String pwd) async {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<LinkResult<int>?> systemReset() async {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<LinkResult<String>?> systemVersion(int type) async {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<LinkResult<int>?> getBatteryState() async {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<LinkResult<int>?> setPIRInterval(int interval) async {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<LinkResult<int>?> setPIRMonitoringPeriodTime(int index, String begin, String end) async {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<LinkResult<int>?> getOTASupportState() async {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<LinkResult<LinkSoftwareVersion>?> getSoftwareVersion(int type) async {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<LinkResult<int>?> sendUpgradeFile(int type, int filePath) async {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<LinkResult<int>?> softwareUpdate(int type, int filePath) async {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<LinkResult<int>?> recLock() async {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<LinkResult<int>?> changeFileLockState(String fileExtra) async {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<LinkResult<int>?> getCameraState(int index) async {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<LinkResult<String>?> getChipId() async {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<LinkResult<int>?> getConnectionType() async {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<LinkResult<int>?> getConnectionState() async {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<LinkResult<bool>?> checkCapability(int type) async {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<LinkResult<int>?> getRemainingRecTime() async {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<LinkResult<int>?> getRemainingPhotoNumber() async {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<void> disconnect() async {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<String?> sdkVersion() async {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
