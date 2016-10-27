//
//  AdDeviceHelper.m
//  NewAdsManager
//
//  Created by zengwenbin on 15/7/8.
//  Copyright (c) 2015年 zengwenbin. All rights reserved.
//

#import "AdDeviceHelper.h"

@implementation AdDeviceHelper

+ (instancetype)sharedHelper {
    static AdDeviceHelper *_sharedAdDeviceHelper = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedAdDeviceHelper = [AdDeviceHelper new];
    });
    return _sharedAdDeviceHelper;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.isPad=(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad);
        self.screenSize=CGSizeZero;
        self.leftTop=CGPointZero;
        self.leftBottom=CGPointZero;
        self.leftCenter=CGPointZero;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(screenOrientationDidChange) name:UIDeviceOrientationDidChangeNotification object:nil];
    }
    return self;
}
-(BOOL)isScreenLand{
    UIInterfaceOrientation ori=[UIApplication sharedApplication].statusBarOrientation;
    if(ori==UIInterfaceOrientationLandscapeLeft||ori==UIInterfaceOrientationLandscapeRight){
        _isScreenLand=YES;
    }else{
        _isScreenLand=NO;
    }
    return _isScreenLand;
}
-(CGSize)screenSize{
    if(CGSizeEqualToSize(_screenSize, CGSizeZero)){
        CGSize tempsize=[UIScreen mainScreen].bounds.size;
        if(self.isScreenLand){
            self.screenSize=CGSizeMake(MAX(tempsize.width, tempsize.height), MIN(tempsize.width, tempsize.height));
        }else{
            self.screenSize=CGSizeMake(MIN(tempsize.width, tempsize.height), MAX(tempsize.width, tempsize.height));
        }
        //_screenSize=tempsize;
    }
    return _screenSize;
}
-(CGPoint)leftTop{
    if(CGPointEqualToPoint(_leftTop, CGPointZero)){
        if([UIApplication sharedApplication].statusBarHidden){
            _leftTop=CGPointZero;
        }else{
            if([UIDevice currentDevice].systemVersion.floatValue<6.9){
                //iOS6 以下,0点从导航条下开始计算
                _leftTop=CGPointZero;
            }else{
                //iOS6 以下,0点从屏幕左上角开始计算
                _leftTop=CGPointMake(0, 20);//状态条高度20;
            }
        }
    }
    return _leftTop;
}
-(CGPoint)leftBottom{
    if(CGPointEqualToPoint(_leftBottom, CGPointZero)){
        if([UIApplication sharedApplication].statusBarHidden){
            _leftBottom=CGPointMake(0, self.screenSize.height);
        }else{
            if([UIDevice currentDevice].systemVersion.floatValue<6.9){
                //iOS6 以下,0点从导航条下开始计算
                _leftBottom=CGPointMake(0, self.screenSize.height-20);//状态条高度20;
            }else{
                //iOS6 以下,0点从屏幕左上角开始计算
                _leftBottom=CGPointMake(0, self.screenSize.height);
            }
        }
    }
    return _leftBottom;
}
-(CGPoint)leftCenter{
    if(CGPointEqualToPoint(_leftCenter, CGPointZero)){
        self.leftCenter=CGPointMake(0,(self.leftTop.y+self.leftBottom.y)*0.5);
    }
    return _leftCenter;
}
-(void)screenOrientationDidChange{
    //reset
    self.screenSize=CGSizeZero;
    self.leftTop=CGPointZero;
    self.leftBottom=CGPointZero;
    self.leftCenter=CGPointZero;
}
@end
