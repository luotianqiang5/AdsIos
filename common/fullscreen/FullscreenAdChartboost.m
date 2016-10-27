//
//  FullscreenAdChartboost.m
//  AdsSdkDemo
//
//  Created by zengwenbin on 15/8/20.
//  Copyright (c) 2015年 zengwenbin. All rights reserved.
//
#import "AdDef.h"
#if CrosspromoType == AdsTypeChartBoost
#import "FullscreenAdChartboost.h"
#import <UIKit/UIKit.h>
#import <Chartboost/Chartboost.h>
@interface FullscreenAdChartboost ()<ChartboostDelegate>
@property(nonatomic,retain)NSString *location;

@end

@implementation FullscreenAdChartboost

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.location=CBLocationDefault;
    }
    return self;
}
-(void)reload{
    if(self.adId.length>0){
        NSArray *adIdArr=[self.adId componentsSeparatedByString:@","];
        if(adIdArr.count==2){
            static dispatch_once_t onceToken;
            dispatch_once(&onceToken, ^{
                [Chartboost startWithAppId:[adIdArr[0] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] appSignature:[adIdArr[1] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] delegate:self];
                [Chartboost setAutoCacheAds:NO];
                return;
            });
        }
    }
    if(self.isReady||[Chartboost hasInterstitial:self.location]){
        [self onLoaded];
    }else{
        [Chartboost cacheInterstitial:self.location];
    }
}
-(BOOL)show{
    if(![super show]){
        return NO;
    }
    if(![Chartboost hasInterstitial:self.location]){
        return NO;
    }
    UIViewController *vc=[UIApplication sharedApplication].keyWindow.rootViewController;
    if(vc.presentingViewController||vc.presentedViewController){
        return YES;
    }
    [Chartboost showInterstitial:self.location];
    return YES;
}
-(void)didCacheInterstitial:(NSString *)location{
    if([location isEqualToString:self.location]){
        [self onLoaded];
    }
}

- (void)didFailToLoadInterstitial:(NSString *)location withError:(CBLoadError)error{
    if([location isEqualToString:self.location]){
        [self onFailed:nil];
    }
}

- (void)didDisplayInterstitial:(NSString *)location{
    if([location isEqualToString:self.location]){
        [self onExpanded];
    }
}

- (void)didDismissInterstitial:(NSString *)location{
    if([location isEqualToString:self.location]){
        [self onCollapsed];
    }
}

- (void)didClickInterstitial:(NSString *)location{
    if([location isEqualToString:self.location]){
        [self onClicked];
    }
}
@end
#endif