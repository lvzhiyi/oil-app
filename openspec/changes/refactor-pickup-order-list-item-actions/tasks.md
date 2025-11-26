# 实施任务清单

- [ ] 移除 `_buildCardBody` 中的箭头图标 (`Icons.chevron_right`)
- [ ] 移除 `GestureDetector` 中的 `onTapUp` 跳转逻辑，保留 `onTapDown` 和 `onTapCancel` 用于视觉反馈
- [ ] 移除独立的 `_buildCancelButton` 方法调用
- [ ] 创建 `_buildActionButtons` 方法，包含：
  - 查看详情按钮（主按钮样式）
  - 取消订单按钮（次要按钮样式，仅待提油时显示）
- [ ] 在 `_buildCardFooter` 或 `build` 方法中集成新的操作按钮区域
- [ ] 测试待提油状态：应显示"取消订单"和"查看详情"两个按钮
- [ ] 测试已完成状态：应只显示"查看详情"按钮
- [ ] 验证点击"查看详情"能正常跳转到详情页
- [ ] 验证点击"取消订单"能正常弹出确认对话框
