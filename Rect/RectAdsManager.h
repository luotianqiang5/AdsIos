//
//  RectAdsManager.h
//  NewAdsManager
//
//  Created by zengwenbin on 15/7/9.
//  Copyright (c) 2015年 zengwenbin. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol RectAdsManagerDelegate;
@interface RectAdsManager : NSObject
/**
 *  广告位置,锚点位于广告中间,默认在屏幕底部
 */
@property (nonatomic, assign) CGPoint postion;
/**
 *  设置是否加载完毕自动显示
 */
@property (nonatomic, assign) bool    autoShow;
/**
 *  设置是否可见
 */
@property (nonatomic, assign) bool    visible;
/**
 *  广告回调
 */
@property (nonatomic, assign) id<RectAdsManagerDelegate> delegate;
/**
 * 是否开启debug模式
 */
@property(nonatomic,assign)BOOL isDebugModel;



/**
 *  获取单例
 */
+ (instancetype)getInstance;
/**
 * 销毁单例
 */
+ (void)purgeInstance;

/**
 *  快速设置广告位置到屏幕中央
 */
- (void)setPositionToScreenCenter;

/**
 * 加载广告
 */
- (void)preload;
/**
 *  显示广告
 */
- (void)show;
/**
 * 移除广告,再次显示可能需要重新请求广告
 */
- (void)removeAd;
@end
@protocol RectAdsManagerDelegate <NSObject>

@optional
/**
 *  Rect 请求成功
 */
-(void)onRectLoaded;
/**
 *  请求失败
 *
 *  @param error 失败原因
 */
-(void)onRectFailed:(NSError *)error;
/**
 *  点击了Rect
 */
-(void)onRectClicked;
/**
 *  Rect 消失
 */
-(void)onRectCollapsed;
/**
 *  Rect 显示
 */
-(void)onRectExpanded;


@end