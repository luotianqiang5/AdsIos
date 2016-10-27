//
//  FullscreenAdBase.h
//  NewAdsManager
//
//  Created by zengwenbin on 15/7/9.
//  Copyright (c) 2015年 zengwenbin. All rights reserved.
//

#import <Foundation/Foundation.h>
@protocol FullscreenAdDelegate;
@interface FullscreenAdBase : NSObject
@property (nonatomic, copy  ) NSString *adId;
@property (nonatomic, assign) bool  autoShow;
@property (nonatomic, assign) bool  isReady;
@property (nonatomic, assign) BOOL  isShowing;
@property (nonatomic, assign) BOOL  isRewarded;
@property (nonatomic, assign) id<FullscreenAdDelegate> delegate;
@property (nonatomic, assign) BOOL isDebugModel;
-(BOOL)isDebugModel;
- (void)preload;
- (void)reload;//重新加载(失败后)
- (BOOL)show;
#pragma mark - 事件触发
-(void)onLoaded;
-(void)onFailed:(NSError *)error;
-(void)onClicked;
-(void)onExpanded;
-(void)onCollapsed;
-(void)onRewarded:(NSString *)itemName rewardedNum:(NSInteger)count isSkipped:(BOOL)isSkipped;
@end

@protocol FullscreenAdDelegate <NSObject>

@optional
-(void)onLoaded;
-(void)onFailed:(NSError *)error;
-(void)onExpanded;
-(void)onCollapsed;
-(void)onClicked;
-(void)onRewarded:(NSString *)itemName rewardedNum:(NSInteger)count isSkipped:(BOOL)isSkipped;
@end
