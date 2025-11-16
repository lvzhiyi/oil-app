# 实现任务清单

## 1. API 服务层
- [ ] 1.1 在 StationService 中添加编辑加油站接口方法 `PUT /stations/{id}`
- [ ] 1.2 确认请求参数类型（复用 BindStationRequest 或创建新的请求类型）
- [ ] 1.3 运行代码生成命令生成 Retrofit 代码

## 2. 控制器层
- [ ] 2.1 修改 StationEditCtrl.save() 方法，移除 Mock 数据逻辑
- [ ] 2.2 实现图片上传逻辑（参考绑定页面的 uploadImage 方法）
- [ ] 2.3 实现新增加油站逻辑（当 stationId 为空时调用 POST /stations）
- [ ] 2.4 实现编辑加油站逻辑（当 stationId 不为空时调用 PUT /stations/{id}）
- [ ] 2.5 添加错误处理和加载状态管理
- [ ] 2.6 添加成功后的导航逻辑（返回上一页或刷新列表）

## 3. 状态管理
- [ ] 3.1 确认 StationEditState 包含所有必要的字段（省市区代码和名称）
- [ ] 3.2 确保状态更新逻辑正确

## 4. 数据模型
- [ ] 4.1 确认 BindStationRequest 包含所有必要字段
- [ ] 4.2 如果需要，创建 UpdateStationRequest（或确认可以复用 BindStationRequest）

## 5. 测试和验证
- [ ] 5.1 测试新增加油站流程（无 stationId）
- [ ] 5.2 测试编辑加油站流程（有 stationId）
- [ ] 5.3 测试图片上传功能
- [ ] 5.4 测试表单验证和错误处理
- [ ] 5.5 测试网络错误处理
- [ ] 5.6 验证接口参数与绑定页面一致

