//
//  unity3DGetFullScreenAd.m
//  AdwoSDK3.0FullScreenPortait
//
//  Created by liujianan on 14-9-10.
//  Copyright (c) 2014年 zenny_chen. All rights reserved.
//

#import "unity3DGetFullScreenAd.h"
#import "AdwoAdSDK.h"

#define ADWO_PUBLISH_ID_FOR_DEMO        @"661981d05a2c40cebd51420a045dca37"

@interface unity3DGetFullScreenAd()<AWAdViewDelegate>
{
    UIView *AdView;
}
@end

@implementation unity3DGetFullScreenAd


-(unity3DGetFullScreenAd *)init
{
    self = [super init];
    if (self) {
        AdView = nil;
    }
    return self;
}
-(void)getFullScreenAd
{
    if(AdView != nil)
        return;
    
    // 初始化AWAdView对象
    AdView = AdwoAdGetFullScreenAdHandle(ADWO_PUBLISH_ID_FOR_DEMO, NO, self, ADWOSDK_FSAD_SHOW_FORM_APPFUN_WITH_BRAND);
    if(AdView == nil)
    {
        NSLog(@"Adwo full-screen ad failed to create!");
        return;
    }
    
    // 这里使用ADWO_ADSDK_AD_TYPE_FULL_SCREEN标签来加载全屏广告
    // 全屏广告是立即加载的，因此不需要设置adRequestTimeIntervel属性，当然也不需要设置其frame属性
    if(!AdwoAdLoadFullScreenAd(AdView, NO, NULL))
    {
        NSLog(@"加载失败，由于：%d", AdwoAdGetLatestErrorCode());
        AdView = nil;  // 若加载失败，则SDK将会自动销毁当前的全屏广告对象，此时将全屏广告对象引用置空即可
    }
}
#pragma mark - ad delegate
// 此接口必须被实现，并且不能返回空！
- (UIViewController*)adwoGetBaseViewController
{
    return [UIApplication sharedApplication].keyWindow.rootViewController;
}

- (void)adwoAdViewDidFailToLoadAd:(UIView*)ad
{
    NSLog(@"Failed to load ad! Because: %d",AdwoAdGetLatestErrorCode());
    
    AdView = nil;
}

- (void)adwoAdViewDidLoadAd:(UIView*)ad
{
    NSLog(@"Ad did load!");
    
    // 广告加载成功，可以把全屏广告展示上去
    AdwoAdShowFullScreenAd(AdView);
}

- (void)adwoFullScreenAdDismissed:(UIView*)ad
{
    NSLog(@"Full-screen ad closed by user!");
    AdView = nil;
}

- (void)adwoDidPresentModalViewForAd:(UIView*)ad
{
    NSLog(@"Browser presented!");
}

- (void)adwoDidDismissModalViewForAd:(UIView*)ad
{
    NSLog(@"Browser dismissed!");
}




@end
