/// 定义提示频率常量的类。
/// 该类用于定义与提示显示频率相关的常量，可以用来控制应用中提示的显示方式。
class TipFrequencyNum {
  /// 从不显示提示, 值为-2。
  /// 当提示不应显示时使用。
  static const int NEVER_SHOW = -2;

  /// 仅在首次启动应用时显示提示 , 值为-1。
  /// 当应用首次启动时显示提示时使用。
  static const int SHOW_ON_FIRST_LAUNCH = -1;

  /// 每次启动应用时显示提示,值为0。
  /// 每次启动应用时显示提示时使用。
  static const int SHOW_EVERY_LAUNCH = 0;
}

/// 定义升级类型常量的类。
/// 该类用于定义不同的应用升级类型，帮助控制升级行为。
class UpgradeType {
  /// 强制更新，值为1。
  /// 要求用户在继续使用应用之前必须更新应用。
  static const int Forced_Update = 1;

  /// 强提示更新，值为2。
  /// 强烈建议用户更新应用，但允许不更新继续使用。
  static const int Strong_Prompt_Update = 2;

  /// 弱提示更新，值为3。
  /// 建议用户更新应用，但不强烈要求。
  static const int Weak_Prompt_Update = 3;

  /// 无提示更新,值为4。
  /// 更新应用时不显示任何提示。
  static const int Update_Without_Prompting = 4;
}
