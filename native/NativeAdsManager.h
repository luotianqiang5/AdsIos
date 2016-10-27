//
//  NativeAdsManager.h
//  NewAdsManager
//
//  Created by zengwenbin on 15/7/8.
//  Copyright (c) 2015年 zengwenbin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NativeAdsDelegate.h"

@class CustomNativeAdBaseView;

@interface NativeAdsManager : NSObject


@property (nonatomic, assign) id<NativeAdsDelegate> delegate;
/**
 * 是否开启debug模式
 */
@property(nonatomic,assign)BOOL isDebugModel;



/**
 * 用于cocos2d项目，调用该方法后会自动创建一个Native广告，并放置在rootViewController上
 */
+ (NativeAdsManager*)getInstance;

/**
 * @param view:继承自CustomNativeAdBaseView的view，用于放置广告元素
 * @param container:用于放置view的容器，类型为UIView
 */
+ (id)createWithAdView:(CustomNativeAdBaseView *)view container:(UIView *)container;
- (id)initWithAdView:(CustomNativeAdBaseView *)view container:(UIView *)container adId:(NSString*)adId;

/**
 * 加载广告
 */
- (void)preload;
/**
 *  显示广告
 */
- (void)show;

/**
 *  设置广告隐藏或显示
 */
- (void)setHidden:(BOOL)isHidden;

/**
 *  移除广告
 */
- (void)remove;

/**
 * 放置广告位置
 */
- (void)layoutByType:(int)type;


@end

