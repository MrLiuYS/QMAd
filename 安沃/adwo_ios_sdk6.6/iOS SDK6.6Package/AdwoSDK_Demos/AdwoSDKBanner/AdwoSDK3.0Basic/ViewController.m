//
//  ViewController.m
//  AdwoSDK3.0Basic
//
//  Created by zenny_chen on 12-10-17.
//  Copyright (c) 2012年 zenny_chen. All rights reserved.
//

#import "ViewController.h"
#import "AdwoAdSDK.h"

// 由于工程里没有添加CoreLocation.framework，因此加上这句话来避免连接错误
ADWO_SDK_WITHOUT_CORE_LOCATION_FRAMEWORK(I do not need CoreLocation framework)

// 由于工程里没有添加Passbook.framework，因此加上这句话来避免连接错误
ADWO_SDK_WITHOUT_PASSKIT_FRAMEWORK(I do not need PassKit framework)


#define ADWO_PUBLISH_ID_FOR_DEMO        @"ab8102cf6dfb4d99adaeeef8c038971f"



@interface ViewController()<AWAdViewDelegate>
{
    UIView *mAdView;

}
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
	// Do any additional setup after loading the view, typically from a nib.
    
    // 展示广告按钮
    UIButton *showButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    showButton.frame = CGRectMake(60.0f, 30.0f, 90.0f, 35.0f);
    [showButton setTitle:@"Show ad" forState:UIControlStateNormal];
    [showButton addTarget:self action:@selector(showButtonTouched:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:showButton];
    
    // 关闭广告按钮
    UIButton *stopButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    stopButton.frame = CGRectMake(170.0f, 30.0f, 90.0f, 35.0f);
    [stopButton setTitle:@"Close ad" forState:UIControlStateNormal];
    [stopButton addTarget:self action:@selector(stopButtonTouched:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:stopButton];
    
}



- (void)showButtonTouched:(UIButton*)sender
{
    if(mAdView != nil)
        return;
    
    // 创建广告banner
    mAdView = AdwoAdCreateBanner(ADWO_PUBLISH_ID_FOR_DEMO, YES, self);
    if(mAdView == nil)
    {
        NSLog(@"Banner广告创建失败");
        return;
    }
    
    // 设置放置Banner的位置
    mAdView.frame = CGRectMake(0.0f, 200.0f, 0.0f, 0.0f);
    
    // 将当前的广告Banner放到父视图上
    AdwoAdAddBannerToSuperView(mAdView, [UIApplication sharedApplication].keyWindow.rootViewController.view);
    
    // 加载广告banner
    AdwoAdLoadBannerAd(mAdView, ADWO_ADSDK_BANNER_SIZE_NORMAL_BANNER, NULL);
}

- (void)stopButtonTouched:(UIButton*)sender
{
    // 释放adView
    if(mAdView != nil)
    {
        if(AdwoAdRemoveAndDestroyBanner(mAdView))
            NSLog(@"Banner被移除咯～");
        mAdView = nil;
    }
}


#pragma mark - Adwo Ad Delegates

// 此接口必须被实现，并且不能返回空！
- (UIViewController*)adwoGetBaseViewController
{
    return [UIApplication sharedApplication].keyWindow.rootViewController;
}

- (void)adwoAdViewDidFailToLoadAd:(UIView*)adview
{
    int errCode = AdwoAdGetLatestErrorCode();
    NSLog(@"广告请求失败，由于：%d", errCode);
}

- (void)adwoAdViewDidLoadAd:(UIView*)adview
{
    NSLog(@"广告已加载");
}


@end



