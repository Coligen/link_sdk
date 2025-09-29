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
import { Link, ErrorCode, LinkResult, LinkFile, LinkStreamUrl, LinkMenu, LinkSoftwareVersion, LinkSpace } from '@mopen/link-public-dev';
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

  private async onChannelResult(method: string,
    channelCb: MethodResult,
    result: LinkResult<Any> | null,
    resultTransfer: ((result: LinkResult<Any>) => string) | null) {
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

  private static linkProgressCallback(dltotal: number, dlnow: number, ultotal: number, ulnow: number): void {
    let eventData: LinkEvent<LinkProgressData> = new LinkEvent();
    eventData.type = LinkEvent.TYPE_PROGRESS;
    eventData.payload = new LinkProgressData(dltotal, dlnow, ultotal, ulnow);

    LinkSdkPlugin.eventSink?.success(LinkSdkPlugin.keyPrefixProcess(JSON.stringify(eventData)));
  }

  async onMethodCall(call: MethodCall, result: MethodResult) {
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
        try {
          let ret: LinkResult<void> = await Link.connect();
          hilog.debug(0x0000, LinkSdkPlugin.TAG, 'sdk method: %{public}s, returned with code %{public}d', call.method, ret.code);
          await this.onChannelResult(call.method, result, ret, null);
        } catch(error) {
          hilog.error(0x0000, LinkSdkPlugin.TAG, 'sdk method: %{public}s returned with error: %{public}s', call.method, error.message);
          result.error("", "sdk method: " + call.method + " invoke error: " + error.message, null);
        }
        break;
      case "heartbeatOn":
        try {
          let ret: void = await Link.heartbeatOn();
          hilog.debug(0x0000, LinkSdkPlugin.TAG, 'sdk method: %{public}s, returned', call.method);
          result.success(ret);
        } catch(error) {
          hilog.error(0x0000, LinkSdkPlugin.TAG, 'sdk method: %{public}s returned with error: %{public}s', call.method, error.message);
          result.error("", "sdk method: " + call.method + " invoke error: " + error.message, null);
        }
        break;
      case "setHeartbeatInterval":
        let second: number = call.argument("second");

        try {
          let ret: void = await Link.setHeartbeatInterval(second);
          hilog.debug(0x0000, LinkSdkPlugin.TAG, 'sdk method: %{public}s, returned', call.method);
          result.success(ret);
        } catch(error) {
          hilog.error(0x0000, LinkSdkPlugin.TAG, 'sdk method: %{public}s returned with error: %{public}s', call.method, error.message);
          result.error("", "sdk method: " + call.method + " invoke error: " + error.message, null);
        }
        break;
      case "heartbeatOff":
        try {
          let ret: void = await Link.heartbeatOff();
          hilog.debug(0x0000, LinkSdkPlugin.TAG, 'sdk method: %{public}s, returned', call.method);
          result.success(ret);
        } catch(error) {
          hilog.error(0x0000, LinkSdkPlugin.TAG, 'sdk method: %{public}s returned with error: %{public}s', call.method, error.message);
          result.error("", "sdk method: " + call.method + " invoke error: " + error.message, null);
        }
        break;
      case "getStreamUrl":
        try {
          let ret: LinkResult<Array<LinkStreamUrl>> = await Link.getStreamUrl();
          hilog.debug(0x0000, LinkSdkPlugin.TAG, 'sdk method: %{public}s, returned with code %{public}d', call.method, ret.code);
          await this.onChannelResult(call.method, result, ret, null);
        } catch(error) {
          hilog.error(0x0000, LinkSdkPlugin.TAG, 'sdk method: %{public}s returned with error: %{public}s', call.method, error.message);
          result.error("", "sdk method: " + call.method + " invoke error: " + error.message, null);
        }
        break;
      case "isPhotoModeSupported":
        try {
          let ret: LinkResult<Number> = await Link.isPhotoModeSupported();
          hilog.debug(0x0000, LinkSdkPlugin.TAG, 'sdk method: %{public}s, returned with code %{public}d', call.method, ret.code);
          await this.onChannelResult(call.method, result, ret, null);
        } catch(error) {
          hilog.error(0x0000, LinkSdkPlugin.TAG, 'sdk method: %{public}s returned with error: %{public}s', call.method, error.message);
          result.error("", "sdk method: " + call.method + " invoke error: " + error.message, null);
        }
        break;
      case "shouldShowRTMapTracks":
        try {
          let ret: LinkResult<Number> = await Link.shouldShowRTMapTracks();
          hilog.debug(0x0000, LinkSdkPlugin.TAG, 'sdk method: %{public}s, returned with code %{public}d', call.method, ret.code);
          await this.onChannelResult(call.method, result, ret, null);
        } catch(error) {
          hilog.error(0x0000, LinkSdkPlugin.TAG, 'sdk method: %{public}s returned with error: %{public}s', call.method, error.message);
          result.error("", "sdk method: " + call.method + " invoke error: " + error.message, null);
        }
        break;
      case "getWorkMode":
        try {
          let ret: LinkResult<Number> = await Link.getWorkMode();
          hilog.debug(0x0000, LinkSdkPlugin.TAG, 'sdk method: %{public}s, returned with code %{public}d', call.method, ret.code);
          await this.onChannelResult(call.method, result, ret, null);
        } catch(error) {
          hilog.error(0x0000, LinkSdkPlugin.TAG, 'sdk method: %{public}s returned with error: %{public}s', call.method, error.message);
          result.error("", "sdk method: " + call.method + " invoke error: " + error.message, null);
        }
        break;
      case "setWorkMode":
        let workMode: number = call.argument("workMode");
        try {
          let ret: LinkResult<Number> = await Link.setWorkMode(workMode);
          hilog.debug(0x0000, LinkSdkPlugin.TAG, 'sdk method: %{public}s, returned with code %{public}d', call.method, ret.code);
          await this.onChannelResult(call.method, result, ret, null);
        } catch(error) {
          hilog.error(0x0000, LinkSdkPlugin.TAG, 'sdk method: %{public}s returned with error: %{public}s', call.method, error.message);
          result.error("", "sdk method: " + call.method + " invoke error: " + error.message, null);
        }
        break;
      case "getVideoRecState":
        try {
          let ret: LinkResult<Number> = await Link.getVideoRecState();
          hilog.debug(0x0000, LinkSdkPlugin.TAG, 'sdk method: %{public}s, returned with code %{public}d', call.method, ret.code);
          await this.onChannelResult(call.method, result, ret, null);
        } catch(error) {
          hilog.error(0x0000, LinkSdkPlugin.TAG, 'sdk method: %{public}s returned with error: %{public}s', call.method, error.message);
          result.error("", "sdk method: " + call.method + " invoke error: " + error.message, null);
        }
        break;
      case "setVideoRecState":
        let flag: number = call.argument("flag");
        try {
          let ret: LinkResult<Number> = await Link.setVideoRecState(flag);
          hilog.debug(0x0000, LinkSdkPlugin.TAG, 'sdk method: %{public}s, returned with code %{public}d', call.method, ret.code);
          await this.onChannelResult(call.method, result, ret, null);
        } catch(error) {
          hilog.error(0x0000, LinkSdkPlugin.TAG, 'sdk method: %{public}s returned with error: %{public}s', call.method, error.message);
          result.error("", "sdk method: " + call.method + " invoke error: " + error.message, null);
        }
        break;
      case "getVideoRecTime":
        try {
          let ret: LinkResult<Number> = await Link.getVideoRecTime();
          hilog.debug(0x0000, LinkSdkPlugin.TAG, 'sdk method: %{public}s, returned with code %{public}d', call.method, ret.code);
          await this.onChannelResult(call.method, result, ret, null);
        } catch(error) {
          hilog.error(0x0000, LinkSdkPlugin.TAG, 'sdk method: %{public}s returned with error: %{public}s', call.method, error.message);
          result.error("", "sdk method: " + call.method + " invoke error: " + error.message, null);
        }
        break;
      case "takePhoto":
        try {
          let ret: LinkResult<Number> = await Link.takePhoto();
          hilog.debug(0x0000, LinkSdkPlugin.TAG, 'sdk method: %{public}s, returned with code %{public}d', call.method, ret.code);
          await this.onChannelResult(call.method, result, ret, null);
        } catch(error) {
          hilog.error(0x0000, LinkSdkPlugin.TAG, 'sdk method: %{public}s returned with error: %{public}s', call.method, error.message);
          result.error("", "sdk method: " + call.method + " invoke error: " + error.message, null);
        }
        break;
      case "snapshot":
        try {
          let ret: LinkResult<Number> = await Link.snapshot();
          hilog.debug(0x0000, LinkSdkPlugin.TAG, 'sdk method: %{public}s, returned with code %{public}d', call.method, ret.code);
          await this.onChannelResult(call.method, result, ret, null);
        } catch(error) {
          hilog.error(0x0000, LinkSdkPlugin.TAG, 'sdk method: %{public}s returned with error: %{public}s', call.method, error.message);
          result.error("", "sdk method: " + call.method + " invoke error: " + error.message, null);
        }
        break;
      case "getMenu":
        let clearCache: boolean = call.argument("clearCache");
        try {
          let ret: LinkResult<Array<LinkMenu>> = await Link.getMenu(clearCache);
          hilog.debug(0x0000, LinkSdkPlugin.TAG, 'sdk method: %{public}s, returned with code %{public}d', call.method, ret.code);
          await this.onChannelResult(call.method, result, ret, null);
        } catch(error) {
          hilog.error(0x0000, LinkSdkPlugin.TAG, 'sdk method: %{public}s returned with error: %{public}s', call.method, error.message);
          result.error("", "sdk method: " + call.method + " invoke error: " + error.message, null);
        }
        break;
      case "getMenuState":
        let cmd: number = call.argument("cmd");
        try {
          let ret: LinkResult<String> = await Link.getMenuState(cmd);
          hilog.debug(0x0000, LinkSdkPlugin.TAG, 'sdk method: %{public}s, returned with code %{public}d', call.method, ret.code);
          await this.onChannelResult(call.method, result, ret, null);
        } catch(error) {
          hilog.error(0x0000, LinkSdkPlugin.TAG, 'sdk method: %{public}s returned with error: %{public}s', call.method, error.message);
          result.error("", "sdk method: " + call.method + " invoke error: " + error.message, null);
        }
        break;
      case "setMenuState":
        {
          let cmd: number = call.argument("cmd");
          let option: string = call.argument("option");

          try {
            let ret: LinkResult<Number> = await Link.setMenuState(cmd, option);
            hilog.debug(0x0000, LinkSdkPlugin.TAG, 'sdk method: %{public}s, returned with code %{public}d', call.method, ret.code);
            await this.onChannelResult(call.method, result, ret, null);
          } catch(error) {
            hilog.error(0x0000, LinkSdkPlugin.TAG, 'sdk method: %{public}s returned with error: %{public}s', call.method, error.message);
            result.error("", "sdk method: " + call.method + " invoke error: " + error.message, null);
          }
        }
        break;
      case "setMenuMultipleState":
        result.notImplemented();
        break;
      case "isMultipleStorageSupported":
        try {
          let ret: LinkResult<Number> = await Link.isMultipleStorageSupported();
          hilog.debug(0x0000, LinkSdkPlugin.TAG, 'sdk method: %{public}s, returned with code %{public}d', call.method, ret.code);
          await this.onChannelResult(call.method, result, ret, null);
        } catch(error) {
          hilog.error(0x0000, LinkSdkPlugin.TAG, 'sdk method: %{public}s returned with error: %{public}s', call.method, error.message);
          result.error("", "sdk method: " + call.method + " invoke error: " + error.message, null);
        }
        break;
      case "isStorageSelectSupported":
        try {
          let ret: LinkResult<Number> = await Link.isStorageSelectSupported();
          hilog.debug(0x0000, LinkSdkPlugin.TAG, 'sdk method: %{public}s, returned with code %{public}d', call.method, ret.code);
          await this.onChannelResult(call.method, result, ret, null);
        } catch(error) {
          hilog.error(0x0000, LinkSdkPlugin.TAG, 'sdk method: %{public}s returned with error: %{public}s', call.method, error.message);
          result.error("", "sdk method: " + call.method + " invoke error: " + error.message, null);
        }
        break;
      case "storageSelect":
        let type: number = call.argument("type");

        try {
          let ret: LinkResult<Number> = await Link.storageSelect(type);
          hilog.debug(0x0000, LinkSdkPlugin.TAG, 'sdk method: %{public}s, returned with code %{public}d', call.method, ret.code);
          await this.onChannelResult(call.method, result, ret, null);
        } catch(error) {
          hilog.error(0x0000, LinkSdkPlugin.TAG, 'sdk method: %{public}s returned with error: %{public}s', call.method, error.message);
          result.error("", "sdk method: " + call.method + " invoke error: " + error.message, null);
        }
        break;
      case "getFileDir":
        try {
          let ret: LinkResult<Array<Number>> = await Link.getFileDir();
          hilog.debug(0x0000, LinkSdkPlugin.TAG, 'sdk method: %{public}s, returned with code %{public}d', call.method, ret.code);
          await this.onChannelResult(call.method, result, ret, null);
        } catch(error) {
          hilog.error(0x0000, LinkSdkPlugin.TAG, 'sdk method: %{public}s returned with error: %{public}s', call.method, error.message);
          result.error("", "sdk method: " + call.method + " invoke error: " + error.message, null);
        }
        break;
      case "getFileList":
        {
          let type: number = call.argument("type");
          let from: number = call.argument("from");
          let count: number = call.argument("count");

          try {
            let ret: LinkResult<Array<LinkFile>> = await Link.getFileList(type, from, count);
            hilog.debug(0x0000, LinkSdkPlugin.TAG, 'sdk method: %{public}s, returned with code %{public}d', call.method, ret.code);
            await this.onChannelResult(call.method, result, ret, null);
          } catch(error) {
            hilog.error(0x0000, LinkSdkPlugin.TAG, 'sdk method: %{public}s returned with error: %{public}s', call.method, error.message);
            result.error("", "sdk method: " + call.method + " invoke error: " + error.message, null);
          }
        }
        break;
      case "deleteFile":
        {
          let extra: string = call.argument("extra");

          try {
            let ret: LinkResult<Number> = await Link.deleteFile(extra);
            hilog.debug(0x0000, LinkSdkPlugin.TAG, 'sdk method: %{public}s, returned with code %{public}d', call.method, ret.code);
            await this.onChannelResult(call.method, result, ret, null);
          } catch(error) {
            hilog.error(0x0000, LinkSdkPlugin.TAG, 'sdk method: %{public}s returned with error: %{public}s', call.method, error.message);
            result.error("", "sdk method: " + call.method + " invoke error: " + error.message, null);
          }
        }
        break;
      case "getFileCopyState":
        try {
          let ret: LinkResult<Number> = await Link.getFileCopyState();
          hilog.debug(0x0000, LinkSdkPlugin.TAG, 'sdk method: %{public}s, returned with code %{public}d', call.method, ret.code);
          await this.onChannelResult(call.method, result, ret, null);
        } catch(error) {
          hilog.error(0x0000, LinkSdkPlugin.TAG, 'sdk method: %{public}s returned with error: %{public}s', call.method, error.message);
          result.error("", "sdk method: " + call.method + " invoke error: " + error.message, null);
        }
        break;
      case "copyFile":
        {
          let extra: string = call.argument("extra");

          try {
            let ret: LinkResult<Number> = await Link.copyFile(extra);
            hilog.debug(0x0000, LinkSdkPlugin.TAG, 'sdk method: %{public}s, returned with code %{public}d', call.method, ret.code);
            await this.onChannelResult(call.method, result, ret, null);
          } catch(error) {
            hilog.error(0x0000, LinkSdkPlugin.TAG, 'sdk method: %{public}s returned with error: %{public}s', call.method, error.message);
            result.error("", "sdk method: " + call.method + " invoke error: " + error.message, null);
          }
        }
        break;
      case "getFileCopyProgress":
        try {
          let ret: LinkResult<Number> = await Link.getFileCopyProgress();
          hilog.debug(0x0000, LinkSdkPlugin.TAG, 'sdk method: %{public}s, returned with code %{public}d', call.method, ret.code);
          await this.onChannelResult(call.method, result, ret, null);
        } catch(error) {
          hilog.error(0x0000, LinkSdkPlugin.TAG, 'sdk method: %{public}s returned with error: %{public}s', call.method, error.message);
          result.error("", "sdk method: " + call.method + " invoke error: " + error.message, null);
        }
        break;
      case "stopFileCopy":
        try {
          let ret: LinkResult<Number> = await Link.stopFileCopy();
          hilog.debug(0x0000, LinkSdkPlugin.TAG, 'sdk method: %{public}s, returned with code %{public}d', call.method, ret.code);
          await this.onChannelResult(call.method, result, ret, null);
        } catch(error) {
          hilog.error(0x0000, LinkSdkPlugin.TAG, 'sdk method: %{public}s returned with error: %{public}s', call.method, error.message);
          result.error("", "sdk method: " + call.method + " invoke error: " + error.message, null);
        }
        break;
      case "getExternalStorageState":
        try {
          let ret: LinkResult<Number> = await Link.getExternalStorageState();
          hilog.debug(0x0000, LinkSdkPlugin.TAG, 'sdk method: %{public}s, returned with code %{public}d', call.method, ret.code);
          await this.onChannelResult(call.method, result, ret, null);
        } catch(error) {
          hilog.error(0x0000, LinkSdkPlugin.TAG, 'sdk method: %{public}s returned with error: %{public}s', call.method, error.message);
          result.error("", "sdk method: " + call.method + " invoke error: " + error.message, null);
        }
        break;
      case "shouldShowExternalStorageSpace":
        try {
          let ret: LinkResult<Number> = await Link.shouldShowExternalStorageSpace();
          hilog.debug(0x0000, LinkSdkPlugin.TAG, 'sdk method: %{public}s, returned with code %{public}d', call.method, ret.code);
          await this.onChannelResult(call.method, result, ret, null);
        } catch(error) {
          hilog.error(0x0000, LinkSdkPlugin.TAG, 'sdk method: %{public}s returned with error: %{public}s', call.method, error.message);
          result.error("", "sdk method: " + call.method + " invoke error: " + error.message, null);
        }
        break;
      case "getStorageSpace":
        {
          let type: number = call.argument("type");

          try {
            let ret: LinkResult<LinkSpace> = await Link.getStorageSpace(type);
            hilog.debug(0x0000, LinkSdkPlugin.TAG, 'sdk method: %{public}s, returned with code %{public}d', call.method, ret.code);
            await this.onChannelResult(call.method, result, ret, null);
          } catch(error) {
            hilog.error(0x0000, LinkSdkPlugin.TAG, 'sdk method: %{public}s returned with error: %{public}s', call.method, error.message);
            result.error("", "sdk method: " + call.method + " invoke error: " + error.message, null);
          }
        }
        break;
      case "isInternalStorageFormatSupported":
        try {
          let ret: LinkResult<Number> = await Link.isInternalStorageFormatSupported();
          hilog.debug(0x0000, LinkSdkPlugin.TAG, 'sdk method: %{public}s, returned with code %{public}d', call.method, ret.code);
          await this.onChannelResult(call.method, result, ret, null);
        } catch(error) {
          hilog.error(0x0000, LinkSdkPlugin.TAG, 'sdk method: %{public}s returned with error: %{public}s', call.method, error.message);
          result.error("", "sdk method: " + call.method + " invoke error: " + error.message, null);
        }
        break;
      case "storageFormat":
        {
          let type: number = call.argument("type");

          try {
            let ret: LinkResult<Number> = await Link.storageFormat(type);
            hilog.debug(0x0000, LinkSdkPlugin.TAG, 'sdk method: %{public}s, returned with code %{public}d', call.method, ret.code);
            await this.onChannelResult(call.method, result, ret, null);
          } catch(error) {
            hilog.error(0x0000, LinkSdkPlugin.TAG, 'sdk method: %{public}s returned with error: %{public}s', call.method, error.message);
            result.error("", "sdk method: " + call.method + " invoke error: " + error.message, null);
          }
        }
        break;
      case "isFileGPSInfoSupported":
        try {
          let ret: LinkResult<Number> = await Link.isFileGPSInfoSupported();
          hilog.debug(0x0000, LinkSdkPlugin.TAG, 'sdk method: %{public}s, returned with code %{public}d', call.method, ret.code);
          await this.onChannelResult(call.method, result, ret, null);
        } catch(error) {
          hilog.error(0x0000, LinkSdkPlugin.TAG, 'sdk method: %{public}s returned with error: %{public}s', call.method, error.message);
          result.error("", "sdk method: " + call.method + " invoke error: " + error.message, null);
        }
        break;
      case "getFileGPSInfo":
        {
          let extra: string = call.argument("extra");

          try {
            let ret: LinkResult<String> = await Link.getFileGPSInfo(extra);
            hilog.debug(0x0000, LinkSdkPlugin.TAG, 'sdk method: %{public}s, returned with code %{public}d', call.method, ret.code);
            await this.onChannelResult(call.method, result, ret, null);
          } catch(error) {
            hilog.error(0x0000, LinkSdkPlugin.TAG, 'sdk method: %{public}s returned with error: %{public}s', call.method, error.message);
            result.error("", "sdk method: " + call.method + " invoke error: " + error.message, null);
          }
        }
        break;
      case "timeSync":
        try {
          let ret: LinkResult<Number> = await Link.timeSync();
          hilog.debug(0x0000, LinkSdkPlugin.TAG, 'sdk method: %{public}s, returned with code %{public}d', call.method, ret.code);
          await this.onChannelResult(call.method, result, ret, null);
        } catch(error) {
          hilog.error(0x0000, LinkSdkPlugin.TAG, 'sdk method: %{public}s returned with error: %{public}s', call.method, error.message);
          result.error("", "sdk method: " + call.method + " invoke error: " + error.message, null);
        }
        break;
      case "getWiFiSSID":
        try {
          let ret: LinkResult<String> = await Link.getWiFiSSID();
          hilog.debug(0x0000, LinkSdkPlugin.TAG, 'sdk method: %{public}s, returned with code %{public}d', call.method, ret.code);
          await this.onChannelResult(call.method, result, ret, null);
        } catch(error) {
          hilog.error(0x0000, LinkSdkPlugin.TAG, 'sdk method: %{public}s returned with error: %{public}s', call.method, error.message);
          result.error("", "sdk method: " + call.method + " invoke error: " + error.message, null);
        }
        break;
      case "getWiFiSSIDFromDevice":
        try {
          let ret: LinkResult<String> = await Link.getWiFiSSIDFromDevice();
          hilog.debug(0x0000, LinkSdkPlugin.TAG, 'sdk method: %{public}s, returned with code %{public}d', call.method, ret.code);
          await this.onChannelResult(call.method, result, ret, null);
        } catch(error) {
          hilog.error(0x0000, LinkSdkPlugin.TAG, 'sdk method: %{public}s returned with error: %{public}s', call.method, error.message);
          result.error("", "sdk method: " + call.method + " invoke error: " + error.message, null);
        }
        break;
      case "setWiFiSSID":
        {
          let ssid: string = call.argument("ssid");

          try {
            let ret: LinkResult<Number> = await Link.setWiFiSSID(ssid);
            hilog.debug(0x0000, LinkSdkPlugin.TAG, 'sdk method: %{public}s, returned with code %{public}d', call.method, ret.code);
            await this.onChannelResult(call.method, result, ret, null);
          } catch(error) {
            hilog.error(0x0000, LinkSdkPlugin.TAG, 'sdk method: %{public}s returned with error: %{public}s', call.method, error.message);
            result.error("", "sdk method: " + call.method + " invoke error: " + error.message, null);
          }
        }
        break;
      case "getWiFiPassword":
        try {
          let ret: LinkResult<String> = await Link.getWiFiPassword();
          hilog.debug(0x0000, LinkSdkPlugin.TAG, 'sdk method: %{public}s, returned with code %{public}d', call.method, ret.code);
          await this.onChannelResult(call.method, result, ret, null);
        } catch(error) {
          hilog.error(0x0000, LinkSdkPlugin.TAG, 'sdk method: %{public}s returned with error: %{public}s', call.method, error.message);
          result.error("", "sdk method: " + call.method + " invoke error: " + error.message, null);
        }
        break;
      case "setWiFiPassword":
        {
          let pwd: string = call.argument("pwd");

          try {
            let ret: LinkResult<Number> = await Link.setWiFiPassword(pwd);
            hilog.debug(0x0000, LinkSdkPlugin.TAG, 'sdk method: %{public}s, returned with code %{public}d', call.method, ret.code);
            await this.onChannelResult(call.method, result, ret, null);
          } catch(error) {
            hilog.error(0x0000, LinkSdkPlugin.TAG, 'sdk method: %{public}s returned with error: %{public}s', call.method, error.message);
            result.error("", "sdk method: " + call.method + " invoke error: " + error.message, null);
          }
        }
        break;
      case "systemReset":
        try {
          let ret: LinkResult<Number> = await Link.systemReset();
          hilog.debug(0x0000, LinkSdkPlugin.TAG, 'sdk method: %{public}s, returned with code %{public}d', call.method, ret.code);
          await this.onChannelResult(call.method, result, ret, null);
        } catch(error) {
          hilog.error(0x0000, LinkSdkPlugin.TAG, 'sdk method: %{public}s returned with error: %{public}s', call.method, error.message);
          result.error("", "sdk method: " + call.method + " invoke error: " + error.message, null);
        }
        break;
      case "systemVersion":
        {
          let type: number = call.argument("type");

          try {
            let ret: LinkResult<String> = await Link.systemVersion(type);
            hilog.debug(0x0000, LinkSdkPlugin.TAG, 'sdk method: %{public}s, returned with code %{public}d', call.method, ret.code);
            await this.onChannelResult(call.method, result, ret, null);
          } catch(error) {
            hilog.error(0x0000, LinkSdkPlugin.TAG, 'sdk method: %{public}s returned with error: %{public}s', call.method, error.message);
            result.error("", "sdk method: " + call.method + " invoke error: " + error.message, null);
          }
        }
        break;
      case "getBatteryState":
        try {
          let ret: LinkResult<Number> = await Link.getBatteryState();
          hilog.debug(0x0000, LinkSdkPlugin.TAG, 'sdk method: %{public}s, returned with code %{public}d', call.method, ret.code);
          await this.onChannelResult(call.method, result, ret, null);
        } catch(error) {
          hilog.error(0x0000, LinkSdkPlugin.TAG, 'sdk method: %{public}s returned with error: %{public}s', call.method, error.message);
          result.error("", "sdk method: " + call.method + " invoke error: " + error.message, null);
        }
        break;
      case "setPIRInterval":
        let interval: number = call.argument("interval");

        try {
          let ret: LinkResult<Number> = await Link.setPIRInterval(interval);
          hilog.debug(0x0000, LinkSdkPlugin.TAG, 'sdk method: %{public}s, returned with code %{public}d', call.method, ret.code);
          await this.onChannelResult(call.method, result, ret, null);
        } catch(error) {
          hilog.error(0x0000, LinkSdkPlugin.TAG, 'sdk method: %{public}s returned with error: %{public}s', call.method, error.message);
          result.error("", "sdk method: " + call.method + " invoke error: " + error.message, null);
        }
        break;
      case "setPIRMonitoringPeriodTime":
        let index: number = call.argument("index");
        let begin: string = call.argument("begin");
        let end: string = call.argument("end");

        try {
          let ret: LinkResult<Number> = await Link.setPIRMonitoringPeriodTime(index, begin, end);
          hilog.debug(0x0000, LinkSdkPlugin.TAG, 'sdk method: %{public}s, returned with code %{public}d', call.method, ret.code);
          await this.onChannelResult(call.method, result, ret, null);
        } catch(error) {
          hilog.error(0x0000, LinkSdkPlugin.TAG, 'sdk method: %{public}s returned with error: %{public}s', call.method, error.message);
          result.error("", "sdk method: " + call.method + " invoke error: " + error.message, null);
        }
        break;
      case "getOTASupportState":
        try {
          let ret: LinkResult<Number> = await Link.getOTASupportState();
          hilog.debug(0x0000, LinkSdkPlugin.TAG, 'sdk method: %{public}s, returned with code %{public}d', call.method, ret.code);
          await this.onChannelResult(call.method, result, ret, null);
        } catch(error) {
          hilog.error(0x0000, LinkSdkPlugin.TAG, 'sdk method: %{public}s returned with error: %{public}s', call.method, error.message);
          result.error("", "sdk method: " + call.method + " invoke error: " + error.message, null);
        }
        break;
      case "getSoftwareVersion":
        {
          let type: number = call.argument("type");

          try {
            let ret: LinkResult<LinkSoftwareVersion> = await Link.getSoftwareVersion(type);
            hilog.debug(0x0000, LinkSdkPlugin.TAG, 'sdk method: %{public}s, returned with code %{public}d', call.method, ret.code);
            await this.onChannelResult(call.method, result, ret, null);
          } catch(error) {
            hilog.error(0x0000, LinkSdkPlugin.TAG, 'sdk method: %{public}s returned with error: %{public}s', call.method, error.message);
            result.error("", "sdk method: " + call.method + " invoke error: " + error.message, null);
          }
        }
        break;
      case "sendUpgradeFile":
        {
          let type: number = call.argument("type");
          let filePath: string = call.argument("filePath");

          try {
            let ret: LinkResult<Number> = await Link.sendUpgradeFile(type, filePath);
            hilog.debug(0x0000, LinkSdkPlugin.TAG, 'sdk method: %{public}s, returned with code %{public}d', call.method, ret.code);
            await this.onChannelResult(call.method, result, ret, null);
          } catch(error) {
            hilog.error(0x0000, LinkSdkPlugin.TAG, 'sdk method: %{public}s returned with error: %{public}s', call.method, error.message);
            result.error("", "sdk method: " + call.method + " invoke error: " + error.message, null);
          }
        }
        break;
      case "softwareUpdate":
        {
          let type: number = call.argument("type");
          let filePath: string = call.argument("filePath");

          try {
            let ret: LinkResult<Number> = await Link.softwareUpdate(type, filePath);
            hilog.debug(0x0000, LinkSdkPlugin.TAG, 'sdk method: %{public}s, returned with code %{public}d', call.method, ret.code);
            await this.onChannelResult(call.method, result, ret, null);
          } catch(error) {
            hilog.error(0x0000, LinkSdkPlugin.TAG, 'sdk method: %{public}s returned with error: %{public}s', call.method, error.message);
            result.error("", "sdk method: " + call.method + " invoke error: " + error.message, null);
          }
        }
        break;
      case "recLock":
        try {
          let ret: LinkResult<Number> = await Link.recLock();
          hilog.debug(0x0000, LinkSdkPlugin.TAG, 'sdk method: %{public}s, returned with code %{public}d', call.method, ret.code);
          await this.onChannelResult(call.method, result, ret, null);
        } catch(error) {
          hilog.error(0x0000, LinkSdkPlugin.TAG, 'sdk method: %{public}s returned with error: %{public}s', call.method, error.message);
          result.error("", "sdk method: " + call.method + " invoke error: " + error.message, null);
        }
        break;
      case "changeFileLockState":
        {
          let extra: string = call.argument("extra");

          try {
            let ret: LinkResult<Number> = await Link.changeFileLockState(extra);
            hilog.debug(0x0000, LinkSdkPlugin.TAG, 'sdk method: %{public}s, returned with code %{public}d', call.method, ret.code);
            await this.onChannelResult(call.method, result, ret, null);
          } catch(error) {
            hilog.error(0x0000, LinkSdkPlugin.TAG, 'sdk method: %{public}s returned with error: %{public}s', call.method, error.message);
            result.error("", "sdk method: " + call.method + " invoke error: " + error.message, null);
          }
        }
        break;
      case "getCameraState":
        {
          let index: number = call.argument("index");

          try {
            let ret: LinkResult<Number> = await Link.getCameraState(index);
            hilog.debug(0x0000, LinkSdkPlugin.TAG, 'sdk method: %{public}s, returned with code %{public}d', call.method, ret.code);
            await this.onChannelResult(call.method, result, ret, null);
          } catch(error) {
            hilog.error(0x0000, LinkSdkPlugin.TAG, 'sdk method: %{public}s returned with error: %{public}s', call.method, error.message);
            result.error("", "sdk method: " + call.method + " invoke error: " + error.message, null);
          }
        }
        break;
      case "getChipId":
        try {
          let ret: LinkResult<String> = await Link.getChipId();
          hilog.debug(0x0000, LinkSdkPlugin.TAG, 'sdk method: %{public}s, returned with code %{public}d', call.method, ret.code);
          await this.onChannelResult(call.method, result, ret, null);
        } catch(error) {
          hilog.error(0x0000, LinkSdkPlugin.TAG, 'sdk method: %{public}s returned with error: %{public}s', call.method, error.message);
          result.error("", "sdk method: " + call.method + " invoke error: " + error.message, null);
        }
        break;
      case "getConnectionType":
        try {
          let ret: LinkResult<Number> = await Link.getConnectionType();
          hilog.debug(0x0000, LinkSdkPlugin.TAG, 'sdk method: %{public}s, returned with code %{public}d', call.method, ret.code);
          await this.onChannelResult(call.method, result, ret, null);
        } catch(error) {
          hilog.error(0x0000, LinkSdkPlugin.TAG, 'sdk method: %{public}s returned with error: %{public}s', call.method, error.message);
          result.error("", "sdk method: " + call.method + " invoke error: " + error.message, null);
        }
        break;
      case "getConnectionState":
        try {
          let ret: LinkResult<Number> = await Link.getConnectionState();
          hilog.debug(0x0000, LinkSdkPlugin.TAG, 'sdk method: %{public}s, returned with code %{public}d', call.method, ret.code);
          await this.onChannelResult(call.method, result, ret, null);
        } catch(error) {
          hilog.error(0x0000, LinkSdkPlugin.TAG, 'sdk method: %{public}s returned with error: %{public}s', call.method, error.message);
          result.error("", "sdk method: " + call.method + " invoke error: " + error.message, null);
        }
        break;
      case "checkCapability":
        {
          let type: number = call.argument("type");

          try {
            let ret: LinkResult<Boolean> = await Link.checkCapability(type);
            hilog.debug(0x0000, LinkSdkPlugin.TAG, 'sdk method: %{public}s, returned with code %{public}d', call.method, ret.code);
            await this.onChannelResult(call.method, result, ret, null);
          } catch(error) {
            hilog.error(0x0000, LinkSdkPlugin.TAG, 'sdk method: %{public}s returned with error: %{public}s', call.method, error.message);
            result.error("", "sdk method: " + call.method + " invoke error: " + error.message, null);
          }
        }
        break;
      case "getRemainingRecTime":
        try {
          let ret: LinkResult<Number> = await Link.getRemainingRecTime();
          hilog.debug(0x0000, LinkSdkPlugin.TAG, 'sdk method: %{public}s, returned with code %{public}d', call.method, ret.code);
          await this.onChannelResult(call.method, result, ret, null);
        } catch(error) {
          hilog.error(0x0000, LinkSdkPlugin.TAG, 'sdk method: %{public}s returned with error: %{public}s', call.method, error.message);
          result.error("", "sdk method: " + call.method + " invoke error: " + error.message, null);
        }
        break;
      case "getRemainingPhotoNumber":
        try {
          let ret: LinkResult<Number> = await Link.getRemainingPhotoNumber();
          hilog.debug(0x0000, LinkSdkPlugin.TAG, 'sdk method: %{public}s, returned with code %{public}d', call.method, ret.code);
          await this.onChannelResult(call.method, result, ret, null);
        } catch(error) {
          hilog.error(0x0000, LinkSdkPlugin.TAG, 'sdk method: %{public}s returned with error: %{public}s', call.method, error.message);
          result.error("", "sdk method: " + call.method + " invoke error: " + error.message, null);
        }
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