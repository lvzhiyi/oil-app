import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:lottery_app/global/app_controller.dart';
import 'package:lottery_app/global/app_state.dart';
import 'package:lottery_app/global/model/agent_info_type.dart';
import 'package:lottery_app/global/model/user_profile_type.dart';
import 'package:lottery_app/pages/profile/widgets/agent_edit_dialog.dart';
import 'package:lottery_app/resources/colors.dart';
import 'package:lottery_app/resources/style.dart';
import 'package:lottery_app/utils/pt.dart';

class AgentInfoCard extends StatelessWidget {
  /// 用户资料信息
  final UserProfile? userProfile;

  const AgentInfoCard({
    Key? key,
    required this.userProfile,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppController, AppState>(
      builder: (context, state) {
        final agentInfo = state.agentInfo;
        if (agentInfo == null) return const SizedBox();

        return Container(
          width: double.infinity,
          margin: EdgeInsets.symmetric(horizontal: pt(20)),
          padding: EdgeInsets.all(pt(20)),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.primary,
                AppColors.mediumBlue,
              ],
            ),
            borderRadius: BorderRadius.circular(pt(16)),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.3),
                blurRadius: pt(20),
                offset: Offset(0, pt(8)),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: pt(30),
                    backgroundColor: Colors.white.withValues(alpha: 0.2),
                    child: Icon(
                      Icons.business,
                      size: pt(30),
                      color: Colors.white,
                    ),
                  ),
                  Gap(pt(16)),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '代理商',
                          style: SportsTextStyle.baseNormal.copyWith(
                            fontSize: pt(12),
                            color: Colors.white.withValues(alpha: 0.8),
                          ),
                        ),
                        Gap(pt(4)),
                        Text(
                          agentInfo.name,
                          style: SportsTextStyle.baseBold.copyWith(
                            fontSize: pt(18),
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (_canEditAgentInfo())
                    InkWell(
                      onTap: () => _showAgentEditDialog(context, agentInfo),
                      child: Container(
                        padding: EdgeInsets.all(pt(8)),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(pt(8)),
                        ),
                        child: Icon(
                          Icons.edit,
                          size: pt(16),
                          color: Colors.white,
                        ),
                      ),
                    ),
                ],
              ),
              Gap(pt(16)),
              Row(
                children: [
                  Expanded(
                    child: _buildInfoItem(
                      Icons.person,
                      '联系人',
                      agentInfo.contactName,
                    ),
                  ),
                  Gap(pt(16)),
                  Expanded(
                    child: _buildInfoItem(
                      Icons.phone,
                      '联系电话',
                      agentInfo.phone,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  /// 构建信息项
  Widget _buildInfoItem(IconData icon, String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              icon,
              size: pt(14),
              color: Colors.white.withValues(alpha: 0.7),
            ),
            Gap(pt(4)),
            Text(
              label,
              style: SportsTextStyle.baseNormal.copyWith(
                fontSize: pt(12),
                color: Colors.white.withValues(alpha: 0.7),
              ),
            ),
          ],
        ),
        Gap(pt(4)),
        Text(
          value,
          style: SportsTextStyle.baseBold.copyWith(
            fontSize: pt(14),
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  /// 检查是否可以编辑代理商信息
  bool _canEditAgentInfo() {
    return userProfile?.role == UserRole.owner;
  }

  /// 显示代理商信息编辑对话框
  void _showAgentEditDialog(BuildContext context, AgentInfo agentInfo) {
    showAgentEditDialog(
      context: context,
      agentInfo: agentInfo,
      onSave: (contactName, phone) async {
        // 这里需要调用API更新代理商信息
        await appController.updateAgentInfo(UpdateAgentInfoRequest(contactName: contactName, phone: phone));
      },
    );
  }
}
