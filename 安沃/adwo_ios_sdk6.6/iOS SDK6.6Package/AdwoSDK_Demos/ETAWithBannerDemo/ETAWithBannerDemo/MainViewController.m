//
//  MainViewController.m
//  ETAWithBannerDemo
//
//  Created by Zenny Chen on 14-5-20.
//  Copyright (c) 2014年 Adwo. All rights reserved.
//

#import "MainViewController.h"
#import "AdwoAdSDK.h"

#define ADWO_PUBLISH_ID_FOR_DEMO        @"ab8102cf6dfb4d99adaeeef8c038971f"

#define ADWO_AD_IS_FORMAL               NO


@interface MainViewController ()<AWAdViewDelegate>

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


@implementation MainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)loadView
{
    [super loadView];
    
    self.wantsFullScreenLayout = YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // 一开始允许广告被移除
    mCanRemoveAd = YES;
    
    // 创建展示按钮
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.frame = CGRectMake(40.0f, 40.0f, 90.0f, 35.0f);
    [button setTitle:@"展示广告" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(showButtonTouched:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    // 创建关闭按钮
    button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.frame = CGRectMake(150.0f, 40.0f, 90.0f, 35.0f);
    [button setTitle:@"关闭广告" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(closeButtonTouched:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

- (void)showButtonTouched:(id)sender
{
    [self createAd];
}

- (void)closeButtonTouched:(id)sender
{
    mCanShowVoicePrint = NO;
    
    mDestroyWholeAd = YES;
    
    // 先关闭定时器
    if(mAdTimer != nil)
    {
        [mAdTimer invalidate];
        mAdTimer = nil;
    }
    
    // 然后再尝试关闭广告
    if(mCanRemoveAd)
    {
        // 移除Banner
        AdwoAdRemoveAndDestroyBanner(mBannerAd);
        mBannerAd = nil;
        
        // 移除ETA广告
        AdwoAdRemoveETAViewFromSuperview(ADWOSDK_ETA_TYPE_VOICEPRINT);
    }
    else
    {
        // 若当前不能直接移除广告，则等待可移除时移除
        mNeedCloseBanner = YES;
        mNeedCloseVoicePrint = YES;
    }
}

- (void)createAd
{
    if(mBannerAd != nil || mAdTimer != nil)
    {
        NSLog(@"广告已被创建！");
        return;
    }
    
    mDestroyWholeAd = NO;
    
    if(mBannerAd == nil)
    {
        // 若定时器在运转，则先将其停掉
        if(mAdTimer != nil)
        {
            [mAdTimer invalidate];
            mAdTimer = nil;
        }
        
        // 创建Banner广告对象
        mBannerAd = AdwoAdCreateBanner(ADWO_PUBLISH_ID_FOR_DEMO, ADWO_AD_IS_FORMAL, self);
        if(mBannerAd == nil)
        {
            NSLog(@"Banner广告创建失败");
            return;
        }
        
        // 设置Banner视图位置
        mBannerAd.frame = CGRectMake(0.0f, 200.0f, 0.0f, 0.0f);
        
        // 添加Banner广告视图
        AdwoAdAddBannerToSuperView(mBannerAd, self.view);
        
        // 加载Banner广告
        NSTimeInterval remainInterval = 20.0;       // 默认请求间隔这里先设置为20秒
        if(AdwoAdLoadBannerAd(mBannerAd, ADWO_ADSDK_BANNER_SIZE_NORMAL_BANNER, &remainInterval))
            NSLog(@"Banner已被加载");
        else
        {
            enum ADWO_ADSDK_ERROR_CODE errCode = AdwoAdGetLatestErrorCode();
            NSLog(@"广告加载失败，由于：%@", adwoResponseErrorInfoList[errCode]);
            
            // 可以直接移除Banner广告
            AdwoAdRemoveAndDestroyBanner(mBannerAd);
            mBannerAd = nil;
            
            mAdTimer = [NSTimer scheduledTimerWithTimeInterval:remainInterval + 1.0 target:self selector:@selector(retryCreateAdHandler:) userInfo:nil repeats:NO];
        }
    }
    
    if(mAdTimer == nil)
    {
        // 开启声纹广告
        AdwoAdLaunchETA(ADWOSDK_ETA_TYPE_VOICEPRINT, ADWO_PUBLISH_ID_FOR_DEMO, ADWO_AD_IS_FORMAL, NULL);
        
        // 立即设置代理
        AdwoAdSetETADelegate(ADWOSDK_ETA_TYPE_VOICEPRINT, self);
    }
}

- (void)retryCreateAdHandler:(NSTimer*)theTimer
{
    mAdTimer = nil;
    
    // 重新尝试创建广告
    [self createAd];
}

- (void)voicePrintHasShownHandler:(NSTimer*)theTimer
{
    mAdTimer = nil;
    
    if(mCanRemoveAd)
    {
        AdwoAdRemoveETAViewFromSuperview(ADWOSDK_ETA_TYPE_VOICEPRINT);
        
        // 若不是点击了关闭按钮，则再重新创建广告
        if(!mDestroyWholeAd)
            [self createAd];
    }
    else
        mNeedCloseVoicePrint = YES;
}

- (void)showVoicePrintAd
{
    CGSize sizeList[ADWOADSDK_MAX_ETA_AD_SIZES];
    
    int nSizes = AdwoAdGetETAViewSizes(ADWOSDK_ETA_TYPE_VOICEPRINT, sizeList);
    
    for(int i = 0; i < nSizes; i++)
    {
        if(sizeList[i].width == 320.0f && sizeList[i].height == 50.0f)
        {
            AdwoAdAddETAViewToSuperview(ADWOSDK_ETA_TYPE_VOICEPRINT, self.view, sizeList[i], CGPointMake(0.0f, 200.0f));
            
            // 声纹广告展示20秒
            mAdTimer = [NSTimer scheduledTimerWithTimeInterval:20.0 target:self selector:@selector(voicePrintHasShownHandler:) userInfo:nil repeats:NO];
            
            return;
        }
    }
    
    // 没找到相应尺寸，则直接移除
    AdwoAdRemoveETAViewFromSuperview(ADWOSDK_ETA_TYPE_VOICEPRINT);
}

#pragma mark - AWAdViewDelegate

- (UIViewController*)adwoGetBaseViewController
{
    return self;
}

- (void)adwoAdViewDidFailToLoadAd:(UIView*)adView
{
    NSLog(@"广告加载失败，由于：%@", adwoResponseErrorInfoList[AdwoAdGetLatestErrorCode()]);
}

- (void)adwoAdViewDidLoadAd:(UIView*)adView
{
    NSLog(@"Banner广告已加载");
}

- (void)adwoUserClosedBannerAd:(UIView*)adView
{
    // 移除Banner广告
    if(mCanRemoveAd)
    {
        AdwoAdRemoveAndDestroyBanner(mBannerAd);
        mBannerAd = nil;
    }
    else
        mNeedCloseBanner = YES;
}

- (void)adwoAdETAReceivedSpecifiedFeatureCode:(int)etaType
{
    // 接收到了特定的声纹特征码，尝试移除Banner后展示声纹广告
    if(mCanRemoveAd)
    {
        AdwoAdRemoveAndDestroyBanner(mBannerAd);
        mBannerAd = nil;
        
        [self showVoicePrintAd];
    }
    else
        mCanShowVoicePrint = YES;
}

- (void)adwoUserClosedETA:(int)etaType
{
    if(mAdTimer != nil)
    {
        // 停止定时器运行
        [mAdTimer invalidate];
        mAdTimer = nil;
    }
    
    if(mCanRemoveAd)
    {
        AdwoAdRemoveETAViewFromSuperview(ADWOSDK_ETA_TYPE_VOICEPRINT);
        
        // 若不是点击了关闭按钮，则再重新创建广告
        if(!mDestroyWholeAd)
            [self createAd];
    }
    else
        mNeedCloseVoicePrint = YES;
}

- (void)adwoAdRequestShouldPause:(UIView*)adView
{
    mCanRemoveAd = NO;
}

- (void)adwoAdRequestMayResume:(UIView*)adView
{
    mCanRemoveAd = YES;
    
    if(mNeedCloseBanner)
    {
        AdwoAdRemoveAndDestroyBanner(mBannerAd);
        mBannerAd = nil;
        mNeedCloseBanner = NO;
    }
    
    if(mNeedCloseVoicePrint)
    {
        AdwoAdRemoveETAViewFromSuperview(ADWOSDK_ETA_TYPE_VOICEPRINT);
        mNeedCloseVoicePrint = NO;
        
        // 若不是点击了关闭按钮，则再重新创建广告
        if(!mDestroyWholeAd)
            [self createAd];
    }
    
    if(mCanShowVoicePrint)
    {
        AdwoAdRemoveAndDestroyBanner(mBannerAd);
        mBannerAd = nil;
        
        [self showVoicePrintAd];
        
        mCanShowVoicePrint = NO;
    }
}

#pragma mark -

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end


