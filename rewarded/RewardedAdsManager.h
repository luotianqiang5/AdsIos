//
//  RewardedAdsManager.h
//  NewAdsManager
//
//  Created by zengwenbin on 15/7/9.
//  Copyright (c) 2015年 zengwenbin. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol RewardedAdsManagerDelegate;
@interface RewardedAdsManager : NSObject

@property (nonatomic, assign) BOOL  autoShow;
@property (nonatomic, assign) BOOL  isPreloaded;
@property (nonatomic, assign) BOOL  isShowing;
@property (nonatomic, assign) id<RewardedAdsManagerDelegate> delegate;
@property (nonatomic, strong) NSString* zoneID;
@property(nonatomic,assign)BOOL isSkip;
@property(nonatomic,assign)BOOL isDebugModel;
+ (instancetype)getInstance;
- (void)preload;
- (BOOL)show;
@end

@protocol RewardedAdsManagerDelegate <NSObject>

@optional

-(void)onRewardedLoaded;
-(void)onRewardedFailed:(NSError *)error;
-(void)onRewardedExpanded;
-(void)onRewardedCollapsed;
-(void)onRewarded:(NSString *)rewardedItem rewardedNum:(NSInteger)rewardedNum isSkipped:(BOOL)isSkipped;

@end
