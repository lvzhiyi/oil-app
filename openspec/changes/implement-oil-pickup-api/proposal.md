# Change: 实现提油页面接口调用逻辑

## Why
当前提油页面使用 Mock 数据进行生成提油凭证操作，需要改为调用真实的后端 API。用户需要能够提交提油申请，包括提油吨数、加油站ID和车辆信息。

## What Changes
- 创建提油订单列表接口服务 `GET /inventories/withdraws`，支持按状态过滤（status=pending_pickup）
- 在买油订单列表接口添加 status 查询参数，支持按订单状态过滤
- 创建提油接口服务 `POST /inventories/{orderId}/withdraw`
- 实现页面初始化时检查是否有待完成的提油工单（通过 status=pending_pickup 查询）
- 如果有待完成的提油工单，禁止发起新的提油申请
- 如果没有待完成的提油工单，允许发起新的提油申请，需要先获取买油订单ID（status=20）
- 更新提油页面控制器，实现真实的接口调用逻辑
- 将车辆信息解析后的 JSON 字符串作为 vehicleInfo 参数传递

## Impact
- **Affected specs**: 
  - `oil-pickup` (修改，添加接口调用需求)
  
- **Affected code**:
  - `lib/pages/pay_order_list/service/pay_order_list.dart` (添加 status 查询参数)
  - `lib/pages/oil_pickup/controller.dart` (实现真实接口调用逻辑)
  - `lib/pages/oil_pickup/service/` (新增提油订单列表接口和提油接口服务)
  - `lib/pages/oil_pickup/model/` (新增提油订单列表响应类型、提油请求和响应类型)

