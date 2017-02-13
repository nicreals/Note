# Block

## 定义

```
int (^multiBlock) (int) = ^(int intVar) {
  return intVar * 2;
}
```

## block中使用变量

在block中直接使用局部变量相当于copy一份到block内部，block不能更改变量的值，也不能实时监测到变量值的改变，除非该变量为全局变量或者给该变量加上`__block`标记.

## block的递归调用

block要递归调用，block本身必须是全局变量或者是静态常量：

```
static void(^ const block)(int) = ^(int i) {
  if (i > 0) {
    NSLog(@"%d",i);
    block(i - 1);
  }
}
block(4);
```
