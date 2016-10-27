//
//  RewardedAdsManager.m
//  NewAdsManager
//
//  Created by zengwenbin on 15/7/9.
//  Copyright (c) 2015年 zengwenbin. All rights reserved.
//

#import "RewardedAdsManager.h"
#import "FullscreenAdBase.h"
#import "AdDeviceHelper.h"
#import "InterstitialAdsManager.h"
#import "CrosspromoAdsManager.h"
#import "AdIdHelper.h"
#import "AdDef.h"
#import <AdColony/AdColony.h>

#define AD_TYPE @"rewarded"

@interface RewardedAdsManager()<FullscreenAdDelegate,AdColonyDelegate,AdColonyAdDelegate>
@property (nonatomic, assign) BOOL  isPreloading;
@end

@implementation RewardedAdsManager

+ (instancetype)getInstance
{
    static RewardedAdsManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [RewardedAdsManager new];
    });
    
    return sharedInstance;
}

- (instancetype)init
{
    if (self = [super init])
    {
        _isDebugModel = NO;
        

//        
//#if RewardedType == AdsTypeMopub
//        self.fullscreenAd=[[FullscreenAdMopubRewarded new] autorelease];
//#elif RewardedType == AdsTypeFyber || RewardedType == AdsTypeFyberNew
//        self.fullscreenAd=[[FullScreenAdFyberRewarded new] autorelease];
//#elif RewardedType == AdsTypeAdColony
//        self.fullscreenAd = [[FullscreenAdAdColonyRewarded new] autorelease];
//#else
//        self.fullscreenAd=nil;
//        return nil;
//#endif
        
//        self.fullscreenAd.delegate = self;
//        self.fullscreenAd.adId = adId;
//        self.fullscreenAd.isRewarded = YES;
//        self.fullscreenAd.isDebugModel = NO;
        
        self.isPreloading = NO;
        self.isPreloaded = NO;
        self.autoShow = NO;
        
        //[self configure];
    }
    
    return self;
}

- (void)dealloc
{
    self.delegate = nil;
    
    [super dealloc];
}

- (void)setIsDebugModel:(BOOL)isDebugModel
{
    _isDebugModel = isDebugModel;
}

- (BOOL)configure
{
    NSString *adId = [[AdIdHelper sharedAdIdHelper].rewardedId copy];
    if(adId.length <= 0){
        return NO;
    }
    
    NSArray *adIdArr = [adId componentsSeparatedByString:@","];
    if(adIdArr.count == 2){
        //static dispatch_once_t onceToken;
        //dispatch_once(&onceToken, ^{
        //if(NO == self.isPreloading)
        
        if([self isPreloaded])
        {
            [self onLoaded];
            if(_autoShow)
                [self show];
        }
        else
        {
            self.isPreloading = YES;
            [AdColony configureWithAppID:[adIdArr[0] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] zoneIDs:@[[adIdArr[1] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]] delegate:self logging:YES];
            self.zoneID = [adIdArr[1] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        }
        //});
        
        return YES;
    }
    
    return NO;
}

- (void)preload
{
    if(NO == [self configure])
    {
        [self onFailed: nil];
    }
}

- (BOOL)show
{
    if(self.isShowing){
        return YES;
    }
    
    if([InterstitialAdsManager getInstance].isShowing){
        return NO;
    }
    
    if([CrosspromoAdsManager getInstance].isShowing){
        return NO;
    }
    
//    if(NO == [AdColony isVirtualCurrencyRewardAvailableForZone:self.zoneID])
//    {
//        return NO;
//    }
    
    UIViewController *vc = [UIApplication sharedApplication].keyWindow.rootViewController;
    if(vc.presentingViewController || vc.presentedViewController){
        return NO;
    }
    
    [AdColony playVideoAdForZone:self.zoneID withDelegate:self withV4VCPrePopup:NO andV4VCPostPopup:NO];
    
    return YES;
}

- (void)setAutoShow:(BOOL)autoShow
{
    _autoShow = autoShow;
}

- (BOOL)isPreloaded
{
    return [AdColony zoneStatusForZone:self.zoneID] == ADCOLONY_ZONE_STATUS_ACTIVE;
}

- (BOOL)isShowing
{
    return _isShowing;
}

#pragma mark - AdColonyDelegate

- (void)onAdColonyAdAvailabilityChange:(BOOL)available inZone:(NSString*) zoneID
{
    self.isPreloading = NO;
    
    if(![zoneID isEqualToString:self.zoneID]){
        return;
    }
    
    if(available)
    {
        [self onLoaded];
        
        if(_autoShow)
            [self show];
    }
    else
    {
        //[self onFailed:nil];
    }
}

- (void)onAdColonyV4VCReward:(BOOL)success currencyName:(NSString *)currencyName currencyAmount:(int)amount inZone:(NSString *)zoneID;
{
    self.isPreloading = NO;
    
    if(![zoneID isEqualToString:self.zoneID]){
        return;
    }
    
    [self onRewarded:currencyName rewardedNum:amount isSkipped:!success];
}

#pragma mark - AdColonyAdDelegate

- (void)onAdColonyAdStartedInZone:(NSString *)zoneID
{
    if([zoneID isEqualToString:self.zoneID]){
        [self onExpanded];
    }
}

- (void)onAdColonyAdAttemptFinished:(BOOL)shown inZone:(NSString *)zoneID
{
    self.isPreloading = NO;
    
    if(shown && [zoneID isEqualToString:self.zoneID]){
        [self onCollapsed];
    }
}

//- (void)onAdColonyAdFinishedWithInfo:(AdColonyAdInfo *)info
//{
//    NSLog(@"onAdColonyAdFinishedWithInfo");
//    
//    if([info.zoneID isEqualToString:self.zoneID]){
//        [self onCollapsed];
//    }
//}

#pragma mark - 全屏回调

- (void)onLoaded
{
    self.isPreloading = NO;
    
    if(self.isShowing)
        return;
    
    if([self.delegate respondsToSelector:@selector(onRewardedLoaded)]){
        [self.delegate onRewardedLoaded];
    }
    
    id temp = [UIApplication sharedApplication].delegate;
    if(temp && [temp respondsToSelector:@selector(onAdsLoaded:)])
    {
        NSDictionary* dict = @{@"type":AD_TYPE};
        [temp onAdsLoaded:dict];
    }
}

- (void)onFailed:(NSError *)error
{
    self.isPreloading = NO;
    
    if(self.isShowing || self.isPreloaded)
        return;
    
    if([self.delegate respondsToSelector:@selector(onRewardedFailed:)]){
        [self.delegate onRewardedFailed:error];
    }
    
    id temp = [UIApplication sharedApplication].delegate;
    if(temp && [temp respondsToSelector:@selector(onAdsFailed:)])
    {
        NSDictionary* dict = @{@"type":AD_TYPE};
        [temp onAdsFailed:dict];
    }
}

- (void)onExpanded
{
    _isShowing = YES;
    
    if([self.delegate respondsToSelector:@selector(onRewardedExpanded)]){
        [self.delegate onRewardedExpanded];
    }
    
    id temp = [UIApplication sharedApplication].delegate;
    if(temp && [temp respondsToSelector:@selector(onAdsExpanded:)])
    {
        NSDictionary* dict = @{@"type":AD_TYPE};
        [temp onAdsExpanded:dict];
    }
}

- (void)onCollapsed
{
    _isShowing = NO;
    
    if([self.delegate respondsToSelector:@selector(onRewardedCollapsed)]){
        [self.delegate onRewardedCollapsed];
    }
    
    id temp = [UIApplication sharedApplication].delegate;
    if(temp && [temp respondsToSelector:@selector(onAdsCollapsed:)])
    {
        NSDictionary* dict = @{@"type":AD_TYPE};
        [temp onAdsCollapsed:dict];
    }
}

- (void)onRewarded:(NSString *)rewardedItem rewardedNum:(NSInteger)rewardedNum isSkipped:(BOOL)isSkipped
{
    _isShowing = NO;
    
    if([self.delegate respondsToSelector:@selector(onRewarded:rewardedNum:isSkipped:)]){
        [self.delegate onRewarded:rewardedItem rewardedNum:rewardedNum isSkipped:isSkipped];
    }
    
    id temp = [UIApplication sharedApplication].delegate;
    if(temp && [temp respondsToSelector:@selector(onAdsRewarded:)])
    {
        NSDictionary* dict = @{@"type":AD_TYPE};
        [temp onAdsRewarded:dict];
    }
}

@end
