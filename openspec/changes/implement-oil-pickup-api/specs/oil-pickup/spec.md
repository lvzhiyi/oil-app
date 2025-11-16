## MODIFIED Requirements

### Requirement: 生成提油凭证
系统 SHALL 提供生成提油凭证的功能，调用后端 API 提交提油申请。

#### Scenario: 检查待完成的提油工单
- **WHEN** 用户进入提油页面
- **THEN** 系统应在页面初始化时调用提油订单列表接口查询待完成的提油工单
- **AND** 接口路径应为 `GET /inventories/withdraws`
- **AND** 接口参数应包含：
  - status=pending_pickup（状态过滤）
  - page=1（分页参数，查询第一页）
  - pageSize=1（分页参数，由于最多只有一个待完成的提油工单，只需查询一条记录）
- **AND** 如果查询到待完成的提油工单，系统应禁止发起新的提油申请
- **AND** 如果未查询到待完成的提油工单，系统应允许发起新的提油申请

#### Scenario: 获取待完成的买油订单
- **WHEN** 用户进入提油页面
- **AND** 系统未查询到待完成的提油工单
- **THEN** 系统应调用买油订单列表接口查询待完成的买油订单
- **AND** 接口参数应包含：
  - status=20（对应"已支付"状态，状态过滤）
  - page=1（分页参数，查询第一页）
  - pageSize=1（分页参数，由于同时只会存在一个待完成的订单，只需查询一条记录）
- **AND** 系统应获取第一个订单的ID并保存到状态中（由于同时只会存在一个待完成的订单）
- **AND** 如果未找到待完成订单，系统应显示相应提示

#### Scenario: 提交提油申请成功
- **WHEN** 用户填写完整的提油信息（加油站、油量、车辆信息）并提交
- **AND** 系统未查询到待完成的提油工单
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

#### Scenario: 页面初始化 - 有待完成的提油工单
- **WHEN** 用户进入提油页面
- **AND** 系统查询到有待完成的提油工单（status=pending_pickup）
- **THEN** 系统应显示提示"您有待完成的提油工单，请先完成后再发起新的申请"
- **AND** "生成提油凭证"按钮应禁用
- **AND** 不允许发起新的提油申请

#### Scenario: 页面初始化 - 无待完成买油订单
- **WHEN** 用户进入提油页面
- **AND** 系统未查询到待完成的提油工单
- **AND** 系统查询待完成买油订单时未找到订单
- **THEN** 系统应显示提示"暂无待完成的买油订单"
- **AND** "生成提油凭证"按钮应禁用或显示相应提示

#### Scenario: 提交失败 - 有待完成的提油工单
- **WHEN** 用户尝试提交提油申请
- **AND** 系统查询到有待完成的提油工单
- **THEN** 系统应显示错误提示"您有待完成的提油工单，请先完成后再发起新的申请"
- **AND** 阻止提油申请提交

#### Scenario: 提交失败 - 无待完成买油订单
- **WHEN** 用户尝试提交提油申请
- **AND** 系统未查询到待完成的提油工单
- **AND** 系统未获取到待完成买油订单ID
- **THEN** 系统应显示错误提示"暂无待完成的买油订单"
- **AND** 阻止提油申请提交

#### Scenario: 提交失败 - 网络错误
- **WHEN** 提油接口调用时发生网络错误
- **THEN** 系统应显示错误提示信息
- **AND** 用户可以重试提交
- **AND** 表单数据保持不变

## ADDED Requirements

### Requirement: 提油订单列表查询
系统 SHALL 提供查询提油订单列表的功能，支持按状态过滤。

#### Scenario: 查询待完成的提油工单
- **WHEN** 系统需要查询待完成的提油工单
- **THEN** 系统应调用提油订单列表接口 `GET /inventories/withdraws`
- **AND** 接口参数应包含：
  - status=pending_pickup（状态过滤）
  - page（分页参数，必填）
  - pageSize（分页参数，必填）
- **AND** 返回符合条件的提油工单列表
- **AND** 由于系统只允许同时发起一笔提油申请，最多只会返回一个待完成的提油工单
- **AND** 为优化性能，建议使用 page=1, pageSize=1 查询

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

