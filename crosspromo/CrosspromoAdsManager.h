//
//  CrosspromoAdsManager.h
//  NewAdsManager
//
//  Created by zengwenbin on 15/7/9.
//  Copyright (c) 2015年 zengwenbin. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol CrosspromoAdsManagerDelegate;
@interface CrosspromoAdsManager : NSObject
/**
 *  设置是否加载完毕自动显示
 */
@property (nonatomic, assign) BOOL  autoShow;
@property (nonatomic, assign) BOOL  isPreloaded;
@property (nonatomic, assign) BOOL  isShowing;
@property (nonatomic, assign) id<CrosspromoAdsManagerDelegate> delegate;

@property(nonatomic,assign)BOOL isDebugModel;

+ (instancetype)getInstance;

- (void)preload;
- (BOOL)show;

@end
@protocol CrosspromoAdsManagerDelegate <NSObject>

@optional
-(void)onCrosspromoLoaded;
-(void)onCrosspromoFailed:(NSError *)error;
-(void)onCrosspromoExpanded;
-(void)onCrosspromoCollapsed;
-(void)onCrosspromoClicked;

@end
