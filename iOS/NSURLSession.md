# NSURLSession

>[从 NSURLConnection 到 NSURLSession](https://objccn.io/issue-5-4/)
>[iOS里实现multipart/form-data格式上传文件](http://www.jianshu.com/p/a0e3c77d3164)

## NSURLSession vs NSURLConnection

和 `NSURLConnection` `一样，NSURLSession` 指的也不仅是同名类 `NSURLSession`，还包括一系列相互关联的类。`NSURLSession` 包括了与之前相同的组件，`NSURLRequest` 与 `NSURLCache`，但是把 `NSURLConnection` 替换成了 `NSURLSession`、`NSURLSessionConfiguration` 以及 `NSURLSessionTask` 的 3 个子类：`NSURLSessionDataTask`，`NSURLSessionUploadTas`k，`NSURLSessionDownloadTask`。

与 `NSURLConnection` 相比，`NSURLsession` 最直接的改进就是可以配置每个 session 的缓存，协议，cookie，以及证书策略（credential policy），甚至跨程序共享这些信息。这将允许程序和网络基础框架之间相互独立，不会发生干扰。每个 `NSURLSession` 对象都由一个 `NSURLSessionConfiguration` 对象来进行初始化，后者指定了刚才提到的那些策略以及一些用来增强移动设备上性能的新选项。

`NSURLSession` 中另一大块就是 session task。它负责处理数据的加载以及文件和数据在客户端与服务端之间的上传和下载。`NSURLSessionTask` 与 `NSURLConnection` 最大的相似之处在于它也负责数据的加载，最大的不同之处在于所有的 task 共享其创造者 `NSURLSession` 这一公共委托者（common delegate）。

## NSURLSession vs AFNetworking

可能大部分iOS程序员遇到网络请求，第一反应就是用`AFNetworking`,但是如果业务需求比较简单，或者想减少对第三方库的依赖，学习和研究基础的`NSURLSession`还是很有必要的

## 基于`NSURLSession`的网络请求实现

```objectivec
typedef void (^upHTTPResponseHandler)(NSData *data,NSError *error);

typedef NS_ENUM(NSUInteger, UPHTTPContentType) {
    UPHTTPContentTypeForm,                                             // application/x-www-form-urlencoded
    UPHTTPContentTypeData,                                             // application/octet-stream
    UPHTTPContentTypeJson,                                             // application/json
    UPHTTPContentTypeMultipartFile,                                    // multipart/form-data;boundary=--abc1234cdtgvkd
    UPHTTPContentTypeMultipartText,                                    // multipart/form-data;boundary=--abc1234cdtgvkd
};

@interface UPHTTP : NSObject

+ (instancetype)defaultHTTP;

+ (instancetype)httpWithContentType:(UPHTTPContentType)type;

@property(nonatomic, assign) UPHTTPContentType contentType;                         // ContentType 默认为 UPHTTPContentTypeForm

@property(nonatomic, assign) NSTimeInterval timeOutInterval;                        // 超时时间 默认10s

- (void)getWithURL:(NSString *)url param:(NSDictionary *)param handler:(upHTTPResponseHandler)handler;

- (void)postWithURL:(NSString *)url param:(NSDictionary *)param handler:(upHTTPResponseHandler)handler;

/*
 * 上传文件 dataArray的个数需要与param键值对的个数相同
 * @url 地址 url
 * @data 数据 data 文件需要转成NSData对象，NSString可以直接传
 * @param 参数 eg: @{name:asshole,Filedata:temp.png} 被解析成两对 name:"asshole"  name:"Filedata", filename:"temp.png"
 * */
- (void)multiPartWithURL:(NSString *)url data:(NSArray *)dataArray param:(NSDictionary *)param handler:(upHTTPResponseHandler)handler;

@end
```

``` objectivec
typedef NS_ENUM(NSUInteger, UPHTTPErrorType) {
    UPHTTPErrorTypeInvalidParameter,
    UPHTTPErrorTypeNetworkError,
    UPHTTPErrorTypeTimeOut,
};

@interface UPHTTP ()<NSURLSessionDelegate>

@property(nonatomic, strong) NSURLSession *session;
@property(nonatomic, strong) NSString *boundary;

@end

@implementation UPHTTP

+ (instancetype)defaultHTTP; {
    UPHTTP *http = [[UPHTTP alloc] init];
    http.contentType = UPHTTPContentTypeForm;
    http.timeOutInterval = 10;
    return http;
}

+ (instancetype)httpWithContentType:(UPHTTPContentType)type {
    UPHTTP *http = [[UPHTTP alloc] init];
    http.contentType = type;
    return http;
}

- (NSURLSession *)session {
    if (!_session) {
        NSOperationQueue *queue = [[NSOperationQueue alloc] init];
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
        config.timeoutIntervalForRequest = _timeOutInterval;
        config.timeoutIntervalForResource = _timeOutInterval;
        _session = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:queue];
    }
    return _session;
}

- (void)getWithURL:(NSString *)url param:(NSDictionary *)param handler:(upHTTPResponseHandler)handler {
    if (!url && handler) {
        dispatch_async(dispatch_get_main_queue(), ^{
            handler(nil,[self errorWithType:UPHTTPErrorTypeInvalidParameter domain:url message:@"url can no be nil"]);
        });
    }
    NSMutableString *urlString = [[NSMutableString alloc] initWithString:url];
    if ([param allKeys]) {
        NSString *paramString = [self parseParams:param];
        if (paramString) {
            [urlString appendFormat:@"?%@",paramString];
        }
    }
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    [request addValue:[self contentTypeWithType:_contentType] forHTTPHeaderField:@"Content-Type"];

    NSURLSessionDataTask *dataTask = [self.session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (handler) {
            dispatch_async(dispatch_get_main_queue(), ^{
                handler(error ? nil : data,error);
            });
        }
    }];
    [dataTask resume];
}

- (void)postWithURL:(NSString *)url param:(NSDictionary *)param handler:(upHTTPResponseHandler)handler {
    if (!url && handler) {
        dispatch_async(dispatch_get_main_queue(), ^{
            handler(nil,[self errorWithType:UPHTTPErrorTypeInvalidParameter domain:url message:@"url can no be nil"]);
        });
    }
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    request.HTTPMethod = @"POST";
    NSString *postStr = [self parseParams:param];
    request.HTTPBody = [postStr dataUsingEncoding:NSUTF8StringEncoding];
    [request addValue:[self contentTypeWithType:_contentType] forHTTPHeaderField:@"Content-Type"];
    NSURLSessionDataTask *dataTask = [self.session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (handler) {
            dispatch_async(dispatch_get_main_queue(), ^{
                handler(error ? nil : data,error);
            });
        }
    }];
    [dataTask resume];
}


- (void)multiPartWithURL:(NSString *)url data:(NSArray *)dataArray param:(NSDictionary *)param handler:(upHTTPResponseHandler)handler {
    if (!url && handler) {
        dispatch_async(dispatch_get_main_queue(), ^{
            handler(nil,[self errorWithType:UPHTTPErrorTypeInvalidParameter domain:url message:@"url can no be nil"]);
        });
        return;
    }
    if (dataArray.count != param.allKeys.count) {
        dispatch_async(dispatch_get_main_queue(), ^{
            handler(nil,[self errorWithType:UPHTTPErrorTypeInvalidParameter domain:url message:@"invalid param or dataArray"]);
        });
        return;
    }
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    request.HTTPMethod = @"POST";
    [request addValue:[self contentTypeWithType:UPHTTPContentTypeMultipartFile] forHTTPHeaderField:@"Content-Type"];
    NSMutableData *bodyData = [NSMutableData data];

    NSString *wrapSingle = @"\r\n";
    NSString *wrapDouble = @"\r\n\r\n";

    NSString *startBoundary = [NSString stringWithFormat:@"--%@%@",_boundary,wrapSingle];
    NSString *endBoundary = [NSString stringWithFormat:@"--%@--%@",_boundary,wrapSingle];

    [dataArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        id key = param.allKeys[idx];
        id value = param[key];

        NSString *paramString;
        if ([key isEqualToString:@"name"]) {
            paramString = [NSString stringWithFormat:@" %@=\"%@\"",key,value];
        } else {
            paramString = [NSString stringWithFormat:@" name=\"%@\"; filename=\"%@\"",key,value];
        }

        NSString *bodyString;
        NSData *componentData;

        if (![obj isKindOfClass:[NSData class]]) {
            componentData = [obj dataUsingEncoding:NSUTF8StringEncoding];
            bodyString = [NSString stringWithFormat:@"%@Content-Disposition: form-data;%@%@",startBoundary,paramString,wrapDouble];
        } else {
            componentData = obj;
            bodyString = [NSString stringWithFormat:@"%@Content-Disposition: form-data;%@%@Content-Transfer-Encoding: binary%@",startBoundary,paramString,wrapSingle,wrapDouble];
        }

        [bodyData appendData:[bodyString dataUsingEncoding:NSUTF8StringEncoding]];
        [bodyData appendData:componentData];

        [bodyData appendData:[wrapSingle dataUsingEncoding:NSUTF8StringEncoding]];

        if (idx == dataArray.count - 1) {
            [bodyData appendData:[endBoundary dataUsingEncoding:NSUTF8StringEncoding]];
        }
    }];

    request.HTTPBody = [bodyData copy];

    NSURLSessionUploadTask *uploadTask = [self.session uploadTaskWithRequest:request fromData:bodyData completionHandler:^(NSData *responseData, NSURLResponse *response, NSError *error) {
        if (handler) {
            dispatch_async(dispatch_get_main_queue(), ^{
                handler(error ? nil : responseData,error);
            });
        }
    }];
    [uploadTask resume];
}

// MARK: - Private

- (NSError *)errorWithType:(UPHTTPErrorType)type domain:(NSString *)domain message:(NSString *)message {
    NSString *errorType;
    switch (type) {
        case UPHTTPErrorTypeInvalidParameter:
            errorType = @"invalid parameter";
            break;
        case UPHTTPErrorTypeNetworkError:
            errorType = @"bad network condition";
            break;
        case UPHTTPErrorTypeTimeOut:
            errorType = @"response time out";
            break;
    }
    NSDictionary *dictionary = @{
            @"error":errorType,
            @"message": message ? : @""
    };
    NSError *error = [NSError errorWithDomain:domain ? : @"" code:type userInfo:dictionary];
    return error;
}

- (NSString *)parseParams:(NSDictionary *)params {
    NSMutableString *result = [[NSMutableString alloc] init];
    NSArray *keys = [params allKeys];
    [keys enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL *stop) {
        id value = params[obj];
        if (value && [value isKindOfClass:[NSString class]]) {
            value = [value up_urlEncodeString];
        }
        [result appendFormat:@"%@=%@",obj, value];
        if (idx != keys.count - 1) {
            [result appendString:@"&"];
        }

    }];
    return result;
}

- (NSString *)contentTypeWithType:(UPHTTPContentType)type {
    NSString *contentType;
    switch (type) {
        case UPHTTPContentTypeForm:
            contentType = @"application/x-www-form-urlencoded";
            break;
        case UPHTTPContentTypeData:
            contentType = @"application/octet-stream";
            break;
        case UPHTTPContentTypeJson:
            contentType = @"application/json";
            break;
        case UPHTTPContentTypeMultipartFile:
            _boundary = [NSString stringWithFormat:@"%uup%uch%uina%u" , arc4random_uniform(9) , arc4random_uniform(19),arc4random_uniform(199),arc4random_uniform(9)];
            contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",_boundary];
            break;
        default:
            contentType = @"application/x-www-form-urlencoded";
    }
    return contentType;
}


@end

```
