//
//  AdViewBase.h
//  NewAdsManager
//
//  Created by zengwenbin on 15/7/8.
//  Copyright (c) 2015年 zengwenbin. All rights reserved.
//  所有banner型广告基类,包括banner,rect 广告
//

#import <UIKit/UIKit.h>
@class BannerAdsManager;
@protocol AdViewDelegate;
@interface AdViewBase : NSObject
@property (nonatomic, retain) UIView*            view;
@property (nonatomic, copy  ) NSString           *adId;
@property (nonatomic, assign) BannerAdsManager   *manger;
@property (nonatomic, assign) id<AdViewDelegate> delegate;
@property (nonatomic, assign) CGSize adSize;
@property (nonatomic, assign) bool   isReady;
@property (nonatomic, assign) bool   visible;
@property (nonatomic, assign) BOOL isDebugModel;
-(BOOL)isDebugModel;
/**
 * 加载广告
 */
- (void)preload;
/**
 *  显示广告
 */
- (void)show;
/**
 * 移除广告,再次显示需要重新请求广告
 */
- (void)removeAd;

#pragma mark - 事件触发

-(void)onLoaded;

-(void)onFailed:(NSError *)error;

-(void)onClicked;

-(void)onCollapsed;

-(void)onExpanded;

@end

@protocol AdViewDelegate <NSObject>

@optional
/**
 *  请求成功
 */
-(void)onLoaded;
/**
 *  请求失败
 *
 *  @param error 失败原因
 */
-(void)onFailed:(NSError *)error;
/**
 *  点击
 */
-(void)onClicked;
/**
 * 消失
 */
-(void)onCollapsed;
/**
 *  显示
 */
-(void)onExpanded;


@end