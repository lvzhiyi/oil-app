/// 单例模式的内存存储类，用于保存临时数据
class _GlobalMemoryStore {
  // 私有构造函数的实例，用于实现单例模式
  static final _GlobalMemoryStore _instance = _GlobalMemoryStore._internal();

  /// 工厂构造函数，返回单例实例
  factory _GlobalMemoryStore() => _instance;

  // 私有构造函数，防止外部实例化
  _GlobalMemoryStore._internal();

  /// 保存用户上次选择的天数
  String? lastSelectedDays;
}

/// 定义一个全局内存存储实例，用于在整个应用中共享数据
final globalMemoryStore = _GlobalMemoryStore();
