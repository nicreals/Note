# NSURLSession

>[从 NSURLConnection 到 NSURLSession](https://objccn.io/issue-5-4/)

>[iOS里实现multipart/form-data格式上传文件](http://www.jianshu.com/p/a0e3c77d3164)

## NSURLSession vs NSURLConnection

和 `NSURLConnection` `一样，NSURLSession` 指的也不仅是同名类 `NSURLSession`，还包括一系列相互关联的类。`NSURLSession` 包括了与之前相同的组件，`NSURLRequest` 与 `NSURLCache`，但是把 `NSURLConnection` 替换成了 `NSURLSession`、`NSURLSessionConfiguration` 以及 `NSURLSessionTask` 的 3 个子类：`NSURLSessionDataTask`，`NSURLSessionUploadTas`k，`NSURLSessionDownloadTask`。

与 `NSURLConnection` 相比，`NSURLsession` 最直接的改进就是可以配置每个 session 的缓存，协议，cookie，以及证书策略（credential policy），甚至跨程序共享这些信息。这将允许程序和网络基础框架之间相互独立，不会发生干扰。每个 `NSURLSession` 对象都由一个 `NSURLSessionConfiguration` 对象来进行初始化，后者指定了刚才提到的那些策略以及一些用来增强移动设备上性能的新选项。

`NSURLSession` 中另一大块就是 session task。它负责处理数据的加载以及文件和数据在客户端与服务端之间的上传和下载。`NSURLSessionTask` 与 `NSURLConnection` 最大的相似之处在于它也负责数据的加载，最大的不同之处在于所有的 task 共享其创造者 `NSURLSession` 这一公共委托者（common delegate）。

## NSURLSession vs AFNetworking
