import 'package:event_bus/event_bus.dart';

/// 点击 tab event
///
/// [event]
///  - index 点击的tab index
EventBus globalTabChangeEventBus = EventBus();

/// 选择对应的 tab 的 event
///
/// [event]
///  - index 目标选中的tab
EventBus globalSelectTabEventBus = EventBus();

/// 通知邮件是否重新请求最新状态
///
/// [event]
EventBus markMessageAsRead = EventBus();

/// ws 服务端推送过来的消息
///
/// [event]
EventBus wssNotifyEvents = EventBus();
