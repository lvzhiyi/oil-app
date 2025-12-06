# Change: 提油订单详情改为接口拉取

## Why
- 当前详情页依赖导航传入的订单数据，存在信息过期或字段缺失风险。
- 需要使用后端提油订单详情接口确保展示的订单信息为最新且完整。

## What Changes
- 进入提油订单详情页时，通过 GET `/inventories/withdraws/{withdrawId}` 拉取最新详情数据。
- 详情页展示的数据源切换为接口返回结果，去除对导航携带完整订单对象的依赖。
- 加入加载与失败提示，保证无数据或接口异常时的可用性。

## Impact
- Affected specs: `oil-pickup-order-detail`
- Affected code: `lib/pages/pickup_order_detail/controller.dart`, `lib/pages/pickup_order_detail/widgets/pickup_order_detail_screen.dart`, 相关网络服务与模型定义
