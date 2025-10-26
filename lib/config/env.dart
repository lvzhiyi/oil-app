enum HttpEnv {
  /// 正式
  pro(1, 'pro'),

  /// 测试
  qa(3, 'qa');

  const HttpEnv(this.value, this.name);

  final int value;

  final String name;

  static HttpEnv mapEnv(int val) => HttpEnv.values.firstWhere(
        (element) => element.value == val,
        orElse: () => HttpEnv.pro,
      );

  static HttpEnv mapEnvName(String val) => HttpEnv.values.firstWhere(
        (element) => element.name == val,
        orElse: () => HttpEnv.pro,
      );
}
