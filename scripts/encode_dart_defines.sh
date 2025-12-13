#!/bin/bash

# 辅助脚本：生成 HTTP_ENV 的 base64 编码值，用于添加到 Xcode 的 DART_DEFINES 中
# 使用方法：./encode_dart_defines.sh <HTTP_ENV值>
# 示例：./encode_dart_defines.sh 1  (生产环境)
#       ./encode_dart_defines.sh 3  (测试环境)

if [ -z "$1" ]; then
  echo "使用方法: $0 <HTTP_ENV值>"
  echo "示例: $0 1  (生产环境)"
  echo "      $0 3  (测试环境)"
  exit 1
fi

HTTP_ENV_VALUE=$1
ENCODED=$(echo -n "HTTP_ENV=$HTTP_ENV_VALUE" | base64)

echo "=========================================="
echo "HTTP_ENV=$HTTP_ENV_VALUE 的 base64 编码值："
echo "=========================================="
echo "$ENCODED"
echo ""
echo "使用方法："
echo "1. 在 Xcode 中打开 Build Settings"
echo "2. 找到 DART_DEFINES 设置"
echo "3. 在现有值的末尾添加逗号和上面的编码值"
echo "   例如：现有值,$ENCODED"
echo ""
echo "或者直接使用以下完整值（包含所有现有定义）："
echo "（需要手动将上面的编码值添加到现有的 DART_DEFINES 中）"

