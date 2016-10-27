//
//  BannerAdsManager.h
//  NewAdsManager
//
//  Created by zengwenbin on 15/7/8.
//  Copyright (c) 2015年 zengwenbin. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSUInteger,BannerAdsPostion){
    BannerAdsPostionCustom,
    BannerAdsPostionTopLeft,
    BannerAdsPostionCenterLeft,
    BannerAdsPostionBottomLeft,
    
    BannerAdsPostionTopCenter,
    BannerAdsPostionCenterCenter,
    BannerAdsPostionBottomCenter,
    
    BannerAdsPostionTopRight,
    BannerAdsPostionCenterRight,
    BannerAdsPostionBottomRight
};


@protocol BannerAdsManagerDelegate;

@interface BannerAdsManager : NSObject
/**
 *  广告位置,锚点位于广告中间,默认在屏幕底部中间
 */
@property (nonatomic, assign) CGPoint postion;
/**
 *  设置是否加载完毕自动显示
 */
@property (nonatomic, assign) bool    autoShow;
/**
 *  设置是否需要显示
 */
@property (nonatomic, assign) bool    needShow;
/**
 *  广告是否加载成功
 */
@property (nonatomic, assign) bool    isReady;
/**
 *  设置是否可见
 */
@property (nonatomic, assign) bool    visible;
/**
 *  广告回调
 */
@property (nonatomic, assign) id<BannerAdsManagerDelegate> delegate;
/**
 * 是否开启debug模式
 */
@property(nonatomic,assign)BOOL isDebugModel;


/**
 *  获取单例
 */
+ (instancetype)getInstance;

/**
 *  快速设置广告位置
 */
- (void)setPositionQuick:(BannerAdsPostion)position;

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


@protocol BannerAdsManagerDelegate <NSObject>

@optional
/**
 *  banner 请求成功
 */
-(void)onBannerLoaded;
/**
 *  请求失败
 *
 *  @param error 失败原因
 */
-(void)onBannerFailed:(NSError *)error;
/**
 *  点击了banner
 */
-(void)onBannerClicked;
/**
 *  banner 消失
 */
-(void)onBannerCollapsed;
/**
 *  banner 显示
 */
-(void)onBannerExpanded;


@end
