//
//  AdwoFSAdContainer.m
//  AdwoSDK3.0FullScreenPortait
//
//  Created by zenny_chen on 13-1-28.
//  Copyright (c) 2013年 zenny_chen. All rights reserved.
//

#import "AdwoFSAdContainer.h"
#import "AdwoAdSDK.h"


#define ADWO_PUBLISH_ID_FOR_DEMO        @"ab8102cf6dfb4d99adaeeef8c038971f"
#define ADWO_FSAD_TEST_MODE             YES

@interface AdwoFSAdContainer() <AWAdViewDelegate>

@end

@implementation AdwoFSAdContainer

// 这里使用单例，使得此全屏广告容器能方便地被用于任何模块
static AdwoFSAdContainer *theFSAdContainerInstance;

// 初始化并启动全屏广告容器，此方法一般在AppDelegate中的- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions代理接口中
+ (void)startWithViewController:(UIViewController*)controller target:(NSObject*)obj adLoadedMsg:(SEL)aSelector
{
    @synchronized([AdwoFSAdContainer class])
    {
        if(theFSAdContainerInstance == nil)
        {
            theFSAdContainerInstance = [[AdwoFSAdContainer alloc] init];
            theFSAdContainerInstance->baseViewController = controller;
            theFSAdContainerInstance->msgTarget = obj;
            theFSAdContainerInstance->msgSelector = aSelector;
        }
    }
}

+ (void)destroy
{
    @synchronized([AdwoFSAdContainer class])
    {
        if(theFSAdContainerInstance != nil)
        {
            [theFSAdContainerInstance release];
            theFSAdContainerInstance = nil;
        }
    }
}

+ (void)loadFSAds
{
    if(theFSAdContainerInstance == nil)
        return;
    
    // 先加载普通插屏广告
    AdwoAdLoadFullScreenAd(theFSAdContainerInstance->fsNormalAd, NO, NULL);
    
    // 再加载后台切换到前台全屏广告
    AdwoAdLoadFullScreenAd(theFSAdContainerInstance->fsBackToForeAd, NO, NULL);
}

+ (void)switchViewContext:(UIViewController*)controller target:(NSObject*)obj adLoadedMsg:(SEL)aSelector
{
    if(theFSAdContainerInstance == nil)
        return;
    
    @synchronized([AdwoFSAdContainer class])
    {
        theFSAdContainerInstance->baseViewController = controller;
        theFSAdContainerInstance->msgTarget = obj;
        theFSAdContainerInstance->msgSelector = aSelector;
    }
}

+ (BOOL)loadLaunchingAd
{
    if(AdwoAdLoadFullScreenAd(theFSAdContainerInstance->fsLaunchingAd, NO, NULL))
        theFSAdContainerInstance->isLaunchingAdLoaded = YES;
    
    return theFSAdContainerInstance->isLaunchingAdLoaded;
}

+ (void)showLaunchingAd
{
    if(theFSAdContainerInstance == nil)
        return;
    
    BOOL canShow = YES;
    
    @synchronized([AdwoFSAdContainer class])
    {
        // 若当前正在展示一个全屏广告，则不予以展示
        if(theFSAdContainerInstance->isAnAdIsShowing)
            canShow = NO;
        else
            theFSAdContainerInstance->isAnAdIsShowing = YES;    // 设置当前正在展示一个全屏广告标签
    }
    
    if(!canShow)
        return;
    
    if(theFSAdContainerInstance->isLaunchingAdLoaded)
        AdwoAdShowFullScreenAd(theFSAdContainerInstance->fsLaunchingAd);
}

+ (void)showNormalAd
{
    if(theFSAdContainerInstance == nil || !theFSAdContainerInstance->isNormalAdLoaded)
        return;
    
    BOOL canShow = YES;
    
    @synchronized([AdwoFSAdContainer class])
    {
        // 若当前正在展示一个全屏广告，则不予以展示
        if(theFSAdContainerInstance->isAnAdIsShowing)
            canShow = NO;
        else
            theFSAdContainerInstance->isAnAdIsShowing = YES;    // 设置当前正在展示一个全屏广告标签
    }
    
    if(!canShow)
        return;
    
    AdwoAdShowFullScreenAd(theFSAdContainerInstance->fsNormalAd);
}

- (id)init
{
    self = [super init];
    
    fsNormalAd = AdwoAdGetFullScreenAdHandle(ADWO_PUBLISH_ID_FOR_DEMO, ADWO_FSAD_TEST_MODE, self, ADWOSDK_FSAD_SHOW_FORM_APPFUN_WITH_BRAND);
    fsNormalAd.tag = 100;
    
    fsLaunchingAd = AdwoAdGetFullScreenAdHandle(ADWO_PUBLISH_ID_FOR_DEMO, ADWO_FSAD_TEST_MODE, self, ADWOSDK_FSAD_SHOW_FORM_LAUNCHING);
    fsLaunchingAd.tag = 200;
    
    fsBackToForeAd = AdwoAdGetFullScreenAdHandle(ADWO_PUBLISH_ID_FOR_DEMO, ADWO_FSAD_TEST_MODE, self, ADWOSDK_FSAD_SHOW_FORM_GROUND_SWITCH);
    fsBackToForeAd.tag = 300;
    AdwoAdSetGroundSwitchAdAutoToShow(fsBackToForeAd, NO);  // 不让后台切换到前台全屏自动展示
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didBecomeActiveNotif:) name:UIApplicationDidBecomeActiveNotification object:nil];
    
    return self;
}

- (void)dealloc
{
    if(fsNormalAd != nil)
    {
        if([baseViewController.view viewWithTag:100] != nil)
            [fsNormalAd removeFromSuperview];
        else
            [fsNormalAd release];
        fsNormalAd = nil;
    }
    if(fsLaunchingAd != nil)
    {
        if([baseViewController.view viewWithTag:200] != nil)
            [fsLaunchingAd removeFromSuperview];
        else
            [fsLaunchingAd release];
        fsLaunchingAd = nil;
    }
    if(fsBackToForeAd != nil)
    {
        if([baseViewController.view viewWithTag:300] != nil)
            [fsBackToForeAd removeFromSuperview];
        else
            [fsBackToForeAd release];
        fsBackToForeAd = nil;
    }
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [super dealloc];
}

- (void)recreateNormalAd
{
    fsNormalAd = AdwoAdGetFullScreenAdHandle(ADWO_PUBLISH_ID_FOR_DEMO, ADWO_FSAD_TEST_MODE, self, ADWOSDK_FSAD_SHOW_FORM_APPFUN_WITH_BRAND);
    fsNormalAd.tag = 100;
    
    // 若加载失败，则SDK将会自动回收广告对象。这里将引用置空
    if(!AdwoAdLoadFullScreenAd(fsNormalAd, NO, NULL))
    {
        fsNormalAd = nil;
        
        // 过5秒后重试
        [self performSelector:@selector(recreateNormalAd) withObject:nil afterDelay:5.0];
    }
}

- (void)recreateLaunchingAd
{
    fsLaunchingAd = AdwoAdGetFullScreenAdHandle(ADWO_PUBLISH_ID_FOR_DEMO, ADWO_FSAD_TEST_MODE, self, ADWOSDK_FSAD_SHOW_FORM_LAUNCHING);
    fsLaunchingAd.tag = 200;
    
    AdwoAdLoadFullScreenAd(fsLaunchingAd, NO, NULL);
}

- (void)recreateGroundSwitchAd
{
    fsBackToForeAd = AdwoAdGetFullScreenAdHandle(ADWO_PUBLISH_ID_FOR_DEMO, ADWO_FSAD_TEST_MODE, self, ADWOSDK_FSAD_SHOW_FORM_GROUND_SWITCH);
    fsBackToForeAd.tag = 300;
    AdwoAdSetGroundSwitchAdAutoToShow(fsBackToForeAd, NO);  // 不让后台切换到前台全屏自动展示
    
    // 若加载失败，则SDK将会自动回收广告对象。这里将引用置空
    if(!AdwoAdLoadFullScreenAd(fsBackToForeAd, NO, NULL))
    {
        fsBackToForeAd = nil;
        
        // 过5秒后重试
        [self performSelector:@selector(recreateGroundSwitchAd) withObject:nil afterDelay:5.0];
    }
}

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

- (void)restartTheAd:(UIView*)adView
{
    // 在做初始化之前先根据当前错误码来设定加载请求间隔时间
    NSTimeInterval interval = 3.0;
    
    NSLog(@"The latest error code: %@", adwoResponseErrorInfoList[AdwoAdGetLatestErrorCode()]);
    
    if(AdwoAdGetLatestErrorCode() != ADWO_ADSDK_ERROR_CODE_LOAD_AD_FAILED)
        interval = 10.0f;   // 若是资源下载失败而引起的错误，则间隔3秒即可，否则间隔10秒再重新尝试请求
    
    if(adView == fsNormalAd)
    {
        isNormalAdLoaded = NO;
        [self performSelector:@selector(recreateNormalAd) withObject:nil afterDelay:interval];
    }
    else if(adView == fsBackToForeAd)
    {
        isBackToForeAdReady = NO;
        [self performSelector:@selector(recreateGroundSwitchAd) withObject:nil afterDelay:interval];
    }
}

#pragma mark - AWAdViewDelegate

- (UIViewController*)adwoGetBaseViewController
{
    return baseViewController;
}

- (void)adwoAdViewDidFailToLoadAd:(UIView*)adView
{
    [self restartTheAd:adView];
}

- (void)adwoAdViewDidLoadAd:(UIView*)adView
{
    if(adView == fsLaunchingAd)
    {
        if(isLaunchingAdLoaded)
        {
            if(msgTarget != nil && [msgTarget respondsToSelector:msgSelector])
                [msgTarget performSelector:msgSelector withObject:adView];
            isLaunchingAdLoaded = NO;
        }
        else
            NSLog(@"Launching full-screen ad resource has been loaded!");
    }
    else if(adView == fsNormalAd)
    {
        isNormalAdLoaded = YES;
        NSLog(@"Normal ad has been loaded!");
    }
    else if(adView == fsBackToForeAd)
    {
        isBackToForeAdReady = YES;
        NSLog(@"Background to foreground ad has been loaded!");
    }
}

- (void)adwoFullScreenAdDismissed:(UIView*)adView
{    
    @synchronized([AdwoFSAdContainer class])
    {
        theFSAdContainerInstance->isAnAdIsShowing = NO;
    }
    
    // 若当前是开屏全屏广告，则直接将引用置空。SDK会自动做请求；其它类型全屏可以自动再做请求
    if(adView == fsLaunchingAd)
        fsLaunchingAd = nil;
    else
        [self restartTheAd:adView];
}

#pragma mark - Notification center

- (void)didBecomeActiveNotif:(NSNotification*)notif
{
    if(!isBackToForeAdReady)
        return;
    
    BOOL canShow = YES;
    
    @synchronized([AdwoFSAdContainer class])
    {
        if(isAnAdIsShowing)
            canShow = NO;
        else
            isAnAdIsShowing = YES;
    }
    
    if(!canShow)
        return;
    
    isBackToForeAdReady = NO;
    AdwoAdShowFullScreenAd(fsBackToForeAd);
}

@end
