# Framework

构建静态framework

## Setting

`Build Setting` -> `Mach-O Type` 设置为`Static-Library`

`Build Phases` -> `Headers` 添加暴露给外部的头文件

# Building

构建多Architecture包:

```bash
#!/bin/sh

PROJECT_NAME="Framework Name"
CONFIGURATION="Release"
BUILD_DIR="build"

BUILD_FLAGS="-target ${PROJECT_NAME} -configuration ${CONFIGURATION} BUILD_DIR=${BUILD_DIR} clean build"

function lipoFramework() {
    rm -r -f $1.framework

    cp -r "${BUILD_DIR}/${CONFIGURATION}-iphoneos/$1.framework" .

    lipo -create -output "$1.framework/$1" "${BUILD_DIR}/${CONFIGURATION}-iphonesimulator/$1.framework/$1" "${BUILD_DIR}/${CONFIGURATION}-iphoneos/$1.framework/$1"
}

xcodebuild -sdk iphoneos ${BUILD_FLAGS}
xcodebuild -sdk iphonesimulator ${BUILD_FLAGS}

lipoFramework "${PROJECT_NAME}"

rm -r -f ${BUILD_DIR}

```
