# API参考

<cite>
**本文档中引用的文件**  
- [auth_service.g.dart](file://lib/global/service/auth_service.g.dart)
- [auth_req_type.dart](file://lib/global/model/auth_req_type.dart)
- [auth_rep_type.g.dart](file://lib/global/model/auth_rep_type.g.dart)
- [station_service.g.dart](file://lib/global/service/station_service.g.dart)
- [station_req_type.dart](file://lib/global/model/station_req_type.dart)
- [station_res_type.g.dart](file://lib/global/model/station_res_type.g.dart)
- [oil_order_service.g.dart](file://lib/pages/main_oil_pay/service/oil_order_service.g.dart)
- [oil_order_req_type.dart](file://lib/pages/main_oil_pay/model/oil_order_req_type.dart)
- [oil_order_res.type.g.dart](file://lib/pages/main_oil_pay/model/oil_order_res.type.g.dart)
- [pay_order_service.g.dart](file://lib/pages/pay_order_detail/service/pay_order_service.g.dart)
- [payment_proof_request.g.dart](file://lib/pages/pay_order_detail/model/payment_proof_request.g.dart)
- [oil_pickup_service.g.dart](file://lib/pages/oil_pickup/service/oil_pickup_service.g.dart)
- [withdraw_data.g.dart](file://lib/pages/oil_pickup/model/withdraw_data.g.dart)
- [common_response_type.g.dart](file://lib/global/model/common_response_type.g.dart)
- [net_manager.dart](file://lib/net/net_manager.dart)
- [api_exception.dart](file://lib/net/api_exception.dart)
</cite>

## 目录
1. [简介](#简介)
2. [认证服务](#认证服务)
3. [加油站服务](#加油站服务)
4. [油品订单服务](#油品订单服务)
5. [支付订单服务](#支付订单服务)
6. [油品提货服务](#油品提货服务)
7. [错误处理机制](#错误处理机制)
8. [Retrofit调用示例](#retrofit调用示例)

## 简介
本API参考文档详细描述了油品业务应用中所有公共接口的RESTful API规范。文档涵盖了认证、加油站管理、油品订单、支付订单和油品提货等核心服务。每个API端点都明确了HTTP方法、URL路径、认证要求以及请求和响应的数据模型。数据模型基于g.dart文件中的JSON序列化注解生成，确保类型安全和数据完整性。

**Section sources**
- [auth_service.g.dart](file://lib/global/service/auth_service.g.dart)
- [station_service.g.dart](file://lib/global/service/station_service.g.dart)

## 认证服务
认证服务提供用户注册、登录、令牌刷新和密码管理功能。所有认证相关操作均通过`/auth`前缀的端点进行。

### 登录
用户使用手机号和密码或验证码进行登录。

**端点信息**
- **HTTP方法**: POST
- **URL路径**: `/auth/login`
- **认证要求**: 无需认证

**请求模型: LoginRequest**
- `phone` (string): 手机号，必填
- `password` (string, 可选): 密码
- `code` (string, 可选): 验证码

**响应模型: AuthResponse**
- `accessToken` (string): 访问令牌
- `refreshToken` (string): 刷新令牌
- `account` (Account对象): 用户账户信息
  - `id` (integer): 用户ID
  - `phone` (string): 手机号
  - `name` (string): 用户名
  - `status` (integer): 账户状态

**Section sources**
- [auth_service.g.dart](file://lib/global/service/auth_service.g.dart#L21-L46)
- [auth_req_type.dart](file://lib/global/model/auth_req_type.dart#L44-L59)
- [auth_rep_type.g.dart](file://lib/global/model/auth_rep_type.g.dart#L9-L22)

### 注册
新用户通过手机号、密码、验证码和用户名进行注册。

**端点信息**
- **HTTP方法**: POST
- **URL路径**: `/auth/register`
- **认证要求**: 无需认证

**请求模型: RegisterRequest**
- `phone` (string): 手机号，必填
- `password` (string): 密码，必填
- `code` (string): 验证码，必填
- `name` (string): 用户名，必填
- `referralCode` (string, 可选): 推荐码

**响应模型: AuthResponse**
同登录接口响应模型。

**Section sources**
- [auth_service.g.dart](file://lib/global/service/auth_service.g.dart#L76-L102)
- [auth_req_type.dart](file://lib/global/model/auth_req_type.dart#L6-L27)

### 发送验证码
向指定手机号发送验证码。

**端点信息**
- **HTTP方法**: POST
- **URL路径**: `/auth/send-verification`
- **认证要求**: 无需认证

**请求模型: SendCodeRequest**
- `phone` (string): 手机号，必填
- `type` (string): 验证码类型，必填

**响应模型: 动态类型**
返回服务器响应数据，通常为成功或错误信息。

**Section sources**
- [auth_service.g.dart](file://lib/global/service/auth_service.g.dart#L104-L124)
- [auth_req_type.dart](file://lib/global/model/auth_req_type.dart#L32-L42)

### 刷新令牌
使用刷新令牌获取新的访问令牌。

**端点信息**
- **HTTP方法**: POST
- **URL路径**: `/auth/refresh-token`
- **认证要求**: 无需认证

**请求模型: RefreshTokenRequest**
- `refreshToken` (string): 刷新令牌，必填

**响应模型: AuthResponse**
同登录接口响应模型。

**Section sources**
- [auth_service.g.dart](file://lib/global/service/auth_service.g.dart#L49-L74)
- [auth_req_type.dart](file://lib/global/model/auth_req_type.dart#L63-L71)

### 修改密码
已验证用户修改其密码。

**端点信息**
- **HTTP方法**: POST
- **URL路径**: `/auth/change-password`
- **认证要求**: 无需认证

**请求模型: ChangePasswordRequest**
- `phone` (string): 手机号，必填
- `code` (string): 验证码，必填
- `newPassword` (string): 新密码，必填

**响应模型: 动态类型**
返回服务器响应数据，通常为成功或错误信息。

**Section sources**
- [auth_service.g.dart](file://lib/global/service/auth_service.g.dart#L127-L146)
- [auth_req_type.dart](file://lib/global/model/auth_req_type.dart#L77-L93)

## 加油站服务
加油站服务提供加油站的查询、详情获取、绑定和更新功能。

### 获取加油站列表
根据状态分页查询加油站列表。

**端点信息**
- **HTTP方法**: GET
- **URL路径**: `/stations`
- **认证要求**: Bearer Token

**查询参数**
- `page` (integer): 页码，必填
- `pageSize` (integer): 每页数量，必填
- `statuses` (array of string): 状态列表，必填

**响应模型: GetStationResponse**
- `list` (array of Station对象): 加油站列表
  - `id` (integer): 加油站ID
  - `name` (string): 加油站名称
  - `status` (string): 状态
  - `address` (string): 地址
- `total` (integer): 总数
- `page` (integer): 当前页码
- `pageSize` (integer): 每页数量

**Section sources**
- [station_service.g.dart](file://lib/global/service/station_service.g.dart#L21-L53)
- [station_res_type.g.dart](file://lib/global/model/station_res_type.g.dart)

### 获取加油站详情
获取指定ID的加油站详细信息。

**端点信息**
- **HTTP方法**: GET
- **URL路径**: `/stations/{id}`
- **认证要求**: Bearer Token

**路径参数**
- `id` (integer): 加油站ID

**响应模型: StationDetailResponse**
包含加油站的完整详细信息，包括联系信息、营业时间等。

**Section sources**
- [station_service.g.dart](file://lib/global/service/station_service.g.dart#L56-L80)

### 绑定加油站
用户绑定新的加油站。

**端点信息**
- **HTTP方法**: POST
- **URL路径**: `/stations`
- **认证要求**: Bearer Token

**请求模型: BindStationRequest**
- `stationName` (string): 加油站名称，必填
- `provinceCode` (string): 省份代码，必填
- `provinceName` (string): 省份名称，必填
- `cityCode` (string): 城市代码，必填
- `cityName` (string): 城市名称，必填
- `areaCode` (string): 区域代码，必填
- `areaName` (string): 区域名称，必填
- `addressDetail` (string): 详细地址，必填
- `businessLicenseUrl` (string): 营业执照URL，必填
- `fuelRetailPermitUrl` (string): 成品油零售许可证URL，必填

**响应模型: 动态类型**
返回服务器响应数据，通常为成功或错误信息。

**Section sources**
- [station_service.g.dart](file://lib/global/service/station_service.g.dart#L83-L102)
- [station_req_type.dart](file://lib/global/model/station_req_type.dart#L20-L57)

### 更新加油站信息
更新指定ID的加油站信息。

**端点信息**
- **HTTP方法**: PUT
- **URL路径**: `/stations/{id}`
- **认证要求**: Bearer Token

**路径参数**
- `id` (string): 加油站ID

**请求模型: BindStationRequest**
同绑定加油站请求模型。

**响应模型: 动态类型**
返回服务器响应数据，通常为成功或错误信息。

**Section sources**
- [station_service.g.dart](file://lib/global/service/station_service.g.dart#L105-L124)

### 更新加油站发票信息
更新指定ID的加油站发票信息。

**端点信息**
- **HTTP方法**: PUT
- **URL路径**: `/stations/{id}/invoice`
- **认证要求**: Bearer Token

**路径参数**
- `id` (integer): 加油站ID

**请求模型: UpdateInvoiceRequest**
- `invoiceTitle` (string): 发票抬头，必填
- `taxNumber` (string): 纳税人识别号，必填
- `bankName` (string): 开户银行，必填
- `bankAccount` (string): 银行账号，必填
- `address` (string): 地址，必填
- `phoneNumber` (string): 电话号码，必填

**响应模型: 动态类型**
返回服务器响应数据，通常为成功或错误信息。

**Section sources**
- [station_service.g.dart](file://lib/global/service/station_service.g.dart#L127-L149)

## 油品订单服务
油品订单服务提供油库列表查询和油品订单创建功能。

### 获取油库列表
分页查询可用油库列表。

**端点信息**
- **HTTP方法**: GET
- **URL路径**: `/oil-depots`
- **认证要求**: Bearer Token

**查询参数**
- `page` (integer): 页码，必填
- `pageSize` (integer): 每页数量，必填

**响应模型: GetOilStoreResponse**
- `list` (array of Depot对象): 油库列表
  - `depotId` (integer): 油库ID
  - `depotName` (string): 油库名称
  - `provinceCode` (string): 省份代码
  - `provinceName` (string): 省份名称
  - `cityCode` (string): 城市代码
  - `cityName` (string): 城市名称
  - `areaCode` (string): 区域代码
  - `areaName` (string): 区域名称
  - `addressDetail` (string): 详细地址
  - `fuels` (array of Fuel对象): 可用油品列表
    - `fuelType` (string): 油品类型
    - `priceCny` (number): 人民币价格
- `total` (integer): 总数
- `page` (integer): 当前页码
- `pageSize` (integer): 每页数量

**Section sources**
- [oil_order_service.g.dart](file://lib/pages/main_oil_pay/service/oil_order_service.g.dart#L21-L48)
- [oil_order_res.type.g.dart](file://lib/pages/main_oil_pay/model/oil_order_res.type.g.dart#L9-L26)

### 创建油品订单
创建新的油品购买订单。

**端点信息**
- **HTTP方法**: POST
- **URL路径**: `/oil-orders`
- **认证要求**: Bearer Token

**请求模型: OilOrderRequest**
- `depotId` (integer): 油库ID，必填
- `fuelType` (string): 油品类型，必填
- `purchaseTon` (string): 购买吨数，必填
- `remark` (string, 可选): 备注

**响应模型: void**
成功时无返回内容，HTTP状态码为200。

**Section sources**
- [oil_order_service.g.dart](file://lib/pages/main_oil_pay/service/oil_order_service.g.dart#L51-L68)
- [oil_order_req_type.dart](file://lib/pages/main_oil_pay/model/oil_order_req_type.dart#L2-L28)

## 支付订单服务
支付订单服务提供支付订单详情查询和支付凭证保存功能。

### 获取支付订单详情
获取指定ID的支付订单详细信息。

**端点信息**
- **HTTP方法**: GET
- **URL路径**: `/oil-orders/{id}`
- **认证要求**: Bearer Token

**路径参数**
- `id` (string): 订单ID

**响应模型: OrderModel**
包含订单的完整详细信息，包括订单号、金额、状态、创建时间等。

**Section sources**
- [pay_order_service.g.dart](file://lib/pages/pay_order_detail/service/pay_order_service.g.dart#L21-L45)

### 保存支付凭证
为指定订单保存支付凭证。

**端点信息**
- **HTTP方法**: POST
- **URL路径**: `/oil-orders/{id}/payment-proof`
- **认证要求**: Bearer Token

**路径参数**
- `id` (string): 订单ID

**请求模型: PaymentProofRequest**
- `proof` (array of string): 支付凭证图片URL列表，必填

**响应模型: void**
成功时无返回内容，HTTP状态码为200。

**Section sources**
- [pay_order_service.g.dart](file://lib/pages/pay_order_detail/service/pay_order_service.g.dart#L48-L65)
- [payment_proof_request.g.dart](file://lib/pages/pay_order_detail/model/payment_proof_request.g.dart#L9-L18)

## 油品提货服务
油品提货服务提供提货订单管理、库存查询和提货操作功能。

### 获取提货订单列表
分页查询提货订单列表，可按状态过滤。

**端点信息**
- **HTTP方法**: GET
- **URL路径**: `/inventories/withdraws`
- **认证要求**: Bearer Token

**查询参数**
- `status` (string, 可选): 订单状态
- `page` (integer): 页码，必填
- `pageSize` (integer): 每页数量，必填

**响应模型: WithdrawOrderListResponse**
- `list` (array of WithdrawOrderModel对象): 提货订单列表
- `total` (integer): 总数
- `page` (integer): 当前页码
- `pageSize` (integer): 每页数量

**Section sources**
- [oil_pickup_service.g.dart](file://lib/pages/oil_pickup/service/oil_pickup_service.g.dart#L21-L54)
- [withdraw_data.g.dart](file://lib/pages/oil_pickup/model/withdraw_data.g.dart#L9-L27)

### 提交提货申请
为指定订单提交提货申请。

**端点信息**
- **HTTP方法**: POST
- **URL路径**: `/inventories/{orderId}/withdraw`
- **认证要求**: Bearer Token

**路径参数**
- `orderId` (integer): 订单ID

**请求模型: WithdrawRequest**
- `withdrawTon` (number): 提货吨数，必填
- `stationId` (integer): 加油站ID，必填
- `vehicleInfo` (string): 车辆信息，必填

**响应模型: WithdrawResponse**
- `withdrawId` (integer): 提货ID
- `withdrawNo` (string): 提货单号
- `remainingTon` (number): 剩余可提货吨数
- `status` (string): 状态
- `message` (string): 消息

**Section sources**
- [oil_pickup_service.g.dart](file://lib/pages/oil_pickup/service/oil_pickup_service.g.dart#L57-L85)
- [withdraw_data.g.dart](file://lib/pages/oil_pickup/model/withdraw_data.g.dart#L92-L104)

### 获取提货订单详情
获取指定ID的提货订单详细信息。

**端点信息**
- **HTTP方法**: GET
- **URL路径**: `/inventories/withdraws/{withdrawId}`
- **认证要求**: Bearer Token

**路径参数**
- `withdrawId` (integer): 提货ID

**响应模型: WithdrawOrderModel**
- `withdrawId` (integer): 提货ID
- `withdrawNo` (string): 提货单号
- `withdrawTon` (number): 提货吨数
- `fuelType` (string): 油品类型
- `vehicleInfo` (string): 车辆信息
- `status` (string): 状态
- `createdAt` (string): 创建时间
- `updatedAt` (string): 更新时间
- `station` (StationInfo对象): 加油站信息
- `depot` (DepotInfo对象): 油库信息

**Section sources**
- [oil_pickup_service.g.dart](file://lib/pages/oil_pickup/service/oil_pickup_service.g.dart#L88-L112)
- [withdraw_data.g.dart](file://lib/pages/oil_pickup/model/withdraw_data.g.dart#L60-L91)

### 获取库存列表
分页查询可用库存列表。

**端点信息**
- **HTTP方法**: GET
- **URL路径**: `/inventories`
- **认证要求**: Bearer Token

**查询参数**
- `page` (integer): 页码，必填
- `pageSize` (integer): 每页数量，必填

**响应模型: InventoryListResponse**
- `list` (array of InventoryModel对象): 库存列表
  - `inventoryId` (integer): 库存ID
  - `depotId` (integer): 油库ID
  - `depotName` (string): 油库名称
  - `fuelType` (string): 油品类型
  - `availableTon` (number): 可用吨数
  - `updatedAt` (string): 更新时间
- `total` (integer): 总数
- `page` (integer): 当前页码
- `pageSize` (integer): 每页数量

**Section sources**
- [oil_pickup_service.g.dart](file://lib/pages/oil_pickup/service/oil_pickup_service.g.dart#L115-L145)
- [withdraw_data.g.dart](file://lib/pages/oil_pickup/model/withdraw_data.g.dart#L124-L135)

### 取消提货申请
取消指定的提货申请。

**端点信息**
- **HTTP方法**: POST
- **URL路径**: `/inventories/withdraws/{withdrawId}/cancel`
- **认证要求**: Bearer Token

**路径参数**
- `withdrawId` (integer): 提货ID

**响应模型: void**
成功时无返回内容，HTTP状态码为200。

**Section sources**
- [oil_pickup_service.g.dart](file://lib/pages/oil_pickup/service/oil_pickup_service.g.dart#L148-L164)

## 错误处理机制
API采用统一的错误响应格式，便于客户端处理各种错误情况。

### 标准错误响应格式
所有API错误响应均遵循以下格式：

```json
{
  "message": "错误消息",
  "code": 1001,
  "data": null
}
```

**字段说明**
- `message` (string): 人类可读的错误描述
- `code` (integer): 机器可读的错误代码
- `data` (any): 附加数据，通常为null

### 常见HTTP状态码
- **200 OK**: 请求成功
- **400 Bad Request**: 请求参数错误
- **401 Unauthorized**: 未授权，需要有效令牌
- **403 Forbidden**: 禁止访问，权限不足
- **404 Not Found**: 资源未找到
- **429 Too Many Requests**: 请求过于频繁
- **500 Internal Server Error**: 服务器内部错误
- **503 Service Unavailable**: 服务不可用

### 常见错误代码
- **1001**: 无效的请求参数
- **1002**: 用户未找到
- **1003**: 认证失败
- **1004**: 权限不足
- **1005**: 资源已存在
- **1006**: 资源不存在
- **1007**: 业务逻辑错误
- **1008**: 系统维护中

**Section sources**
- [common_response_type.g.dart](file://lib/global/model/common_response_type.g.dart#L9-L21)
- [api_exception.dart](file://lib/net/api_exception.dart)

## Retrofit调用示例
以下是使用Retrofit进行类型安全API调用的代码示例。

### 服务接口定义
```dart
@RestApi(baseUrl: "/api")
abstract class OilApiService {
  factory OilApiService(Dio dio, {String? baseUrl}) = _OilApiService;
  
  @POST("/auth/login")
  Future<AuthResponse> login(@Body() LoginRequest request);
  
  @GET("/stations")
  Future<GetStationResponse> getStations(
    @Query("page") int page,
    @Query("pageSize") int pageSize,
    @Query("statuses") List<String> statuses,
  );
  
  @POST("/oil-orders")
  Future<void> createOilOrder(@Body() OilOrderRequest request);
}
```

### 服务调用示例
```dart
// 初始化Dio客户端
final dio = Dio(BaseOptions(
  baseUrl: 'https://api.oil-business.com',
  connectTimeout: const Duration(seconds: 10),
  receiveTimeout: const Duration(seconds: 10),
));

// 创建API服务实例
final apiService = OilApiService(dio);

// 调用登录API
try {
  final loginRequest = LoginRequest(
    phone: "13800138000",
    password: "password123",
  );
  
  final authResponse = await apiService.login(loginRequest);
  print("登录成功: ${authResponse.account?.name}");
} on DioException catch (e) {
  // 处理网络错误
  print("网络错误: ${e.message}");
} on FormatException catch (e) {
  // 处理JSON解析错误
  print("数据解析错误: ${e.message}");
}
```

**Section sources**
- [net_manager.dart](file://lib/net/net_manager.dart)
- [auth_service.g.dart](file://lib/global/service/auth_service.g.dart)