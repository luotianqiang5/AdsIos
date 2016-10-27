//
//  NativeAdsDelegateSource.h
//  AdsSdkDemo
//
//  Created by zengwenbin on 15/8/11.
//  Copyright (c) 2015年 zengwenbin. All rights reserved.
//



#import <UIKit/UIKit.h>

@class NativeAdBaseView;

//@protocol NativeAdsSource<NSObject>
//
//@optional
//@property (retain, nonatomic) UIImageView *iconImageView;
//@property (retain, nonatomic) UILabel *titleLabel;
//@property (retain, nonatomic) UILabel *bodyLabel;
//@property (retain, nonatomic) UILabel *ctaLabel;
//
//-(void)beginLoadingAnimation;
//-(void)endLoadingAnimation;
//-(void)resetAds;
//
//
//@required
//@property (retain, nonatomic) UIImageView *mainImageView;
//@property (assign, nonatomic) CGSize nativeAdViewSize;
//
//-(void)layoutViewsAtNativeAdView:(NativeAdBaseView *)view;
//@end
//


@protocol NativeAdsDelegate <NSObject>

@optional

-(void)onLoaded;

-(void)onFailed:(NSError *)error;

-(void)onClicked;

-(void)onExpanded;

-(void)onCollapsed;


@end

