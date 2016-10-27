//
//  CrosspromoAdsManager.m
//  NewAdsManager
//
//  Created by zengwenbin on 15/7/9.
//  Copyright (c) 2015年 zengwenbin. All rights reserved.
//

#import "CrosspromoAdsManager.h"
#import "FullscreenAdBase.h"
#import "AdDeviceHelper.h"
#import "InterstitialAdsManager.h"
#import "RewardedAdsManager.h"
#import "AdIdHelper.h"
#import "AdDef.h"

#import "FullscreenAdChartboost.h"

#define AD_TYPE @"crosspromotion"

@interface CrosspromoAdsManager()<FullscreenAdDelegate>
@property(nonatomic,strong) FullscreenAdBase *fullscreenAd;

@end

@implementation CrosspromoAdsManager

+ (instancetype)getInstance{
    static CrosspromoAdsManager *_sharedCrosspromoAdsManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedCrosspromoAdsManager = [CrosspromoAdsManager new];
    });
    
    [_sharedCrosspromoAdsManager initFullscreenAd];
    
    return _sharedCrosspromoAdsManager;
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
    self.fullscreenAd=nil;
    self.delegate=nil;
    
    [super dealloc];
}

- (void)initFullscreenAd
{
    if(self.fullscreenAd)
        return;
    
    NSString *adId=[AdIdHelper sharedAdIdHelper].crosspromoId;
    if(adId.length)
    {

        self.fullscreenAd=[[FullscreenAdChartboost new] autorelease];
    }
    else
    {
        self.fullscreenAd=nil;
    }
    
    if(self.fullscreenAd)
    {
        self.fullscreenAd.delegate=self;
        self.fullscreenAd.adId=adId;
        self.fullscreenAd.isDebugModel=NO;
    }
    
}


-(void)setIsDebugModel:(BOOL)isDebugModel
{
    if(nil == self.fullscreenAd)
        return;
    
    if(self.isDebugModel==isDebugModel){
        return;
    }
    _isDebugModel=isDebugModel;
    self.fullscreenAd.isDebugModel=isDebugModel;
}

- (void)preload
{
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
    if([InterstitialAdsManager getInstance].isShowing){
        return YES;
    }
    if([RewardedAdsManager getInstance].isShowing){
        return YES;
    }
    return [self.fullscreenAd show];
}

-(void)setAutoShow:(BOOL)autoShow{
    
    if(nil == self.fullscreenAd)
        return;
    
    if(self.autoShow==autoShow){
        return;
    }
    _autoShow=autoShow;
    self.fullscreenAd.autoShow=autoShow;
}

-(BOOL)isPreloaded
{
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
    
    if([self.delegate respondsToSelector:@selector(onCrosspromoLoaded)]){
        [self.delegate onCrosspromoLoaded];
    }
    
    id temp = [UIApplication sharedApplication].delegate;
    if(temp && [temp respondsToSelector:@selector(onAdsLoaded:)])
    {
        NSDictionary* dict = @{@"type":AD_TYPE};
        [temp onAdsLoaded:dict];
    }
}
-(void)onFailed:(NSError *)error{
    if([self.delegate respondsToSelector:@selector(onCrosspromoFailed:)]){
        [self.delegate onCrosspromoFailed:error];
    }
    
    id temp = [UIApplication sharedApplication].delegate;
    if(temp && [temp respondsToSelector:@selector(onAdsFailed:)])
    {
        NSDictionary* dict = @{@"type":AD_TYPE};
        [temp onAdsFailed:dict];
    }
}
-(void)onExpanded{
    if([self.delegate respondsToSelector:@selector(onCrosspromoExpanded)]){
        [self.delegate onCrosspromoExpanded];
    }
    
    id temp = [UIApplication sharedApplication].delegate;
    if(temp && [temp respondsToSelector:@selector(onAdsExpanded:)])
    {
        NSDictionary* dict = @{@"type":AD_TYPE};
        [temp onAdsExpanded:dict];
    }
}
-(void)onCollapsed{
    if([self.delegate respondsToSelector:@selector(onCrosspromoCollapsed)]){
        [self.delegate onCrosspromoCollapsed];
    }
    
    id temp = [UIApplication sharedApplication].delegate;
    if(temp && [temp respondsToSelector:@selector(onAdsCollapsed:)])
    {
        NSDictionary* dict = @{@"type":AD_TYPE};
        [temp onAdsCollapsed:dict];
    }
}
-(void)onClicked{
    if([self.delegate respondsToSelector:@selector(onCrosspromoClicked)]){
        [self.delegate onCrosspromoClicked];
    }
    
    id temp = [UIApplication sharedApplication].delegate;
    if(temp && [temp respondsToSelector:@selector(onAdsClicked:)])
    {
        NSDictionary* dict = @{@"type":AD_TYPE};
        [temp onAdsClicked:dict];
    }
}
@end
