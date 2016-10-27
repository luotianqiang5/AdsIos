//
//  AdsSdk.m
//  CKID015_Kindergarten
//
//  Created by zengwenbin on 15/7/13.
//
//

#import "AdsSdk.h"
#import <GoogleMobileAds/GoogleMobileAds.h>
#import <Chartboost/Chartboost.h>

#define TAG_VERSION @"production-kids-V1.0.0"

@interface AdsSdk()<BannerAdsManagerDelegate,InterstitialAdsManagerDelegate,CrosspromoAdsManagerDelegate,RewardedAdsManagerDelegate>

@end

@implementation AdsSdk

+ (NSString*)getVersion
{
    NSString* admobVersion = [NSString stringWithFormat:@"GoogleMobileAdsSDK:%@",[GADRequest sdkVersion]];
    NSString* chartboostVersion = [NSString stringWithFormat:@"Chartboost:%@",[Chartboost getSDKVersion]];
    NSString* adColonyVerion = [NSString stringWithFormat:@"AdColony:%@",@"2.6.2"];
    
    NSString* versions = [NSString stringWithFormat:@"AdsSdk:%@|%@|%@|%@",TAG_VERSION,admobVersion,chartboostVersion,adColonyVerion];
    
    return versions;
}

+ (instancetype)getInstance {
    static AdsSdk *_sharedAdsSdk = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedAdsSdk = [AdsSdk new];
    });
    
    return _sharedAdsSdk;
}
-(void)preloadAllAds{
    [self preloadAds:AdTypeBannerAds];
    [self preloadAds:AdTypeRectAds];
    [self preloadAds:AdTypeInterstitialAds];
    [self preloadAds:AdTypeCrosspromoAds];
    [self preloadAds:AdTypeRewardedAds];
    [self preloadAds:AdTypeNativeAds];
}
-(void)preloadAds:(AdsType)adType{
    switch (adType) {
        case AdTypeBannerAds:
            [BannerAdsManager getInstance].delegate=self;
            [[BannerAdsManager getInstance] preload];
            break;
        case AdTypeRectAds:
            break;
        case AdTypeInterstitialAds:
            [InterstitialAdsManager getInstance].delegate=self;
            [[InterstitialAdsManager getInstance] preload];
            break;
        case AdTypeCrosspromoAds:
            [CrosspromoAdsManager getInstance].delegate=self;
            [[CrosspromoAdsManager getInstance] preload];
            break;
        case AdTypeRewardedAds:
            [RewardedAdsManager getInstance].delegate=self;
            [[RewardedAdsManager getInstance] preload];
            break;
        case AdTypeNativeAds:
            break;
        default:
            break;
    }
}

-(BOOL)showAds:(AdsType)adType{
    switch (adType) {
        case AdTypeBannerAds:
            [[BannerAdsManager getInstance] show];
            return YES;
            break;
        case AdTypeRectAds:
            return NO;
            break;
        case AdTypeInterstitialAds:
            return [[InterstitialAdsManager getInstance] show];
            break;
        case AdTypeCrosspromoAds:
            return [[CrosspromoAdsManager getInstance] show];
            break;
        case AdTypeRewardedAds:
            return [[RewardedAdsManager getInstance] show];
            break;
        case AdTypeNativeAds:
            return NO;
            break;
        default:
            return NO;
            break;
    }
}
-(void)removeAds:(AdsType)adType{
    switch (adType) {
        case AdTypeBannerAds:
            [[BannerAdsManager getInstance] removeAd];
            break;
        case AdTypeRectAds:
            break;
        case AdTypeNativeAds:
        default:
            break;
    }
}
-(void)setAds:(AdsType)adType visable:(BOOL)visable{
    switch (adType) {
        case AdTypeBannerAds:
            [BannerAdsManager getInstance].visible=visable;
            break;
        case AdTypeRectAds:
            break;
        case AdTypeNativeAds:
        default:
            break;
    }
}
-(BOOL)isAdsVisable:(AdsType)adType{
    switch (adType) {
        case AdTypeBannerAds:
            return [BannerAdsManager getInstance].visible;
            break;
        case AdTypeRectAds:
            return NO;
            break;
        default:
            return NO;
            break;
    }
}
-(void)setIsDebugModel:(BOOL)isDebugModel{
    [BannerAdsManager getInstance].isDebugModel=isDebugModel;
    [InterstitialAdsManager getInstance].isDebugModel=isDebugModel;
    [CrosspromoAdsManager getInstance].isDebugModel=isDebugModel;
    [RewardedAdsManager getInstance].isDebugModel=isDebugModel;
}
-(BOOL)isFullScreenShowing{
    return [InterstitialAdsManager getInstance].isShowing||[CrosspromoAdsManager getInstance].isShowing||[RewardedAdsManager getInstance].isShowing;
}
-(void)setBannerAdsPostion:(BannerAdsPostion)bannerAdsPostion{
    _bannerAdsPostion=bannerAdsPostion;
    [[BannerAdsManager getInstance] setPositionQuick:bannerAdsPostion];
}
#pragma mark - load success
-(void)onBannerLoaded{
    if([self.delegate respondsToSelector:@selector(onAdsLoaded:)]){
        [self.delegate onAdsLoaded:AdTypeBannerAds];
    }
}
-(void)onRectLoaded{
    if([self.delegate respondsToSelector:@selector(onAdsLoaded:)]){
        [self.delegate onAdsLoaded:AdTypeRectAds];
    }
}
-(void)onInterstitialLoaded{
    if([self.delegate respondsToSelector:@selector(onAdsLoaded:)]){
        [self.delegate onAdsLoaded:AdTypeInterstitialAds];
    }
}
-(void)onCrosspromoLoaded{
    if([self.delegate respondsToSelector:@selector(onAdsLoaded:)]){
        [self.delegate onAdsLoaded:AdTypeCrosspromoAds];
    }
}
-(void)onRewardedLoaded{
    if([self.delegate respondsToSelector:@selector(onAdsLoaded:)]){
        [self.delegate onAdsLoaded:AdTypeRewardedAds];
    }
}
#pragma mark - load fail
-(void)onBannerFailed:(NSError *)error{
    if([self.delegate respondsToSelector:@selector(onAdsFailed:adType:)]){
        [self.delegate onAdsFailed:error adType:AdTypeBannerAds];
    }
}
-(void)onRectFailed:(NSError *)error{
    if([self.delegate respondsToSelector:@selector(onAdsFailed:adType:)]){
        [self.delegate onAdsFailed:error adType:AdTypeRectAds];
    }
}
-(void)onInterstitialFailed:(NSError *)error{
    if([self.delegate respondsToSelector:@selector(onAdsFailed:adType:)]){
        [self.delegate onAdsFailed:error adType:AdTypeInterstitialAds];
    }
    
}
-(void)onCrosspromoFailed:(NSError *)error{
    if([self.delegate respondsToSelector:@selector(onAdsFailed:adType:)]){
        [self.delegate onAdsFailed:error adType:AdTypeCrosspromoAds];
    }
}
-(void)onRewardedFailed:(NSError *)error{
    if([self.delegate respondsToSelector:@selector(onAdsFailed:adType:)]){
        [self.delegate onAdsFailed:error adType:AdTypeRewardedAds];
    }
}
#pragma mark - show
-(void)onBannerExpanded{
    if([self.delegate respondsToSelector:@selector(onAdsExpanded:)]){
        [self.delegate onAdsExpanded:AdTypeBannerAds];
    }
}
-(void)onRectExpanded{
    if([self.delegate respondsToSelector:@selector(onAdsExpanded:)]){
        [self.delegate onAdsExpanded:AdTypeRectAds];
    }
}
-(void)onInterstitialExpanded{
    if([self.delegate respondsToSelector:@selector(onAdsExpanded:)]){
        [self.delegate onAdsExpanded:AdTypeInterstitialAds];
    }
}
-(void)onCrosspromoExpanded{
    if([self.delegate respondsToSelector:@selector(onAdsExpanded:)]){
        [self.delegate onAdsExpanded:AdTypeCrosspromoAds];
    }
}
-(void)onRewardedExpanded{
    if([self.delegate respondsToSelector:@selector(onAdsExpanded:)]){
        [self.delegate onAdsExpanded:AdTypeRewardedAds];
    }
}
#pragma mark - clicked
-(void)onBannerClicked{
    if([self.delegate respondsToSelector:@selector(onAdsClicked:)]){
        [self.delegate onAdsClicked:AdTypeBannerAds];
    }
}
-(void)onRectClicked{
    if([self.delegate respondsToSelector:@selector(onAdsClicked:)]){
        [self.delegate onAdsClicked:AdTypeRectAds];
    }
}
-(void)onInterstitialClicked{
    if([self.delegate respondsToSelector:@selector(onAdsClicked:)]){
        [self.delegate onAdsClicked:AdTypeInterstitialAds];
    }
}
-(void)onCrosspromoClicked{
    if([self.delegate respondsToSelector:@selector(onAdsClicked:)]){
        [self.delegate onAdsClicked:AdTypeCrosspromoAds];
    }
}
#pragma mark - dismiss
-(void)onBannerCollapsed{
    if([self.delegate respondsToSelector:@selector(onAdsCollapsed:)]){
        [self.delegate onAdsCollapsed:AdTypeBannerAds];
    }
}
-(void)onRectCollapsed{
    if([self.delegate respondsToSelector:@selector(onAdsCollapsed:)]){
        [self.delegate onAdsCollapsed:AdTypeRectAds];
    }
}
-(void)onInterstitialCollapsed{
    if([self.delegate respondsToSelector:@selector(onAdsCollapsed:)]){
        [self.delegate onAdsCollapsed:AdTypeInterstitialAds];
    }
}
-(void)onCrosspromoCollapsed{
    if([self.delegate respondsToSelector:@selector(onAdsCollapsed:)]){
        [self.delegate onAdsCollapsed:AdTypeCrosspromoAds];
    }
}
-(void)onRewardedCollapsed{
    if([self.delegate respondsToSelector:@selector(onAdsCollapsed:)]){
        [self.delegate onAdsCollapsed:AdTypeCrosspromoAds];
    }
}
#pragma mark - rewarded
-(void)onRewarded:(NSString *)rewardedItem rewardedNum:(NSInteger)rewardedNum isSkipped:(BOOL)isSkipped{
    if([self.delegate respondsToSelector:@selector(onRewarded:amount:isSkiped:)]){
        [self.delegate onRewarded:rewardedItem amount:rewardedNum isSkiped:isSkipped];
    }
}

#pragma mark - NativeAdsDelegate

-(void)onLoaded
{
    if([self.delegate respondsToSelector:@selector(onAdsLoaded:)]){
        [self.delegate onAdsLoaded:AdTypeNativeAds];
    }
}

-(void)onFailed:(NSError *)error
{
    if([self.delegate respondsToSelector:@selector(onAdsFailed:adType:)]){
        [self.delegate onAdsFailed:error adType:AdTypeNativeAds];
    }
}

-(void)onClicked
{
    if([self.delegate respondsToSelector:@selector(onAdsClicked:)]){
        [self.delegate onAdsClicked:AdTypeNativeAds];
    }
}

-(void)onExpanded
{
    if([self.delegate respondsToSelector:@selector(onAdsExpanded:)]){
        [self.delegate onAdsExpanded:AdTypeNativeAds];
    }
}

- (void)onCollapsed
{
    if([self.delegate respondsToSelector:@selector(onAdsCollapsed:)]){
        [self.delegate onAdsCollapsed:AdTypeNativeAds];
    }
}


@end
