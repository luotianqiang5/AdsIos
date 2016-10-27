//
//  AdViewBase.m
//  NewAdsManager
//
//  Created by zengwenbin on 15/7/8.
//  Copyright (c) 2015年 zengwenbin. All rights reserved.
//

#import "AdViewBase.h"
#import "BannerAdsManager.h"

@interface AdViewBase()
@property(nonatomic,assign)BOOL waitAd;

@end

@implementation AdViewBase

- (instancetype)init
{
    self = [super init];
    if (!self) {
        return nil;
    }
    self.isDebugModel=NO;
    self.view=[UIView new];
    self.view.backgroundColor=[UIColor clearColor];
    self.view.layer.zPosition=100;
    self.waitAd=NO;
    self.adSize=CGSizeZero;
    self.isReady=NO;
    self.visible=YES;
    self.adId=nil;
//    self.autoShow=NO;
    return self;
}
-(void)dealloc{
    [super dealloc];
    self.view=nil;
}
-(BOOL)isDebugModel{
    return _isDebugModel;
}
- (void)preload{
}
- (void)show{
    if(self.isReady){
        //self.visible=YES;
        self.waitAd=NO;
        [self onExpanded];
    }else{
        [self preload];
        self.waitAd=YES;
    }
}
- (void)removeAd{
    //self.visible=NO;
    [self onCollapsed];
}
-(void)setVisible:(bool)visible{
    if(self.visible==visible){
        return;
    }
    _visible=visible;
    self.view.hidden=!visible;
    self.view.userInteractionEnabled=visible;
}
#pragma mark - 事件触发

-(void)onLoaded{
    if(self.isDebugModel){
        NSLog(@"==========%s=%@==========",__func__,self.class);
    }
    if([self.delegate respondsToSelector:@selector(onLoaded)]){
        [self.delegate onLoaded];
    }
    self.isReady=YES;
    if(self.waitAd){
        [self show];
    }
}

-(void)onFailed:(NSError *)error{
    if(self.isDebugModel){
        NSLog(@"==========%s=%@==========",__func__,self.class);
        NSLog(@"error:%@",error.localizedDescription);
    }
    if([self.delegate respondsToSelector:@selector(onFailed:)]){
        [self.delegate onFailed:error];
    }
    self.isReady=NO;
}
-(void)onClicked{
    if(self.isDebugModel){
        NSLog(@"==========%s=%@==========",__func__,self.class);
    }
    if([self.delegate respondsToSelector:@selector(onClicked)]){
        [self.delegate onClicked];
    }
}
-(void)onCollapsed{
    if(self.isDebugModel){
        NSLog(@"==========%s=%@==========",__func__,self.class);
    }
    if([self.delegate respondsToSelector:@selector(onCollapsed)]){
        [self.delegate onCollapsed];
    }
}
-(void)onExpanded{
    if(!self.visible){
        NSLog(@"====ad will not show cause of ads invisible");
    }
    if(self.isDebugModel){
        NSLog(@"==========%s=%@==========",__func__,self.class);
    }

    if([self.delegate respondsToSelector:@selector(onExpanded)]){
        [self.delegate onExpanded];
    }
}

@end
