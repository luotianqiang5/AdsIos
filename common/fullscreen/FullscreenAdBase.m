//
//  FullscreenAdBase.m
//  NewAdsManager
//
//  Created by zengwenbin on 15/7/9.
//  Copyright (c) 2015年 zengwenbin. All rights reserved.
//

#import "FullscreenAdBase.h"
#import <UIKit/UIKit.h>

static const NSInteger MAXRETRYTIME=3;
@interface FullscreenAdBase()

@property(nonatomic,assign)NSInteger retryTime;

@end

@implementation FullscreenAdBase
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.isDebugModel=NO;
        self.retryTime=MAXRETRYTIME;
        self.isReady=NO;
        self.isShowing=NO;
        self.isRewarded=NO;
    }
    return self;
}

-(void)preload{
    self.retryTime=MAXRETRYTIME;
    [self reload];
}
-(void)reload{
    
}
-(BOOL)show{
    if(self.isReady==NO){
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            //从后台返回,如果立即请求会失败
            [self preload];
        });
        return NO;
    }
    
    UIViewController *vc=[UIApplication sharedApplication].keyWindow.rootViewController;
    if([vc.presentingViewController isKindOfClass:[UIAlertController class]] ||
       [vc.presentedViewController isKindOfClass:[UIAlertController class]] ){
        return NO;
    }
    
    return YES;
}
#pragma mark - 事件触发
-(void)onLoaded{
    if(self.isDebugModel){
        NSLog(@"==========%s=%@==========",__func__,self.class);
    }
    self.retryTime=MAXRETRYTIME;
    self.isReady=YES;
    if([self.delegate respondsToSelector:@selector(onLoaded)]){
        [self.delegate onLoaded];
    }
    if(self.autoShow){
        [self show];
    }
}
-(void)onFailed:(NSError *)error{
    if(self.isDebugModel){
        NSLog(@"==========%s=%@==error:%@========",__func__,self.class,error);
    }
    self.isReady=NO;
    self.retryTime--;
    if(self.retryTime>0){
        [self performSelector:@selector(reload) withObject:nil afterDelay:1];
    }
    if(self.retryTime==0&&[self.delegate respondsToSelector:@selector(onFailed:)]){
        [self.delegate onFailed:error];
    }
}
-(void)onExpanded{
    self.isShowing=YES;
    if(self.isDebugModel){
        NSLog(@"==========%s=%@==========",__func__,self.class);
    }
    if([self.delegate respondsToSelector:@selector(onExpanded)]){
        [self.delegate onExpanded];
    }
}
-(void)onCollapsed{
    if(self.isDebugModel){
        NSLog(@"==========%s=%@==========",__func__,self.class);
    }
    self.isShowing=NO;
    self.isReady=NO;
    
    //Delay 3 seconds to preload new ad. Avoid showing new ad immediately when the former ad collapsed.
    [self performSelector:@selector(preloadDelay) withObject:nil afterDelay:3];
    
    if([self.delegate respondsToSelector:@selector(onCollapsed)]){
        [self.delegate onCollapsed];
    }
}

- (void)preloadDelay
{
    [self preload];
}

-(void)onClicked{
    if(self.isDebugModel){
        NSLog(@"==========%s=%@==========",__func__,self.class);
    }
    if([self.delegate respondsToSelector:@selector(onClicked)]){
        [self.delegate onClicked];
    }
}
-(void)onRewarded:(NSString *)itemName rewardedNum:(NSInteger)count isSkipped:(BOOL)isSkipped{
    if(self.isDebugModel){
        NSLog(@"==========%s=%@==========",__func__,self.class);
        NSLog(@"==========get Item:%@ count:%@ skipped:%@",itemName,@(count),@(isSkipped));
    }
    if([self.delegate respondsToSelector:@selector(onRewarded:rewardedNum:isSkipped:)]){
        [self.delegate onRewarded:itemName rewardedNum:count isSkipped:isSkipped];
    }
}
@end
