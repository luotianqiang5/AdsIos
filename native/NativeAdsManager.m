//
//  NativeAdsManager.m
//  NewAdsManager
//
//  Created by zengwenbin on 15/7/8.
//  Copyright (c) 2015年 zengwenbin. All rights reserved.
//

#import "NativeAdsManager.h"
#import "AdDeviceHelper.h"
#import "AdIdHelper.h"
#import "AdDef.h"

@interface NativeAdsManager ()<AdViewDelegate>
@property(nonatomic,assign)BOOL autoShow;
@end

@implementation NativeAdsManager

+ (NativeAdsManager*)getInstance
{
    static NativeAdsManager* instance = nil;
    static dispatch_once_t once_token;
    
    dispatch_once(&once_token, ^{

        NSString *adId=[AdIdHelper sharedAdIdHelper].nativeId;
        if(0 == [adId length])
        {
            NSLog(@"Native ad id has not found.");
            return;
        }
        
        instance = [[NativeAdsManager alloc] initWithAdView:nil container:nil adId:adId];
        
    });
    
    return instance;
}

+ (id)createWithAdView:(CustomNativeAdBaseView *)view container:(UIView *)container
{
    NSString *adId=[AdIdHelper sharedAdIdHelper].nativeId;
    if(0 == [adId length])
    {
        NSLog(@"Native ad id has not found.");
        return nil;
    }
    
    return [[[self alloc] initWithAdView:view container:container adId:adId] autorelease];
}

- (id)initWithAdView:(CustomNativeAdBaseView *)view container:(UIView *)container adId:(NSString*)adId
{
    if(0 == [adId length])
    {
        NSLog(@"Native ad id has not found.");
        return nil;
    }
    
    if(self = [super init])
    {
        _isDebugModel=NO;
        self.autoShow=NO;
    }

    return self;
}

- (void)dealloc
{
    self.delegate = nil;
    [super dealloc];
}

-(void)setAutoShow:(BOOL)autoShow{
    
}

-(void)setIsDebugModel:(BOOL)isDebugModel{
    
}

-(void)setDelegate:(id<NativeAdsDelegate>)delegate{
    
}

-(void)preload{

}

- (void)show{

}

- (void)setHidden:(BOOL)isHidden
{

}

- (void)remove
{

}

- (void)layoutByType:(int)type
{

}


@end
