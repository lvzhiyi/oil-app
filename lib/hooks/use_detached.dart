import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

enum LifeCycleType {
  detached, //应用或组件销毁
  paused, //应用切到后台
  resumed, //应用切到前台
}

typedef LifeCycleFunc = void Function(LifeCycleType type);
typedef DisposeFunc = void Function();

/// hooks 不能与 BaseState 同时使用
/// 兼容 hooks 的销毁操作
void useDetached(DisposeFunc dispose, List<Object?> keys,
    [LifeCycleFunc? lifeChange]) {
  // 组件生命周期销毁触发
  useEffect((() {
    return dispose;
  }), keys);

  void _lifeChange(LifeCycleType type) {
    if (lifeChange != null) {
      lifeChange(type);
    }
  }

  useOnAppLifecycleStateChange(((previous, current) {
    switch (current) {
      case AppLifecycleState.inactive:
        break;

      // 应用切到后台触发
      case AppLifecycleState.paused:
        _lifeChange(LifeCycleType.paused);
        break;

      // 应用切到前台触发
      case AppLifecycleState.resumed:
        _lifeChange(LifeCycleType.resumed);
        break;

      // 应用销毁时触发
      case AppLifecycleState.detached:
        _lifeChange(LifeCycleType.detached);
        dispose();
        break;
      case AppLifecycleState.hidden:
        break;
    }
  }));
}
