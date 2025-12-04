# Design Document: Invoice Edit Page

## Overview

本设计文档描述了加油站发票信息编辑页面的技术实现方案。该功能允许用户从加油站管理列表或加油站详情页进入发票编辑页面，补充或修改加油站的发票信息。

系统采用 Flutter + BLoC 架构模式，遵循项目现有的页面结构（page.dart, view.dart, controller.dart, state.dart），通过 Retrofit 调用后端 API 进行数据持久化。

## Architecture

```mermaid
graph TB
    subgraph UI Layer
        SML[StationManagementList]
        SED[StationEditPage]
        IEP[InvoiceEditPage]
    end
    
    subgraph State Management
        IEC[InvoiceEditCtrl]
        IES[InvoiceEditState]
    end
    
    subgraph Service Layer
        SS[StationService]
    end
    
    subgraph Network Layer
        NM[NetManager]
        API[Backend API]
    end
    
    SML -->|navigate with stationId| IEP
    SED -->|navigate with stationId| IEP
    IEP --> IEC
    IEC --> IES
    IEC --> SS
    SS --> NM
    NM --> API
```

## Components and Interfaces

### 1. InvoiceEditPage (page.dart)

页面入口组件，负责接收路由参数并初始化 BLoC。

```dart
class InvoiceEditPage extends BasePage {
  const InvoiceEditPage({Key? key}) : super(key: key);
}
```

路由参数：
- `stationId` (int, required): 加油站ID
- `invoice` (InvoiceInfo?, optional): 已有的发票信息，用于预填充表单

### 2. InvoiceEditCtrl (controller.dart)

业务逻辑控制器，继承自 Cubit<InvoiceEditState>。

```dart
class InvoiceEditCtrl extends Cubit<InvoiceEditState> {
  InvoiceEditCtrl({required int stationId, InvoiceInfo? invoice});
  
  void updateInvoiceTitle(String value);
  void updateTaxNumber(String value);
  void updateBankName(String value);
  void updateBankAccount(String value);
  void updateCompanyAddress(String value);
  void updateCompanyPhone(String value);
  void updateInvoiceType(String value);
  
  Future<bool> save(BuildContext context);
  bool validate();
}
```

### 3. InvoiceEditState (state.dart)

状态管理类，存储表单数据和UI状态。

```dart
class InvoiceEditState {
  final int stationId;
  final String invoiceTitle;
  final String taxNumber;
  final String bankName;
  final String bankAccount;
  final String companyAddress;
  final String companyPhone;
  final String invoiceType;
  final bool isLoading;
  final bool hasError;
  final String? errorMessage;
}
```

### 4. InvoiceEditForm (widgets/invoice_edit_form.dart)

表单UI组件，包含所有输入字段和保存按钮。

### 5. StationService 扩展

在现有 StationService 中添加发票相关接口：

```dart
/// 更新加油站发票信息
@PUT('/stations/{id}/invoice')
Future updateStationInvoice(
  @Path('id') int id,
  @Body() UpdateInvoiceRequest request,
);
```

### 6. 数据模型

```dart
// 发票信息模型
@JsonSerializable()
class InvoiceInfo {
  final String? invoiceTitle;
  final String? taxNumber;
  final String? bankName;
  final String? bankAccount;
  final String? companyAddress;
  final String? companyPhone;
  final String? invoiceType;
}

// 更新发票请求模型
@JsonSerializable()
class UpdateInvoiceRequest {
  final String invoiceTitle;
  final String taxNumber;
  final String bankName;
  final String bankAccount;
  final String companyAddress;
  final String companyPhone;
  final String invoiceType;
}
```

## Data Models

### InvoiceInfo

| 字段 | 类型 | 描述 | 验证规则 |
|------|------|------|----------|
| invoiceTitle | String | 发票抬头 | 非空 |
| taxNumber | String | 税号 | 非空，15-20位字母数字 |
| bankName | String | 开户银行 | 非空 |
| bankAccount | String | 银行账号 | 非空，纯数字 |
| companyAddress | String | 公司地址 | 非空 |
| companyPhone | String | 公司电话 | 非空，有效电话格式 |
| invoiceType | String | 发票类型 | 枚举值：special_vat, normal_vat |

### InvoiceType 枚举

| 值 | 显示名称 |
|----|----------|
| special_vat | 增值税专用发票 |
| normal_vat | 增值税普通发票 |

## Correctness Properties

*A property is a characteristic or behavior that should hold true across all valid executions of a system-essentially, a formal statement about what the system should do. Properties serve as the bridge between human-readable specifications and machine-verifiable correctness guarantees.*

### Property 1: Station ID Parameter Initialization
*For any* valid station ID, when InvoiceEditPage is initialized with that station ID, the state SHALL contain the same station ID value.
**Validates: Requirements 1.2, 2.2**

### Property 2: Invoice Data Pre-population
*For any* existing invoice data, when InvoiceEditPage loads with that data, all form fields SHALL be populated with the corresponding values from the invoice data.
**Validates: Requirements 1.3**

### Property 3: Form Field Validation
*For any* form input values, the validation function SHALL return true only when all required fields are non-empty AND tax number matches the valid format AND bank account contains only digits AND phone number matches valid format.
**Validates: Requirements 3.2, 3.3, 3.4, 3.5**

### Property 4: API Request Data Integrity
*For any* valid form state, when save is called, the API request body SHALL contain all form field values exactly as stored in the state.
**Validates: Requirements 4.1**

## Error Handling

### 验证错误

| 错误场景 | 错误消息 |
|----------|----------|
| 发票抬头为空 | 请输入发票抬头 |
| 税号为空 | 请输入税号 |
| 税号格式无效 | 税号格式不正确 |
| 开户银行为空 | 请输入开户银行 |
| 银行账号为空 | 请输入银行账号 |
| 银行账号非数字 | 银行账号格式不正确 |
| 公司地址为空 | 请输入公司地址 |
| 公司电话为空 | 请输入公司电话 |
| 公司电话格式无效 | 电话号码格式不正确 |

### 网络错误

| 错误场景 | 处理方式 |
|----------|----------|
| 网络超时 | 显示"网络超时，请稍后重试"提示 |
| 服务器错误 | 显示"保存失败，请稍后重试"提示 |
| 未授权 | 跳转到登录页面 |

## Testing Strategy

### 单元测试

1. **验证器测试**
   - 测试 InvoiceValidator 各字段验证逻辑
   - 覆盖有效输入和无效输入场景

2. **Controller 测试**
   - 测试状态更新方法
   - 测试 validate() 方法
   - 测试 save() 方法（使用 mock service）

### 属性测试

使用 `dart_quickcheck` 或 `glados` 库进行属性测试：

1. **Property 1 测试**: 生成随机 station ID，验证初始化后状态正确
2. **Property 2 测试**: 生成随机 InvoiceInfo，验证表单预填充正确
3. **Property 3 测试**: 生成随机表单输入，验证验证逻辑一致性
4. **Property 4 测试**: 生成随机有效表单状态，验证 API 请求数据完整性

### 测试框架

- 单元测试: `flutter_test`
- 属性测试: `glados` (Dart property-based testing library)
- Mock: `mocktail`

### 测试配置

每个属性测试运行至少 100 次迭代以确保覆盖边界情况。
