package mobile.open.plugin.link_sdk;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.os.Build;
import android.util.Log;

import androidx.annotation.NonNull;

import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;

import java.lang.reflect.Method;
import java.lang.reflect.ParameterizedType;
import java.lang.reflect.Type;
import java.util.Arrays;
import java.util.List;
import java.util.function.Function;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import mobile.open.sdk.link.Link;
import mobile.open.sdk.link.LinkFile;
import mobile.open.sdk.link.LinkMenu;
import mobile.open.sdk.link.LinkProgressCallback;
import mobile.open.sdk.link.LinkResult;
import mobile.open.sdk.link.LinkSoftwareVersion;
import mobile.open.sdk.link.LinkSpace;
import mobile.open.sdk.link.LinkStreamUrl;

/**
 * LinkSdkPlugin
 */
public class LinkSdkPlugin implements FlutterPlugin, MethodCallHandler, EventChannel.StreamHandler {
    private static final String TAG = "LinkSDKPlugin";
    private static final String CHANNEL_LINKSDK = "mobile.open.sdk/linksdk";
    private static final String CHANNEL_LINKSDK_EVENT = "mobile.open.sdk/linksdk/event";

    private Context context;
    private MethodChannel methodChannel;
    private EventChannel eventChannel;
    private EventChannel.EventSink eventSink;
    private final Gson gson = new Gson();

    @Override
    public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
        context = flutterPluginBinding.getApplicationContext();

        methodChannel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), CHANNEL_LINKSDK);
        methodChannel.setMethodCallHandler(this);

        eventChannel = new EventChannel(flutterPluginBinding.getBinaryMessenger(), CHANNEL_LINKSDK_EVENT);
        eventChannel.setStreamHandler(this);

        registerEventReceiver();
    }

    private void onChannelResult(String methodName, Method method, Object result, Result channelCb) {
        if (result == null) {
            Log.e(TAG, "link call: " + methodName + ", return result of null");
            channelCb.error("", "sdk return result of null", null);
            return;
        }

        if (method.getReturnType().equals(LinkResult.class)) {
            //剥出第一层泛型包装: LinkResult<Type>
            Type type = method.getGenericReturnType();
            if (!(type instanceof ParameterizedType)) {
                Log.e(TAG, "link call: " + methodName + ", unexpected return type");
                channelCb.error("", "unexpected return type", null);
                return;
            }

            //获取第一层泛型包装中的实际类型
            Type[] actualTypeArgs = ((ParameterizedType) type).getActualTypeArguments();
            if (actualTypeArgs.length == 0) {
                Log.e(TAG, "link call: " + methodName + ", can not find real parameterized type");
                channelCb.error("", "can not find real parameterized type", null);
                return;
            }

            Type actualTypeArg = actualTypeArgs[0];
            if (actualTypeArg instanceof ParameterizedType) {
                if (((ParameterizedType) actualTypeArg).getRawType() != List.class) {
                    Log.e(TAG, "link call: " + methodName + ", unexpected parameterized type");
                    //第一层泛型的实际类型是非List类型,SDK目前没有此类型的返回值
                    channelCb.error("", "unexpected parameterized type", null);
                    return;
                }

                //剥出第二层泛型(List)中的实际类型
                Type[] nestedType = ((ParameterizedType) actualTypeArg).getActualTypeArguments();
                if (nestedType.length == 0) {
                    Log.e(TAG, "link call: " + methodName + ", can not find real nested parameterized type");
                    channelCb.error("", "can not find real nested parameterized type", null);
                    return;
                }

                Type actualNestedTypeArg = nestedType[0];
                if (actualNestedTypeArg == Integer.class) {
                    LinkResult<List<Integer>> dirRet = (LinkResult<List<Integer>>) result;
                    String jsonRet = gson.toJson(dirRet, new TypeToken<LinkResult<List<Integer>>>() {
                    }.getType());
                    channelCb.success(jsonRet);
                } else if (actualNestedTypeArg == LinkMenu.class) {
                    LinkResult<List<LinkMenu>> spaceRet = (LinkResult<List<LinkMenu>>) result;
                    String jsonRet = gson.toJson(spaceRet, new TypeToken<LinkResult<List<LinkMenu>>>() {
                    }.getType());
                    channelCb.success(jsonRet);
                } else if (actualNestedTypeArg == LinkStreamUrl.class) {
                    LinkResult<List<LinkStreamUrl>> streamUrlRet = (LinkResult<List<LinkStreamUrl>>) result;
                    String jsonRet = gson.toJson(streamUrlRet, new TypeToken<LinkResult<List<LinkStreamUrl>>>() {
                    }.getType());
                    channelCb.success(jsonRet);
                } else if (actualNestedTypeArg == LinkFile.class) {
                    LinkResult<List<LinkFile>> fileRet = (LinkResult<List<LinkFile>>) result;
                    String jsonRet = gson.toJson(fileRet, new TypeToken<LinkResult<List<LinkFile>>>() {
                    }.getType());
                    channelCb.success(jsonRet);
                } else {
                    Log.e(TAG, "link call: " + methodName + ", unexpected nested parameterized type");
                    //第二层泛型的实际类型是其他泛型包装,不处理
                    channelCb.error("", "unexpected nested parameterized type", null);
                }
            } else if (actualTypeArg == Void.class) {
                LinkResult<Void> voidRet = (LinkResult<Void>) result;
                String jsonRet = gson.toJson(voidRet, new TypeToken<LinkResult<Void>>() {
                }.getType());
                channelCb.success(jsonRet);
            } else if (actualTypeArg == Boolean.class) {
                LinkResult<Boolean> boolRet = (LinkResult<Boolean>) result;
                String jsonRet = gson.toJson(boolRet, new TypeToken<LinkResult<Boolean>>() {
                }.getType());
                channelCb.success(jsonRet);
            } else if (actualTypeArg == Integer.class) {
                LinkResult<Integer> intRet = (LinkResult<Integer>) result;
                String jsonRet = gson.toJson(intRet, new TypeToken<LinkResult<Integer>>() {
                }.getType());
                channelCb.success(jsonRet);
            } else if (actualTypeArg == String.class) {
                LinkResult<String> stringRet = (LinkResult<String>) result;
                String jsonRet = gson.toJson(stringRet, new TypeToken<LinkResult<String>>() {
                }.getType());
                channelCb.success(jsonRet);
            } else if (actualTypeArg == LinkSpace.class) {
                LinkResult<LinkSpace> spaceRet = (LinkResult<LinkSpace>) result;
                String jsonRet = gson.toJson(spaceRet, new TypeToken<LinkResult<LinkSpace>>() {
                }.getType());
                channelCb.success(jsonRet);
            } else if (actualTypeArg == LinkSoftwareVersion.class) {
                LinkResult<LinkSoftwareVersion> swVersionRet = (LinkResult<LinkSoftwareVersion>) result;
                String jsonRet = gson.toJson(swVersionRet, new TypeToken<LinkResult<LinkSoftwareVersion>>() {
                }.getType());
                channelCb.success(jsonRet);
            } else {
                Log.e(TAG, "link call: " + methodName + ", unexpected return type");
                //第一层泛型的实际类型是其他泛型包装,不处理
                channelCb.error("", "unexpected return type", null);
            }
        } else if (method.getReturnType().equals(Void.class)) {
            channelCb.success(0);
        } else if (method.getReturnType().equals(String.class)) {
            channelCb.success(result);
        } else {
            Log.d(TAG, "invoke method " + methodName + ", unknown return type");
            //LinkSDK中暂时未用到的返回值类型
            channelCb.error("", "unexpected return type", null);
        }
    }

    private void invokeAsyncMethod(String methodName, Class<?>[] paramTypes, Object[] params, Result channelCb) {
        try {
            Method method = Link.class.getMethod(methodName, paramTypes);
            Object ret = method.invoke(Link.getInstance(), params);

            onChannelResult(methodName, method, ret, channelCb);
        } catch (Exception e) {
            Log.e(TAG, "link call: " + methodName + ", error: " + e);
            channelCb.error("", "sdk method: " + methodName + " invoke error", e.getMessage());
        }
    }

    private final LinkProgressCallback linkProgressCallback = (v, v1, v2, v3) -> {
        LinkEvent<LinkProgressData> event = new LinkEvent<>();
        event.type = LinkEvent.TYPE_PROGRESS;
        event.payload = new LinkProgressData(v, v1, v2, v3);

        eventSink.success(gson.toJson(event, new TypeToken<LinkEvent<LinkProgressData>>() {
        }.getType()));
    };

    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
        switch (call.method) {
            case "init":
                Link.getInstance().init(context);
                Link.getInstance().setProgressCallback(linkProgressCallback);
                result.success(0);
                break;
            case "configNetChannel":
                invokeAsyncMethod(call.method, null, null, result);
                break;
            case "clearNetChannelConfig":
                invokeAsyncMethod(call.method, null, null, result);
                break;
            case "connect":
                invokeAsyncMethod(call.method, null, null, result);
                break;
            case "heartbeatOn":
                Link.getInstance().heartbeatOn();
                result.success(0);
                break;
            case "setHeartbeatInterval":
                int second = call.argument("second");
                Link.getInstance().setHeartbeatInterval(second);
                result.success(0);
                break;
            case "heartbeatOff":
                Link.getInstance().heartbeatOff();
                result.success(0);
                break;
            case "getStreamUrl":
                invokeAsyncMethod(call.method, null, null, result);
                break;
            case "isPhotoModeSupported":
                invokeAsyncMethod(call.method, null, null, result);
                break;
            case "shouldShowRTMapTracks":
                invokeAsyncMethod(call.method, null, null, result);
                break;
            case "getWorkMode":
                invokeAsyncMethod(call.method, null, null, result);
                break;
            case "setWorkMode":
                int workMode = call.argument("workMode");
                invokeAsyncMethod(call.method, new Class[]{int.class}, new Object[]{workMode}, result);
                break;
            case "getVideoRecState":
                invokeAsyncMethod(call.method, null, null, result);
                break;
            case "setVideoRecState":
                int flag = call.argument("flag");
                invokeAsyncMethod(call.method, new Class[]{int.class}, new Object[]{flag}, result);
                break;
            case "getVideoRecTime":
                invokeAsyncMethod(call.method, null, null, result);
                break;
            case "takePhoto":
                invokeAsyncMethod(call.method, null, null, result);
                break;
            case "snapshot":
                invokeAsyncMethod(call.method, null, null, result);
                break;
            case "getMenu":
                boolean clearCache = call.argument("clearCache");
                invokeAsyncMethod(call.method, new Class[]{boolean.class}, new Object[]{clearCache}, result);
                break;
            case "getMenuState":
                int cmd = call.argument("cmd");
                invokeAsyncMethod(call.method, new Class[]{int.class}, new Object[]{cmd}, result);
                break;
            case "setMenuState":
                int cmd1 = call.argument("cmd");
                String option = call.argument("option");
                invokeAsyncMethod(call.method, new Class[]{int.class, String.class}, new Object[]{cmd1, option}, result);
                break;
            case "setMenuMultipleState":
                result.notImplemented();
                break;
            case "isMultipleStorageSupported":
                invokeAsyncMethod(call.method, null, null, result);
                break;
            case "isStorageSelectSupported":
                invokeAsyncMethod(call.method, null, null, result);
                break;
            case "storageSelect":
                int type = call.argument("type");
                invokeAsyncMethod(call.method, new Class[]{int.class}, new Object[]{type}, result);
                break;
            case "getFileDir":
                invokeAsyncMethod(call.method, null, null, result);
                break;
            case "getFileList":
                int type1 = call.argument("type");
                int from = call.argument("from");
                int count = call.argument("count");
                invokeAsyncMethod(call.method, new Class[]{int.class, int.class, int.class}, new Object[]{type1, from, count}, result);
                break;
            case "deleteFile":
                String extra = call.argument("extra");
                invokeAsyncMethod(call.method, new Class[]{String.class}, new Object[]{extra}, result);
                break;
            case "getFileCopyState":
                invokeAsyncMethod(call.method, null, null, result);
                break;
            case "copyFile":
                String extra1 = call.argument("extra");
                invokeAsyncMethod(call.method, new Class[]{String.class}, new Object[]{extra1}, result);
                break;
            case "getFileCopyProgress":
                invokeAsyncMethod(call.method, null, null, result);
                break;
            case "stopFileCopy":
                invokeAsyncMethod(call.method, null, null, result);
                break;
            case "getExternalStorageState":
                invokeAsyncMethod(call.method, null, null, result);
                break;
            case "shouldShowExternalStorageSpace":
                invokeAsyncMethod(call.method, null, null, result);
                break;
            case "getStorageSpace":
                int type2 = call.argument("type");
                invokeAsyncMethod(call.method, new Class[]{int.class}, new Object[]{type2}, result);
                break;
            case "isInternalStorageFormatSupported":
                invokeAsyncMethod(call.method, null, null, result);
                break;
            case "storageFormat":
                int type3 = call.argument("type");
                invokeAsyncMethod(call.method, new Class[]{int.class}, new Object[]{type3}, result);
                break;
            case "isFileGPSInfoSupported":
                invokeAsyncMethod(call.method, null, null, result);
                break;
            case "getFileGPSInfo":
                String extra2 = call.argument("extra");
                invokeAsyncMethod(call.method, new Class[]{String.class}, new Object[]{extra2}, result);
                break;
            case "timeSync":
                invokeAsyncMethod(call.method, null, null, result);
                break;
            case "getWiFiSSID":
                invokeAsyncMethod(call.method, null, null, result);
                break;
            case "getWiFiSSIDFromDevice":
                invokeAsyncMethod(call.method, null, null, result);
                break;
            case "setWiFiSSID":
                String ssid = call.argument("ssid");
                invokeAsyncMethod(call.method, new Class[]{String.class}, new Object[]{ssid}, result);
                break;
            case "getWiFiPassword":
                invokeAsyncMethod(call.method, null, null, result);
                break;
            case "setWiFiPassword":
                String pwd = call.argument("pwd");
                invokeAsyncMethod(call.method, new Class[]{String.class}, new Object[]{pwd}, result);
                break;
            case "systemReset":
                invokeAsyncMethod(call.method, null, null, result);
                break;
            case "systemVersion":
                int type4 = call.argument("type");
                invokeAsyncMethod(call.method, new Class[]{int.class}, new Object[]{type4}, result);
                break;
            case "getBatteryState":
                invokeAsyncMethod(call.method, null, null, result);
                break;
            case "setPIRInterval":
                int interval = call.argument("interval");
                invokeAsyncMethod(call.method, new Class[]{int.class}, new Object[]{interval}, result);
                break;
            case "setPIRMonitoringPeriodTime":
                int index = call.argument("index");
                String begin = call.argument("begin");
                String end = call.argument("end");
                invokeAsyncMethod(call.method, new Class[]{int.class, String.class, String.class}, new Object[]{index, begin, end}, result);
                break;
            case "getOTASupportState":
                invokeAsyncMethod(call.method, null, null, result);
                break;
            case "getSoftwareVersion":
                int type5 = call.argument("type");
                invokeAsyncMethod(call.method, new Class[]{int.class}, new Object[]{type5}, result);
                break;
            case "sendUpgradeFile":
                int type6 = call.argument("type");
                String filePath = call.argument("filePath");
                invokeAsyncMethod(call.method, new Class[]{int.class, String.class}, new Object[]{type6, filePath}, result);
                break;
            case "softwareUpdate":
                int type7 = call.argument("type");
                String filePath1 = call.argument("filePath");
                invokeAsyncMethod(call.method, new Class[]{int.class, String.class}, new Object[]{type7, filePath1}, result);
                break;
            case "recLock":
                invokeAsyncMethod(call.method, null, null, result);
                break;
            case "changeFileLockState":
                String extra3 = call.argument("extra");
                invokeAsyncMethod(call.method, new Class[]{String.class}, new Object[]{extra3}, result);
                break;
            case "getCameraState":
                String index1 = call.argument("index");
                invokeAsyncMethod(call.method, new Class[]{int.class}, new Object[]{index1}, result);
                break;
            case "getChipId":
                invokeAsyncMethod(call.method, null, null, result);
                break;
            case "getConnectionType":
                invokeAsyncMethod(call.method, null, null, result);
                break;
            case "getConnectionState":
                invokeAsyncMethod(call.method, null, null, result);
                break;
            case "checkCapability":
                int type8 = call.argument("type");
                invokeAsyncMethod(call.method, new Class[]{int.class}, new Object[]{type8}, result);
                break;
            case "getRemainingRecTime":
                invokeAsyncMethod(call.method, null, null, result);
                break;
            case "getRemainingPhotoNumber":
                invokeAsyncMethod(call.method, null, null, result);
                break;
            case "disconnect":
                Link.getInstance().disconnect();
                result.success(0);
                break;
            case "sdkVersion":
                invokeAsyncMethod(call.method, null, null, result);
                break;
            default:
                result.notImplemented();
                break;
        }
    }

    @Override
    public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
        methodChannel.setMethodCallHandler(null);
        eventChannel.setStreamHandler(null);

        unregisterEventReceiver();

        context = null;
    }

    @Override
    public void onListen(Object arguments, EventChannel.EventSink events) {
        eventSink = events;
    }

    @Override
    public void onCancel(Object arguments) {
        eventSink = null;
    }

    private final BroadcastReceiver sdkEventReceiver = new BroadcastReceiver() {
        @Override
        public void onReceive(Context context, Intent intent) {
            if (null == intent) {
                return;
            }

            if (Link.Action.CONNECTION_STATE.equals(intent.getAction())) {
                //LinkSDK协议层连接状态处理

                int connState = intent.getIntExtra(Link.Extra.CONNECTION_STATE, -1);

                if (connState != -1) {
                    LinkEvent<LinkConnectionStateData> event = new LinkEvent<>();
                    event.type = LinkEvent.TYPE_CONNECTION_STATE;
                    event.payload = new LinkConnectionStateData(connState);

                    eventSink.success(gson.toJson(event, new TypeToken<LinkEvent<LinkConnectionStateData>>() {
                    }.getType()));
                }
            } else if (Link.Action.NOTIFY.equals(intent.getAction())) {
                //LinkSDK通过WiFi连接设备后,设备端主动发送的通知消息处理

                int notifyCode = intent.getIntExtra(Link.Extra.NOTIFY_CODE, -1);
                String notifyData = intent.getStringExtra(Link.Extra.NOTIFY_DATA);

                if (notifyCode != -1) {
                    LinkEvent<LinkNotifyData> event = new LinkEvent<>();
                    event.type = LinkEvent.TYPE_NOTIFY;
                    event.payload = new LinkNotifyData(notifyCode, notifyData);

                    eventSink.success(gson.toJson(event, new TypeToken<LinkEvent<LinkNotifyData>>() {
                    }.getType()));
                }
            } else {

            }
        }
    };

    private void registerEventReceiver() {
        try {
            IntentFilter intentFilter = new IntentFilter();
            intentFilter.addAction(Link.Action.NOTIFY);
            intentFilter.addAction(Link.Action.CONNECTION_STATE);
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
                context.registerReceiver(sdkEventReceiver, intentFilter, Context.RECEIVER_EXPORTED);
            } else {
                context.registerReceiver(sdkEventReceiver, intentFilter);
            }
        } catch (Exception e) {
            Log.e(TAG, "register sdk event receiver failed: " + e);
        }
    }

    private void unregisterEventReceiver() {
        try {
            context.unregisterReceiver(sdkEventReceiver);
        } catch (Exception e) {
            Log.e(TAG, "unregister sdk event receiver failed: " + e);
        }
    }

    private static class LinkEvent<T> {
        /**
         * 连接状态变化事件
         */
        static final int TYPE_CONNECTION_STATE = 0;

        /**
         * 设备通知事件
         */
        static final int TYPE_NOTIFY = 1;

        /**
         * 上传/下载进度变化事件
         */
        static final int TYPE_PROGRESS = 2;

        private int type;
        private T payload;

        public T getPayload() {
            return payload;
        }

        public void setPayload(T payload) {
            this.payload = payload;
        }

        public int getType() {
            return type;
        }

        public void setType(int type) {
            this.type = type;
        }

        @Override
        public String toString() {
            return "LinkEvent{" +
                    "payload=" + payload +
                    ", type=" + type +
                    '}';
        }
    }

    private static class LinkConnectionStateData {
        private int state;

        public LinkConnectionStateData(int state) {
            this.state = state;
        }

        public int getState() {
            return state;
        }

        public void setState(int state) {
            this.state = state;
        }

        @Override
        public String toString() {
            return "LinkConnectionStateData{" +
                    "state=" + state +
                    '}';
        }
    }

    private static class LinkNotifyData {
        private int code;
        private String data;

        public LinkNotifyData(int code, String data) {
            this.code = code;
            this.data = data;
        }

        public int getCode() {
            return code;
        }

        public void setCode(int code) {
            this.code = code;
        }

        public String getData() {
            return data;
        }

        public void setData(String data) {
            this.data = data;
        }

        @Override
        public String toString() {
            return "LinkNotifyData{" +
                    "code=" + code +
                    ", data='" + data + '\'' +
                    '}';
        }
    }

    private static class LinkProgressData {
        private double dlTotal;
        private double dlNow;
        private double ulTotal;
        private double ulNow;

        public LinkProgressData(double dlNow, double dlTotal, double ulNow, double ulTotal) {
            this.dlNow = dlNow;
            this.dlTotal = dlTotal;
            this.ulNow = ulNow;
            this.ulTotal = ulTotal;
        }

        public double getDlNow() {
            return dlNow;
        }

        public void setDlNow(double dlNow) {
            this.dlNow = dlNow;
        }

        public double getDlTotal() {
            return dlTotal;
        }

        public void setDlTotal(double dlTotal) {
            this.dlTotal = dlTotal;
        }

        public double getUlNow() {
            return ulNow;
        }

        public void setUlNow(double ulNow) {
            this.ulNow = ulNow;
        }

        public double getUlTotal() {
            return ulTotal;
        }

        public void setUlTotal(double ulTotal) {
            this.ulTotal = ulTotal;
        }

        @Override
        public String toString() {
            return "LinkProgressData{" +
                    "dlNow=" + dlNow +
                    ", dlTotal=" + dlTotal +
                    ", ulTotal=" + ulTotal +
                    ", ulNow=" + ulNow +
                    '}';
        }
    }
}
