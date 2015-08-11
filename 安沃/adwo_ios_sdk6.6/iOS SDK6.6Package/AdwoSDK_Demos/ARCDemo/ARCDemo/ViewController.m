//
//  ViewController.m
//  ARCDemo
//
//  Created by Zenny Chen on 13-9-6.
//  Copyright (c) 2013年 Zenny Chen. All rights reserved.
//

#import "ViewController.h"

#import "AdwoAdSDK.h"

ADWO_SDK_WITHOUT_CORE_LOCATION_FRAMEWORK(This project does not need CoreLocation.framework)

ADWO_SDK_WITHOUT_PASSKIT_FRAMEWORK(This project does not need Passbook.framework)


@interface ViewController ()<AWAdViewDelegate>

@end

static NSString* const adwoResponseErrorInfoList[] = {
    @"操作成功",
    @"广告初始化失败",
    @"当前广告已调用了加载接口",
    @"不该为空的参数为空",
    @"参数值非法",
    @"非法广告对象句柄",
    @"代理为空或adwoGetBaseViewController方法没实现",
    @"非法的广告对象句柄引用计数",
    @"意料之外的错误",
    @"广告请求太过频繁",
    @"广告加载失败",
    @"全屏广告已经展示过",
    @"全屏广告还没准备好来展示",
    @"全屏广告资源破损",
    @"开屏全屏广告正在请求",
    @"当前全屏已设置为自动展示",
    @"当前事件触发型广告已被禁用",
    @"没找到相应合法尺寸的事件触发型广告",
    
    @"服务器繁忙",
    @"当前没有广告",
    @"未知请求错误",
    @"PID不存在",
    @"PID未被激活",
    @"请求数据有问题",
    @"接收到的数据有问题",
    @"当前IP下广告已经投放完",
    @"当前广告都已经投放完",
    @"没有低优先级广告",
    @"开发者在Adwo官网注册的Bundle ID与当前应用的Bundle ID不一致",
    @"服务器响应出错",
    @"设备当前没连网络，或网络信号不好",
    @"请求URL出错"
};


@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.frame = CGRectMake(20.0f, 20.0f, 150.0f, 35.0f);
    [button setTitle:@"Request Banner" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(requestBannerButtonTouched:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.frame = CGRectMake(20.0f, 70.0f, 150.0f, 35.0f);
    [button setTitle:@"Request FS Ad" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(requestFSButtonTouched:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.frame = CGRectMake(20.0f, 120.0f, 150.0f, 35.0f);
    [button setTitle:@"Request Implant Ad" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(requestImplantButtonTouched:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.frame = CGRectMake(20.0f, 170.0f, 150.0f, 35.0f);
    [button setTitle:@"Stop Banner Ad" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(stopBannerButtonTouched:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

#pragma mark - button events

#define ADWO_PUBLISH_ID_FOR_DEMO        @"536a9c813d1a47f8a6a56b55638d904e"


- (void)requestBannerButtonTouched:(UIButton*)sender
{
    if(mAdBannerView != nil)
        return;
    
    // 创建广告对象
    mAdBannerView = AdwoAdCreateBanner(ADWO_PUBLISH_ID_FOR_DEMO, NO, self);
    if(mAdBannerView == nil)
    {
        NSLog(@"Adwo ad view failed to create!");
        return;
    }
    
    // 设置AWAdView的位置（这里对frame设置大小将不起作用）
    mAdBannerView.frame = CGRectMake(0.0f, 300.0f, 0.0f, 0.0f);
    
    // 将adView添加到本视图中（注意，在调用loadAd前必须先将adView添加到一个父视图中）
    AdwoAdAddBannerToSuperView(mAdBannerView, self.view);
    
    if(AdwoAdLoadBannerAd(mAdBannerView, ADWO_ADSDK_BANNER_SIZE_NORMAL_BANNER, NULL))
        NSLog(@"Banner加载成功");
    else
    {
        NSLog(@"Banner加载失败，由于：%@", adwoResponseErrorInfoList[AdwoAdGetLatestErrorCode()]);
        
        // 若加载失败，则将Banner移除
        AdwoAdRemoveAndDestroyBanner(mAdBannerView);
        mAdBannerView = nil;
    }
}

- (void)requestFSButtonTouched:(UIButton*)sender
{
    if(mAdFSView != nil)
        return;
    
    // 创建广告对象
    mAdFSView = AdwoAdGetFullScreenAdHandle(ADWO_PUBLISH_ID_FOR_DEMO, NO, self, ADWOSDK_FSAD_SHOW_FORM_APPFUN_WITH_BRAND);
    if(mAdFSView == nil)
    {
        NSLog(@"Adwo ad view failed to fetch!");
        return;
    }
    
    if(AdwoAdLoadFullScreenAd(mAdFSView, NO, NULL))
        NSLog(@"全屏广告加载成功！");
    else
    {
        NSLog(@"全屏加载失败，由于：%@", adwoResponseErrorInfoList[AdwoAdGetLatestErrorCode()]);
        
        // 加载失败后，SDK将会自动销毁全屏广告对象，这里将全屏广告对象引用直接置空即可
        mAdFSView = nil;
    }
}

- (void)requestImplantButtonTouched:(id)sender
{
    if(mImplantAdView != nil)
        return;
    
    // 创建植入性广告
    mImplantAdView = AdwoAdCreateImplantAd(ADWO_PUBLISH_ID_FOR_DEMO, YES, self, nil);
    
    // 加载植入性广告
    if(!AdwoAdLoadImplantAd(mImplantAdView, NULL))
    {
        NSLog(@"植入性广告加载失败，由于：%@", adwoResponseErrorInfoList[AdwoAdGetLatestErrorCode()]);
        AdwoAdRemoveAndDestroyImplantAd(mImplantAdView);
        mImplantAdView = nil;
    }
    else
        NSLog(@"植入性广告加载成功");
}

- (void)stopBannerButtonTouched:(UIButton*)sender
{
    // 若当前Banner不可被销毁，则直接返回
    if(mShouldPauseBanner)
        return;
    
    // 释放adView
    if(mAdBannerView != nil)
    {
        if(AdwoAdRemoveAndDestroyBanner(mAdBannerView))
            NSLog(@"Ad view has been removed!");
        
        mAdBannerView = nil;
    }
}


#pragma mark - Adwo Ad delegates

// 此接口必须被实现，并且不能返回空！
- (UIViewController*)adwoGetBaseViewController
{
    return self;
}

- (void)adwoAdViewDidLoadAd:(UIView*)adview
{
    NSLog(@"Ad did load!");
    
    if(adview == mAdFSView)
        AdwoAdShowFullScreenAd(adview);     // 若是全屏广告加载好，则展示全屏广告
    else if(adview == mImplantAdView)
    {
        AdwoAdShowImplantAd(mImplantAdView, self.view);     // 若是植入性广告加载好，则展示植入性广告
        
        // 这里可以激活植入性广告
        AdwoAdImplantAdActivate(mImplantAdView);
    }
}

- (void)adwoAdRequestShouldPause:(UIView*)adView
{
    mShouldPauseBanner = YES;
}

- (void)adwoAdRequestMayResume:(UIView*)adView
{
    mShouldPauseBanner = NO;
}

- (void)adwoAdViewDidFailToLoadAd:(UIView*)adview
{
    int errCode = AdwoAdGetLatestErrorCode();
    NSLog(@"Ad request failed, because: %@", adwoResponseErrorInfoList[errCode]);
    
    if(adview == mAdFSView)
    {
        mAdFSView = nil;
    
        // 这里至少间隔1秒之后，可以再尝试请求
        [self performSelector:@selector(requestFSButtonTouched:) withObject:nil afterDelay:3.0];
    }
}

- (void)adwoUserClosedImplantAd:(UIView*)adView
{
    // 当用户关闭了植入性广告之后，将其销毁
    AdwoAdRemoveAndDestroyImplantAd(mImplantAdView);
    mImplantAdView = nil;
}

- (void)adwoFullScreenAdDismissed:(UIView*)adView
{
    // 当用户关闭了全屏广告之后，将引用置空即可，SDK将会自动销毁对象
    mAdFSView = nil;
    
    NSLog(@"Full screen ad has been closed");
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
