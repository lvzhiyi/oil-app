# oil-pickup Specification

## Purpose
TBD - created by archiving change refactor-vehicle-info-param. Update Purpose after archive.
## Requirements
### Requirement: Withdraw Request Vehicle Info Format
The system SHALL submit vehicle information containing both the raw input string and the parsed JSON data, separated by `|||`.

#### Scenario: Submit with raw text
- **WHEN** user pastes vehicle info text "京A88888 13800138000"
- **THEN** the request `vehicleInfo` field contains "京A88888 13800138000|||{\"plateNumber\":\"京A88888\",...}"

#### Scenario: Submit without raw text
- **WHEN** user manually enters vehicle info without pasting
- **THEN** the request `vehicleInfo` field contains "|||{\"plateNumber\":\"...\",...}" (empty raw string)

### Requirement: Regenerate Certificate Image
The system SHALL allow users to regenerate and save the pickup certificate image from the order detail page for orders in "Pending Pickup" status.

#### Scenario: Regenerate image
- **WHEN** user views a "Pending Pickup" order
- **THEN** a "Regenerate Certificate Image" button is displayed
- **WHEN** user taps the button
- **THEN** the system generates the certificate image and presents options to save or share it (Gallery, File, Share)

### Requirement: 提油页面导航入口
系统 SHALL 在主导航栏的第二个 Tab 位置提供提油页面入口。

#### Scenario: 用户访问提油页面
- **WHEN** 用户点击主导航栏第二个 Tab
- **THEN** 系统应显示提油页面
- **AND** Tab 图标和文字应正确显示

### Requirement: 加油站选择功能
系统 SHALL 允许用户选择加油站作为提油地点。

#### Scenario: 首次选择加油站
- **WHEN** 用户首次进入提油页面且未选择加油站
- **THEN** 系统应显示"选择加油站"按钮
- **AND** 点击按钮应跳转到加油站列表页面

#### Scenario: 已选择加油站
- **WHEN** 用户已选择加油站
- **THEN** 提油页面应显示当前选中的加油站信息
- **AND** 加油站信息旁边应显示切换按钮
- **AND** 点击切换按钮应跳转到加油站列表页面

#### Scenario: 从列表选择加油站
- **WHEN** 用户在加油站列表页面点击某个加油站
- **THEN** 系统应选中该加油站
- **AND** 返回提油页面并显示选中的加油站信息

### Requirement: 加油站列表展示
系统 SHALL 提供加油站列表页面展示所有可用的加油站。

#### Scenario: 查看加油站列表
- **WHEN** 用户进入加油站列表页面
- **THEN** 系统应显示所有加油站的列表
- **AND** 每个列表项应显示加油站名称和地址
- **AND** 列表应支持滚动查看

#### Scenario: 空列表状态
- **WHEN** 没有可用的加油站数据
- **THEN** 系统应显示空状态提示
- **AND** 提示用户可以新增加油站

### Requirement: 加油站信息修改
系统 SHALL 允许用户修改已有加油站的信息。

#### Scenario: 进入编辑页面
- **WHEN** 用户在加油站列表项点击"修改"按钮
- **THEN** 系统应跳转到加油站编辑页面
- **AND** 页面应预填充当前加油站的信息

#### Scenario: 保存修改
- **WHEN** 用户修改加油站信息后点击保存按钮
- **AND** 表单验证通过
- **THEN** 系统应更新加油站信息
- **AND** 显示成功提示
- **AND** 返回加油站列表页面

#### Scenario: 取消修改
- **WHEN** 用户点击返回或取消按钮
- **THEN** 系统应丢弃未保存的修改
- **AND** 返回加油站列表页面

### Requirement: 新增加油站入口
系统 SHALL 提供新增加油站的入口按钮。

#### Scenario: 显示新增按钮
- **WHEN** 用户在加油站列表页面
- **THEN** 系统应在页面底部或固定位置显示"新增加油站"按钮

#### Scenario: 点击新增按钮(当前阶段)
- **WHEN** 用户点击"新增加油站"按钮
- **THEN** 系统暂不执行任何逻辑(预留后续开发)

### Requirement: 提油油量输入
系统 SHALL 提供输入提油油量的功能区域,且仅允许输入正整数。

#### Scenario: 输入油量
- **WHEN** 用户在提油页面的输入框输入油量
- **THEN** 系统应仅接受整数输入(不允许小数点和非数字字符)
- **AND** 应显示提示文本"请输入本次提油量/吨"
- **AND** 键盘应显示数字键盘

#### Scenario: 油量验证 - 空值
- **WHEN** 用户未输入提油量或输入为空
- **THEN** 系统应显示错误提示"请输入提油量"
- **AND** 不允许提交生成提油凭证

#### Scenario: 油量验证 - 非数字
- **WHEN** 用户输入非数字字符
- **THEN** 系统应阻止输入(仅允许数字)
- **AND** 不允许提交生成提油凭证

#### Scenario: 油量验证 - 小于等于0
- **WHEN** 用户输入的油量小于等于0(如0、负数)
- **THEN** 系统应显示错误提示"提油量必须大于0"
- **AND** 不允许提交生成提油凭证

### Requirement: 粘贴车辆信息展示
系统 SHALL 提供粘贴车辆信息的展示区域。

#### Scenario: 显示车辆信息区域
- **WHEN** 用户在提油页面
- **THEN** 系统应显示"粘贴车辆信息"的展示区域
- **AND** 区域应有明确的标题和边框样式

#### Scenario: 空车辆信息状态
- **WHEN** 用户尚未粘贴车辆信息
- **THEN** 系统应显示占位内容或提示

### Requirement: 车辆信息智能识别
系统 SHALL 自动识别和解析粘贴的车辆信息文本,并生成结构化的 JSON 数据。

#### Scenario: 粘贴标准格式车辆信息
- **WHEN** 用户粘贴包含完整字段的车辆信息文本
- **THEN** 系统应自动识别所有字段
- **AND** 生成包含所有字段的 JSON 字符串
- **AND** 在界面显示识别结果

#### Scenario: 粘贴乱序车辆信息
- **WHEN** 用户粘贴字段顺序不一致的车辆信息文本
- **THEN** 系统应通过关键词匹配正确识别各字段
- **AND** 生成正确的 JSON 数据结构

#### Scenario: 粘贴不完整车辆信息
- **WHEN** 用户粘贴缺少部分字段的车辆信息文本
- **THEN** 系统应识别出存在的字段
- **AND** 未识别的字段在 JSON 中设为 null 或空字符串
- **AND** 提示用户缺少的必填字段

#### Scenario: 识别多种格式变体
- **WHEN** 车辆信息包含不同的分隔符(冒号、等号、空格)
- **AND** 包含不同的换行方式
- **THEN** 系统应灵活解析并正确识别字段值
- **AND** 生成统一格式的 JSON 数据

#### Scenario: 查看识别后的 JSON
- **WHEN** 系统成功识别车辆信息
- **THEN** 用户应能够查看生成的 JSON 字符串
- **AND** JSON 应包含所有识别到的字段
- **AND** JSON 格式应正确可用于后续处理

### Requirement: 生成提油凭证
系统 SHALL 提供生成提油凭证的功能，调用后端 API 提交提油申请。

#### Scenario: 获取待完成的买油订单
- **WHEN** 用户进入提油页面
- **THEN** 系统应调用买油订单列表接口查询待完成的买油订单
- **AND** 接口参数应包含：
  - status=20（对应"已支付"状态，状态过滤）
  - page=1（分页参数，查询第一页）
  - pageSize=1（分页参数，由于同时只会存在一个待完成的订单，只需查询一条记录）
- **AND** 系统应获取第一个订单的ID并保存到状态中（由于同时只会存在一个待完成的订单）
- **AND** 如果未找到待完成订单，系统应显示相应提示

#### Scenario: 提交提油申请成功
- **WHEN** 用户填写完整的提油信息（加油站、油量、车辆信息）并提交
- **AND** 系统已获取到待完成的买油订单ID
- **THEN** 系统应验证所有必填字段
- **AND** 系统应调用 `POST /inventories/{orderId}/withdraw` 接口
- **AND** orderId 应使用页面初始化时获取的买油订单ID
- **AND** 请求参数应包含：
  - withdrawTon: 提油吨数（整数）
  - stationId: 加油站ID（整数）
  - vehicleInfo: 车辆信息JSON字符串（由车辆信息解析器生成）
- **AND** 接口调用成功后应显示成功提示

#### Scenario: 提交失败 - 缺少必填信息
- **WHEN** 用户未填写完整必填信息就尝试提交
- **THEN** 系统应显示验证错误提示
- **AND** 标记缺失或错误的字段
- **AND** 阻止接口调用

#### Scenario: 页面初始化 - 无待完成买油订单
- **WHEN** 用户进入提油页面
- **AND** 系统查询待完成买油订单时未找到订单
- **THEN** 系统应显示提示"暂无待完成的买油订单"
- **AND** "生成提油凭证"按钮应禁用或显示相应提示

#### Scenario: 提交失败 - 无待完成买油订单
- **WHEN** 用户尝试提交提油申请
- **AND** 系统未获取到待完成买油订单ID
- **THEN** 系统应显示错误提示"暂无待完成的买油订单"
- **AND** 阻止提油申请提交

#### Scenario: 提交失败 - 网络错误
- **WHEN** 提油接口调用时发生网络错误
- **THEN** 系统应显示错误提示信息
- **AND** 用户可以重试提交
- **AND** 表单数据保持不变

### Requirement: Mock 数据支持
系统 SHALL 使用 Mock 数据进行功能开发和测试。

#### Scenario: 加载 Mock 加油站数据
- **WHEN** 页面需要加油站数据
- **THEN** 系统应从 Mock 数据源加载预设的加油站列表
- **AND** Mock 数据应包含加油站名称、地址等必要字段

#### Scenario: Mock 数据修改
- **WHEN** 用户修改加油站信息
- **THEN** 系统应在内存中更新 Mock 数据
- **AND** 修改应在当前会话中保持

#### Scenario: Mock 数据选择
- **WHEN** 用户选择加油站
- **THEN** 系统应记录选中的加油站 ID
- **AND** 在提油页面正确显示选中的加油站信息

### Requirement: 响应式布局适配
系统 SHALL 确保提油相关页面在不同设备上正确显示。

#### Scenario: 手机端适配
- **WHEN** 用户在手机设备上访问提油页面
- **THEN** 所有组件应使用 AppSizes 工具进行尺寸适配
- **AND** 页面布局应适应手机屏幕宽度

#### Scenario: 平板端适配
- **WHEN** 用户在平板设备上访问提油页面
- **THEN** 页面应根据 AppSizes.isTablet 调整布局
- **AND** 字体和间距应正确缩放

#### Scenario: 深色模式适配
- **WHEN** 用户切换到深色模式
- **THEN** 所有颜色应使用 CustomAppColor.of(context) 动态获取
- **AND** 页面应正确显示深色主题样式

### Requirement: 提油列表
系统 SHALL 提供提油订单列表页面，允许用户查看和筛选提油记录。

#### Scenario: 查看提油列表
- **WHEN** 用户进入提油列表页面
- **THEN** 系统显示提油订单列表
- **AND** 顶部显示两个筛选标签："待提油"和"已完成"
- **AND** 默认选中"待提油"标签

#### Scenario: 筛选待提油订单
- **WHEN** 用户选择"待提油"标签
- **THEN** 系统调用接口获取状态为 `pending_pickup` 的订单
- **AND** 列表显示待提油的订单信息

#### Scenario: 筛选已完成订单
- **WHEN** 用户选择"已完成"标签
- **THEN** 系统调用接口获取状态为 `completed` 的订单
- **AND** 列表显示已完成的订单信息

#### Scenario: 列表分页加载
- **WHEN** 用户滚动列表到底部
- **THEN** 系统自动加载下一页数据
- **AND** 如果没有更多数据，显示相应提示

### Requirement: 提油订单列表查询
系统 SHALL 提供查询提油订单列表的功能，支持按状态过滤。

#### Scenario: 查询提油订单
- **WHEN** 系统需要查询提油订单
- **THEN** 系统应调用提油订单列表接口 `GET /inventories/withdraws`
- **AND** 接口参数应包含：
  - status（状态过滤，可选）
  - page（分页参数，必填）
  - pageSize（分页参数，必填）
- **AND** 返回符合条件的提油工单列表

#### Scenario: 查询所有提油订单
- **WHEN** 系统需要查询所有提油订单（不指定状态）
- **THEN** 系统应调用提油订单列表接口 `GET /inventories/withdraws`
- **AND** 接口参数应包含：
  - page（分页参数，必填）
  - pageSize（分页参数，必填）
- **AND** status 参数为可选参数，不传则返回所有状态的提油订单

### Requirement: 买油订单列表状态过滤
系统 SHALL 支持按订单状态过滤买油订单列表。

#### Scenario: 查询待完成订单
- **WHEN** 系统需要查询待完成的买油订单
- **THEN** 系统应调用买油订单列表接口
- **AND** 接口参数应包含：
  - status=20（对应"已支付"状态，状态过滤）
  - page（分页参数，必填）
  - pageSize（分页参数，必填）
- **AND** 返回符合条件的订单列表
- **AND** 为优化性能，建议使用 page=1, pageSize=1 查询

#### Scenario: 查询所有订单
- **WHEN** 系统需要查询所有订单（不指定状态）
- **THEN** 系统应调用买油订单列表接口
- **AND** 接口参数应包含：
  - page（分页参数，必填）
  - pageSize（分页参数，必填）
- **AND** status 参数为可选参数，不传则返回所有状态的订单

### Requirement: 提油接口调用
系统 SHALL 提供调用提油接口的功能。

#### Scenario: 构建提油请求参数
- **WHEN** 系统需要提交提油申请
- **THEN** 系统应构建包含以下字段的请求参数：
  - withdrawTon: 用户输入的提油吨数（转换为整数）
  - stationId: 当前选中的加油站ID（转换为整数）
  - vehicleInfo: 车辆信息解析后的JSON字符串（使用 VehicleInfoParser.toJson 生成）

#### Scenario: 调用提油接口
- **WHEN** 系统调用提油接口
- **THEN** 接口路径应为 `POST /inventories/{orderId}/withdraw`
- **AND** orderId 应为待完成订单的ID
- **AND** 请求体应包含 withdrawTon、stationId、vehicleInfo 字段
- **AND** 接口调用成功后应更新UI状态

#### Scenario: 车辆信息JSON格式
- **WHEN** 系统需要传递车辆信息
- **THEN** 系统应使用 VehicleInfoParser.toJson 方法将车辆模型转换为JSON字符串
- **AND** JSON字符串应包含所有解析到的车辆信息字段
- **AND** 即使某些字段为空，也应包含在JSON中（值为null或空字符串）

### Requirement: 库存列表项组件
系统 SHALL 提供库存列表项组件，用于展示单个库存信息，采用现代化的扁平设计风格。

#### Scenario: 显示库存卡片头部信息
- **WHEN** 系统渲染库存列表项
- **THEN** 组件应显示卡片头部区域
- **AND** 头部左侧应显示油库图标和油库名称
- **AND** 头部右侧应显示位置信息（如果API提供）
- **AND** 头部和主体之间应使用虚线分割线分隔

#### Scenario: 显示油品徽章
- **WHEN** 系统渲染库存列表项
- **THEN** 组件应在卡片主体左侧显示油品徽章
- **AND** 徽章尺寸应为52x52像素，圆角12px
- **AND** 徽章应显示油品编号（如 #0、#95）和名称（柴油/汽油）
- **AND** 柴油应使用紫色主题（背景 #EEECFC，文字 #7165E3）
- **AND** 汽油应使用橙色主题（背景 #FFF7ED，文字 #F59E0B）
- **AND** 编号字体应为18px粗体，名称字体应为11px

#### Scenario: 显示库存量信息
- **WHEN** 系统渲染库存列表项
- **THEN** 组件应在卡片主体中间显示库存量
- **AND** 库存量数字应使用大号字体（26px，等宽字体）
- **AND** 单位"吨"应使用12px字体
- **AND** 数字和单位应基线对齐
- **AND** 库存量上方应显示"当前持有"标签（12px灰色文字）

#### Scenario: 显示库存状态标签
- **WHEN** 系统渲染库存列表项
- **AND** 库存量大于等于5吨
- **THEN** 组件应显示"库存充足"标签（绿色圆点 + 绿色文字）
- **WHEN** 系统渲染库存列表项
- **AND** 库存量大于0但小于5吨
- **THEN** 组件应显示"库存紧张"标签（橙色圆点 + 橙色文字）
- **WHEN** 系统渲染库存列表项
- **AND** 库存量小于等于0
- **THEN** 组件应显示"暂无库存"标签（灰色圆点 + 灰色文字）或不显示标签

#### Scenario: 显示操作按钮
- **WHEN** 系统渲染库存列表项
- **AND** 库存量大于0
- **THEN** 组件应在卡片主体右侧显示"去提油"按钮
- **AND** 按钮应为圆角20px（pill形状）
- **AND** 按钮背景应为紫色（#7165E3），文字为白色
- **AND** 按钮应具有阴影效果（紫色40%透明度）
- **WHEN** 系统渲染库存列表项
- **AND** 库存量小于等于0
- **THEN** 组件应显示禁用状态的按钮（灰色背景，灰色文字，不可点击）

#### Scenario: 卡片样式
- **WHEN** 系统渲染库存列表项
- **THEN** 卡片应具有以下样式：
- **AND** 圆角：16px
- **AND** 内边距：16px
- **AND** 背景色：白色
- **AND** 阴影：弱阴影（0 2px 8px rgba(0,0,0,0.02)）
- **AND** 边框：1px 浅色边框（rgba(0,0,0,0.03)）
- **AND** 列表项之间间距：12px

#### Scenario: 点击列表项
- **WHEN** 用户点击库存列表项（或点击"去提油"按钮）
- **AND** 库存量大于0
- **THEN** 组件应触发点击回调
- **AND** 应传递当前库存的信息
- **AND** 系统应跳转到库存详情提油页面

### Requirement: Vehicle Information Entry
The system SHALL provide a structured form for entering vehicle and driver information, supported by an intelligent text parser.

#### Scenario: Manual Entry
- **WHEN** the user opens the Oil Pickup Detail page
- **THEN** a structured form SHALL be displayed with fields for:
  - Driver Name
  - Plate Number (Vehicle No.)
  - ID Card Number
  - Phone Number
  - Oil Amount (Ton)
- **AND** all fields SHALL be manually editable.

#### Scenario: Intelligent Parsing (Auto-Fill)
- **WHEN** the user pastes vehicle dispatch information into the "Intelligent Parse" area and triggers identification
- **THEN** the system SHALL parse the text.
- **AND** automatically populate the corresponding fields in the structured form.
- **AND** keep the form editable for user corrections.

### Requirement: Validation
The system SHALL validate vehicle information before generating a pickup certificate.

#### Scenario: Missing Required Fields
- **WHEN** the user clicks "Generate Certificate"
- **AND** one or more required fields (Driver Name, Plate Number, ID Card) are empty
- **THEN** the system SHALL prevent submission.
- **AND** highlight the empty fields with a visual error indicator (Inline Validation).
- **AND** display a Toast warning indicating the validation failure.

