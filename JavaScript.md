# JavaScript

> 问Java和JavaScript有什么关系？
>
> 雷锋和雷锋塔的关系

## Foundation

### Equality

使用`==`比较，它会自动转换数据类型再比较，很多时候，会得到非常诡异的结果；
使用`===`比较，它不会自动转换数据类型，如果数据类型不一致，返回`false`，如果一致，再比较。
由于JavaScript这个设计缺陷，尽量避免使用`==`比较。

### null/undefined/NaN

表示值为空，大多数情况下，我们都应该用`null`。`undefined`仅仅在判断函数参数是否传递的情况下有用。

NaN表示函数返回值为空。

### strict mode

如果一个变量没有通过`var`申明就被使用，那么该变量就自动被申明为全局变量,
可以启用用`strict模式`强制通过`var`申明变量，未使用`var`申明变量就使用的，将导致运行错误(部分浏览器支持),：

```
'use strict'; //写在JavaScript文件第一行，不支持的浏览器会将其当做字符串
```
### String

除了使用`+`号连接字符串，还可以使用`${var}`的方式替换`var`的值,**并用<`>符号包裹**，简化书写(ES6新增)：

```
var name = 'hole';
var age = 20;
var message = `你好, ${name}, 你今年${age}岁了!`;
```
字符串是不可变的，如果对字符串的某个索引赋值，不会有任何错误，但是，也没有任何效果：

```
var s = 'Test';
s[0] = 'X';
alert(s); // s仍然为'Test'
```
### Array

Array元素的增删：Ò

| Function             | Description       |
| -------------------- | ----------------- |
| push(item1,item2)    | 向`Array`的末尾添加若干元素 |
| pop()                | 删除`Array`的最后一个元素  |
| unshift(item1,item2) | 向`Array`的头部添加若干元素 |
| shift()              | 删除`Array`的第一个元素   |

### Object

JavaScript对象为动态类型，对象属性可以自由添加删除：

```
var ass = {
    name: 'hole'
};
ass.age; // undefined
ass.age = 40; // 新增一个age属性
ass.age; // 40
delete ass.age; // 删除age属性
```

`in`用于判断对象及其父对象是否拥有一个属性或者方法;

`hasOwnProperty`用于判断对象是否拥有一个属性;

```
var ass = {
    name: 'hole'
};
var mobile = ['聂锐'，'hole'，'老铁'，'林飞浪'];
ass.hasOwnProperty('name'); // true
mobile.hasOwnProperty('join'); // false hasOwnProperty不能用来判定方法
'join' in mobile  //true in关键字可以判定是否包含属性和方法
```

### Iterable

集合类型的遍历有`for ... in`,`for ... of`,`forEach()`三种方式：

`for … in`遍历集合对象的属性/key：

```
var a = ['A', 'B', 'C'];
a.name = 'Hello';
for (var x in a) {
    alert(x); // '0', '1', '2', 'name'
}
```

`for ... of`遍历集合对象的键值/value：

```
var a = ['A', 'B', 'C'];
a.name = 'Hello';
for (var x of a) {
    alert(x); // 'A', 'B', 'C'  新增的name为属性，并不是Array对象a的元素
}
```

`forEach()`遍历集合对象时似乎不能被中断：

```
var a = ['A', 'B', 'C'];
a.forEach(function (element, index, array) {
    // element: 指向当前元素的值
    // index: 指向当前索引
    // array: 指向Array对象本身
    alert(element);
});
```

## Function

### Parameters

JavaScript允许传入任意个数的参数，定义一个函数：

```
function abs(x) {
    if (x >= 0) {
        return x;
    } else {
        return -x;
    }
}
```

当参数比定义的参数个数多时不受影响：

```
abs(10, 'blablabla'); // 返回10
abs(-9, 'haha', 'hehe', null); // 返回9
```

当参数比定义的参数个数少时返回`NaN`：

```
abs(); // 返回NaN
```

使用`arguments`可以获取函数调用时传入的说有参数:

```
function foo(x) {
    alert(x); // 10
    for (var i=0; i<arguments.length; i++) {
        alert(arguments[i]); // 10, 20, 30
    }
}
foo(10, 20, 30);
```

使用`...rest`获取已定义参数之外的参数(ES6标准):

```
function foo(a, b, ...rest) {
    console.log('a = ' + a);
    console.log('b = ' + b);
    console.log(rest);
}

foo(1, 2, 3, 4, 5);
// 结果:
// a = 1
// b = 2
// Array [ 3, 4, 5 ]

foo(1);
// 结果:
// a = 1
// b = undefined
// Array []
```

### var & let & const

在函数内部使用`var`声明的变量在整个函数声明周期中都可以访问：

```
'use strict';
function foo() {
    console.log(temp); // undefined 没有报错，JavaScript会扫描整个函数体，将声明的变量"提升至函数顶部"
    for (var i=0; i<100; i++) {
    }
    console.log(i); // 100 可以访问var变量
    var temp = i;
}
foo()
```

使用`let`声明的变量只能局部访问：

```
function foo() {
    for (let i=0; i<100; i++) {
    }
    console.log(i); // SyntaxError
}
foo()
```

使用`const`可以定义一个常量，和`let`一样只能局部访问:

```
'use strict';
const PI = 3.14;
PI = 3; // 某些浏览器不报错，但是无效果！
PI; // 3.14
```

### this

以下代码`this`的指代都很清楚：

```
function getAge() {
    var y = new Date().getFullYear();
    return y - this.birth;
}

var ass = {
    name: 'hole',
    birth: 1985,
    age: getAge
};

ass.age(); // 31, 正常结果
getAge(); // NaN
```

要保证`this`指代正确，函数调用必须使用`this.xxx`的形式：

```
var fn = ass.age; // 先拿到ass的age函数
fn(); // NaN    what the fuck！
```

对象内部函数`this`指代同样有坑：

```
'use strict';
var ass = {
    name: 'hole',
    birth: 1985,
    age: function () {
        function getAgeFromBirth() {
            var y = new Date().getFullYear();
            return y - this.birth;
        }
        return getAgeFromBirth();
    }
};

ass.age(); // 指代undefined Uncaught TypeError: Cannot read property 'birth' of undefined 如果不用strict模式，this将指代window对象
```

使用`that`变量捕获`this`解决指代问题：

```
'use strict';

var ass = {
    name: 'hole',
    birth: 1985,
    age: function () {
        var that = this; // 在方法内部一开始就捕获this
        function getAgeFromBirth() {
            var y = new Date().getFullYear();
            return y - that.birth; // 用that而不是this
        }
        return getAgeFromBirth();
    }
};

ass.age(); // 31
```

使用`apply()`,`call()`解决`this`指代问题：

```
function getMoney(x) {
    return x + this.birth;
}

var ass = {
    name: 'hole',
    birth: 1985,
    money: getMoney
};

ass.age(10000); // 11985
getMoney.apply(ass, [10000]); // 11985, 参数ass指定调用对象 参数打包成Array传入
getMoney.call(ass,10000); // 11985,参数ass指定调用对象 参数直接传入
```

## Closure

有如下代码，由于`f1`,`f2`,`f3`引用了变量`i`,但这三个函数并不会立即执行，当执行是`i`的值为4，所以函数返回全都是16；

```
function count() {
    var arr = [];
    for (var i=1; i<=3; i++) {
        arr.push(function () {
            return i * i;
        });
    }
    return arr;
}

var results = count();
var f1 = results[0];
var f2 = results[1];
var f3 = results[2];
f1(); // 16 WTF!
f2(); // 16
f3(); // 16
```

利用闭包可以实现立即执行的匿名函数：

```
function count() {
    var arr = [];
    for (var i=1; i<=3; i++) {
        arr.push((function (n) {
            return function () {
                return n * n;
            }
        })(i));
    }
    return arr;
}

var results = count();
var f1 = results[0];
var f2 = results[1];
var f3 = results[2];

f1(); // 1
f2(); // 4
f3(); // 9
```

通常，一个立即执行的匿名函数可以把函数体拆开，一般这么写：

```
(function (x) {
    return x * x;
})(3);
```
