//
//  ViewController.h
//  AdwoSDK3.0Navigation
//
//  Created by zenny_chen on 12-10-23.
//  Copyright (c) 2012年 zenny_chen. All rights reserved.
//

#import "AdwoAdSDK.h"

#define ADWO_PUBLISH_ID_FOR_DEMO        @"ab8102cf6dfb4d99adaeeef8c038971f"

@class MyViewController1;

@interface ViewController : UIViewController
{
    UINavigationController *naviController;
    MyViewController1 *controller1;
    UIViewController *mCurrentShowAdViewController;
    UIView *mFSAd;
    
    UIView *mAdView;                    // 广告对象句柄
    UIViewController<AWAdViewDelegate> *mCurrDelegate;
    BOOL mCanBeRefreshed;               // 是否可以刷新Banner的标识
    BOOL mCanShowFSAd;
}

// Banner相关接口
- (void)createBanner:(UIViewController<AWAdViewDelegate>*)delegate;
- (void)destroyBanner;

// 全屏广告相关接口
- (void)loadFSAd:(UIViewController*)viewController;
- (void)clearShowAdViewController;

@end

