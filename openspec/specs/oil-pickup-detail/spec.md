# oil-pickup-detail Specification

## Purpose
TBD - created by archiving change refactor-oil-pickup-detail-layout. Update Purpose after archive.
## Requirements
### Requirement: 提油详情页面布局
提油详情页面SHALL采用居中布局设计，优化信息层级和视觉焦点。

#### Scenario: 库存信息卡片居中显示
- **WHEN** 用户进入提油详情页面
- **THEN** 库存信息卡片内容居中显示，包括油库名称、可用库存数量
- **AND** 库存数量使用大号字体（36px）突出显示
- **AND** 油品类型标签显示在油库名称下方

#### Scenario: 提油量输入框居中布局
- **WHEN** 用户查看提油量输入区域
- **THEN** 输入框采用居中布局
- **AND** 输入框使用大号字体（48px）显示数字
- **AND** 单位"吨"显示在输入框右侧
- **AND** 输入框下方显示提示文字"请输入本次提油数量"

#### Scenario: 文本粘贴区样式优化
- **WHEN** 用户查看车辆及司机信息输入区域
- **THEN** 文本输入框高度为160px
- **AND** 输入框支持多行文本输入
- **AND** 输入框聚焦时显示紫色边框和阴影效果
- **AND** 标题区域显示"车辆及司机调度信息"和"点击粘贴"按钮
- **AND** 输入框下方显示提示信息框，说明文字将直接生成在提油凭证上

#### Scenario: 底部按钮固定定位
- **WHEN** 用户滚动页面内容
- **THEN** 底部"生成提油凭证"按钮固定在屏幕底部
- **AND** 按钮区域有阴影效果，与内容区域区分
- **AND** 按钮区域适配安全区域（SafeArea）

#### Scenario: 页面间距统一规范
- **WHEN** 用户查看页面布局
- **THEN** 页面左右边距为16px
- **AND** 卡片之间的间距为12px
- **AND** 卡片内边距为16-24px
- **AND** 所有圆角统一为12px

