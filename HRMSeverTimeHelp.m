//
//  HRMSeverTimeHelp.m
//  HRM-iOS
//
//  Created by Chenjw on 2019/10/16.
//  Copyright © 2019 com.bonade.HRM-iOS. All rights reserved.
//

#import "HRMSeverTimeHelp.h"
#import "HRMAttenRequestManager.h"
@interface HRMSeverTimeHelp()
@property (nonatomic, strong) NSMutableArray *listerMap;
@property (nonatomic, strong) dispatch_source_t timer;
@property (nonatomic, assign) NSTimeInterval timeStamp;
@property (nonatomic, strong) NSDateFormatter *formatter;
@end
@implementation HRMSeverTimeHelp

static id _instance;

+ (instancetype)shareInstance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    
    return _instance;
}


- (void)addListener:(id<TimerListenerProtocol>)listener {
    if(![self.listerMap containsObject:listener]){
        [self.listerMap addObject:listener];
        if(self.listerMap.count > 0){
            //启动
            [self requestSeverTime];
        }
    }
}
- (void)removeListener:(id<TimerListenerProtocol>)listener {
    if([self.listerMap containsObject:listener]){
        [self.listerMap removeObject:listener];
        if(self.listerMap.count == 0){
            //暂停
            dispatch_cancel(self.timer);
        }
    }
}


- (void)requestSeverTime{
    
//    [[HRMAttenRequestManager shareManger] getServerTime:^(NSDate * _Nonnull dateTime) {
    //这里换成自己业务的网络请求服务器时间
        self.timeStamp = [dateTime timeIntervalSince1970];
        [self setupTime];
//    }];
}



- (void)setupTime{
    
    
    dispatch_source_set_event_handler(self.timer, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            self.timeStamp += 1;
            NSDate *date = [NSDate dateWithTimeIntervalSince1970:self.timeStamp];
            NSString *dateString = [self.formatter stringFromDate:date];
            
            [self.listerMap enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                id<TimerListenerProtocol> listener = obj;
                if([listener respondsToSelector:@selector(didChangeSeverTime:date:dateString:)]){
                    [listener didChangeSeverTime:self.timeStamp date:date dateString:dateString];
                }
            }];
        });
    });
    
    
}


- (dispatch_source_t)timer{
    if (!_timer) {
        _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_global_queue(0, 0));
        dispatch_source_set_timer(self.timer, DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
        dispatch_resume(self.timer);
    }
    return _timer;
}
- (NSDateFormatter *)formatter{
    if (!_formatter) {
        _formatter = [[NSDateFormatter alloc] init];
        _formatter.dateFormat = @"HH:mm:ss";
    }
    return _formatter;
}
- (NSMutableArray *)listerMap{
    if (!_listerMap) {
        _listerMap = [NSMutableArray array];
    }
    return _listerMap;
}
@end
