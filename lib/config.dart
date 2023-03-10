import 'package:flutter/material.dart';
import 'package:screen_retriever/screen_retriever.dart';
import 'package:window_manager/window_manager.dart';
import 'package:windows_single_instance/windows_single_instance.dart';

class Config {
  static double relHeight = 300;
  static Future initWindow(List<String> args, {Size? screenSize}) async {
    // 获取屏幕真实大小
    Display primaryDisplay = await screenRetriever.getPrimaryDisplay();
    relHeight = primaryDisplay.size.height * 0.15;
    double relWidth = relHeight;
    final displaySize = Size(relWidth, relHeight);
    await setSingleInstance(args);
    WindowManager w = WindowManager.instance;
    await w.ensureInitialized();
    WindowOptions windowOptions = WindowOptions(
        size: displaySize,
        minimumSize: displaySize,
        alwaysOnTop: true, // 设置置顶
        titleBarStyle: TitleBarStyle.hidden, // 去除窗口标题栏
        skipTaskbar: true // 去除状态栏图标
        );
    w.waitUntilReadyToShow(windowOptions, () async {
      double w1 = primaryDisplay.size.width - 100;
      await w.setBackgroundColor(Colors.transparent);
      await w.setPosition(Offset(w1 - relWidth, primaryDisplay.size.height - relHeight - 100)); // 位置居中
      await w.show();
      await w.focus();
      await w.setAsFrameless();
    });
  }

  /// windows设置单实例启动
  static setSingleInstance(List<String> args) async {
    await WindowsSingleInstance.ensureSingleInstance(args, "desktop_open", onSecondWindow: (args) async {
      // 唤起并聚焦
      if (await windowManager.isMinimized()) await windowManager.restore();
      windowManager.focus();
    });
  }
}
