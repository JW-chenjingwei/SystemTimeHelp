//
//  HRMSeverTimeHelp.h
//  HRM-iOS
//
//  Created by Chenjw on 2019/10/16.
//  Copyright © 2019 com.bonade.HRM-iOS. All rights reserved.
//

#import <Foundation/Foundation.h>
@class HRMSeverTimeHelp;
//监听者需要实现的协议
@protocol TimerListenerProtocol <NSObject>
@required
- (void)didChangeSeverTime:(NSTimeInterval)timeStamp date:(NSDate *_Nullable)date dateString:(NSString *_Nullable)dateString;
@end


NS_ASSUME_NONNULL_BEGIN

@interface HRMSeverTimeHelp : NSObject

+ (instancetype)shareInstance;


- (void)requestSeverTime;

- (void)addListener:(id<TimerListenerProtocol>)listener;
- (void)removeListener:(id<TimerListenerProtocol>)listener;

@end

NS_ASSUME_NONNULL_END
