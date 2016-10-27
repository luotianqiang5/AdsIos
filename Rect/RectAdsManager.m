//
//  RectAdsManager.m
//  NewAdsManager
//
//  Created by zengwenbin on 15/7/8.
//  Copyright (c) 2015年 zengwenbin. All rights reserved.
//

#import "RectAdsManager.h"
#import "AdDeviceHelper.h"
#import "AdIdHelper.h"
#import "AdDef.h"

#define AD_TYPE @"rect"

@interface RectAdsManager ()
@property (nonatomic, retain) AdViewBase *adView;
@property (nonatomic, assign) BOOL setToCenter;
@end

@implementation RectAdsManager


+ (instancetype)getInstance{
    static RectAdsManager *_sharedRectAdsManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedRectAdsManager = [RectAdsManager new];
    });
    
    return _sharedRectAdsManager;
}
+(void)purgeInstance{
    
}
- (instancetype)init
{
    self = [super init];
    if (!self) {
        return nil;
    }
    _isDebugModel=NO;
    self.setToCenter=NO;
    NSString *adId=[[AdIdHelper sharedAdIdHelper].rectId copy];
    if(adId.length<=0){
        return nil;
    }
    return self;
}
-(void)screenOrientationDidChange{
    if(self.adView && !self.adView.view.superview){
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if(self.setToCenter){
                [self setPositionToScreenCenter];
            }
        });
    }
}

- (void)dealloc
{
    self.adView=nil;
    self.delegate=nil;
    [super dealloc];
}

-(void)preload{

}

-(void)setIsDebugModel:(BOOL)isDebugModel{

}

-(void)show{

}
-(void)removeAd{

}
-(void)setVisible:(bool)visible{
}
-(bool)visible{
    
    return NO;
}
-(void)setPositionToScreenCenter{
}
-(void)setPostion:(CGPoint)postion{

}

@end
