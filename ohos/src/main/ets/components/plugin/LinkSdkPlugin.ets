import {
  Any,
  EventChannel,
  FlutterPlugin,
  FlutterPluginBinding,
  MethodCall,
  MethodCallHandler,
  MethodChannel,
  MethodResult
} from '@ohos/flutter_ohos';
import { StreamHandler, EventSink } from '@ohos/flutter_ohos/src/main/ets/plugin/common/EventChannel'
import { Context } from '@kit.AbilityKit';
import { Link, ErrorCode, LinkResult } from '@mopen/link-public-dev';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { JSON } from '@kit.ArkTS';
import commonEventManager from '@ohos.commonEventManager';
import { BusinessError } from '@ohos.base';
import { LinkEvent } from './LinkEvent';
import { LinkProgressData } from './LinkProgressData';

export class LinkSdkPlugin implements FlutterPlugin, MethodCallHandler, StreamHandler {
  private static TAG: string = "LinkSdkPlugin";
  private CHANNEL_LINKSDK: string = "mobile.open.sdk/linksdk"
  private CHANNEL_LINKSDK_EVENT: string = "mobile.open.sdk/linksdk/event"

  private context?: Context;

  private linkSdkChannel?: MethodChannel;
  private linkSdkEventChannel?: EventChannel;

  private static eventSink?: EventSink;
  private subscriber?: commonEventManager.CommonEventSubscriber;
  private subscribeInfo: commonEventManager.CommonEventSubscribeInfo = {
    events: [Link.EVENT_TYPE_CONNECTION_STATE, Link.EVENT_TYPE_NOTIFY]
  };

  getUniqueClassName(): string {
    return "mobile.open.sdk.link.LinkSDK";
  }

  onAttachedToEngine(binding: FlutterPluginBinding): void {
    this.context = binding.getApplicationContext();
    this.linkSdkChannel = new MethodChannel(binding.getBinaryMessenger(), this.CHANNEL_LINKSDK);
    this.linkSdkChannel?.setMethodCallHandler(this);

    this.linkSdkEventChannel = new EventChannel(binding.getBinaryMessenger(), this.CHANNEL_LINKSDK_EVENT);
    this.linkSdkEventChannel.setStreamHandler(this);

    this.createSubscriber();
    this.subscribe();
  }

  onDetachedFromEngine(binding: FlutterPluginBinding): void {
    this.linkSdkChannel?.setMethodCallHandler(null);
    this.linkSdkEventChannel?.setStreamHandler(null);
    this.context = undefined;

    this.unsubscribe();
  }

  private static keyPrefixProcess(jsonStr: string): string {
    if (typeof jsonStr !== 'string' || jsonStr === null || jsonStr === undefined) {
      return jsonStr;
    }

    const regex = /"_([^"]+)":/g;
    return jsonStr.replace(regex, (match, key: string) => `"${key}":`);
  }

  private subscribeCB(err: BusinessError, data: commonEventManager.CommonEventData) {
    if (err) {
      hilog.debug(0x0000, LinkSdkPlugin.TAG, `Failed to subscribe. Code is ${err.code}, message is ${err.message}`);
    } else {
      hilog.info(0x0000, LinkSdkPlugin.TAG, `receive notification data: ${JSON.stringify(data)}}`);

      if (data.event == Link.EVENT_TYPE_CONNECTION_STATE) {
        let eventData: LinkEvent<Object> = new LinkEvent();
        eventData.type = LinkEvent.TYPE_CONNECTION_STATE;
        eventData.payload = JSON.parse(data.data);

        LinkSdkPlugin.eventSink?.success(LinkSdkPlugin.keyPrefixProcess(JSON.stringify(eventData)));
      } else if (data.event == Link.EVENT_TYPE_NOTIFY) {
        let eventData: LinkEvent<Object> = new LinkEvent();
        eventData.type = LinkEvent.TYPE_NOTIFY;
        eventData.payload = JSON.parse(data.data);

        LinkSdkPlugin.eventSink?.success(LinkSdkPlugin.keyPrefixProcess(JSON.stringify(eventData)));
      } else {

      }
    }
  }

  private unsubscribeCB(err: BusinessError) {
    if (err) {
      hilog.error(0x0000, LinkSdkPlugin.TAG, `Failed to unsubscribe. Code is ${err.code}, message is ${err.message}`);
    } else {
      hilog.info(0x0000, LinkSdkPlugin.TAG, `Succeeded in unsubscribing.`);
    }
  }

  private createSubscriber() {
    try {
      hilog.info(0x0000, LinkSdkPlugin.TAG, `Succeeded in creating notifcation subscriber.`);
      this.subscriber = commonEventManager.createSubscriberSync(this.subscribeInfo);
    } catch (error) {
      let err: BusinessError = error as BusinessError;
      hilog.error(0x0000, LinkSdkPlugin.TAG, `Failed to create subscriber. Code is ${err.code}, message is ${err.message}`);
    }
  }

  private subscribe() {
    try {
      commonEventManager.subscribe(this.subscriber, this.subscribeCB);
    } catch (error) {
      let err: BusinessError = error as BusinessError;
      hilog.error(0x0000, LinkSdkPlugin.TAG, `Failed to subscribe. Code is ${err.code}, message is ${err.message}`);
    }
  }

  private unsubscribe() {
    try {
      commonEventManager.unsubscribe(this.subscriber, this.unsubscribeCB);
    } catch (error) {
      let err: BusinessError = error as BusinessError;
      hilog.error(0x0000, LinkSdkPlugin.TAG, `Failed to unsubscribe. Code is ${err.code}, message is ${err.message}`);
    }
  }

  private onChannelResult(method: string,
    channelCb: MethodResult,
    result: LinkResult<Any> | null,
    resultTransfer: ((result: LinkResult<Any>) => string) | null): void {
    if (result != null) {
      if (result.code != ErrorCode.LINK_ERR_OK && result.code != ErrorCode.LINK_ERR_MENU_UPGRADE) {
        hilog.error(0x0000, LinkSdkPlugin.TAG, 'link call: %{public}s failed, code is: %{public}d', method, result.code);
        channelCb.error(`${result.code}`, "sdk return error code", null);
      } else {
        let jsonStr: string;

        if (resultTransfer != null) {
          jsonStr = resultTransfer(result.data);
        } else {
          jsonStr = LinkSdkPlugin.keyPrefixProcess(JSON.stringify(result));
        }

        hilog.debug(0x0000, LinkSdkPlugin.TAG, 'link call: %{public}s successful, data is: %{public}s', method, jsonStr);
        channelCb.success(jsonStr);
      }
    } else {
      hilog.error(0x0000, LinkSdkPlugin.TAG, 'link call: %{public}s error', method);
      channelCb.error("", "sdk return result of null", null);
    }
  }

  private invokeAsyncMethod(name: string,
    method: ((...params: Any) => Promise<LinkResult<Any>>) | null | undefined,
    resultTransfer: ((result: LinkResult<Any>) => string) | null,
    channelCb: MethodResult, ...params: Any) {
    if (method == null || method == undefined) {
      hilog.error(0x0000, LinkSdkPlugin.TAG, 'can not invoke method of null or undefined');
      channelCb.notImplemented();
      return;
    }

    hilog.debug(0x0000, LinkSdkPlugin.TAG, 'invoke sdk method: %{public}s', name);

    method(params).then((ret: LinkResult<Any>) => {
      hilog.debug(0x0000, LinkSdkPlugin.TAG, 'sdk method: %{public}s, returned with code %{public}d', name, ret.code);
      this.onChannelResult(name, channelCb, ret, resultTransfer);
    }).catch((error: BusinessError) => {
      hilog.error(0x0000, LinkSdkPlugin.TAG, 'sdk method: %{public}s returned with error: %{public}s', name, error.message);
      channelCb.error("", "sdk method: " + name + " invoke error: " + error.message, null);
    });
  }

  private invokeAsyncMethodWithSimpleReturn(name: string,
    method: ((...params: Any) => Promise<Any>) | null | undefined,
    resultTransfer: ((result: Any) => Any) | null,
    channelCb: MethodResult, ...params: Any) {
    if (method == null || method == undefined) {
      hilog.error(0x0000, LinkSdkPlugin.TAG, 'can not invoke method of null or undefined');
      channelCb.notImplemented();
      return;
    }

    hilog.debug(0x0000, LinkSdkPlugin.TAG, 'invoke sdk method: %{public}s', name);

    method(params).then((ret: Any) => {
      hilog.debug(0x0000, LinkSdkPlugin.TAG, 'sdk method: %{public}s, returned with %{public}s', name, ret);

      if (resultTransfer != null) {
        channelCb.success(resultTransfer(ret));
      } else {
        channelCb.success(ret);
      }
    }).catch((error: BusinessError) => {
      hilog.error(0x0000, LinkSdkPlugin.TAG, 'sdk method: %{public}s returned with error: %{public}s', name, error.message);
      channelCb.error("", "sdk method: " + name + " invoke error: " + error.message, null);
    });
  }

  private static linkProgressCallback(dltotal: number, dlnow: number, ultotal: number, ulnow: number): void {
    let eventData: LinkEvent<LinkProgressData> = new LinkEvent();
    eventData.type = LinkEvent.TYPE_PROGRESS;
    eventData.payload = new LinkProgressData(dltotal, dlnow, ultotal, ulnow);

    LinkSdkPlugin.eventSink?.success(LinkSdkPlugin.keyPrefixProcess(JSON.stringify(eventData)));
  }

  onMethodCall(call: MethodCall, result: MethodResult): void {
    switch (call.method) {
      case "init":
        Link.init(this.context);
        Link.setProgressCallback(LinkSdkPlugin.linkProgressCallback);
        result.success(0);
        break;
      case "configNetChannel":
        //仅Android平台有此接口,兼容性保留
        result.notImplemented();
        break;
      case "clearNetChannelConfig":
        //仅Android平台有此接口,兼容性保留
        result.notImplemented();
        break;
      case "connect":
        this.invokeAsyncMethod(call.method, Link.connect, null, result);
        break;
      case "heartbeatOn":
        this.invokeAsyncMethodWithSimpleReturn(call.method, Link.heartbeatOn, null, result);
        break;
      case "setHeartbeatInterval":
        let second: number = call.argument("second");
        this.invokeAsyncMethodWithSimpleReturn(call.method, Link.setHeartbeatInterval, null, result, second);
        break;
      case "heartbeatOff":
        this.invokeAsyncMethodWithSimpleReturn(call.method, Link.heartbeatOff, null, result);
        break;
      case "getStreamUrl":
        this.invokeAsyncMethod(call.method, Link.getStreamUrl, null, result);
        break;
      case "isPhotoModeSupported":
        this.invokeAsyncMethod(call.method, Link.isPhotoModeSupported, null, result);
        break;
      case "shouldShowRTMapTracks":
        this.invokeAsyncMethod(call.method, Link.shouldShowRTMapTracks, null, result);
        break;
      case "getWorkMode":
        this.invokeAsyncMethod(call.method, Link.getWorkMode, null, result);
        break;
      case "setWorkMode":
        let workMode: number = call.argument("workMode");
        this.invokeAsyncMethod(call.method, Link.setWorkMode, null, result, workMode);
        break;
      case "getVideoRecState":
        this.invokeAsyncMethod(call.method, Link.getVideoRecState, null, result);
        break;
      case "setVideoRecState":
        let flag: number = call.argument("flag");
        this.invokeAsyncMethod(call.method, Link.setVideoRecState, null, result, flag);
        break;
      case "getVideoRecTime":
        this.invokeAsyncMethod(call.method, Link.getVideoRecTime, null, result);
        break;
      case "takePhoto":
        this.invokeAsyncMethod(call.method, Link.takePhoto, null, result);
        break;
      case "snapshot":
        this.invokeAsyncMethod(call.method, Link.snapshot, null, result);
        break;
      case "getMenu":
        let clearCache: boolean = call.argument("clearCache");
        this.invokeAsyncMethod(call.method, Link.getMenu, null, result, clearCache);
        break;
      case "getMenuState":
        let cmd: number = call.argument("cmd");
        this.invokeAsyncMethod(call.method, Link.getMenuState, null, result, cmd);
        break;
      case "setMenuState":
        {
          let cmd: number = call.argument("cmd");
          let option: string = call.argument("option");
          this.invokeAsyncMethod(call.method, Link.setMenuState, null, result, cmd, option);
        }
        break;
      case "setMenuMultipleState":
        result.notImplemented();
        break;
      case "isMultipleStorageSupported":
        this.invokeAsyncMethod(call.method, Link.isMultipleStorageSupported, null, result);
        break;
      case "isStorageSelectSupported":
        this.invokeAsyncMethod(call.method, Link.isStorageSelectSupported, null, result);
        break;
      case "storageSelect":
        let type: number = call.argument("type");
        this.invokeAsyncMethod(call.method, Link.storageSelect, null, result, type);
        break;
      case "getFileDir":
        this.invokeAsyncMethod(call.method, Link.getFileDir, null, result);
        break;
      case "getFileList":
        {
          let type: number = call.argument("type");
          let from: number = call.argument("from");
          let count: number = call.argument("count");
          this.invokeAsyncMethod(call.method, Link.getFileList, null, result, type, from, count);
        }
        break;
      case "deleteFile":
        {
          let extra: string = call.argument("extra");
          this.invokeAsyncMethod(call.method, Link.deleteFile, null, result, extra);
        }
        break;
      case "getFileCopyState":
        this.invokeAsyncMethod(call.method, Link.getFileCopyState, null, result);
        break;
      case "copyFile":
        {
          let extra: string = call.argument("extra");
          this.invokeAsyncMethod(call.method, Link.copyFile, null, result, extra);
        }
        break;
      case "getFileCopyProgress":
        this.invokeAsyncMethod(call.method, Link.getFileCopyProgress, null, result);
        break;
      case "stopFileCopy":
        this.invokeAsyncMethod(call.method, Link.stopFileCopy, null, result);
        break;
      case "getExternalStorageState":
        this.invokeAsyncMethod(call.method, Link.getExternalStorageState, null, result);
        break;
      case "shouldShowExternalStorageSpace":
        this.invokeAsyncMethod(call.method, Link.shouldShowExternalStorageSpace, null, result);
        break;
      case "getStorageSpace":
        {
          let type: number = call.argument("type");
          this.invokeAsyncMethod(call.method, Link.getStorageSpace, null, result, type);
        }
        break;
      case "isInternalStorageFormatSupported":
        this.invokeAsyncMethod(call.method, Link.isInternalStorageFormatSupported, null, result);
        break;
      case "storageFormat":
        {
          let type: number = call.argument("type");
          this.invokeAsyncMethod(call.method, Link.storageFormat, null, result, type);
        }
        break;
      case "isFileGPSInfoSupported":
        this.invokeAsyncMethod(call.method, Link.isFileGPSInfoSupported, null, result);
        break;
      case "getFileGPSInfo":
        {
          let extra: string = call.argument("extra");
          this.invokeAsyncMethod(call.method, Link.getFileGPSInfo, null, result, extra);
        }
        break;
      case "timeSync":
        this.invokeAsyncMethod(call.method, Link.timeSync, null, result);
        break;
      case "getWiFiSSID":
        this.invokeAsyncMethod(call.method, Link.getWiFiSSID, null, result);
        break;
      case "getWiFiSSIDFromDevice":
        this.invokeAsyncMethod(call.method, Link.getWiFiSSIDFromDevice, null, result);
        break;
      case "setWiFiSSID":
        {
          let ssid: string = call.argument("ssid");
          this.invokeAsyncMethod(call.method, Link.setWiFiSSID, null, result, ssid);
        }
        break;
      case "getWiFiPassword":
        this.invokeAsyncMethod(call.method, Link.getWiFiPassword, null, result);
        break;
      case "setWiFiPassword":
        {
          let pwd: string = call.argument("pwd");
          this.invokeAsyncMethod(call.method, Link.setWiFiPassword, null, result, pwd);
        }
        break;
      case "systemReset":
        this.invokeAsyncMethod(call.method, Link.systemReset, null, result);
        break;
      case "systemVersion":
        {
          let type: number = call.argument("type");
          this.invokeAsyncMethod(call.method, Link.systemVersion, null, result, type);
        }
        break;
      case "getBatteryState":
        this.invokeAsyncMethod(call.method, Link.getBatteryState, null, result);
        break;
      case "setPIRInterval":
        let interval: number = call.argument("interval");
        this.invokeAsyncMethod(call.method, Link.setPIRInterval, null, result, interval);
        break;
      case "setPIRMonitoringPeriodTime":
        let index: number = call.argument("index");
        let begin: string = call.argument("begin");
        let end: string = call.argument("end");
        this.invokeAsyncMethod(call.method, Link.setPIRMonitoringPeriodTime, null, result, index, begin, end);
        break;
      case "getOTASupportState":
        this.invokeAsyncMethod(call.method, Link.getOTASupportState, null, result);
        break;
      case "getSoftwareVersion":
        {
          let type: number = call.argument("type");
          this.invokeAsyncMethod(call.method, Link.getSoftwareVersion, null, result, type);
        }
        break;
      case "sendUpgradeFile":
        {
          let type: number = call.argument("type");
          let filePath: string = call.argument("filePath");
          this.invokeAsyncMethod(call.method, Link.sendUpgradeFile, null, result, type, filePath);
        }
        break;
      case "softwareUpdate":
        {
          let type: number = call.argument("type");
          let filePath: string = call.argument("filePath");
          this.invokeAsyncMethod(call.method, Link.softwareUpdate, null, result, type, filePath);
        }
        break;
      case "recLock":
        this.invokeAsyncMethod(call.method, Link.recLock, null, result);
        break;
      case "changeFileLockState":
        {
          let extra: string = call.argument("extra");
          this.invokeAsyncMethod(call.method, Link.changeFileLockState, null, result, extra);
        }
        break;
      case "getCameraState":
        {
          let index: number = call.argument("index");
          this.invokeAsyncMethod(call.method, Link.getCameraState, null, result, index);
        }
        break;
      case "getChipId":
        this.invokeAsyncMethod(call.method, Link.getChipId, null, result);
        break;
      case "getConnectionType":
        this.invokeAsyncMethod(call.method, Link.getConnectionType, null, result);
        break;
      case "getConnectionState":
        this.invokeAsyncMethod(call.method, Link.getConnectionState, null, result);
        break;
      case "checkCapability":
        {
          let type: number = call.argument("type");
          this.invokeAsyncMethod(call.method, Link.checkCapability, null, result, type);
        }
        break;
      case "getRemainingRecTime":
        this.invokeAsyncMethod(call.method, Link.getRemainingRecTime, null, result);
        break;
      case "getRemainingPhotoNumber":
        this.invokeAsyncMethod(call.method, Link.getRemainingPhotoNumber, null, result);
        break;
      case "disconnect":
        Link.disconnect();
        result.success(0);
        break;
      case "sdkVersion":
        const version: String = Link.sdkVersion();
        result.success(version);
        break;
      default:
        result.notImplemented();
        break;
    }
  }

  onListen(args: object, events: EventSink): void {
    LinkSdkPlugin.eventSink = events;
  }

  onCancel(args: object): void {
    LinkSdkPlugin.eventSink = undefined;
  }
}