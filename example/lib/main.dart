import 'dart:io';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:link_sdk/link_sdk.dart';
import 'package:sdk_core/sdk_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SdkCore.init("2025713681", "0985a99f25017534bf2c39323bf8b6ec4325c9c007f4de80eecac1e1eeab39e9");
  await SdkCore.initializeOnUserProtocolAgreed();
  await LinkSdk.init();

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    // We also handle the message potentially returning null.
    try {
      platformVersion = await LinkSdk.sdkVersion() ?? 'Unknown sdk version';
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Text('Running LinkSDK Example Version:\n $_platformVersion\n'),
        ),
      ),
    );
  }
}
