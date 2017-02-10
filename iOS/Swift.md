# Swift
> [Swift3 指导手册](http://swift.gg/2017/01/11/swift-3-tutorial-fundamentals/)

> [Swift 单例模式](http://swifter.tips/singleton/)

> [Swift单例中静态属性的额外作用](http://swift.gg/2017/01/10/dear-erica-singletons-and-property-observers/)

## Closure

## 循环引用

## Enum

- Swift中的枚举成员不会按顺序的被赋值为`0,1,2…`,每个枚举成员就是一个完备的值。
- 使用`Switch`穷举`enum`时如果在没有`default`分支的情况下必须穷举所有枚举类型，否则会报错。
- 相对于Objective-C中的枚举，Swift运行 switch 中匹配到的子句之后，程序会退出 switch 语句，并不会继续向下运行，不需要在每个分支判断后加`break`

## 循环结构及遍历

### `stride`序列

stride 函数返回一个任意可变步长 类型值的序列

```
1.stride(through: 5, by: 1)   // 1,2,3,4,5 包含终点
1.stride(to: 5, by: 1) // 1,2,3,4 不包含终点

let  byThree = stride(from: 3, to: 10, by: 3)
for ass in byThree {
    print(ass) // 3 6 9
}
```

### `indices`属性

`indices`属性会创建一个包含全部索引的范围

```
let names = ["Robb", "Sansa", "Arya", "Jon"]
for nameIndex in names.indices {
    if(nameIndex < 3) {
        print(names[nameIndex]) //Robb, Sansa, Arya
    }
}
```

### `enumerated()`方法

 `enumerated()`返回 一个由每一个数据项索引值和数据值组成的元组

```
let names = ["Robb", "Sansa", "Arya", "Jon"]
for (index, name) in names.enumerated() {
    print("\(index): \(name)")
}
```

## 单例

一个最优雅的Swift单例写法：

```
class MyManager  {
    static let sharedInstance = MyManager()
    private init() {}
}
```
1. 声明为`let` 可保证线程安全，
2. 将`init()`设置为`private`可保证不能外部生成新的实例。

可以通过如下方式在调用单例时设置额外操作

```
public final class Singleton {
    private static let _shared = Singleton()
    private init() { }

    public static var shared: Singleton {
        get {
            doSomething() // 举个栗子
            return _shared
        }
    }
}
```
