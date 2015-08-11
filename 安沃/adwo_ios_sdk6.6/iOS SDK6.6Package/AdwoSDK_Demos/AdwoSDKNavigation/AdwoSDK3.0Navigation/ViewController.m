//
//  ViewController.m
//  AdwoSDK3.0Navigation
//
//  Created by zenny_chen on 12-10-23.
//  Copyright (c) 2012年 zenny_chen. All rights reserved.
//

#import "ViewController.h"
#import "MyViewController1.h"

@interface ViewController ()<AWAdViewDelegate>

@end

@implementation ViewController


- (void)createBanner:(UIViewController<AWAdViewDelegate>*)delegate
{
    mCanBeRefreshed = YES;          // 初始状态，可以Banner可以被刷新
    mCurrDelegate = delegate;
    if(mAdView != nil)
        return;
    
    mAdView = AdwoAdCreateBanner(ADWO_PUBLISH_ID_FOR_DEMO, YES, delegate);
    if(mAdView == nil)
    {
        NSLog(@"Banner对象创建失败");
        return;
    }
    
    // 给banner视图指定展示位置
    mAdView.frame = CGRectMake(0.0f, 200.0f, 0.0f, 0.0f);
    
    // 将Banner加载到指定的视图控制器上
    AdwoAdAddBannerToSuperView(mAdView, delegate.view);
    
    // 加载Banner广告
    AdwoAdLoadBannerAd(mAdView, ADWO_ADSDK_BANNER_SIZE_NORMAL_BANNER, NULL);
}

- (void)destroyBanner
{
    mCurrDelegate = nil;
    
    if(mAdView != nil)
    {
        AdwoAdRemoveAndDestroyBanner(mAdView);
        mAdView = nil;
    }
}

- (void)loadFSAd:(UIViewController*)viewController
{
    // 设置当前广告代理所需要的视图控制器
    mCurrentShowAdViewController = viewController;
    if(mFSAd != nil)
    {
        // 若当前全屏广告对象不空，则判断是否已经可以直接展示，若能直接展示，则展示之
        if(mCanShowFSAd && mCurrentShowAdViewController != nil)
        {
            AdwoAdShowFullScreenAd(mFSAd);
        }
    }
    else
    {
        // 当前全屏广告对象未初始化，则获得它
        mFSAd = AdwoAdGetFullScreenAdHandle(ADWO_PUBLISH_ID_FOR_DEMO, YES, self, ADWOSDK_FSAD_SHOW_FORM_APPFUN_WITH_BRAND);
        if(mFSAd == nil)
            return;
        
        // 尝试加载全屏广告对象
        if(!AdwoAdLoadFullScreenAd(mFSAd, YES, NULL))
            mFSAd = nil;        // 若加载失败，SDK会自动销毁全屏广告对象，此时必须将全屏广告对象引用置空
    }
}

- (void)clearShowAdViewController
{
    mCurrentShowAdViewController = nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    controller1 = [[MyViewController1 alloc] init];
    
    naviController = [[UINavigationController alloc] initWithRootViewController:controller1];
    naviController.navigationBarHidden = YES;
    [self.view addSubview:naviController.view];
    
    [controller1 setupBanner:self];
}

#pragma mark - Adwo ad delegates

- (UIViewController*)adwoGetBaseViewController
{
    // 返回当前正展示的视图控制器对象
    return mCurrentShowAdViewController;
}

- (void)adwoAdViewDidFailToLoadAd:(UIView*)adView
{
    // 若加载失败，则SDK将会自动销毁全屏广告对象，此时必须把全屏广告对象引用置空
    mFSAd = nil;
    mCanShowFSAd = NO;
}

- (void)adwoAdViewDidLoadAd:(UIView*)adView
{
    // 全屏广告可以被展示
    mCanShowFSAd = YES;
    
    if(mCurrentShowAdViewController != nil && adView == mAdView)
    {
        AdwoAdShowFullScreenAd(mFSAd);
    }
}

- (void)adwoFullScreenAdDismissed:(UIView*)adView
{
    // 若全屏广告被用户关闭，则SDK将会自动销毁全屏广告对象，此时必须把全屏广告对象引用置空
    mFSAd = nil;
    mCanShowFSAd = NO;
}

#pragma mark -

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end


