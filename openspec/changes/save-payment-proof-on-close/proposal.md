# Change: 上传凭证成功后保存支付凭证

## Why
当前上传转账凭证功能仅将图片上传到OSS，但未调用后端接口保存凭证信息。用户上传凭证后关闭组件时，系统需要调用后端接口将凭证URL保存到订单中，以便后续审核和管理。

## What Changes
- 在支付订单服务中添加保存支付凭证接口 `POST /oil-orders/{id}/payment-proof`
- 创建支付凭证请求模型，包含 proof 字段（凭证URL数组）
- 在上传凭证成功后立即调用保存接口，同步凭证列表到后端
- 在删除凭证后立即调用保存接口，更新凭证列表
- 在关闭上传凭证对话框时，如果有已上传的凭证URL但未保存，调用保存接口
- 添加保存凭证的加载状态和错误处理
- 保存成功后刷新订单详情，更新订单状态
- 实现防抖机制，避免频繁调用保存接口

## Impact
- **Affected specs**:
  - `payment-order-detail` (新增，添加支付凭证保存需求)

- **Affected code**:
  - `lib/pages/pay_order_detail/service/pay_order_service.dart` (添加保存支付凭证接口)
  - `lib/pages/pay_order_detail/controller.dart` (添加保存凭证方法，在上传成功、删除后、关闭对话框时调用)
  - `lib/pages/pay_order_detail/view.dart` (修改关闭对话框逻辑，调用保存接口)
  - `lib/pages/pay_order_detail/model/` (新增支付凭证请求模型，如果需要)

