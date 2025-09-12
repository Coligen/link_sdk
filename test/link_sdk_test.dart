import 'package:flutter_test/flutter_test.dart';
import 'package:link_sdk/link_file.dart';
import 'package:link_sdk/link_menu.dart';
import 'package:link_sdk/link_result.dart';
import 'package:link_sdk/link_sdk.dart';
import 'package:link_sdk/link_sdk_platform_interface.dart';
import 'package:link_sdk/link_sdk_method_channel.dart';
import 'package:link_sdk/link_software_version.dart';
import 'package:link_sdk/link_space.dart';
import 'package:link_sdk/link_stream_url.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockLinkSdkPlatform
    with MockPlatformInterfaceMixin
    implements LinkSdkPlatform {
  @override
  Future<LinkResult<int>?> changeFileLockState(String fileExtra) {
    // TODO: implement changeFileLockState
    throw UnimplementedError();
  }

  @override
  Future<LinkResult<bool>?> checkCapability(int type) {
    // TODO: implement checkCapability
    throw UnimplementedError();
  }

  @override
  Future<bool?> clearNetChannelConfig() {
    // TODO: implement clearNetChannelConfig
    throw UnimplementedError();
  }

  @override
  Future<bool?> configNetChannel() {
    // TODO: implement configNetChannel
    throw UnimplementedError();
  }

  @override
  Future<LinkResult<void>?> connect() {
    // TODO: implement connect
    throw UnimplementedError();
  }

  @override
  Future<LinkResult<int>?> copyFile(String fileExtra) {
    // TODO: implement copyFile
    throw UnimplementedError();
  }

  @override
  Future<LinkResult<int>?> deleteFile(String fileExtra) {
    // TODO: implement deleteFile
    throw UnimplementedError();
  }

  @override
  Future<void> disconnect() {
    // TODO: implement disconnect
    throw UnimplementedError();
  }

  @override
  Future<LinkResult<int>?> getBatteryState() {
    // TODO: implement getBatteryState
    throw UnimplementedError();
  }

  @override
  Future<LinkResult<int>?> getCameraState(int index) {
    // TODO: implement getCameraState
    throw UnimplementedError();
  }

  @override
  Future<LinkResult<String>?> getChipId() {
    // TODO: implement getChipId
    throw UnimplementedError();
  }

  @override
  Future<LinkResult<int>?> getConnectionState() {
    // TODO: implement getConnectionState
    throw UnimplementedError();
  }

  @override
  Future<LinkResult<int>?> getConnectionType() {
    // TODO: implement getConnectionType
    throw UnimplementedError();
  }

  @override
  Future<LinkResult<int>?> getExternalStorageState() {
    // TODO: implement getExternalStorageState
    throw UnimplementedError();
  }

  @override
  Future<LinkResult<int>?> getFileCopyProgress() {
    // TODO: implement getFileCopyProgress
    throw UnimplementedError();
  }

  @override
  Future<LinkResult<int>?> getFileCopyState() {
    // TODO: implement getFileCopyState
    throw UnimplementedError();
  }

  @override
  Future<LinkResult<List<String>>?> getFileDir() {
    // TODO: implement getFileDir
    throw UnimplementedError();
  }

  @override
  Future<LinkResult<String>?> getFileGPSInfo(String fileExtra) {
    // TODO: implement getFileGPSInfo
    throw UnimplementedError();
  }

  @override
  Future<LinkResult<List<LinkFile>>?> getFileList(int type, int from, int count) {
    // TODO: implement getFileList
    throw UnimplementedError();
  }

  @override
  Future<LinkResult<List<LinkMenu>>?> getMenu(bool clearCache) {
    // TODO: implement getMenu
    throw UnimplementedError();
  }

  @override
  Future<LinkResult<String>?> getMenuState(int cmd) {
    // TODO: implement getMenuState
    throw UnimplementedError();
  }

  @override
  Future<LinkResult<int>?> getOTASupportState() {
    // TODO: implement getOTASupportState
    throw UnimplementedError();
  }

  @override
  Future<LinkResult<int>?> getRemainingPhotoNumber() {
    // TODO: implement getRemainingPhotoNumber
    throw UnimplementedError();
  }

  @override
  Future<LinkResult<int>?> getRemainingRecTime() {
    // TODO: implement getRemainingRecTime
    throw UnimplementedError();
  }

  @override
  Future<LinkResult<LinkSoftwareVersion>?> getSoftwareVersion(int type) {
    // TODO: implement getSoftwareVersion
    throw UnimplementedError();
  }

  @override
  Future<LinkResult<LinkSpace>?> getStorageSpace(int type) {
    // TODO: implement getStorageSpace
    throw UnimplementedError();
  }

  @override
  Future<LinkResult<List<LinkStreamUrl>>?> getStreamUrl() {
    // TODO: implement getStreamUrl
    throw UnimplementedError();
  }

  @override
  Future<LinkResult<int>?> getVideoRecState() {
    // TODO: implement getVideoRecState
    throw UnimplementedError();
  }

  @override
  Future<LinkResult<int>?> getVideoRecTime() {
    // TODO: implement getVideoRecTime
    throw UnimplementedError();
  }

  @override
  Future<LinkResult<String>?> getWiFiPassword() {
    // TODO: implement getWiFiPassword
    throw UnimplementedError();
  }

  @override
  Future<LinkResult<String>?> getWiFiSSID() {
    // TODO: implement getWiFiSSID
    throw UnimplementedError();
  }

  @override
  Future<LinkResult<String>?> getWiFiSSIDFromDevice() {
    // TODO: implement getWiFiSSIDFromDevice
    throw UnimplementedError();
  }

  @override
  Future<LinkResult<int>?> getWorkMode() {
    // TODO: implement getWorkMode
    throw UnimplementedError();
  }

  @override
  Future<void> heartbeatOff() {
    // TODO: implement heartbeatOff
    throw UnimplementedError();
  }

  @override
  Future<void> heartbeatOn() {
    // TODO: implement heartbeatOn
    throw UnimplementedError();
  }

  @override
  Future<void> init() {
    // TODO: implement init
    throw UnimplementedError();
  }

  @override
  Future<LinkResult<int>?> isFileGPSInfoSupported() {
    // TODO: implement isFileGPSInfoSupported
    throw UnimplementedError();
  }

  @override
  Future<LinkResult<int>?> isInternalStorageFormatSupported() {
    // TODO: implement isInternalStorageFormatSupported
    throw UnimplementedError();
  }

  @override
  Future<LinkResult<int>?> isMultipleStorageSupported() {
    // TODO: implement isMultipleStorageSupported
    throw UnimplementedError();
  }

  @override
  Future<LinkResult<int>?> isPhotoModeSupported() {
    // TODO: implement isPhotoModeSupported
    throw UnimplementedError();
  }

  @override
  Future<LinkResult<int>?> isStorageSelectSupported() {
    // TODO: implement isStorageSelectSupported
    throw UnimplementedError();
  }

  @override
  set onConnectionStateChanged(LinkConnectionStateListener listener) {
    // TODO: implement onConnectionStateChanged
  }

  @override
  set onNotify(LinkNotifyListener listener) {
    // TODO: implement onNotify
  }

  @override
  Future<LinkResult<int>?> recLock() {
    // TODO: implement recLock
    throw UnimplementedError();
  }

  @override
  Future<String> sdkVersion() {
    return Future.value('LinkSDK Version Mock');
  }

  @override
  Future<LinkResult<int>?> sendUpgradeFile(int type, int filePath) {
    // TODO: implement sendUpgradeFile
    throw UnimplementedError();
  }

  @override
  Future<void> setHeartbeatInterval(int second) {
    // TODO: implement setHeartbeatInterval
    throw UnimplementedError();
  }

  @override
  Future<LinkResult<int>?> setMenuMultipleState(int cmd, List<String> options) {
    // TODO: implement setMenuMultipleState
    throw UnimplementedError();
  }

  @override
  Future<LinkResult<int>?> setMenuState(int cmd, String option) {
    // TODO: implement setMenuState
    throw UnimplementedError();
  }

  @override
  Future<LinkResult<int>?> setPIRInterval(int interval) {
    // TODO: implement setPIRInterval
    throw UnimplementedError();
  }

  @override
  Future<LinkResult<int>?> setPIRMonitoringPeriodTime(int index, String begin, String end) {
    // TODO: implement setPIRMonitoringPeriodTime
    throw UnimplementedError();
  }

  @override
  Future<LinkResult<int>?> setVideoRecState(int flag) {
    // TODO: implement setVideoRecState
    throw UnimplementedError();
  }

  @override
  Future<LinkResult<int>?> setWiFiPassword(String pwd) {
    // TODO: implement setWiFiPassword
    throw UnimplementedError();
  }

  @override
  Future<LinkResult<int>?> setWiFiSSID(String ssid) {
    // TODO: implement setWiFiSSID
    throw UnimplementedError();
  }

  @override
  Future<LinkResult<int>?> setWorkMode(int workMode) {
    // TODO: implement setWorkMode
    throw UnimplementedError();
  }

  @override
  Future<LinkResult<int>?> shouldShowExternalStorageSpace() {
    // TODO: implement shouldShowExternalStorageSpace
    throw UnimplementedError();
  }

  @override
  Future<LinkResult<int>?> shouldShowRTMapTracks() {
    // TODO: implement shouldShowRTMapTracks
    throw UnimplementedError();
  }

  @override
  Future<LinkResult<int>?> snapshot() {
    // TODO: implement snapshot
    throw UnimplementedError();
  }

  @override
  Future<LinkResult<int>?> softwareUpdate(int type, int filePath) {
    // TODO: implement softwareUpdate
    throw UnimplementedError();
  }

  @override
  Future<LinkResult<int>?> stopFileCopy() {
    // TODO: implement stopFileCopy
    throw UnimplementedError();
  }

  @override
  Future<LinkResult<int>?> storageFormat(int type) {
    // TODO: implement storageFormat
    throw UnimplementedError();
  }

  @override
  Future<LinkResult<int>?> storageSelect(int type) {
    // TODO: implement storageSelect
    throw UnimplementedError();
  }

  @override
  Future<LinkResult<int>?> systemReset() {
    // TODO: implement systemReset
    throw UnimplementedError();
  }

  @override
  Future<LinkResult<String>?> systemVersion(int type) {
    // TODO: implement systemVersion
    throw UnimplementedError();
  }

  @override
  Future<LinkResult<int>?> takePhoto() {
    // TODO: implement takePhoto
    throw UnimplementedError();
  }

  @override
  Future<LinkResult<int>?> timeSync() {
    // TODO: implement timeSync
    throw UnimplementedError();
  }
    
}

void main() {
  final LinkSdkPlatform initialPlatform = LinkSdkPlatform.instance;

  test('$MethodChannelLinkSdk is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelLinkSdk>());
  });

  test('sdkVersion', () async {
    MockLinkSdkPlatform fakePlatform = MockLinkSdkPlatform();
    LinkSdkPlatform.instance = fakePlatform;

    expect(await LinkSdk.sdkVersion(), 'LinkSDK Version Mock');
  });
}
