//
//  AdDeviceHelper.h
//  NewAdsManager
//
//  Created by zengwenbin on 15/7/8.
//  Copyright (c) 2015年 zengwenbin. All rights reserved.
//

#import "AdViewBase.h"

@interface AdDeviceHelper : AdViewBase
+ (instancetype)sharedHelper;
@property(nonatomic,assign)BOOL isPad;
@property(nonatomic,assign)BOOL isScreenLand;
@property(nonatomic,assign)CGSize screenSize;
@property(nonatomic,assign)CGPoint leftTop;
@property(nonatomic,assign)CGPoint leftBottom;
@property(nonatomic,assign)CGPoint leftCenter;
@end
