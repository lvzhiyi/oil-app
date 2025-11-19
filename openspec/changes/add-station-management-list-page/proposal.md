# Change: 新增加油站管理列表页

## Why
当前个人中心页面的"加油站管理"按钮点击后没有跳转功能。用户需要一个专门的加油站管理列表页面来查看、编辑和管理所有加油站信息，这个页面应该与选择加油站的列表页面区分开来，提供更完整的管理功能。

## What Changes
- 新增加油站管理列表页面（station_management_list）
- 将个人中心页面的"加油站管理"按钮点击跳转到新的管理列表页
- 管理列表页使用与选择加油站列表页相同的接口（getStationStatus）
- 管理列表页支持查看所有加油站、编辑加油站、新增加油站功能
- 管理列表页与选择加油站列表页在UI和交互上有所区分（标题、功能按钮等）

## Impact
- **Affected specs**: 
  - `station-management` (修改，添加加油站管理列表页需求)
  
- **Affected code**:
  - `lib/pages/station_management_list/` (新增页面模块)
  - `lib/pages/profile/widgets/account_screen.dart` (修改，添加跳转逻辑)
  - `lib/router/routes.dart` (新增路由定义)

