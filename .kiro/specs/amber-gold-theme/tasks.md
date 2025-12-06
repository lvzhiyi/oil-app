# Implementation Plan

## 琥珀金主题色彩系统重构

- [x] 1. 更新核心颜色定义文件
  - [x] 1.1 在 AppColor 类中添加新的语义化颜色常量
    - 添加 primaryColor (#D97706)、secondaryColor (#FFFBEB)、accentColor (#F59E0B)
    - 添加 primaryLight、primaryDark、secondaryLight 等变体色
    - _Requirements: 1.1, 1.2, 1.3, 1.4_
  - [x] 1.2 更新 AppColor 中的 legacy 颜色别名
    - 将 btnPurple 改为指向 primaryColor
    - 将 txtPurple 改为指向 accentColor
    - 将 borderPurple 改为指向 primaryColor
    - 将 icPurple 改为指向 accentColor
    - _Requirements: 5.1, 5.2, 5.3, 5.4_
  - [x] 1.3 编写颜色常量单元测试
    - **Property 3: Theme color value correctness**
    - **Validates: Requirements 1.1, 1.2, 1.3**
    - 验证所有颜色常量的十六进制值正确

- [x] 2. 更新 CustomAppColor 主题适配类
  - [x] 2.1 添加新的语义化颜色 getter
    - 添加 primaryColor、secondaryColor、accentColor getter
    - 确保在 light/dark 模式下返回正确的颜色
    - _Requirements: 1.4, 6.1, 6.2, 6.3_
  - [x] 2.2 更新 bgScaffold 返回新的背景色
    - light 模式返回 secondaryColor (#FFFBEB)
    - _Requirements: 3.1_
  - [x] 2.3 编写 legacy 颜色别名属性测试
    - **Property 1: Legacy color alias consistency**
    - **Validates: Requirements 5.1, 5.2, 5.3, 5.4, 6.4**
    - 验证 btnPurple、txtPurple、borderPurple、icPurple 返回正确的新颜色

- [x] 3. Checkpoint - 确保核心颜色定义测试通过
  - All tests pass ✓

- [x] 4. 更新基础 UI 组件
  - [x] 4.1 更新 CommonButton 组件
    - 确保使用 primaryColor 作为默认背景色
    - 更新阴影颜色为 primaryColor
    - _Requirements: 2.1, 2.2, 2.3, 2.4_
  - [x] 4.2 编写按钮颜色属性测试
    - **Property 2: Primary button color consistency**
    - **Validates: Requirements 2.1**
  - [x] 4.3 更新 CommonTextFormField 组件
    - 更新焦点边框颜色引用 (通过 legacy alias 自动更新)
    - 更新阴影颜色引用
    - _Requirements: 5.3_
  - [x] 4.4 更新 CommonImgUpload 组件
    - 更新焦点标签颜色
    - 更新编辑图标和文字颜色
    - 添加 Loading 动画颜色为 primaryColor
    - _Requirements: 5.3, 5.4_
  - [x] 4.5 更新 CommonCityPicker 组件
    - 更新焦点边框颜色
    - 更新确认按钮文字颜色为 primaryColor
    - _Requirements: 5.3_
  - [x] 4.6 更新 CustomToggle 组件
    - 更新选中背景色为 primaryColor
    - 更新未选中文字颜色为 accentColor
    - 更新容器背景色为 primaryColor.withOpacity(0.1)
    - _Requirements: 5.1, 5.2_

- [x] 5. 更新其他通用组件
  - [x] 5.1 更新 CommonDialog 和 HtmlWebviewContainer
    - 更新 Loading 动画颜色为 primaryColor (通过 legacy alias 自动更新)
    - _Requirements: 5.1_
  - [x] 5.2 更新 PullRefresh 组件
    - 更新刷新文字颜色为 primaryColor (通过 legacy alias 自动更新)
    - _Requirements: 5.1_
  - [x] 5.3 更新 FilterOptionChip 组件
    - 更新选中边框和文字颜色为 primaryColor (通过 legacy alias 自动更新)
    - _Requirements: 5.3_
  - [x] 5.4 更新 CommonRichText 和 Heading 组件
    - 更新链接/强调文字颜色为 accentColor (通过 legacy alias 自动更新)
    - _Requirements: 5.2_
  - [x] 5.5 更新 CommonDigitTextFormField 组件
    - 更新数字文字颜色为 accentColor (通过 legacy alias 自动更新)
    - _Requirements: 5.2_
  - [x] 5.6 更新 Topbar 组件
    - 更新图标颜色引用 (通过 legacy alias 自动更新)
    - _Requirements: 5.4_

- [x] 6. Checkpoint - 确保基础组件更新后测试通过
  - All tests pass ✓

- [x] 7. 更新业务页面组件
  - [x] 7.1 更新 DepotsItemWidget (购油首页列表)
    - 更新去购油按钮背景色为 secondaryLight (#FEF3C7)
    - 更新去购油按钮文字和箭头颜色为 accentColor
    - 更新卡片选中边框颜色为 primaryColor
    - 更新价格数字颜色为 accentColor
    - _Requirements: 4.1, 4.2, 5.2_
  - [x] 7.2 更新 VerificationLoginForm (验证码登录表单)
    - 更新获取验证码按钮文字颜色为 accentColor (通过 legacy alias 自动更新)
    - _Requirements: 4.2, 5.2_
  - [x] 7.3 更新 StationManagementListScreen
    - 更新添加图标颜色引用 (通过 legacy alias 自动更新)
    - _Requirements: 5.4_

- [x] 8. 更新样式文件和油品颜色
  - [x] 8.1 更新 SportsTextStyle 样式定义
    - 更新 blueNormal 和 blueBold 样式颜色为 primaryColor (通过 legacy alias 自动更新)
    - _Requirements: 5.1_
  - [x] 8.2 更新油品颜色定义
    - 更新 dieselBg 为 #FEF3C7 (浅黄)
    - 更新 dieselText 为 #B45309 (深琥珀)
    - 确保 gasText 使用 accentColor (#F59E0B)
    - _Requirements: 7.1, 7.2, 7.3_

- [x] 9. 更新 HTML 协议文件
  - [x] 9.1 更新 privacy_policy.html
    - 将 CSS 变量 --primary-color 从 #7165E3 改为 #D97706
    - _Requirements: 4.1_
  - [x] 9.2 更新 service_agreement.html
    - 将 CSS 变量 --primary-color 从 #7165E3 改为 #D97706
    - _Requirements: 4.1_

- [x] 10. Final Checkpoint - 确保所有测试通过
  - All 13 color tests passing ✓

## 实现总结

琥珀金主题色彩系统重构已完成。主要更改：

1. **核心颜色定义** - 添加了 primaryColor (#D97706)、secondaryColor (#FFFBEB)、accentColor (#F59E0B) 等语义化颜色
2. **Legacy 别名系统** - btnPurple、txtPurple、borderPurple、icPurple 现在指向新的琥珀金颜色，大部分组件自动获得新主题
3. **手动更新的组件** - CommonImgUpload、CommonCityPicker、CustomToggle、DepotsItemWidget
4. **HTML 文件** - privacy_policy.html、service_agreement.html 的 CSS 变量已更新
5. **单元测试** - 13 个颜色常量测试全部通过
