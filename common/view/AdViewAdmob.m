//
//  AdViewAdmob.m
//  AdsSdkDemo
//
//  Created by xuzepei on 16/4/8.
//
//

#import "AdViewAdmob.h"
#import <GoogleMobileAds/GoogleMobileAds.h>
#import "AdDeviceHelper.h"

@interface AdViewAdmob()<GADBannerViewDelegate>
@property(nonatomic,retain)GADBannerView *bannerView;
@end

@implementation AdViewAdmob

- (void)dealloc
{
    self.bannerView = nil;
    
    [super dealloc];
}

- (instancetype)init
{
    self = [super init];
    if (!self) {
        return nil;
    }
    
    [self bannerView];
    
    return self;
}

- (GADBannerView *)bannerView{
    if(!_bannerView){
        
        if([AdDeviceHelper sharedHelper].isScreenLand){
            _bannerView=[[GADBannerView alloc] initWithAdSize:kGADAdSizeSmartBannerLandscape];
        }else{
            _bannerView=[[GADBannerView alloc] initWithAdSize:kGADAdSizeSmartBannerPortrait];
        }
        _bannerView.delegate=self;
        self.view.bounds = _bannerView.bounds;
        self.adSize = self.view.bounds.size;
        [self.view addSubview:_bannerView];
        
    }
    return _bannerView;
}

- (void)preload
{
    self.bannerView.adUnitID = self.adId;
    self.bannerView.rootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    [self.bannerView loadRequest:[GADRequest request]];
}


- (void)adViewDidReceiveAd:(GADBannerView *)view{
    
    NSLog(@"Banner adapter class name: %@", view.adNetworkClassName);
    
    [self onLoaded];
}

- (void)adView:(GADBannerView *)view didFailToReceiveAdWithError:(GADRequestError *)error{
    [self onFailed:error];
}

- (void)adViewWillPresentScreen:(GADBannerView *)adView{
    [self onClicked];
}

- (void)adViewWillLeaveApplication:(GADBannerView *)adView{
    [self onClicked];
}

@end
