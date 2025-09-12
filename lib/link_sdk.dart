import 'link_sdk_platform_interface.dart';
import 'link_file.dart';
import 'link_menu.dart';
import 'link_software_version.dart';
import 'link_space.dart';
import 'link_result.dart';
import 'link_stream_url.dart';

class LinkSdk {
  static set onConnectionStateChanged(LinkConnectionStateListener? listener) => {
    LinkSdkPlatform.instance.onConnectionStateChanged = listener
  };
  static set onNotify(LinkNotifyListener? listener) => {
    LinkSdkPlatform.instance.onNotify = listener
  };
  static set onProgress(LinkProgressListener? listener) => {
    LinkSdkPlatform.instance.onProgress = listener
  };

  static Future<void> init() async {
    return LinkSdkPlatform.instance.init();
  }

  static Future<bool?> configNetChannel() async {
    return LinkSdkPlatform.instance.configNetChannel();
  }

  static Future<bool?> clearNetChannelConfig() async {
    return LinkSdkPlatform.instance.clearNetChannelConfig();
  }

  static Future<LinkResult<void>?> connect() async {
    return LinkSdkPlatform.instance.connect();
  }

  static Future<void> heartbeatOn() async {
    return LinkSdkPlatform.instance.heartbeatOn();
  }

  static Future<void> setHeartbeatInterval(int second) async {
    return LinkSdkPlatform.instance.setHeartbeatInterval(second);
  }

  static Future<void> heartbeatOff() async {
    return LinkSdkPlatform.instance.heartbeatOff();
  }

  static Future<LinkResult<List<LinkStreamUrl>>?> getStreamUrl() async {
    return LinkSdkPlatform.instance.getStreamUrl();
  }

  static Future<LinkResult<int>?> isPhotoModeSupported() async {
    return LinkSdkPlatform.instance.isPhotoModeSupported();
  }

  static Future<LinkResult<int>?> shouldShowRTMapTracks() async {
    return LinkSdkPlatform.instance.shouldShowRTMapTracks();
  }

  static Future<LinkResult<int>?> getWorkMode() async {
    return LinkSdkPlatform.instance.getWorkMode();
  }

  static Future<LinkResult<int>?> setWorkMode(int workMode) async {
    return LinkSdkPlatform.instance.setWorkMode(workMode);
  }

  static Future<LinkResult<int>?> getVideoRecState() async {
    return LinkSdkPlatform.instance.getVideoRecState();
  }

  static Future<LinkResult<int>?> setVideoRecState(int flag) async {
    return LinkSdkPlatform.instance.setVideoRecState(flag);
  }

  static Future<LinkResult<int>?> getVideoRecTime() async {
    return LinkSdkPlatform.instance.getVideoRecTime();
  }

  static Future<LinkResult<int>?> takePhoto() async {
    return LinkSdkPlatform.instance.takePhoto();
  }

  static Future<LinkResult<int>?> snapshot() async {
    return LinkSdkPlatform.instance.snapshot();
  }

  static Future<LinkResult<List<LinkMenu>>?> getMenu(bool clearCache) async {
    return LinkSdkPlatform.instance.getMenu(clearCache);
  }

  static Future<LinkResult<String>?> getMenuState(int cmd) async {
    return LinkSdkPlatform.instance.getMenuState(cmd);
  }

  static Future<LinkResult<int>?> setMenuState(int cmd, String option) async {
    return LinkSdkPlatform.instance.setMenuState(cmd, option);
  }

  static Future<LinkResult<int>?> setMenuMultipleState(int cmd, List<String> options) async {
    return LinkSdkPlatform.instance.setMenuMultipleState(cmd, options);
  }

  static Future<LinkResult<int>?> isMultipleStorageSupported() async {
    return LinkSdkPlatform.instance.isMultipleStorageSupported();
  }

  static Future<LinkResult<int>?> isStorageSelectSupported() async {
    return LinkSdkPlatform.instance.isStorageSelectSupported();
  }

  static Future<LinkResult<int>?> storageSelect(int type) async {
    return LinkSdkPlatform.instance.storageSelect(type);
  }

  static Future<LinkResult<List<int>>?> getFileDir() async {
    return LinkSdkPlatform.instance.getFileDir();
  }

  static Future<LinkResult<List<LinkFile>>?> getFileList(int type, int from, int count) async {
    return LinkSdkPlatform.instance.getFileList(type, from, count);
  }

  static Future<LinkResult<int>?> deleteFile(String fileExtra) async {
    return LinkSdkPlatform.instance.deleteFile(fileExtra);
  }

  static Future<LinkResult<int>?> getFileCopyState() async {
    return LinkSdkPlatform.instance.getFileCopyState();
  }

  static Future<LinkResult<int>?> copyFile(String fileExtra) async {
    return LinkSdkPlatform.instance.copyFile(fileExtra);
  }

  static Future<LinkResult<int>?> getFileCopyProgress() async {
    return LinkSdkPlatform.instance.getFileCopyProgress();
  }

  static Future<LinkResult<int>?> stopFileCopy() async {
    return LinkSdkPlatform.instance.stopFileCopy();
  }

  static Future<LinkResult<int>?> getExternalStorageState() async {
    return LinkSdkPlatform.instance.getExternalStorageState();
  }

  static Future<LinkResult<int>?> shouldShowExternalStorageSpace() async {
    return LinkSdkPlatform.instance.shouldShowExternalStorageSpace();
  }

  static Future<LinkResult<LinkSpace>?> getStorageSpace(int type) async {
    return LinkSdkPlatform.instance.getStorageSpace(type);
  }

  static Future<LinkResult<int>?> isInternalStorageFormatSupported() async {
    return LinkSdkPlatform.instance.isInternalStorageFormatSupported();
  }

  static Future<LinkResult<int>?> storageFormat(int type) async {
    return LinkSdkPlatform.instance.storageFormat(type);
  }

  static Future<LinkResult<int>?> isFileGPSInfoSupported() async {
    return LinkSdkPlatform.instance.isFileGPSInfoSupported();
  }

  static Future<LinkResult<String>?> getFileGPSInfo(String fileExtra) async {
    return LinkSdkPlatform.instance.getFileGPSInfo(fileExtra);
  }

  static Future<LinkResult<int>?> timeSync() async {
    return LinkSdkPlatform.instance.timeSync();
  }

  static Future<LinkResult<String>?> getWiFiSSID() async {
    return LinkSdkPlatform.instance.getWiFiSSID();
  }

  static Future<LinkResult<String>?> getWiFiSSIDFromDevice() async {
    return LinkSdkPlatform.instance.getWiFiSSIDFromDevice();
  }

  static Future<LinkResult<int>?> setWiFiSSID(String ssid) async {
    return LinkSdkPlatform.instance.setWiFiSSID(ssid);
  }

  static Future<LinkResult<String>?> getWiFiPassword() async {
    return LinkSdkPlatform.instance.getWiFiPassword();
  }

  static Future<LinkResult<int>?> setWiFiPassword(String pwd) async {
    return LinkSdkPlatform.instance.setWiFiPassword(pwd);
  }

  static Future<LinkResult<int>?> systemReset() async {
    return LinkSdkPlatform.instance.systemReset();
  }

  static Future<LinkResult<String>?> systemVersion(int type) async {
    return LinkSdkPlatform.instance.systemVersion(type);
  }

  static Future<LinkResult<int>?> getBatteryState() async {
    return LinkSdkPlatform.instance.getBatteryState();
  }

  static Future<LinkResult<int>?> setPIRInterval(int interval) async {
    return LinkSdkPlatform.instance.setPIRInterval(interval);
  }

  static Future<LinkResult<int>?> setPIRMonitoringPeriodTime(int index, String begin, String end) async {
    return LinkSdkPlatform.instance.setPIRMonitoringPeriodTime(index, begin, end);
  }

  static Future<LinkResult<int>?> getOTASupportState() async {
    return LinkSdkPlatform.instance.getOTASupportState();
  }

  static Future<LinkResult<LinkSoftwareVersion>?> getSoftwareVersion(int type) async {
    return LinkSdkPlatform.instance.getSoftwareVersion(type);
  }

  static Future<LinkResult<int>?> sendUpgradeFile(int type, int filePath) async {
    return LinkSdkPlatform.instance.sendUpgradeFile(type, filePath);
  }

  static Future<LinkResult<int>?> softwareUpdate(int type, int filePath) async {
    return LinkSdkPlatform.instance.softwareUpdate(type, filePath);
  }

  static Future<LinkResult<int>?> recLock() async {
    return LinkSdkPlatform.instance.recLock();
  }

  static Future<LinkResult<int>?> changeFileLockState(String fileExtra) async {
    return LinkSdkPlatform.instance.changeFileLockState(fileExtra);
  }

  static Future<LinkResult<int>?> getCameraState(int index) async {
    return LinkSdkPlatform.instance.getCameraState(index);
  }

  static Future<LinkResult<String>?> getChipId() async {
    return LinkSdkPlatform.instance.getChipId();
  }

  static Future<LinkResult<int>?> getConnectionType() async {
    return LinkSdkPlatform.instance.getConnectionType();
  }

  static Future<LinkResult<int>?> getConnectionState() async {
    return LinkSdkPlatform.instance.getConnectionState();
  }

  static Future<LinkResult<bool>?> checkCapability(int type) async {
    return LinkSdkPlatform.instance.checkCapability(type);
  }

  static Future<LinkResult<int>?> getRemainingRecTime() async {
    return LinkSdkPlatform.instance.getRemainingRecTime();
  }

  static Future<LinkResult<int>?> getRemainingPhotoNumber() async {
    return LinkSdkPlatform.instance.getRemainingPhotoNumber();
  }

  static Future<void> disconnect() async {
    return LinkSdkPlatform.instance.disconnect();
  }

  static Future<String?> sdkVersion() async {
    return LinkSdkPlatform.instance.sdkVersion();
  }
}
