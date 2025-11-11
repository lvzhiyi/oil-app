# 买油呗

一款为加油站提供的采购汽油管理的app项目，主要面向加油站向油库采购汽油

## 🚀 快速开始

### 环境要求
- Flutter SDK
- Dart SDK
- Android Studio / Xcode

### 安装依赖
```bash
# 安装rps工具
dart pub global activate rps --version 0.8.0

# 安装项目依赖
flutter pub get
```

### 运行项目
```bash
# 命令行启动（支持多渠道）
flutter run --flavor oppo
flutter run --flavor vivo  
flutter run --flavor xiaomi

# 或使用VSCode task任务启动
```

## 🛠️ 技术栈

- **框架**: Flutter (跨平台)
- **状态管理**: BLOC模式
- **网络请求**: Dio + Retrofit
- **国际化**: Easy Localization
- **路由管理**: Go Router
- **代码生成**: Freezed + JSON Serializable

## 📡 API数据结构

### 标准数据格式

#### 请求格式
所有API接口请求都采用标准JSON格式：
- **Content-Type**: `application/json;charset=UTF-8`
- **请求体**: 标准JSON对象
- **字符编码**: UTF-8

```json
{
  "field1": "value1",
  "field2": "value2",
  "nested_object": {
    "sub_field": "sub_value"
  }
}
```

#### 响应格式
所有API接口都遵循统一的响应数据结构：

```json
{
  "code": 1,           // 状态码，200表示成功
  "message": "success",  // 响应消息
  "data": {}             // 具体业务数据
}
```

### 认证相关接口

#### 登录接口
- **路径**: `POST /auths/login`
- **请求参数**:
```json
{
  "phone": "手机号",
  "password": "密码"
}
```
- **响应数据**:
```json
{
  "code": 200,
  "message": "success",
  "data": {
    "access_token": "用户的access_token",
    "refresh_token": "用户的refresh_token", 
    "用户信息字段": "..."
  }
}
```

#### Token刷新接口
- **路径**: `POST /auths/refresh`
- **请求参数**:
```json
{
  "refresh_token": "用户的refresh_token"
}
```
- **响应数据**:
```json
{
  "code": 1,
  "message": "success",
  "data": {
    "access_token": "new_access_token",
    "refresh_token": "new_refresh_token"
  }
}
```

#### 退出登录接口
- **路径**: `POST /auths/logout`
- **响应数据**:
```json
{
  "code": 1,
  "message": "success",
  "data": null
}
```

### 双Token机制

项目采用双Token安全机制：

- **access_token**: 用于API访问的短期令牌，携带在请求头中
- **refresh_token**: 用于刷新access_token的长期令牌
- **自动刷新**: 当access_token过期时，自动使用refresh_token获取新的双token
- **安全退出**: 退出登录时清除本地存储的所有认证信息

### 接口基础配置

- **开发/测试环境**: `https://test.maiyoubei.com/api/app`
- **生产环境**: 待配置
- **请求格式**: 标准JSON格式 (与web开发一致)
- **响应格式**: 统一JSON格式 (code、message、data三字段结构)
- **Content-Type**: `application/json;charset=UTF-8`
- **认证方式**: Bearer Token (在请求头中携带)
- **字符编码**: UTF-8

## 👤 用户角色

- **普通员工**: 基础功能访问，不可充值和导出
- **管理员**: 员工权限 + 禁用员工权限  
- **老板**: 完整权限，包括员工管理和系统配置

## 📄 许可证

本项目为商业项目，仅供内部开发使用。

