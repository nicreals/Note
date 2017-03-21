# Framework

构建静态framework

## Setting

`Build Setting` -> `Mach-O Type` 设置为`Static-Library`

`Build Phases` -> `Headers` 添加暴露给外部的头文件

如果framework中含有category，在`Build Setting` -> `Other Linker Flag`中添加 `-ObjC`

## Building

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

## 模块化设计

将项目按业务分成若干模块，并包装成静态framework集成到主工程中

- 资源文件需要放在主模块中以便调用，包括第三方库的bundle

- `other warning flags`加入`-Wno-incomplete-umbrella`屏蔽头文件暴露警告

- 由于业务模块是静态framework，需要编译业务模块后，更改的代码才能更新到APP中
