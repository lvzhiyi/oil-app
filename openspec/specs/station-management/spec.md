# Capability: Station Management (加油站管理)

## Purpose

加油站管理能力提供加油站绑定、状态查询和相关证照管理功能。用户可以绑定加油站信息，上传营业执照和成品油零售许可证，系统支持省市区三级联动地址选择，并管理加油站从待审核到激活的完整状态流转。

## Requirements

### Requirement: 加油站绑定
系统 SHALL 支持用户绑定加油站信息。

#### Scenario: 首次绑定加油站
- **WHEN** 新注册用户完成注册流程
- **THEN** 系统自动导航到加油站绑定页面
- **AND** 用户需要填写完整的加油站信息才能继续

#### Scenario: 登录用户无绑定站点
- **WHEN** 已注册用户登录但未绑定任何加油站
- **THEN** 系统检测到无绑定站点
- **AND** 自动跳转到加油站绑定页面
- **AND** 用户必须完成绑定才能访问主要功能

#### Scenario: 提交加油站信息成功
- **WHEN** 用户填写完整的加油站信息并提交
- **THEN** 系统验证所有必填字段
- **AND** 系统上传营业执照和成品油零售许可证图片到OSS
- **AND** 系统创建加油站绑定申请
- **AND** 加油站状态设置为"待审核"(pending_review)

#### Scenario: 提交失败 - 缺少必填信息
- **WHEN** 用户未填写完整必填信息就尝试提交
- **THEN** 系统显示验证错误提示
- **AND** 标记缺失或错误的字段
- **AND** 阻止表单提交

### Requirement: 地址选择
系统 SHALL 提供省市区三级联动地址选择功能。

#### Scenario: 选择省份
- **WHEN** 用户点击省份选择器
- **THEN** 系统显示所有省份列表
- **AND** 用户选择省份后，更新省份代码和名称
- **AND** 清空之前选择的市和区信息

#### Scenario: 选择城市
- **WHEN** 用户在已选省份的基础上选择城市
- **THEN** 系统显示该省份下的所有城市
- **AND** 用户选择城市后，更新城市代码和名称
- **AND** 清空之前选择的区信息

#### Scenario: 选择区域
- **WHEN** 用户在已选城市的基础上选择区域
- **THEN** 系统显示该城市下的所有区域
- **AND** 用户选择后，更新区域代码和名称
- **AND** 完整地址信息被保存

#### Scenario: 地址数据源
- **WHEN** 系统需要显示地址选择器
- **THEN** 系统从本地JSON文件(pca-code.json)读取省市区数据
- **AND** 数据包含完整的代码和名称映射关系

### Requirement: 证照上传
系统 SHALL 支持加油站相关证照的图片上传。

#### Scenario: 选择营业执照
- **WHEN** 用户点击营业执照上传区域
- **THEN** 系统打开图片选择器（相册或相机）
- **AND** 用户选择图片后显示预览
- **AND** 图片路径被保存到表单状态

#### Scenario: 选择成品油零售许可证
- **WHEN** 用户点击成品油零售许可证上传区域
- **THEN** 系统打开图片选择器
- **AND** 用户选择图片后显示预览
- **AND** 图片路径被保存到表单状态

#### Scenario: 图片上传到OSS
- **WHEN** 用户提交表单时有本地图片
- **THEN** 系统将图片上传到阿里云OSS
- **AND** 获取图片的OSS URL签名
- **AND** 使用URL提交到后端API
- **AND** 显示上传进度

#### Scenario: 上传失败处理
- **WHEN** 图片上传失败（网络错误或OSS错误）
- **THEN** 系统显示上传失败提示
- **AND** 用户可以重试上传
- **AND** 表单提交被阻止直到上传成功

### Requirement: 加油站状态查询
系统 SHALL 能够查询和显示加油站的审核状态。

#### Scenario: 查询待审核和活跃站点
- **WHEN** 系统需要检查用户的加油站绑定状态
- **THEN** 系统调用API查询状态为"pending_review"和"active"的站点
- **AND** 返回用户关联的所有符合条件的加油站列表

#### Scenario: 用户有待审核站点
- **WHEN** 查询结果包含状态为"pending_review"的站点
- **THEN** 系统显示"待审核"页面
- **AND** 提示用户等待管理员审核
- **AND** 用户无法访问完整的应用功能

#### Scenario: 用户有活跃站点
- **WHEN** 查询结果包含状态为"active"的站点
- **THEN** 系统允许用户进入主界面
- **AND** 用户可以访问所有功能
- **AND** 站点信息在应用中可用

#### Scenario: 用户无绑定站点
- **WHEN** 查询结果为空列表
- **THEN** 系统跳转到加油站绑定页面
- **AND** 提示用户需要绑定加油站

### Requirement: 表单验证
系统 SHALL 验证加油站绑定表单的所有必填字段。

#### Scenario: 加油站名称验证
- **WHEN** 用户输入加油站名称
- **THEN** 系统验证名称不为空
- **AND** 验证名称长度在合理范围内
- **AND** 实时显示验证状态

#### Scenario: 地址信息验证
- **WHEN** 用户提交表单
- **THEN** 系统验证省市区都已选择
- **AND** 验证详细地址不为空
- **AND** 所有地址代码和名称都已保存

#### Scenario: 证照验证
- **WHEN** 用户提交表单
- **THEN** 系统验证营业执照已上传
- **AND** 验证成品油零售许可证已上传
- **AND** 验证图片URL有效

#### Scenario: 提交前综合验证
- **WHEN** 用户点击"绑定"按钮
- **THEN** 系统执行完整的表单验证
- **AND** 所有验证通过后才允许提交
- **AND** 验证失败时显示具体错误信息并聚焦到第一个错误字段

### Requirement: 加油站状态流转
系统 SHALL 管理加油站从绑定到激活的状态流转。

#### Scenario: 新绑定站点 - 待审核
- **WHEN** 用户成功提交加油站绑定申请
- **THEN** 加油站状态设置为"pending_review"
- **AND** 系统显示待审核提示页面
- **AND** 用户被限制访问主要功能

#### Scenario: 管理员审核通过 - 激活
- **WHEN** 管理员审核通过加油站申请
- **THEN** 加油站状态变更为"active"
- **AND** 用户下次登录可以访问完整功能
- **AND** 系统可能发送通知给用户

#### Scenario: 管理员审核拒绝
- **WHEN** 管理员拒绝加油站申请
- **THEN** 加油站状态变更为"rejected"
- **AND** 用户收到拒绝原因
- **AND** 用户可以修改信息重新提交

## Technical Notes

### API Endpoints
- `POST /station/bind` - 绑定加油站
- `GET /station/status` - 查询加油站状态（支持状态过滤）
- `POST /common/upload-signature` - 获取OSS上传签名

### Data Models
- `BindStationRequest`: { stationName, provinceCode, provinceName, cityCode, cityName, areaCode, areaName, addressDetail, businessLicenseUrl, fuelRetailPermitUrl }
- `GetStationResponse`: { list: StationInfo[] }
- `StationInfo`: { id, name, status, ... }

### Station Status Enum
- `pending_review` - 待审核
- `active` - 已激活/正常运营
- `rejected` - 审核拒绝
- `suspended` - 暂停服务

### State Management
- 使用 Cubit 管理页面状态（BindStationCtrl）
- 表单状态使用 flutter_form_builder
- 全局加油站信息存储在 AppController

### Image Handling
- 使用 image_picker 选择图片
- 支持相机拍照和相册选择
- 图片先上传到阿里云OSS
- OSS URL保存到数据库

### Data Source
- 省市区数据来源: `assets/json/pca-code.json`
- 数据格式: { code: string, name: string, children: [] }
- 三级联动逻辑

### Navigation Flow
1. 新用户注册 → 加油站绑定 → 待审核页面
2. 登录检查 → 无站点 → 加油站绑定
3. 登录检查 → 待审核站点 → 待审核页面
4. 登录检查 → 活跃站点 → 主界面

