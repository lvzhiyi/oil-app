#!/bin/bash

# APK文件上传到OSS脚本
# 使用方法: ./upload_oss.sh <文件路径> <文件名> [环境]

# 配置信息
RELEASE_OSS_KEY="fRwNQqnS0Lkfk4FRmobqT3kL"
LOG_FILE="scripts/upload_log.txt"

# 根据环境参数设置域名
ENV=${3:-dev}  # 默认为dev环境

if [ "$ENV" = "pro" ]; then
    BASE_URL="https://sszc.quicksales.cn"
else
    BASE_URL="https://dev-lyjk.quicksales.cn"
fi

UPLOAD_URL="$BASE_URL/api/lottery-platform/files/release"
SIGN_URL="$BASE_URL/api/lottery-client/files/sign-url"

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 日志函数
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# 写入日志文件函数
write_log() {
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    echo "[$timestamp] $1" >> "$LOG_FILE"
}

# 确保日志目录存在
mkdir -p "$(dirname "$LOG_FILE")"

# 检查参数
if [ $# -lt 2 ] || [ $# -gt 3 ]; then
    echo "使用方法: $0 <文件路径> <文件名> [环境]"
    echo "示例: $0 ./dist/android/oil_business_app.apk oil_business_app.apk"
    echo "示例: $0 ./dist/android/oil_business_app.apk oil_business_app.apk pro"
    echo ""
    echo "参数说明:"
    echo "  文件路径: APK文件的完整路径"
    echo "  文件名: 上传到OSS后的文件名"
    echo "  环境: dev(默认) 或 pro"
    exit 1
fi

FILE_PATH="$1"
FILE_NAME="$2"

# 检查文件是否存在
if [ ! -f "$FILE_PATH" ]; then
    log_error "文件 '$FILE_PATH' 不存在"
    exit 1
fi

# 检查文件扩展名
if [[ ! "$FILE_NAME" =~ \.apk$ ]]; then
    log_warning "文件名 '$FILE_NAME' 不是APK格式，请确认是否正确"
fi

# 获取文件大小
FILE_SIZE=$(stat -f%z "$FILE_PATH" 2>/dev/null || stat -c%s "$FILE_PATH" 2>/dev/null)
FILE_SIZE_MB=$(echo "scale=2; $FILE_SIZE / 1024 / 1024" | bc 2>/dev/null || echo "未知")

log_info "开始上传APK文件..."
log_info "文件路径: $FILE_PATH"
log_info "文件名: $FILE_NAME"
log_info "文件大小: $FILE_SIZE 字节 ($FILE_SIZE_MB MB)"
log_info "环境: $ENV"
log_info "上传地址: $UPLOAD_URL"

# 检查网络连接
if ! curl -s --connect-timeout 5 "$UPLOAD_URL" > /dev/null; then
    log_error "无法连接到上传服务器，请检查网络连接"
    exit 1
fi

# 使用curl上传文件
log_info "正在上传，请稍候..."

RESPONSE=$(curl -s \
    -X POST \
    -H "x-oss-key:$RELEASE_OSS_KEY" \
    -H "Content-Type: multipart/form-data" \
    -F "fileType=bin" \
    -F "method=put" \
    -F "file=@$FILE_PATH;filename=$FILE_NAME" \
    -w "\nHTTP_STATUS:%{http_code}\nTIME:%{time_total}s\nSIZE:%{size_upload}bytes" \
    --connect-timeout 30 \
    --max-time 300 \
    "$UPLOAD_URL")

# 分离响应内容、HTTP状态码和其他信息
HTTP_CODE=$(echo "$RESPONSE" | grep "HTTP_STATUS:" | cut -d: -f2)
UPLOAD_TIME=$(echo "$RESPONSE" | grep "TIME:" | cut -d: -f2)
UPLOAD_SIZE=$(echo "$RESPONSE" | grep "SIZE:" | cut -d: -f2)
RESPONSE_BODY=$(echo "$RESPONSE" | grep -v "HTTP_STATUS:" | grep -v "TIME:" | grep -v "SIZE:")

echo ""
log_info "上传完成!"
log_info "HTTP状态码: $HTTP_CODE"
log_info "上传耗时: ${UPLOAD_TIME}秒"
log_info "实际上传大小: ${UPLOAD_SIZE}字节"

if [ -n "$RESPONSE_BODY" ]; then
    log_info "响应内容: $RESPONSE_BODY"
fi

# 检查上传结果
if [ "$HTTP_CODE" -eq 200 ] || [ "$HTTP_CODE" -eq 201 ]; then
    log_success "APK文件上传成功!"
    log_info "文件已成功上传到OSS"
		write_log "下载地址响应: $SIGN_RESPONSE_BODY"
    # 解析响应中的data.path字段
    # if [ -n "$RESPONSE_BODY" ]; then
    #     # 尝试从响应中提取data.path
    #     FILE_PATH_FROM_RESPONSE=$(echo "$RESPONSE_BODY" | grep -o '"data":\s*{[^}]*}' | grep -o '"path":\s*"[^"]*"' | cut -d'"' -f4)

    #     if [ -n "$FILE_PATH_FROM_RESPONSE" ]; then
    #         log_info "从响应中获取到文件路径: $FILE_PATH_FROM_RESPONSE"

    #         # 调用新接口获取真实下载地址
    #         log_info "正在获取真实下载地址..."

    #         SIGN_RESPONSE=$(curl -s \
    #             -X GET \
    #             -w "\nHTTP_STATUS:%{http_code}\nTIME:%{time_total}s" \
    #             --connect-timeout 30 \
    #             --max-time 60 \
    #             "$SIGN_URL?filePath=$FILE_PATH_FROM_RESPONSE")

    #         SIGN_HTTP_CODE=$(echo "$SIGN_RESPONSE" | grep "HTTP_STATUS:" | cut -d: -f2)
    #         SIGN_TIME=$(echo "$SIGN_RESPONSE" | grep "TIME:" | cut -d: -f2)
    #         SIGN_RESPONSE_BODY=$(echo "$SIGN_RESPONSE" | grep -v "HTTP_STATUS:" | grep -v "TIME:")

    #         log_info "获取下载地址完成!"
    #         log_info "HTTP状态码: $SIGN_HTTP_CODE"
    #         log_info "请求耗时: ${SIGN_TIME}秒"

    #         if [ -n "$SIGN_RESPONSE_BODY" ]; then
    #             log_info "下载地址响应: $SIGN_RESPONSE_BODY"
    #         fi

    #                     if [ "$SIGN_HTTP_CODE" -eq 200 ] || [ "$SIGN_HTTP_CODE" -eq 201 ]; then
    #             log_success "成功获取真实下载地址!"

    #             # 记录上传成功结果到日志文件
    #             write_log "上传成功: $FILE_NAME | 环境: $ENV | 文件大小: $FILE_SIZE_MB MB | 上传耗时: ${UPLOAD_TIME}秒 | 获取下载地址: 成功"

    #             # 记录下载地址响应结果
    #             if [ -n "$SIGN_RESPONSE_BODY" ]; then
    #                 write_log "下载地址响应: $SIGN_RESPONSE_BODY"
    #             fi
    #         else
    #             log_warning "获取真实下载地址失败，HTTP状态码: $SIGN_HTTP_CODE"

    #             # 记录上传成功但获取下载地址失败的结果
    #             write_log "上传成功: $FILE_NAME | 环境: $ENV | 文件大小: $FILE_SIZE_MB MB | 上传耗时: ${UPLOAD_TIME}秒 | 获取下载地址: 失败(HTTP:$SIGN_HTTP_CODE)"

    #             # 记录失败时的响应内容
    #             if [ -n "$SIGN_RESPONSE_BODY" ]; then
    #                 write_log "失败响应: $SIGN_RESPONSE_BODY"
    #             fi
    #         fi
    #     else
    #         log_warning "无法从响应中解析出data.path字段"
    #         log_info "响应内容: $RESPONSE_BODY"

    #         # 记录上传成功但无法解析路径的结果
    #         write_log "上传成功: $FILE_NAME | 环境: $ENV | 文件大小: $FILE_SIZE_MB MB | 上传耗时: ${UPLOAD_TIME}秒 | 获取下载地址: 失败(无法解析路径)"
    #     fi
    # fi

    exit 0
else
    log_error "APK文件上传失败，HTTP状态码: $HTTP_CODE"
    echo ""
    log_info "可能的原因："
    case $HTTP_CODE in
        400) echo "  - 请求参数错误，请检查文件格式和参数" ;;
        401) echo "  - 认证失败，请检查RELEASE_OSS_KEY是否正确" ;;
        403) echo "  - 权限不足，请联系管理员" ;;
        404) echo "  - 上传接口不存在，请检查URL" ;;
        413) echo "  - 文件太大，超过服务器限制" ;;
        500) echo "  - 服务器内部错误，请稍后重试" ;;
        502|503|504) echo "  - 服务器暂时不可用，请稍后重试" ;;
        *) echo "  - 其他错误，请检查服务器日志" ;;
    esac
    exit 1
fi