# 实现任务清单

## 1. 数据模型
- [ ] 1.1 创建提油订单列表响应类型 (WithdrawOrderListResponse)
- [ ] 1.2 创建提油订单模型 (WithdrawOrderModel)，包含订单ID、状态等字段
- [ ] 1.3 创建提油请求类型 (WithdrawRequest)，包含 withdrawTon、stationId、vehicleInfo 字段
- [ ] 1.4 创建提油响应类型（如果需要）

## 2. API 服务层
- [ ] 2.1 创建提油订单列表接口服务方法 `GET /inventories/withdraws`，支持 status、page、pageSize 查询参数
- [ ] 2.2 在买油订单列表接口添加 status 查询参数（可选参数，page 和 pageSize 已存在）
- [ ] 2.3 创建提油接口服务方法 `POST /inventories/{orderId}/withdraw`
- [ ] 2.4 运行代码生成命令生成 Retrofit 代码

## 3. 控制器层
- [ ] 3.1 在 OilPickupCtrl.initState() 中实现检查待完成提油工单的逻辑（调用提油订单列表接口，status=pending_pickup, page=1, pageSize=1）
- [ ] 3.2 如果查询到待完成的提油工单，设置状态禁止发起新申请
- [ ] 3.3 如果未查询到待完成的提油工单，调用买油订单列表接口获取待完成订单（status=20, page=1, pageSize=1）
- [ ] 3.4 将获取到的买油订单ID保存到状态中
- [ ] 3.5 处理无待完成买油订单的情况（显示提示、禁用按钮等）
- [ ] 3.6 修改 OilPickupCtrl.generateCertificate() 方法，移除 Mock 逻辑
- [ ] 3.7 在提交前再次检查是否有待完成的提油工单
- [ ] 3.8 实现提油接口调用逻辑（使用状态中保存的买油订单ID）
- [ ] 3.9 构建请求参数（withdrawTon、stationId、vehicleInfo）
- [ ] 3.10 添加错误处理和加载状态管理
- [ ] 3.11 添加成功后的处理逻辑（提示、导航等）

## 4. 状态管理
- [ ] 4.1 在 OilPickupState 中添加买油订单ID字段（pendingOilOrderId）
- [ ] 4.2 添加是否有待完成提油工单字段（hasPendingWithdraw）
- [ ] 4.3 添加订单加载状态字段（isLoadingOrder）
- [ ] 4.4 添加订单加载错误信息字段（orderError）
- [ ] 4.5 添加是否允许发起新申请字段（canCreateNewWithdraw）
- [ ] 4.6 更新 copyWith 方法以支持新字段

## 5. 测试和验证
- [ ] 5.1 测试获取待完成订单流程
- [ ] 5.2 测试提油接口调用流程
- [ ] 5.3 测试车辆信息JSON字符串传递
- [ ] 5.4 测试表单验证和错误处理
- [ ] 5.5 测试网络错误处理
- [ ] 5.6 验证接口参数格式正确

