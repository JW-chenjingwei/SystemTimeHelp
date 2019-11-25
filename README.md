### 在很多app中，有很多业务需要实时获取服务器时间，比如商品抢购倒计时，考勤打卡等功能需要，如果你是获取系统时间比如NSDate是不准的，用户可以随时更改手机系统时间。一般的做法都是以后台返回的时间为准，有两种做法，一是让后台在每个接口都返回一个时间，这样每次请求接口的时候都能拿到时间；二是让后台新增一个获取时间的接口，每次我们需要获取时再请求获取，我这边的后台使用第二种。
### 使用方法：
```
//第一步，初始化对象
//创建对象
HRMSeverTimeHelp *help = [HRMSeverTimeHelp shareInstance];

//给自己的观察者添加订阅
[help addListener:self];

//开始请求服务器时间
[help requestSeverTime];


//第二步，准守协议
//观察者遵守TimerListenerProtocol协议
你的vc<TimerListenerProtocol>

//在更新回调方法取得返回的时间：（你可以更改这个协议方法，具体根据你业务决定）
- (void)didChangeSeverTime:(NSTimeInterval)timeStamp date:(NSDate *_Nullable)date dateString:(NSString *_Nullable)dateString;

//在你需要取消订阅的地方取消订阅
[help removeListener:self];

```

