# Change: 添加提油页面及加油站选择管理功能

## Why
当前应用缺少提油业务的核心功能页面。用户需要能够选择加油站、切换加油站、查看粘贴车辆信息以及生成提油凭证,以完成从油库提油的业务流程。

## What Changes
- 在主导航第二个 Tab 添加提油页面
- 实现加油站选择和切换功能
- 实现加油站列表展示页面
- 支持修改已选加油站信息
- 支持新增加油站(UI预留,逻辑后续实现)
- 展示粘贴车辆信息区域
- 展示生成提油凭证按钮
- 使用 Mock 数据进行功能开发和测试

## Impact
- **Affected specs**: 
  - `oil-pickup` (新增能力)
  - `main-navigation` (修改,添加第二个Tab路由)
  - `station-management` (可能修改,复用加油站选择逻辑)
  
- **Affected code**:
  - `lib/pages/oil_pickup/` (新增页面模块)
  - `lib/pages/station_list/` (新增加油站列表页面)
  - `lib/router/routes.dart` (新增路由定义)
  - `lib/models/` (新增 Mock 数据模型)
  - `lib/global/mock/` (新增 Mock 数据服务,如需要)

