# Change: 更新加油站编辑页面接口调用逻辑

## Why
当前加油站编辑页面使用 Mock 数据进行保存操作，需要改为调用真实的后端 API。根据业务逻辑，新增加油站和编辑加油站使用相同的请求参数，但接口路径不同：新增加油站使用 `POST /stations`，编辑加油站使用 `PUT /stations/{id}`。

## What Changes
- 更新加油站编辑页面的保存逻辑，从 Mock 数据改为调用真实 API
- 在 StationService 中添加编辑加油站接口方法 `PUT /stations/{id}`
- 新增加油站时，接口调用逻辑参考绑定页面（绑定页面实际调用的是 `POST /stations`）
- 编辑加油站时，调用 `PUT /stations/{id}` 接口，参数与新增加油站接口参数一致
- 更新 station-management spec，添加编辑加油站的需求和 API 端点说明

## Impact
- **Affected specs**: 
  - `station-management` (修改，添加编辑加油站需求和 API 端点)
  
- **Affected code**:
  - `lib/pages/station_edit/controller.dart` (修改保存逻辑，调用真实 API)
  - `lib/global/service/station_service.dart` (添加编辑加油站接口方法)
  - `lib/global/model/station_req_type.dart` (可能需要添加编辑请求类型，或复用 BindStationRequest)

