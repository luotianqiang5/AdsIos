//
//  AdsSdk.h
//  CKID015_Kindergarten
//
//  Created by zengwenbin on 15/7/13.
//
//

#import <Foundation/Foundation.h>
#import "BannerAdsManager.h"
#import "InterstitialAdsManager.h"
#import "CrosspromoAdsManager.h"
#import "RewardedAdsManager.h"

typedef NS_ENUM(NSInteger, AdsType){
    AdTypeBannerAds,
    AdTypeRectAds,
    AdTypeInterstitialAds,
    AdTypeCrosspromoAds,
    AdTypeRewardedAds,
    AdTypeNativeAds
};
@protocol AdsSdkDelegate;
@interface AdsSdk : NSObject

@property(nonatomic,assign)id<AdsSdkDelegate> delegate;
@property(nonatomic,assign)BannerAdsPostion bannerAdsPostion;

+ (NSString*)getVersion;
+ (instancetype)getInstance;

- (void)setIsDebugModel:(BOOL)isDebugModel;
- (void)preloadAllAds;
- (void)preloadAds:(AdsType)adType;
- (BOOL)showAds:(AdsType)adType;
- (void)removeAds:(AdsType)adType;
- (void)setAds:(AdsType)adType visable:(BOOL) visable;
- (BOOL)isAdsVisable:(AdsType)adType;
- (BOOL)isFullScreenShowing;

@end

@protocol AdsSdkDelegate <NSObject>

@optional
-(void)onAdsLoaded:(AdsType)adType;
-(void)onAdsFailed:(NSError *)error adType:(AdsType)adType;
-(void)onAdsClicked:(AdsType)adType;
-(void)onAdsCollapsed:(AdsType)adType;
-(void)onAdsExpanded:(AdsType)adType;
-(void)onRewarded:(NSString *)itemName amount:(NSInteger)amount isSkiped:(BOOL)isSkipped;
@end