//
//  AdIdHelper.h
//  AdsSdkDemo
//
//  Created by zengwenbin on 15/7/28.
//  Copyright (c) 2015年 zengwenbin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AdIdHelper : NSObject
@property(nonatomic,retain)NSDictionary *configDic;
@property(nonatomic,retain)NSArray *adTypeName;
@property(nonatomic,retain)NSString *bannerId;
@property(nonatomic,retain)NSString *nativeId;
@property(nonatomic,retain)NSString *rectId;
@property(nonatomic,retain)NSString *interstitialId;
@property(nonatomic,retain)NSString *crosspromoId;
@property(nonatomic,retain)NSString *rewardedId;
+ (instancetype)sharedAdIdHelper;
@end
