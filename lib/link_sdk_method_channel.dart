// ignore_for_file: constant_identifier_names

import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/services.dart';

import 'link_sdk_platform_interface.dart';
import 'link_file.dart';
import 'link_menu.dart';
import 'link_software_version.dart';
import 'link_space.dart';
import 'link_result.dart';
import 'link_stream_url.dart';

class MethodChannelLinkSdk extends LinkSdkPlatform {
  /// LinkSDK事件类型: 协议层连接状态变化
  static const int _EVENT_TYPE_CONNECTION_STATE = 0;
  /// LinkSDK事件类型: 设备通知
  static const int _EVENT_TYPE_NOTIFY = 1;
  /// LinkSDK事件类型: 上传/下载进度变化
  static const int _EVENT_TYPE_PROGRESS = 2;

  final MethodChannel _methodchannel = const MethodChannel('mobile.open.sdk/linksdk');
  final EventChannel _eventChannel = const EventChannel('mobile.open.sdk/linksdk/event');

  LinkConnectionStateListener? _connectionStateListener;
  LinkNotifyListener? _notifyListener;
  LinkProgressListener? _progressListener;

  @override
  set onConnectionStateChanged(LinkConnectionStateListener? listener) => _connectionStateListener = listener;
  @override
  set onNotify(LinkNotifyListener? listener) => _notifyListener = listener;
  @override
  set onProgress(LinkProgressListener? listener) => _progressListener = listener;

  Future<T?> _invokeMethod<T>(String method, [dynamic arguments]) async {
    try {
      final ret = await _methodchannel.invokeMethod(method, arguments);
      log('invoke method: $method returned with: $ret');
      return ret;
    } on MissingPluginException {
      log('invoke method: $method error, not implemented on target platform');
      return null;
    } on PlatformException catch (e) {
      log('invoke method: $method error of platform: $e');
      return null;
    } catch (e) {
      log('invoke method: $method error other: $e');
      return null;
    }
  }

  @override
  Future<void> init() async {
    _eventChannel.receiveBroadcastStream().listen((event) {
      var param = json.decode(event);
      var type = (param['type'] as num).toInt();
      var payload = param['payload'];

      log('receive event with type: $type, payload: $payload');

      if (type == _EVENT_TYPE_NOTIFY) {
        int code = (payload['code'] as num).toInt();
        String? data = payload['data'] as String?;

        //log('receive device notification code: $code, data: $data');
        _notifyListener?.call(code, data);
      } else if (type == _EVENT_TYPE_CONNECTION_STATE) {
        int state = (payload['state'] as num).toInt();

        //log('receive new connection state: $state');
        _connectionStateListener?.call(state);
      } else if (type == _EVENT_TYPE_PROGRESS) {
        double dlTotal = (payload['dlTotal'] as num).toDouble();
        double dlNow = (payload['dlNow'] as num).toDouble();
        double ulTotal = (payload['ulTotal'] as num).toDouble();
        double ulNow = (payload['ulNow'] as num).toDouble();

        //log('receive progress change: $dlTotal $dlNow $ulTotal $ulNow');
        _progressListener?.call(dlTotal, dlNow, ulTotal, ulNow);
      } else {
        
      }
    });

    await _invokeMethod('init');
  }

  @override
  Future<bool?> configNetChannel() async {
    return await _invokeMethod('configNetChannel');
  }

  @override
  Future<bool?> clearNetChannelConfig() async {
    return await _invokeMethod('clearNetChannelConfig');
  }

  @override
  Future<LinkResult<void>?> connect() async {
    final result = await _invokeMethod('connect');
    if (result == null) {
      return null;
    }

    final kvMap = json.decode(result);
    return LinkResult(code: kvMap['code'], data: null);
  }

  @override
  Future<void> heartbeatOn() async {
    await _invokeMethod('heartbeatOn');
  }

  @override
  Future<void> setHeartbeatInterval(int second) async {
    await _invokeMethod('setHeartbeatInterval', {'second': second});
  }

  @override
  Future<void> heartbeatOff() async {
    await _invokeMethod('heartbeatOff');
  }

  @override
  Future<LinkResult<List<LinkStreamUrl>>?> getStreamUrl() async {
    final result = await _invokeMethod('getStreamUrl');
    if (result == null) {
      return null;
    }

    final kvMap = json.decode(result);
    return LinkResult.fromJson(
      kvMap,
      (json) => (json as List<dynamic>).map((e) => LinkStreamUrl.fromJson(e)).toList()
    );
  }

  @override
  Future<LinkResult<int>?> isPhotoModeSupported() async {
    final result = await _invokeMethod('isPhotoModeSupported');
    if (result == null) {
      return null;
    }

    final kvMap = json.decode(result);
    return LinkResult.fromJson(
      kvMap,
      (json) => (json as num).toInt()
    );
  }

  @override
  Future<LinkResult<int>?> shouldShowRTMapTracks() async {
    final result = await _invokeMethod('shouldShowRTMapTracks');
    if (result == null) {
      return null;
    }

    final kvMap = json.decode(result);
    return LinkResult.fromJson(
      kvMap,
      (json) => (json as num).toInt()
    );
  }

  @override
  Future<LinkResult<int>?> getWorkMode() async {
    final result = await _invokeMethod('getWorkMode');
    if (result == null) {
      return null;
    }

    final kvMap = json.decode(result);
    return LinkResult.fromJson(
      kvMap,
      (json) => (json as num).toInt()
    );
  }

  @override
  Future<LinkResult<int>?> setWorkMode(int workMode) async {
    final result = await _invokeMethod('setWorkMode', {'workMode': workMode});
    if (result == null) {
      return null;
    }

    final kvMap = json.decode(result);
    return LinkResult.fromJson(
      kvMap,
      (json) => (json as num).toInt()
    );
  }

  @override
  Future<LinkResult<int>?> getVideoRecState() async {
    final result = await _invokeMethod('getVideoRecState');
    if (result == null) {
      return null;
    }

    final kvMap = json.decode(result);
    return LinkResult.fromJson(
      kvMap,
      (json) => (json as num).toInt()
    );
  }

  @override
  Future<LinkResult<int>?> setVideoRecState(int flag) async {
    final result = await _invokeMethod('setVideoRecState', {'flag': flag});
    if (result == null) {
      return null;
    }

    final kvMap = json.decode(result);
    return LinkResult.fromJson(
      kvMap,
      (json) => (json as num).toInt()
    );
  }

  @override
  Future<LinkResult<int>?> getVideoRecTime() async {
    final result = await _invokeMethod('getVideoRecTime');
    if (result == null) {
      return null;
    }

    final kvMap = json.decode(result);
    return LinkResult.fromJson(
      kvMap,
      (json) => (json as num).toInt()
    );
  }

  @override
  Future<LinkResult<int>?> takePhoto() async {
    final result = await _invokeMethod('takePhoto');
    if (result == null) {
      return null;
    }

    final kvMap = json.decode(result);
    return LinkResult.fromJson(
      kvMap,
      (json) => (json as num).toInt()
    );
  }

  @override
  Future<LinkResult<int>?> snapshot() async {
    final result = await _invokeMethod('snapshot');
    if (result == null) {
      return null;
    }

    final kvMap = json.decode(result);
    return LinkResult.fromJson(
      kvMap,
      (json) => (json as num).toInt()
    );
  }

  @override
  Future<LinkResult<List<LinkMenu>>?> getMenu(bool clearCache) async {
    final result = await _invokeMethod('getMenu', {'clearCache': clearCache});
    if (result == null) {
      return null;
    }

    final kvMap = json.decode(result);
    return LinkResult.fromJson(
      kvMap,
      (json) => (json as List<dynamic>).map((e) => LinkMenu.fromJson(e)).toList()
    );
  }

  @override
  Future<LinkResult<String>?> getMenuState(int cmd) async {
    final result = await _invokeMethod('getMenuState', {'cmd': cmd});
    if (result == null) {
      return null;
    }

    final kvMap = json.decode(result);
    return LinkResult.fromJson(
      kvMap,
      (json) => (json as String)
    );
  }

  @override
  Future<LinkResult<int>?> setMenuState(int cmd, String option) async {
    final result = await _invokeMethod('setMenuState', {'cmd': cmd, 'option': option});
    if (result == null) {
      return null;
    }

    final kvMap = json.decode(result);
    return LinkResult.fromJson(
      kvMap,
      (json) => (json as num).toInt()
    );
  }

  @override
  Future<LinkResult<int>?> setMenuMultipleState(int cmd, List<String> options) async {
    final result = await _invokeMethod('setMenuMultipleState', {'cmd': cmd, 'options': options});
    if (result == null) {
      return null;
    }

    final kvMap = json.decode(result);
    return LinkResult.fromJson(
      kvMap,
      (json) => (json as num).toInt()
    );
  }

  @override
  Future<LinkResult<int>?> isMultipleStorageSupported() async {
    final result = await _invokeMethod('isMultipleStorageSupported');
    if (result == null) {
      return null;
    }

    final kvMap = json.decode(result);
    return LinkResult.fromJson(
      kvMap,
      (json) => (json as num).toInt()
    );
  }

  @override
  Future<LinkResult<int>?> isStorageSelectSupported() async {
    final result = await _invokeMethod('isStorageSelectSupported');
    if (result == null) {
      return null;
    }

    final kvMap = json.decode(result);
    return LinkResult.fromJson(
      kvMap,
      (json) => (json as num).toInt()
    );
  }

  @override
  Future<LinkResult<int>?> storageSelect(int type) async {
    final result = await _invokeMethod('storageSelect', {'type': type});
    if (result == null) {
      return null;
    }

    final kvMap = json.decode(result);
    return LinkResult.fromJson(
      kvMap,
      (json) => (json as num).toInt()
    );
  }

  @override
  Future<LinkResult<List<int>>?> getFileDir() async {
    final result = await _invokeMethod('getFileDir');
    if (result == null) {
      return null;
    }

    final kvMap = json.decode(result);
    return LinkResult.fromJson(
      kvMap,
      (json) => (json as List<dynamic>).map((e) => (e as num).toInt()).toList()
    );
  }

  @override
  Future<LinkResult<List<LinkFile>>?> getFileList(int type, int from, int count) async {
    final result = await _invokeMethod('getFileList', {'type': type, 'from': from, 'count': count});
    if (result == null) {
      return null;
    }

    final kvMap = json.decode(result);
    return LinkResult.fromJson(
      kvMap,
      (json) => (json as List<dynamic>).map((e) => LinkFile.fromJson(e)).toList()
    );
  }

  @override
  Future<LinkResult<int>?> deleteFile(String fileExtra) async {
    final result = await _invokeMethod('deleteFile', {'extra': fileExtra});
    if (result == null) {
      return null;
    }

    final kvMap = json.decode(result);
    return LinkResult.fromJson(
      kvMap,
      (json) => (json as num).toInt()
    );
  }

  @override
  Future<LinkResult<int>?> getFileCopyState() async {
    final result = await _invokeMethod('getFileCopyState');
    if (result == null) {
      return null;
    }

    final kvMap = json.decode(result);
    return LinkResult.fromJson(
      kvMap,
      (json) => (json as num).toInt()
    );
  }

  @override
  Future<LinkResult<int>?> copyFile(String fileExtra) async {
    final result = await _invokeMethod('copyFile', {'extra': fileExtra});
    if (result == null) {
      return null;
    }

    final kvMap = json.decode(result);
    return LinkResult.fromJson(
      kvMap,
      (json) => (json as num).toInt()
    );
  }

  @override
  Future<LinkResult<int>?> getFileCopyProgress() async {
    final result = await _invokeMethod('getFileCopyProgress');
    if (result == null) {
      return null;
    }

    final kvMap = json.decode(result);
    return LinkResult.fromJson(
      kvMap,
      (json) => (json as num).toInt()
    );
  }

  @override
  Future<LinkResult<int>?> stopFileCopy() async {
    final result = await _invokeMethod('stopFileCopy');
    if (result == null) {
      return null;
    }

    final kvMap = json.decode(result);
    return LinkResult.fromJson(
      kvMap,
      (json) => (json as num).toInt()
    );
  }

  @override
  Future<LinkResult<int>?> getExternalStorageState() async {
    final result = await _invokeMethod('getExternalStorageState');
    if (result == null) {
      return null;
    }

    final kvMap = json.decode(result);
    return LinkResult.fromJson(
      kvMap,
      (json) => (json as num).toInt()
    );
  }

  @override
  Future<LinkResult<int>?> shouldShowExternalStorageSpace() async {
    final result = await _invokeMethod('shouldShowExternalStorageSpace');
    if (result == null) {
      return null;
    }

    final kvMap = json.decode(result);
    return LinkResult.fromJson(
      kvMap,
      (json) => (json as num).toInt()
    );
  }

  @override
  Future<LinkResult<LinkSpace>?> getStorageSpace(int type) async {
    final result = await _invokeMethod('getStorageSpace', {'type': type});
    if (result == null) {
      return null;
    }

    final kvMap = json.decode(result);
    return LinkResult.fromJson(
      kvMap,
      (json) => LinkSpace.fromJson(json as Map<String, dynamic>)
    );
  }

  @override
  Future<LinkResult<int>?> isInternalStorageFormatSupported() async {
    final result = await _invokeMethod('isInternalStorageFormatSupported');
    if (result == null) {
      return null;
    }

    final kvMap = json.decode(result);
    return LinkResult.fromJson(
      kvMap,
      (json) => (json as num).toInt()
    );
  }

  @override
  Future<LinkResult<int>?> storageFormat(int type) async {
    final result = await _invokeMethod('storageFormat', {'type': type});
    if (result == null) {
      return null;
    }

    final kvMap = json.decode(result);
    return LinkResult.fromJson(
      kvMap,
      (json) => (json as num).toInt()
    );
  }

  @override
  Future<LinkResult<int>?> isFileGPSInfoSupported() async {
    final result = await _invokeMethod('isFileGPSInfoSupported');
    if (result == null) {
      return null;
    }

    final kvMap = json.decode(result);
    return LinkResult.fromJson(
      kvMap,
      (json) => (json as num).toInt()
    );
  }

  @override
  Future<LinkResult<String>?> getFileGPSInfo(String fileExtra) async {
    final result = await _invokeMethod('getFileGPSInfo', {'extra': fileExtra});
    if (result == null) {
      return null;
    }

    final kvMap = json.decode(result);
    return LinkResult.fromJson(
      kvMap,
      (json) => (json as String)
    );
  }

  @override
  Future<LinkResult<int>?> timeSync() async {
    final result = await _invokeMethod('timeSync');
    if (result == null) {
      return null;
    }

    final kvMap = json.decode(result);
    return LinkResult.fromJson(
      kvMap,
      (json) => (json as num).toInt()
    );
  }

  @override
  Future<LinkResult<String>?> getWiFiSSID() async {
    final result = await _invokeMethod('getWiFiSSID');
    if (result == null) {
      return null;
    }

    final kvMap = json.decode(result);
    return LinkResult.fromJson(
      kvMap,
      (json) => (json as String)
    );
  }

  @override
  Future<LinkResult<String>?> getWiFiSSIDFromDevice() async {
    final result = await _invokeMethod('getWiFiSSIDFromDevice');
    if (result == null) {
      return null;
    }

    final kvMap = json.decode(result);
    return LinkResult.fromJson(
      kvMap,
      (json) => (json as String)
    );
  }

  @override
  Future<LinkResult<int>?> setWiFiSSID(String ssid) async {
    final result = await _invokeMethod('setWiFiSSID', {'ssid': ssid});
    if (result == null) {
      return null;
    }

    final kvMap = json.decode(result);
    return LinkResult.fromJson(
      kvMap,
      (json) => (json as num).toInt()
    );
  }

  @override
  Future<LinkResult<String>?> getWiFiPassword() async {
    final result = await _invokeMethod('getWiFiPassword');
    if (result == null) {
      return null;
    }

    final kvMap = json.decode(result);
    return LinkResult.fromJson(
      kvMap,
      (json) => (json as String)
    );
  }

  @override
  Future<LinkResult<int>?> setWiFiPassword(String pwd) async {
    final result = await _invokeMethod('setWiFiPassword', {'pwd': pwd});
    if (result == null) {
      return null;
    }

    final kvMap = json.decode(result);
    return LinkResult.fromJson(
      kvMap,
      (json) => (json as num).toInt()
    );
  }

  @override
  Future<LinkResult<int>?> systemReset() async {
    final result = await _invokeMethod('systemReset');
    if (result == null) {
      return null;
    }

    final kvMap = json.decode(result);
    return LinkResult.fromJson(
      kvMap,
      (json) => (json as num).toInt()
    );
  }

  @override
  Future<LinkResult<String>?> systemVersion(int type) async {
    final result = await _invokeMethod('systemVersion', {'type': type});
    if (result == null) {
      return null;
    }

    final kvMap = json.decode(result);
    return LinkResult.fromJson(
      kvMap,
      (json) => (json as String)
    );
  }

  @override
  Future<LinkResult<int>?> getBatteryState() async {
    final result = await _invokeMethod('getBatteryState');
    if (result == null) {
      return null;
    }

    final kvMap = json.decode(result);
    return LinkResult.fromJson(
      kvMap,
      (json) => (json as num).toInt()
    );
  }

  @override
  Future<LinkResult<int>?> setPIRInterval(int interval) async {
    final result = await _invokeMethod('setPIRInterval', {'interval': interval});
    if (result == null) {
      return null;
    }

    final kvMap = json.decode(result);
    return LinkResult.fromJson(
      kvMap,
      (json) => (json as num).toInt()
    );
  }

  @override
  Future<LinkResult<int>?> setPIRMonitoringPeriodTime(int index, String begin, String end) async {
    final result = await _invokeMethod('setPIRMonitoringPeriodTime', {'index': index, 'begin': begin, 'end': end});
    if (result == null) {
      return null;
    }

    final kvMap = json.decode(result);
    return LinkResult.fromJson(
      kvMap,
      (json) => (json as num).toInt()
    );
  }

  @override
  Future<LinkResult<int>?> getOTASupportState() async {
    final result = await _invokeMethod('getOTASupportState');
    if (result == null) {
      return null;
    }

    final kvMap = json.decode(result);
    return LinkResult.fromJson(
      kvMap,
      (json) => (json as num).toInt()
    );
  }

  @override
  Future<LinkResult<LinkSoftwareVersion>?> getSoftwareVersion(int type) async {
    final result = await _invokeMethod('getSoftwareVersion', {'type': type});
    if (result == null) {
      return null;
    }

    final kvMap = json.decode(result);
    return LinkResult.fromJson(
      kvMap,
      (json) => LinkSoftwareVersion.fromJson(json as Map<String, dynamic>)
    );
  }

  @override
  Future<LinkResult<int>?> sendUpgradeFile(int type, int filePath) async {
    final result = await _invokeMethod('sendUpgradeFile', {'type': type, 'filePath': filePath});
    if (result == null) {
      return null;
    }

    final kvMap = json.decode(result);
    return LinkResult.fromJson(
      kvMap,
      (json) => (json as num).toInt()
    );
  }

  @override
  Future<LinkResult<int>?> softwareUpdate(int type, int filePath) async {
    final result = await _invokeMethod('softwareUpdate', {'type': type, 'filePath': filePath});
    if (result == null) {
      return null;
    }

    final kvMap = json.decode(result);
    return LinkResult.fromJson(
      kvMap,
      (json) => (json as num).toInt()
    );
  }

  @override
  Future<LinkResult<int>?> recLock() async {
    final result = await _invokeMethod('recLock');
    if (result == null) {
      return null;
    }

    final kvMap = json.decode(result);
    return LinkResult.fromJson(
      kvMap,
      (json) => (json as num).toInt()
    );
  }

  @override
  Future<LinkResult<int>?> changeFileLockState(String fileExtra) async {
    final result = await _invokeMethod('changeFileLockState', {'extra': fileExtra});
    if (result == null) {
      return null;
    }

    final kvMap = json.decode(result);
    return LinkResult.fromJson(
      kvMap,
      (json) => (json as num).toInt()
    );
  }

  @override
  Future<LinkResult<int>?> getCameraState(int index) async {
    final result = await _invokeMethod('getCameraState', {'index': index});
    if (result == null) {
      return null;
    }

    final kvMap = json.decode(result);
    return LinkResult.fromJson(
      kvMap,
      (json) => (json as num).toInt()
    );
  }

  @override
  Future<LinkResult<String>?> getChipId() async {
    final result = await _invokeMethod('getChipId');
    if (result == null) {
      return null;
    }

    final kvMap = json.decode(result);
    return LinkResult.fromJson(
      kvMap,
      (json) => (json as String)
    );
  }

  @override
  Future<LinkResult<int>?> getConnectionType() async {
    final result = await _invokeMethod('getConnectionType');
    if (result == null) {
      return null;
    }

    final kvMap = json.decode(result);
    return LinkResult.fromJson(
      kvMap,
      (json) => (json as num).toInt()
    );
  }

  @override
  Future<LinkResult<int>?> getConnectionState() async {
    final result = await _invokeMethod('getConnectionState');
    if (result == null) {
      return null;
    }

    final kvMap = json.decode(result);
    return LinkResult.fromJson(
      kvMap,
      (json) => (json as num).toInt()
    );
  }

  @override
  Future<LinkResult<bool>?> checkCapability(int type) async {
    final result = await _invokeMethod('checkCapability', {'type': type});
    if (result == null) {
      return null;
    }

    final kvMap = json.decode(result);
    return LinkResult.fromJson(
      kvMap,
      (json) => (json as bool)
    );
  }

  @override
  Future<LinkResult<int>?> getRemainingRecTime() async {
    final result = await _invokeMethod('getRemainingRecTime');
    if (result == null) {
      return null;
    }

    final kvMap = json.decode(result);
    return LinkResult.fromJson(
      kvMap,
      (json) => (json as num).toInt()
    );
  }

  @override
  Future<LinkResult<int>?> getRemainingPhotoNumber() async {
    final result = await _invokeMethod('getRemainingPhotoNumber');
    if (result == null) {
      return null;
    }

    final kvMap = json.decode(result);
    return LinkResult.fromJson(
      kvMap,
      (json) => (json as num).toInt()
    );
  }

  @override
  Future<void> disconnect() async {
    await _invokeMethod('disconnect');
  }

  @override
  Future<String?> sdkVersion() async {
    final result = await _invokeMethod('sdkVersion');
    if (result == null) {
      return null;
    }
    return result;
  }
}
