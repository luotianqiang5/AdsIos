//
//  InterstitialAdsManager.h
//  NewAdsManager
//
//  Created by zengwenbin on 15/7/9.
//  Copyright (c) 2015年 zengwenbin. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol InterstitialAdsManagerDelegate;
@interface InterstitialAdsManager : NSObject
/**
 *  设置是否加载完毕自动显示
 */
@property (nonatomic, assign) BOOL  autoShow;
@property (nonatomic, assign) BOOL  isPreloaded;
@property (nonatomic, assign) BOOL  isShowing;
@property (nonatomic, assign) id<InterstitialAdsManagerDelegate> delegate;
/**
 * 是否开启debug模式
 */
@property(nonatomic,assign)BOOL isDebugModel;
/**
 *  获取单例
 */
+ (instancetype)getInstance;
/**
 * 加载广告
 */
- (void)preload;
/**
 *  显示广告
 */
- (BOOL)show;
@end
@protocol InterstitialAdsManagerDelegate <NSObject>

@optional
-(void)onInterstitialLoaded;
-(void)onInterstitialFailed:(NSError *)error;
-(void)onInterstitialExpanded;
-(void)onInterstitialCollapsed;
-(void)onInterstitialClicked;

@end
