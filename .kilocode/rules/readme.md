# 彩票赠送管理应用

一款为代理商提供的彩票赠送管理Flutter应用，帮助餐饮、本地生活等行业商户通过赠送彩票的方式吸引顾客消费和充值。

## 📱 项目概述

本应用采用B2B2C模式，代理商通过购买彩票权益，生成二维码赠送给消费者，消费者扫码后在独立H5应用中领取彩票。解决了传统线下购票赠送的地域限制和操作不便问题。

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

## ✨ 主要功能

- **📊 数据仪表盘** - 赠送统计、趋势分析
- **💰 充值管理** - 套餐购买、余额充值、多种支付方式
- **🎫 彩票赠送** - 静态/动态二维码生成
- **📋 记录管理** - 赠送记录查询、Excel导出
- **👥 员工管理** - 多角色权限管理
- **⚙️ 个人中心** - 账户设置、API对接（规划中）

## 🛠️ 技术栈

- **框架**: Flutter (跨平台)
- **状态管理**: BLOC模式
- **网络请求**: Dio + Retrofit
- **国际化**: Easy Localization
- **路由管理**: Go Router
- **代码生成**: Freezed + JSON Serializable

## 👤 用户角色

- **普通员工**: 基础功能访问，不可充值和导出
- **管理员**: 员工权限 + 禁用员工权限  
- **老板**: 完整权限，包括员工管理和系统配置

## 📖 相关文档

- [详细开发文档](.cursor/rules/develop.mdc) - 完整的项目说明和开发规范
- [网络问题解决方案](网络连接问题解决方案.md) - 开发环境网络配置
- [镜像源配置说明](镜像源配置说明.md) - Flutter环境配置

## 📄 许可证

本项目为商业项目，仅供内部开发使用。

