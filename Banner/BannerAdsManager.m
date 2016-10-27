//
//  BannerAdsManager.m
//  NewAdsManager
//
//  Created by zengwenbin on 15/7/8.
//  Copyright (c) 2015年 zengwenbin. All rights reserved.
//

#import "BannerAdsManager.h"
#import "AdDeviceHelper.h"
#import "AdIdHelper.h"
#import "AdDef.h"
#import "AdViewAdmob.h"

#define AD_TYPE @"banner"

@interface BannerAdsManager ()<AdViewDelegate>
@property (nonatomic, retain) AdViewBase *adView;
@property (nonatomic, assign) BannerAdsPostion postionQuick;
@end

@implementation BannerAdsManager


+ (instancetype)getInstance{
    static BannerAdsManager *_sharedBannerAdsManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedBannerAdsManager = [BannerAdsManager new];
    });
    
    [_sharedBannerAdsManager initAdView];
    
    return _sharedBannerAdsManager;
}

- (instancetype)init
{
    self = [super init];
    if (!self) {
        return nil;
    }
    
    _isDebugModel=NO;
    self.visible=YES;
    self.postion=CGPointZero;
    self.autoShow=NO;
    
    [self initAdView];

    return self;
}

- (void)initAdView
{
    if(self.adView)
        return;
    
    NSString *adId=[AdIdHelper sharedAdIdHelper].bannerId;
    if([adId length])
    {
        self.adView = [[AdViewAdmob new] autorelease];
    }
    else
    {
        self.adView=nil;
    }
    
    if(self.adView)
    {
        self.adView.delegate  =self;
        self.adView.adId = adId;
        self.adView.isDebugModel = NO;
        [self setPositionQuick:BannerAdsPostionBottomCenter];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(screenOrientationDidChange) name:UIDeviceOrientationDidChangeNotification object:nil];
    }
}

- (void)screenOrientationDidChange{
    if(self.adView && !self.adView.view.superview){
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self setPositionQuick:self.postionQuick];
        });
    }
}

- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    self.delegate=nil;
    self.adView=nil;
    
    [super dealloc];
    
}

- (void)setIsDebugModel:(BOOL)isDebugModel
{
    if(nil == self.adView)
        return;
    
    if(self.isDebugModel==isDebugModel){
        return;
    }
    _isDebugModel=isDebugModel;
    self.adView.isDebugModel=isDebugModel;
}

- (void)preload
{
    [self initAdView];
    
    if(self.adView)
        [self.adView preload];
}

- (void)show
{
    [self initAdView];
    if(nil == self.adView)
        return;
    
    self.needShow = YES;
    
    if(NO == self.isReady)
        return;
    
    UIView *container=[UIApplication sharedApplication].keyWindow.rootViewController.view;
    if(self.adView.view.superview!=container){
        if(self.adView.view.superview){
            [self.adView.view removeFromSuperview];
        }
        [container addSubview:self.adView.view];
    }
    
    [self setPositionQuick:_postionQuick];
    
    [self.adView show];
}

- (void)removeAd
{
    if(nil == self.adView)
        return;
    
    self.needShow = NO;
    
    if(self.adView.view.superview){
        [self.adView.view removeFromSuperview];
    }
    [self.adView removeAd];
}

- (void)setVisible:(bool)visible
{
    if(self.adView)
        self.adView.visible=visible;
}

- (bool)visible
{
    if(self.adView)
        return self.adView.visible;
    
    return NO;
}

- (void)setPositionQuick:(BannerAdsPostion)position
{
    _postionQuick=position;
    if(position==BannerAdsPostionCustom){
        return;
    }
    CGPoint pos=CGPointZero;
    CGSize adSize=self.adView.view.bounds.size;
    switch (position) {
        case BannerAdsPostionTopLeft:
            pos.x=adSize.width*0.5;
            pos.y=[AdDeviceHelper sharedHelper].leftTop.y+adSize.height*0.5;
            break;
        case BannerAdsPostionCenterLeft:
            pos.x=adSize.width*0.5;
            pos.y=[AdDeviceHelper sharedHelper].leftCenter.y;
            self.adView.view.autoresizingMask=UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin;
            break;
        case BannerAdsPostionBottomLeft:
            pos.x=adSize.width*0.5;
            pos.y=[AdDeviceHelper sharedHelper].leftBottom.y-adSize.height*0.5;
            self.adView.view.autoresizingMask=UIViewAutoresizingFlexibleTopMargin;
            break;
            
        case BannerAdsPostionTopCenter:
            pos.x=[AdDeviceHelper sharedHelper].screenSize.width*0.5;
            pos.y=[AdDeviceHelper sharedHelper].leftTop.y+adSize.height*0.5;
            self.adView.view.autoresizingMask=UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin;
            break;
        case BannerAdsPostionCenterCenter:
            pos.x=[AdDeviceHelper sharedHelper].screenSize.width*0.5;
            pos.y=[AdDeviceHelper sharedHelper].leftCenter.y;
            self.adView.view.autoresizingMask=UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin;
            break;
        case BannerAdsPostionBottomCenter:
            pos.x=[AdDeviceHelper sharedHelper].screenSize.width*0.5;
            pos.y=[AdDeviceHelper sharedHelper].leftBottom.y-adSize.height*0.5;
            self.adView.view.autoresizingMask=UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleTopMargin;
            break;
            
        case BannerAdsPostionTopRight:
            pos.x=[AdDeviceHelper sharedHelper].screenSize.width-adSize.width*0.5;
            pos.y=[AdDeviceHelper sharedHelper].leftTop.y+adSize.height*0.5;
            self.adView.view.autoresizingMask=UIViewAutoresizingFlexibleLeftMargin;
            break;
        case BannerAdsPostionCenterRight:
            pos.x=[AdDeviceHelper sharedHelper].screenSize.width-adSize.width*0.5;
            pos.y=[AdDeviceHelper sharedHelper].leftCenter.y;
            self.adView.view.autoresizingMask=UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin;
            break;
        case BannerAdsPostionBottomRight:
            pos.x=[AdDeviceHelper sharedHelper].screenSize.width-adSize.width*0.5;
            pos.y=[AdDeviceHelper sharedHelper].leftBottom.y-adSize.height*0.5;
            self.adView.view.autoresizingMask=UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleTopMargin;
            break;
        default:
            break;
    }
    _postion=pos;
    
    if(self.adView)
        self.adView.view.center=pos;
}

- (void)setPostion:(CGPoint)postion
{
    if(nil == self.adView)
        return;
    
    _postion=postion;
    _postionQuick=BannerAdsPostionCustom;
    self.adView.view.autoresizingMask=0;
    self.adView.view.center=postion;
}

#pragma mark - banner回调
- (void)onLoaded{
    
    self.isReady = YES;
    
    if([self.delegate respondsToSelector:@selector(onBannerLoaded)]){
        [self.delegate onBannerLoaded];
    }
    
    id temp = [UIApplication sharedApplication].delegate;
    if(temp && [temp respondsToSelector:@selector(onAdsLoaded:)])
    {
        NSDictionary* dict = @{@"type":AD_TYPE};
        [temp onAdsLoaded:dict];
    }
    
    if(self.autoShow){
        [self show];
    }
    
    if(self.needShow)
        [self show];
}

- (void)onFailed:(NSError *)error{
    if([self.delegate respondsToSelector:@selector(onBannerFailed:)]){
        [self.delegate onBannerFailed:error];
    }
    
    id temp = [UIApplication sharedApplication].delegate;
    if(temp && [temp respondsToSelector:@selector(onAdsFailed:)])
    {
        NSDictionary* dict = @{@"type":AD_TYPE};
        [temp onAdsFailed:dict];
    }
}
- (void)onClicked{
    if([self.delegate respondsToSelector:@selector(onBannerClicked)]){
        [self.delegate onBannerClicked];
    }
    
    id temp = [UIApplication sharedApplication].delegate;
    if(temp && [temp respondsToSelector:@selector(onAdsClicked:)])
    {
        NSDictionary* dict = @{@"type":AD_TYPE};
        [temp onAdsClicked:dict];
    }
}

- (void)onCollapsed{
    if([self.delegate respondsToSelector:@selector(onBannerCollapsed)]){
        [self.delegate onBannerCollapsed];
    }
    
    id temp = [UIApplication sharedApplication].delegate;
    if(temp && [temp respondsToSelector:@selector(onAdsCollapsed:)])
    {
        NSDictionary* dict = @{@"type":AD_TYPE};
        [temp onAdsCollapsed:dict];
    }
}

- (void)onExpanded{
    if([self.delegate respondsToSelector:@selector(onBannerExpanded)]){
        [self.delegate onBannerExpanded];
    }
    
    id temp = [UIApplication sharedApplication].delegate;
    if(temp && [temp respondsToSelector:@selector(onAdsExpanded:)])
    {
        NSDictionary* dict = @{@"type":AD_TYPE};
        [temp onAdsExpanded:dict];
    }
}

@end
