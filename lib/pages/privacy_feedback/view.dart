import 'package:flutter/material.dart';
import 'package:oil_business_app/resources/colors.dart';
import 'package:oil_business_app/utils/sizer_utils.dart';
import 'package:oil_business_app/widgets/base/text/common_text.dart';
import 'state.dart';

class PrivacyFeedbackView extends StatelessWidget {
  final PrivacyFeedbackState state;

  const PrivacyFeedbackView({Key? key, required this.state}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomAppColor.of(context).bgScaffold,
      appBar: AppBar(
        backgroundColor: CustomAppColor.of(context).bgTopBar,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: CustomAppColor.of(context).txtBlack),
        title: CommonText(
          text: '隐私政策',
          fontSize: AppSizes.setFontSize(18),
          fontWeight: FontWeight.w600,
          textColor: CustomAppColor.of(context).txtBlack,
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(AppSizes.setWidth(16)),
        child: CommonText(
          text: '''
隐私政策

生效日期：2023年10月1日

欢迎您使用“买油呗”！我们非常重视您的隐私保护和个人信息安全。本隐私政策旨在帮助您了解我们如何收集、使用、存储和保护您的个人信息。

1. 我们如何收集您的信息
为了向您提供更好的服务，我们可能会收集以下类型的信息：
- 账号信息：包括您的手机号码、用户名等。
- 交易信息：包括您的订单记录、支付信息等。
- 设备信息：包括您的设备型号、操作系统版本等。

2. 我们如何使用您的信息
我们将收集的信息用于以下用途：
- 提供、维护和改进我们的服务。
- 处理您的订单和支付。
- 向您发送重要的通知和更新。
- 保障您的账号安全。

3. 信息共享与披露
我们不会向任何第三方出售您的个人信息。我们仅在以下情况下共享您的信息：
- 获得您的明确同意。
- 根据法律法规的要求。
- 为了保护我们的合法权益。

4. 信息安全
我们采取合理的安全措施来保护您的个人信息，防止未经授权的访问、使用或泄露。

5. 您的权利
您有权访问、更正或删除您的个人信息。您也可以随时联系我们注销您的账号。

6. 联系我们
如果您对本隐私政策有任何疑问或建议，请通过以下方式联系我们：
邮箱：support@oilbusiness.com

感谢您信任并使用“买油呗”！
''',
          fontSize: AppSizes.setFontSize(14),
          textColor: CustomAppColor.of(context).txtBlack,
          maxLines: 1000,
          textAlign: TextAlign.start,
        ),
      ),
    );
  }
}