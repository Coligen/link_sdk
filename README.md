## LinkSDK-Flutter平台插件
</br>
集成此业务插件前，需要先集成基础认证插件：[SDKCore](https://github.com/Coligen/sdk_core.git)。

</br>

### 仓库说明
本仓库是基于各原生平台的LinkSDK模块，最终对接Flutter平台的插件实现，同时提供了简单的example供开发者参考。

</br>

### 平台支持
目前已完成插件对接的平台如下：

- Android。对应仓库中的android目录。
- Harmony。对应仓库中的ohos目录。

若有需要，开发者可参考Android和Harmony平台，自行实现iOS平台的插件代码。

</br>

### 接口列表
Flutter平台的插件接口与原生平台的接口保持一致(即接口名称、参数列表、返回值类型均保持一致)，请参考原生平台SDK接口文档。

Flutter插件接口文档尚在完善中......

</br>

### 集成方式
本目前仅支持git仓库源码方式集成，开发者可在Flutter工程pubspec.yaml文件的dependencies节点下添加配置：
```yaml
link_sdk:
    git:
      url: https://github.com/Coligen/link_sdk.git
      ref: main
```

添加后保存文件，Flutter会自动去更新依赖，若没有自动更新，开发者可自行在终端中执行 flutter pub get 触发更新。

</br>

### 调用示例
开发者确认插件集成、授权配置无误后，即可在Flutter项目中调用接口进行初始化工作了，我们推荐在main函数中调用，示例如下：
```dart
// 确保插件已初始化完成
WidgetsFlutterBinding.ensureInitialized();

// SDKCore认证插件初始化逻辑,可参考对应仓库说明
await SdkCore.init("2025713681", "0985a99f25017534bf2c39323bf8b6ec4325c9c007f4de80eecac1e1eeab39e9");
await SdkCore.initializeOnUserProtocolAgreed();

// LinkSDK初始化,
await LinkSdk.init();
```

相关参考可在仓库的example/lib/main.dart中找到。

