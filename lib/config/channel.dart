import 'dart:io';

enum AndroidChannel {
  oppo,

  vivo,

  xiaomi,

  transsion,

  huawei,

  samSung,

  googleAndriod,

  apk
}

enum IOSChannel { AppleIOS }

class ChannelConfig {
  static const Map<AndroidChannel, String> AFKeyAndroid = {
    AndroidChannel.oppo: 'mmAZfmWvdPhCcCeonjs9PT',
    AndroidChannel.vivo: 'PmQQMw5xa3vCWpTfCKoewC',
    AndroidChannel.xiaomi: 'bU72NsGJ3bs3JdRHAaahp9',
    AndroidChannel.transsion: 'aXdurhQvXr4rsG8KARucDJ',
    AndroidChannel.huawei: 'sVXQEt2f9xA9hFMCsLKg35',
    AndroidChannel.samSung: 'ZzcXJWoypza95aAoZKUVcR',
    AndroidChannel.googleAndriod: 'XcHtkPvoQqUV45oWj7iK4X',
    AndroidChannel.apk: '2WSqzz7D6gjfbohBvC428o',
  };
  static const Map<IOSChannel, String> AFKeyIOS = {
    IOSChannel.AppleIOS: 'yux4EzuSzohgx3qPWuVpc3'
  };

  static const Map<AndroidChannel, String> PartnerIdAndroid = {
    AndroidChannel.oppo: '1000026181',
    AndroidChannel.vivo: '1000026182',
    AndroidChannel.xiaomi: '1000026183',
    AndroidChannel.transsion: '1000026184',
    AndroidChannel.huawei: '1000026185',
    AndroidChannel.samSung: '1000026186',
    AndroidChannel.googleAndriod: '1000026187',
    AndroidChannel.apk: '1000026189',
  };
  static const Map<IOSChannel, String> PartnerIdIOS = {
    IOSChannel.AppleIOS: '1000026188'
  };

  static AndroidChannel? parseAndroidChannel(String channel) {
    return AndroidChannel.values.firstWhere(
      (e) {
        print(e.toString());
        return e.toString().split('.').last.toLowerCase() ==
            channel.toLowerCase();
      },
      orElse: () => AndroidChannel.apk, // 返回 null 或者抛出异常
    );
  }

  static String androidChannelString =
      const String.fromEnvironment('ANDROID_CHANNEL', defaultValue: 'apk');

  static getAfKey() {
    if (Platform.isIOS) {
      return AFKeyIOS[IOSChannel.AppleIOS];
    }

    AndroidChannel? androidChannel = parseAndroidChannel(androidChannelString);

    return AFKeyAndroid[androidChannel];
  }

  static getPartnerId() {
    if (Platform.isIOS) {
      return PartnerIdIOS[IOSChannel.AppleIOS];
    }

    AndroidChannel? androidChannel = parseAndroidChannel(androidChannelString);

    return PartnerIdAndroid[androidChannel];
  }
}
