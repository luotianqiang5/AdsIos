//
//  AdIdHelper.m
//  AdsSdkDemo
//
//  Created by zengwenbin on 15/7/28.
//  Copyright (c) 2015年 zengwenbin. All rights reserved.
//

#import "AdIdHelper.h"
#import "AdDeviceHelper.h"
#import "AdsSdk.h"
const static NSString *APPCONFIG_FILE_NAME=@"AppConfig.plist";

@implementation AdIdHelper

+ (instancetype)sharedAdIdHelper {
    static AdIdHelper *_sharedAdIdHelper = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedAdIdHelper = [AdIdHelper new];
    });
    return _sharedAdIdHelper;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.configDic=[NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:[APPCONFIG_FILE_NAME copy] ofType:nil]];
    }
    return self;
}

-(void)dealloc{
    self.adTypeName=nil;
    self.configDic=nil;
    
    self.bannerId=nil;
    self.nativeId=nil;
    self.rectId=nil;
    self.interstitialId=nil;
    self.crosspromoId=nil;
    self.rewardedId=nil;
    
    [super dealloc];
}

-(NSString *)bannerId{
    if(_bannerId==nil){
        self.bannerId = [self getAdIdByAdType:AdTypeBannerAds];
    }
    return _bannerId;
}

-(NSString *)nativeId{
    if(_nativeId==nil){
        self.nativeId = [self getAdIdByAdType:AdTypeNativeAds];
    }
    return _nativeId;
}

-(NSString *)rectId{
    if(_rectId==nil){
        self.rectId = [self getAdIdByAdType:AdTypeRectAds];
    }
    return _rectId;
}

-(NSString *)interstitialId{
    if(_interstitialId==nil){
        self.interstitialId = [self getAdIdByAdType:AdTypeInterstitialAds];
    }
    return _interstitialId;
}

-(NSString *)crosspromoId{
    if(_crosspromoId==nil){
        self.crosspromoId = [self getAdIdByAdType:AdTypeCrosspromoAds];
    }
    return _crosspromoId;
}

-(NSString *)rewardedId{
    
    if(_rewardedId==nil){
        self.rewardedId = [self getAdIdByAdType:AdTypeRewardedAds];
    }
    return _rewardedId;
}

-(NSArray *)adTypeName{
    if(_adTypeName==nil){
        self.adTypeName = @[@"Banner",@"Rect",@"Interstitial",@"Crosspromo",@"Rewarded",@"Native"];
    }
    return _adTypeName;
}

-(NSString *)getAdIdByAdType:(AdsType)type{
    NSString *adId=nil;
    NSString *key=self.adTypeName[type];
    id adConfig=[self.configDic valueForKey:key];
    //iPhone and iPad are set separately
    if([adConfig isKindOfClass:[NSDictionary class]]){
        
        if(type == AdTypeCrosspromoAds)
        {
            NSString* appId = [adConfig objectForKey:@"AppID"];
            if(nil == appId)
                appId = @"";
            NSString* appSignature = [adConfig objectForKey:@"Signature"];
            if(nil == appSignature)
                appSignature = @"";
            
            adId = [NSString stringWithFormat:@"%@,%@",appId,appSignature];
        }
        else if(type == AdTypeRewardedAds)
        {
            NSString* appID = [adConfig objectForKey:@"AppID"];
            if(nil == appID)
                appID = @"";
            NSString* zoneID = [adConfig objectForKey:@"Signature"];
            if(nil == zoneID)
                zoneID = @"";
            
            adId = [NSString stringWithFormat:@"%@,%@",appID,zoneID];
        }
        else if([AdDeviceHelper sharedHelper].isPad){
            adId=[adConfig valueForKey:@"Pad"];
        }else{
            adId=[adConfig valueForKey:@"Phone"];
        }
    }else if ([adConfig isKindOfClass:[NSString class]]){
        adId=adConfig;
    }
    

    
    return adId;
}

@end
