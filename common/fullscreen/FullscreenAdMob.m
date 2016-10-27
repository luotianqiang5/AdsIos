//
//  FullscreenAdmob.m
//  AdsSdkDemo
//
//  Created by xuzepei on 16/4/8.
//
//

#import "FullscreenAdMob.h"

@interface FullscreenAdMob()<GADInterstitialDelegate>

@property (nonatomic,retain)GADInterstitial *interstitial;

@end

@implementation FullscreenAdMob

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

-(GADInterstitial*)interstitial{
    if(!_interstitial){
        _interstitial=[[GADInterstitial alloc] initWithAdUnitID:self.adId];
        
        _interstitial.delegate=self;
    }
    return _interstitial;
}

-(void)reload{
    if(self.isReady){
        [self onLoaded];
        return;
    }
    [self.interstitial loadRequest:[GADRequest request]];
}
-(BOOL)show{
    if([super show]==NO){
        return NO;
    }
    UIViewController *vc=[UIApplication sharedApplication].keyWindow.rootViewController;
    if(vc.presentingViewController||vc.presentedViewController){
        return YES;
    }
    [self.interstitial presentFromRootViewController:vc];
    return YES;
}

#pragma mark - delegate

- (void)interstitialDidReceiveAd:(GADInterstitial *)ad{
    
    NSLog(@"Interstitial adapter class name: %@", ad.adNetworkClassName);
    
    if(ad==self.interstitial){
        [self onLoaded];
    }
}
- (void)interstitial:(GADInterstitial *)ad didFailToReceiveAdWithError:(GADRequestError *)error{
    if(ad==self.interstitial){
        [self onFailed:error];
    }
}

- (void)interstitialWillPresentScreen:(GADInterstitial *)ad{
    if(ad==self.interstitial){
        [self onExpanded];
    }
}
- (void)interstitialDidDismissScreen:(GADInterstitial *)ad{
    if(ad==self.interstitial){
        [self onCollapsed];
    }
    self.interstitial=nil;
}


- (void)interstitialWillLeaveApplication:(GADInterstitial *)ad{
    if(ad==self.interstitial){
        [self onClicked];
    }
}
@end
