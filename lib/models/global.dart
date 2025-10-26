///
/* resetPassword - 重置密码
  inquireAccount - 找回账号
  playerLogin - 玩家登入
  setPhoneNumber - 初次设置手机号
  registration - 注册
  oldPhoneNumber - 修改电话时的电话验证（旧号码）
  newPhoneNumber - 修改电话时的电话验证（新号码）
  updatePassword - 更新密码
  updateBankInfo - 更新支付信息
  updateBankInfoFirst - 首次设置支付信息
  freeTrialReward - 免费体验金
  demoPlayer - 试玩帐号
  Partner_registration - 代理注册
  Partner_oldPhoneNumber - 代理电话号码（旧）
  Partner_newPhoneNumber - 代理电话号码（新）
  Partner_updatePassword - 代理更新密码
  Partner_updateBankInfoFirst - 代理银行卡（首次）
  Partner_updateBankInfo - 代理银行卡（更换）
  setEmail - 首次绑定邮箱
  newEmail - 更新邮箱
 */ //
enum CaptchaSence {
  playerLogin,
  registration,
  resetPassword,
  setPhoneNumber,
  oldPhoneNumber,
  playerChangeEmail,
  newPhoneNumber,
  updatePassword,
  updateBankInfo,
  updateBankInfoFirst,
  freeTrialReward,
  demoPlayer,
  Partner_registration,
  Partner_oldPhoneNumber,
  Partner_newPhoneNumber,
  Partner_updatePassword,
  Partner_updateBankInfoFirst,
  Partner_updateBankInfo,
  setEmail,
  newEmail
}
