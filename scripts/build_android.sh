#!/bin/bash
# 使用方式：./build_android.sh <渠道> <分支> <build number> <http env>
set -e

ver=`grep -m 1 '^version:' pubspec.yaml | awk '{print $2}'`
ver=${ver##'version: '}

echo "$1"
echo "> Check version from 'pubspec.yaml': '$ver'."
# 添加pub token（如果需要）
# echo "eYTzX3Ti4wpQO085" | flutter pub token add https://dart.cloudsmith.io/flutter-qsfx/flutter-package/
# echo "hZSSW9kMbY5ti7zI" | flutter pub token add https://dart.cloudsmith.io/workspace-for-wai-loon/sportsdk_package/

android() {
  echo "> Now begin building apk."
  echo "安卓渠道 $1"
  echo "分支 $2"
  echo "build number $3"
  echo "http env $4"
  # [--target-platform android-arm]: 指定构建 ARM 架构
  # [--shrink] 代码压缩
  # [--obfuscate] 代码混淆
  # [--split-debug-info=./build/debuginfo] 指定调试信息目录，进一步减小包大小
  # flutter build apk --dart-define=ANDROID_CHANNEL=$1  --shrink --obfuscate --split-debug-info=./build/debuginfo

  flutter build apk --no-tree-shake-icons --flavor $1 --dart-define=ANDROID_CHANNEL=$1 --dart-define=BUILD_NUMBER=$3 --dart-define=HTTP_ENV=$4
   # 检查构建是否成功
  if [ $? -ne 0 ]; then
    echo "Error: Export failed."
    exit 1
  fi

  # 移动并重命名生成的 APK 文件
  apk_name='oil_business_app';
  # 判断 $2 是否等于 1
  # if [ "$2" = "false" ]; then
      time=$(date "+%y%m%d")
      new_branch=${2//\//_}
      apk_name="oil_business_app_${ver}_$3_$4"
  # else
  #     apk_name="oil_business_app_${ver}"
  # fi
  echo $apk_name
  apk_path="./build/app/outputs/flutter-apk/app-$1-release.apk"
  if [ -f "$apk_path" ]; then
    # 创建输出目录（如果不存在）
    mkdir -p "./dist/android"
    mv "$apk_path" "./dist/android/${apk_name}.apk"
    echo "> Built Android done. './dist/android/${apk_name}.apk'"
  else
    echo "Error: APK file not found at $apk_path"
    exit 1
  fi

}


# pub() {
  # Step 3: Copy the new build to the server
  # echo "开始复制资源文件"
  # scp -v -o StrictHostKeyChecking=no -i ${centos} -r ./dist/'sports_'$time'_'$ver'.apk' centos@ec2-16-163-214-1.ap-east-1.compute.amazonaws.com:/home/app/android
# }

android $1 $2 $3 $4

# echo "centos:${centos}"
# if [ -f ${centos} ]; then
#   # pub
# fi
