# Cocoapods

## 基础使用

可以参考：

1. [Cocoapods Guide](https://guides.cocoapods.org/)
2. [用CocoaPods做iOS程序的依赖管理](http://blog.devtang.com/2014/05/25/use-cocoapod-to-manage-ios-lib-dependency/)
3. [使用Cocoapods创建私有podspec](http://blog.wtlucky.com/blog/2015/02/26/create-private-podspec/)

## 模块化方案

### 总体思想

将APP根据业务板块拆分为若干个`cocoapods`私有本地pods，将基础性的公用代码（基础工具类，公用UI组件等）单独创建一个模块（本地pods），其他模块依赖与该公用模块，主工程只需要放入统筹各个模块的代码（appdelegate,tabbarcontroller，模块间的通信实现等），将各个子模块连接在一起；

### 优点

1. 减少业务代码耦合性；
2. 便于多人合作任务分工，避免代码合并冲突；
3. 加快编译效率，测试代码只需编译所在子模块；
4. 对于大型项目，后期便于维护；

### 缺点

1. 需要开发者对业务所属模块有清晰的认识；
2. 建立模块化的过程相对复杂，需要对Cocoapods有较为深入的了解；
3. 使用不当会造成App包体积增大；

### 具体实现

1. 创建私有库

```shell
pod lib create UP-base
```

配置`podspec`文件:

```ruby
Pod::Spec.new do |s|
  s.name             = 'UP-base'
  s.version          = '0.1.0'
  s.summary          = 'A short description of UP-base.'

  s.homepage         = 'https://github.com/nicreals/UP-base'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'nicreals' => 'nic.reals@outlook.com' }
  s.source           = { :git => 'https://github.com/nicreals/UP-base.git', :tag => s.version.to_s }


  s.platform     = :ios, '7.0'
  s.source_files = 'UP-base/Classes/**/*.{h,m}' //指定源文件路径
  s.resources = 'UP-base/Assets/**/*.png' // 指定资源文件路径
  # s.prefix_header_file = 'UP-base/Classes/UPBase.pch' //指定pch文件路径
  s.dependency 'Masonry' // 设置依赖库
end
```

2. 主工程集成

在主工程目录创建`Podfile`并配置自工程路径：

生成`Podfile`:

```ruby
pod init
```

配置`Podfile`:

```ruby
platform :ios, '7.0'
workspace 'UP_GuPiaoTong'

def podlibs
    pod 'UP-mine', :path => '~/Documents/UpChina/UP-mine'
    pod 'UP-market', :path => '~/Documents/UpChina/UP-market'
    pod 'UP-base', :path => '~/Documents/UpChina/UP-base'
end

target 'UP_GuPiaoTong' do
  podlibs
end
```

集成：

```bash
pod install --no-repo-update
```

3. 模块间通讯实现

在子模块定义接口协议:

```objectivec
@protocol UPBaseRouterDelegate <NSObject>

- (void)base:(UIViewController *)base goLoginWithComplete:(void (^)(BOOL success))complete;

@end

@interface UPBaseRouter : NSObject

@property (nonatomic, weak) id<UPBaseRouterDelegate> delegate;

+ (UPBaseRouter *)shareInstance;

@end
```

主工程中实现协议:

```objectivec
//UPBaseRouterManager
- (void)base:(UIViewController *)base goLoginWithComplete:(void (^)(BOOL))complete {
    self.loginBlock = complete;
    UPLoginViewController *login = [[UPLoginViewController alloc] init];
    login.hidesBottomBarWhenPushed = YES;
    login.delegate = self;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:login];
    [base presentViewController:nav animated:YES completion:nil];
}

- (void)didLoginSuccess:(BOOL)success {
    NSLog(@"%@",@(success));
    self.loginBlock(success);
}

@end
```

模块间调用:

```objectivec
- (void)goLogin:(UIButton *)sender {
    [[UPBaseRouter shareInstance].delegate base:self goLoginWithComplete:^(BOOL success) {
        [self.loginButton setTitle:@"已登陆" forState:UIControlStateNormal];
        NSLog(@"登陆成功 - market");
    }];
}
```

## 优化

### 减少文件路径层级

直接将子模块所有文件放在模块第一级目录，同时如下设置`podspec`:
```ruby
s.source_files = '**/*.{h,m,pch}'
s.resources = 'Assets/**/*.png'
s.exclude_files = 'Example/**/*'
```

### 优化代码提示

#### 优化主工程调用子工程的代码提示

在`build setting` -> `user header search paths` 添加`"${PODS_ROOT}/"`路径

#### 优化子模块的代码提示

1. 设置pch文件:

``` ruby
s.prefix_header_file = 'UP-Base.pch'
```
这样可以使模块内部可直接使用pch文件中定义的类。

2. 设置外部头文件:

```ruby
s.public_header_files = 'UP-Base.h'
```
__同时要注释掉主工程的`Podfile`中的`use_framework!`;__

这样可以在新建文件时自动倒入该文件的父类(前提是`UP-Base.h`中定义了该类)
