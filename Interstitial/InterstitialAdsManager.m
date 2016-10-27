//
//  InterstitialAdsManager.m
//  NewAdsManager
//
//  Created by zengwenbin on 15/7/9.
//  Copyright (c) 2015年 zengwenbin. All rights reserved.
//

#import "InterstitialAdsManager.h"
#import "FullscreenAdBase.h"
#import "AdDeviceHelper.h"
#import "CrosspromoAdsManager.h"
#import "RewardedAdsManager.h"
#import "AdIdHelper.h"
#import "AdDef.h"

#import "FullscreenAdMob.h"

#define AD_TYPE @"interstitial"

@interface InterstitialAdsManager()<FullscreenAdDelegate>
@property(nonatomic,strong) FullscreenAdBase *fullscreenAd;

@end

@implementation InterstitialAdsManager

+ (instancetype)getInstance{
    static InterstitialAdsManager *_sharedInterstitialAdsManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInterstitialAdsManager = [InterstitialAdsManager new];
    });
    
    [_sharedInterstitialAdsManager initFullscreenAd];
    
    return _sharedInterstitialAdsManager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        _isDebugModel=NO;
        self.isPreloaded=NO;
        self.autoShow=NO;
        
        [self initFullscreenAd];
    }
    return self;
}

- (void)dealloc
{
    self.delegate = nil;
    self.fullscreenAd = nil;
    
    [super dealloc];
}

- (void)initFullscreenAd
{
    if(self.fullscreenAd)
        return;
    
    NSString *adId=[AdIdHelper sharedAdIdHelper].interstitialId;
    if(adId.length)
    {
        self.fullscreenAd=[[FullscreenAdMob new] autorelease];
    }
    else
    {
        self.fullscreenAd=nil;
    }
    
    if(self.fullscreenAd)
    {
        self.fullscreenAd.delegate = self;
        self.fullscreenAd.adId = adId;
        self.fullscreenAd.isDebugModel = NO;
    }

}

-(void)setIsDebugModel:(BOOL)isDebugModel{
    
    if(nil == self.fullscreenAd)
        return;
    
    if(self.isDebugModel==isDebugModel){
        return;
    }
    _isDebugModel=isDebugModel;
    
    self.fullscreenAd.isDebugModel=isDebugModel;
}

- (void)preload{
    
    [self initFullscreenAd];
    
    if(self.fullscreenAd)
        [self.fullscreenAd preload];
}

- (BOOL)show
{
    [self initFullscreenAd];
    if(nil == self.fullscreenAd)
        return NO;
    
    if(self.isShowing){
        return YES;
    }
    
    if([CrosspromoAdsManager getInstance].isShowing){
        return YES;
    }
    
    if([RewardedAdsManager getInstance].isShowing){
        return YES;
    }
    
    return [self.fullscreenAd show];
}

-(void)setAutoShow:(BOOL)autoShow
{
    if(nil == self.fullscreenAd)
        return;
    
    if(self.autoShow==autoShow){
        return;
    }
    _autoShow=autoShow;
    self.fullscreenAd.autoShow=autoShow;
}

-(BOOL)isPreloaded{
    
    if(self.fullscreenAd)
        return self.fullscreenAd.isReady;
    
    return NO;
}

-(BOOL)isShowing{
    
    if(self.fullscreenAd)
        return self.fullscreenAd.isShowing;
    
    return NO;
}

#pragma mark - 全屏回调
-(void)onLoaded{
    
    if([self.delegate respondsToSelector:@selector(onInterstitialLoaded)]){
        [self.delegate onInterstitialLoaded];
    }
    
    id temp = [UIApplication sharedApplication].delegate;
    if(temp && [temp respondsToSelector:@selector(onAdsLoaded:)])
    {
        NSDictionary* dict = @{@"type":AD_TYPE};
        [temp onAdsLoaded:dict];
    }
}

-(void)onFailed:(NSError *)error{
    if([self.delegate respondsToSelector:@selector(onInterstitialFailed:)]){
        [self.delegate onInterstitialFailed:error];
    }
    
    id temp = [UIApplication sharedApplication].delegate;
    if(temp && [temp respondsToSelector:@selector(onAdsFailed:)])
    {
        NSDictionary* dict = @{@"type":AD_TYPE};
        [temp onAdsFailed:dict];
    }
    
}

-(void)onExpanded{
    if([self.delegate respondsToSelector:@selector(onInterstitialExpanded)]){
        [self.delegate onInterstitialExpanded];
    }
    
    id temp = [UIApplication sharedApplication].delegate;
    if(temp && [temp respondsToSelector:@selector(onAdsExpanded:)])
    {
        NSDictionary* dict = @{@"type":AD_TYPE};
        [temp onAdsExpanded:dict];
    }
}

-(void)onCollapsed{
    if([self.delegate respondsToSelector:@selector(onInterstitialCollapsed)]){
        [self.delegate onInterstitialCollapsed];
    }
    
    id temp = [UIApplication sharedApplication].delegate;
    if(temp && [temp respondsToSelector:@selector(onAdsCollapsed:)])
    {
        NSDictionary* dict = @{@"type":AD_TYPE};
        [temp onAdsCollapsed:dict];
    }
}

-(void)onClicked{
    if([self.delegate respondsToSelector:@selector(onInterstitialClicked)]){
        [self.delegate onInterstitialClicked];
    }
    
    id temp = [UIApplication sharedApplication].delegate;
    if(temp && [temp respondsToSelector:@selector(onAdsClicked:)])
    {
        NSDictionary* dict = @{@"type":AD_TYPE};
        [temp onAdsClicked:dict];
    }
}
@end
